Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEB062F693F
	for <linux-xfs@vger.kernel.org>; Mon, 27 Oct 2025 17:12:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761585170; cv=none; b=SwKcTeu30vUr+pFxv51+E0jnecmSv3vwib+RLA3C5eCh0wNNWFYxOITBe2tM8pa75w6mg95qg1frWv36ptZFyBTT+rpcDE+9wuxxpregDTze2dtXHyjBVwPbCDO65foJEJJYsVzZnoYXA0CY73tPzffTkGN5GVEc5vc7CnEN824=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761585170; c=relaxed/simple;
	bh=eeCcaiB5m6mBMPE2QFVNav++Juuy6BY9qODhUaJkbbE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CcNrmQPfJhOv6HimMjiHHwq+1+Bn6HlDzQ8fd6DaG8UscO5ffixijOv2aaQe7Xm1D0hGsZDUhlK6uj5iUBYAjj2vT88VwJXL+GdTGqhOVuYC+ojgCR26WYK4zp/FITtAJgY/qrLfRrEraQ5bfeH3301VUJ/g/3eLpRQBX165BsI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=3txy0tOv; arc=none smtp.client-ip=209.85.214.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="3txy0tOv"
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-290da96b37fso9865ad.1
        for <linux-xfs@vger.kernel.org>; Mon, 27 Oct 2025 10:12:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1761585168; x=1762189968; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=bPy+FHVUTDlqo9kS8K0pwEoZsjWCLKbllIO0a4/trd8=;
        b=3txy0tOvQB9Zzi2DRCgScrD2MNOnRQqPwvbiqFKqkxk9OeWypvULXELoePexHM4xCb
         KzGlJ0QmT2WpG6h1F3tNfpRcbawVVVAUBQIwR5jV8f8ChtCq9L0jtMQOJmOfrhCObz9I
         C/4bjn+Qx+qoo4dJtoQgWN6+/Umt2pJInfypP9QhlxM1X0dEzPrwSPrnQY/+qT24cuEq
         1XRqEbT7a7zFFiC8vlaguLgq3INGB8roO3QVSfHSAdIu4EyUnQXqi9/LBdV31tY4CcBH
         +dGaTepAgZQbAfQ8+HL+tB+/6pxn2waTKnt38HF2kPZ9DrWhZ9/jq+lfLBC3flE44b7D
         H3Aw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761585168; x=1762189968;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bPy+FHVUTDlqo9kS8K0pwEoZsjWCLKbllIO0a4/trd8=;
        b=q20f4l3NNL+NfBcLZUyxjZjr5XPiO5HOk5E2loOw0YFS3Zrh+kCN2WwRFiq8hiecm+
         xxOOWe4VyfFD84QX9g5ddvz76/e8j+JPma+5ixZh9h9UlPcrGE6J/iGi4KN7O0lS+W//
         CFCJdTDucGnZvihrZAIVxp+X9dVpbicVD7UonetRPw18F1SZXc70KUVlEXU3lc9RVcaR
         k8BAQQA/ZtP42ygFkio2Y/wEMgXaAF/6o4BjjhpYQcdQVPF8qJ0IJU/5gUb2cIdWcKoR
         9Th2xBg5VpJXRVfYDrYY1bDyPgk3Os+tepylccUyD72WOL24YkUrRGocGi5rObvui6ih
         bNhg==
X-Forwarded-Encrypted: i=1; AJvYcCXYh+FC1zXG7Fw+JQwpx+dCxnu6eo41GEOGoqfOTtPvnatej3dfizo//8sS3sMRzuAGQ97xlwTWFvA=@vger.kernel.org
X-Gm-Message-State: AOJu0YySJpMjB3oxABCC6LnoDOo9h8MRmjCLrEiCC+D5P9ZOYS3DqFly
	NRHwntKGLnhQFLrD4Kkf2hWomzeMF7PmdsG1m3Lc2i1g5hebTFdM3cyWFFjtX+OHww==
X-Gm-Gg: ASbGncvjgGdSBNlcDMPhcJSueBMiaf6Z80Yp+5U8ZTq7Tw0Rb0DYb1wH5a98XMsaouq
	i2SwDSGFwViGRp7WXd+1K2hAiJPL9U7HgS7Um3fvQWVWDj+IHom7ZvT6gD7bTq9xysPUMuW/8F9
	M3+sBxnUCfBGIClMWFEPyhdKilXn+ZwWWy+tjk5qzrI5nWmVdyKxpSjrqyAyc0s5NzyNiZ76jAo
	sbIDwyARuSEOQE8+LM8t/LYTwI1biuQWzKtB/jERX3gMJUmLBRJ4LLcsl1O2imV2FS0j/rpaVpJ
	0F+JesocLfEwAPLEiXBKT3n8BAuOk847vUWNL0p5rINpc0c680dNIqUF3SN+0umagdmrrFcylqf
	IiHJ0ZGurUDzl8ePM1cOWUxIrwF5NiqB/JTCmh+QcT+F43asvFLYm6GKLwCxNP12g8M8+yw/G1l
	P/+PVtUlcTAC0FIfGA1XIhAeBDiPam4COeBuGiGMjxEdnlx6vRjugUmemn9Xj7PpygIt5+YOXu3
	N0sHwrvaqDpVHSK6T5bmcrMMLcUWIJD8gk=
X-Google-Smtp-Source: AGHT+IFqnCggieYC70G3l4AysmlLY9PDhAFPBx/+0lwHkbnuWCU0qCp4R3nH9HyqPlC8U+RgBeixrw==
X-Received: by 2002:a17:902:e807:b0:290:c639:1897 with SMTP id d9443c01a7336-294cca88caemr184895ad.2.1761585167716;
        Mon, 27 Oct 2025 10:12:47 -0700 (PDT)
Received: from google.com (235.215.125.34.bc.googleusercontent.com. [34.125.215.235])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-34028fc5cc5sm32860a91.0.2025.10.27.10.12.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Oct 2025 10:12:46 -0700 (PDT)
Date: Mon, 27 Oct 2025 17:12:41 +0000
From: Carlos Llamas <cmllamas@google.com>
To: Keith Busch <kbusch@kernel.org>
Cc: Keith Busch <kbusch@meta.com>, linux-block@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org,
	linux-ext4@vger.kernel.org, hch@lst.de, axboe@kernel.dk,
	Hannes Reinecke <hare@suse.de>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCHv4 5/8] iomap: simplify direct io validity check
Message-ID: <aP-oCfjViaEIowQe@google.com>
References: <20250827141258.63501-1-kbusch@meta.com>
 <20250827141258.63501-6-kbusch@meta.com>
 <aP-c5gPjrpsn0vJA@google.com>
 <aP-hByAKuQ7ycNwM@kbusch-mbp>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aP-hByAKuQ7ycNwM@kbusch-mbp>

On Mon, Oct 27, 2025 at 10:42:47AM -0600, Keith Busch wrote:
> On Mon, Oct 27, 2025 at 04:25:10PM +0000, Carlos Llamas wrote:
> > Hey Keith, I'be bisected an LTP issue down to this patch. There is a
> > O_DIRECT read test that expects EINVAL for a bad buffer alignment.
> > However, if I understand the patchset correctly, this is intentional
> > move which makes this LTP test obsolete, correct?
> > 
> > The broken test is "test 5" here:
> > https://github.com/linux-test-project/ltp/blob/master/testcases/kernel/syscalls/read/read02.c
> > 
> > ... and this is what I get now:
> >   read02.c:87: TFAIL: read() failed unexpectedly, expected EINVAL: EIO (5)
> 
> Yes, the changes are intentional. Your test should still see the read
> fail since it looks like its attempting a byte aligned memory offset,
> and most storage controllers don't advertise support for byte aligned
> DMA. So the problem is that you got EIO instead of EINVAL? The block

Yes, that is the problem.

> layer that finds your misaligned address should have still failed with
> EINVAL, but that check is deferred to pretty low in the stack rather
> than preemptively checked as before. The filesystem may return a generic
> EIO in that case, but not sure. What filesystem was this using?

I see, so the check is to be deferred to the block implementation. I
don't really know what fs I was using, I throught it was ext4 but let me
double check.
