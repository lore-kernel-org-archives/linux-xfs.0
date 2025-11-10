Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7613227FD43
	for <linux-xfs@vger.kernel.org>; Mon, 10 Nov 2025 18:04:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762797843; cv=none; b=s6kOwGiml2WVeI0Nda2A0VW+GnUxHBdYlcTxVLUTTaaLBerts+dTDeCoQi6AQ4KsM/hiOZyJzdgnu23ve9D6Sy9sr92BIIy60s6j9tFOggd9ULdWa1cRfBR3IndkreK9QHwldFN0fhUM6hXrVm3g5PKa6gxMtRHObdqxFRHcCV4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762797843; c=relaxed/simple;
	bh=ubbfu9K+n4unKrE+X27xCTRa2Elp07PYXSJQb2dx2aM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bzxYF1+usOW1EiR4H0lp3UFD78l1NkCJ13RQK0dKVfSaCHBMYLMTR+H9LJUT4jxnGnpxOhtvCS1vS3WGhUWtHAUVLCxFwzcnyxQAA6ZntFAVipQtZLV5a/oxp2rb6tKWhTXnjVOiS9okt3ABA84GcbM6wh7YT8bGi3RxyRLjK88=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NkKm0IVX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NkKm0IVX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1169C2BCAF;
	Mon, 10 Nov 2025 18:04:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762797843;
	bh=ubbfu9K+n4unKrE+X27xCTRa2Elp07PYXSJQb2dx2aM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=NkKm0IVXhiqNWgBNuIaX2I3UXDGhWEAghal7JG6xWJ0AdThJPnGymOBVkmZqbizhJ
	 +iXpxIAiJLzqAIv27veX4iLFpH5wA3q1FCOi7WFViLwRwEkWRXWM+xxaJEuMk92Dhf
	 ryCeOGel8TEaLJN1WrmGtaJW/fZ4aYC5Bcj/sTewdkZW7TGpXe6K0wRF6zypuTmY4p
	 b9KmE/chxC8wDIcGuNrT5I/1vQPMP5IwxRK8ukvAJsryuoUH9XriGo9x8k0dDijXd/
	 K7v2+Xvd2b6Ur8azLqFHDfAxPVDlAigRVUYzffk3V62KG+kfBG15HbdoE9p50otxnu
	 CjVlkLZcrZywg==
Date: Mon, 10 Nov 2025 10:04:02 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 02/18] xfs: make qi_dquots a 64-bit value
Message-ID: <20251110180402.GQ196370@frogsfrogsfrogs>
References: <20251110132335.409466-1-hch@lst.de>
 <20251110132335.409466-3-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251110132335.409466-3-hch@lst.de>

On Mon, Nov 10, 2025 at 02:22:54PM +0100, Christoph Hellwig wrote:
> qi_dquots counts all quotas in the file system, which can be up to
> 3 * UINT_MAX and overflow a 32-bit counter, but can't be negative.
> Make qi_dquots a uint64_t, and saturate the value to UINT_MAX for
> userspace reporting.
> 
> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Heh, what a bug. :)
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_qm.h       | 2 +-
>  fs/xfs/xfs_quotaops.c | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/xfs/xfs_qm.h b/fs/xfs/xfs_qm.h
> index 35b64bc3a7a8..e88ed6ad0e65 100644
> --- a/fs/xfs/xfs_qm.h
> +++ b/fs/xfs/xfs_qm.h
> @@ -57,7 +57,7 @@ struct xfs_quotainfo {
>  	struct xfs_inode	*qi_pquotaip;	/* project quota inode */
>  	struct xfs_inode	*qi_dirip;	/* quota metadir */
>  	struct list_lru		qi_lru;
> -	int			qi_dquots;
> +	uint64_t		qi_dquots;
>  	struct mutex		qi_quotaofflock;/* to serialize quotaoff */
>  	xfs_filblks_t		qi_dqchunklen;	/* # BBs in a chunk of dqs */
>  	uint			qi_dqperchunk;	/* # ondisk dq in above chunk */
> diff --git a/fs/xfs/xfs_quotaops.c b/fs/xfs/xfs_quotaops.c
> index 4c7f7ce4fd2f..94fbe3d99ec7 100644
> --- a/fs/xfs/xfs_quotaops.c
> +++ b/fs/xfs/xfs_quotaops.c
> @@ -65,7 +65,7 @@ xfs_fs_get_quota_state(
>  	memset(state, 0, sizeof(*state));
>  	if (!XFS_IS_QUOTA_ON(mp))
>  		return 0;
> -	state->s_incoredqs = q->qi_dquots;
> +	state->s_incoredqs = min_t(uint64_t, q->qi_dquots, UINT_MAX);
>  	if (XFS_IS_UQUOTA_ON(mp))
>  		state->s_state[USRQUOTA].flags |= QCI_ACCT_ENABLED;
>  	if (XFS_IS_UQUOTA_ENFORCED(mp))
> -- 
> 2.47.3
> 
> 
