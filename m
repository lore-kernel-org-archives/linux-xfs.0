Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795121312;
	b=cnH8DXX/ZsR1xrDVAkOeNksLuK7BSz4K/8/EJ54MyG0RuxrhPWKtulq6pze0Af8aekkh
	 vjbrQXivcetFpkHZIpCOynUD62/X0aevbA3TX3sNaqKezOqURCX5hkTmDp3578n+Ecfds
	 qqJswwBJ03IijnM4jkfgOVcGoz3weQQLMbMLIGVKOCS34GN+tHSVU7/hEXmIB7JFBmaMq
	 CTXBkwGPYsRf6yG9tKKWmFg97utJ4ooGdbzGCDOSAr72ShkoyTiD+ccgbOcyxcQlf0AdS
	 efxJN/cvTSbEDnOvpJEQn8YfpVwYTs/oq4juWizCBsQu68WgnvQ2Xxn/tsPpEdkaaKg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795121312;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=3PGVJVSc8QkEj1hdnStWiMpyEZMIVB/RSu3VQkMSD4Q=;
	b=Ajaai7QKegnNBftjudihJZNJzbHihUEIwGdQP18COs3jNV5mQkradseRq4R2ok/9iQHG
	 xwV+t31In4zgrnTgyp8XrvOCw+CXb1GWz6tiG83mXR1T+AP805z93nFP/tD2fWhyP0fx7
	 EX74oDH0xZ3hNF7RPUTCMk09p/qWX6E4pu6qKdbb5DUjq3zicwtCp/w7cKu9/OA3VubH9
	 gJYfVW2K9ie6g8w42G062p6lcGd2OdoitaolKrlFZvuXmx7aXNNtVGztIxn/srGGe2sit
	 1Rbl+gaTq7pKdASJErwGmgFcayUjnMT7S1ZNd9JMJPc80lzk3VqJaWYQC2uO20u6t6g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="Ue9J5/vX";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86E6C606CC7B;
	Thu, 19 Nov 2026 20:48:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Ue9J5/vX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5862C1F000CF;
	Thu, 19 Nov 2026 20:48:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795121312;
	bh=3PGVJVSc8QkEj1hdnStWiMpyEZMIVB/RSu3VQkMSD4Q=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Ue9J5/vXQQKgXeGGR/gDKOdLIvkPt/OHBv/xbkrYdBe65rGDof+xnYjDqlFvqyqQV
	 WTbiGm1jwXFq2goSCG+63YU564jbcVpEBNEmScsT4QFSJLA/xI1v8/xsoWqAW2f1Ul
	 SSVRPr2dUv57zfJ2/9acK9mOwLLa5IYT21C8vqN0sSoybGDiMczqGgpVA1x2ScNPvR
	 SwWELDPV/KKxRb1t95LVaGxquYOYMrfFU97lDXPBU8ZIkB06H6EscpbeR2xjQHhO+G
	 EVtsDIFt5g8DJJmL063y3QX3nR44hpO1z/oLunHmPHWXkAYut8GVWPBGAVsr8yFtPi
	 pVmjC2n2lsCcA==
Date: Thu, 19 Nov 2026 21:48:27 +0100
From: Christian Brauner <brauner@kernel.org>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: ebiggers@kernel.org, hch@lst.de, fsverity@lists.linux.dev, 
	dsterba@suse.com, linux-xfs@vger.kernel.org, linux-btrfs@vger.kernel.org, 
	linux-f2fs-devel@lists.sourceforge.net, linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	viro@zeniv.linux.org.uk, jaegeuk@kernel.org, chao@kernel.org, tytso@mit.edu
Subject: Re: [PATCH v2 2/5] fsverity: add I_VERITY_BUILDING inode state flag
Message-ID: <20261119-gefunden-beteiligen-epidemie-5a23ff160ef4@brauner>
References: <20261105115532.613467-1-aalbersh@kernel.org>
 <20261105115532.613467-3-aalbersh@kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20261105115532.613467-3-aalbersh@kernel.org>

On Thu, Nov 05, 2026 at 12:55:27PM +0100, Andrey Albershteyn wrote:
> Every filesystem that supports fs-verity keeps a private runtime inode
> flag meaning Merkle tree is currently being built *_VERITY_IN_PROGRESS.
> They all serve the same two purposes: reject a concurrent enable with
> -EBUSY and let the write paths recognize the special writes done while
> the tree is under construction.
> 
> Hoist this flag into the VFS as a new inode state flag,
> I_VERITY_BUILDING, and manage its lifetime in the generic fs-verity
> enable path. The flag is set after ->begin_enable_verity() succeeds and
> cleared after ->end_enable_verity() returns (both on the success and the
> rollback paths). Add the concurrent-enable guard.
> 
> A new helper, fsverity_is_building(), is provided for filesystems to
> query the flag. No filesystem uses it yet; the per-fs flags are
> converted in following patches.
> 
> Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
> ---
>  fs/verity/enable.c       | 22 +++++++++++++++++++---
>  include/linux/fs.h       |  6 ++++++
>  include/linux/fsverity.h | 21 +++++++++++++++++++++
>  3 files changed, 46 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/verity/enable.c b/fs/verity/enable.c
> index fe8493280b77..65d3571c62b5 100644
> --- a/fs/verity/enable.c
> +++ b/fs/verity/enable.c
> @@ -229,13 +229,23 @@ static int enable_verity(struct file *filp,
>  
>  	/*
>  	 * Start enabling verity on this file, serialized by the inode lock.
> -	 * Fail if verity is already enabled or is already being enabled.
> +	 * Fail if verity is already enabled or is already being enabled. Set
> +	 * I_VERITY_BUILDING inode runtime flag which will be cleared when
> +	 * enablement succeeded or rolled back.
>  	 */
>  	inode_lock(inode);
> -	if (IS_VERITY(inode))
> +	if (IS_VERITY(inode)) {
>  		err = -EEXIST;
> -	else
> +	} else if (inode_state_read_once(inode) & I_VERITY_BUILDING) {
> +		err = -EBUSY;
> +	} else {
>  		err = vops->begin_enable_verity(filp);
> +		if (!err) {
> +			spin_lock(&inode->i_lock);
> +			inode_state_set(inode, I_VERITY_BUILDING);
> +			spin_unlock(&inode->i_lock);
> +		}
> +	}
>  	inode_unlock(inode);
>  	if (err)
>  		goto out;
> @@ -291,6 +301,9 @@ static int enable_verity(struct file *filp,
>  	 */
>  	inode_lock(inode);
>  	err = vops->end_enable_verity(filp, desc, desc_size, params.tree_size);
> +	spin_lock(&inode->i_lock);
> +	inode_state_clear(inode, I_VERITY_BUILDING);
> +	spin_unlock(&inode->i_lock);
>  	inode_unlock(inode);
>  	if (err) {
>  		fsverity_err(inode, "%ps() failed with err %d",
> @@ -317,6 +330,9 @@ static int enable_verity(struct file *filp,
>  rollback:
>  	inode_lock(inode);
>  	(void)vops->end_enable_verity(filp, NULL, 0, params.tree_size);
> +	spin_lock(&inode->i_lock);
> +	inode_state_clear(inode, I_VERITY_BUILDING);
> +	spin_unlock(&inode->i_lock);
>  	inode_unlock(inode);
>  	goto out;
>  }
> diff --git a/include/linux/fs.h b/include/linux/fs.h
> index 99caef43ff3c..7c90ce09f797 100644
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -707,6 +707,11 @@ is_uncached_acl(struct posix_acl *acl)
>   * I_LRU_ISOLATING	Inode is pinned being isolated from LRU without holding
>   *			i_count.
>   *
> + * I_VERITY_BUILDING	fs-verity is being enabled on the inode: the Merkle
> + *			tree is under construction.  The file is effectively
> + *			read-only to userspace; the only writes happening are
> + *			for the fs-verity metadata.
> + *
>   * Q: What is the difference between I_WILL_FREE and I_FREEING?
>   *
>   * __I_{SYNC,NEW,LRU_ISOLATING} are used to derive unique addresses to wait
> @@ -741,6 +746,7 @@ enum inode_state_flags_enum {
>  	I_SYNC_QUEUED		= (1U << 17),
>  	I_PINNING_NETFS_WB	= (1U << 18),
>  	I_METADATA_WRITEBACK	= (1U << 19),
> +	I_VERITY_BUILDING	= (1U << 20),
>  };
>  
>  #define I_DIRTY_INODE (I_DIRTY_SYNC | I_DIRTY_DATASYNC)
> diff --git a/include/linux/fsverity.h b/include/linux/fsverity.h
> index 61fe96ccdff6..c72edec57e30 100644
> --- a/include/linux/fsverity.h
> +++ b/include/linux/fsverity.h
> @@ -164,6 +164,22 @@ static inline bool fsverity_active(const struct inode *inode)
>  	return false;
>  }
>  
> +/**
> + * fsverity_is_building() - is fs-verity being enabled on the inode
> + * @inode: inode to check
> + *
> + * This checks whether the inode's Merkle tree is currently being built.
> + * While this is the case the file is read-only to userspace and the only writes
> + * allowed are for the fs-verity metadata. This becomes false when fsverity
> + * metadata is fully created and written to disk or building failed.
> + *
> + * Return: true if fs-verity is being enabled on the inode
> + */
> +static inline bool fsverity_is_building(const struct inode *inode)
> +{
> +	return inode_state_read_once((struct inode *)inode) & I_VERITY_BUILDING;

Isn't the fix to make inode_state_read_once() take a const struct inode *?
