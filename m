Return-Path: <SRS0=AYd8=6O=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A147DC47247
	for <linux-xfs@archiver.kernel.org>; Thu, 30 Apr 2020 19:01:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 81C132073E
	for <linux-xfs@archiver.kernel.org>; Thu, 30 Apr 2020 19:01:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="uWqSaIqe"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726673AbgD3TBE (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 30 Apr 2020 15:01:04 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:57904 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726346AbgD3TBD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 30 Apr 2020 15:01:03 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03UInKfw079580;
        Thu, 30 Apr 2020 19:00:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=XTxS3NBKQaqapF9IQdRKATpOl8dCwNxrbcIB29J+Qug=;
 b=uWqSaIqeE9u1TpKljYUVNQHAPbw2oNj06n/HpEAXqDWoK4NgiAHZO1lu+KMLvpVj8WkI
 uc5Q3vLCgIo7y4KzK9KNirLJhHby12UN8Lff91tZrZs/Vzn+5JZUMw2kZMc1yrlpz1Qb
 HJaLp9r8HUU61f+8zGHmWlEOwaG9EpuqiAw0k/jwGKZwqBfZyPA7WiRaSJBysiydRvM/
 4DiH+r+ZJV4CujX+4nJPQkmH4AqIMmfZfgl4buLPml3SFYzR6qrOLd9woDFDOMzeRRpG
 Ucuku+wqHtPVMd7TRdcGUxB9jQV9X4CoZjqjWINZpQygC7dviuZZXVlsFq1iAUJDXeUH cQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 30p01p3ubt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 30 Apr 2020 19:00:59 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03UImFC8121059;
        Thu, 30 Apr 2020 19:00:59 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 30qtg1p0rm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 30 Apr 2020 19:00:59 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 03UJ0w1u017884;
        Thu, 30 Apr 2020 19:00:58 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 30 Apr 2020 12:00:57 -0700
Date:   Thu, 30 Apr 2020 12:00:57 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v3 17/17] xfs: remove unused iget_flags param from
 xfs_imap_to_bp()
Message-ID: <20200430190057.GR6742@magnolia>
References: <20200429172153.41680-1-bfoster@redhat.com>
 <20200429172153.41680-18-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200429172153.41680-18-bfoster@redhat.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9607 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 adultscore=0
 mlxlogscore=999 phishscore=0 malwarescore=0 spamscore=0 bulkscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004300145
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9607 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 clxscore=1015
 phishscore=0 mlxlogscore=999 adultscore=0 priorityscore=1501 mlxscore=0
 suspectscore=0 malwarescore=0 lowpriorityscore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004300145
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Apr 29, 2020 at 01:21:53PM -0400, Brian Foster wrote:
> iget_flags is unused in xfs_imap_to_bp(). Remove the parameter and
> fix up the callers.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>

Not sure why this is in this series, but as a small cleanup it makes
sense anyway...

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/libxfs/xfs_inode_buf.c | 5 ++---
>  fs/xfs/libxfs/xfs_inode_buf.h | 2 +-
>  fs/xfs/scrub/ialloc.c         | 3 +--
>  fs/xfs/xfs_inode.c            | 7 +++----
>  fs/xfs/xfs_log_recover.c      | 2 +-
>  5 files changed, 8 insertions(+), 11 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
> index b102e611bf54..81a010422bea 100644
> --- a/fs/xfs/libxfs/xfs_inode_buf.c
> +++ b/fs/xfs/libxfs/xfs_inode_buf.c
> @@ -161,8 +161,7 @@ xfs_imap_to_bp(
>  	struct xfs_imap		*imap,
>  	struct xfs_dinode       **dipp,
>  	struct xfs_buf		**bpp,
> -	uint			buf_flags,
> -	uint			iget_flags)
> +	uint			buf_flags)
>  {
>  	struct xfs_buf		*bp;
>  	int			error;
> @@ -621,7 +620,7 @@ xfs_iread(
>  	/*
>  	 * Get pointers to the on-disk inode and the buffer containing it.
>  	 */
> -	error = xfs_imap_to_bp(mp, tp, &ip->i_imap, &dip, &bp, 0, iget_flags);
> +	error = xfs_imap_to_bp(mp, tp, &ip->i_imap, &dip, &bp, 0);
>  	if (error)
>  		return error;
>  
> diff --git a/fs/xfs/libxfs/xfs_inode_buf.h b/fs/xfs/libxfs/xfs_inode_buf.h
> index 9b373dcf9e34..d9b4781ac9fd 100644
> --- a/fs/xfs/libxfs/xfs_inode_buf.h
> +++ b/fs/xfs/libxfs/xfs_inode_buf.h
> @@ -48,7 +48,7 @@ struct xfs_imap {
>  
>  int	xfs_imap_to_bp(struct xfs_mount *, struct xfs_trans *,
>  		       struct xfs_imap *, struct xfs_dinode **,
> -		       struct xfs_buf **, uint, uint);
> +		       struct xfs_buf **, uint);
>  int	xfs_iread(struct xfs_mount *, struct xfs_trans *,
>  		  struct xfs_inode *, uint);
>  void	xfs_dinode_calc_crc(struct xfs_mount *, struct xfs_dinode *);
> diff --git a/fs/xfs/scrub/ialloc.c b/fs/xfs/scrub/ialloc.c
> index 64c217eb06a7..6517d67e8d51 100644
> --- a/fs/xfs/scrub/ialloc.c
> +++ b/fs/xfs/scrub/ialloc.c
> @@ -278,8 +278,7 @@ xchk_iallocbt_check_cluster(
>  			&XFS_RMAP_OINFO_INODES);
>  
>  	/* Grab the inode cluster buffer. */
> -	error = xfs_imap_to_bp(mp, bs->cur->bc_tp, &imap, &dip, &cluster_bp,
> -			0, 0);
> +	error = xfs_imap_to_bp(mp, bs->cur->bc_tp, &imap, &dip, &cluster_bp, 0);
>  	if (!xchk_btree_xref_process_error(bs->sc, bs->cur, 0, &error))
>  		return error;
>  
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index e0d9a5bf7507..4f915b91b9fd 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -2172,7 +2172,7 @@ xfs_iunlink_update_inode(
>  
>  	ASSERT(xfs_verify_agino_or_null(mp, agno, next_agino));
>  
> -	error = xfs_imap_to_bp(mp, tp, &ip->i_imap, &dip, &ibp, 0, 0);
> +	error = xfs_imap_to_bp(mp, tp, &ip->i_imap, &dip, &ibp, 0);
>  	if (error)
>  		return error;
>  
> @@ -2302,7 +2302,7 @@ xfs_iunlink_map_ino(
>  		return error;
>  	}
>  
> -	error = xfs_imap_to_bp(mp, tp, imap, dipp, bpp, 0, 0);
> +	error = xfs_imap_to_bp(mp, tp, imap, dipp, bpp, 0);
>  	if (error) {
>  		xfs_warn(mp, "%s: xfs_imap_to_bp returned error %d.",
>  				__func__, error);
> @@ -3665,8 +3665,7 @@ xfs_iflush(
>  	 * If we get any other error, we effectively have a corruption situation
>  	 * and we cannot flush the inode. Abort the flush and shut down.
>  	 */
> -	error = xfs_imap_to_bp(mp, NULL, &ip->i_imap, &dip, &bp, XBF_TRYLOCK,
> -			       0);
> +	error = xfs_imap_to_bp(mp, NULL, &ip->i_imap, &dip, &bp, XBF_TRYLOCK);
>  	if (error == -EAGAIN) {
>  		xfs_ifunlock(ip);
>  		return error;
> diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
> index 11c3502b07b1..6a98fd9f00b3 100644
> --- a/fs/xfs/xfs_log_recover.c
> +++ b/fs/xfs/xfs_log_recover.c
> @@ -4987,7 +4987,7 @@ xlog_recover_process_one_iunlink(
>  	/*
>  	 * Get the on disk inode to find the next inode in the bucket.
>  	 */
> -	error = xfs_imap_to_bp(mp, NULL, &ip->i_imap, &dip, &ibp, 0, 0);
> +	error = xfs_imap_to_bp(mp, NULL, &ip->i_imap, &dip, &ibp, 0);
>  	if (error)
>  		goto fail_iput;
>  
> -- 
> 2.21.1
> 
