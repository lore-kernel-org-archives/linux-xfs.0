Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8ACABC433F5
	for <linux-xfs@archiver.kernel.org>; Mon,  7 Mar 2022 05:13:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231577AbiCGFOh (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 7 Mar 2022 00:14:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230215AbiCGFOf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 7 Mar 2022 00:14:35 -0500
Received: from mail105.syd.optusnet.com.au (mail105.syd.optusnet.com.au [211.29.132.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 8246E31DDA
        for <linux-xfs@vger.kernel.org>; Sun,  6 Mar 2022 21:13:41 -0800 (PST)
Received: from dread.disaster.area (pa49-186-17-0.pa.vic.optusnet.com.au [49.186.17.0])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 7CBF610E15BE;
        Mon,  7 Mar 2022 16:13:40 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1nR5gh-002TiB-Hz; Mon, 07 Mar 2022 16:13:39 +1100
Date:   Mon, 7 Mar 2022 16:13:39 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Chandan Babu R <chandan.babu@oracle.com>
Cc:     linux-xfs@vger.kernel.org, djwong@kernel.org
Subject: Re: [PATCH V7 15/17] xfs: Enable bulkstat ioctl to support 64-bit
 per-inode extent counters
Message-ID: <20220307051339.GO59715@dread.disaster.area>
References: <20220301103938.1106808-1-chandan.babu@oracle.com>
 <20220301103938.1106808-16-chandan.babu@oracle.com>
 <20220304080932.GK59715@dread.disaster.area>
 <87fsnwlg9a.fsf@debian-BULLSEYE-live-builder-AMD64>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87fsnwlg9a.fsf@debian-BULLSEYE-live-builder-AMD64>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=deDjYVbe c=1 sm=1 tr=0 ts=62259484
        a=+dVDrTVfsjPpH/ci3UuFng==:117 a=+dVDrTVfsjPpH/ci3UuFng==:17
        a=kj9zAlcOel0A:10 a=o8Y5sQTvuykA:10 a=7-415B0cAAAA:8
        a=k_B6-1RhUkVrhR-ZP5EA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, Mar 05, 2022 at 06:15:37PM +0530, Chandan Babu R wrote:
> On 04 Mar 2022 at 13:39, Dave Chinner wrote:
> > On Tue, Mar 01, 2022 at 04:09:36PM +0530, Chandan Babu R wrote:
> >> @@ -102,7 +104,27 @@ xfs_bulkstat_one_int(
> >>  
> >>  	buf->bs_xflags = xfs_ip2xflags(ip);
> >>  	buf->bs_extsize_blks = ip->i_extsize;
> >> -	buf->bs_extents = xfs_ifork_nextents(&ip->i_df);
> >> +
> >> +	nextents = xfs_ifork_nextents(&ip->i_df);
> >> +	if (!(bc->breq->flags & XFS_IBULK_NREXT64)) {
> >> +		xfs_extnum_t	max_nextents = XFS_MAX_EXTCNT_DATA_FORK_OLD;
> >> +
> >> +		if (unlikely(XFS_TEST_ERROR(false, mp,
> >> +				XFS_ERRTAG_REDUCE_MAX_IEXTENTS)))
> >> +			max_nextents = 10;
> >> +
> >> +		if (nextents > max_nextents) {
> >> +			xfs_iunlock(ip, XFS_ILOCK_SHARED);
> >> +			xfs_irele(ip);
> >> +			error = -EOVERFLOW;
> >> +			goto out;
> >> +		}
> >
> > This just seems wrong. This will cause a total abort of the bulkstat
> > pass which will just be completely unexpected by any application
> > taht does not know about 64 bit extent counts. Most of them likely
> > don't even care about the extent count in the data being returned.
> >
> > Really, I think this should just set the extent count to the MAX
> > number and just continue onwards, otherwise existing application
> > will not be able to bulkstat a filesystem with large extents counts
> > in it at all.
> >
> 
> Actually, I don't know much about how applications use bulkstat. I am
> dependent on guidance from other developers who are well versed on this
> topic. I will change the code to return maximum extent count if the value
> overflows older extent count limits.

They tend to just run in a loop until either no more inodes are to
be found or an error occurs. bulkstat loops don't expect errors to
be reported - it's hard to do something based on all inodes if you
get errors reading then inodes part way through. There's no way for
the application to tell where it should restart scanning - the
bulkstat iteration cookie is controlled by the kernel, and I don't
think we update it on error.

e.g. see fstests src/bstat.c and src/bulkstat_unlink_test*.c - they
simply abort if bulkstat fails. Same goes for xfsdump common/util.c
and dump/content.c - they just error out and return and don't try to
continue further.

Hence returning -EOVERFLOW because the extent count is greater than
what can be held in the struct bstat will stop those programs from
running properly to completion.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
