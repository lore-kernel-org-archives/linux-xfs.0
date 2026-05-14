Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC4E63E5A3E
	for <linux-xfs@vger.kernel.org>; Thu, 14 May 2026 15:08:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.221.44
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778771323; cv=pass; b=ttjADKYZ5AcksGGigYCNcLP5VgTY63pbqfue1K2gbV6FcjqIckMcyppUgW+WYaf1fqMuk+sOe+IbKdVTzZr2xAwKDKGzIxdWLRBNNzdmVwHiu8yJclkGhdyZvBT9V8i289+WeDcnUtqOw0F5rRe/KdDl9y9y2ZLpScLUhcrv5Gk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778771323; c=relaxed/simple;
	bh=Oqw0NDluenc4M9KSxSuO4kI1l37w9GHWqNHYO2kNx68=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=OINDSYEo4rmRkvVwlR9okOlMojjG1i6oS10aVU5Wltlzsm40cfD5QAUgdgi1MezKh7kMwO5qZjJ256RL5RED82QBeedaQAdcLZ76Lo7BpOCWYGNrRz3D5k+K/YPuN2xsgyhuMSRDzKUWJL7Bpd/BjEL5++vPGIPV579rFNiHky8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jFPFUZyG; arc=pass smtp.client-ip=209.85.221.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jFPFUZyG"
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-43d77f6092eso5104995f8f.2
        for <linux-xfs@vger.kernel.org>; Thu, 14 May 2026 08:08:36 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1778771314; cv=none;
        d=google.com; s=arc-20240605;
        b=OFSpNXTVHK3OXDWxMC5X1VqapUBbemfX8whNhakHN40t4QTbMii8z2IluyM90qstj6
         q5LVCkbyYFxWfz9G95P6VwvhD2QRxQltXyMCoR27Emw8QA5q0MUpungmMa6RTyLI1T5e
         cveTORcsUrnMMD2emx8Ll8Ub1meXifSJLuWZHQETxgbRnB0qxGZsNNnjj9TFOU36hnIJ
         x7VzHNCUYivX4mLmXSd39a1370MFmkenlSl7ZNgP0zcjSdFaO79+gpW58Et8ZJ/pVKy/
         dmxl32XHLtwEGoObVufMcw4iBGnqhnNTw+T9MgDM9i//4cSczMA4X1up8LdWP1tEURfc
         mVIg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=+bdgZnAoM28ZGhdZNKKk0p4fIizw0yp98Oy054cZAiQ=;
        fh=2uIRROmmYZed/2TMgTT5q/0MyIDC/neF1G4akrxIQGk=;
        b=WnYnqlPWuqq7ppK36nyjS0uSIFIpyv3Ed1ojM6VK+t4JA4m0/srpsbNwNkj2Wfwe5P
         RdGsFtTlu6HrVOR/Hx7nXfLvsDwK6WQkrgh9p9o9Qqx2tz7wzPvMp1WCGyCQe5D8IGR7
         +E8lo3iDHsZ7xtHm7Dc/SNN9y41c3dJxNP/GwPNxXjs2Iw49+A5p4ePeSnLkR9hO0Z7F
         dgXppkTlTlA0ExKz5eb78BreHateXi5ujGaNOnucBZ7xs1AE8Bhw7ellm4Hk4JuOT7fq
         lRWPVJrQdt6+VUPY7xUwJkaE4d8JEg3Svx/qvx5vgAG2hdma6F0Ez9pzNoGsc4vq4SGg
         10Mg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778771314; x=1779376114; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+bdgZnAoM28ZGhdZNKKk0p4fIizw0yp98Oy054cZAiQ=;
        b=jFPFUZyGbul8cFDW3q1P3p8RLFHIlj1m8F/jtBNQTuTemT8CbQcyZBT8xxrwEoNmdx
         dvoD/B1XdCHqWwexSKNL3GiAmxfVL27b9xO8VLbakoMzQCIlWUsOfnwuogxd2hefNitU
         EA/47XveoOX3bQebaE5Bn7Ib1z0EBA9QLxXTki+3y3j/Ix1432ha4YtONJr2yrwRUiEJ
         Ln2BI2WkrizjK6YQ5oQ7r21y+2JS2T8GcBqe1dKf/TMkqN3KHUqQuNnMrqOzpOgz+0Dg
         uvbu+oXzpm0FA7jHZYsRB7qlCYMB+jrUo9yjOLaEjPixn52lGmzHwMM99fy2pZE3AbJU
         BVSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778771314; x=1779376114;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=+bdgZnAoM28ZGhdZNKKk0p4fIizw0yp98Oy054cZAiQ=;
        b=mcTu6lTX6YymR3yFaP6n+GU/pfrqYVjSvtbJ3pYFKA6pQTYKC7xFBuYnnK7BqtaRb3
         ai+UKPu2j6HGmr3GBMvAviTv5K8IxmSsKH7/JaUCW5ISjoP9oR8jiInKS5XJVz9OnHRZ
         OzeSNLDYsRuix4Oiko0dHp1fzfVZmxu05TA+lchjt/czYkqCSLbodVdynK8QkSy1RRCu
         4UeahywWC1h0KuhvO4odb3x8oLpvwC4mPL1lUODOQD+pRVhJNNoCgIOkoI06w5ioCLRZ
         Hqec1F1qkkxpqbfuXoiYUoMPsP7QnVaDsJi1cteWAK4huZYKZfvfcvqgNi4aFj8s7xuw
         YF1w==
X-Forwarded-Encrypted: i=1; AFNElJ/qMW2LdpbFRu1kSGGEqQc1UzZln9fZVp/ORcQ5ZD+y0nekyix4+AmaDjonvDhFILt008VTM1/C9hs=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy8WbQd+I4f41H6qBE8JycmqNXCijgR+eK4PLh4zu3IitkmeIY5
	+8bcWzrQ4HBAhY70KLmW6zcwoPZ6hYe03vPtsREhm2e8owlAxqKr7i4AXrnLf8L3mDT+hMlZtvC
	jvoAaK8yE47tTdNmBs4qlD47VcPCDNvU=
X-Gm-Gg: Acq92OE0tcbx51lwWR2t6WPVB32Cr4I/h4OFhSmwCfcaS5pPWcEgb8Fvxr6w92UDDw6
	0p7cYrMp2fR2OVRqneWf8hBtFqmvlcggkRlDqFs6UXdzZSGw2eBcWXnnQyA/gr3hJMAOAwadA00
	NHuMjJ2lZIJJu+DvgNuv9ugp3DuMcTyaZ2MQWSZffZ5yqrdIcoCZwqgBBgoJg/+Gnk9HFJZx/pU
	5kmY36Ys1V/EoAcOVf+RhTsVhKtVkcmfgdB/6ArPpNgwfoXGZdIuyywClVIZfk3EWgS2e3F0JCN
	bVfBkw==
X-Received: by 2002:a05:6000:24c3:b0:448:8db5:410b with SMTP id
 ffacd0b85a97d-45c599ebcc5mr13067532f8f.20.1778771314283; Thu, 14 May 2026
 08:08:34 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260514062955.1183976-1-yi.zhang@huaweicloud.com> <20260514062955.1183976-5-yi.zhang@huaweicloud.com>
In-Reply-To: <20260514062955.1183976-5-yi.zhang@huaweicloud.com>
From: Joanne Koong <joannelkoong@gmail.com>
Date: Thu, 14 May 2026 08:08:21 -0700
X-Gm-Features: AVHnY4JGAYta6lc0ZFFwSJBwWzibm6rBu2Rx6wdCCAM4bkR5PfJiohRCslD9kBQ
Message-ID: <CAJnrk1bHM9aGXbk+LJYJZrfbtLvbwsqwrJgY2KkT5AyVfBjdrg@mail.gmail.com>
Subject: Re: [PATCH 4/4] iomap: fix out-of-bounds bitmap_set() with
 zero-length range
To: Zhang Yi <yi.zhang@huaweicloud.com>
Cc: linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org, 
	linux-ext4@vger.kernel.org, brauner@kernel.org, djwong@kernel.org, 
	hch@infradead.org, yi.zhang@huawei.com, yizhang089@gmail.com, 
	yangerkun@huawei.com, yukuai@fnnas.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, May 13, 2026 at 11:35=E2=80=AFPM Zhang Yi <yi.zhang@huaweicloud.com=
> wrote:
>
> From: Zhang Yi <yi.zhang@huawei.com>
>
> ifs_set_range_dirty() and ifs_set_range_uptodate() compute last_blk
> as (off + len - 1) >> i_blkbits.  When off is 0 and len is 0, the
> unsigned subtraction underflows to SIZE_MAX, producing a huge
> last_blk and nr_blks value that causes bitmap_set() to write far
> beyond the ifs->state allocation.
>
> Regarding ifs_set_range_uptodate(), it is temporarily safe because len
> cannot be passed in as 0. However, for ifs_set_range_dirty() this is
> reachable from __iomap_write_end(): when copy_folio_from_iter_atomic()
> returns 0 (e.g. user buffer fault) and the folio is already uptodate,
> the guard at the top of __iomap_write_end() does not trigger because
> !folio_test_uptodate() is false, and iomap_set_range_dirty() is called
> with copied =3D=3D 0.

Is the Fixes: 4ce02c679722  ("iomap: Add per-block dirty state
tracking to improve performance") tag needed for this?

>
> Add a !len guard to both functions before the computation, so that a
> zero-length range is a no-op.
>
> Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
> ---
>  fs/iomap/buffered-io.c | 23 +++++++++++++++--------
>  1 file changed, 15 insertions(+), 8 deletions(-)
>
> diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
> index 27ab33edbdee..6fe5f7e998fd 100644
> --- a/fs/iomap/buffered-io.c
> +++ b/fs/iomap/buffered-io.c
> @@ -67,11 +67,14 @@ static bool ifs_set_range_uptodate(struct folio *foli=
o,
>                 struct iomap_folio_state *ifs, size_t off, size_t len)
>  {
>         struct inode *inode =3D folio->mapping->host;
> -       unsigned int first_blk =3D off >> inode->i_blkbits;
> -       unsigned int last_blk =3D (off + len - 1) >> inode->i_blkbits;
> -       unsigned int nr_blks =3D last_blk - first_blk + 1;
> +       unsigned int first_blk, last_blk;
>
> -       bitmap_set(ifs->state, first_blk, nr_blks);
> +       if (!len)
> +               return true;

I think both callers of ifs_set_range_uptodate() use the return value
to decide whether to mark the folio uptodate or not - does this still
need to return ifs_is_fully_uptodate(folio, ifs) instead of always
true?

Thanks,
Joanne

> +
> +       first_blk =3D off >> inode->i_blkbits;
> +       last_blk =3D (off + len - 1) >> inode->i_blkbits;
> +       bitmap_set(ifs->state, first_blk, last_blk - first_blk + 1);
>         return ifs_is_fully_uptodate(folio, ifs);
>  }
