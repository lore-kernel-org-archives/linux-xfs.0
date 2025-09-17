Received: from mail-qt1-f179.google.com (mail-qt1-f179.google.com [209.85.160.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03F4528312D
	for <linux-xfs@vger.kernel.org>; Wed, 17 Sep 2025 17:18:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758129534; cv=none; b=PC2Gq+H5d/DcA1o0LYXZ70+CnGNhOqtwiFL4uMYWwI3x2AcDkOcjPv5b5xrd255AnA00mL32bMAuSpjj7Kmh83CoUmiyo0MdMV9BiI89V3rj1yAAFErd4P0LMIOykjlhG5U7tzhFCCax2pmum6+6+WSCG9YilfSOjzg/+iultWI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758129534; c=relaxed/simple;
	bh=vp4xXfEstXfG1EmVhXAhHkfIJCfjz0gaa7uWSYhK+O0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=J0pLFhgtl+mngTfKTPBhOTP6jFIDQlHI8oOrvG0OZTrQz+M0/U7wmW9yAKzqcTqCxp/s3vYeM2ia2uUSxsB1xvFW4vJJK1Jyw8D1y2dmZaZouljZjnCZjve/IU1/7yFI+n8oTZmckMT1IvXNxzKBEK47ocP8H2IATs6WYwO3RQ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=IVjx+uEK; arc=none smtp.client-ip=209.85.160.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IVjx+uEK"
Received: by mail-qt1-f179.google.com with SMTP id d75a77b69052e-4b3d3f6360cso737231cf.0
        for <linux-xfs@vger.kernel.org>; Wed, 17 Sep 2025 10:18:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758129532; x=1758734332; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=D8pW7pxi6JTe55Epd+um3+DbceuB+Xvn3fqBDDJif2g=;
        b=IVjx+uEK/gqmilCKdtTghrftfgk4OK6ghUX+AibF9mE0GrjKyFajd9I1Ype5tNXEnh
         fa2dYJj0b+wGPUVxi6R9nvKgeHeU8qUVHDNrxLVV8lvCrX80FAukS1032Xxj1ky6g/3g
         C80aklEy+6Umg2FWB0tefMdOOO78zqw5CWj0MqhNAXg80Jp/EH9obmMDfuA7MnAdGwzt
         NWdQ5IK1ooyJiry/HjFAm+YvdPXPlL3ztq+hxAiQr7sK7O589DA6d0lrXic3PTbmMUzy
         7kkKIlaXJIxGtWUrXlLsxJ9iEHvbcHiAajRKiFhw/F2d/tAvCoe46ZLswLlnlOGrZtHB
         d71w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758129532; x=1758734332;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=D8pW7pxi6JTe55Epd+um3+DbceuB+Xvn3fqBDDJif2g=;
        b=ceVGtibsBp6Syku2TGicHBZGV+3WCq8/CmQYaqvHzcHm35YVMSHL0YO3wP1Q2gEBM6
         Yj60wR4LCdCJ/hP1zAe73mad9qsXL4XUMvVnDAsZ/AFKTFbM6WVmCoqpB+/5EseiCDHn
         wa0Vx7vE/AafoOzuSVLeieO9m+vxHghQfDVNj3d6pre+2so1FeoeRyLKatFtNnMExxmw
         Erz63qkpdhz/tTcQxhWNu2eILoHe7hh3ocJeJws79aTOWSzyjXtxPnifCXpdEUPkptUY
         ++tWoklnxwm9L3lfuGcR4makZlLHEyLpT20cvydf9P/h5rwrc8M6JFqnHMZbQEK2wTlE
         taTA==
X-Forwarded-Encrypted: i=1; AJvYcCXbnmRdPFSiEmBEYAwaBN3ECMt4Q1O7tjuYx1fZ1ga90Ktce7EkPIqsOPpi17EXdK1ohBXxJaB3A74=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz6dcujolT6NtK60xBNoICk8vdSDioL6G0IVN0N7l7w3dAEy+4Q
	1ioQksMuvT7LvARwOvav46YvdSYZAtIxEs7nNop/Nfn2ljXJQwJxNDSES9HEc3fQlkg6No87nDM
	1LQy8+ozYCPMNHSN+kbwSFjesTwQuJhDCahrApEw=
X-Gm-Gg: ASbGncu8loKDV5GGE0orlRgjK4oath8F/H1nLWyFSwJfkjDS/9cMmLzN1YZSiiAVk2n
	fU3N4pZe5EwRq52QiY86hOzhMavhzcq7Q5vjfNYXgQHWO+CRVu+WLFs+L0aWo50qLDjqBwHl4aJ
	JGOamYvy7l5JZIcsBz2cIQP5Mm4cIxudxGY5hv5qhHTns7ZFAHgu6kdW2v4rvT2Em+81oapLMIp
	3ebIY7glIhIwLKoD8k796Tw17VOcpsT86XcynqS
X-Google-Smtp-Source: AGHT+IHiMTSmkmvH/pD4nOT6bsOIUhs4gEp68ZMAu2302zulspJRouc36WusR+YC7ttsBUGHtvGI0zOG4nIXrlbyvJI=
X-Received: by 2002:a05:622a:346:b0:4b7:9b6c:57a6 with SMTP id
 d75a77b69052e-4ba676ba708mr36173691cf.36.1758129531421; Wed, 17 Sep 2025
 10:18:51 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <175798149979.381990.14913079500562122255.stgit@frogsfrogsfrogs> <175798150113.381990.4002893785000461185.stgit@frogsfrogsfrogs>
In-Reply-To: <175798150113.381990.4002893785000461185.stgit@frogsfrogsfrogs>
From: Joanne Koong <joannelkoong@gmail.com>
Date: Wed, 17 Sep 2025 10:18:40 -0700
X-Gm-Features: AS18NWCrbo_HW6aoJVfhCMuUdYyAl8VotiYmI_03uQUmXbXXWG4XO46mip0fHBY
Message-ID: <CAJnrk1YWtEJ2O90Z0+YH346c3FigVJz4e=H6qwRYv7xLdVg1PA@mail.gmail.com>
Subject: Re: [PATCH 4/8] fuse: signal that a fuse filesystem should exhibit
 local fs behaviors
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: miklos@szeredi.hu, bernd@bsbernd.com, linux-xfs@vger.kernel.org, 
	John@groves.net, linux-fsdevel@vger.kernel.org, neal@gompa.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 15, 2025 at 5:25=E2=80=AFPM Darrick J. Wong <djwong@kernel.org>=
 wrote:
>
> From: Darrick J. Wong <djwong@kernel.org>
>
> Create a new fuse context flag that indicates that the kernel should
> implement various local filesystem behaviors instead of passing vfs
> commands straight through to the fuse server and expecting the server to
> do all the work.  For example, this means that we'll use the kernel to
> transform some ACL updates into mode changes, and later to do
> enforcement of the immutable and append iflags.
>
> Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
> ---
>  fs/fuse/fuse_i.h |    4 ++++
>  fs/fuse/inode.c  |    2 ++
>  2 files changed, 6 insertions(+)
>
> diff --git a/fs/fuse/fuse_i.h b/fs/fuse/fuse_i.h
> index e93a3c3f11d901..e13e8270f4f58d 100644
> --- a/fs/fuse/fuse_i.h
> +++ b/fs/fuse/fuse_i.h
> @@ -603,6 +603,7 @@ struct fuse_fs_context {
>         bool no_control:1;
>         bool no_force_umount:1;
>         bool legacy_opts_show:1;
> +       bool local_fs:1;
>         enum fuse_dax_mode dax_mode;
>         unsigned int max_read;
>         unsigned int blksize;
> @@ -901,6 +902,9 @@ struct fuse_conn {
>         /* Is link not implemented by fs? */
>         unsigned int no_link:1;
>
> +       /* Should this filesystem behave like a local filesystem? */
> +       unsigned int local_fs:1;
> +
>         /* Use io_uring for communication */
>         unsigned int io_uring;
>
> diff --git a/fs/fuse/inode.c b/fs/fuse/inode.c
> index c94aba627a6f11..c8dd0bcb7e6f9f 100644
> --- a/fs/fuse/inode.c
> +++ b/fs/fuse/inode.c
> @@ -1862,6 +1862,7 @@ int fuse_fill_super_common(struct super_block *sb, =
struct fuse_fs_context *ctx)
>         fc->destroy =3D ctx->destroy;
>         fc->no_control =3D ctx->no_control;
>         fc->no_force_umount =3D ctx->no_force_umount;
> +       fc->local_fs =3D ctx->local_fs;
>

If I'm understanding it correctly, fc->local_fs is set to true if it's
a fuseblk device? Why do we need a new "ctx->local_fs" instead of
reusing ctx->is_bdev?

Thanks,
Joanne

>         err =3D -ENOMEM;
>         root =3D fuse_get_root_inode(sb, ctx->rootmode);
> @@ -2029,6 +2030,7 @@ static int fuse_init_fs_context(struct fs_context *=
fsc)
>         if (fsc->fs_type =3D=3D &fuseblk_fs_type) {
>                 ctx->is_bdev =3D true;
>                 ctx->destroy =3D true;
> +               ctx->local_fs =3D true;
>         }
>  #endif
>
>
