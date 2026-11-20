Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795165482;
	b=Vvz17fu8Fc46E/n5SRfgVjKff6GrOODqSO7Qrs46vDxQa8uyI/tdB0FOfoexkLoCR8Ov
	 UYtv89DGuznjPVZ4CDDLIrSlHMUJWHg7Mo2M5R7ya0/hEPOP+63BCnqwp1flj6pQCJ/qk
	 c7dknDcsuRlxnuEWgyWdHZUUZYuRZ1OVUItNi8nWqQRCnfDvPL2Ur4FKHB9ytrSvWa0xX
	 TTO2lMU2GLBfgZn2AIB4NCp9TeY2793gEn+muFAU1F9KbpPUVPzuqFT6lLRsJQwKBh7IV
	 /mX+7LCwfcBFqsXFCQb5gntTyzd1T4L3oJP0vuJf8syJltWo0GDF8C7UubkgMWcJR1g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795165482;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=0i1q7QXoQpyw7U+kbS9CbTzSUpFctyuEhoMiaekUXV0=;
	b=N7qyMagp6UgA648wmNwEaXsOOq54zqx6kr5iDOkHkXOiwUDGjlglyL0MunKKyQEiOMrq
	 RDPc6ZMlgKuTioB88HXuyQoqLVd4pXXyowr63URTTJmMN87RHI4axn06RGL5G+PHPeA0y
	 jSrLkm7q/7DbeQ46GUeLEMvgvF26lfJvSLKcMQ7zkhTGeNx8il6TRXd6gvnxlMxDy2lYo
	 idmG4H0Wkjt0j+nrQNU1ipxCDwLEQKFdHjHfuVvEILyuO4YBPrvuSJULuzualtAMqBZ6K
	 tH9dO6iAy7ltod4bMrFS6XxjZYXSe9gDfsPcOEiQqd9KKk28W2ssj5l9Tmbe61TZwuA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=IhrGSlie;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C2E6606A333;
	Fri, 20 Nov 2026 09:04:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=IhrGSlie
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C384A1F000C6;
	Fri, 20 Nov 2026 09:04:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795165481;
	bh=0i1q7QXoQpyw7U+kbS9CbTzSUpFctyuEhoMiaekUXV0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=IhrGSlieICNdpQD+S2EFBPZbistZAhe5LomuJdvVVJj61IRoirzeBTM3qemoO3lT9
	 GqcetHnecqBmRhrcqPij5z1BQxNa1TyVn1qfoBM1Gyb1w3ztBVQlo1I0YcFSgX45yn
	 ke2ZY7lMRlDk0uJpweHBGJ9TjQc2t57B+g5DSUWxzvfgc205/yGI8O7A1MA1zuUHUo
	 2LgFe1yV6EBsqFLvqu3Fj26GWae9y28vu9qeGXs5KjD2BC6XZeeiAIGLH9Eey8NKjB
	 hQen8Th96khGc/3hFyKwHZEA2+1KYvbMQuvnh6W7Vdm5dOXC8itUEuHsN2Ri35Ownd
	 8lPa2Yq34KlmQ==
Date: Fri, 20 Nov 2026 10:04:37 +0100
From: Christian Brauner <brauner@kernel.org>
To: Tal Zussman <tz2294@columbia.edu>, Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, John Garry <john.garry@linux.dev>, 
	linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 0/2] block: fail short atomic bounce bios in
 bio_iov_iter_bounce_write()
Message-ID: <20261120-gratwanderung-wickeln-mitkommen-1fa50bede59a@brauner>
References: <20261107-blkdev-atomic-bounce-v1-0-f66344262096@columbia.edu>
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
In-Reply-To: <20261107-blkdev-atomic-bounce-v1-0-f66344262096@columbia.edu>

On Sat, Nov 07, 2026 at 11:24:34PM -0500, Tal Zussman wrote:
> bio_iov_iter_get_pages() fails a short REQ_ATOMIC bio. In contrast,
> bio_iov_iter_bounce_write() doesn't, so a bounced atomic write that runs
> into a folio allocation failure triggers a WARN_ON_ONCE() in
> iomap_dio_bio_iter_one().
> 
> The first patch makes bio_iov_iter_bounce_write() also check that a
> REQ_ATOMIC bio covers the whole iterator, and clean up and return
> -EINVAL if it doesn't. With both paths covered the iomap check can't
> trigger, so the second patch removes it, as suggested by John Garry.
> 
> ---

No objections per se, I just would like see Christoph take a look first.
