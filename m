Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42B683FCB1C;
	Fri, 16 Oct 2026 20:26:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792182397; cv=none; b=mq0V0a+LbaxN4VgU/zSZi1hNrHsk/o2UJwd7hVmI6gtcbV77Sv32g4mxmHPaAMmAMQjV2yH9qVeuZ4c2K6kafdHRlS2aw2WIxybq9A3yQwfcm7PW78HwquPcBvwsiVbzoj78X1irvrBOCBgK/ldw8+YeqouelzDH0ukjaUOH7gA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792182397; c=relaxed/simple;
	bh=YdPMipidByITQ1l4lHkkLO1ayK8wNcYCVpL4gJcYRhk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=I8WdTE1MdCRhBmptgPfoDmT0zrAPZPZbjUz3/cDY1/yq94+0+Kv2mSd0WLSxQLZ+HL8EXmoOex4yiwjUP609tNo1D5fmlkc7QnxdOBqkxU4EIFYMHqsoM4WZz9nb27gCJH4DPrk5bw0okWuT/iAhSDc49yF2whB3ogkaaEWjUHs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=R7Kxco08; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="R7Kxco08"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id C8DC11F000C4;
	Fri, 16 Oct 2026 20:26:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792182395;
	bh=RtM7QZ40GAUC8iNV3TvPo6m3j0fEG8GRiol+edvRkUw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=R7Kxco08dzkXRsAYxQuOHHvS+7lptjjWPHYV9E8Cn/ZOAH+zIJrxgOSrCHtCteMZN
	 nZgRso//YLFtXbN0Amb1iK3YUkeL/AfbaLDBxPACEH/WXcu55wwosh8fX/TJBYlduv
	 9c4GKpWjoYZ1tQ9RoIzs6hy0WtU2U2pO03mJuclOWWf+7KMJs6+g3Qgnil8f+8tRFL
	 0ydj145WxRFtzVEJ2IvYXSR5PD6wk9D2cA9XiRs8ZqQPxhX1LPoGa8hyQiiBu2ZgL6
	 lmnEEKisEaxfPrXU0Og7fm+Pski2PyQdBg2VL98+Wnqw4nmIk8IPZ8IvWPlv+iaABB
	 +Qm/gIfHnmcTA==
Date: Fri, 16 Oct 2026 13:26:35 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Kanchan Joshi <joshi.k@samsung.com>
Cc: brauner@kernel.org, hch@lst.de, dgc@kernel.org, cem@kernel.org,
	jack@suse.cz, axboe@kernel.dk, kbusch@kernel.org,
	linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	gost.dev@samsung.com, Anuj Gupta <anuj20.g@samsung.com>
Subject: Re: [PATCH v6 3/8] fs: add i_write_stream, exclusive with the write
 life time hint
Message-ID: <20261016202635.GK107986@frogsfrogsfrogs>
References: <20261015063246.103433-1-joshi.k@samsung.com>
 <CGME20261015063432epcas5p2a31bc0518d759cefee79673fd27dd0ce@epcas5p2.samsung.com>
 <20261015063246.103433-4-joshi.k@samsung.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261015063246.103433-4-joshi.k@samsung.com>

On Thu, Oct 15, 2026 at 12:02:41PM +0530, Kanchan Joshi wrote:
> Keep the attached stream id in the VFS inode rather than the
> filesystem's own, so that fcntl_set_rw_hint() can see it. It is a u16 in
> the 32-bit hole after i_state, so struct inode does not grow on 64-bit.
> 
> Suggested-by: Christoph Hellwig <hch@lst.de>
> Suggested-by: Darrick J. Wong <djwong@kernel.org>
> Signed-off-by: Kanchan Joshi <joshi.k@samsung.com>
> Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
> ---
>  fs/fcntl.c         | 7 +++++++
>  fs/inode.c         | 1 +
>  include/linux/fs.h | 2 +-
>  3 files changed, 9 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/fcntl.c b/fs/fcntl.c
> index 9b71bc9d71d1..271ff8f61354 100644
> --- a/fs/fcntl.c
> +++ b/fs/fcntl.c
> @@ -383,7 +383,14 @@ static long fcntl_set_rw_hint(struct file *file, unsigned long arg)
>  	if (!rw_hint_valid(hint))
>  		return -EINVAL;
>  
> +	/* keep write stream and write life time hint mutually exclusive */
> +	spin_lock(&inode->i_lock);
> +	if (hint != WRITE_LIFE_NOT_SET && READ_ONCE(inode->i_write_stream)) {
> +		spin_unlock(&inode->i_lock);
> +		return -EBUSY;
> +	}
>  	WRITE_ONCE(inode->i_write_hint, hint);
> +	spin_unlock(&inode->i_lock);
>  
>  	/*
>  	 * file->f_mapping->host may differ from inode. As an example,
> diff --git a/fs/inode.c b/fs/inode.c
> index a9d37be390a1..3bc0251230c0 100644
> --- a/fs/inode.c
> +++ b/fs/inode.c
> @@ -246,6 +246,7 @@ int inode_init_always_gfp(struct super_block *sb, struct inode *inode, gfp_t gfp
>  	atomic_set(&inode->i_writecount, 0);
>  	inode->i_size = 0;
>  	inode->i_write_hint = WRITE_LIFE_NOT_SET;
> +	inode->i_write_stream = 0;

/me wonders if this should be WRITE_STREAM_NOT_SET...

--D

>  	inode->i_blocks = 0;
>  	inode->i_bytes = 0;
>  	inode->i_generation = 0;
> diff --git a/include/linux/fs.h b/include/linux/fs.h
> index deb411e86661..ae91cb93eab6 100644
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -812,7 +812,7 @@ struct inode {
>  
>  	/* Misc */
>  	struct inode_state_flags i_state;
> -	/* 32-bit hole */
> +	u16			i_write_stream;
>  	struct rw_semaphore	i_rwsem;
>  
>  	unsigned long		dirtied_when;	/* jiffies of first dirtying */
> -- 
> 2.25.1
> 
> 
