Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com [209.85.208.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42CE631A045
	for <linux-xfs@vger.kernel.org>; Fri, 12 Sep 2025 16:28:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757694519; cv=none; b=FfybsZLh9y49Tvg/9IwMaUSstDvPNySp2QqIvN8/SrfLxPQjWbKYhQrywkj1vrsY2h2+SkMHWNYMPFQEno/PgJkZprgoIEnxg1uMNsPS+MEvahbkYSIel2nyJwdupH3TToXDgtWe2onmjubPrgNlanTL8+DblvEu1ZWux7gJXHs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757694519; c=relaxed/simple;
	bh=sfOjqy5Hmnq/IKULzCIl01+HRUC2yrcuDNx1K4f5Qg4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=bjePUf71aaUAR9S2VlinpEEwhWTMQ/sQwS8KInPnkK3TItNMFoR5p12WDheUC5c7rLdnP48hbp7RSotEXAbcbi2nzmNQRqOdQSODK7WD4/qAw0cYhX9nqeo+RriOMhNhbx15fnIP1IlVuu3INkvjiRydBcPybFcO7u3gu+vKI2w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=XLhNDUu7; arc=none smtp.client-ip=209.85.208.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XLhNDUu7"
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-62ed8943293so2155428a12.0
        for <linux-xfs@vger.kernel.org>; Fri, 12 Sep 2025 09:28:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757694515; x=1758299315; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5bCLfdduUpvZu4Yibc21wcUORVmaWAAbs5DHC/ImGBY=;
        b=XLhNDUu7k1hhreFP7iLBRa3n2nljhGEha8gWbtlmhNASrLUkaIRZ5RCVe6YGkMC5WT
         kL4m2ScOjm7hwFJEBeiDNzwi6zkI6l2wPwFunRc9Mv4kQft48IKEAhmnhe8Afar58cfV
         Yl7wgEDvtPcnxHxVrhMVaiEdJU0c87e/SLWrzhvzg9HD+wI314Cd0xD0UlMCE04TzV0o
         MY2AZfu4BNKuUrxawgIa+ldR5oC4rcPgBbstdIUBDyDPh4zbTg3/fOWBajLGqEvGeeRd
         H//EKVsXW/KE+bJkms9VCjroMCXnCskvBLOjgYLq5w/A5I6Cp4Hts4tgqWElIpiTCsSf
         iVZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757694515; x=1758299315;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5bCLfdduUpvZu4Yibc21wcUORVmaWAAbs5DHC/ImGBY=;
        b=Ausm8TcaPYyX2nEm9jQl45UCDm2wKtUaLPwgOtMRYdKit2Yux8ye4YGuDCPrky9lkl
         G2TKjQw+NOp4iEGN87y+jN01NzjlcYCZi81e3ZF/JHZpxNSWhNVsZy5abQ+uY73ibfWt
         7jR8BLievNm292goFTbtIEcjGmOrBU3HRAqstSi1+HXlJFlZCcmsYyQHE0Rn3wcEGMhv
         mbo1grunL0WrCrKNdWnaho30IgyPraCcZf5ibIYBusv5k7+EG2Sx7PoY9IeCthASOMAC
         89znnAXrjTSew9CU8mWq4r8lUs3i9Mx77P3C57d2Ee8rFIEqxVeKz10te6cTAUOX3xAI
         xLrA==
X-Forwarded-Encrypted: i=1; AJvYcCWh4TBiq+x65O788pCusurBTrMKbRcpL76oKAXTRhaWtYvuYt0GFGvYH4gh+LWnTLi6wBr6861idqY=@vger.kernel.org
X-Gm-Message-State: AOJu0YxiuRZ25ieH1ZHNidaI8zwpg/rDNvgO8RtiKD0znxywreL0ReAL
	QK8P2khUpVra3rq8Svsswzn8DSDqogxVuGrGhfIKslaNRO9GDnbVqgiFDhkBv54bOxCrDPHaH/u
	TbI34487cJfcPfhAaA6Fprd0oSwEJS88=
X-Gm-Gg: ASbGncv2LlOVgkZcAAxCkloaZmsBBel9mQ7kHtPECWbtHr7JGRi8XCYCVnrGUFJe/wv
	682DkJg/FkgfL2gympxY6uIRGEV8SlePbMP6Ej8mRa02o7SHi2t8RvhzW3/8sjOgsLoEYm6JwDA
	mc3xGKtYhIpzvmsGlcIs5S8OTVuTJ04o1LeW+1Qc5OY0sBLMd+mcpf3EX3PabVJj3S+zBASQ/E6
	NzqcihBZSLALsgT5g==
X-Google-Smtp-Source: AGHT+IFxDXD9UC5TygRPl8WtGCb5YNCX87Wur2PfXYtTjzcTqAYPz4r4TKpRuMfc3CdtuJG+VeCu/l1dEmF5bBkQd0Q=
X-Received: by 2002:a05:6402:5109:b0:62e:c6b8:6071 with SMTP id
 4fb4d7f45d1cf-62ed97da5b0mr3759364a12.4.1757694515190; Fri, 12 Sep 2025
 09:28:35 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250912152855.689917-1-tahbertschinger@gmail.com> <20250912152855.689917-8-tahbertschinger@gmail.com>
In-Reply-To: <20250912152855.689917-8-tahbertschinger@gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Fri, 12 Sep 2025 18:28:21 +0200
X-Gm-Features: AS18NWCSzfK3NoifN2tzIKAg6Q8TBBOoqWssuUVqrGMtiJ6gMp_y-P_PmkEK_Gk
Message-ID: <CAOQ4uxgFXfASm_Barwy=62oQT1FXF+mvGvt82qwwLdmhBhBGgA@mail.gmail.com>
Subject: Re: [PATCH v3 07/10] exportfs: new FILEID_CACHED flag for
 non-blocking fh lookup
To: Thomas Bertschinger <tahbertschinger@gmail.com>
Cc: io-uring@vger.kernel.org, axboe@kernel.dk, linux-fsdevel@vger.kernel.org, 
	viro@zeniv.linux.org.uk, brauner@kernel.org, linux-nfs@vger.kernel.org, 
	linux-xfs@vger.kernel.org, cem@kernel.org, chuck.lever@oracle.com, 
	jlayton@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Sep 12, 2025 at 5:27=E2=80=AFPM Thomas Bertschinger
<tahbertschinger@gmail.com> wrote:
>
> This defines a new flag FILEID_CACHED that the VFS can set in the
> handle_type field of struct file_handle to request that the FS
> implementations of fh_to_{dentry,parent}() only complete if they can
> satisfy the request with cached data.
>
> Because not every FS implementation will recognize this new flag, those
> that do recognize the flag can indicate their support using a new
> export flag, EXPORT_OP_NONBLOCK.
>
> If FILEID_CACHED is set in a file handle, but the filesystem does not
> set EXPORT_OP_NONBLOCK, then the VFS will return -EAGAIN without
> attempting to call into the filesystem code.
>
> exportfs_decode_fh_raw() is updated to respect the new flag by returning
> -EAGAIN when it would need to do an operation that may not be possible
> with only cached data.
>
> Suggested-by: Amir Goldstein <amir73il@gmail.com>
> Signed-off-by: Thomas Bertschinger <tahbertschinger@gmail.com>
> ---
> I didn't apply Amir's Reviewed-by for this patch because I added the
> Documenation section, which was not reviewed in v2.

Documentation looks good.

Reviewed-by: Amir Goldstein <amir73il@gmail.com>

Thanks,
Amir.

>
>  Documentation/filesystems/nfs/exporting.rst |  6 ++++++
>  fs/exportfs/expfs.c                         | 12 ++++++++++++
>  fs/fhandle.c                                |  2 ++
>  include/linux/exportfs.h                    |  5 +++++
>  4 files changed, 25 insertions(+)
>
> diff --git a/Documentation/filesystems/nfs/exporting.rst b/Documentation/=
filesystems/nfs/exporting.rst
> index de64d2d002a2..70f46eaeb0d4 100644
> --- a/Documentation/filesystems/nfs/exporting.rst
> +++ b/Documentation/filesystems/nfs/exporting.rst
> @@ -238,3 +238,9 @@ following flags are defined:
>      all of an inode's dirty data on last close. Exports that behave this
>      way should set EXPORT_OP_FLUSH_ON_CLOSE so that NFSD knows to skip
>      waiting for writeback when closing such files.
> +
> +  EXPORT_OP_NONBLOCK - FS supports fh_to_{dentry,parent}() using cached =
data
> +    When performing open_by_handle_at(2) using io_uring, it is useful to
> +    complete the file open using only cached data when possible, otherwi=
se
> +    failing with -EAGAIN.  This flag indicates that the filesystem suppo=
rts this
> +    mode of operation.
> diff --git a/fs/exportfs/expfs.c b/fs/exportfs/expfs.c
> index 949ce6ef6c4e..e2cfdd9d6392 100644
> --- a/fs/exportfs/expfs.c
> +++ b/fs/exportfs/expfs.c
> @@ -441,6 +441,7 @@ exportfs_decode_fh_raw(struct vfsmount *mnt, struct f=
id *fid, int fh_len,
>                        void *context)
>  {
>         const struct export_operations *nop =3D mnt->mnt_sb->s_export_op;
> +       bool decode_cached =3D fileid_type & FILEID_CACHED;
>         struct dentry *result, *alias;
>         char nbuf[NAME_MAX+1];
>         int err;
> @@ -453,6 +454,10 @@ exportfs_decode_fh_raw(struct vfsmount *mnt, struct =
fid *fid, int fh_len,
>          */
>         if (!exportfs_can_decode_fh(nop))
>                 return ERR_PTR(-ESTALE);
> +
> +       if (decode_cached && !(nop->flags & EXPORT_OP_NONBLOCK))
> +               return ERR_PTR(-EAGAIN);
> +
>         result =3D nop->fh_to_dentry(mnt->mnt_sb, fid, fh_len, fileid_typ=
e);
>         if (IS_ERR_OR_NULL(result))
>                 return result;
> @@ -481,6 +486,10 @@ exportfs_decode_fh_raw(struct vfsmount *mnt, struct =
fid *fid, int fh_len,
>                  * filesystem root.
>                  */
>                 if (result->d_flags & DCACHE_DISCONNECTED) {
> +                       err =3D -EAGAIN;
> +                       if (decode_cached)
> +                               goto err_result;
> +
>                         err =3D reconnect_path(mnt, result, nbuf);
>                         if (err)
>                                 goto err_result;
> @@ -526,6 +535,9 @@ exportfs_decode_fh_raw(struct vfsmount *mnt, struct f=
id *fid, int fh_len,
>                 err =3D PTR_ERR(target_dir);
>                 if (IS_ERR(target_dir))
>                         goto err_result;
> +               err =3D -EAGAIN;
> +               if (decode_cached && (target_dir->d_flags & DCACHE_DISCON=
NECTED))
> +                       goto err_result;
>
>                 /*
>                  * And as usual we need to make sure the parent directory=
 is
> diff --git a/fs/fhandle.c b/fs/fhandle.c
> index 2dc669aeb520..509ff8983f94 100644
> --- a/fs/fhandle.c
> +++ b/fs/fhandle.c
> @@ -273,6 +273,8 @@ static int do_handle_to_path(struct file_handle *hand=
le, struct path *path,
>         if (IS_ERR_OR_NULL(dentry)) {
>                 if (dentry =3D=3D ERR_PTR(-ENOMEM))
>                         return -ENOMEM;
> +               if (dentry =3D=3D ERR_PTR(-EAGAIN))
> +                       return -EAGAIN;
>                 return -ESTALE;
>         }
>         path->dentry =3D dentry;
> diff --git a/include/linux/exportfs.h b/include/linux/exportfs.h
> index 30a9791d88e0..8238b6f67956 100644
> --- a/include/linux/exportfs.h
> +++ b/include/linux/exportfs.h
> @@ -199,6 +199,8 @@ struct handle_to_path_ctx {
>  #define FILEID_FS_FLAGS_MASK   0xff00
>  #define FILEID_FS_FLAGS(flags) ((flags) & FILEID_FS_FLAGS_MASK)
>
> +#define FILEID_CACHED          0x100 /* Use only cached data when decodi=
ng handle */
> +
>  /* User flags: */
>  #define FILEID_USER_FLAGS_MASK 0xffff0000
>  #define FILEID_USER_FLAGS(type) ((type) & FILEID_USER_FLAGS_MASK)
> @@ -303,6 +305,9 @@ struct export_operations {
>                                                 */
>  #define EXPORT_OP_FLUSH_ON_CLOSE       (0x20) /* fs flushes file data on=
 close */
>  #define EXPORT_OP_NOLOCKS              (0x40) /* no file locking support=
 */
> +#define EXPORT_OP_NONBLOCK             (0x80) /* Filesystem supports non=
-
> +                                                 blocking fh_to_dentry()
> +                                               */
>         unsigned long   flags;
>  };
>
> --
> 2.51.0
>
