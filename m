Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42E7E389472
	for <linux-xfs@vger.kernel.org>; Mon, 13 Jul 2026 22:55:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783983327; cv=none; b=CqRBgh1IUmdqJ0wGasvCJ4uU60ZX4xSlekbCOQBbJRJaSc8YuHeLeuRA24chqYY3CUmhQ+z7E59uwSfuYMml8fMMHF1tDtPCOZSatQm6QjAZYXab8zrQRlXHEotXjpGozS08aT2Xkv1obgMEJtlcdx9fnq76UVfH3mJ6IoDIolU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783983327; c=relaxed/simple;
	bh=eINDxY63NyC5j4LUx8npQ6NR13i9oYPath9HiK4MYgc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=M6OVAgPvHhRnAMzgs9L3hYGCdfegSuE0nUdpiMePhKkqE3WruVSg/ot7I32+mar/g1RokfLkfZkOvAgiM3Uhvh51YM7O4sy+xMGgurQBj4dQhAwXFDVqodmYausL1dtF4Jj6Ell9pUOvPdpqLsqWlfRf7JtXr5iTdyx54DnxV0s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Rleqq3vJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Rleqq3vJ"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id D42C11F000E9;
	Mon, 13 Jul 2026 22:55:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783983325;
	bh=Sy+JQqtUHVoxEcGjLtwWnVSSSoUDBWRncqbNt5uWVMs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Rleqq3vJy2K9neuw9CqVDYtYqRZ2WvfcJKdQNbpGTeoCs6rQ3BN07S0pz7LzhFgkY
	 gU5u0d9tdmkkh5pwixvT54aekiJ55VTuXI/0ZKgCk2YMhcTzDIxfC22PiSrER/hPMn
	 9eWeZp/6px9M8XnRETz5YysEr1yZGQYnTzTdQqmFzzY+ETwTRedbE2haqwI/Teuu2o
	 h7IZJRZSNtBN3C/j6GQaBioBGu7L5MeIzfXtMXHZoRdAA1zJ8KudeAAc2vb8rOAe0N
	 +cUh2b6U77EanwxyTmZRcBCWtzc5hQs/ano2vKOmx1C+oJempxwJuswHF/h9JDfaD6
	 cYcAlAd00FRDQ==
Date: Mon, 13 Jul 2026 15:55:25 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Cc: linux-xfs@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>,
	Damien Le Moal <dlemoal@kernel.org>
Subject: Re: [PATCH v2 4/4] xfs: mark internal metadir file creation helpers
 static
Message-ID: <20260713225525.GL7195@frogsfrogsfrogs>
References: <20260713124250.3978-1-johannes.thumshirn@wdc.com>
 <20260713124250.3978-5-johannes.thumshirn@wdc.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260713124250.3978-5-johannes.thumshirn@wdc.com>

On Mon, Jul 13, 2026 at 02:42:50PM +0200, Johannes Thumshirn wrote:
> Now that there is xfs_metadir_create_file() mark
> xfs_metadir_start_create(), xfs_metadir_create() and xfs_metadir_cancel()
> as static and remove them from xfs_metadir.h.
> 
> Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>

Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  fs/xfs/libxfs/xfs_metadir.c | 6 +++---
>  fs/xfs/libxfs/xfs_metadir.h | 4 ----
>  2 files changed, 3 insertions(+), 7 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_metadir.c b/fs/xfs/libxfs/xfs_metadir.c
> index 0d6a153bc9e9..7c6b086b73db 100644
> --- a/fs/xfs/libxfs/xfs_metadir.c
> +++ b/fs/xfs/libxfs/xfs_metadir.c
> @@ -182,7 +182,7 @@ xfs_metadir_teardown(
>   * Begin the process of creating a metadata file by allocating transactions
>   * and taking whatever resources we're going to need.
>   */
> -int
> +static int
>  xfs_metadir_start_create(
>  	struct xfs_metadir_update	*upd)
>  {
> @@ -236,7 +236,7 @@ xfs_metadir_start_create(
>   * a negative error code.  If an inode is passed back, the caller must finish
>   * setting up the inode before releasing it.
>   */
> -int
> +static int
>  xfs_metadir_create(
>  	struct xfs_metadir_update	*upd,
>  	umode_t				mode)
> @@ -425,7 +425,7 @@ xfs_metadir_commit(
>  }
>  
>  /* Cancel a metadir update and unlock/drop all resources. */
> -void
> +static void
>  xfs_metadir_cancel(
>  	struct xfs_metadir_update	*upd,
>  	int				error)
> diff --git a/fs/xfs/libxfs/xfs_metadir.h b/fs/xfs/libxfs/xfs_metadir.h
> index a795a2d0e3fe..e434b9d1c932 100644
> --- a/fs/xfs/libxfs/xfs_metadir.h
> +++ b/fs/xfs/libxfs/xfs_metadir.h
> @@ -32,9 +32,6 @@ int xfs_metadir_load(struct xfs_trans *tp, struct xfs_inode *dp,
>  		const char *path, enum xfs_metafile_type metafile_type,
>  		struct xfs_inode **ipp);
>  
> -int xfs_metadir_start_create(struct xfs_metadir_update *upd);
> -int xfs_metadir_create(struct xfs_metadir_update *upd, umode_t mode);
> -
>  typedef int (*xfs_metadir_createfn)(struct xfs_metadir_update *upd, void *priv);
>  
>  int xfs_metadir_create_file(struct xfs_metadir_update *upd, umode_t mode,
> @@ -45,7 +42,6 @@ int xfs_metadir_start_link(struct xfs_metadir_update *upd);
>  int xfs_metadir_link(struct xfs_metadir_update *upd);
>  
>  int xfs_metadir_commit(struct xfs_metadir_update *upd);
> -void xfs_metadir_cancel(struct xfs_metadir_update *upd, int error);
>  
>  int xfs_metadir_mkdir(struct xfs_inode *dp, const char *path,
>  		struct xfs_inode **ipp);
> -- 
> 2.54.0
> 
> 
