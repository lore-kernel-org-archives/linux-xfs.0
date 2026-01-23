Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com [209.85.218.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86A872356BA
	for <linux-xfs@vger.kernel.org>; Fri, 23 Jan 2026 18:22:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.218.44
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769192569; cv=pass; b=kfEMggjOaOXXK8OuIk/b2zu2h1Qc2dsAJqVB36zss3eShLgtqtoCkgOD4SC56sdeMvNNJuSyDdQcL6tXRwIByf7Qfc105ZfW39iSp/KRlhjAWq/a0ku2u5WPcGhe4ZDlfePIKx+HQxLgmIhE7l5tgASwilFQaV4i18cePLoClUo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769192569; c=relaxed/simple;
	bh=lOvKL8jPLHOjzeC8LP/PDdz1kXLsa3wpT4eM+vbS7Ck=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=hTPBwJUwaV/bhaDwkETG00hCPXUsSVn+YqaKvC/yh0BEuejo3/7EcRqfqrk2yxnzO5636CGXlQLP2MMpoDqs2LTSY3PTFW8/AaKwC2JBmB3xcYXXniEKEnBtwv4vC09zQHGku7WifqwiNE/lak1I97u0fDObZeb1A9K7+I0X7b0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=EiiTIXwt; arc=pass smtp.client-ip=209.85.218.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EiiTIXwt"
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-b885e8c6700so189411866b.0
        for <linux-xfs@vger.kernel.org>; Fri, 23 Jan 2026 10:22:47 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769192566; cv=none;
        d=google.com; s=arc-20240605;
        b=WRmzHbWgV65B01n6VSJpkRhwD62G24oStfo03CYtSuGzhppOvtBqKU0+1cDQh1lYBD
         Q9ayf1QTmQQ9NETCa9tWW9N7L/G3MkPPeQwpQgxwZ/WllBqwG81TdidOSjXduOaGeOBr
         9FH+kl3p5gUuZwwCSP4XiQKWB9j0aFZitW4HkXIaLZICwbBV7bKqxU8cA3YVJpzxYeQ1
         rgpk6rQ7YR5vDVxnjiCzwcuPnqJbmj6b/Pc3HBdiwdPGB6EzDpqXj5PRqenEQjFU/P13
         En+STJsDfIM9igaj5iIPjQJSdgDJMOT5E4BbQp4JkYM0dnuH0pbpGwpI/w7j2ZSZ0Cvk
         N1xA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=nYqrCBR982tatSGEeSG6rAxU5c1u2Fh6iLjLUm7fE6o=;
        fh=9xdhaof7CukPvCYuy7Xj9Bp52kuPKw88c4sRfhpe8hw=;
        b=gb+C//Ok93xBn1/274EM3ssFXmQou9jApAYCnXkrPT22q13MVc/k1qm+reCa484Rue
         dTaK0sWu6zI7D13REK182vFyqN0tlB6LQPsrYS+6tCqrabodaBsx/jazNUUVNKTBnq0O
         7XubMTssSzO+dHWwu2YSHpfdrk3C2qs3LvgJyBDPqsvt08JCOvFeprlNXXZdoJ20WGO8
         JguzsJudH3oKOBP02QxtswhDKO3iwWDMyzUTJlYxsEdxT0Hc4iMHw7hZqp9ZF6v1zM50
         qt3Ts67AeqB+85x3wWE0O19rNf6jaictEkqOT4RkGh1cG5lybVGnYqxdmobxOoydNeJh
         k+lA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769192566; x=1769797366; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nYqrCBR982tatSGEeSG6rAxU5c1u2Fh6iLjLUm7fE6o=;
        b=EiiTIXwtbt14wDkkFkz1yV6M20s3VcYmJPjSos3SZbnvW4Pkq7oqy8G7sGLGNfOM+S
         t0OUjP9PNcQw/DmMVIdYkPJw273EhGUSsZVrvB2YSsse4ZYcTKD67cShyEnEoyIDB69t
         9DTtRLrzNXZHXXBRbbBlmYiTxLDjhtc0hCOjHQ82sYz37AV2T9GdhSxhUaIrYvOY5FR5
         FBrcE0ThYRt1kjKzuN1uCYo6h/mezWQVQtndlFazmePVozqg3RBll7aEb7R1WgwbuayV
         PfLVFVU7usNUJVdBvF1odyve/MC6wBw1I90aXrx1C7LhXYoJjITgd3af5BGAMAsPnXRM
         iNzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769192566; x=1769797366;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=nYqrCBR982tatSGEeSG6rAxU5c1u2Fh6iLjLUm7fE6o=;
        b=K+wIiiWFR4CS7KXt58/hEg/MTQi3yPZNheMnhw41/ZYeHS3kteBFGA7/6ZtAwh2ytE
         kuNwfJO6Hyk4WvUm5HLyiBXYV6TT4RetVS9B6qiz6w8yUVfcWKGoQAzhwlKPLcE0Wa3/
         rDAXXZq2HmCdKDF5UCuGPJgjA1xoALE9plWMSd8xnu8qyCqupeFSX0POB0ZM2xzwzTH8
         Dxqo9chz9y5OpAxGRciTaPseOHyMbA9S9UANe+nKfQSl7gpWoQhMq9Yin4QuuOOgM22t
         aaBnWS6ZOUSzNNoevv/uawlp/+ptQ59XAh9mdeg0k5j1rfqWI+KbK9+NLPtTK42tKGwY
         6JTA==
X-Forwarded-Encrypted: i=1; AJvYcCWwUi0Y4IlOeMcpOLowx1AXClcegLnKWUqajq3gL4vTWDqqrywJW/NZIHi0OeJPiesBk3eBjbutzJw=@vger.kernel.org
X-Gm-Message-State: AOJu0YxonGeWB2Bg+sE144RqrxcoggBqZRxDys4yhiLt9GGC0+A0ilCf
	1SIeeAPdOQvyiWHX4Nh+jvPQGOL93mThy94YL2WusCCOQTin5Skd+UYDim2zPxfXT0u4lcfAtqr
	I0YBT8yj7CzEV80WnTRWoqRjfxAHYb+c=
X-Gm-Gg: AZuq6aLTwdE93LQaEkZEkgeEd6MORB8+B0RQ+K0u+IzFYhtIohHHXVIec92QlGY4KtQ
	6IpisFvuwNa3Zrfrb3sJNhUciWpaXmb94ESG+vLoII1cZ9Zj0JpPUSz9gc/PSAeH5tEXP5JSqrB
	sdQAeyWYTJ99lE8aIvjPAbSfaqhvugCKkD61SSPMziPiuikljTgODhwF5c/5H6Jeh2pB6oX1tSh
	YUA/+81H4VfVMz8R3hJdifHX2UxsYp6xAmFxvowNQNgJ1JhZL25ObbwkqDzUluYYUllc79Vqswh
	naW7qm9HzyO7fbOnBkxh3bvIYKZTTg==
X-Received: by 2002:a17:907:940d:b0:b80:3846:d46 with SMTP id
 a640c23a62f3a-b885ac7c3e0mr316284866b.20.1769192564672; Fri, 23 Jan 2026
 10:22:44 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <176915153667.1677852.8049980969235323328.stgit@frogsfrogsfrogs> <176915153716.1677852.3636395936252128481.stgit@frogsfrogsfrogs>
In-Reply-To: <176915153716.1677852.3636395936252128481.stgit@frogsfrogsfrogs>
From: Jiaming Zhang <r772577952@gmail.com>
Date: Sat, 24 Jan 2026 02:22:05 +0800
X-Gm-Features: AZwV_Qh8SYhiSmvcxD2Zi6jcb9vN7lMOdKyckJX0IYAt-be3o1zZLjx6Xa_R27U
Message-ID: <CANypQFYZfQB-iiWHkewhgNyn9kW9bBps5yr1X_tAmhMier59kA@mail.gmail.com>
Subject: Re: [PATCH 1/5] xfs: get rid of the xchk_xfile_*_descr calls
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, stable@vger.kernel.org, linux-xfs@vger.kernel.org, 
	hch@lst.de
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Darrick J. Wong <djwong@kernel.org> =E4=BA=8E2026=E5=B9=B41=E6=9C=8823=E6=
=97=A5=E5=91=A8=E4=BA=94 15:03=E5=86=99=E9=81=93=EF=BC=9A
>
> From: Darrick J. Wong <djwong@kernel.org>
>
> The xchk_xfile_*_descr macros call kasprintf, which can fail to allocate
> memory if the formatted string is larger than 16 bytes (or whatever the
> nofail guarantees are nowadays).  Some of them could easily exceed that,
> and Jiaming Zhang found a few places where that can happen with syzbot.
>
> The descriptions are debugging aids and aren't required to be unique, so
> let's just pass in static strings and eliminate this path to failure.
> Note this patch touches a number of commits, most of which were merged
> between 6.6 and 6.14.
>
> Cc: r772577952@gmail.com
> Cc: <stable@vger.kernel.org> # v6.12
> Fixes: ab97f4b1c03075 ("xfs: repair AGI unlinked inode bucket lists")
> Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
> ---
>  fs/xfs/scrub/common.h            |   25 -------------------------
>  fs/xfs/scrub/agheader_repair.c   |   13 ++++---------
>  fs/xfs/scrub/alloc_repair.c      |    5 +----
>  fs/xfs/scrub/attr_repair.c       |   20 +++++---------------
>  fs/xfs/scrub/bmap_repair.c       |    6 +-----
>  fs/xfs/scrub/dir.c               |   13 ++++---------
>  fs/xfs/scrub/dir_repair.c        |   11 +++--------
>  fs/xfs/scrub/dirtree.c           |   11 +++--------
>  fs/xfs/scrub/ialloc_repair.c     |    5 +----
>  fs/xfs/scrub/nlinks.c            |    6 ++----
>  fs/xfs/scrub/parent.c            |   11 +++--------
>  fs/xfs/scrub/parent_repair.c     |   23 ++++++-----------------
>  fs/xfs/scrub/quotacheck.c        |   13 +++----------
>  fs/xfs/scrub/refcount_repair.c   |   13 ++-----------
>  fs/xfs/scrub/rmap_repair.c       |    5 +----
>  fs/xfs/scrub/rtbitmap_repair.c   |    6 ++----
>  fs/xfs/scrub/rtrefcount_repair.c |   15 +++------------
>  fs/xfs/scrub/rtrmap_repair.c     |    5 +----
>  fs/xfs/scrub/rtsummary.c         |    7 ++-----
>  19 files changed, 47 insertions(+), 166 deletions(-)
>
>
> diff --git a/fs/xfs/scrub/common.h b/fs/xfs/scrub/common.h
> index ddbc065c798cd1..f2ecc68538f0c3 100644
> --- a/fs/xfs/scrub/common.h
> +++ b/fs/xfs/scrub/common.h
> @@ -246,31 +246,6 @@ static inline bool xchk_could_repair(const struct xf=
s_scrub *sc)
>
>  int xchk_metadata_inode_forks(struct xfs_scrub *sc);
>
> -/*
> - * Helper macros to allocate and format xfile description strings.
> - * Callers must kfree the pointer returned.
> - */
> -#define xchk_xfile_descr(sc, fmt, ...) \
> -       kasprintf(XCHK_GFP_FLAGS, "XFS (%s): " fmt, \
> -                       (sc)->mp->m_super->s_id, ##__VA_ARGS__)
> -#define xchk_xfile_ag_descr(sc, fmt, ...) \
> -       kasprintf(XCHK_GFP_FLAGS, "XFS (%s): AG 0x%x " fmt, \
> -                       (sc)->mp->m_super->s_id, \
> -                       (sc)->sa.pag ? \
> -                               pag_agno((sc)->sa.pag) : (sc)->sm->sm_agn=
o, \
> -                       ##__VA_ARGS__)
> -#define xchk_xfile_ino_descr(sc, fmt, ...) \
> -       kasprintf(XCHK_GFP_FLAGS, "XFS (%s): inode 0x%llx " fmt, \
> -                       (sc)->mp->m_super->s_id, \
> -                       (sc)->ip ? (sc)->ip->i_ino : (sc)->sm->sm_ino, \
> -                       ##__VA_ARGS__)
> -#define xchk_xfile_rtgroup_descr(sc, fmt, ...) \
> -       kasprintf(XCHK_GFP_FLAGS, "XFS (%s): rtgroup 0x%x " fmt, \
> -                       (sc)->mp->m_super->s_id, \
> -                       (sc)->sa.pag ? \
> -                               rtg_rgno((sc)->sr.rtg) : (sc)->sm->sm_agn=
o, \
> -                       ##__VA_ARGS__)
> -
>  /*
>   * Setting up a hook to wait for intents to drain is costly -- we have t=
o take
>   * the CPU hotplug lock and force an i-cache flush on all CPUs once to s=
et it
> diff --git a/fs/xfs/scrub/agheader_repair.c b/fs/xfs/scrub/agheader_repai=
r.c
> index cd6f0223879f49..a2f6a7f71d8396 100644
> --- a/fs/xfs/scrub/agheader_repair.c
> +++ b/fs/xfs/scrub/agheader_repair.c
> @@ -1708,7 +1708,6 @@ xrep_agi(
>  {
>         struct xrep_agi         *ragi;
>         struct xfs_mount        *mp =3D sc->mp;
> -       char                    *descr;
>         unsigned int            i;
>         int                     error;
>
> @@ -1742,17 +1741,13 @@ xrep_agi(
>         xagino_bitmap_init(&ragi->iunlink_bmp);
>         sc->buf_cleanup =3D xrep_agi_buf_cleanup;
>
> -       descr =3D xchk_xfile_ag_descr(sc, "iunlinked next pointers");
> -       error =3D xfarray_create(descr, 0, sizeof(xfs_agino_t),
> -                       &ragi->iunlink_next);
> -       kfree(descr);
> +       error =3D xfarray_create("iunlinked next pointers", 0,
> +                       sizeof(xfs_agino_t), &ragi->iunlink_next);
>         if (error)
>                 return error;
>
> -       descr =3D xchk_xfile_ag_descr(sc, "iunlinked prev pointers");
> -       error =3D xfarray_create(descr, 0, sizeof(xfs_agino_t),
> -                       &ragi->iunlink_prev);
> -       kfree(descr);
> +       error =3D xfarray_create("iunlinked prev pointers", 0,
> +                       sizeof(xfs_agino_t), &ragi->iunlink_prev);
>         if (error)
>                 return error;
>
> diff --git a/fs/xfs/scrub/alloc_repair.c b/fs/xfs/scrub/alloc_repair.c
> index bed6a09aa79112..b6fe1f23819eb2 100644
> --- a/fs/xfs/scrub/alloc_repair.c
> +++ b/fs/xfs/scrub/alloc_repair.c
> @@ -850,7 +850,6 @@ xrep_allocbt(
>         struct xrep_abt         *ra;
>         struct xfs_mount        *mp =3D sc->mp;
>         unsigned int            busy_gen;
> -       char                    *descr;
>         int                     error;
>
>         /* We require the rmapbt to rebuild anything. */
> @@ -876,11 +875,9 @@ xrep_allocbt(
>         }
>
>         /* Set up enough storage to handle maximally fragmented free spac=
e. */
> -       descr =3D xchk_xfile_ag_descr(sc, "free space records");
> -       error =3D xfarray_create(descr, mp->m_sb.sb_agblocks / 2,
> +       error =3D xfarray_create("free space records", mp->m_sb.sb_agbloc=
ks / 2,
>                         sizeof(struct xfs_alloc_rec_incore),
>                         &ra->free_records);
> -       kfree(descr);
>         if (error)
>                 goto out_ra;
>
> diff --git a/fs/xfs/scrub/attr_repair.c b/fs/xfs/scrub/attr_repair.c
> index 09d63aa10314b0..eded354dec11ee 100644
> --- a/fs/xfs/scrub/attr_repair.c
> +++ b/fs/xfs/scrub/attr_repair.c
> @@ -1529,7 +1529,6 @@ xrep_xattr_setup_scan(
>         struct xrep_xattr       **rxp)
>  {
>         struct xrep_xattr       *rx;
> -       char                    *descr;
>         int                     max_len;
>         int                     error;
>
> @@ -1555,35 +1554,26 @@ xrep_xattr_setup_scan(
>                 goto out_rx;
>
>         /* Set up some staging for salvaged attribute keys and values */
> -       descr =3D xchk_xfile_ino_descr(sc, "xattr keys");
> -       error =3D xfarray_create(descr, 0, sizeof(struct xrep_xattr_key),
> +       error =3D xfarray_create("xattr keys", 0, sizeof(struct xrep_xatt=
r_key),
>                         &rx->xattr_records);
> -       kfree(descr);
>         if (error)
>                 goto out_rx;
>
> -       descr =3D xchk_xfile_ino_descr(sc, "xattr names");
> -       error =3D xfblob_create(descr, &rx->xattr_blobs);
> -       kfree(descr);
> +       error =3D xfblob_create("xattr names", &rx->xattr_blobs);
>         if (error)
>                 goto out_keys;
>
>         if (xfs_has_parent(sc->mp)) {
>                 ASSERT(sc->flags & XCHK_FSGATES_DIRENTS);
>
> -               descr =3D xchk_xfile_ino_descr(sc,
> -                               "xattr retained parent pointer entries");
> -               error =3D xfarray_create(descr, 0,
> +               error =3D xfarray_create("xattr parent pointer entries", =
0,
>                                 sizeof(struct xrep_xattr_pptr),
>                                 &rx->pptr_recs);
> -               kfree(descr);
>                 if (error)
>                         goto out_values;
>
> -               descr =3D xchk_xfile_ino_descr(sc,
> -                               "xattr retained parent pointer names");
> -               error =3D xfblob_create(descr, &rx->pptr_names);
> -               kfree(descr);
> +               error =3D xfblob_create("xattr parent pointer names",
> +                               &rx->pptr_names);
>                 if (error)
>                         goto out_pprecs;
>
> diff --git a/fs/xfs/scrub/bmap_repair.c b/fs/xfs/scrub/bmap_repair.c
> index 1084213b8e9b88..747cd9389b491d 100644
> --- a/fs/xfs/scrub/bmap_repair.c
> +++ b/fs/xfs/scrub/bmap_repair.c
> @@ -923,7 +923,6 @@ xrep_bmap(
>         bool                    allow_unwritten)
>  {
>         struct xrep_bmap        *rb;
> -       char                    *descr;
>         xfs_extnum_t            max_bmbt_recs;
>         bool                    large_extcount;
>         int                     error =3D 0;
> @@ -945,11 +944,8 @@ xrep_bmap(
>         /* Set up enough storage to handle the max records for this fork.=
 */
>         large_extcount =3D xfs_has_large_extent_counts(sc->mp);
>         max_bmbt_recs =3D xfs_iext_max_nextents(large_extcount, whichfork=
);
> -       descr =3D xchk_xfile_ino_descr(sc, "%s fork mapping records",
> -                       whichfork =3D=3D XFS_DATA_FORK ? "data" : "attr")=
;
> -       error =3D xfarray_create(descr, max_bmbt_recs,
> +       error =3D xfarray_create("fork mapping records", max_bmbt_recs,
>                         sizeof(struct xfs_bmbt_rec), &rb->bmap_records);
> -       kfree(descr);
>         if (error)
>                 goto out_rb;
>
> diff --git a/fs/xfs/scrub/dir.c b/fs/xfs/scrub/dir.c
> index c877bde71e6280..4f849d98cbdd22 100644
> --- a/fs/xfs/scrub/dir.c
> +++ b/fs/xfs/scrub/dir.c
> @@ -1102,22 +1102,17 @@ xchk_directory(
>         sd->xname.name =3D sd->namebuf;
>
>         if (xfs_has_parent(sc->mp)) {
> -               char            *descr;
> -
>                 /*
>                  * Set up some staging memory for dirents that we can't c=
heck
>                  * due to locking contention.
>                  */
> -               descr =3D xchk_xfile_ino_descr(sc, "slow directory entrie=
s");
> -               error =3D xfarray_create(descr, 0, sizeof(struct xchk_dir=
ent),
> -                               &sd->dir_entries);
> -               kfree(descr);
> +               error =3D xfarray_create("slow directory entries", 0,
> +                               sizeof(struct xchk_dirent), &sd->dir_entr=
ies);
>                 if (error)
>                         goto out_sd;
>
> -               descr =3D xchk_xfile_ino_descr(sc, "slow directory entry =
names");
> -               error =3D xfblob_create(descr, &sd->dir_names);
> -               kfree(descr);
> +               error =3D xfblob_create("slow directory entry names",
> +                               &sd->dir_names);
>                 if (error)
>                         goto out_entries;
>         }
> diff --git a/fs/xfs/scrub/dir_repair.c b/fs/xfs/scrub/dir_repair.c
> index 8d3b550990b58a..7a21b688a47158 100644
> --- a/fs/xfs/scrub/dir_repair.c
> +++ b/fs/xfs/scrub/dir_repair.c
> @@ -1784,20 +1784,15 @@ xrep_dir_setup_scan(
>         struct xrep_dir         *rd)
>  {
>         struct xfs_scrub        *sc =3D rd->sc;
> -       char                    *descr;
>         int                     error;
>
>         /* Set up some staging memory for salvaging dirents. */
> -       descr =3D xchk_xfile_ino_descr(sc, "directory entries");
> -       error =3D xfarray_create(descr, 0, sizeof(struct xrep_dirent),
> -                       &rd->dir_entries);
> -       kfree(descr);
> +       error =3D xfarray_create("directory entries", 0,
> +                       sizeof(struct xrep_dirent), &rd->dir_entries);
>         if (error)
>                 return error;
>
> -       descr =3D xchk_xfile_ino_descr(sc, "directory entry names");
> -       error =3D xfblob_create(descr, &rd->dir_names);
> -       kfree(descr);
> +       error =3D xfblob_create("directory entry names", &rd->dir_names);
>         if (error)
>                 goto out_xfarray;
>
> diff --git a/fs/xfs/scrub/dirtree.c b/fs/xfs/scrub/dirtree.c
> index 3a9cdf8738b6db..f9c85b8b194fa4 100644
> --- a/fs/xfs/scrub/dirtree.c
> +++ b/fs/xfs/scrub/dirtree.c
> @@ -92,7 +92,6 @@ xchk_setup_dirtree(
>         struct xfs_scrub        *sc)
>  {
>         struct xchk_dirtree     *dl;
> -       char                    *descr;
>         int                     error;
>
>         xchk_fsgates_enable(sc, XCHK_FSGATES_DIRENTS);
> @@ -116,16 +115,12 @@ xchk_setup_dirtree(
>
>         mutex_init(&dl->lock);
>
> -       descr =3D xchk_xfile_ino_descr(sc, "dirtree path steps");
> -       error =3D xfarray_create(descr, 0, sizeof(struct xchk_dirpath_ste=
p),
> -                       &dl->path_steps);
> -       kfree(descr);
> +       error =3D xfarray_create("dirtree path steps", 0,
> +                       sizeof(struct xchk_dirpath_step), &dl->path_steps=
);
>         if (error)
>                 goto out_dl;
>
> -       descr =3D xchk_xfile_ino_descr(sc, "dirtree path names");
> -       error =3D xfblob_create(descr, &dl->path_names);
> -       kfree(descr);
> +       error =3D xfblob_create("dirtree path names", &dl->path_names);
>         if (error)
>                 goto out_steps;
>
> diff --git a/fs/xfs/scrub/ialloc_repair.c b/fs/xfs/scrub/ialloc_repair.c
> index 14e48d3f1912bf..b1d00167d263f4 100644
> --- a/fs/xfs/scrub/ialloc_repair.c
> +++ b/fs/xfs/scrub/ialloc_repair.c
> @@ -797,7 +797,6 @@ xrep_iallocbt(
>  {
>         struct xrep_ibt         *ri;
>         struct xfs_mount        *mp =3D sc->mp;
> -       char                    *descr;
>         xfs_agino_t             first_agino, last_agino;
>         int                     error =3D 0;
>
> @@ -816,11 +815,9 @@ xrep_iallocbt(
>         /* Set up enough storage to handle an AG with nothing but inodes.=
 */
>         xfs_agino_range(mp, pag_agno(sc->sa.pag), &first_agino, &last_agi=
no);
>         last_agino /=3D XFS_INODES_PER_CHUNK;
> -       descr =3D xchk_xfile_ag_descr(sc, "inode index records");
> -       error =3D xfarray_create(descr, last_agino,
> +       error =3D xfarray_create("inode index records", last_agino,
>                         sizeof(struct xfs_inobt_rec_incore),
>                         &ri->inode_records);
> -       kfree(descr);
>         if (error)
>                 goto out_ri;
>
> diff --git a/fs/xfs/scrub/nlinks.c b/fs/xfs/scrub/nlinks.c
> index 091c79e432e592..2ba686e4de8bc5 100644
> --- a/fs/xfs/scrub/nlinks.c
> +++ b/fs/xfs/scrub/nlinks.c
> @@ -990,7 +990,6 @@ xchk_nlinks_setup_scan(
>         struct xchk_nlink_ctrs  *xnc)
>  {
>         struct xfs_mount        *mp =3D sc->mp;
> -       char                    *descr;
>         unsigned long long      max_inos;
>         xfs_agnumber_t          last_agno =3D mp->m_sb.sb_agcount - 1;
>         xfs_agino_t             first_agino, last_agino;
> @@ -1007,10 +1006,9 @@ xchk_nlinks_setup_scan(
>          */
>         xfs_agino_range(mp, last_agno, &first_agino, &last_agino);
>         max_inos =3D XFS_AGINO_TO_INO(mp, last_agno, last_agino) + 1;
> -       descr =3D xchk_xfile_descr(sc, "file link counts");
> -       error =3D xfarray_create(descr, min(XFS_MAXINUMBER + 1, max_inos)=
,
> +       error =3D xfarray_create("file link counts",
> +                       min(XFS_MAXINUMBER + 1, max_inos),
>                         sizeof(struct xchk_nlink), &xnc->nlinks);
> -       kfree(descr);
>         if (error)
>                 goto out_teardown;
>
> diff --git a/fs/xfs/scrub/parent.c b/fs/xfs/scrub/parent.c
> index 11d5de10fd567b..23c195d14494e5 100644
> --- a/fs/xfs/scrub/parent.c
> +++ b/fs/xfs/scrub/parent.c
> @@ -755,7 +755,6 @@ xchk_parent_pptr(
>         struct xfs_scrub        *sc)
>  {
>         struct xchk_pptrs       *pp;
> -       char                    *descr;
>         int                     error;
>
>         pp =3D kvzalloc(sizeof(struct xchk_pptrs), XCHK_GFP_FLAGS);
> @@ -768,16 +767,12 @@ xchk_parent_pptr(
>          * Set up some staging memory for parent pointers that we can't c=
heck
>          * due to locking contention.
>          */
> -       descr =3D xchk_xfile_ino_descr(sc, "slow parent pointer entries")=
;
> -       error =3D xfarray_create(descr, 0, sizeof(struct xchk_pptr),
> -                       &pp->pptr_entries);
> -       kfree(descr);
> +       error =3D xfarray_create("slow parent pointer entries", 0,
> +                       sizeof(struct xchk_pptr), &pp->pptr_entries);
>         if (error)
>                 goto out_pp;
>
> -       descr =3D xchk_xfile_ino_descr(sc, "slow parent pointer names");
> -       error =3D xfblob_create(descr, &pp->pptr_names);
> -       kfree(descr);
> +       error =3D xfblob_create("slow parent pointer names", &pp->pptr_na=
mes);
>         if (error)
>                 goto out_entries;
>
> diff --git a/fs/xfs/scrub/parent_repair.c b/fs/xfs/scrub/parent_repair.c
> index 2949feda627175..897902c54178d4 100644
> --- a/fs/xfs/scrub/parent_repair.c
> +++ b/fs/xfs/scrub/parent_repair.c
> @@ -1497,7 +1497,6 @@ xrep_parent_setup_scan(
>         struct xrep_parent      *rp)
>  {
>         struct xfs_scrub        *sc =3D rp->sc;
> -       char                    *descr;
>         struct xfs_da_geometry  *geo =3D sc->mp->m_attr_geo;
>         int                     max_len;
>         int                     error;
> @@ -1525,32 +1524,22 @@ xrep_parent_setup_scan(
>                 goto out_xattr_name;
>
>         /* Set up some staging memory for logging parent pointer updates.=
 */
> -       descr =3D xchk_xfile_ino_descr(sc, "parent pointer entries");
> -       error =3D xfarray_create(descr, 0, sizeof(struct xrep_pptr),
> -                       &rp->pptr_recs);
> -       kfree(descr);
> +       error =3D xfarray_create("parent pointer entries", 0,
> +                       sizeof(struct xrep_pptr), &rp->pptr_recs);
>         if (error)
>                 goto out_xattr_value;
>
> -       descr =3D xchk_xfile_ino_descr(sc, "parent pointer names");
> -       error =3D xfblob_create(descr, &rp->pptr_names);
> -       kfree(descr);
> +       error =3D xfblob_create("parent pointer names", &rp->pptr_names);
>         if (error)
>                 goto out_recs;
>
>         /* Set up some storage for copying attrs before the mapping excha=
nge */
> -       descr =3D xchk_xfile_ino_descr(sc,
> -                               "parent pointer retained xattr entries");
> -       error =3D xfarray_create(descr, 0, sizeof(struct xrep_parent_xatt=
r),
> -                       &rp->xattr_records);
> -       kfree(descr);
> +       error =3D xfarray_create("parent pointer xattr entries", 0,
> +                       sizeof(struct xrep_parent_xattr), &rp->xattr_reco=
rds);
>         if (error)
>                 goto out_names;
>
> -       descr =3D xchk_xfile_ino_descr(sc,
> -                               "parent pointer retained xattr values");
> -       error =3D xfblob_create(descr, &rp->xattr_blobs);
> -       kfree(descr);
> +       error =3D xfblob_create("parent pointer xattr values", &rp->xattr=
_blobs);
>         if (error)
>                 goto out_attr_keys;
>
> diff --git a/fs/xfs/scrub/quotacheck.c b/fs/xfs/scrub/quotacheck.c
> index d412a8359784ee..3b2f4ccde2ec09 100644
> --- a/fs/xfs/scrub/quotacheck.c
> +++ b/fs/xfs/scrub/quotacheck.c
> @@ -741,7 +741,6 @@ xqcheck_setup_scan(
>         struct xfs_scrub        *sc,
>         struct xqcheck          *xqc)
>  {
> -       char                    *descr;
>         struct xfs_quotainfo    *qi =3D sc->mp->m_quotainfo;
>         unsigned long long      max_dquots =3D XFS_DQ_ID_MAX + 1ULL;
>         int                     error;
> @@ -756,28 +755,22 @@ xqcheck_setup_scan(
>
>         error =3D -ENOMEM;
>         if (xfs_this_quota_on(sc->mp, XFS_DQTYPE_USER)) {
> -               descr =3D xchk_xfile_descr(sc, "user dquot records");
> -               error =3D xfarray_create(descr, max_dquots,
> +               error =3D xfarray_create("user dquot records", max_dquots=
,
>                                 sizeof(struct xqcheck_dquot), &xqc->ucoun=
ts);
> -               kfree(descr);
>                 if (error)
>                         goto out_teardown;
>         }
>
>         if (xfs_this_quota_on(sc->mp, XFS_DQTYPE_GROUP)) {
> -               descr =3D xchk_xfile_descr(sc, "group dquot records");
> -               error =3D xfarray_create(descr, max_dquots,
> +               error =3D xfarray_create("group dquot records", max_dquot=
s,
>                                 sizeof(struct xqcheck_dquot), &xqc->gcoun=
ts);
> -               kfree(descr);
>                 if (error)
>                         goto out_teardown;
>         }
>
>         if (xfs_this_quota_on(sc->mp, XFS_DQTYPE_PROJ)) {
> -               descr =3D xchk_xfile_descr(sc, "project dquot records");
> -               error =3D xfarray_create(descr, max_dquots,
> +               error =3D xfarray_create("project dquot records", max_dqu=
ots,
>                                 sizeof(struct xqcheck_dquot), &xqc->pcoun=
ts);
> -               kfree(descr);
>                 if (error)
>                         goto out_teardown;
>         }
> diff --git a/fs/xfs/scrub/refcount_repair.c b/fs/xfs/scrub/refcount_repai=
r.c
> index 9c8cb5332da042..360fd7354880a7 100644
> --- a/fs/xfs/scrub/refcount_repair.c
> +++ b/fs/xfs/scrub/refcount_repair.c
> @@ -123,13 +123,7 @@ int
>  xrep_setup_ag_refcountbt(
>         struct xfs_scrub        *sc)
>  {
> -       char                    *descr;
> -       int                     error;
> -
> -       descr =3D xchk_xfile_ag_descr(sc, "rmap record bag");
> -       error =3D xrep_setup_xfbtree(sc, descr);
> -       kfree(descr);
> -       return error;
> +       return xrep_setup_xfbtree(sc, "rmap record bag");
>  }
>
>  /* Check for any obvious conflicts with this shared/CoW staging extent. =
*/
> @@ -704,7 +698,6 @@ xrep_refcountbt(
>  {
>         struct xrep_refc        *rr;
>         struct xfs_mount        *mp =3D sc->mp;
> -       char                    *descr;
>         int                     error;
>
>         /* We require the rmapbt to rebuild anything. */
> @@ -717,11 +710,9 @@ xrep_refcountbt(
>         rr->sc =3D sc;
>
>         /* Set up enough storage to handle one refcount record per block.=
 */
> -       descr =3D xchk_xfile_ag_descr(sc, "reference count records");
> -       error =3D xfarray_create(descr, mp->m_sb.sb_agblocks,
> +       error =3D xfarray_create("reference count records", mp->m_sb.sb_a=
gblocks,
>                         sizeof(struct xfs_refcount_irec),
>                         &rr->refcount_records);
> -       kfree(descr);
>         if (error)
>                 goto out_rr;
>
> diff --git a/fs/xfs/scrub/rmap_repair.c b/fs/xfs/scrub/rmap_repair.c
> index 17d4a38d735cb8..cfd1cf403b37eb 100644
> --- a/fs/xfs/scrub/rmap_repair.c
> +++ b/fs/xfs/scrub/rmap_repair.c
> @@ -164,14 +164,11 @@ xrep_setup_ag_rmapbt(
>         struct xfs_scrub        *sc)
>  {
>         struct xrep_rmap        *rr;
> -       char                    *descr;
>         int                     error;
>
>         xchk_fsgates_enable(sc, XCHK_FSGATES_RMAP);
>
> -       descr =3D xchk_xfile_ag_descr(sc, "reverse mapping records");
> -       error =3D xrep_setup_xfbtree(sc, descr);
> -       kfree(descr);
> +       error =3D xrep_setup_xfbtree(sc, "reverse mapping records");
>         if (error)
>                 return error;
>
> diff --git a/fs/xfs/scrub/rtbitmap_repair.c b/fs/xfs/scrub/rtbitmap_repai=
r.c
> index 203a1a97c5026e..41d6736a529d02 100644
> --- a/fs/xfs/scrub/rtbitmap_repair.c
> +++ b/fs/xfs/scrub/rtbitmap_repair.c
> @@ -43,7 +43,6 @@ xrep_setup_rtbitmap(
>         struct xchk_rtbitmap    *rtb)
>  {
>         struct xfs_mount        *mp =3D sc->mp;
> -       char                    *descr;
>         unsigned long long      blocks =3D mp->m_sb.sb_rbmblocks;
>         int                     error;
>
> @@ -52,9 +51,8 @@ xrep_setup_rtbitmap(
>                 return error;
>
>         /* Create an xfile to hold our reconstructed bitmap. */
> -       descr =3D xchk_xfile_rtgroup_descr(sc, "bitmap file");
> -       error =3D xfile_create(descr, blocks * mp->m_sb.sb_blocksize, &sc=
->xfile);
> -       kfree(descr);
> +       error =3D xfile_create("realtime bitmap file",
> +                       blocks * mp->m_sb.sb_blocksize, &sc->xfile);
>         if (error)
>                 return error;
>
> diff --git a/fs/xfs/scrub/rtrefcount_repair.c b/fs/xfs/scrub/rtrefcount_r=
epair.c
> index 983362447826de..b35e39cce7ad5a 100644
> --- a/fs/xfs/scrub/rtrefcount_repair.c
> +++ b/fs/xfs/scrub/rtrefcount_repair.c
> @@ -128,13 +128,7 @@ int
>  xrep_setup_rtrefcountbt(
>         struct xfs_scrub        *sc)
>  {
> -       char                    *descr;
> -       int                     error;
> -
> -       descr =3D xchk_xfile_ag_descr(sc, "rmap record bag");
> -       error =3D xrep_setup_xfbtree(sc, descr);
> -       kfree(descr);
> -       return error;
> +       return xrep_setup_xfbtree(sc, "realtime rmap record bag");
>  }
>
>  /* Check for any obvious conflicts with this shared/CoW staging extent. =
*/
> @@ -704,7 +698,6 @@ xrep_rtrefcountbt(
>  {
>         struct xrep_rtrefc      *rr;
>         struct xfs_mount        *mp =3D sc->mp;
> -       char                    *descr;
>         int                     error;
>
>         /* We require the rmapbt to rebuild anything. */
> @@ -722,11 +715,9 @@ xrep_rtrefcountbt(
>         rr->sc =3D sc;
>
>         /* Set up enough storage to handle one refcount record per rt ext=
ent. */
> -       descr =3D xchk_xfile_ag_descr(sc, "reference count records");
> -       error =3D xfarray_create(descr, mp->m_sb.sb_rextents,
> -                       sizeof(struct xfs_refcount_irec),
> +       error =3D xfarray_create("realtime reference count records",
> +                       mp->m_sb.sb_rextents, sizeof(struct xfs_refcount_=
irec),
>                         &rr->refcount_records);
> -       kfree(descr);
>         if (error)
>                 goto out_rr;
>
> diff --git a/fs/xfs/scrub/rtrmap_repair.c b/fs/xfs/scrub/rtrmap_repair.c
> index 7561941a337a1f..749977a66e40ff 100644
> --- a/fs/xfs/scrub/rtrmap_repair.c
> +++ b/fs/xfs/scrub/rtrmap_repair.c
> @@ -103,14 +103,11 @@ xrep_setup_rtrmapbt(
>         struct xfs_scrub        *sc)
>  {
>         struct xrep_rtrmap      *rr;
> -       char                    *descr;
>         int                     error;
>
>         xchk_fsgates_enable(sc, XCHK_FSGATES_RMAP);
>
> -       descr =3D xchk_xfile_rtgroup_descr(sc, "reverse mapping records")=
;
> -       error =3D xrep_setup_xfbtree(sc, descr);
> -       kfree(descr);
> +       error =3D xrep_setup_xfbtree(sc, "realtime reverse mapping record=
s");
>         if (error)
>                 return error;
>
> diff --git a/fs/xfs/scrub/rtsummary.c b/fs/xfs/scrub/rtsummary.c
> index 4ac679c1bd29cd..fb78cff2ac3a16 100644
> --- a/fs/xfs/scrub/rtsummary.c
> +++ b/fs/xfs/scrub/rtsummary.c
> @@ -43,7 +43,6 @@ xchk_setup_rtsummary(
>         struct xfs_scrub        *sc)
>  {
>         struct xfs_mount        *mp =3D sc->mp;
> -       char                    *descr;
>         struct xchk_rtsummary   *rts;
>         int                     error;
>
> @@ -70,10 +69,8 @@ xchk_setup_rtsummary(
>          * Create an xfile to construct a new rtsummary file.  The xfile =
allows
>          * us to avoid pinning kernel memory for this purpose.
>          */
> -       descr =3D xchk_xfile_descr(sc, "realtime summary file");
> -       error =3D xfile_create(descr, XFS_FSB_TO_B(mp, mp->m_rsumblocks),
> -                       &sc->xfile);
> -       kfree(descr);
> +       error =3D xfile_create("realtime summary file",
> +                       XFS_FSB_TO_B(mp, mp->m_rsumblocks), &sc->xfile);
>         if (error)
>                 return error;
>
>

After applying patches and running the reproducer for ~10 minutes, no
issues were triggered.

Tested-by: Jiaming Zhang <r772577952@gmail.com>
