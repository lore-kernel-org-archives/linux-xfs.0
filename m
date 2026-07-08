Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F0553F58C4
	for <linux-xfs@vger.kernel.org>; Wed,  8 Jul 2026 21:30:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.221.48
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783546223; cv=pass; b=Z0xIATvHv3lLz2+cBF1fbqmJUqeJVe8lME5xHvA/HJES+8sQgoOYml/tFn1H8klM/Nt6FfNjrT5BdNki5e/gx64lmYg4/5A7oF2M7rWjdgVKw2HTISSUpiRhx19teeRkCd9zHeF41V0WCRcstGAe2x2x3L49Ffv+KgVQlyDk5ak=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783546223; c=relaxed/simple;
	bh=kgvdwCop/aLSvgkbu/K8xvwikDak1ekolcORsUSIrk8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=TKzxoh4OXfMGOe8JvxORdVI0FWQffEJB9Z9AIUchS9Vt65c4auBpbsthnWDXIlnzliEQLKCOdlbCU50DloMc37M68dWn/O2iduVWDp8pAg4ecamjxGapJ+kwbSl8v/c3CKlt2rdOnyWgTLTPDrvnQbtw6H3WeiJzvz4qaSbdMvw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=RJQy0fpJ; arc=pass smtp.client-ip=209.85.221.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RJQy0fpJ"
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-47122683cf3so747308f8f.0
        for <linux-xfs@vger.kernel.org>; Wed, 08 Jul 2026 14:30:21 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1783546220; cv=none;
        d=google.com; s=arc-20260327;
        b=lVHqUhtWade+2YSq4YfuuStMdzw760gUIueZwTYjuWEiSe+seR8GxlDiDex3DrDNY5
         d923z4W+Tp7gHwPAn0P2p8jlbSsUyI1w0FPdvTp89zlB9u73M42QDMOXHnYxjRDE72Ge
         1GbckxvFynjsy/yThLAlZQrqkvW7vUuCKDORIU9uVFDK6EPmPJtRUfdgGrYgNC+08Oac
         MXS8bp+S3N2Bwu7Ov2AX1UGzQHflFiNSz/dn0Hi7aOOV1ny5ndNrW09LP3yd/hheM/LM
         51DtKVLY5dR2Sv37vW+qpC0QyKt7wa49o4MIB0X2CmNs2cz0Ga54gz1qo1vgd+5lpkM6
         Q2IA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=oysFZq6tAMslUX12xXRG6mkqYiMd4xCFaT2TvkVCwfg=;
        fh=sYiPs7q3ITEhh5GkhJ+cqkk/sqkFKGUMzZnmNDPAwvo=;
        b=qNbdiqQXErpg7IjEo9eWHEWMiQZmzt6wA3BY8iSUrYKvPOUtn/vfPfMdsZ0nXmzN5i
         hVRDl/FcxZACobeJH//r8MdV2colzWpCpEHYdUalrgqQ4t9NJshuWR4V93cmyHYRjSYd
         0Y9ifgoNRhuMR7p1brYPOJErG6hkstbSkxzGlOHcHjn09+9PFlrsvx18Em1laLEDJP6v
         i6rAuyzxZBdKTO6VBP3OymRdpWluQ/uYGg5jrUtCF6gQQIM4iUIPoMAM3ZGEjv5tAQ+c
         1VW7A3mS2je7Lr1KkAS4YOZlIdKPURa+gEZXEW13zlMaZy0ReEv5Ko56r3wYDba06S6E
         q6hw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783546220; x=1784151020; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=oysFZq6tAMslUX12xXRG6mkqYiMd4xCFaT2TvkVCwfg=;
        b=RJQy0fpJv3jey4oVW3Jth+gMCS0D+qKWsZcVqK3QeSsQ16gmCFNS9CbpLD60E8A3K9
         TR6GMD4UmkmNdFvZaOPUhqUGwikiGSeaCAju2UOUhlbPWVCZVPLnjZPMxBSXi54koZ0F
         2H+qXyoHa9QRiF3yaFUfz0g1NU7tN9rNwXzcIDLuh2QKElrAlPHNL/LWqpY6p/+HyKWS
         AIrIDoqIE6vUo0+XdOw4g1DKMIynTJ3oZ9ud93GyU4yZ1+ig5asjfElCGEFwAh3LMI3N
         m3WEVBmDXtAAcC1nFvf5FzcJRztFbfE/O0sNannv8vHK+RwGLDhGQ9m+DluCnjakM9GY
         Ew5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783546220; x=1784151020;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=oysFZq6tAMslUX12xXRG6mkqYiMd4xCFaT2TvkVCwfg=;
        b=FOQRvDkPcCwSJ9+N06AU9OJBSNDIidB7VI/J59/HIt1Jp9VEz0l9Neyq9NH6or6hEH
         MRCzgSwFlnYys+o6O/Tm/42+y/BRXwk/iG8IFKcddGTMYZGpuJ3Z4jTy2spDA/DPbYeZ
         K7b1Ok22wZCLgtVTP4wGEGYoJxN6MrBTdqAonw3s6hpd9pcKmPGDxvpxyuOKTZtsdMp5
         Aub35gL+xEgwqbm7J4/GlYziH/SqvJf6UhSj/x9g5lU/q7vnCclTZjUZ8bZxLBIdrvfR
         MmDKx9Fsr0fqdzG+2oBc53BvhiMb3YTVKQvrecRuBEGsZXLWM9pgOfF314d05DjVx4mp
         /W5Q==
X-Forwarded-Encrypted: i=1; AHgh+RpTxpai9DLut3zSOMABMDcZfnkAKgbqxWbFyOkC+TgRF957VxFB9ZCZWiYke2oqVx2LevJmr5xhzrE=@vger.kernel.org
X-Gm-Message-State: AOJu0YxXqe+xJ1ZxSaTBdGoAn4xJtG89nduXGADlhRMd88n1tMJ+i0tr
	LLSs0JtV7nU4AEKPstJHYVYjKBKRIpmNE4oQm+rEj60YK59gfjSaPQNq8CKWBQFzQ9iPLMcsGTu
	yj0zmkmDmnJbsKbLe/RPswsFn2cOChW8=
X-Gm-Gg: AfdE7cmR+uCxpmXGh6l5KyFLG6cUh6HxY79ZKSABVpyMwTpVZwZp9uorci1qpmoAVnC
	/UjxPfNkVm2N2JeIcJ1EYbGOoeB+Qm7uUOiM3ZUSJC7DR+oc3R9x7Rwe7xKtDOvg7W2esdudeg2
	8noVUs1BI7SdTpp0XfhCXs0CeHGYsdVavKSuTxF8fm0oG1HmEtxhW8OFbNq8hHXky0hkcYeF84n
	0Rzi1y6Lu8laoQW8GcGAe81VXqSOic3N+PGv29Sl2sIcOl0AuW3JqH6qxV19VprZZr4X8y2ubLt
	szj5YZNqt6iWD3pg4CqFFZOinO+1eMtlqWd8GNmGdswYJ5rP+Q2g
X-Received: by 2002:a05:6000:1a8d:b0:46e:997e:b4c5 with SMTP id
 ffacd0b85a97d-47df07318ebmr4686335f8f.18.1783546219649; Wed, 08 Jul 2026
 14:30:19 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260520030357.679687-1-yi.zhang@huaweicloud.com> <20260520030357.679687-3-yi.zhang@huaweicloud.com>
In-Reply-To: <20260520030357.679687-3-yi.zhang@huaweicloud.com>
From: Joanne Koong <joannelkoong@gmail.com>
Date: Wed, 8 Jul 2026 14:30:05 -0700
X-Gm-Features: AUfX_mze2KSMzcr9sNQr-lNuBFUay6tZXCOW1WB9AHVpL4GFldBmQybXidQ8yFw
Message-ID: <CAJnrk1Yeqij31Geuv55Es+si0zRqzCGe-B=hpw_DjT11AsRcTQ@mail.gmail.com>
Subject: Re: [PATCH v2 2/5] iomap: support invalidating partial folios
To: Zhang Yi <yi.zhang@huaweicloud.com>
Cc: linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org, 
	linux-ext4@vger.kernel.org, brauner@kernel.org, djwong@kernel.org, 
	hch@infradead.org, yi.zhang@huawei.com, yizhang089@gmail.com, 
	yangerkun@huawei.com, yukuai@fnnas.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, May 19, 2026 at 8:09=E2=80=AFPM Zhang Yi <yi.zhang@huaweicloud.com>=
 wrote:
>
> From: Zhang Yi <yi.zhang@huawei.com>
>
> Current iomap_invalidate_folio() can only invalidate an entire folio. If
> we truncate a partial folio on a filesystem where the block size is
> smaller than the folio size, it will leave behind dirty bits for the
> truncated or punched blocks. During the write-back process, it will
> attempt to map the invalid hole range. Fortunately, this has not caused
> any real problems so far because the ->writeback_range() function
> corrects the length.
>
> However, the implementation of FALLOC_FL_ZERO_RANGE in ext4 depends on
> the support for invalidating partial folios. When ext4 partially zeroes
> out a dirty and unwritten folio, it does not perform a flush first like
> XFS. Therefore, if the dirty bits of the corresponding area cannot be
> cleared, the zeroed area after writeback remains in the written state
> rather than reverting to the unwritten state. Fix this by supporting
> invalidation of partial folios.
>
> Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
> Reviewed-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  fs/iomap/buffered-io.c | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
> index 64351a448a8b..876c2f507f58 100644
> --- a/fs/iomap/buffered-io.c
> +++ b/fs/iomap/buffered-io.c
> @@ -761,6 +761,8 @@ void iomap_invalidate_folio(struct folio *folio, size=
_t offset, size_t len)
>                 WARN_ON_ONCE(folio_test_writeback(folio));
>                 folio_cancel_dirty(folio);
>                 ifs_free(folio);
> +       } else {
> +               iomap_clear_range_dirty(folio, offset, len);
>         }
>  }
>  EXPORT_SYMBOL_GPL(iomap_invalidate_folio);
> --
> 2.52.0
>
>

Reviewed-by: Joanne Koong <joannelkoong@gmail.com>
