Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A7C614287
	for <linux-xfs@vger.kernel.org>; Tue, 23 Jul 2024 02:20:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721701212; cv=none; b=fLz1ZlmVd3Cwhs/Yd/a2P+9iA48eXckczaeacIraYuqK1oJruWwAvTx7a6ebz9B6sz3wkv+NCir81wacEG9JW4g3mkSe/683QOs3eSwxCc+s7XCW7u1WApHxmW9Fse/DwNxgu3Y98BjVy0LVvWNg2b+jpUOPgPY42KDLuDWvz3g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721701212; c=relaxed/simple;
	bh=ZknCh8qGx+LjpRq87QU/ndiRDOmL4nzkLLrvhsscFT4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LWtjw1ZfsnleyOI4yJweg8qPnIrJA9FOEsGNvYXc8jce2Dex+p1aRySrGgkdZs3Ej3tKPt3jxFucpE9uxqMfVpTxNN8ZjSqGXeZ5vo5TPX0BHYvaKhpLEzXCbS37pNAlLiRYosbVAwS4bUS4UdjAx4WJAYXl/fByQXzwnplsTCg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PLfH30Xx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PLfH30Xx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4628C116B1;
	Tue, 23 Jul 2024 02:20:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1721701211;
	bh=ZknCh8qGx+LjpRq87QU/ndiRDOmL4nzkLLrvhsscFT4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=PLfH30XxUw2DYNY3ZomOkRaq5bB2tLjnNJUCGef1Q7JgbY9G+0XFmOI4DsFCFIY4O
	 3VtagQiUTGsONSSJREa1unr7oOMoBwopdUyFGp8rDGRD+iUwoTj1KnpLa6BCYhUVDZ
	 ptmNDAh88YVytEhvM/3HLLuzidYzfdte9x41CiLJEIHJt2HDzna8DBVGP0vy1/QVQ/
	 tiiKJ6/3BNgczZ+iLtKIGt2Gkc7m0PKf8lRPs8CZtMTCVM8qeLo8g1PjgB/rkmEjgz
	 kKnAU7zidTs4RCCAsnEkOj9KR/IUFv5le9qUqn0cyGa86EbOcJ/TFAgDVVccN6cP60
	 p41pP6/Hr60rw==
Date: Mon, 22 Jul 2024 19:20:11 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Julian Sun <sunjunchao2870@gmail.com>
Cc: linux-xfs@vger.kernel.org, chandan.babu@oracle.com
Subject: Re: [PATCH] xfs: remove unused parameter in macro XFS_DQUOT_LOGRES
Message-ID: <20240723022011.GO612460@frogsfrogsfrogs>
References: <20240721112701.212342-1-sunjunchao2870@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240721112701.212342-1-sunjunchao2870@gmail.com>

On Sun, Jul 21, 2024 at 07:27:01AM -0400, Julian Sun wrote:
> In the macro definition of XFS_DQUOT_LOGRES, a parameter is accepted,
> but it is not used. Hence, it should be removed.
> 
> This patch has only passed compilation test, but it should be fine.
> 
> Signed-off-by: Julian Sun <sunjunchao2870@gmail.com>

Seems fine to me...
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/libxfs/xfs_quota_defs.h |  2 +-
>  fs/xfs/libxfs/xfs_trans_resv.c | 28 ++++++++++++++--------------
>  2 files changed, 15 insertions(+), 15 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_quota_defs.h b/fs/xfs/libxfs/xfs_quota_defs.h
> index cb035da3f990..fb05f44f6c75 100644
> --- a/fs/xfs/libxfs/xfs_quota_defs.h
> +++ b/fs/xfs/libxfs/xfs_quota_defs.h
> @@ -56,7 +56,7 @@ typedef uint8_t		xfs_dqtype_t;
>   * And, of course, we also need to take into account the dquot log format item
>   * used to describe each dquot.
>   */
> -#define XFS_DQUOT_LOGRES(mp)	\
> +#define XFS_DQUOT_LOGRES	\
>  	((sizeof(struct xfs_dq_logformat) + sizeof(struct xfs_disk_dquot)) * 6)
>  
>  #define XFS_IS_QUOTA_ON(mp)		((mp)->m_qflags & XFS_ALL_QUOTA_ACCT)
> diff --git a/fs/xfs/libxfs/xfs_trans_resv.c b/fs/xfs/libxfs/xfs_trans_resv.c
> index 3dc8f785bf29..45aaf169806a 100644
> --- a/fs/xfs/libxfs/xfs_trans_resv.c
> +++ b/fs/xfs/libxfs/xfs_trans_resv.c
> @@ -338,11 +338,11 @@ xfs_calc_write_reservation(
>  					blksz);
>  		t1 += adj;
>  		t3 += adj;
> -		return XFS_DQUOT_LOGRES(mp) + max3(t1, t2, t3);
> +		return XFS_DQUOT_LOGRES + max3(t1, t2, t3);
>  	}
>  
>  	t4 = xfs_calc_refcountbt_reservation(mp, 1);
> -	return XFS_DQUOT_LOGRES(mp) + max(t4, max3(t1, t2, t3));
> +	return XFS_DQUOT_LOGRES + max(t4, max3(t1, t2, t3));
>  }
>  
>  unsigned int
> @@ -410,11 +410,11 @@ xfs_calc_itruncate_reservation(
>  					xfs_refcountbt_block_count(mp, 4),
>  					blksz);
>  
> -		return XFS_DQUOT_LOGRES(mp) + max3(t1, t2, t3);
> +		return XFS_DQUOT_LOGRES + max3(t1, t2, t3);
>  	}
>  
>  	t4 = xfs_calc_refcountbt_reservation(mp, 2);
> -	return XFS_DQUOT_LOGRES(mp) + max(t4, max3(t1, t2, t3));
> +	return XFS_DQUOT_LOGRES + max(t4, max3(t1, t2, t3));
>  }
>  
>  unsigned int
> @@ -466,7 +466,7 @@ STATIC uint
>  xfs_calc_rename_reservation(
>  	struct xfs_mount	*mp)
>  {
> -	unsigned int		overhead = XFS_DQUOT_LOGRES(mp);
> +	unsigned int		overhead = XFS_DQUOT_LOGRES;
>  	struct xfs_trans_resv	*resp = M_RES(mp);
>  	unsigned int		t1, t2, t3 = 0;
>  
> @@ -577,7 +577,7 @@ STATIC uint
>  xfs_calc_link_reservation(
>  	struct xfs_mount	*mp)
>  {
> -	unsigned int		overhead = XFS_DQUOT_LOGRES(mp);
> +	unsigned int		overhead = XFS_DQUOT_LOGRES;
>  	struct xfs_trans_resv	*resp = M_RES(mp);
>  	unsigned int		t1, t2, t3 = 0;
>  
> @@ -641,7 +641,7 @@ STATIC uint
>  xfs_calc_remove_reservation(
>  	struct xfs_mount	*mp)
>  {
> -	unsigned int            overhead = XFS_DQUOT_LOGRES(mp);
> +	unsigned int            overhead = XFS_DQUOT_LOGRES;
>  	struct xfs_trans_resv   *resp = M_RES(mp);
>  	unsigned int            t1, t2, t3 = 0;
>  
> @@ -729,7 +729,7 @@ xfs_calc_icreate_reservation(
>  	struct xfs_mount	*mp)
>  {
>  	struct xfs_trans_resv	*resp = M_RES(mp);
> -	unsigned int		overhead = XFS_DQUOT_LOGRES(mp);
> +	unsigned int		overhead = XFS_DQUOT_LOGRES;
>  	unsigned int		t1, t2, t3 = 0;
>  
>  	t1 = xfs_calc_icreate_resv_alloc(mp);
> @@ -747,7 +747,7 @@ STATIC uint
>  xfs_calc_create_tmpfile_reservation(
>  	struct xfs_mount        *mp)
>  {
> -	uint	res = XFS_DQUOT_LOGRES(mp);
> +	uint	res = XFS_DQUOT_LOGRES;
>  
>  	res += xfs_calc_icreate_resv_alloc(mp);
>  	return res + xfs_calc_iunlink_add_reservation(mp);
> @@ -829,7 +829,7 @@ STATIC uint
>  xfs_calc_ifree_reservation(
>  	struct xfs_mount	*mp)
>  {
> -	return XFS_DQUOT_LOGRES(mp) +
> +	return XFS_DQUOT_LOGRES +
>  		xfs_calc_inode_res(mp, 1) +
>  		xfs_calc_buf_res(3, mp->m_sb.sb_sectsize) +
>  		xfs_calc_iunlink_remove_reservation(mp) +
> @@ -846,7 +846,7 @@ STATIC uint
>  xfs_calc_ichange_reservation(
>  	struct xfs_mount	*mp)
>  {
> -	return XFS_DQUOT_LOGRES(mp) +
> +	return XFS_DQUOT_LOGRES +
>  		xfs_calc_inode_res(mp, 1) +
>  		xfs_calc_buf_res(1, mp->m_sb.sb_sectsize);
>  
> @@ -955,7 +955,7 @@ STATIC uint
>  xfs_calc_addafork_reservation(
>  	struct xfs_mount	*mp)
>  {
> -	return XFS_DQUOT_LOGRES(mp) +
> +	return XFS_DQUOT_LOGRES +
>  		xfs_calc_inode_res(mp, 1) +
>  		xfs_calc_buf_res(2, mp->m_sb.sb_sectsize) +
>  		xfs_calc_buf_res(1, mp->m_dir_geo->blksize) +
> @@ -1003,7 +1003,7 @@ STATIC uint
>  xfs_calc_attrsetm_reservation(
>  	struct xfs_mount	*mp)
>  {
> -	return XFS_DQUOT_LOGRES(mp) +
> +	return XFS_DQUOT_LOGRES +
>  		xfs_calc_inode_res(mp, 1) +
>  		xfs_calc_buf_res(1, mp->m_sb.sb_sectsize) +
>  		xfs_calc_buf_res(XFS_DA_NODE_MAXDEPTH, XFS_FSB_TO_B(mp, 1));
> @@ -1043,7 +1043,7 @@ STATIC uint
>  xfs_calc_attrrm_reservation(
>  	struct xfs_mount	*mp)
>  {
> -	return XFS_DQUOT_LOGRES(mp) +
> +	return XFS_DQUOT_LOGRES +
>  		max((xfs_calc_inode_res(mp, 1) +
>  		     xfs_calc_buf_res(XFS_DA_NODE_MAXDEPTH,
>  				      XFS_FSB_TO_B(mp, 1)) +
> -- 
> 2.39.2
> 
> 
