Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F6D8C433EF
	for <linux-xfs@archiver.kernel.org>; Mon,  7 Mar 2022 22:08:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236509AbiCGWJf (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 7 Mar 2022 17:09:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235685AbiCGWJe (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 7 Mar 2022 17:09:34 -0500
Received: from mail104.syd.optusnet.com.au (mail104.syd.optusnet.com.au [211.29.132.246])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 39BD1DF6F
        for <linux-xfs@vger.kernel.org>; Mon,  7 Mar 2022 14:08:39 -0800 (PST)
Received: from dread.disaster.area (pa49-186-17-0.pa.vic.optusnet.com.au [49.186.17.0])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 39875531299;
        Tue,  8 Mar 2022 08:41:28 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1nRL6d-002kZq-Lr; Tue, 08 Mar 2022 08:41:27 +1100
Date:   Tue, 8 Mar 2022 08:41:27 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Chandan Babu R <chandan.babu@oracle.com>
Cc:     linux-xfs@vger.kernel.org, djwong@kernel.org
Subject: Re: [PATCH V7 15/17] xfs: Enable bulkstat ioctl to support 64-bit
 per-inode extent counters
Message-ID: <20220307214127.GQ59715@dread.disaster.area>
References: <20220301103938.1106808-1-chandan.babu@oracle.com>
 <20220301103938.1106808-16-chandan.babu@oracle.com>
 <20220304080932.GK59715@dread.disaster.area>
 <87fsnwlg9a.fsf@debian-BULLSEYE-live-builder-AMD64>
 <20220307051339.GO59715@dread.disaster.area>
 <87h789swmm.fsf@debian-BULLSEYE-live-builder-AMD64>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87h789swmm.fsf@debian-BULLSEYE-live-builder-AMD64>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=VuxAv86n c=1 sm=1 tr=0 ts=62267c08
        a=+dVDrTVfsjPpH/ci3UuFng==:117 a=+dVDrTVfsjPpH/ci3UuFng==:17
        a=kj9zAlcOel0A:10 a=o8Y5sQTvuykA:10 a=NEAV23lmAAAA:8 a=7-415B0cAAAA:8
        a=yImPAJHIK8huVE7IUGUA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Mar 07, 2022 at 07:16:57PM +0530, Chandan Babu R wrote:
> On 07 Mar 2022 at 10:43, Dave Chinner wrote:
> > On Sat, Mar 05, 2022 at 06:15:37PM +0530, Chandan Babu R wrote:
> >> On 04 Mar 2022 at 13:39, Dave Chinner wrote:
> >> > On Tue, Mar 01, 2022 at 04:09:36PM +0530, Chandan Babu R wrote:
> >> >> @@ -102,7 +104,27 @@ xfs_bulkstat_one_int(
> >> >>  
> >> >>  	buf->bs_xflags = xfs_ip2xflags(ip);
> >> >>  	buf->bs_extsize_blks = ip->i_extsize;
> >> >> -	buf->bs_extents = xfs_ifork_nextents(&ip->i_df);
> >> >> +
> >> >> +	nextents = xfs_ifork_nextents(&ip->i_df);
> >> >> +	if (!(bc->breq->flags & XFS_IBULK_NREXT64)) {
> >> >> +		xfs_extnum_t	max_nextents = XFS_MAX_EXTCNT_DATA_FORK_OLD;
> >> >> +
> >> >> +		if (unlikely(XFS_TEST_ERROR(false, mp,
> >> >> +				XFS_ERRTAG_REDUCE_MAX_IEXTENTS)))
> >> >> +			max_nextents = 10;
> >> >> +
> >> >> +		if (nextents > max_nextents) {
> >> >> +			xfs_iunlock(ip, XFS_ILOCK_SHARED);
> >> >> +			xfs_irele(ip);
> >> >> +			error = -EOVERFLOW;
> >> >> +			goto out;
> >> >> +		}
> >> >
> >> > This just seems wrong. This will cause a total abort of the bulkstat
> >> > pass which will just be completely unexpected by any application
> >> > taht does not know about 64 bit extent counts. Most of them likely
> >> > don't even care about the extent count in the data being returned.
> >> >
> >> > Really, I think this should just set the extent count to the MAX
> >> > number and just continue onwards, otherwise existing application
> >> > will not be able to bulkstat a filesystem with large extents counts
> >> > in it at all.
> >> >
> >> 
> >> Actually, I don't know much about how applications use bulkstat. I am
> >> dependent on guidance from other developers who are well versed on this
> >> topic. I will change the code to return maximum extent count if the value
> >> overflows older extent count limits.
> >
> > They tend to just run in a loop until either no more inodes are to
> > be found or an error occurs. bulkstat loops don't expect errors to
> > be reported - it's hard to do something based on all inodes if you
> > get errors reading then inodes part way through. There's no way for
> > the application to tell where it should restart scanning - the
> > bulkstat iteration cookie is controlled by the kernel, and I don't
> > think we update it on error.
> 
> xfs_bulkstat() has the following,
> 
>         kmem_free(bc.buf);
> 
>         /*
>          * We found some inodes, so clear the error status and return them.
>          * The lastino pointer will point directly at the inode that triggered
>          * any error that occurred, so on the next call the error will be
>          * triggered again and propagated to userspace as there will be no
>          * formatted inodes in the buffer.
>          */
>         if (breq->ocount > 0)
>                 error = 0;
> 
>         return error;
> 
> The above will help the userspace process to issue another bulkstat call which
> beging from the inode causing an error.

ANd then it returns with a cookie pointing at the overflowed inode,
and we try that one first on the next loop, triggering -EOVERFLOW
with breq->ocount == 0.

Or maybe we have two inodes in a row that trigger EOVERFLOW, so even
if we skip the first and return to userspace, we trip the second on
the next call and boom...

> > e.g. see fstests src/bstat.c and src/bulkstat_unlink_test*.c - they
> > simply abort if bulkstat fails. Same goes for xfsdump common/util.c
> > and dump/content.c - they just error out and return and don't try to
> > continue further.
> 
> I made the following changes to src/bstat.c,
> 
> diff --git a/src/bstat.c b/src/bstat.c
> index 3f3dc2c6..0e72190e 100644
> --- a/src/bstat.c
> +++ b/src/bstat.c
> @@ -143,7 +143,19 @@ main(int argc, char **argv)
>  	bulkreq.ubuffer = t;
>  	bulkreq.ocount  = &count;
>  
> -	while ((ret = xfsctl(name, fsfd, XFS_IOC_FSBULKSTAT, &bulkreq)) == 0) {
> +	while (1) {
> +		ret = xfsctl(name, fsfd, XFS_IOC_FSBULKSTAT, &bulkreq);
> +		if (ret == -1) {
> +			if (errno == EOVERFLOW) {
> +				printf("Skipping inode %llu.\n",  last+1);
> +				++last;
> +				continue;
> +			}
> +
> +			perror("xfsctl");
> +			exit(1);
> +		}
> +
>  		total += count;
>  
> 
> Executing the script at
> https://gist.github.com/chandanr/f2d147fa20a681e1508e182b5b7cdb00 provides the
> following output,
> 
> ...
> 
> ino 128 mode 040755 nlink 3 uid 0 gid 0 rdev 0
> blksize 4096 size 37 blocks 0 xflags 0 extsize 0
> atime Thu Jan  1 00:00:00.000000000 1970
> mtime Mon Mar  7 13:06:30.051339892 2022
> ctime Mon Mar  7 13:06:30.051339892 2022
> extents 0 0 gen 0
> DMI: event mask 0x00000000 state 0x0000
> 
> Skipping inode 131.
> 
> ino 132 mode 040755 nlink 2 uid 0 gid 0 rdev 0
> blksize 4096 size 97 blocks 0 xflags 0 extsize 0
> atime Mon Mar  7 13:06:30.051339892 2022
> mtime Mon Mar  7 13:06:30.083339892 2022
> ctime Mon Mar  7 13:06:30.083339892 2022
> extents 0 0 gen 548703887
> DMI: event mask 0x00000000 state 0x0000
> 
> ...
> 
> The above illustrates that userspace programs can be modified to use lastip to
> skip inodes which cause bulkstat ioctl to return with an error.

Yes, I know they can be modified to handle it - that is not the
concern here. The concern is that this new error can potentially
break the *unmodified* applications already out there. e.g. xfsdump
may just stop dumping a filesystem half way through because it
doesn't handle unexpected errors like this sanely. But we can't tie
a version of xfsdump to a specific kernel feature, so we have to
make sure that buklstat from older builds of xfsdump will still
iterate through the entire filesystem without explicit EOVERFLOW
support...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
