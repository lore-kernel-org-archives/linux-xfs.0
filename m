Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.40
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794396074;
	b=un/I894xCIjQlGB0QUBQR9rnXdtJGf9j/QYbdeRfI2MVY+yrpQ1DzA7mQbKkfWutcduY
	 wc1cyj4v9ydPOj5sPEl2IBatjj/isK3HNc0paursxo/OsvYslkrWMAwsILCm0eeHo/kJl
	 dNDo0r3SoNEiax6reAi9nzvcwGBjYW0MtJsF2/tXn/nnO9NqTumZJR3Fd448PqRcnmWtW
	 qOu8+gkkSwoVmJHcdzZ8oAROmrQdOvMv+tmF/2PPQp4obZLBt3XAzHng0KrjQM65tZfMO
	 KSLMm/eSLF2CPVC5lvbkYa2rQA7LcQGAAjhmE0Bc10U5B3OvOeLs/dkVdwbNOzXntAQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794396074;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=kBXKsT9ZCsjDhkyFEPBUIYke5NN6Zkrm34ssQPKm0Vs=;
	b=Fbm8jEV7c8QMcKTQiq/Q7i6Dw7eTpv9YF9eGX9n0R5abbLEQ3/Xb12LnDruWgHT4LpUC
	 l+szKd8nXzarag1HIprg91vksFSBXQTHk8GGiYoyDWrwzGse0PfJ9qvUgSPef+kPj89bf
	 E3BXI/tZtsPNdypJ9dhqMT44JT3T82URYBXRFpizdR0n6hfK/0jZd+xVS7vWYW2SzksOg
	 EJTHMAxr1lhBy7g7XuAP76wbl9QpKfHTHlOJTI2TunAxInb1eY4s6xeqXw25sCFKRb80S
	 0TWVCjt2qBLfvGV2/4V7lLbFqZDoHivfLjBbNNwJxpsUS5C9v2o6ij8ULbQ6EAa2Jgw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=W9bvGn+y;
	arc=none smtp.remote-ip=95.215.58.40
Received: from mta1.migadu.com (out-40.mta1.migadu.com [95.215.58.40])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9564606A324
	for <linux-xfs@vger.kernel.org>; Wed, 11 Nov 2026 11:21:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B9564606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=W9bvGn+y
X-Envelope-To: linux-xfs@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=5QkVrf7bCPT9Dzg1aMldKaFYsjGVxzBELewsYgxXRuk=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794396072; v=1; x=1795000872;
 b=W9bvGn+ybcxvyekKzLezLTPjhMSTOnZLw7LxXW3Uw/+JQQy2GGLs2bbRRwluDxM6HlSPo6Xv
 UuccTQWkttyy+eqhEfrkD0ItZZLKl6PyUUjvPXtpfaR6JkSk9nR/OSSjAsR/+mTv9fRj1ypQTOw
 uL46QxgGc22BtQIW2po3IepA=
X-Envelope-To: linux-xfs@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 3defb7f018b5929e;
	Wed, 11 Nov 2026 11:21:11 +0000
X-Mizu-Trace-ID: 3defb7f018b5929e
X-Migadu-Flow: FLOW_OUT
Date: Wed, 11 Nov 2026 12:21:07 +0100
From: "Pankaj Raghav (Samsung)" <pankaj.raghav@linux.dev>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 02/25] iomap: add support for data checksumming
Message-ID: <avRO_O8jx3zrccGq@quentin>
References: <20261104085929.317544-1-hch@lst.de>
 <20261104085929.317544-3-hch@lst.de>
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261104085929.317544-3-hch@lst.de>

On Wed, Nov 04, 2026 at 09:57:06AM +0100, Christoph Hellwig wrote:
> Add a new refcounted structure for a data checksum attached to

I don't see any new refcounted structure. Probably the commit message is
stale?

> an iomap_ioend, and helpers to allocate, split and access it.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
>  
>  /*
>   * Flags that if set on either ioend prevent the merge of two ioends.
> @@ -522,14 +529,31 @@ static inline u16 iomap_ioend_flags(const struct iomap *iomap)
>  struct iomap_ioend {
>  	struct list_head	io_list;	/* next ioend in chain */
>  	u16			io_flags;	/* IOMAP_IOEND_* */
> +	u8			io_csum_shift;	/* ilog(2) of csum size */
>  	u32			io_bvec_offset;	/* offset into first bvec */
>  	struct inode		*io_inode;	/* file being written to */
>  	size_t			io_size;	/* size of the extent */
>  	atomic_t		io_remaining;	/* completetion defer count */
>  	int			io_error;	/* stashed away status */
> -	struct iomap_ioend	*io_parent;	/* parent for completions */
> +
> +	/*
> +	 * There are two kinds of ioend, the original ones submitted by iomap,
> +	 * and thus split of for I/O size limitations.  For the latter,

s/thus split of/those split off

> +	 * io_parent points to the original ioend.  For the original ioends,
> +	 * the space used by the parent pointer is reused by the checksum
> +	 * pointer when data checksum are used.  Split ioends always point
> +	 * into the original allocation with their io_csum pointer.  As a
> +	 * special case tiny checksum use the pointer as actual checksum
> +	 * storage if that fits.
> +	 */
> +	union {
> +		struct iomap_ioend *io_parent;	/* parent for completions */
> +		void		*io_csum_alloc; /* original csum allocation. */
> +		u8		io_csum_inline[sizeof(void *)];
> +	};
>  	loff_t			io_offset;	/* offset in the file */
>  	sector_t		io_sector;	/* start sector of ioend */
> +	void			*io_csum;	/* data checksum */
>  	void			*io_private;	/* file system private data */
>  	struct fsverity_info	*io_vi;		/* fsverity info */
>  	struct bio		io_bio;		/* MUST BE LAST! */
> @@ -547,6 +571,22 @@ static inline struct iomap_ioend *iomap_ioend_from_bio(struct bio *bio)
>  	.bi_offset	= (_ioend)->io_bvec_offset,	\
>  }
>  

-- 
Pankaj
