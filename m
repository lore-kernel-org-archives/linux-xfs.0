Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7CD01C433EF
	for <linux-xfs@archiver.kernel.org>; Tue, 28 Sep 2021 23:08:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 62D4360EBB
	for <linux-xfs@archiver.kernel.org>; Tue, 28 Sep 2021 23:08:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243178AbhI1XKG (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 28 Sep 2021 19:10:06 -0400
Received: from mail110.syd.optusnet.com.au ([211.29.132.97]:47658 "EHLO
        mail110.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S243131AbhI1XKG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 28 Sep 2021 19:10:06 -0400
Received: from dread.disaster.area (pa49-195-238-16.pa.nsw.optusnet.com.au [49.195.238.16])
        by mail110.syd.optusnet.com.au (Postfix) with ESMTPS id 600D4107987;
        Wed, 29 Sep 2021 09:08:23 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1mVMD0-000GRo-Pp; Wed, 29 Sep 2021 09:08:22 +1000
Date:   Wed, 29 Sep 2021 09:08:22 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Chandan Babu R <chandan.babu@oracle.com>
Cc:     linux-xfs@vger.kernel.org, djwong@kernel.org
Subject: Re: [PATCH V3 08/12] xfs: Promote xfs_extnum_t and xfs_aextnum_t to
 64 and 32-bits respectively
Message-ID: <20210928230822.GK2361455@dread.disaster.area>
References: <20210916100647.176018-1-chandan.babu@oracle.com>
 <20210916100647.176018-9-chandan.babu@oracle.com>
 <20210928004707.GO1756565@dread.disaster.area>
 <874ka51168.fsf@debian-BULLSEYE-live-builder-AMD64>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <874ka51168.fsf@debian-BULLSEYE-live-builder-AMD64>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=epq8cqlX c=1 sm=1 tr=0 ts=6153a068
        a=DzKKRZjfViQTE5W6EVc0VA==:117 a=DzKKRZjfViQTE5W6EVc0VA==:17
        a=kj9zAlcOel0A:10 a=7QKq2e-ADPsA:10 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8
        a=7-415B0cAAAA:8 a=eQiATYRCL94CXckHCdYA:9 a=CjuIK1q_8ugA:10
        a=AjGcO6oz07-iQ99wixmX:22 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Sep 28, 2021 at 03:17:59PM +0530, Chandan Babu R wrote:
> On 28 Sep 2021 at 06:17, Dave Chinner wrote:
> > On Thu, Sep 16, 2021 at 03:36:43PM +0530, Chandan Babu R wrote:
> >> A future commit will introduce a 64-bit on-disk data extent counter and a
> >> 32-bit on-disk attr extent counter. This commit promotes xfs_extnum_t and
> >> xfs_aextnum_t to 64 and 32-bits in order to correctly handle in-core versions
> >> of these quantities.
> >> 
> >> Reviewed-by: Darrick J. Wong <djwong@kernel.org>
> >> Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
> >
> > So while I was auditing extent lengths w.r.t. the last patch f the
> > series, I noticed that xfs_extnum_t is used in the struct
> > xfs_log_dinode and so changing the size of these types changes the
> > layout of this structure:
> >
> > /*
> >  * Define the format of the inode core that is logged. This structure must be
> >  * kept identical to struct xfs_dinode except for the endianness annotations.
> >  */
> > struct xfs_log_dinode {
> > ....
> >         xfs_rfsblock_t  di_nblocks;     /* # of direct & btree blocks used */
> >         xfs_extlen_t    di_extsize;     /* basic/minimum extent size for file */
> >         xfs_extnum_t    di_nextents;    /* number of extents in data fork */
> >         xfs_aextnum_t   di_anextents;   /* number of extents in attribute fork*/
> > ....
> >
> > Which means this:
> >
> >> -typedef int32_t		xfs_extnum_t;	/* # of extents in a file */
> >> -typedef int16_t		xfs_aextnum_t;	/* # extents in an attribute fork */
> >> +typedef uint64_t	xfs_extnum_t;	/* # of extents in a file */
> >> +typedef uint32_t	xfs_aextnum_t;	/* # extents in an attribute fork */
> >
> > creates an incompatible log format change that will cause silent
> > inode corruption during log recovery if inodes logged with this
> > change are replayed on an older kernel without this change. It's not
> > just the type size change that matters here - it also changes the
> > implicit padding in this structure because xfs_extlen_t is a 32 bit
> > object and so:
> >
> > Old					New
> > 64 bit object (di_nblocks)		64 bit object (di_nblocks)
> > 32 bit object (di_extsize)		32 bit object (di_extsize)
> > 					32 bit pad (implicit)
> > 32 bit object (di_nextents)		64 bit object (di_nextents)
> > 16 bit object (di_anextents)		32 bit ojecct (di_anextents
> > 8 bit object (di_forkoff)		8 bit object (di_forkoff)
> > 8 bit object (di_aformat)		8 bit object (di_aformat)
> > 					16 bit pad (implicit)
> > 32 bit object (di_dmevmask)		32 bit object (di_dmevmask)
> >
> >
> > That's quite the layout change, and that's something we must not do
> > without a feature bit being set. hence I think we need to rev the
> > struct xfs_log_dinode version for large extent count support, too,
> > so that the struct xfs_log_dinode does not change size for
> > filesystems without the large extent count feature.
> 
> Actually, the current patch replaces the data types xfs_extnum_t and
> xfs_aextnum_t inside "struct xfs_log_dinode" with the basic integral types
> uint32_t and uint16_t respectively. The patch "xfs: Extend per-inode extent
> counter widths" which arrives later in the series adds the new field
> di_nextents64 to "struct xfs_log_dinode" and uint64_t is used as its data
> type.

Arggh.

Perhaps now you might see why I really don't like naming things by
size and having the contents of those fields based on context? It
is so easy to miss things like when the wrong variable or type is
used for a given context because the code itself gives you no hint
as to what the correct usage it.

I suspect part of the problem I'm had here is that the change of
the type in the xfs_log_dinode is done in a -variable rename- patch
that names variables by size, not in the patch that -actually
changes the variable size-.

IOWs, the type change in the xfs_log_dinode should
either be in this patch where the log_dinode structure shape would
change, or in it's own standalone patch with a description that says
"we need to avoid changing the on-disk structure shape".

Making sure that the on-disk format changes (or things that avoid
them!) are clear and explicit in a patchset is critical as these are
things we really need to get right.

I missed the per-inode extent size flag for a similar reason - it
was buried in a larger patch that made lots of different
modifications to support the on-disk extent count format change, so
it wasn't clearly defined/called out as a separate on-disk format
change necessary for correct functioning.

> So in a scenario where we have a filesystem which does not have support for
> 64-bit extent counters and a kernel which does not support 64-bit extent
> counters is replaying a log created by a kernel supporting 64-bit extent
> counters, the contents of the 16-bit and 32-bit extent counter fields should
> be replayed correctly into xfs_inode's attr and data fork extent counters
> respectively. The contents of the 64-bit extent counter (whose value will be
> zero) in the logged inode will be replayed back into di_pad2[] field of the
> inode.

I think that's correct, because the superblock bit will prevent
mount on old kernels that don't support the 64 bit extent counter
and so the zeroes in di_pad2 won't get overwritten incorrectly.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
