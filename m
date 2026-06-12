Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com [209.85.218.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4A21352017
	for <linux-xfs@vger.kernel.org>; Fri, 12 Jun 2026 12:47:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.218.49
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781268474; cv=pass; b=O4eZumfWok62IKCGQfLtsO0Ey3Baq3qd36vBUTM7pyeaiyLLTa1MmNR0LU2npcJEBG/ceyo6IliOgEklrTrpXLsQekFbmkqmqAwoEyRmY1Fe1PxtScq17NbzweuilJeVu5fIsJyicV427RrLbezfR019mADxZDoBZvjIBsJ43tU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781268474; c=relaxed/simple;
	bh=VGmZesSSLmZNxPo3Ssa1PEm8Mb+/hE2Hz3enV10zimU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ROXXC7AIY9uAX83mAqzjAOiRLY9cjPMllra/DLQHRYtnqjr/4txOnlDPOUqepOfxdutd6di51LmTzT7A2xLTLB3mDS86GwcgSF11vRmuuXFwn6h32s5kFCqGzzrF3aTVJbeg5Htfp5EkPez9ZfY6/CcQwizO1F+/2dNASR1LWW4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=A6gL2C66; arc=pass smtp.client-ip=209.85.218.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="A6gL2C66"
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-bec3f69d343so141796066b.0
        for <linux-xfs@vger.kernel.org>; Fri, 12 Jun 2026 05:47:52 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781268471; cv=none;
        d=google.com; s=arc-20240605;
        b=elEd5w04Ml1xsiEppBgJGF+Cm8SIJgACcW+BPU2xKUBkPw/yqi4VPo0jeZ2TNaVl98
         0CbVs/Ta9npD9vPGqbU2mTq4pdMm/BP8TQHWZ3SFMf95WR9TF7Rx3mZdNiQZ3ABDA2UG
         SOO+OPU33jsXd+9xzy0U88PFAB3OdKNh6Vh7cRx745a7eQgvozriAhVqJi+9FW8WsQ0+
         4MkixG3MvTJmwlasKQtJ39+QZQ/3/YHjpBZFRD50+BX1z5gscKMxwprTtEGf89Hlg49e
         mcEE/2laXFvMyCOp0sp9pKclkY17cXZ3BpZiNJ5/Z0iMVbN/uE6ryNiHIaT+k6BGHdLA
         R05Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=ag2eGDwU8syV1RH+N+wd/1kZqB8xDggym7Gt+/wUo1w=;
        fh=NpOHYtWGMDxFu7wcUdEBEkLLYTw2yTTvYMg60PuYglY=;
        b=TJaVdsrE9lf93jRoM5pMz2JxQ87gwAWEdS/tJfoPxlaIEQ7g2Z0GXVStVkxZPQdRPM
         t04deuO6tk8QmqJMw7aZpvDqwmuVAzYdY7ti+Uocb1ygDlrjjuHHGtksh6WHaA3VLb38
         7MdMgOvN9wQ44b1/zSDuonWGRsSEvWrZUREGXo6y7qtFdBWJ+QP2vJ5FKNX22agcd0Eb
         YR9ekXh2YDD8IFQVKsBTXqx7CInBRUGrwN4RTQ/lgZajVTh33ddy68GC6oKtMD2nEmDN
         T7Hf01ElCw2LJPTduTAE8sFNmU3AjCCkGCKDbsdF4MFjyUf+KD/i/QEciYAUnrdktRXl
         tPOQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781268471; x=1781873271; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ag2eGDwU8syV1RH+N+wd/1kZqB8xDggym7Gt+/wUo1w=;
        b=A6gL2C666izy4LslmsVY7Xhck06JSIpkQnRI0xUymeTeKo35orxWH6gU5kBkeq8MH2
         wcNcxZOsZ/8UMcSMwBwUPSMTjMw15BmmWnjS9wHyeyXdoL2ZPSwLRPEGYx8q3y9irDf4
         3FrrGjFDJO0bq1i8ZMNtMJBCqF85EYRxINh6WYJvsDLsdoa1GENYswhdKE/TLpSAR6w8
         ogzuvX0UNuZEvv1jH53qcGrXJ+GNyeDazgC3EaZq2jck1P+K/fnf1DK5yImgsPpzHf8+
         92MdyrW1gfyKyu1FFzKBTwttu66vHKFbBhDhSwbuCcn9v/sw5k06/s616B8rll1p04e5
         xxgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781268471; x=1781873271;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ag2eGDwU8syV1RH+N+wd/1kZqB8xDggym7Gt+/wUo1w=;
        b=Rmv6EMpgnOrfKj1Khz2lCH/Bijk12Bzd7om3Ct1nJrVQShq8TifHl1Oxr0mCSuFUsZ
         WLDRHhPlhAjm4neqKeSIOADDScYlEceYGukFA/+2RzuxGBJbhamD7XMFI8ia1o3lIj1z
         qDpLlfMHneM00JxjZU6DVKn9Ugl7158tFqGtphzzOMi/E0KoBHM2SdZuTJfU2gAUGJB/
         Ag3ezjoblIQ6v1JDyaWk+he0lg/H2rC1BEkR7tXtNw58B5RskElH6L2caTAycH1iHoJ/
         BuHMl9frjiCc5pvSE4b2Bn0IiyLjB5pY5xNxwYWy6zAZb2tElbNaxmLSOGx4mQ5eKbnK
         VCVg==
X-Forwarded-Encrypted: i=1; AFNElJ+zmjGwd1+9vuaJIFk7mn6GwQ3vDI+WJ8z91ZF0+QX/qAuVfXOS4Jn2i1flnuOZvKSP6gq6C33/Wfo=@vger.kernel.org
X-Gm-Message-State: AOJu0YwVBmpyXnx/9uhtwYE/mgSfmkbEoLBdrrkRLVwZ4h051qHxVrfY
	wKjJUAx50c0K1S0rSNt/P/r119Jo9Sgu35hrRZj/6cuwEBTuab/o00FCa0Ydm7LbDBFRKT4+NMR
	sAhtdA9y5zzHVrzxc5+Yam14Ya7ehces=
X-Gm-Gg: Acq92OHMLXEoiCj6Im0eIsUQLJ4p0ZNh5hW7j4yaTL3xFKsyL4Kw/LGZOM22iSdhaBQ
	9TDidc0bEL/f+bWrhneSXsnLNOjy3aWFRBV7K72MrVOWVSde8VN1qlUqlCtYCKwISbmKZ1fSaAV
	47pPTSzrX0wopA4quG9Xx6uRDI7jXvCM9WxgUveRQgSB8CBkq7XFWRl3u4G4Lr1Kqifyd8vkSlT
	6w0wWa5cEqOpT03Lk5kViJW2VluNY7JGwI76V7dL5KFs4aqb5Abj+nAwhD2vFbT7mtKWWKtlQS6
	B0x1ppWftFye1wg7OCwwYurjQqfW5rvj+T8GsPWfbZ2WeGn82w==
X-Received: by 2002:a17:907:2708:b0:bee:9809:3ccd with SMTP id
 a640c23a62f3a-bfe279319d1mr96864466b.4.1781268470807; Fri, 12 Jun 2026
 05:47:50 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260612114917.2192-1-aditya.ansh182@gmail.com> <20260612114917.2192-3-aditya.ansh182@gmail.com>
In-Reply-To: <20260612114917.2192-3-aditya.ansh182@gmail.com>
From: Aditya Prakash Srivastava <aditya.ansh182@gmail.com>
Date: Fri, 12 Jun 2026 18:17:39 +0530
X-Gm-Features: AVVi8CeC_1Qypk47107-i_0fcvy4vjJWMWXCU0OrEsgpWvmHotAkLK4JijrbJLE
Message-ID: <CAK5ssPPaX69jy_GGw4Qw=7JQPoc+quz8jqnep3uN7FCqFsxaYw@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] xfs: prevent close() from hanging on frozen filesystems
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
