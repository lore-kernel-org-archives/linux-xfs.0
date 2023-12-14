Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 479D16A346
	for <linux-xfs@vger.kernel.org>; Thu, 14 Dec 2023 20:44:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AYBSPe4s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA6E0C433C7;
	Thu, 14 Dec 2023 20:44:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1702586665;
	bh=buoEnCktuqvI4/f71sLdk/DU0VI/5aGQKefD34ixTpg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=AYBSPe4sgfbr7g1t5Po39TIWboX30b/Ib39vsRjkkrKcuNcjRAH0FlT5GrRjtC1qA
	 qVKmErkAJb+XyLKVQ8QH6A/NDG76eZj6zL5YAGuFD4kMmLTdHzmKr9y39mcTUOY9X4
	 9Dn9yQwLpOnb7rasYPCpWP4zVrm3kkSWRKy4svQa/Y91JIcDfNwBwQJa8usREY4GGC
	 aoKoo8TmtkznnBHhyG355XFww9pbwbu4sbUaUshi6edDlD+oBsgUe2eWQhSoik54K8
	 +SAms2O+9Qm8P2k33xMqNC4jJHgpO9A1uHp/3yhxqEVVlzwbVxnEd2c8+0zJqDnFT0
	 tMOO5af9NvSaA==
Date: Thu, 14 Dec 2023 12:44:25 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Chandan Babu R <chandan.babu@oracle.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 02/19] xfs: turn the xfs_trans_mod_dquot_byino stub into
 an inline function
Message-ID: <20231214204425.GQ361584@frogsfrogsfrogs>
References: <20231214063438.290538-1-hch@lst.de>
 <20231214063438.290538-3-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231214063438.290538-3-hch@lst.de>

On Thu, Dec 14, 2023 at 07:34:21AM +0100, Christoph Hellwig wrote:
> Without this upcoming change can cause an unused variable warning,
> when adding a local variable for the fields field passed to it.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Stupid warnings...
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_quota.h | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_quota.h b/fs/xfs/xfs_quota.h
> index dcc785fdd34532..e0d56489f3b287 100644
> --- a/fs/xfs/xfs_quota.h
> +++ b/fs/xfs/xfs_quota.h
> @@ -127,7 +127,10 @@ xfs_qm_vop_dqalloc(struct xfs_inode *ip, kuid_t kuid, kgid_t kgid,
>  }
>  #define xfs_trans_dup_dqinfo(tp, tp2)
>  #define xfs_trans_free_dqinfo(tp)
> -#define xfs_trans_mod_dquot_byino(tp, ip, fields, delta) do { } while (0)
> +static inline void xfs_trans_mod_dquot_byino(struct xfs_trans *tp,
> +		struct xfs_inode *ip, uint field, int64_t delta)
> +{
> +}
>  #define xfs_trans_apply_dquot_deltas(tp)
>  #define xfs_trans_unreserve_and_mod_dquots(tp)
>  static inline int xfs_trans_reserve_quota_nblks(struct xfs_trans *tp,
> -- 
> 2.39.2
> 
> 
