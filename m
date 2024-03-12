Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E96441E48C;
	Tue, 12 Mar 2024 14:51:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710255099; cv=none; b=NA3SNeRalNx8gNkivO1tONsYSyeuKtUJgh3XkaDS9yFt2SLZXM0Quj+55ODnOhAGExKHLdoYkUVLt8+JoKMQmRk/svBdydjUZ1wXvKTGyDkQw0qQ27oj0iRZuwMqaNJkao7uu4yzVJrzQBlX74D9/bGYOOULJtayZOhPkO+mlxs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710255099; c=relaxed/simple;
	bh=n0TYN4RvuzeQqnNR/vv0ZdbV8Ix0JgbwOfvQ3mcDu7Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=p9TVulQ0+5VrGSXh6W6TdqzxANCfEaLPMnbkwDuCYs4/cc3TQ37mTMqbBqSk1Y6mpe09u+RvqcqxtEQqQF1ejjOoxv1x71avyitpngPwaz/7zNHTGxUofa8LsZ2c9pqWa4nGLDU6J4MQChgvR/iTY+pUzr80A8ng/da6BEkd8ek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=S8u0Ho8A; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="S8u0Ho8A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09A58C433C7;
	Tue, 12 Mar 2024 14:51:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1710255098;
	bh=n0TYN4RvuzeQqnNR/vv0ZdbV8Ix0JgbwOfvQ3mcDu7Y=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=S8u0Ho8AbaZNPjM11cS15TedAW9WeOIWLQgS0Rb87I5ZdB6vFzp7l9USSdrSULAee
	 kLz9TXFZvZqTkLA8ovfQ2O0rNApC392+3lv1BNxNIoxxsLX2ULaRDeF2r5UPsjNEIg
	 dsaBrBAIl92m4d69nKNt4+9EDmqc1UQ3cPGCj//NTrWwljiEPfaGHIJlXjXtK/E6T+
	 PCitxrxv4VWFaKe1SEeGWUrG1X3EDKcR+jBrdZ8lTPfNUQmLyI9oOj4Hvx1U6LbV5J
	 Cmc1qtgCIFWWop9ZMdO4sl1UxcW7hhDaL5/HFHOO8lBXWXzOFTeYNSN5PQjEaNjquy
	 D4l3wRVTtHm4A==
Date: Tue, 12 Mar 2024 08:51:35 -0600
From: Keith Busch <kbusch@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, Chandan Babu R <chandanbabu@kernel.org>,
	linux-block@vger.kernel.org, linux-nvme@lists.infradead.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/5] block: add a bio_chain_and_submit helper
Message-ID: <ZfBr91m4oQS_VYFg@kbusch-mbp.mynextlight.net>
References: <20240312144532.1044427-1-hch@lst.de>
 <20240312144532.1044427-3-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240312144532.1044427-3-hch@lst.de>

On Tue, Mar 12, 2024 at 08:45:28AM -0600, Christoph Hellwig wrote:
> +struct bio *bio_chain_and_submit(struct bio *prev, struct bio *new)
>  {
> -	struct bio *new = bio_alloc(bdev, nr_pages, opf, gfp);
> -
> -	if (bio) {
> -		bio_chain(bio, new);
> -		submit_bio(bio);
> +	if (prev) {
> +		bio_chain(prev, new);
> +		submit_bio(prev);
>  	}
> -
>  	return new;
>  }
> +EXPORT_SYMBOL_GPL(bio_chain_and_submit);
> +
> +struct bio *blk_next_bio(struct bio *bio, struct block_device *bdev,
> +		unsigned int nr_pages, blk_opf_t opf, gfp_t gfp)
> +{
> +	return bio_chain_and_submit(bio, bio_alloc(bdev, nr_pages, opf, gfp));
> +}

I realize you're not changing any behavior here, but I want to ask, is
bio_alloc() always guaranteed to return a valid bio? It sure looks like
it can return NULL under some uncommon conditions, but I can't find
anyone checking the result. So I guess it's safe?
