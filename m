Return-Path: <SRS0=FK3z=6C=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E3DEC2BB1D
	for <linux-xfs@archiver.kernel.org>; Sat, 18 Apr 2020 00:09:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 03AA922243
	for <linux-xfs@archiver.kernel.org>; Sat, 18 Apr 2020 00:09:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="b0MNNWYf"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726121AbgDRAJd (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 17 Apr 2020 20:09:33 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:52572 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725985AbgDRAJd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 17 Apr 2020 20:09:33 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03I047xP143777;
        Sat, 18 Apr 2020 00:09:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=jmm02O3HKCEKdBcukze3i6lFXDhRnVevOXKA4aZqTzo=;
 b=b0MNNWYf+voJ/h2cPSiAn61qKmNrNmcjP2QvBtolNCZ3/KijkhufHKVt7VKTVNum808a
 3HbQT6Ir0cwy9P/BLEIn0Ka+cJYlE9JjUTGWB1QfIfTuzyAftTmxQvRZuekjnbJ02KPq
 3LFonE4dTMhuvlYn/elIyTrzCXevB7helK4DdjVpeOH7al7pQUckUyuK+xbAyISnYez1
 f4/PYGQAq74WTcBVuaoWjZQzTyFbS09++Ej4FlEtOVyMV9MrfckNlKJH4mQsNr9RQvBW
 /+NJb0k7Z4VdyIEXV7EjON6Z1qOgCHJJ0KAIXu/MBXCEGKWpSgyAXHBFkapbjKNIgMKd zg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 30emejskbd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 18 Apr 2020 00:09:29 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03I07SSn031730;
        Sat, 18 Apr 2020 00:07:29 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 30dn92ent8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 18 Apr 2020 00:07:28 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 03I07H8J024651;
        Sat, 18 Apr 2020 00:07:17 GMT
Received: from [192.168.1.223] (/67.1.142.158)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 17 Apr 2020 17:07:17 -0700
Subject: Re: [PATCH 03/12] xfs: always attach iflush_done and simplify error
 handling
To:     Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org
References: <20200417150859.14734-1-bfoster@redhat.com>
 <20200417150859.14734-4-bfoster@redhat.com>
From:   Allison Collins <allison.henderson@oracle.com>
Message-ID: <b462a393-9c23-ea16-b027-4cee13586471@oracle.com>
Date:   Fri, 17 Apr 2020 17:07:16 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20200417150859.14734-4-bfoster@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9594 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=999
 suspectscore=2 malwarescore=0 spamscore=0 phishscore=0 adultscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004170174
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9594 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 impostorscore=0
 mlxscore=0 suspectscore=2 lowpriorityscore=0 spamscore=0 mlxlogscore=999
 bulkscore=0 adultscore=0 phishscore=0 clxscore=1015 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004170174
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 4/17/20 8:08 AM, Brian Foster wrote:
> The inode flush code has several layers of error handling between
> the inode and cluster flushing code. If the inode flush fails before
> acquiring the backing buffer, the inode flush is aborted. If the
> cluster flush fails, the current inode flush is aborted and the
> cluster buffer is failed to handle the initial inode and any others
> that might have been attached before the error.
> 
> Since xfs_iflush() is the only caller of xfs_iflush_cluser(), the
> error handling between the two can be condensed in the top-level
> function. If we update xfs_iflush_int() to attach the item
> completion handler to the buffer first, any errors that occur after
> the first call to xfs_iflush_int() can be handled with a buffer
> I/O failure.
> 
> Lift the error handling from xfs_iflush_cluster() into xfs_iflush()
> and consolidate with the existing error handling. This also replaces
> the need to release the buffer because failing the buffer with
> XBF_ASYNC drops the current reference.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>
> ---
>   fs/xfs/xfs_inode.c | 94 +++++++++++++++-------------------------------
>   1 file changed, 30 insertions(+), 64 deletions(-)
> 
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index b539ee221ce5..4c9971ec6fa6 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -3496,6 +3496,7 @@ xfs_iflush_cluster(
>   	struct xfs_inode	**cilist;
>   	struct xfs_inode	*cip;
>   	struct xfs_ino_geometry	*igeo = M_IGEO(mp);
> +	int			error = 0;
>   	int			nr_found;
>   	int			clcount = 0;
>   	int			i;
> @@ -3588,11 +3589,10 @@ xfs_iflush_cluster(
>   		 * re-check that it's dirty before flushing.
>   		 */
>   		if (!xfs_inode_clean(cip)) {
> -			int	error;
>   			error = xfs_iflush_int(cip, bp);
>   			if (error) {
>   				xfs_iunlock(cip, XFS_ILOCK_SHARED);
> -				goto cluster_corrupt_out;
> +				goto out_free;
>   			}
>   			clcount++;
>   		} else {
> @@ -3611,32 +3611,7 @@ xfs_iflush_cluster(
>   	kmem_free(cilist);
>   out_put:
>   	xfs_perag_put(pag);
> -	return 0;
> -
> -
> -cluster_corrupt_out:
> -	/*
> -	 * Corruption detected in the clustering loop.  Invalidate the
> -	 * inode buffer and shut down the filesystem.
> -	 */
> -	rcu_read_unlock();
Hmm, I can't find where this unlock moved?  Is it not needed anymore?  I 
think I followed the rest of it though.

Reviewed-by: Allison Collins <allison.henderson@oracle.com>

Allison

> -
> -	/*
> -	 * We'll always have an inode attached to the buffer for completion
> -	 * process by the time we are called from xfs_iflush(). Hence we have
> -	 * always need to do IO completion processing to abort the inodes
> -	 * attached to the buffer.  handle them just like the shutdown case in
> -	 * xfs_buf_submit().
> -	 */
> -	ASSERT(bp->b_iodone);
> -	xfs_buf_iofail(bp, XBF_ASYNC);
> -	xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
> -
> -	/* abort the corrupt inode, as it was not attached to the buffer */
> -	xfs_iflush_abort(cip, false);
> -	kmem_free(cilist);
> -	xfs_perag_put(pag);
> -	return -EFSCORRUPTED;
> +	return error;
>   }
>   
>   /*
> @@ -3692,17 +3667,16 @@ xfs_iflush(
>   	 */
>   	if (XFS_FORCED_SHUTDOWN(mp)) {
>   		error = -EIO;
> -		goto abort_out;
> +		goto abort;
>   	}
>   
>   	/*
>   	 * Get the buffer containing the on-disk inode. We are doing a try-lock
> -	 * operation here, so we may get  an EAGAIN error. In that case, we
> -	 * simply want to return with the inode still dirty.
> +	 * operation here, so we may get an EAGAIN error. In that case, return
> +	 * leaving the inode dirty.
>   	 *
>   	 * If we get any other error, we effectively have a corruption situation
> -	 * and we cannot flush the inode, so we treat it the same as failing
> -	 * xfs_iflush_int().
> +	 * and we cannot flush the inode. Abort the flush and shut down.
>   	 */
>   	error = xfs_imap_to_bp(mp, NULL, &ip->i_imap, &dip, &bp, XBF_TRYLOCK,
>   			       0);
> @@ -3711,14 +3685,7 @@ xfs_iflush(
>   		return error;
>   	}
>   	if (error)
> -		goto corrupt_out;
> -
> -	/*
> -	 * First flush out the inode that xfs_iflush was called with.
> -	 */
> -	error = xfs_iflush_int(ip, bp);
> -	if (error)
> -		goto corrupt_out;
> +		goto abort;
>   
>   	/*
>   	 * If the buffer is pinned then push on the log now so we won't
> @@ -3728,28 +3695,28 @@ xfs_iflush(
>   		xfs_log_force(mp, 0);
>   
>   	/*
> -	 * inode clustering: try to gather other inodes into this write
> +	 * Flush the provided inode then attempt to gather others from the
> +	 * cluster into the write.
>   	 *
> -	 * Note: Any error during clustering will result in the filesystem
> -	 * being shut down and completion callbacks run on the cluster buffer.
> -	 * As we have already flushed and attached this inode to the buffer,
> -	 * it has already been aborted and released by xfs_iflush_cluster() and
> -	 * so we have no further error handling to do here.
> +	 * Note: Once we attempt to flush an inode, we must run buffer
> +	 * completion callbacks on any failure. If this fails, simulate an I/O
> +	 * failure on the buffer and shut down.
>   	 */
> -	error = xfs_iflush_cluster(ip, bp);
> -	if (error)
> -		return error;
> +	error = xfs_iflush_int(ip, bp);
> +	if (!error)
> +		error = xfs_iflush_cluster(ip, bp);
> +	if (error) {
> +		xfs_buf_iofail(bp, XBF_ASYNC);
> +		goto shutdown;
> +	}
>   
>   	*bpp = bp;
>   	return 0;
>   
> -corrupt_out:
> -	if (bp)
> -		xfs_buf_relse(bp);
> -	xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
> -abort_out:
> -	/* abort the corrupt inode, as it was not attached to the buffer */
> +abort:
>   	xfs_iflush_abort(ip, false);
> +shutdown:
> +	xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
>   	return error;
>   }
>   
> @@ -3798,6 +3765,13 @@ xfs_iflush_int(
>   	       ip->i_d.di_nextents > XFS_IFORK_MAXEXT(ip, XFS_DATA_FORK));
>   	ASSERT(iip != NULL && iip->ili_fields != 0);
>   
> +	/*
> +	 * Attach the inode item callback to the buffer. Whether the flush
> +	 * succeeds or not, buffer I/O completion processing is now required to
> +	 * remove the inode from the AIL and release the flush lock.
> +	 */
> +	xfs_buf_attach_iodone(bp, xfs_iflush_done, &iip->ili_item);
> +
>   	/* set *dip = inode's place in the buffer */
>   	dip = xfs_buf_offset(bp, ip->i_imap.im_boffset);
>   
> @@ -3913,14 +3887,6 @@ xfs_iflush_int(
>   	xfs_trans_ail_copy_lsn(mp->m_ail, &iip->ili_flush_lsn,
>   				&iip->ili_item.li_lsn);
>   
> -	/*
> -	 * Attach the function xfs_iflush_done to the inode's
> -	 * buffer.  This will remove the inode from the AIL
> -	 * and unlock the inode's flush lock when the inode is
> -	 * completely written to disk.
> -	 */
> -	xfs_buf_attach_iodone(bp, xfs_iflush_done, &iip->ili_item);
> -
>   	/* generate the checksum. */
>   	xfs_dinode_calc_crc(mp, dip);
>   
> 
