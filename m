Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com [209.85.218.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 802B23D3482
	for <linux-xfs@vger.kernel.org>; Fri, 12 Jun 2026 12:48:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.218.44
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781268506; cv=pass; b=YFu4j91KlcqSScIvDZ9JpoW4+7Y0BI59TdmPFWQJ5OvZrmc2gKm9OwwbKsaNR9ADkOQS/8n6A2EEEteVxvk7ktoPQFTUbp+1fOB04DmKlfjP4IYSV6hb0CDd9BfldSMFMhjo7jsEMe350IzpjuBMaOSQNL8+xJCnUwsHnnAE7A0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781268506; c=relaxed/simple;
	bh=wzyefegPQ56HaP/L1vGqh6l0U8XZBoOuHJKAbUD1xfE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=aC9D0ArjdQbpIg4DK8jyZcPOpbgIJq/VzvXB7WrtOmwjcdO6ICC22W/Z3TbRPp509bnVjqML3q/udQLLpudRikzZc2nWm8egWJ04EeQYOEoZZVVOFXiF9ICuQLHLtjQG6G0yLxsjRBGxu8Ycv+Rt9NTWoR5BEYA4wFAWPOFw6b4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mZ/Sas0R; arc=pass smtp.client-ip=209.85.218.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mZ/Sas0R"
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-bec423a5265so177483366b.1
        for <linux-xfs@vger.kernel.org>; Fri, 12 Jun 2026 05:48:24 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781268503; cv=none;
        d=google.com; s=arc-20240605;
        b=ejwSvDP4sEAiBEbEHaSrlmV53javkpyYpFVctwBSmmuxGm77W7v/VDbliF2xgztD8g
         BBifQSH+UdziE5KfBkZCCC5lkbtmq/ydF9LhHQzJzFfehKjKLpNOwjpNreS9umcV8yVp
         EwjJxxlIzWimoXP8N+ZVLftST1o8tWf6fZzo3QTArYlKGRd5ZDwTp/UhLGfnt4Pr5WcI
         4cE7xmYdx1z4TwxAXpfTalIZkYn8PrSn6FmI8/a9SH9R7peY2iVtAJaq0R4maLv58o/V
         9UH8V8aGk0XZShRQgZ2XKutW4nz1bi+6KiHA6MeCN0H2IuB1rKRndfY4C4n6vXQE13XD
         QJeg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=C/B24oGIDZCDxK/eGLCqt4DHARmDrIFcF//V/k+AUtA=;
        fh=fIH5XONVf3M0S7BkBgHY+1H0ZsiGUP7dXw6Hs8fno+g=;
        b=jGHzrMzGflfL4KkN0Awf54SUKLbg42XtB3uej6mxnf2ouZI3TfjpJBLgMSZe7myHn/
         4uFfqfpfFbFK07Z8fGxIqDxYA1WszNUQiIOCi0kg/frr/dzAQjmakFt+51iZ+oT1Gyck
         pq+PsfqIyuPgcxCoX9zDPsQfd75kzfXUYSaxKv8yc5rUv6+jqIYrosAjQgH7KVFcNynC
         ve7YDCtXVQ/EWDCYUyiBVJRClpSPgXCBFeGB8zAwP8GCeOUHOuzPCgwZiziMTvCwdnBW
         70iUBMuXLLYUwzfNEae6V4OnQ/W8nZw53vqFDfx8IebzsGs5bMCJIDNTnk6ffbASyf7d
         IMvw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781268503; x=1781873303; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=C/B24oGIDZCDxK/eGLCqt4DHARmDrIFcF//V/k+AUtA=;
        b=mZ/Sas0Rr2Ae8XJV2K1x12ancKIjrL82SpdoTRjGXrRNLDLc5civ9lnTN6CaIEv0Qt
         6aCOaEmTWrdkWw6WZExJ2gdOX/4jcexU/Lq61MEsA1ZaCwEXuUuv2pJI4NVEJxop9ZyS
         FFJU/FvhJgs+FQCakUAvvo4/nvvwEhv76wSw5iPFufVk8s7YtbeoSeAIe1RikWYA97R0
         CHeeq/oDMtj+V1Xek7smLhv0bSXhanpezgdmaRa8D5QIKFIWnA5VLbF+z/pYjtOWLCCB
         LWQUz+hi4N9AByrt2Cz3UXD7yNvUxyd0tHw9Ay5G+0IWB+EI92+H5oYtcOVMcOchMZ0Y
         2nCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781268503; x=1781873303;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=C/B24oGIDZCDxK/eGLCqt4DHARmDrIFcF//V/k+AUtA=;
        b=LzNc73cESjMYheDEAGZKulArgMW13BKf6on/KJY6/PVsrWoxsqnVDVRLgjrLOqRmiB
         vMHsK/nXcicXIMxYIEHmw4wfJw0337BwPtRJgFcPOZ0ajif3TwpndNx/2tyh+htY+OAg
         dTLJSKtQG5VjOOH0y+cEn8Sw0iB1huhQCi6qozuCvIXp7FffjzY4kB7KkP8plq441xZP
         H6/cwytYptoqkNCEs576xdvSzYnS0GnqYYT3HU6naQW0m8rxOyl3fKy2WmoZqZo4fVwI
         FKSHgUZzZYPxVY/J6FFoBBwUHML1Xk6rNAZImOZ+TWUKJvKfdaBEC/WW2OPO1SJIurFY
         ksgQ==
X-Forwarded-Encrypted: i=1; AFNElJ8km7V1kp/PYUZJn1ke9ncKTv1vaueu8rEqYIuE3GNXTNxDIjHFbtteoTZprUEdC/9FXtrAipRornw=@vger.kernel.org
X-Gm-Message-State: AOJu0YyX0GeOwlOYuhHuf/tG2LBW6WkXRUSXr0Efq15fkzTduUhxCVWP
	E4/PCTygOhH6DD5dwN4gKh7a677/HZZVFo7FfprfIxBzOffT4nuQw7oyLkU9lNl8D1G/EvRKgpO
	hyLVyTOIcO5itEW96kxv+r5RmlZjDkzc=
X-Gm-Gg: Acq92OE+iEU5s5ipeQiZNJPMSSZjQuleebXwlPBaPhuKUz+kXxTasxiSC00y10Tw5S8
	0c4FzELqsxeS+JQcIzcijhmSsDp6ai0mLzwuMUqtoyBlur14X7qqNK6XocF0Y9aLrEpXCHkzpH2
	9xRS3qEZuCrHcylOobwOAm85CFUu64pplnJb1ycCOFkp9BvV5siH2kb+iYNA09ptLgNuyWz0kyb
	f8mIPnGJ9DJS8u8OuOsZ8NFD/8Ec/G5cEkrCxj8jM0jlUXVsgx28EOz91T8Sve9Z7PnjmPTWLyI
	DsQW9gs4hazyWOowLPAGrw97bSHeyp5vNVXTcJg9G7ofaLj2Gw==
X-Received: by 2002:a17:907:7212:b0:bd5:7c2:7622 with SMTP id
 a640c23a62f3a-bfe2c09ded7mr139483466b.49.1781268502503; Fri, 12 Jun 2026
 05:48:22 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260612114917.2192-1-aditya.ansh182@gmail.com> <20260612114917.2192-2-aditya.ansh182@gmail.com>
In-Reply-To: <20260612114917.2192-2-aditya.ansh182@gmail.com>
From: Aditya Prakash Srivastava <aditya.ansh182@gmail.com>
Date: Fri, 12 Jun 2026 18:18:11 +0530
X-Gm-Features: AVVi8Ce1MI2RmRgthudlq6kJ37NVTS7dG9j4zOH4Owck4u_ON47J8q_fURPt-co
Message-ID: <CAK5ssPNGQcpodPo2kWpxjqC7kvmwu+GPc_RGqTY_ip9QSpbfPw@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] xfs: add a XFS_TRANS_WRITECOUNT_TRYLOCK flag
To: Carlos Maiolino <cem@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Apologies for the mailing list noise in v2; a local stale patch file
collision caused the wrong files and version headers to be sent.
Please ignore this version v2 completely and take a look at the
clean v3 series.

Thanks
Aditya Prakash Srivastava

On Fri, Jun 12, 2026 at 5:20=E2=80=AFPM Aditya Srivastava
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
