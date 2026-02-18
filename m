Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A9EE2ECEA3;
	Wed, 18 Feb 2026 21:41:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771450899; cv=none; b=WHPwQ7Ilq0sygjhtSJUYVGga/cXMGn7JVKzOHya60TTULl8yANtnj34uqYJvCd9vlwI9txVB5Uo3uFJDw3xz0Fc6znANfsLXPQA4KC3VVUYOnVxOL8N118t/ClnHGX+bsFkxOIU+KIrVpRkBNIWxolwBPuAOfBCsFyNrtEnZpjA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771450899; c=relaxed/simple;
	bh=RFNByzUvaO7u/JH30zuOuIX6qfJNT+tkJE4Yzso8fZc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Vyk1HYVHNYVTesHh2JZfwJtgL6eISjQICUWyNDbMdj1FjWYAVkOqbrGgD6SSuCMBYNYl+V3T+wNSORuGqe87ZLfSZXkFj5ryf9v0X9UejrkVVEH4pJUIHv2em3ZhaRfEBzvOwrp2BCuPKoINWSCOxRZoByW76Y9Yz+5An8MZyFs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=m4Of8Yqh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="m4Of8Yqh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C704C116D0;
	Wed, 18 Feb 2026 21:41:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771450899;
	bh=RFNByzUvaO7u/JH30zuOuIX6qfJNT+tkJE4Yzso8fZc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=m4Of8YqhzIVyWXNu6Hwkb5MEEgEcCMgafizlvxIB3AJDAkQifU6GyUCV/Mg9leJCU
	 SmG+YK3+ri51vIUo9GtpOiBdXMca/kXqIr2jsDHCYeEQ9o5S87jveALWqXtfM9zV7o
	 u+nQCnB7P6Zp0b1CSTNMPe5gC8nYbO62VRsA/ktouhUwOpbNZQq2IvZ8diD9K/NA+w
	 bdkTkW7G6HRSD/nyXx5dGcDyd/PiZtZ2GU/ttb5xxyf6LNxc/rABJhLfqyPb6ZlBUQ
	 EJig6T4tOvJ3B1T23GYBIiKaOC/Oz9gs2tXQ0KRiF+YijViCB8CvtYrsf874DU20Di
	 uXyKaLnlTlX8A==
Date: Wed, 18 Feb 2026 13:41:38 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: linux-xfs@vger.kernel.org, fsverity@lists.linux.dev,
	linux-fsdevel@vger.kernel.org, ebiggers@kernel.org, hch@lst.de
Subject: Re: [PATCH v3 02/35] fsverity: expose ensure_fsverity_info()
Message-ID: <20260218214138.GB6467@frogsfrogsfrogs>
References: <20260217231937.1183679-1-aalbersh@kernel.org>
 <20260217231937.1183679-3-aalbersh@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260217231937.1183679-3-aalbersh@kernel.org>

On Wed, Feb 18, 2026 at 12:19:02AM +0100, Andrey Albershteyn wrote:
> This function will be used by XFS's scrub to force fsverity activation,
> therefore, to read fsverity context.
> 
> Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>

Looks fine to me
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  fs/verity/open.c         | 5 +++--
>  include/linux/fsverity.h | 7 +++++++
>  2 files changed, 10 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/verity/open.c b/fs/verity/open.c
> index dfa0d1afe0fe..0483db672526 100644
> --- a/fs/verity/open.c
> +++ b/fs/verity/open.c
> @@ -344,7 +344,7 @@ int fsverity_get_descriptor(struct inode *inode,
>  	return 0;
>  }
>  
> -static int ensure_verity_info(struct inode *inode)
> +int fsverity_ensure_verity_info(struct inode *inode)
>  {
>  	struct fsverity_info *vi = fsverity_get_info(inode), *found;
>  	struct fsverity_descriptor *desc;
> @@ -380,12 +380,13 @@ static int ensure_verity_info(struct inode *inode)
>  	kfree(desc);
>  	return err;
>  }
> +EXPORT_SYMBOL_GPL(fsverity_ensure_verity_info);
>  
>  int __fsverity_file_open(struct inode *inode, struct file *filp)
>  {
>  	if (filp->f_mode & FMODE_WRITE)
>  		return -EPERM;
> -	return ensure_verity_info(inode);
> +	return fsverity_ensure_verity_info(inode);
>  }
>  EXPORT_SYMBOL_GPL(__fsverity_file_open);
>  
> diff --git a/include/linux/fsverity.h b/include/linux/fsverity.h
> index d8b581e3ce48..16740a331020 100644
> --- a/include/linux/fsverity.h
> +++ b/include/linux/fsverity.h
> @@ -202,6 +202,7 @@ int fsverity_get_digest(struct inode *inode,
>  /* open.c */
>  
>  int __fsverity_file_open(struct inode *inode, struct file *filp);
> +int fsverity_ensure_verity_info(struct inode *inode);
>  
>  /* read_metadata.c */
>  
> @@ -288,6 +289,12 @@ static inline void fsverity_enqueue_verify_work(struct work_struct *work)
>  	WARN_ON_ONCE(1);
>  }
>  
> +static inline int fsverity_ensure_verity_info(struct inode *inode)
> +{
> +	WARN_ON_ONCE(1);
> +	return -EOPNOTSUPP;
> +}
> +
>  #endif	/* !CONFIG_FS_VERITY */
>  
>  static inline bool fsverity_verify_folio(struct fsverity_info *vi,
> -- 
> 2.51.2
> 
> 
