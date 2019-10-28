Return-Path: <SRS0=q11v=YV=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C7BBCA9EC1
	for <linux-xfs@archiver.kernel.org>; Mon, 28 Oct 2019 16:27:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6732A21783
	for <linux-xfs@archiver.kernel.org>; Mon, 28 Oct 2019 16:27:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ZcefSEUY"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390942AbfJ1Q1h (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 28 Oct 2019 12:27:37 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:32964 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732424AbfJ1Q1g (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 28 Oct 2019 12:27:36 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9SGH1UK050232;
        Mon, 28 Oct 2019 16:27:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=XoyzMpuRS/Pfw5o9fSM5JZoQzAzSTTzMWJKFog5OKiU=;
 b=ZcefSEUYx+nNExPsaKAGoRp5VcN51ml38FzrFtxqsMlXy0kgbkoBuRoQraV9YFflildM
 B9kDTJVVSHsOgZJTnLlkOQp+BG0BTg4CIFu+TBWx9HvvLdp5/EGMbqmVQsWeQuN6VVr9
 ARSth1FVDnYwGdPHVTjDz+6LYc9Xa66/iGLXk99u1d56m+TkLBHznP7P7fKQIKPNOgzF
 5qRAmdwfslXJB9pxWhbFDTpXsJNjeVEWMdUrxPHbx+HMFqkTiPbJvqv91f+AOcq0/j1O
 jVFAQlxqlI7DyrtUeXhMQ3ViG/0QXNH1fo3zxsMzeRdbSAescTxik2DJC1I/mjKIa71X bg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 2vvdju39k8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 28 Oct 2019 16:27:32 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9SGFZxo112519;
        Mon, 28 Oct 2019 16:25:31 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 2vwaky9djp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 28 Oct 2019 16:25:31 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x9SGPUb5009649;
        Mon, 28 Oct 2019 16:25:31 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 28 Oct 2019 09:25:30 -0700
Date:   Mon, 28 Oct 2019 09:25:29 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 5/8] xfs: simplify the xfs_iomap_write_direct calling
 conventions
Message-ID: <20191028162529.GE15222@magnolia>
References: <20191025150336.19411-1-hch@lst.de>
 <20191025150336.19411-6-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191025150336.19411-6-hch@lst.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9424 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1910280161
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9424 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1910280161
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Oct 25, 2019 at 05:03:33PM +0200, Christoph Hellwig wrote:
> Move the EOF alignment and checking for the next allocated extent into
> the callers to avoid the need to pass the byte based offset and count
> as well as looking at the incoming imap.  The added benefit is that
> the caller can unlock the incoming ilock and the function doesn't have
> funny unbalanced locking contexts.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks ok, though it took me a while to figure out the old unlocking
strategy well enough to compare it to the new one. :)

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/xfs_iomap.c | 82 ++++++++++++++++------------------------------
>  fs/xfs/xfs_iomap.h |  6 ++--
>  fs/xfs/xfs_pnfs.c  | 25 +++++++-------
>  3 files changed, 45 insertions(+), 68 deletions(-)
> 
> diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
> index e3b11cda447e..4af50b101d2b 100644
> --- a/fs/xfs/xfs_iomap.c
> +++ b/fs/xfs/xfs_iomap.c
> @@ -148,7 +148,7 @@ xfs_eof_alignment(
>   * Check if last_fsb is outside the last extent, and if so grow it to the next
>   * stripe unit boundary.
>   */
> -static xfs_fileoff_t
> +xfs_fileoff_t
>  xfs_iomap_eof_align_last_fsb(
>  	struct xfs_inode	*ip,
>  	xfs_fileoff_t		end_fsb)
> @@ -185,61 +185,36 @@ xfs_iomap_eof_align_last_fsb(
>  
>  int
>  xfs_iomap_write_direct(
> -	xfs_inode_t	*ip,
> -	xfs_off_t	offset,
> -	size_t		count,
> -	xfs_bmbt_irec_t *imap,
> -	int		nmaps)
> +	struct xfs_inode	*ip,
> +	xfs_fileoff_t		offset_fsb,
> +	xfs_fileoff_t		count_fsb,
> +	struct xfs_bmbt_irec	*imap)
>  {
> -	xfs_mount_t	*mp = ip->i_mount;
> -	xfs_fileoff_t	offset_fsb = XFS_B_TO_FSBT(mp, offset);
> -	xfs_fileoff_t	last_fsb = xfs_iomap_end_fsb(mp, offset, count);
> -	xfs_filblks_t	count_fsb, resaligned;
> -	xfs_extlen_t	extsz;
> -	int		nimaps;
> -	int		quota_flag;
> -	int		rt;
> -	xfs_trans_t	*tp;
> -	uint		qblocks, resblks, resrtextents;
> -	int		error;
> -	int		lockmode;
> -	int		bmapi_flags = XFS_BMAPI_PREALLOC;
> -	uint		tflags = 0;
> -
> -	rt = XFS_IS_REALTIME_INODE(ip);
> -	extsz = xfs_get_extsz_hint(ip);
> -	lockmode = XFS_ILOCK_SHARED;	/* locked by caller */
> -
> -	ASSERT(xfs_isilocked(ip, lockmode));
> +	struct xfs_mount	*mp = ip->i_mount;
> +	struct xfs_trans	*tp;
> +	xfs_filblks_t		resaligned;
> +	int			nimaps;
> +	int			quota_flag;
> +	uint			qblocks, resblks;
> +	unsigned int		resrtextents = 0;
> +	int			error;
> +	int			bmapi_flags = XFS_BMAPI_PREALLOC;
> +	uint			tflags = 0;
>  
> -	if (offset + count > XFS_ISIZE(ip)) {
> -		last_fsb = xfs_iomap_eof_align_last_fsb(ip, last_fsb);
> -	} else {
> -		if (nmaps && (imap->br_startblock == HOLESTARTBLOCK))
> -			last_fsb = min(last_fsb, (xfs_fileoff_t)
> -					imap->br_blockcount +
> -					imap->br_startoff);
> -	}
> -	count_fsb = last_fsb - offset_fsb;
>  	ASSERT(count_fsb > 0);
> -	resaligned = xfs_aligned_fsb_count(offset_fsb, count_fsb, extsz);
>  
> -	if (unlikely(rt)) {
> +	resaligned = xfs_aligned_fsb_count(offset_fsb, count_fsb,
> +					   xfs_get_extsz_hint(ip));
> +	if (unlikely(XFS_IS_REALTIME_INODE(ip))) {
>  		resrtextents = qblocks = resaligned;
>  		resrtextents /= mp->m_sb.sb_rextsize;
>  		resblks = XFS_DIOSTRAT_SPACE_RES(mp, 0);
>  		quota_flag = XFS_QMOPT_RES_RTBLKS;
>  	} else {
> -		resrtextents = 0;
>  		resblks = qblocks = XFS_DIOSTRAT_SPACE_RES(mp, resaligned);
>  		quota_flag = XFS_QMOPT_RES_REGBLKS;
>  	}
>  
> -	/*
> -	 * Drop the shared lock acquired by the caller, attach the dquot if
> -	 * necessary and move on to transaction setup.
> -	 */
> -	xfs_iunlock(ip, lockmode);
>  	error = xfs_qm_dqattach(ip);
>  	if (error)
>  		return error;
> @@ -269,8 +244,7 @@ xfs_iomap_write_direct(
>  	if (error)
>  		return error;
>  
> -	lockmode = XFS_ILOCK_EXCL;
> -	xfs_ilock(ip, lockmode);
> +	xfs_ilock(ip, XFS_ILOCK_EXCL);
>  
>  	error = xfs_trans_reserve_quota_nblks(tp, ip, qblocks, 0, quota_flag);
>  	if (error)
> @@ -307,7 +281,7 @@ xfs_iomap_write_direct(
>  		error = xfs_alert_fsblock_zero(ip, imap);
>  
>  out_unlock:
> -	xfs_iunlock(ip, lockmode);
> +	xfs_iunlock(ip, XFS_ILOCK_EXCL);
>  	return error;
>  
>  out_res_cancel:
> @@ -807,14 +781,16 @@ xfs_direct_write_iomap_begin(
>  	 * lower level functions are updated.
>  	 */
>  	length = min_t(loff_t, length, 1024 * PAGE_SIZE);
> +	end_fsb = xfs_iomap_end_fsb(mp, offset, length);
>  
> -	/*
> -	 * xfs_iomap_write_direct() expects the shared lock. It is unlocked on
> -	 * return.
> -	 */
> -	if (lockmode == XFS_ILOCK_EXCL)
> -		xfs_ilock_demote(ip, lockmode);
> -	error = xfs_iomap_write_direct(ip, offset, length, &imap, nimaps);
> +	if (offset + length > XFS_ISIZE(ip))
> +		end_fsb = xfs_iomap_eof_align_last_fsb(ip, end_fsb);
> +	else if (nimaps && imap.br_startblock == HOLESTARTBLOCK)
> +		end_fsb = min(end_fsb, imap.br_startoff + imap.br_blockcount);
> +	xfs_iunlock(ip, lockmode);
> +
> +	error = xfs_iomap_write_direct(ip, offset_fsb, end_fsb - offset_fsb,
> +			&imap);
>  	if (error)
>  		return error;
>  
> diff --git a/fs/xfs/xfs_iomap.h b/fs/xfs/xfs_iomap.h
> index d5b292bdaf82..7d3703556d0e 100644
> --- a/fs/xfs/xfs_iomap.h
> +++ b/fs/xfs/xfs_iomap.h
> @@ -11,9 +11,11 @@
>  struct xfs_inode;
>  struct xfs_bmbt_irec;
>  
> -int xfs_iomap_write_direct(struct xfs_inode *, xfs_off_t, size_t,
> -			struct xfs_bmbt_irec *, int);
> +int xfs_iomap_write_direct(struct xfs_inode *ip, xfs_fileoff_t offset_fsb,
> +		xfs_fileoff_t count_fsb, struct xfs_bmbt_irec *imap);
>  int xfs_iomap_write_unwritten(struct xfs_inode *, xfs_off_t, xfs_off_t, bool);
> +xfs_fileoff_t xfs_iomap_eof_align_last_fsb(struct xfs_inode *ip,
> +		xfs_fileoff_t end_fsb);
>  
>  int xfs_bmbt_to_iomap(struct xfs_inode *, struct iomap *,
>  		struct xfs_bmbt_irec *, u16);
> diff --git a/fs/xfs/xfs_pnfs.c b/fs/xfs/xfs_pnfs.c
> index fa90c6334c7c..f64996ca4870 100644
> --- a/fs/xfs/xfs_pnfs.c
> +++ b/fs/xfs/xfs_pnfs.c
> @@ -142,22 +142,19 @@ xfs_fs_map_blocks(
>  	lock_flags = xfs_ilock_data_map_shared(ip);
>  	error = xfs_bmapi_read(ip, offset_fsb, end_fsb - offset_fsb,
>  				&imap, &nimaps, bmapi_flags);
> -	xfs_iunlock(ip, lock_flags);
> -
> -	if (error)
> -		goto out_unlock;
> -
> -	if (write &&
> +	if (!error && write &&
>  	    (!nimaps || imap.br_startblock == HOLESTARTBLOCK)) {
>  		ASSERT(imap.br_startblock != DELAYSTARTBLOCK);
>  
> -		/*
> -		 * xfs_iomap_write_direct() expects to take ownership of the
> -		 * shared ilock.
> -		 */
> -		xfs_ilock(ip, XFS_ILOCK_SHARED);
> -		error = xfs_iomap_write_direct(ip, offset, length, &imap,
> -					       nimaps);
> +		if (offset + length > XFS_ISIZE(ip))
> +			end_fsb = xfs_iomap_eof_align_last_fsb(ip, end_fsb);
> +		else if (nimaps && imap.br_startblock == HOLESTARTBLOCK)
> +			end_fsb = min(end_fsb, imap.br_startoff +
> +					       imap.br_blockcount);
> +		xfs_iunlock(ip, lock_flags);
> +
> +		error = xfs_iomap_write_direct(ip, offset_fsb,
> +				end_fsb - offset_fsb, &imap);
>  		if (error)
>  			goto out_unlock;
>  
> @@ -170,6 +167,8 @@ xfs_fs_map_blocks(
>  				XFS_PREALLOC_SET | XFS_PREALLOC_SYNC);
>  		if (error)
>  			goto out_unlock;
> +	} else {
> +		xfs_iunlock(ip, lock_flags);
>  	}
>  	xfs_iunlock(ip, XFS_IOLOCK_EXCL);
>  
> -- 
> 2.20.1
> 
