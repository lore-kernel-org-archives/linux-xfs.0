Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-pg0-f66.google.com ([74.125.83.66]:44319 "EHLO
        mail-pg0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751023AbeCYGCk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 25 Mar 2018 02:02:40 -0400
Date: Sun, 25 Mar 2018 14:02:31 +0800
From: Eryu Guan <guaneryu@gmail.com>
Subject: Re: [PATCH v2] xfs: detect agfl count corruption and reset agfl
Message-ID: <20180325060231.GB30836@localhost.localdomain>
References: <20180315174539.48142-1-bfoster@redhat.com>
 <20180323051138.GY30836@localhost.localdomain>
 <20180323114622.GA20654@bfoster.bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180323114622.GA20654@bfoster.bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org, stable@vger.kernel.org, "Darrick J. Wong" <darrick.wong@oracle.com>

On Fri, Mar 23, 2018 at 07:46:22AM -0400, Brian Foster wrote:
> On Fri, Mar 23, 2018 at 01:11:38PM +0800, Eryu Guan wrote:
> > Hi Brian,
> > 
> > On Thu, Mar 15, 2018 at 01:45:39PM -0400, Brian Foster wrote:
> > > The struct xfs_agfl v5 header was originally introduced with
> > > unexpected padding that caused the AGFL to operate with one less
> > > slot than intended. The header has since been packed, but the fix
> > > left an incompatibility for users who upgrade from an old kernel
> > > with the unpacked header to a newer kernel with the packed header
> > > while the AGFL happens to wrap around the end. The newer kernel
> > > recognizes one extra slot at the physical end of the AGFL that the
> > > previous kernel did not. The new kernel will eventually attempt to
> > > allocate a block from that slot, which contains invalid data, and
> > > cause a crash.
> > > 
> > > This condition can be detected by comparing the active range of the
> > > AGFL to the count. While this detects a padding mismatch, it can
> > > also trigger false positives for unrelated flcount corruption. Since
> > > we cannot distinguish a size mismatch due to padding from unrelated
> > > corruption, we can't trust the AGFL enough to simply repopulate the
> > > empty slot.
> > > 
> > > Instead, avoid unnecessarily complex detection logic and and use a
> > > solution that can handle any form of flcount corruption that slips
> > > through read verifiers: distrust the entire AGFL and reset it to an
> > > empty state. Any valid blocks within the AGFL are intentionally
> > > leaked. This requires xfs_repair to rectify (which was already
> > > necessary based on the state the AGFL was found in). The reset
> > > mitigates the side effect of the padding mismatch problem from a
> > > filesystem crash to a free space accounting inconsistency. The
> > > generic approach also means that this patch can be safely backported
> > > to kernels with or without a packed struct xfs_agfl.
> > > 
> > > Check the AGF for an invalid freelist count on initial read from
> > > disk. If detected, set a flag on the xfs_perag to indicate that a
> > > reset is required before the AGFL can be used. In the first
> > > transaction that attempts to use a flagged AGFL, reset it to empty,
> > > warn the user about the inconsistency and allow the freelist fixup
> > > code to repopulate the AGFL with new blocks. The xfs_perag flag is
> > > cleared to eliminate the need for repeated checks on each block
> > > allocation operation.
> > > 
> > > Fixes: 96f859d52bcb ("libxfs: pack the agfl header structure so XFS_AGFL_SIZE is correct")
> > > CC: <stable@vger.kernel.org>
> > > Suggested-by: Dave Chinner <david@fromorbit.com>
> > > Signed-off-by: Brian Foster <bfoster@redhat.com>
> > > Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
> > > Reviewed-by Dave Chiluk <chiluk+linuxxfs@indeed.com>
> > > ---
> > > 
> > > v2:
> > > - Function rename and logic cleanup.
> > > - CC stable.
> > > v1: https://marc.info/?l=linux-xfs&m=152104784709048&w=2
> > > - Use a simplified AGFL reset mechanism.
> > > - Trigger on AGFL fixup rather than get/put.
> > > - Various refactors, cleanups and comments.
> > > rfc: https://marc.info/?l=linux-xfs&m=152045069616434&w=2
> > > 
> > >  fs/xfs/libxfs/xfs_alloc.c | 94 +++++++++++++++++++++++++++++++++++++++++++++++
> > >  fs/xfs/xfs_mount.h        |  1 +
> > >  fs/xfs/xfs_trace.h        |  9 ++++-
> > >  3 files changed, 103 insertions(+), 1 deletion(-)
> > > 
> > > diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
> > > index 3db90b707fb2..39387bdd225d 100644
> > > --- a/fs/xfs/libxfs/xfs_alloc.c
> > > +++ b/fs/xfs/libxfs/xfs_alloc.c
> > > @@ -2063,6 +2063,93 @@ xfs_alloc_space_available(
> > >  }
> > >  
> > >  /*
> > > + * Check the agfl fields of the agf for inconsistency or corruption. The purpose
> > > + * is to detect an agfl header padding mismatch between current and early v5
> > > + * kernels. This problem manifests as a 1-slot size difference between the
> > > + * on-disk flcount and the active [first, last] range of a wrapped agfl. This
> > > + * may also catch variants of agfl count corruption unrelated to padding. Either
> > > + * way, we'll reset the agfl and warn the user.
> > > + *
> > > + * Return true if a reset is required before the agfl can be used, false
> > > + * otherwise.
> > > + */
> > > +static bool
> > > +xfs_agfl_needs_reset(
> > > +	struct xfs_mount	*mp,
> > > +	struct xfs_agf		*agf)
> > > +{
> > > +	uint32_t		f = be32_to_cpu(agf->agf_flfirst);
> > > +	uint32_t		l = be32_to_cpu(agf->agf_fllast);
> > > +	uint32_t		c = be32_to_cpu(agf->agf_flcount);
> > > +	int			agfl_size = xfs_agfl_size(mp);
> >                                             ^^^^^^^^^^^^^
> > Should this be XFS_AGFL_SIZE(mp)? Otherwise I got compile error (based
> > on 4.15-rc5 kernel):
> > 
> 
> This patch was rebased onto for-next which now includes commit
> a78ee256c325e ("xfs: convert XFS_AGFL_SIZE to a helper function"). That
> commit refactors the macro into a helper function.

Ah, thanks! I did search the list (roughly) to see if there's any patch
introduced xfs_agfl_size but apparently missed this patch.

Thanks,
Eryu
