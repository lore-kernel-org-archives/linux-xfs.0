Return-Path: <SRS0=yuEF=YW=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D98BCCA9EAE
	for <linux-xfs@archiver.kernel.org>; Tue, 29 Oct 2019 23:33:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A0D4E20659
	for <linux-xfs@archiver.kernel.org>; Tue, 29 Oct 2019 23:33:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="q54RCWjZ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726271AbfJ2Xdn (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 29 Oct 2019 19:33:43 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:53888 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725974AbfJ2Xdn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 29 Oct 2019 19:33:43 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9TNXeBT020517;
        Tue, 29 Oct 2019 23:33:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=SVLTlTzMY3Sf3vzFpevoiOvvBFqEzAUib8r+x5vqP3g=;
 b=q54RCWjZbUh5JD+iXw61CpLYE9INPovZuo5MrzwpHdWiSVz+Fx3zMHHtfGdYFoU4Zy70
 KGPpDEsTr3Vkqn5zXTKOixK/4wQmIoXGq6YTCtCkFb+JZwOZs6IA7LpdZKg98cvBK0JP
 A0iv736+2Ulecx+CaSghaOtL7zcrZfyQoArPpIqvN4P7hv+qhbSz7FhfdFYS3Q8hcQu/
 Q3Jf9s/1EpvqowiCt8XRDCjTzKM25arVuQSyc7w0Hmvnds4ZAJq88GApEA6ESsBYDbi/
 KUMPRPP/xp5J9kMt9m9w8nhWG7kBeKyW8xp1tnD+6lDhDlaxx3jsJy8HYFK+aM/zu4A9 lQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 2vxwhf8b99-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 29 Oct 2019 23:33:39 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9TNXLbT193875;
        Tue, 29 Oct 2019 23:33:39 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 2vxwj84cec-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 29 Oct 2019 23:33:39 +0000
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x9TNXcx3007944;
        Tue, 29 Oct 2019 23:33:38 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 29 Oct 2019 16:33:38 -0700
Date:   Tue, 29 Oct 2019 16:33:37 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH V2] xfs: properly serialise fallocate against AIO+DIO
Message-ID: <20191029233337.GH15222@magnolia>
References: <20191029223752.28562-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191029223752.28562-1-david@fromorbit.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9425 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1910290207
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9425 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1910290207
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Oct 30, 2019 at 09:37:52AM +1100, Dave Chinner wrote:
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

Looks reasonable to me; what do you think of my regression test?

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/xfs_bmap_util.c |  8 +-------
>  fs/xfs/xfs_file.c      | 23 +++++++++++++++++++++++
>  fs/xfs/xfs_ioctl.c     |  1 +
>  3 files changed, 25 insertions(+), 7 deletions(-)
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
> index 525b29b99116..46fc5629369b 100644
> --- a/fs/xfs/xfs_file.c
> +++ b/fs/xfs/xfs_file.c
> @@ -817,6 +817,29 @@ xfs_file_fallocate(
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
> +	 * Now that AIO and DIO has drained we can flush and (if necessary)
> +	 * invalidate the cached range over the first operation we are about to
> +	 * run. We include zero and collapse here because they both start with a
> +	 * hole punch over the target range. Insert and collapse both invalidate
> +	 * the broader range affected by the shift in xfs_prepare_shift().
> +	 */
> +	if (mode & (FALLOC_FL_PUNCH_HOLE | FALLOC_FL_ZERO_RANGE |
> +		    FALLOC_FL_COLLAPSE_RANGE)) {
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
