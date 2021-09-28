Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9C3DC433EF
	for <linux-xfs@archiver.kernel.org>; Tue, 28 Sep 2021 23:39:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A1CB661357
	for <linux-xfs@archiver.kernel.org>; Tue, 28 Sep 2021 23:39:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243370AbhI1Xky (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 28 Sep 2021 19:40:54 -0400
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:36582 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S243314AbhI1Xky (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 28 Sep 2021 19:40:54 -0400
Received: from dread.disaster.area (pa49-195-238-16.pa.nsw.optusnet.com.au [49.195.238.16])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id F3B7710535FA;
        Wed, 29 Sep 2021 09:39:11 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1mVMgo-000GxB-Re; Wed, 29 Sep 2021 09:39:10 +1000
Date:   Wed, 29 Sep 2021 09:39:10 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Chandan Babu R <chandan.babu@oracle.com>
Cc:     linux-xfs@vger.kernel.org, djwong@kernel.org
Subject: Re: [PATCH V3 09/12] xfs: Enable bulkstat ioctl to support 64-bit
 per-inode extent counters
Message-ID: <20210928233910.GL2361455@dread.disaster.area>
References: <20210916100647.176018-1-chandan.babu@oracle.com>
 <20210916100647.176018-10-chandan.babu@oracle.com>
 <20210927230637.GL1756565@dread.disaster.area>
 <87zgrxyqqe.fsf@debian-BULLSEYE-live-builder-AMD64>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87zgrxyqqe.fsf@debian-BULLSEYE-live-builder-AMD64>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=Af7P4EfG c=1 sm=1 tr=0
        a=DzKKRZjfViQTE5W6EVc0VA==:117 a=DzKKRZjfViQTE5W6EVc0VA==:17
        a=kj9zAlcOel0A:10 a=7QKq2e-ADPsA:10 a=7-415B0cAAAA:8
        a=dxHEdJrIkcwWQ-yBpGEA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Sep 28, 2021 at 03:19:29PM +0530, Chandan Babu R wrote:
> On 28 Sep 2021 at 04:36, Dave Chinner wrote:
> > On Thu, Sep 16, 2021 at 03:36:44PM +0530, Chandan Babu R wrote:
> >> @@ -492,9 +494,16 @@ struct xfs_bulk_ireq {
> >>   */
> >>  #define XFS_BULK_IREQ_METADIR	(1 << 2)
> >>  
> >> -#define XFS_BULK_IREQ_FLAGS_ALL	(XFS_BULK_IREQ_AGNO | \
> >> +#define XFS_BULK_IREQ_BULKSTAT	(1 << 3)
> >> +
> >> +#define XFS_BULK_IREQ_FLAGS_ALL	(XFS_BULK_IREQ_AGNO |	 \
> >>  				 XFS_BULK_IREQ_SPECIAL | \
> >> -				 XFS_BULK_IREQ_METADIR)
> >> +				 XFS_BULK_IREQ_METADIR | \
> >> +				 XFS_BULK_IREQ_BULKSTAT)
> >
> > What's this XFS_BULK_IREQ_METADIR thing? I haven't noticed that when
> > scanning any recent proposed patch series....
> >
> 
> XFS_BULK_IREQ_METADIR is from Darrick's tree. His "Kill XFS_BTREE_MAXLEVELS"
> patch series is based on his other patchsets. His recent "xfs: support dynamic
> btree cursor height" patch series rebases only the required patchset on top of
> v5.15-rc1 kernel eliminating the others.

OK, so how much testing has this had on just a straight v5.15-rcX
kernel?

> >> @@ -134,7 +136,26 @@ xfs_bulkstat_one_int(
> >>  
> >>  	buf->bs_xflags = xfs_ip2xflags(ip);
> >>  	buf->bs_extsize_blks = ip->i_extsize;
> >> -	buf->bs_extents = xfs_ifork_nextents(&ip->i_df);
> >> +
> >> +	nextents = xfs_ifork_nextents(&ip->i_df);
> >> +	if (!(bc->breq->flags & XFS_IBULK_NREXT64)) {
> >> +		xfs_extnum_t max_nextents = XFS_IFORK_EXTCNT_MAXS32;
> >> +
> >> +		if (unlikely(XFS_TEST_ERROR(false, mp,
> >> +				XFS_ERRTAG_REDUCE_MAX_IEXTENTS)))
> >> +			max_nextents = 10;
> >> +
> >> +		if (nextents > max_nextents) {
> >> +			xfs_iunlock(ip, XFS_ILOCK_SHARED);
> >> +			xfs_irele(ip);
> >> +			error = -EINVAL;
> >> +			goto out_advance;
> >> +		}
> >
> > So we return an EINVAL error if any extent overflows the 32 bit
> > counter? Why isn't this -EOVERFLOW?
> >
> 
> Returning -EINVAL causes xfs_bulkstat_iwalk() to skip inodes whose extent
> count is larger than that which can be fitted into a 32-bit field. Returning
> -EOVERFLOW causes the bulkstat ioctl to stop reporting remaining inodes.

Ok, that's a bad behaviour we need to fix because it will cause
things like old versions of xfs_dump to miss inodes that
have overflowing extent counts. i.e. it will cause incomplete
backups, and the failure will likely be silent.

I asked about -EOVERFLOW because that's what stat() returns when an
inode attribute value doesn't fit in the stat_buf field (e.g. 64 bit
inode number on 32 bit kernel), and if we are overflowing the
bulkstat field then we really should be telling userspace that an
overflow occurred.

/me has a sudden realisation that the xfs_dump format may not
support large extents counts and goes looking...

Yeah, xfsdump doesn't support extent counts greater than 2^32. So
that means we really do need -EOVERFLOW errors here.  i.e, if we get
an extent count overflow with a !(bc->breq->flags &
XFS_IBULK_NREXT64) bulkstat walk, xfs_dump needs bulkstat to fill
out the inode with the overflow with all the fileds that aren't
overflowed, then error out with -EOVERFLOW.

Bulkstat itself should not silently skip the inode because it would
overflow a field in the struct xfs-bstat - the decision of what to
do with the overflow is something xfsdump needs to handle, not the
kernel.  Hence we need to return -EOVERFLOW here so that userspace
can decide what to do with an inode it can't handle...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
