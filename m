Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10CD63E2ABA;
	Thu, 25 Jun 2026 17:27:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782408462; cv=none; b=ErgRXlf1bWU/n9wDrqZPba+SvbnT/hkzGeRBytK7b13oEpRD9gXGPTjpep6OOj/W6mBlrJXTuZoOjRpJuYJf+my5M5sL1ULmJUq3lDcLDfCH89K52VpV4ggqsFHoOeS9vfldh/69ZZ1B5RE4ikWiz5Bq3flk1N+MKozIfEY3Vdo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782408462; c=relaxed/simple;
	bh=hbOYVXEEyUmHQJY81f3ZxGxpuaEmNUlAOvAbpCFN5yg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=H2VInoPrgyyuaDKefSznPWkHkzL0fVoWXlCnsui/QwTveWI61a4dcJiEND2Mf5WeH5WNEhx7WjZm63KgCVnjTa2AXmukOqVWlbRpCtZLA9L6AoqZTtaXd2ETj1X5cjTQ40ielLpTt1FTFry8mjtrDzcd0o2JheLQZrYGQ49lpsI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iETBEHN+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iETBEHN+"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 9E6981F00A3D;
	Thu, 25 Jun 2026 17:27:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782408460;
	bh=tvuLwEQoSIdOrb203mC98VZ//kFDZO0IRJjscdA56ZQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=iETBEHN+38kSAJ3JIL3Qq/rSXmiT7OPU4aYA8tl8c0dE8Lv/owV2YCuBjNrvAPN3O
	 WjAa2ZhVko/j4rwJj2yX1UqXmy20zln/zPevRSO+M7SF2NjwXRSJecpUHR9QpA6ZhE
	 BWrsgrIt9MCuNfTf4xG7eSC5HjRU74eJf8TrzAivA2PrBOpDg2K8Pd2rYSuIejsa+J
	 kNjlMsey0+l/9zrhyvpeAk97s4BCmvS2AGj4ByxpfKmS4ufngvTBtJ5EBfGGev3/WL
	 ta/UsPme0xV9Hy+lgtJ/AUHvEDMbg0Tui3Z/9iJTka8YxVLsuiieVWlCRnTyZGjR6Y
	 3YUaLfHUGLZ+A==
Date: Thu, 25 Jun 2026 10:27:40 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Christian Brauner <brauner@kernel.org>, Kelu Ye <yekelu1@huawei.com>,
	Yifan Zhao <zhaoyifan28@huawei.com>,
	Ritesh Harjani <ritesh.list@gmail.com>,
	Joanne Koong <joannelkoong@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sungjong Seo <sj1557.seo@samsung.com>,
	Hyunchul Lee <hyc.lee@gmail.com>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Miklos Szeredi <miklos@szeredi.hu>, fuse-devel@lists.linux.dev,
	ntfs3@lists.linux.dev, linux-erofs@lists.ozlabs.org,
	linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 1/2] iomap: consolidate bio submission
Message-ID: <20260625172740.GD6078@frogsfrogsfrogs>
References: <20260625120803.2462291-1-hch@lst.de>
 <20260625120803.2462291-2-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260625120803.2462291-2-hch@lst.de>

On Thu, Jun 25, 2026 at 02:07:56PM +0200, Christoph Hellwig wrote:
> Add a iomap_bio_submit_read_endio helper factored out of
> iomap_bio_submit_read to that all ->submit_read implementations for
> iomap_read_ops that use iomap_bio_read_folio_range can shared the
> logic.
> 
> Right now that logic is mostly trivial, but already has a bug for XFS
> because the XFS version is too trivial:  file system integrity validation
> needs a workqueue context and thus can't happen from the default iomap
> bi_end_io I/O handler.  Unfortunately the iomap refactoring just before
> fs integrity landed moved code around here and the call go misplaced,
> meaning it never got called.  The PI information still is verified by
> the block layer, but the offloading is less efficient (and the future
> userspace interface can't get at it).
> 
> Fixes: 0b10a370529c ("iomap: support T10 protection information")
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/exfat/iomap.c      |  5 +----
>  fs/iomap/bio.c        | 13 ++++++++++---
>  fs/ntfs/aops.c        |  6 ++----
>  fs/ntfs3/inode.c      |  5 +----
>  fs/xfs/xfs_aops.c     |  3 +--
>  include/linux/iomap.h |  2 ++
>  6 files changed, 17 insertions(+), 17 deletions(-)
> 
> diff --git a/fs/exfat/iomap.c b/fs/exfat/iomap.c
> index 1aac38e63fe6..190fc6471f84 100644
> --- a/fs/exfat/iomap.c
> +++ b/fs/exfat/iomap.c
> @@ -253,10 +253,7 @@ static void exfat_iomap_read_end_io(struct bio *bio)
>  static void exfat_iomap_bio_submit_read(const struct iomap_iter *iter,
>  		struct iomap_read_folio_ctx *ctx)
>  {
> -	struct bio *bio = ctx->read_ctx;
> -
> -	bio->bi_end_io = exfat_iomap_read_end_io;
> -	submit_bio(bio);
> +	iomap_bio_submit_read_endio(iter, ctx, exfat_iomap_read_end_io);
>  }
>  
>  const struct iomap_read_ops exfat_iomap_bio_read_ops = {
> diff --git a/fs/iomap/bio.c b/fs/iomap/bio.c
> index 4504f4633f17..0f31e35567b4 100644
> --- a/fs/iomap/bio.c
> +++ b/fs/iomap/bio.c
> @@ -78,15 +78,23 @@ u32 iomap_finish_ioend_buffered_read(struct iomap_ioend *ioend)
>  	return __iomap_read_end_io(&ioend->io_bio, ioend->io_error);
>  }
>  
> -static void iomap_bio_submit_read(const struct iomap_iter *iter,
> -		struct iomap_read_folio_ctx *ctx)
> +void iomap_bio_submit_read_endio(const struct iomap_iter *iter,
> +		struct iomap_read_folio_ctx *ctx, bio_end_io_t end_io)
>  {
>  	struct bio *bio = ctx->read_ctx;
>  
> +	bio->bi_end_io = end_io;
>  	if (iter->iomap.flags & IOMAP_F_INTEGRITY)
>  		fs_bio_integrity_alloc(bio);

Ah, so the bug here is that all the pagecache readers should have been
allocating integrity information for the bio before submitting it?  And
because it doesn't, iomap_finish_ioend won't do the read verification?
So the block layer does it for us, and that's why we don't use the ioend
chaining?  And (I guess) the future userspace interface won't have any
means to get at the integrity data?

If the answers to all four questions is "yes" then I've understood this
fix well enough to declare

Cc: <stable@vger.kernel.org> # v7.1
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>


--D

>  	submit_bio(bio);
>  }
> +EXPORT_SYMBOL_GPL(iomap_bio_submit_read_endio);
> +
> +static void iomap_bio_submit_read(const struct iomap_iter *iter,
> +		struct iomap_read_folio_ctx *ctx)
> +{
> +	return iomap_bio_submit_read_endio(iter, ctx, iomap_read_end_io);
> +}
>  
>  static struct bio_set *iomap_read_bio_set(struct iomap_read_folio_ctx *ctx)
>  {
> @@ -127,7 +135,6 @@ static void iomap_read_alloc_bio(const struct iomap_iter *iter,
>  	if (ctx->rac)
>  		bio->bi_opf |= REQ_RAHEAD;
>  	bio->bi_iter.bi_sector = iomap_sector(iomap, iter->pos);
> -	bio->bi_end_io = iomap_read_end_io;
>  	bio_add_folio_nofail(bio, folio, plen,
>  			offset_in_folio(folio, iter->pos));
>  	ctx->read_ctx = bio;
> diff --git a/fs/ntfs/aops.c b/fs/ntfs/aops.c
> index 1fbf832ad165..f2bb56506046 100644
> --- a/fs/ntfs/aops.c
> +++ b/fs/ntfs/aops.c
> @@ -38,11 +38,9 @@ static void ntfs_iomap_read_end_io(struct bio *bio)
>  }
>  
>  static void ntfs_iomap_bio_submit_read(const struct iomap_iter *iter,
> -	struct iomap_read_folio_ctx *ctx)
> +		struct iomap_read_folio_ctx *ctx)
>  {
> -	struct bio *bio = ctx->read_ctx;
> -	bio->bi_end_io = ntfs_iomap_read_end_io;
> -	submit_bio(bio);
> +	iomap_bio_submit_read_endio(iter, ctx, ntfs_iomap_read_end_io);
>  }
>  
>  static const struct iomap_read_ops ntfs_iomap_bio_read_ops = {
> diff --git a/fs/ntfs3/inode.c b/fs/ntfs3/inode.c
> index 42af1abe17f8..f9600aba1548 100644
> --- a/fs/ntfs3/inode.c
> +++ b/fs/ntfs3/inode.c
> @@ -609,10 +609,7 @@ static void ntfs_iomap_read_end_io(struct bio *bio)
>  static void ntfs_iomap_bio_submit_read(const struct iomap_iter *iter,
>  		struct iomap_read_folio_ctx *ctx)
>  {
> -	struct bio *bio = ctx->read_ctx;
> -
> -	bio->bi_end_io = ntfs_iomap_read_end_io;
> -	submit_bio(bio);
> +	iomap_bio_submit_read_endio(iter, ctx, ntfs_iomap_read_end_io);
>  }
>  
>  static const struct iomap_read_ops ntfs_iomap_bio_read_ops = {
> diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
> index 2a0c54256e93..51293b6f331f 100644
> --- a/fs/xfs/xfs_aops.c
> +++ b/fs/xfs/xfs_aops.c
> @@ -764,8 +764,7 @@ xfs_bio_submit_read(
>  
>  	/* defer read completions to the ioend workqueue */
>  	iomap_init_ioend(iter->inode, bio, ctx->read_ctx_file_offset, 0);
> -	bio->bi_end_io = xfs_end_bio;
> -	submit_bio(bio);
> +	iomap_bio_submit_read_endio(iter, ctx, xfs_end_bio);
>  }
>  
>  static const struct iomap_read_ops xfs_iomap_read_ops = {
> diff --git a/include/linux/iomap.h b/include/linux/iomap.h
> index 3582ed1fe236..56b43d594e6e 100644
> --- a/include/linux/iomap.h
> +++ b/include/linux/iomap.h
> @@ -622,6 +622,8 @@ extern struct bio_set iomap_ioend_bioset;
>  #ifdef CONFIG_BLOCK
>  int iomap_bio_read_folio_range(const struct iomap_iter *iter,
>  		struct iomap_read_folio_ctx *ctx, size_t plen);
> +void iomap_bio_submit_read_endio(const struct iomap_iter *iter,
> +		struct iomap_read_folio_ctx *ctx, bio_end_io_t end_io);
>  
>  extern const struct iomap_read_ops iomap_bio_read_ops;
>  
> -- 
> 2.53.0
> 
> 
