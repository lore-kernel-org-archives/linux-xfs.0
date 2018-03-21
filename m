Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:58686 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751671AbeCUQRw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 21 Mar 2018 12:17:52 -0400
Date: Wed, 21 Mar 2018 09:17:45 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH v2] xfs: test agfl reset on bad list wrapping
Message-ID: <20180321161745.GB4810@magnolia>
References: <20180321031746.GF4866@magnolia>
 <20180321144532.GU30836@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180321144532.GU30836@localhost.localdomain>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eryu Guan <guaneryu@gmail.com>
Cc: Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org, david@fromorbit.com, fstests <fstests@vger.kernel.org>

On Wed, Mar 21, 2018 at 10:45:32PM +0800, Eryu Guan wrote:
> On Tue, Mar 20, 2018 at 08:17:46PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > From the kernel patch that this test examines ("xfs: detect agfl count
> > corruption and reset agfl"):
> > 
> > "The struct xfs_agfl v5 header was originally introduced with
> > unexpected padding that caused the AGFL to operate with one less
> > slot than intended. The header has since been packed, but the fix
> > left an incompatibility for users who upgrade from an old kernel
> > with the unpacked header to a newer kernel with the packed header
> > while the AGFL happens to wrap around the end. The newer kernel
> > recognizes one extra slot at the physical end of the AGFL that the
> > previous kernel did not. The new kernel will eventually attempt to
> > allocate a block from that slot, which contains invalid data, and
> > cause a crash.
> > 
> > "This condition can be detected by comparing the active range of the
> > AGFL to the count. While this detects a padding mismatch, it can
> > also trigger false positives for unrelated flcount corruption. Since
> > we cannot distinguish a size mismatch due to padding from unrelated
> > corruption, we can't trust the AGFL enough to simply repopulate the
> > empty slot.
> > 
> > "Instead, avoid unnecessarily complex detection logic and and use a
> > solution that can handle any form of flcount corruption that slips
> > through read verifiers: distrust the entire AGFL and reset it to an
> > empty state. Any valid blocks within the AGFL are intentionally
> > leaked. This requires xfs_repair to rectify (which was already
> > necessary based on the state the AGFL was found in). The reset
> > mitigates the side effect of the padding mismatch problem from a
> > filesystem crash to a free space accounting inconsistency."
> > 
> > This test exercises the reset code by mutating a fresh filesystem to
> > contain an agfl with various list configurations of correctly wrapped,
> > incorrectly wrapped, not wrapped, and actually corrupt free lists; then
> > checks the success of the reset operation by fragmenting the free space
> > btrees to exercise the agfl.  Kernels without this reset fix will shut
> > down the filesystem with corruption errors.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  common/rc         |    6 +
> >  tests/xfs/709     |  254 +++++++++++++++++++++++++++++++++++++++++++++++++++++
> >  tests/xfs/709.out |   13 +++
> >  tests/xfs/group   |    1 
> >  4 files changed, 274 insertions(+)
> >  create mode 100755 tests/xfs/709
> >  create mode 100644 tests/xfs/709.out
> > 
> > diff --git a/common/rc b/common/rc
> > index 2c29d55..8f048f1 100644
> > --- a/common/rc
> > +++ b/common/rc
> > @@ -3440,6 +3440,12 @@ _get_device_size()
> >  	grep `_short_dev $1` /proc/partitions | awk '{print $3}'
> >  }
> >  
> > +# check dmesg log for a specific string
> > +_check_dmesg_for() {
> > +	dmesg | tac | sed -ne "0,\#run fstests $seqnum at $date_time#p" | \
> > +		tac | egrep -q "$1"
> 
> Hmm, searching dmesg log for a specific test this way requires a
> writable /dev/kmsg, we have checked it in 'check', otherwise we won't
> write such logs to dmesg. Need a _require_check_dmesg or something?
> 
> And it seems this "dmesg | tac ... | tac" sequence can be factored out
> to a helper and reused in _check_dmesg too.

Ok.

--D

> Thanks,
> Eryu
> --
> To unsubscribe from this list: send the line "unsubscribe fstests" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
