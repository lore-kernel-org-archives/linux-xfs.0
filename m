Received: from mail-yw1-f171.google.com (mail-yw1-f171.google.com [209.85.128.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 141E547A0DC
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jun 2026 20:39:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.128.171
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782851981; cv=pass; b=IVxB9ofmpXWyp/EDPzB2yJXyqkJo24qnv+nfQVoA+2NXzeDLCw4EUd+fSJKMxKH5zIbHPoLiMoF1jgIx/kaoKUao/OE3ZocmlmS0hdmE+5C5+rZnChsM26qJFXQjf7ON4W00S3Yo3EJfC+Yn99eGlcxbrYvx4gm0duUn20l69a0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782851981; c=relaxed/simple;
	bh=5D38aeFmFPo4QXzw9TaB4T12tNTsX9FO9UgEPQFTE7s=;
	h=In-Reply-To:References:MIME-Version:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=f1Liq46Stz9dhjhMLllcZnGuqJjVQPhl43rSXflpVyVHQteus/CY81WOgm+CcPbXLOnmoLOlLrZGT9JisxvWeyWuvzOZCA3rAgHNvugv1Snne8XGcp1218kg7pogwvXgAljYwWyudmfsfaocc6yv+9/E0XM8uro/3ksI/Ku0IlQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=RyZwKlk+; arc=pass smtp.client-ip=209.85.128.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RyZwKlk+"
Received: by mail-yw1-f171.google.com with SMTP id 00721157ae682-804239c418bso49225887b3.0
        for <linux-xfs@vger.kernel.org>; Tue, 30 Jun 2026 13:39:39 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1782851979; cv=none;
        d=google.com; s=arc-20260327;
        b=XLvZ9qiHgyIar7mtftvhJJj6rWvvUGDbzFvcuXE71aJd3ok9FjdKHF/EyhMQmtpFCp
         c0LPLlzL+mheWUBAYNqWG2KUFb+EBFkFIYpiEPgTBr0swefFLCOq/s1ZDgL0zArK7/h6
         dW9ePIfTOPog6jxJtBb9Unlbgg+pcVgJ1zqDQ4i33YA/pqknzaSqk05Fga0o9IFveER9
         H3sT/d/1eli7MZl/zuKajEE3rdQkVX/7RXqmBvnK9FxFsCdyXeoBy9Hfsq7zKss37G06
         DYqVJFRLHJUt4nrRlt6VIbSl8QDanJdnXLtdDvvcCPhXNEANVCIdhwBj0HtmCG+E3sGH
         fEFA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:mime-version:references
         :in-reply-to:dkim-signature;
        bh=5D38aeFmFPo4QXzw9TaB4T12tNTsX9FO9UgEPQFTE7s=;
        fh=neVViZNbnCuS5rbzlEoWKFuQAMPNbHyw2uIJf2Si+nQ=;
        b=I3j14dMXv42A+6wJNNcOUlXlgo0HAZhkqkIDfDJcayPj0Oaeduv2LZxjRSNMQlkxMT
         XVcWzDkLXDbbieDWOBeKhNcy2hbqsZxQkkUyiSL0yyCe7uRlOkaP9KCrEK9w8MiEyrfN
         XxzQFHwJABX4XYMd0IGHBM0da6kgda/gPmTHP4hh8QBq5+pcYd8MrOPj9fBhFvzYYD2y
         lVd6mu11+syLUDHMgXpyqeucsw1G4XJggPk778RvztjTICq9Iy4Cg2j7uxhKTPGaQ4AE
         XrLlF9PZDGPS7mo2ncZ/cTwgTWYZw3ye1OTpXaP0BQN3oollBvDVa0MAJSVvtZm2HryR
         cDJw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782851979; x=1783456779; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:references
         :in-reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=5D38aeFmFPo4QXzw9TaB4T12tNTsX9FO9UgEPQFTE7s=;
        b=RyZwKlk+VJfBGdfqjCx1Q7d4kIgGXpu2oOfO1RaDxLvx4nnIVwLAOjGYSY/hNFqsWY
         w2p0f8lmiKuK34iaujbzpFRBWInveNDJB+hJrb8OIygLPoUnuF9HqrA0Y3W+eQKnjkQ+
         6vLeoR02Gh4AZruWV0H1XHCn6bUmfH2HaW3AxlC+dBgFFMqlnL7I2ICfgyIY23k9JSgF
         CAcYO+vin/YdxacIGpJ8qORIZDDCH/u/703WUlAmJACTsb+1sk70l6wtBau/7PA1c8SA
         Ld4/rB8XJNL0vR0W28FQc265oXFx/ZqU6AGQXOs0k3+/e9GuQbU0ceJy5aW01ts7ljRK
         H+pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782851979; x=1783456779;
        h=cc:to:subject:message-id:date:from:mime-version:references
         :in-reply-to:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5D38aeFmFPo4QXzw9TaB4T12tNTsX9FO9UgEPQFTE7s=;
        b=E7lYoiW370utpC7GmmXjhzFoutbOsT2QQuDuxI3OF9WUKTSqmJPHgXWMahmgSx9cjo
         gWc1uFw5FhNQ7ICaOWUeaapfQfal/5Qzrpo5r+S8NJaczg+9sGGgDHYEId6p6uejXWLX
         IhEnPABB8VuoxKeF/6lx89k+LXL5UaeEn4lFewlAeBxM8Vyxn/z98uV03NRPBpfdfiRs
         qSwyO7rhg5lUlIzA7DAH+2pEMxscPmB630FL2EM9LgDvGsNxGg9VOfsbClv6cHq7+Zxv
         IMnXftzGE+Ue/hu1SFzZfawYKhiA9e1ABvsOHKOr9bbmMOlheOust0pF0qyEbc1DE00p
         +M+g==
X-Forwarded-Encrypted: i=1; AHgh+RpdX2oLYOrhMt5VP/LT4bpft21HcstLS8tnYWuC6r0MQeJNf21I2L2hRdnZYCfh3o3AUGohUqyyFus=@vger.kernel.org
X-Gm-Message-State: AOJu0YwKnJQKsEFNmOnP9cAd4bQHBH06YA6JtITMQfHDIIcy+6BG48Vv
	h+dBaYO8LexRtumG2h+9lB1BgOCuZ9GGCXSVcCyKqR3mEQsr7eigaEkNjc+JaYWxz9DAhVRmOxc
	W5avWEoyCmJFuUVNyhwuWJnUREvsFeFA=
X-Gm-Gg: AfdE7cm2d8XdlEFqNEBqDR9VxKr+Wqo5OAIpcKv/eOL9iugp9wDSDhW/tTKHNCNGHke
	XMVEP3EcokKnLiMhZxwiLkvHaljHgW4eF/5FAN8k33YfRmNgL9yZJ4umfTZgpJEJPm/n+f0ivdD
	DGS4IsbD0BbYi8Yy9WFxozH73+RSI3RmT5IvE3Mh12hvTwqnEcRRRgH/JGVZrLgR/4xkTvDPZSA
	L33Vt+Tsj9EVl0IHHq24f56CuqBarpWeD45hdpFwkjbO5udr5nYBM3deaUMB4Ci6HqrgT10
X-Received: by 2002:a05:690c:4b04:b0:7dd:16e2:7291 with SMTP id
 00721157ae682-8120365d817mr19039887b3.39.1782851979033; Tue, 30 Jun 2026
 13:39:39 -0700 (PDT)
Received: from 77377267392 named unknown by gmailapi.google.com with HTTPREST;
 Tue, 30 Jun 2026 13:39:35 -0700
Received: from 77377267392 named unknown by gmailapi.google.com with HTTPREST;
 Tue, 30 Jun 2026 13:39:35 -0700
In-Reply-To: <20260630161113.GB6526@frogsfrogsfrogs>
References: <20260630100621.7173-1-alhouseenyousef@gmail.com> <20260630161113.GB6526@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Yousef Alhouseen <alhouseenyousef@gmail.com>
Date: Tue, 30 Jun 2026 13:39:35 -0700
X-Gm-Features: AVVi8CdvJBhb56hLbqMtooFd6yugGBtf8dueg3H7CS2QMgBj44HN8wGt5PUPelQ
Message-ID: <CAMuQ4bXGcSf2=MVknbgt709Jkv4fgiCx9UEocSEFTDkzPY5bFg@mail.gmail.com>
Subject: Re: [PATCH v2] xfs: zero newly allocated btree root space
To: djwong@kernel.org
Cc: cem@kernel.org, linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Yes. The KMSAN report traces the allocation through
xfs_bmap_extents_to_btree(), which calls xfs_bmap_broot_realloc(...,
1). With no existing root, that reaches krealloc(NULL, new_size). The
conversion initializes the block header, first key, and end-anchored
pointer, but does not initialize the layout/alignment gap within the
full if_broot_bytes allocation. XFS_ILOG_DBROOT later copies that
complete byte count into the log.

So the observed bytes are root-layout slack from the extents-to-btree
conversion, rather than record storage that a later insertion should
have filled.

Thanks for the review.

On Tue, 30 Jun 2026 09:11:13 -0700, "Darrick J. Wong" <djwong@kernel.org> wrote:
> On Tue, Jun 30, 2026 at 12:06:21PM +0200, Yousef Alhouseen wrote:
> > xfs_broot_realloc() preserves the existing in-inode btree root while
> > growing its allocation, but leaves the added bytes uninitialized. The
> > inode log formatter copies if_broot_bytes bytes into the journal, so those
> > bytes reach the log record and its CRC calculation before every location
> > has necessarily been overwritten by btree updates.
> >
> > Request __GFP_ZERO for the initial allocation and every subsequent
> > allocation or reallocation, as required by krealloc() semantics. This
> > keeps stale heap contents out of the filesystem log without a separate
> > memset after each growth.
> >
> > Fixes: 6c1c55ac3c05 ("xfs: refactor the inode fork memory allocation functions")
> > Suggested-by: Darrick J. Wong <djwong@kernel.org>
> > Reported-by: syzbot+97f2c05378c5d68dcb8c@syzkaller.appspotmail.com
> > Closes: https://syzkaller.appspot.com/bug?extid=97f2c05378c5d68dcb8c
>
> I wonder, did you figure out exactly *which* code path was leaving
> if_broot partially uninitialized? Somewhere out there, someone will get
> cranky at the reduced performance that comes from zeroing (especially on
> krealloc) when most of the codepaths will immediately zero/set the
> buffer anyway.
>
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Yousef Alhouseen <alhouseenyousef@gmail.com>
>
> In the long run I'm willing to take a small performance hit of having
> many layered protections as is reasonably performant to avoid spilling
> kernel memory contents to disk, though, so
>
> Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
>
> (others may disagree)
>
> --D
>
> > ---
> > Changes in v2:
> > - Use __GFP_ZERO instead of an explicit memset after krealloc().
> > - Apply __GFP_ZERO consistently across the allocation lifetime.
> >
> > fs/xfs/libxfs/xfs_inode_fork.c | 8 +++++---
> > 1 file changed, 5 insertions(+), 3 deletions(-)
> >
> > diff --git a/fs/xfs/libxfs/xfs_inode_fork.c b/fs/xfs/libxfs/xfs_inode_fork.c
> > index 606a36526ce2..dc05540fa85b 100644
> > --- a/fs/xfs/libxfs/xfs_inode_fork.c
> > +++ b/fs/xfs/libxfs/xfs_inode_fork.c
> > @@ -384,7 +384,8 @@ xfs_broot_alloc(
> > ASSERT(ifp->if_broot == NULL);
> >
> > ifp->if_broot = kmalloc(new_size,
> > - GFP_KERNEL | __GFP_NOLOCKDEP | __GFP_NOFAIL);
> > + GFP_KERNEL | __GFP_NOLOCKDEP | __GFP_NOFAIL |
> > + __GFP_ZERO);
> > ifp->if_broot_bytes = new_size;
> > return ifp->if_broot;
> > }
> > @@ -417,7 +418,8 @@ xfs_broot_realloc(
> > if (ifp->if_broot_bytes > 0 && ifp->if_broot_bytes > new_size) {
> > struct xfs_btree_block *old_broot = ifp->if_broot;
> >
> > - ifp->if_broot = kmalloc(new_size, GFP_KERNEL | __GFP_NOFAIL);
> > + ifp->if_broot = kmalloc(new_size,
> > + GFP_KERNEL | __GFP_NOFAIL | __GFP_ZERO);
> > ifp->if_broot_bytes = new_size;
> > memcpy(ifp->if_broot, old_broot, new_size);
> > kfree(old_broot);
> > @@ -429,7 +431,7 @@ xfs_broot_realloc(
> > * object.
> > */
> > ifp->if_broot = krealloc(ifp->if_broot, new_size,
> > - GFP_KERNEL | __GFP_NOFAIL);
> > + GFP_KERNEL | __GFP_NOFAIL | __GFP_ZERO);
> > ifp->if_broot_bytes = new_size;
> > return ifp->if_broot;
> > }
> > --
> > 2.54.0
> >
