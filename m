Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5939B38AC96
	for <linux-xfs@vger.kernel.org>; Fri, 12 Jun 2026 11:37:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.218.48
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781264275; cv=pass; b=s3bLg80tm+WMrV+CV22cb2a5H61udf+F53HSVdz1YGhy01YNv0xygy2QjvFfeIb2XEKWYnjlySRUERbad1qpGBnct5vJ1bJIkeRKm3n/CwfsRZHXQ+UniZENJbL0wx3occbX8GRg8/ACEfeCu5oTU+Z7OmHUzEJsshcQe8Kwuhs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781264275; c=relaxed/simple;
	bh=BusxJ/aKDkFpNvVckEVMZKK+F0gMaOca8f5053IjcD8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Ct3UOr9DgiU6OTK4CRRIx9uRcdKJ1DJ60yvthuzhEAmdMjx5iCdtzUPoChJyuc7S0m8Px8UR3VhT9r2vDuYtYfHmXtc/HoX2nIaL9PQPl8gIu8wX2OJbnZOGNVfU0uyMt2p/y4qgqmHo+YBOD5RK8LNp2P3pzYNwk+vT90oJ4NA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=N348YaV2; arc=pass smtp.client-ip=209.85.218.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="N348YaV2"
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-bef8b97655eso331855166b.0
        for <linux-xfs@vger.kernel.org>; Fri, 12 Jun 2026 04:37:52 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781264270; cv=none;
        d=google.com; s=arc-20240605;
        b=QUOkE4ZPkB/Ch8HSZMGrqtFTiFBt+PmfsGYS2WS8dcfv4I75KWW/Dli0BN4W4eBnCL
         pcXdNRQfgPYi+6d04oEVyZrMyJsqv6uHcsY5vdFtz2kVugsnbbX3KL9K0uVek0LD6IfB
         kM7jx7gI0JX8oRDVBh9FUDnxEN80HQDQNF89BcMNMxq9pOhPRb7ADVrcLnE00V8nNviZ
         1EWJQuEceK3N2VvyMHGEgvfAyXpqKlKbhWkad39gzH8xLNihXurS1XgqKuV+CPvWkaZ1
         3Ulztd0guoxfVp8WestfFDU3+aKGkDnXfPtcNbQTbNjFv70OS/khhOjweMbjAwH8OtZw
         H5Kw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=us2y2rYtgKwmZzoqsSJPTcUTfyrM/bEVPE/563r0FPI=;
        fh=D81C9Q7C/Evur2aTE6C0IkMomlMhbHfIPZxB2UTOG3Y=;
        b=OIbVngyNsM227ksBq5u1Ukkg8ry5VfDNoLozicW8jBfPw6ppRFQBDYzEhGyeIXu88V
         +WvdWXA1gsYhVSVccREUx0JO+qJxuyL5OoVv3ScO6+QimzbBK1QJ1BGgRIrD2FxwBuzY
         kr/hz8vXuPdVwjX/ZMRPRh7VGad08yVXnCEdS7EyFEMinkJwBAMlMPC0Z0PAcHbICfZz
         Tht5lEZx4LGT2oaHT2EoFHuDS5t56rk/2w7dXs6bHXO8E92Eu/y5TAv+wheHB+BKWhew
         pCn96p0jlQy7BXZQH4X1v36IZQvAixiCBOeeV1+KltBW7EsT1Xot+Lj2cBZdbuj86RcS
         sBig==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781264270; x=1781869070; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=us2y2rYtgKwmZzoqsSJPTcUTfyrM/bEVPE/563r0FPI=;
        b=N348YaV2HmZqOyywZsgi4NgCgPdCdAjoVCJlvUMHzcWf5E9uKhqium8c+2BPKea5+D
         rA5h/DXfJZSdqjtGgJf+LQ8OEgOnsFJAVbxn1f4VlOzVr8hbUmiCEB4UV8L1EgkOzg1m
         8kYxczQ1pK5OVLOO+OgPY8wwBWlISg+2mdJ6ERzdOXOi82N2SWz177ENyy5suWf0ouSH
         VtRaLPuiTrA0FD17P18nHT3p8RQ0qbBIjMsZDGMdmZObmCHiZq7UHbPQqbdlaEurilKd
         P6MhlFP4rTVnphn89/ULpKwgGkw+eauQczMY3YVz92qrNBV0q7wCh51PKrUbpr3fOHjH
         xS2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781264270; x=1781869070;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=us2y2rYtgKwmZzoqsSJPTcUTfyrM/bEVPE/563r0FPI=;
        b=oxL8YhotTlaKg/b8XHMuVQMnfbBI4Fr54olmjBp0QkKZeMQodg2MuwJ23lqIX3z6yQ
         ORg5Qct7ljyNlYX5aLuoXNOA5tT1zZP02qZ6f7R+yE1D70GZ0CFu+1aM7WYyC0emPd1v
         EQsZFGJ+tTHrkAxjtJJS0NCLHaWOJQX/iyY32jexoMqa+EXkLBZzlP4GmRxYQ7g+RT/E
         yYBKPy8isxQCSmwGM22Syq01l6jXEow9liqBBMpjPTLSBbAjZSQ70hxMe+ZDWCjYCzgx
         LcQwunZcUF14QHXq2PeDwrvweRqIFDKzorFHSfvMD9o8NLfhItlV9WG5k4efLDAMbCXv
         VXMQ==
X-Forwarded-Encrypted: i=1; AFNElJ9pip/Ghfzt68dvaOx2sHm89mmnkv2OORuW9fQtNUH5epfRycay7ugAinD/w8knyIalbzjmH+exeJo=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw/0sonwKRO6HCh6sW/6wtCY9kR1Bf714EF3Ub2t5HemRZENATP
	bCSaf+S2dioDgCjg82vHU58qq8q+u+f/Ef5r9Z4sAklQfoB6KHvejsiPCerr6NgEFEgzcRVJ0S/
	SZb9tpBfcZyFG0YN2rtZZk7FqkHKUFI8LJaOWymE=
X-Gm-Gg: Acq92OEID+lJY/ZasQyUZF+xPXJS1hK0UWve7wvq/UT7E6BYTIi4Y5OrY38lXuMjnWq
	ufw6FOcbX0wM42FNEZRebk01FuYHNfXsr6wdL5BKPAamIRJCB9lJB04M4bwV9IcUMudl4HzxkjH
	6MWfNUVZnhr76BvBWEOUhHj0CM+f/PodKovxDscuC/JpUXsHgVtTYdF7zteTjRzpUua2WUnpdJg
	qMjbeiDFbKx3M//6t0Spz+CnX3TeyeVK4yL8UCaMzzNaawg+3r2JP+Tus5P7EpHCW0AoIiryXpd
	d/N50RUW9SVMX8FXBUBjj/IQ/c27f0TKRMrLsuj1TWNlIMFG8w==
X-Received: by 2002:a17:907:75e6:b0:bf0:e345:68b with SMTP id
 a640c23a62f3a-bfe2a1149b6mr61306466b.18.1781264270220; Fri, 12 Jun 2026
 04:37:50 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260612112252.1697-1-aditya.ansh182@gmail.com> <20260612112252.1697-3-aditya.ansh182@gmail.com>
In-Reply-To: <20260612112252.1697-3-aditya.ansh182@gmail.com>
From: Aditya Prakash Srivastava <aditya.ansh182@gmail.com>
Date: Fri, 12 Jun 2026 17:07:37 +0530
X-Gm-Features: AVVi8Cfogk-EKrh4Svih0FN_YVnNfFsDALnrtLprjLxssVfES8uaarJr1fT-LqQ
Message-ID: <CAK5ssPOhjeE5KHn9q1Q663a9dJu7bzomU1QYPfXUoeha2-QaQQ@mail.gmail.com>
Subject: Re: [PATCH 2/2] xfs: prevent close() from hanging on frozen filesystems
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
> When a file with active speculative post-EOF preallocations is closed,
> xfs_file_release() synchronously triggers xfs_free_eofblocks() to clean
> them up. This requires allocating a write transaction (xfs_trans_alloc),
> which blocks indefinitely if the filesystem is currently frozen or in the
> process of freezing, as it waits to acquire the superblock's write lock.
>
> As a result, a close() system call on a read-write file descriptor can
> hang indefinitely in percpu_rwsem_wait() until the filesystem is thawed,
> even if the file is closed by a non-writer process or after all writing
> activity has already ceased.
>
> To fix this properly and avoid any potential race conditions where a free=
ze
> might come in immediately after a writable check, pass the new
> XFS_TRANS_WRITECOUNT_TRYLOCK flag to xfs_trans_alloc() when freeing
> speculative preallocations in xfs_file_release().
>
> If xfs_free_eofblocks() returns -EAGAIN on a trylock failure, we cleanly
> bypass setting XFS_EOFBLOCKS_RELEASED on the inode, ensuring subsequent
> releases or the background blockgc garbage collector can successfully ret=
ry
> the cleanup once the filesystem thaws.
>
> Also, rename the flags parameter in xfs_free_eofblocks() to trans_flags a=
s
> suggested to make its usage stand out, and update existing callers to
> pass 0 to preserve standard blocking paths.
>
> Suggested-by: Christoph Hellwig <hch@infradead.org>
> Signed-off-by: Aditya Prakash Srivastava <aditya.ansh182@gmail.com>
> ---
>  fs/xfs/xfs_bmap_util.c | 9 +++++----
>  fs/xfs/xfs_bmap_util.h | 2 +-
>  fs/xfs/xfs_file.c      | 8 +++++---
>  fs/xfs/xfs_icache.c    | 2 +-
>  fs/xfs/xfs_inode.c     | 2 +-
>  5 files changed, 13 insertions(+), 10 deletions(-)
>
> diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
> index 0ab00615f1ad..faf0630717dc 100644
> --- a/fs/xfs/xfs_bmap_util.c
> +++ b/fs/xfs/xfs_bmap_util.c
> @@ -574,7 +574,8 @@ xfs_can_free_eofblocks(
>   */
>  int
>  xfs_free_eofblocks(
> -       struct xfs_inode        *ip)
> +       struct xfs_inode        *ip,
> +       uint                    trans_flags)
>  {
>         struct xfs_trans        *tp;
>         struct xfs_mount        *mp =3D ip->i_mount;
> @@ -604,9 +605,9 @@ xfs_free_eofblocks(
>                 return 0;
>         }
>
> -       error =3D xfs_trans_alloc(mp, &M_RES(mp)->tr_itruncate, 0, 0, 0, =
&tp);
> +       error =3D xfs_trans_alloc(mp, &M_RES(mp)->tr_itruncate, 0, 0, tra=
ns_flags, &tp);
>         if (error) {
> -               ASSERT(xfs_is_shutdown(mp));
> +               ASSERT(error =3D=3D -EAGAIN || xfs_is_shutdown(mp));
>                 return error;
>         }
>
> @@ -928,7 +929,7 @@ xfs_prepare_shift(
>          * into the accessible region of the file.
>          */
>         if (xfs_can_free_eofblocks(ip)) {
> -               error =3D xfs_free_eofblocks(ip);
> +               error =3D xfs_free_eofblocks(ip, 0);
>                 if (error)
>                         return error;
>         }
> diff --git a/fs/xfs/xfs_bmap_util.h b/fs/xfs/xfs_bmap_util.h
> index c477b3361630..c13774aa0892 100644
> --- a/fs/xfs/xfs_bmap_util.h
> +++ b/fs/xfs/xfs_bmap_util.h
> @@ -66,7 +66,7 @@ int   xfs_insert_file_space(struct xfs_inode *, xfs_off=
_t offset,
>
>  /* EOF block manipulation functions */
>  bool   xfs_can_free_eofblocks(struct xfs_inode *ip);
> -int    xfs_free_eofblocks(struct xfs_inode *ip);
> +int    xfs_free_eofblocks(struct xfs_inode *ip, uint trans_flags);
>
>  int    xfs_swap_extents(struct xfs_inode *ip, struct xfs_inode *tip,
>                          struct xfs_swapext *sx);
> diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> index 845a97c9b063..76c9b2fe7c51 100644
> --- a/fs/xfs/xfs_file.c
> +++ b/fs/xfs/xfs_file.c
> @@ -1806,9 +1806,11 @@ xfs_file_release(
>          */
>         if (!xfs_iflags_test(ip, XFS_EOFBLOCKS_RELEASED) &&
>             xfs_ilock_nowait(ip, XFS_IOLOCK_EXCL)) {
> -               if (xfs_can_free_eofblocks(ip) &&
> -                   !xfs_iflags_test_and_set(ip, XFS_EOFBLOCKS_RELEASED))
> -                       xfs_free_eofblocks(ip);
> +               if (!xfs_iflags_test(ip, XFS_EOFBLOCKS_RELEASED) &&
> +                   xfs_can_free_eofblocks(ip) &&
> +                   !xfs_free_eofblocks(ip, XFS_TRANS_WRITECOUNT_TRYLOCK)=
)
> +                       xfs_iflags_set(ip, XFS_EOFBLOCKS_RELEASED);
> +
>                 xfs_iunlock(ip, XFS_IOLOCK_EXCL);
>         }
>
> diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
> index 2040a9292ee6..c575b4acb24c 100644
> --- a/fs/xfs/xfs_icache.c
> +++ b/fs/xfs/xfs_icache.c
> @@ -1259,7 +1259,7 @@ xfs_inode_free_eofblocks(
>         *lockflags |=3D XFS_IOLOCK_EXCL;
>
>         if (xfs_can_free_eofblocks(ip))
> -               return xfs_free_eofblocks(ip);
> +               return xfs_free_eofblocks(ip, 0);
>
>         /* inode could be preallocated */
>         trace_xfs_inode_free_eofblocks_invalid(ip);
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index 9978ac1422fc..1c75f51af4d7 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -1423,7 +1423,7 @@ xfs_inactive(
>                  * reference to the inode at this point anyways.
>                  */
>                 if (xfs_can_free_eofblocks(ip))
> -                       error =3D xfs_free_eofblocks(ip);
> +                       error =3D xfs_free_eofblocks(ip, 0);
>
>                 goto out;
>         }
> --
> 2.47.3
>
