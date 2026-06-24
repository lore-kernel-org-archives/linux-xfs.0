Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C7912F7F09;
	Wed, 24 Jun 2026 18:10:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782324646; cv=none; b=vEbnayhiiwbWLscJZaaSwG65beeeZyfBZquY8urBJYZBC7xsYNkd1GPkFYxsHfSmXQXBaJSqYev7w34qLWG4s2PXgUa63EGSAuRukMCj1CbeZiYAgvItW4e3cmrTA64JghK14ZosPAqQarrwaqUQ/qYueckPdIk/voughLYyN1M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782324646; c=relaxed/simple;
	bh=9dWJpIPviB3j/RcYTZiHaK2TbX3pKlfjl40No/ClBCw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QtseovkkLdxLzJ/nH/u5GASMYGX1S5NRPr0h0mAzSL5vamBcizrSf8lKqstHlYki6dN8cg7fxhT2J8giGuOTVLKP2G1qI6faCOHxEWYPQmgYAZjeyXnoySO8B7K/1am+z4hvmnP3IPN3JTKZDbKJQ+f68/s2Uv6ofhPinqOiwoo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MM961cKw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MM961cKw"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id B21E11F00A3A;
	Wed, 24 Jun 2026 18:10:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782324644;
	bh=4iAW9KN5yB1jzNrXT2p4nlwF55arryZssnvuPQN3zT4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=MM961cKwy9XhPjp8JCMcEuggeJSCkOXOx4MXvgsxG/WdsJDZ09oIPKjSWWBso9w7k
	 AhXeom+20pf2Xw83D9mBKFRTNPTJr3QpSw/OPJG2QvnjtAiPM1uwZV7uHgx/TWqR+D
	 BU3x9qSPJwoL91pe3nkzrLMloPUQlbGYdOx2mKmh6UvBahh4V/padCBRmyh0i0Hoxi
	 yycUmZzRg2mY6mhPnovNZVVpRX+IQ6nAGBSKTHvDZR46eyedzAtSjatI4OogWXApEJ
	 ZoHx82oWHm8pD3VqeeuG1aFXv/AltvebQJz51fV8bahpm0AewSA3LgaM/vMHco6Vdy
	 iPvYLCkbaAo1Q==
Date: Wed, 24 Jun 2026 11:10:44 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Kanchan Joshi <joshi.k@samsung.com>
Cc: brauner@kernel.org, hch@lst.de, dgc@kernel.org, jack@suse.cz,
	cem@kernel.org, axboe@kernel.dk, kbusch@kernel.org,
	ritesh.list@gmail.com, linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-block@vger.kernel.org,
	gost.dev@samsung.com
Subject: Re: [PATCH v3 2/6] iomap: introduce and propagate write_stream
Message-ID: <20260624181044.GW6078@frogsfrogsfrogs>
References: <20260616180555.33338-1-joshi.k@samsung.com>
 <CGME20260616181244epcas5p318804096b125c240c2155e54f76e2e07@epcas5p3.samsung.com>
 <20260616180555.33338-3-joshi.k@samsung.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260616180555.33338-3-joshi.k@samsung.com>

On Tue, Jun 16, 2026 at 11:35:51PM +0530, Kanchan Joshi wrote:
> Add a new write_stream field to struct iomap. Existing hole is used to
> place the new field.
> Propagate write_stream from iomap to bio in both direct I/O and buffered
> writeback paths.
> 
> Signed-off-by: Kanchan Joshi <joshi.k@samsung.com>
> ---
>  fs/iomap/direct-io.c  | 1 +
>  fs/iomap/ioend.c      | 3 +++
>  include/linux/iomap.h | 2 ++
>  3 files changed, 6 insertions(+)
> 
> diff --git a/fs/iomap/direct-io.c b/fs/iomap/direct-io.c
> index b36ee619cdcd..455fd5d97d25 100644
> --- a/fs/iomap/direct-io.c
> +++ b/fs/iomap/direct-io.c
> @@ -348,6 +348,7 @@ static ssize_t iomap_dio_bio_iter_one(struct iomap_iter *iter,
>  	fscrypt_set_bio_crypt_ctx(bio, iter->inode, pos, GFP_KERNEL);
>  	bio->bi_iter.bi_sector = iomap_sector(&iter->iomap, pos);
>  	bio->bi_write_hint = iter->inode->i_write_hint;
> +	bio->bi_write_stream = iter->iomap.write_stream;
>  	bio->bi_ioprio = dio->iocb->ki_ioprio;
>  	bio->bi_private = dio;
>  	bio->bi_end_io = iomap_dio_bio_end_io;
> diff --git a/fs/iomap/ioend.c b/fs/iomap/ioend.c
> index acf3cf98b23a..56ed5ba6a421 100644
> --- a/fs/iomap/ioend.c
> +++ b/fs/iomap/ioend.c
> @@ -164,6 +164,7 @@ static struct iomap_ioend *iomap_alloc_ioend(struct iomap_writepage_ctx *wpc,
>  			       GFP_NOFS, &iomap_ioend_bioset);
>  	bio->bi_iter.bi_sector = iomap_sector(&wpc->iomap, pos);
>  	bio->bi_write_hint = wpc->inode->i_write_hint;
> +	bio->bi_write_stream = wpc->iomap.write_stream;
>  	wbc_init_bio(wpc->wbc, bio);
>  	wpc->nr_folios = 0;
>  	return iomap_init_ioend(wpc->inode, bio, pos, ioend_flags);
> @@ -187,6 +188,8 @@ static bool iomap_can_add_to_ioend(struct iomap_writepage_ctx *wpc, loff_t pos,
>  	if (!(wpc->iomap.flags & IOMAP_F_ANON_WRITE) &&
>  	    iomap_sector(&wpc->iomap, pos) != bio_end_sector(&ioend->io_bio))
>  		return false;
> +	if (wpc->iomap.write_stream != ioend->io_bio.bi_write_stream)
> +		return false;
>  	/*
>  	 * Limit ioend bio chain lengths to minimise IO completion latency. This
>  	 * also prevents long tight loops ending page writeback on all the
> diff --git a/include/linux/iomap.h b/include/linux/iomap.h
> index 2c5685adf3a9..44583429ffa4 100644
> --- a/include/linux/iomap.h
> +++ b/include/linux/iomap.h
> @@ -120,6 +120,8 @@ struct iomap {
>  	u64			length;	/* length of mapping, bytes */
>  	u16			type;	/* type of mapping */
>  	u16			flags;	/* flags for mapping */
> +	u8			write_stream; /* write stream for I/O */

I'm mildly confused by the types here -- the ioctl exposes a u32, iomap
has a u8, and xfs seems to use u16.  I gather you want maximum
flexibility in the uapi and that's the reason for the u32, but can the
internal interfaces be made consistent?

I also wonder what happens if the write stream ever becomes persistent,
but this patchset doesn't go there, and maybe the programming model is
simply that you have to set it every time you open the file?

--D

> +	/* 3 bytes padding hole here */
>  	struct block_device	*bdev;	/* block device for I/O */
>  	struct dax_device	*dax_dev; /* dax_dev for dax operations */
>  	void			*inline_data;
> -- 
> 2.25.1
> 
> 
