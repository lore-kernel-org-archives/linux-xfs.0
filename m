Return-Path: <SRS0=yuEF=YW=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75D6FCA9EB9
	for <linux-xfs@archiver.kernel.org>; Tue, 29 Oct 2019 04:19:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 38CE72086A
	for <linux-xfs@archiver.kernel.org>; Tue, 29 Oct 2019 04:19:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="IcTH6Qdr"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730480AbfJ2ETZ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 29 Oct 2019 00:19:25 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:57522 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727608AbfJ2ETY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 29 Oct 2019 00:19:24 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9T4JLEM003015;
        Tue, 29 Oct 2019 04:19:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=pRyHZviNz1P360ZPDGyg4+pKKYLYpOdHNXffbVPWZA4=;
 b=IcTH6QdrmzW3JkJFqyokfH6XdcXN1/EH+x35guGcfBhxJWRksoeB5eTSCBZpuyKQMxGl
 qqDDGIl1npGcx0vslF/G/IvSrEjhduYvSdFQ0OP68DLOG3PCxsBwzZKFzqIp9KVm8YRm
 L5p+4vdpX7LmQ72WmWd+Imj7XkzwZvV3C4yFRVzohysHPNfvMjf6VVHGZtabAEhTVsJT
 ZOb5DKfa7J4fbFgdIJteVS1BISz43691owdLz9i2KRQtqwhfO4EtC2GFPVdwQZhMyGj4
 XPd22UgCyv4VNNDh+LH+1obJkaOOH/TMsF9TOQED4UHwl/N4AEy8bxVVEWrwzkVGXft4 Cw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 2vvumfb31y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 29 Oct 2019 04:19:16 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9T4IETL010955;
        Tue, 29 Oct 2019 04:19:15 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 2vwam078wq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 29 Oct 2019 04:19:15 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x9T4JB0r007728;
        Tue, 29 Oct 2019 04:19:12 GMT
Received: from localhost (/10.159.156.71)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 28 Oct 2019 21:19:11 -0700
Date:   Mon, 28 Oct 2019 21:19:08 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: properly serialise fallocate against AIO+DIO
Message-ID: <20191029041908.GB15222@magnolia>
References: <20191029034850.8212-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191029034850.8212-1-david@fromorbit.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9424 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1910290045
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9424 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1910290045
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Oct 29, 2019 at 02:48:50PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> AIO+DIO can extend the file size on IO completion, and it holds
> no inode locks while the IO is in flight. Therefore, a race
> condition exists in file size updates if we do something like this:
> 
> aio-thread			fallocate-thread
> 
> lock inode
> submit IO beyond inode->i_size
> unlock inode
> .....
> 				lock inode
> 				break layouts
> 				if (off + len > inode->i_size)
> 					new_size = off + len
> 				.....
> 				inode_dio_wait()
> 				<blocks>
> .....
> completes
> inode->i_size updated
> inode_dio_done()
> ....
> 				<wakes>
> 				<does stuff no long beyond EOF>
> 				if (new_size)
> 					xfs_vn_setattr(inode, new_size)
> 
> 
> Yup, that attempt to extend the file size in the fallocate code
> turns into a truncate - it removes the whatever the aio write
> allocated and put to disk, and reduced the inode size back down to
> where the fallocate operation ends.
> 
> Fundamentally, xfs_file_fallocate()  not compatible with racing
> AIO+DIO completions, so we need to move the inode_dio_wait() call
> up to where the lock the inode and break the layouts.
> 
> Secondly, storing the inode size and then using it unchecked without
> holding the ILOCK is not safe; we can only do such a thing if we've
> locked out and drained all IO and other modification operations,
> which we don't do initially in xfs_file_fallocate.
> 
> It should be noted that some of the fallocate operations are
> compound operations - they are made up of multiple manipulations
> that may zero data, and so we may need to flush and invalidate the
> file multiple times during an operation. However, we only need to
> lock out IO and other space manipulation operations once, as that
> lockout is maintained until the entire fallocate operation has been
> completed.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/xfs_bmap_util.c |  8 +-------
>  fs/xfs/xfs_file.c      | 30 ++++++++++++++++++++++++++++++
>  fs/xfs/xfs_ioctl.c     |  1 +
>  3 files changed, 32 insertions(+), 7 deletions(-)
> 
> diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
> index fb31d7d6701e..dea68308fb64 100644
> --- a/fs/xfs/xfs_bmap_util.c
> +++ b/fs/xfs/xfs_bmap_util.c
> @@ -1040,6 +1040,7 @@ xfs_unmap_extent(
>  	goto out_unlock;
>  }
>  
> +/* Caller must first wait for the completion of any pending DIOs if required. */
>  int
>  xfs_flush_unmap_range(
>  	struct xfs_inode	*ip,
> @@ -1051,9 +1052,6 @@ xfs_flush_unmap_range(
>  	xfs_off_t		rounding, start, end;
>  	int			error;
>  
> -	/* wait for the completion of any pending DIOs */
> -	inode_dio_wait(inode);

Does xfs_reflink_remap_prep still need this function to call inode_dio_wait
before zapping the page cache prior to reflinking into an existing file?

> -
>  	rounding = max_t(xfs_off_t, 1 << mp->m_sb.sb_blocklog, PAGE_SIZE);
>  	start = round_down(offset, rounding);
>  	end = round_up(offset + len, rounding) - 1;
> @@ -1085,10 +1083,6 @@ xfs_free_file_space(
>  	if (len <= 0)	/* if nothing being freed */
>  		return 0;
>  
> -	error = xfs_flush_unmap_range(ip, offset, len);
> -	if (error)
> -		return error;
> -
>  	startoffset_fsb = XFS_B_TO_FSB(mp, offset);
>  	endoffset_fsb = XFS_B_TO_FSBT(mp, offset + len);
>  
> diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> index 525b29b99116..865543e41fb4 100644
> --- a/fs/xfs/xfs_file.c
> +++ b/fs/xfs/xfs_file.c
> @@ -817,6 +817,36 @@ xfs_file_fallocate(
>  	if (error)
>  		goto out_unlock;
>  
> +	/*
> +	 * Must wait for all AIO to complete before we continue as AIO can
> +	 * change the file size on completion without holding any locks we
> +	 * currently hold. We must do this first because AIO can update both
> +	 * the on disk and in memory inode sizes, and the operations that follow
> +	 * require the in-memory size to be fully up-to-date.
> +	 */
> +	inode_dio_wait(inode);
> +
> +	/*
> +	 * Now AIO and DIO has drained we flush and (if necessary) invalidate
> +	 * the cached range over the first operation we are about to run.
> +	 *
> +	 * We care about zero and collapse here because they both run a hole
> +	 * punch over the range first. Because that can zero data, and the range
> +	 * of invalidation for the shift operations is much larger, we still do
> +	 * the required flush for collapse in xfs_prepare_shift().
> +	 *
> +	 * Insert has the same range requirements as collapse, and we extend the
> +	 * file first which can zero data. Hence insert has the same
> +	 * flush/invalidate requirements as collapse and so they are both
> +	 * handled at the right time by xfs_prepare_shift().
> +	 */
> +	if (mode & (FALLOC_FL_PUNCH_HOLE | FALLOC_FL_ZERO_RANGE |
> +		    FALLOC_FL_COLLAPSE_RANGE)) {

Er... "Insert has the same requirements as collapse", but we don't test
for that here?  Also ... xfs_prepare_shift handles flushing for both
collapse and insert range, but we still have to flush here for collapse?

<confused but suspecting this has something to do with the fact that we
only do insert range after updating the isize?>

I think the third paragraph of the comment is just confusing me more.
Does the following describe what's going on?

"Insert range has the same range [should this be "page cache flushing"?]
requirements as collapse.  Because we can zero data as part of extending
the file size, we skip the flush here and let the flush in
xfs_prepare_shift take care of invalidating the page cache." ?

--D

> +		error = xfs_flush_unmap_range(ip, offset, len);
> +		if (error)
> +			goto out_unlock;
> +	}
> +
>  	if (mode & FALLOC_FL_PUNCH_HOLE) {
>  		error = xfs_free_file_space(ip, offset, len);
>  		if (error)
> diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
> index 287f83eb791f..800f07044636 100644
> --- a/fs/xfs/xfs_ioctl.c
> +++ b/fs/xfs/xfs_ioctl.c
> @@ -623,6 +623,7 @@ xfs_ioc_space(
>  	error = xfs_break_layouts(inode, &iolock, BREAK_UNMAP);
>  	if (error)
>  		goto out_unlock;
> +	inode_dio_wait(inode);
>  
>  	switch (bf->l_whence) {
>  	case 0: /*SEEK_SET*/
> -- 
> 2.24.0.rc0
> 
