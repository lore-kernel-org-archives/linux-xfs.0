Received: from mail-qt1-f182.google.com (mail-qt1-f182.google.com [209.85.160.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D93627F749
	for <linux-xfs@vger.kernel.org>; Tue, 24 Jun 2025 10:07:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750759648; cv=none; b=Ul7C5xDLIDJ/ssGJclF0O4R72PGP0D5SPJ3gV8OMUVSaYSZKQiaz7viYSPoYApHoPHwL82X6nDxA9HzMBNwfJPTnaVDyje9j8lkArD7pcTHNMO7LSU+DSyIs7FfN7GYEV9Mq2nasPm4xCDXmIaorDTVW/7wulsXhAqwdDRtkaZk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750759648; c=relaxed/simple;
	bh=W+CM9mO/ETwaXyRHsX7BAiiGsjxFt5RQdi+vc9rW6+g=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Xe89n5GdGFV189FHJBmhiTPcm0U9VFzxQ2uxD/lE13zDcXUngQkeowW3VWo54tqOp12xbFh2eUFRKM13ArLs8T1x5cEnTFU2CwU6ihUibu4uGiEJJgokjJzEooF55Hi+BEZItNoW7LBaRQ6HAinQI+m0xp2s3HFPZNTeGJHFpVk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu; spf=pass smtp.mailfrom=szeredi.hu; dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b=mgS7pRNq; arc=none smtp.client-ip=209.85.160.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b="mgS7pRNq"
Received: by mail-qt1-f182.google.com with SMTP id d75a77b69052e-4a58ba6c945so86907941cf.2
        for <linux-xfs@vger.kernel.org>; Tue, 24 Jun 2025 03:07:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google; t=1750759645; x=1751364445; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=hPlvv9Q47LZ5cAIWrnNCm2DnqvLNTn1tPrP8Q6vlz2s=;
        b=mgS7pRNquJ2v0kLWXLgvyQ/SgfO7VdRmdDoGq8nE4hQLGZ2UOWJkuxkKEV3639qjK9
         Fcqbru+vCgr4cNWKaxvAUEVvEbwgWo3OokOCnRko0QNdy40ZtA4EjxI3px2Cu6G1mWIy
         25h6D8HX433FJUiSD88ZGbAqcL9t+Chbc4/6c=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750759645; x=1751364445;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=hPlvv9Q47LZ5cAIWrnNCm2DnqvLNTn1tPrP8Q6vlz2s=;
        b=rNCXNR4nndRjtmjvwZtlem3LZIUf7Spy0F5cGFjYdY+ZFklowEgDQhKfeFLsNvDqVf
         Ux6VRtXIyN+XjLV3ne0x+QMzAst9PNXHJ5LvIFDEff0vhfo26WORlietQ3XyrTGqdNBL
         YJ6zvhUYzrgfiYrCZ2pNFTQ0zYedlXLJJBtXs17yl0UbClgFanD1wBqtY6AIiwWvDEo1
         KPR+dUiP5s24V//Kq48CGjFuMvvtbsd6Msrgthudz69BYlvAXFGz+G+AnhQmB+CDC8Q/
         KcsrIEsTH891L8wtkncIA7CIDIjaMJvajoSfMaP7BvfjSNF+e2judUhxsjTFz+aembXj
         toTg==
X-Forwarded-Encrypted: i=1; AJvYcCVNi8HfcaBFmsq0HpRw/u4qL5ugE8VuNTZJEg9IbguTrVfRSf3HSOu7QpjywVRq5lxiv4P0EOAKqkA=@vger.kernel.org
X-Gm-Message-State: AOJu0YzNS4cywGEWtJF3l53cY429Sr/gMGklfjXISjeyMubS6tpr7iRl
	pH1NgfGflDPkJvn7tZkHCMnpahqXOJx/eXnFt+w786IM5DVRkc3TPqrECZ/hKrLl4Qi9smSxJFi
	o62b+xMxG2Y8LSdAnv69gTg9N/jxIH5Wt46p7uT6gug==
X-Gm-Gg: ASbGncspb1pwU2Q0L6zsEI04bIJDIhyGPiIxx/wCNKHO8oi9sRfI6Xln9QP/N7SUAfl
	c55f7X7eq/IdXMvwPhBJHgHY4Taa0n7c2I1B44J1m+5oGsP2itLJ1FoRLZS/+nR9srfdhy+BYW7
	hBeeWrDzkk3a7nZ21L33pb/UsSTGQhz3RbufikjjEtbi9qn5TWi+9c9g==
X-Google-Smtp-Source: AGHT+IH0x0+iRHOWa2KqbV5wn8xPjJLoyNs9pTpMyvvOlaqhWqr33e0pXkymA/nSZQXBfDKBFVAgqMyY/CG6d2NNlt8=
X-Received: by 2002:a05:622a:1194:b0:4a4:3be3:6d69 with SMTP id
 d75a77b69052e-4a77a2cf554mr254409501cf.41.1750759645024; Tue, 24 Jun 2025
 03:07:25 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250624022135.832899-1-joannelkoong@gmail.com> <20250624022135.832899-13-joannelkoong@gmail.com>
In-Reply-To: <20250624022135.832899-13-joannelkoong@gmail.com>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Tue, 24 Jun 2025 12:07:14 +0200
X-Gm-Features: AX0GCFu5oKUxjJA2CnW9KEBLReN6IYqX2gQbksH-7WeoCgZJDO5EaGGt1ih0KtE
Message-ID: <CAJfpegt-O3fm9y4=NGWJUqgDOxtTkDBfjPnbDjjLbeuFNhUsUg@mail.gmail.com>
Subject: Re: [PATCH v3 12/16] fuse: use iomap for buffered writes
To: Joanne Koong <joannelkoong@gmail.com>
Cc: linux-fsdevel@vger.kernel.org, hch@lst.de, brauner@kernel.org, 
	djwong@kernel.org, anuj20.g@samsung.com, linux-xfs@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-block@vger.kernel.org, gfs2@lists.linux.dev, 
	kernel-team@meta.com
Content-Type: text/plain; charset="UTF-8"

On Tue, 24 Jun 2025 at 04:23, Joanne Koong <joannelkoong@gmail.com> wrote:

>  static ssize_t fuse_cache_write_iter(struct kiocb *iocb, struct iov_iter *from)
>  {
>         struct file *file = iocb->ki_filp;
> @@ -1384,6 +1418,7 @@ static ssize_t fuse_cache_write_iter(struct kiocb *iocb, struct iov_iter *from)
>         struct inode *inode = mapping->host;
>         ssize_t err, count;
>         struct fuse_conn *fc = get_fuse_conn(inode);
> +       bool writeback = false;
>
>         if (fc->writeback_cache) {
>                 /* Update size (EOF optimization) and mode (SUID clearing) */
> @@ -1397,8 +1432,7 @@ static ssize_t fuse_cache_write_iter(struct kiocb *iocb, struct iov_iter *from)
>                                                 file_inode(file))) {
>                         goto writethrough;
>                 }
> -
> -               return generic_file_write_iter(iocb, from);
> +               writeback = true;

Doing this in the else branch makes the writethrough label (which is
wrong now) unnecessary.

Thanks,
Miklos
