Return-Path: <SRS0=NnDK=6T=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 283ACC47254
	for <linux-xfs@archiver.kernel.org>; Tue,  5 May 2020 21:09:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E9F84206FA
	for <linux-xfs@archiver.kernel.org>; Tue,  5 May 2020 21:09:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="uGxfeGco"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726350AbgEEVJk (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 5 May 2020 17:09:40 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:49444 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729011AbgEEVJj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 5 May 2020 17:09:39 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 045L3bVD166625;
        Tue, 5 May 2020 21:09:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=M2d9PSExObDsOcMGKxYwEgz+HU/EDk834HoUjns/Mpg=;
 b=uGxfeGcoFAG+JH2syZlwP4ZEA1AZMjVQJ2qqC8hJU7mzsRhBkYZruz7wOmIOmHekAMuq
 +b369Qaxaj7Y5rjp446KmUcOkxKYRGu6E+dQ0AuJA0hyBxZYPrg7BOBiBwyoZeW5psLj
 pSLPSoE18sr8DBfjIIHJBiood2ypHnAXrlnXgD4DdyqIl3+jFJMEoAO4EdmA2RdnQYt4
 U4if/bBDhKDYfph6+d1eCOD/lPAISTuP1JiclBLiPsYBO0bsPC9y1JH3PLwjNhEEPDkE
 rIXXS6GL0Cly4kJqi3v2yWSpZupf3FMnv+mtLuWl+c68c7SV2fR63SRHOIrAtXcL/AF5 ng== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 30s09r75p8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 05 May 2020 21:09:35 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 045L5mSm128627;
        Tue, 5 May 2020 21:09:34 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 30t1r5yrm7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 05 May 2020 21:09:34 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 045L9Xnk029526;
        Tue, 5 May 2020 21:09:34 GMT
Received: from [192.168.1.223] (/67.1.142.158)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 05 May 2020 14:09:33 -0700
Subject: Re: [PATCH v4 03/17] xfs: simplify inode flush error handling
To:     Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org
References: <20200504141154.55887-1-bfoster@redhat.com>
 <20200504141154.55887-4-bfoster@redhat.com>
From:   Allison Collins <allison.henderson@oracle.com>
Message-ID: <60d6b8e2-e5c1-32d2-f387-fc7301d7b9ca@oracle.com>
Date:   Tue, 5 May 2020 14:09:32 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20200504141154.55887-4-bfoster@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9612 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 adultscore=0 suspectscore=2
 spamscore=0 mlxlogscore=999 malwarescore=0 phishscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2005050163
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9612 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0
 lowpriorityscore=0 spamscore=0 adultscore=0 clxscore=1015 suspectscore=2
 priorityscore=1501 malwarescore=0 mlxlogscore=999 phishscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2005050163
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 5/4/20 7:11 AM, Brian Foster wrote:
> The inode flush code has several layers of error handling between
> the inode and cluster flushing code. If the inode flush fails before
> acquiring the backing buffer, the inode flush is aborted. If the
> cluster flush fails, the current inode flush is aborted and the
> cluster buffer is failed to handle the initial inode and any others
> that might have been attached before the error.
> 
> Since xfs_iflush() is the only caller of xfs_iflush_cluster(), the
> error handling between the two can be condensed in the top-level
> function. If we update xfs_iflush_int() to always fall through to
> the log item update and attach the item completion handler to the
> buffer, any errors that occur after the first call to
> xfs_iflush_int() can be handled with a buffer I/O failure.
> 
> Lift the error handling from xfs_iflush_cluster() into xfs_iflush()
> and consolidate with the existing error handling. This also replaces
> the need to release the buffer because failing the buffer with
> XBF_ASYNC drops the current reference.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
Ok, I think it looks good
Reviewed-by: Allison Collins <allison.henderson@oracle.com>

> ---
>   fs/xfs/xfs_inode.c | 117 +++++++++++++++++----------------------------
>   1 file changed, 45 insertions(+), 72 deletions(-)
> 
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index 909ca7c0bac4..84f2ee9957dc 100644
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
> @@ -3611,33 +3611,7 @@ xfs_iflush_cluster(
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
> -
> -	/*
> -	 * We'll always have an inode attached to the buffer for completion
> -	 * process by the time we are called from xfs_iflush(). Hence we have
> -	 * always need to do IO completion processing to abort the inodes
> -	 * attached to the buffer.  handle them just like the shutdown case in
> -	 * xfs_buf_submit().
> -	 */
> -	ASSERT(bp->b_iodone);
> -	bp->b_flags |= XBF_ASYNC;
> -	xfs_buf_ioend_fail(bp);
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
> @@ -3693,17 +3667,16 @@ xfs_iflush(
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
> @@ -3712,14 +3685,7 @@ xfs_iflush(
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
> @@ -3729,28 +3695,29 @@ xfs_iflush(
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
> +		bp->b_flags |= XBF_ASYNC;
> +		xfs_buf_ioend_fail(bp);
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
> @@ -3792,6 +3759,7 @@ xfs_iflush_int(
>   	struct xfs_inode_log_item *iip = ip->i_itemp;
>   	struct xfs_dinode	*dip;
>   	struct xfs_mount	*mp = ip->i_mount;
> +	int			error;
>   
>   	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL|XFS_ILOCK_SHARED));
>   	ASSERT(xfs_isiflocked(ip));
> @@ -3799,15 +3767,21 @@ xfs_iflush_int(
>   	       ip->i_d.di_nextents > XFS_IFORK_MAXEXT(ip, XFS_DATA_FORK));
>   	ASSERT(iip != NULL && iip->ili_fields != 0);
>   
> -	/* set *dip = inode's place in the buffer */
>   	dip = xfs_buf_offset(bp, ip->i_imap.im_boffset);
>   
> +	/*
> +	 * We don't flush the inode if any of the following checks fail, but we
> +	 * do still update the log item and attach to the backing buffer as if
> +	 * the flush happened. This is a formality to facilitate predictable
> +	 * error handling as the caller will shutdown and fail the buffer.
> +	 */
> +	error = -EFSCORRUPTED;
>   	if (XFS_TEST_ERROR(dip->di_magic != cpu_to_be16(XFS_DINODE_MAGIC),
>   			       mp, XFS_ERRTAG_IFLUSH_1)) {
>   		xfs_alert_tag(mp, XFS_PTAG_IFLUSH,
>   			"%s: Bad inode %Lu magic number 0x%x, ptr "PTR_FMT,
>   			__func__, ip->i_ino, be16_to_cpu(dip->di_magic), dip);
> -		goto corrupt_out;
> +		goto flush_out;
>   	}
>   	if (S_ISREG(VFS_I(ip)->i_mode)) {
>   		if (XFS_TEST_ERROR(
> @@ -3817,7 +3791,7 @@ xfs_iflush_int(
>   			xfs_alert_tag(mp, XFS_PTAG_IFLUSH,
>   				"%s: Bad regular inode %Lu, ptr "PTR_FMT,
>   				__func__, ip->i_ino, ip);
> -			goto corrupt_out;
> +			goto flush_out;
>   		}
>   	} else if (S_ISDIR(VFS_I(ip)->i_mode)) {
>   		if (XFS_TEST_ERROR(
> @@ -3828,7 +3802,7 @@ xfs_iflush_int(
>   			xfs_alert_tag(mp, XFS_PTAG_IFLUSH,
>   				"%s: Bad directory inode %Lu, ptr "PTR_FMT,
>   				__func__, ip->i_ino, ip);
> -			goto corrupt_out;
> +			goto flush_out;
>   		}
>   	}
>   	if (XFS_TEST_ERROR(ip->i_d.di_nextents + ip->i_d.di_anextents >
> @@ -3839,14 +3813,14 @@ xfs_iflush_int(
>   			__func__, ip->i_ino,
>   			ip->i_d.di_nextents + ip->i_d.di_anextents,
>   			ip->i_d.di_nblocks, ip);
> -		goto corrupt_out;
> +		goto flush_out;
>   	}
>   	if (XFS_TEST_ERROR(ip->i_d.di_forkoff > mp->m_sb.sb_inodesize,
>   				mp, XFS_ERRTAG_IFLUSH_6)) {
>   		xfs_alert_tag(mp, XFS_PTAG_IFLUSH,
>   			"%s: bad inode %Lu, forkoff 0x%x, ptr "PTR_FMT,
>   			__func__, ip->i_ino, ip->i_d.di_forkoff, ip);
> -		goto corrupt_out;
> +		goto flush_out;
>   	}
>   
>   	/*
> @@ -3863,7 +3837,7 @@ xfs_iflush_int(
>   
>   	/* Check the inline fork data before we write out. */
>   	if (!xfs_inode_verify_forks(ip))
> -		goto corrupt_out;
> +		goto flush_out;
>   
>   	/*
>   	 * Copy the dirty parts of the inode into the on-disk inode.  We always
> @@ -3906,6 +3880,8 @@ xfs_iflush_int(
>   	 * need the AIL lock, because it is a 64 bit value that cannot be read
>   	 * atomically.
>   	 */
> +	error = 0;
> +flush_out:
>   	iip->ili_last_fields = iip->ili_fields;
>   	iip->ili_fields = 0;
>   	iip->ili_fsync_fields = 0;
> @@ -3915,10 +3891,10 @@ xfs_iflush_int(
>   				&iip->ili_item.li_lsn);
>   
>   	/*
> -	 * Attach the function xfs_iflush_done to the inode's
> -	 * buffer.  This will remove the inode from the AIL
> -	 * and unlock the inode's flush lock when the inode is
> -	 * completely written to disk.
> +	 * Attach the inode item callback to the buffer whether the flush
> +	 * succeeded or not. If not, the caller will shut down and fail I/O
> +	 * completion on the buffer to remove the inode from the AIL and release
> +	 * the flush lock.
>   	 */
>   	xfs_buf_attach_iodone(bp, xfs_iflush_done, &iip->ili_item);
>   
> @@ -3927,10 +3903,7 @@ xfs_iflush_int(
>   
>   	ASSERT(!list_empty(&bp->b_li_list));
>   	ASSERT(bp->b_iodone != NULL);
> -	return 0;
> -
> -corrupt_out:
> -	return -EFSCORRUPTED;
> +	return error;
>   }
>   
>   /* Release an inode. */
> 
