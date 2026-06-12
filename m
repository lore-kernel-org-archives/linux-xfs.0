Received: from mail-ej1-f51.google.com (mail-ej1-f51.google.com [209.85.218.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C58793E832A
	for <linux-xfs@vger.kernel.org>; Fri, 12 Jun 2026 11:38:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.218.51
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781264296; cv=pass; b=dtC6E0Y6qHICsxDO6ZddTH4sVWsO7zPvAN/l+QsO1HNVfc/Npu5RF+DdOx67jbVCeEaH1nWBSZnNNNMe6smAD5LKYaPXEwnqd6iPFChn6uIX6Duj8/UP03GJOyDJUzwEYGod8Flt4e6O/mo3ELWuky0Zcx4qjj19EoY6wT0sEAo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781264296; c=relaxed/simple;
	bh=/DrrLGWmCVwx9+6FEarb3rcCm1SgMUh/VIq6UcggpRY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=WmHs0cEapf04VwzJvJrVXCSrCnUrX/teP8pmnvb6MekEkNU7Fu0xEyoqfiyWVg4dKqj9IOlJ1OIwMp7cMDzAvXgvS0ef7EWNccRBHF85Oo+NHyVnNQOxmgBAuRQ9Q2QitF4JUJ+v/47vkuqE3HHyq9nNiHWHcvXU9/tNcQegjCs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=dZGdbwFW; arc=pass smtp.client-ip=209.85.218.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dZGdbwFW"
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-beb44f97561so116950466b.0
        for <linux-xfs@vger.kernel.org>; Fri, 12 Jun 2026 04:38:12 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781264291; cv=none;
        d=google.com; s=arc-20240605;
        b=bSA0BqzFUrilZRN07ADpjyqF59QBX3o3n6wjKGUGkr0VyS88j8w7Cxb+Fd0NHVeqJ7
         thgiSh1/yeV/ZKY/djWGp/jxdWuFNCfYDAmb4Dkmth8NmITvkTvQRfB4XhDneJA3mctg
         jQp4BoV9LEC2LvEJ7aG+9gNuh+6LY64jmWDKxjxRE5EVZ5ky8X2awUEYHhYalUsqZzmV
         qEBc1aL8ZcJ8rkltd30Pz6bOSeU9UuqBJAY63SQIk4Iaad1f3EBZp7c8NTdzVeku+00O
         ouMwYqwUlRdZluqHHLZE/qO6YJNuHjdvkTswZpdw0YGWMCC3t+adQzyStf+XBPmDHzxP
         MnaQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=+IQj5rcd7MF8cObFuoT0nugDTq7yPQQUWB6TL/BTANc=;
        fh=PTd1QYvgRQ+UhBURvmypMhY+PHStkuWPONc2JewBxh0=;
        b=GOhKnzL4Ta/iKVZ13A+iJF6zlwonS67tuBGoJBisbGwskLtXAyFzJVQ+yLLaqQxRfB
         8qE+W+clf60n7/r5Ey9Ic/opXPkvrNEJKYIF5neSZp/aGc8VgBk6dEsugmHs8JyJe109
         EuF4pbrRGjy3D70NYeB208KTOtAO6qnBg68Fr/wHnavGqDCZicKWEh3Q3dr9yMuOz/Hs
         j8g+8T6eGhpFPl6OIDrUKvkoPftvUMIHKqdFZukvezQqSt1sc5iVgNVTybI8vwcamgLN
         rHwR49FnI2Ad/vjMXP4whK0GwgGAcr0t6+Im6IqBDoPtZx8rpOPFZPf3K6pRaF2Q7x24
         cKaA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781264291; x=1781869091; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+IQj5rcd7MF8cObFuoT0nugDTq7yPQQUWB6TL/BTANc=;
        b=dZGdbwFWZAcAChPJdC8AmekmOcD3TIuJHo1HoJhmL/K3aZ9cUtgNrwlBNt3QVT9wbL
         GhNf/Dpi+1YhBaQrSUSncBHP8fhpWmiNSt2rn3EkaG7/pote+6dWbFX1SbOql+AFHFZr
         IoI4cE4kIor7HTunGxOomTISIXM/eupYhw0ulW8f/8hQQYrZZKoNNkZQlxTmv5VeGqzJ
         2a79sS4Y/2y2+ad/K7y87TV16XzakDSwk609jkXxde5pAjjuVtelXBrbNP0Stck+7p6J
         CpuXI0+gcX2qpLcFQjv8DZqeICYT7IOhGqL9EHhpmhjMP9YWena1+Pc1J6du/GD8jFlm
         6l4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781264291; x=1781869091;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=+IQj5rcd7MF8cObFuoT0nugDTq7yPQQUWB6TL/BTANc=;
        b=pji+oJ8PAHmVELxYZMbmaWPOZhYMKnrEMv68Y59HtqweutUPMi3mRcznyRyuQpyXcj
         Ip1svvuHAhoIOwTelvZWFMjKvSzKEDzJCVcvBb/OgdD37Y09p1ZdU37IWxGxvAMtx9NM
         CoOLqzFlpOvbl/8sJRa6GaxzYtGlJdKAlx3oRaP78RdJVnhGEYc9sRSe7c+e0ZLsxDlX
         VQw2dx2NUMRM3oi0Jab0UkxJ1QMFAvVuFyUFeZNiOm7WF5SsOikzzKNvZ6tJ1JXrMjtF
         BsMZrVrxrhQ93cVIHRJhe7crCNl/AiaTiuBVvisUH52ZN/gnc8ZwHZuSiYU4OtH+fkoq
         uSBg==
X-Forwarded-Encrypted: i=1; AFNElJ/tTWbYrsfP4QxA3nuHpHwAXzR6asQq2rcItKYlCDWNGiz9kqBfWZ3U/BA5DxZgqzUKTH5/bxC7t7A=@vger.kernel.org
X-Gm-Message-State: AOJu0YxbANKQo3H2x8SJFtOf3+RDZYKup16ApI+Si1yHuVQkeTlSCAvQ
	XcZbxyvQsAbxuvVScBGuJO8XFpUoA2a7nRztqYj2OZ2EfF/rhzOlvIsGgHYX8HfC/Lfp3BzhWnl
	bUFAbxmW+P/RZ68rc20lMLPASSClpKH4QIAAdwcJbtA==
X-Gm-Gg: Acq92OGIrQUg7JXPd6dzgJJ8WawX5/gveLNCwZ+U5P0i6iJb2nSb4RGRKLs7cbVSeGb
	8k3exrRYePdLpRjaSgWSQSqSU1E4b1TU6s1kquWEF+M0tdeTSsMcTjoMuTJ92XAYUmLIZSBk3jq
	x02U+QENscxDEEo0snE+fZe7Rje0ytxaWGwpFb+emIY5KykqEO0LVLh8TkzpEpFAOD+T7w3JG/3
	nwYmBkVABqxdFEe0aDk+LoI1rPVuh7Zj44JWOxupYhYYDTP1X7Cvd9yXa7X4Lgs/kyk9H7z4msX
	cHDHyGeFlOe8P5q51S2g6PllnaeP4l/8CzxK/KU=
X-Received: by 2002:a17:907:266e:b0:bfa:f563:9294 with SMTP id
 a640c23a62f3a-bfe2890ba61mr75408866b.18.1781264290631; Fri, 12 Jun 2026
 04:38:10 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260612112252.1697-1-aditya.ansh182@gmail.com> <20260612112252.1697-2-aditya.ansh182@gmail.com>
In-Reply-To: <20260612112252.1697-2-aditya.ansh182@gmail.com>
From: Aditya Prakash Srivastava <aditya.ansh182@gmail.com>
Date: Fri, 12 Jun 2026 17:07:59 +0530
X-Gm-Features: AVVi8CcP1rGB8eGTEi-tnoAmiH0duxHM4i9mhj8FB1oC1C69jQWSQob_rDCdouo
Message-ID: <CAK5ssPOv5gUn5Rq2GhTsmhXH0tby9ADYqkuR9RoT-zYG9c+s8A@mail.gmail.com>
Subject: Re: [PATCH 1/2] xfs: add a XFS_TRANS_WRITECOUNT_TRYLOCK flag
To: Carlos Maiolino <cem@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

The sequencing is wrong, Please ignore

Will send a fresh series

On Fri, Jun 12, 2026 at 4:53=E2=80=AFPM Aditya Srivastava
<aditya.ansh182@gmail.com> wrote:
>
> From: Aditya Prakash Srivastava <aditya.ansh182@gmail.com>
>
> Introduce a new transaction allocation flag, XFS_TRANS_WRITECOUNT_TRYLOCK=
.
> When this flag is specified, __xfs_trans_alloc() attempts to obtain
> freeze protection using sb_start_intwrite_trylock() instead of blocking
> indefinitely on sb_start_intwrite().
>
> If the trylock fails, the allocation is aborted gracefully: the freshly
> allocated transaction handle is freed, and the function returns the
> appropriate error pointer ERR_PTR(-EAGAIN), which is then propagated
> to the caller by xfs_trans_alloc().
>
> Also add an assertion in __xfs_trans_alloc() to ensure that both
> XFS_TRANS_NO_WRITECOUNT and XFS_TRANS_WRITECOUNT_TRYLOCK are never
> specified at the same time, as they are mutually exclusive.
>
> Suggested-by: Christoph Hellwig <hch@infradead.org>
> Signed-off-by: Aditya Prakash Srivastava <aditya.ansh182@gmail.com>
> ---
>  fs/xfs/libxfs/xfs_shared.h |  3 +++
>  fs/xfs/xfs_trans.c         | 12 +++++++++++-
>  2 files changed, 14 insertions(+), 1 deletion(-)
>
> diff --git a/fs/xfs/libxfs/xfs_shared.h b/fs/xfs/libxfs/xfs_shared.h
> index b1e0d9bc1f7d..68d22b6cddd3 100644
> --- a/fs/xfs/libxfs/xfs_shared.h
> +++ b/fs/xfs/libxfs/xfs_shared.h
> @@ -164,6 +164,9 @@ void        xfs_log_get_max_trans_res(struct xfs_moun=
t *mp,
>  /* Transaction has locked the rtbitmap and rtsum inodes */
>  #define XFS_TRANS_RTBITMAP_LOCKED      (1u << 9)
>
> +/* Try lock filesystem superblock for freeze protection */
> +#define XFS_TRANS_WRITECOUNT_TRYLOCK   (1u << 10)
> +
>  /*
>   * Field values for xfs_trans_mod_sb.
>   */
> diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
> index 148cc32449c1..3860e44d6439 100644
> --- a/fs/xfs/xfs_trans.c
> +++ b/fs/xfs/xfs_trans.c
> @@ -216,10 +216,18 @@ __xfs_trans_alloc(
>         struct xfs_trans        *tp;
>
>         ASSERT(!(flags & XFS_TRANS_RES_FDBLKS) || xfs_has_lazysbcount(mp)=
);
> +       ASSERT(!((flags & XFS_TRANS_NO_WRITECOUNT) &&
> +                (flags & XFS_TRANS_WRITECOUNT_TRYLOCK)));
>
>         tp =3D kmem_cache_zalloc(xfs_trans_cache, GFP_KERNEL | __GFP_NOFA=
IL);
> -       if (!(flags & XFS_TRANS_NO_WRITECOUNT))
> +       if (flags & XFS_TRANS_WRITECOUNT_TRYLOCK) {
> +               if (!sb_start_intwrite_trylock(mp->m_super)) {
> +                       kmem_cache_free(xfs_trans_cache, tp);
> +                       return ERR_PTR(-EAGAIN);
> +               }
> +       } else if (!(flags & XFS_TRANS_NO_WRITECOUNT)) {
>                 sb_start_intwrite(mp->m_super);
> +       }
>         xfs_trans_set_context(tp);
>         tp->t_flags =3D flags;
>         tp->t_mountp =3D mp;
> @@ -252,6 +260,8 @@ xfs_trans_alloc(
>          */
>  retry:
>         tp =3D __xfs_trans_alloc(mp, flags);
> +       if (IS_ERR(tp))
> +               return PTR_ERR(tp);
>         WARN_ON(mp->m_super->s_writers.frozen =3D=3D SB_FREEZE_COMPLETE);
>         error =3D xfs_trans_reserve(tp, resp, blocks, rtextents);
>         if (error =3D=3D -ENOSPC && want_retry) {
> --
> 2.47.3
>
