Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com [209.85.208.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A26F02D3EC5
	for <linux-xfs@vger.kernel.org>; Thu, 18 Sep 2025 18:42:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758220944; cv=none; b=STamaKqOlO4B1BwFYcEO+7/iIs+HJZAzn5jvgyOak6VEausr5zx2qzzNbkZyKe/+JDvum6cIIA5ep07f1o9Yd0KoBwrcg6kK1doOLJJUPvMscEpO0yM2+LUEy7R/xQQAuR5OYoSZmd+KLZgDwbOEE8Q5HP/gCX0ddqNtHfsbHn0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758220944; c=relaxed/simple;
	bh=lJMaDs3GFAG0VCADvPElwzQ8QuNVqcMB++IIa2IjDuw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=AZFMbW71DKn7cpdZSwRd5OWCJyCejng1vur9edpWWC3fqqvMpRWxItn+H3urzDde+xsoCPIPZmI3qrUiUKyl0nwdRJzxvYAyrMut1+1biieTMmTHXR422eEnxvYfOqKk1kGQJQ0WdMM7ZerskLTagdQRT9uNRUU0OP+211n+NtQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=f6d8WbnV; arc=none smtp.client-ip=209.85.208.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="f6d8WbnV"
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-61feb87fe26so1535391a12.1
        for <linux-xfs@vger.kernel.org>; Thu, 18 Sep 2025 11:42:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758220941; x=1758825741; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SPMLMEPYX97uZpoy0CneeO0IuQMeuU2YP6ldNThVyoQ=;
        b=f6d8WbnV0hEHDKeLlH155tMzAuqWJ8ear2d7BYsuptNuGs9zTpgi+b/C9gZRJwHSSc
         1wXFEWiSVM6fQlyTZvrm+SdVeaCJXajsMryWa/9IDfNvXiKEIAnEK7HuH1i/Dm19+4p3
         BgMq9ma37fLURVtTLx204wIOVSqJSGiAdHCz0sJbQxARgW4VXCRqnV23VtF9p2aHmc7O
         d4oojnqs8z8lwTh8SGe0tdH6GC1OOP2m+Z+6NLgtfWQoJuuzMp1CeUP2MNMKENtqst6Q
         afSTgWOnU2bGBPcUyQSAbstAt/CNJjq9n5MLFqYU6M5djaIKJa7N/oocXYFycT40crYk
         7uiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758220941; x=1758825741;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SPMLMEPYX97uZpoy0CneeO0IuQMeuU2YP6ldNThVyoQ=;
        b=ZGxN+LSzS48P8hNsbvplmk2MfY0wa9LhK4DyoeJx0AP1vDkTaY+hJAYg/8FpVzx+f6
         2TdM0EM+EL26tbToPX27TViCPuNQE2jN4XKVIHSwkW0xR2rj5DKtCKN1y9v4mJ0vDd1M
         qElf4Yk9GiLsorQ/NYj85yMFsf2K0lPBLTs9iY+sKtKTvHw5bMJYI6bUu2kFCrXtaNEV
         DWC2qvuPP6atVQKUKqVD3BRvUjQOh8l+yJyEEhncEn1FVD3c7IhGFGweMplXUCHvkuOp
         ybteIm3u4o/hkjfIdkheCQz2rEJ1oxb5w3zo2vr0nSS1EYH9sBPau7JOjUveCtzhdtVY
         a9XQ==
X-Forwarded-Encrypted: i=1; AJvYcCWL2Ia+I+4ONv4UdGwu+43JVNb8c52XueWoz8xFI0AuS9j+JA/LULC7syrgLILcIsQOqzFh8GUEkME=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw8ODZHsd1KqdxviOorzTechNzPD4PIXqmMtv2hkgmZliOsFmhn
	fl6dB545mblS3YH3Uld0LzN70Nx6pbO0zbW1PKy0K0/HRBN4r4g+cyIwjGInt9KkqKI1WeV2y6U
	ZZeuvLrmq/9oatwASuSEZ/HmgGSkcakM=
X-Gm-Gg: ASbGncuI58EeXPZWd28soV1WPhOMnGTXaV+PYMW1zcmrJu+izA+gtGPZgZzOgHZaYwY
	Vpd+mJ0364xUQbw9GnzXdIc5QErL2tvO1rkOBIyGZ9EN8+Py8fjcc7vEgKQtCI13e+facmBdefj
	Ido/zRGmZdQtm7dz15mVwzHOUveCecGYAYl9xB4OLAviOPuzNb/phGdcCV2BB95xa4RwopQ8zNm
	jK5FlMgxU4C/4MhrzmrPA2Jv3lIfMg2voUwbFcS2uiB3o7Wwp9GTaGWzRY=
X-Google-Smtp-Source: AGHT+IGwURNqY1UXTJIndR0Cdw9I0f6eTvGH55+d2t2XOwTmkB8JqnA7mh7f2j94ogOycjNXkgJY8txzVj0YHR+pJIs=
X-Received: by 2002:a05:6402:278d:b0:62f:a3ae:fedf with SMTP id
 4fb4d7f45d1cf-62fc0b2d82fmr222968a12.34.1758220940552; Thu, 18 Sep 2025
 11:42:20 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <175798151087.382724.2707973706304359333.stgit@frogsfrogsfrogs>
 <175798151352.382724.799745519035147130.stgit@frogsfrogsfrogs>
 <CAOQ4uxibHLq7YVpjtXdrHk74rXrOLSc7sAW7s=RADc7OYN2ndA@mail.gmail.com> <20250918181703.GR1587915@frogsfrogsfrogs>
In-Reply-To: <20250918181703.GR1587915@frogsfrogsfrogs>
From: Amir Goldstein <amir73il@gmail.com>
Date: Thu, 18 Sep 2025 20:42:08 +0200
X-Gm-Features: AS18NWC_TLuJSg7VC9sx1LoWMQWOgUFx4lmgCutocCRngi6X2QY4zbWavSmW9i4
Message-ID: <CAOQ4uxiH1d3fV0kgiO3-JjqGH4DKboXdtEpe=Z=gKooPgz7B8g@mail.gmail.com>
Subject: Re: [PATCH 04/28] fuse: adapt FUSE_DEV_IOC_BACKING_{OPEN,CLOSE} to
 add new iomap devices
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: miklos@szeredi.hu, bernd@bsbernd.com, linux-xfs@vger.kernel.org, 
	John@groves.net, linux-fsdevel@vger.kernel.org, neal@gompa.dev, 
	joannelkoong@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Sep 18, 2025 at 8:17=E2=80=AFPM Darrick J. Wong <djwong@kernel.org>=
 wrote:
>
> On Wed, Sep 17, 2025 at 05:09:14AM +0200, Amir Goldstein wrote:
> > On Tue, Sep 16, 2025 at 2:30=E2=80=AFAM Darrick J. Wong <djwong@kernel.=
org> wrote:
> > >
> > > From: Darrick J. Wong <djwong@kernel.org>
> > >
> > > Enable the use of the backing file open/close ioctls so that fuse
> > > servers can register block devices for use with iomap.
> > >
> > > Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
> > > ---
> > >  fs/fuse/fuse_i.h          |    5 ++
> > >  include/uapi/linux/fuse.h |    3 +
> > >  fs/fuse/Kconfig           |    1
> > >  fs/fuse/backing.c         |   12 +++++
> > >  fs/fuse/file_iomap.c      |   99 +++++++++++++++++++++++++++++++++++=
++++++----
> > >  fs/fuse/trace.c           |    1
> > >  6 files changed, 111 insertions(+), 10 deletions(-)
> > >
> > >
> > > diff --git a/fs/fuse/fuse_i.h b/fs/fuse/fuse_i.h
> > > index 389b123f0bf144..791f210c13a876 100644
> > > --- a/fs/fuse/fuse_i.h
> > > +++ b/fs/fuse/fuse_i.h
> > > @@ -97,12 +97,14 @@ struct fuse_submount_lookup {
> > >  };
> > >
> > >  struct fuse_conn;
> > > +struct fuse_backing;
> > >
> > >  /** Operations for subsystems that want to use a backing file */
> > >  struct fuse_backing_ops {
> > >         int (*may_admin)(struct fuse_conn *fc, uint32_t flags);
> > >         int (*may_open)(struct fuse_conn *fc, struct file *file);
> > >         int (*may_close)(struct fuse_conn *fc, struct file *file);
> > > +       int (*post_open)(struct fuse_conn *fc, struct fuse_backing *f=
b);
> > >         unsigned int type;
> > >  };
> > >
> > > @@ -110,6 +112,7 @@ struct fuse_backing_ops {
> > >  struct fuse_backing {
> > >         struct file *file;
> > >         struct cred *cred;
> > > +       struct block_device *bdev;
> > >         const struct fuse_backing_ops *ops;
> > >
> > >         /** refcount */
> > > @@ -1704,6 +1707,8 @@ static inline bool fuse_has_iomap(const struct =
inode *inode)
> > >  {
> > >         return get_fuse_conn_c(inode)->iomap;
> > >  }
> > > +
> > > +extern const struct fuse_backing_ops fuse_iomap_backing_ops;
> > >  #else
> > >  # define fuse_iomap_enabled(...)               (false)
> > >  # define fuse_has_iomap(...)                   (false)
> > > diff --git a/include/uapi/linux/fuse.h b/include/uapi/linux/fuse.h
> > > index 3634cbe602cd9c..3a367f387795ff 100644
> > > --- a/include/uapi/linux/fuse.h
> > > +++ b/include/uapi/linux/fuse.h
> > > @@ -1124,7 +1124,8 @@ struct fuse_notify_retrieve_in {
> > >
> > >  #define FUSE_BACKING_TYPE_MASK         (0xFF)
> > >  #define FUSE_BACKING_TYPE_PASSTHROUGH  (0)
> > > -#define FUSE_BACKING_MAX_TYPE          (FUSE_BACKING_TYPE_PASSTHROUG=
H)
> > > +#define FUSE_BACKING_TYPE_IOMAP                (1)
> > > +#define FUSE_BACKING_MAX_TYPE          (FUSE_BACKING_TYPE_IOMAP)
> > >
> > >  #define FUSE_BACKING_FLAGS_ALL         (FUSE_BACKING_TYPE_MASK)
> > >
> > > diff --git a/fs/fuse/Kconfig b/fs/fuse/Kconfig
> > > index 52e1a04183e760..baa38cf0f295ff 100644
> > > --- a/fs/fuse/Kconfig
> > > +++ b/fs/fuse/Kconfig
> > > @@ -75,6 +75,7 @@ config FUSE_IOMAP
> > >         depends on FUSE_FS
> > >         depends on BLOCK
> > >         select FS_IOMAP
> > > +       select FUSE_BACKING
> > >         help
> > >           Enable fuse servers to operate the regular file I/O path th=
rough
> > >           the fs-iomap library in the kernel.  This enables higher pe=
rformance
> > > diff --git a/fs/fuse/backing.c b/fs/fuse/backing.c
> > > index 229c101ab46b0e..fc58636ac78eaa 100644
> > > --- a/fs/fuse/backing.c
> > > +++ b/fs/fuse/backing.c
> > > @@ -89,6 +89,10 @@ fuse_backing_ops_from_map(const struct fuse_backin=
g_map *map)
> > >  #ifdef CONFIG_FUSE_PASSTHROUGH
> > >         case FUSE_BACKING_TYPE_PASSTHROUGH:
> > >                 return &fuse_passthrough_backing_ops;
> > > +#endif
> > > +#ifdef CONFIG_FUSE_IOMAP
> > > +       case FUSE_BACKING_TYPE_IOMAP:
> > > +               return &fuse_iomap_backing_ops;
> > >  #endif
> > >         default:
> > >                 break;
> > > @@ -137,8 +141,16 @@ int fuse_backing_open(struct fuse_conn *fc, stru=
ct fuse_backing_map *map)
> > >         fb->file =3D file;
> > >         fb->cred =3D prepare_creds();
> > >         fb->ops =3D ops;
> > > +       fb->bdev =3D NULL;
> > >         refcount_set(&fb->count, 1);
> > >
> > > +       res =3D ops->post_open ? ops->post_open(fc, fb) : 0;
> > > +       if (res) {
> > > +               fuse_backing_free(fb);
> > > +               fb =3D NULL;
> > > +               goto out;
> > > +       }
> > > +
> > >         res =3D fuse_backing_id_alloc(fc, fb);
> > >         if (res < 0) {
> > >                 fuse_backing_free(fb);
> > > diff --git a/fs/fuse/file_iomap.c b/fs/fuse/file_iomap.c
> > > index e7d19e2aee4541..3a4161633add0e 100644
> > > --- a/fs/fuse/file_iomap.c
> > > +++ b/fs/fuse/file_iomap.c
> > > @@ -319,10 +319,6 @@ static inline bool fuse_iomap_check_mapping(cons=
t struct inode *inode,
> > >                 return false;
> > >         }
> > >
> > > -       /* XXX: we don't support devices yet */
> > > -       if (BAD_DATA(map->dev !=3D FUSE_IOMAP_DEV_NULL))
> > > -               return false;
> > > -
> > >         /* No overflows in the device range, if supplied */
> > >         if (map->addr !=3D FUSE_IOMAP_NULL_ADDR &&
> > >             BAD_DATA(check_add_overflow(map->addr, map->length, &end)=
))
> > > @@ -334,6 +330,7 @@ static inline bool fuse_iomap_check_mapping(const=
 struct inode *inode,
> > >  /* Convert a mapping from the server into something the kernel can u=
se */
> > >  static inline void fuse_iomap_from_server(struct inode *inode,
> > >                                           struct iomap *iomap,
> > > +                                         const struct fuse_backing *=
fb,
> > >                                           const struct fuse_iomap_io =
*fmap)
> > >  {
> > >         iomap->addr =3D fmap->addr;
> > > @@ -341,7 +338,9 @@ static inline void fuse_iomap_from_server(struct =
inode *inode,
> > >         iomap->length =3D fmap->length;
> > >         iomap->type =3D fuse_iomap_type_from_server(fmap->type);
> > >         iomap->flags =3D fuse_iomap_flags_from_server(fmap->flags);
> > > -       iomap->bdev =3D inode->i_sb->s_bdev; /* XXX */
> > > +
> > > +       iomap->bdev =3D fb ? fb->bdev : NULL;
> > > +       iomap->dax_dev =3D NULL;
> > >  }
> > >
> > >  /* Convert a mapping from the kernel into something the server can u=
se */
> > > @@ -392,6 +391,27 @@ static inline bool fuse_is_iomap_file_write(unsi=
gned int opflags)
> > >         return opflags & (IOMAP_WRITE | IOMAP_ZERO | IOMAP_UNSHARE);
> > >  }
> > >
> > > +static inline struct fuse_backing *
> > > +fuse_iomap_find_dev(struct fuse_conn *fc, const struct fuse_iomap_io=
 *map)
> > > +{
> > > +       struct fuse_backing *ret =3D NULL;
> > > +
> > > +       if (map->dev !=3D FUSE_IOMAP_DEV_NULL && map->dev < INT_MAX)
> > > +               ret =3D fuse_backing_lookup(fc, &fuse_iomap_backing_o=
ps,
> > > +                                         map->dev);
> > > +
> > > +       switch (map->type) {
> > > +       case FUSE_IOMAP_TYPE_MAPPED:
> > > +       case FUSE_IOMAP_TYPE_UNWRITTEN:
> > > +               /* Mappings backed by space must have a device/addr *=
/
> > > +               if (BAD_DATA(ret =3D=3D NULL))
> > > +                       return ERR_PTR(-EFSCORRUPTED);
> > > +               break;
> > > +       }
> > > +
> > > +       return ret;
> > > +}
> > > +
> > >  static int fuse_iomap_begin(struct inode *inode, loff_t pos, loff_t =
count,
> > >                             unsigned opflags, struct iomap *iomap,
> > >                             struct iomap *srcmap)
> > > @@ -405,6 +425,8 @@ static int fuse_iomap_begin(struct inode *inode, =
loff_t pos, loff_t count,
> > >         };
> > >         struct fuse_iomap_begin_out outarg =3D { };
> > >         struct fuse_mount *fm =3D get_fuse_mount(inode);
> > > +       struct fuse_backing *read_dev =3D NULL;
> > > +       struct fuse_backing *write_dev =3D NULL;
> > >         FUSE_ARGS(args);
> > >         int err;
> > >
> > > @@ -431,24 +453,44 @@ static int fuse_iomap_begin(struct inode *inode=
, loff_t pos, loff_t count,
> > >         if (err)
> > >                 return err;
> > >
> > > +       read_dev =3D fuse_iomap_find_dev(fm->fc, &outarg.read);
> > > +       if (IS_ERR(read_dev))
> > > +               return PTR_ERR(read_dev);
> > > +
> > >         if (fuse_is_iomap_file_write(opflags) &&
> > >             outarg.write.type !=3D FUSE_IOMAP_TYPE_PURE_OVERWRITE) {
> > > +               /* open the write device */
> > > +               write_dev =3D fuse_iomap_find_dev(fm->fc, &outarg.wri=
te);
> > > +               if (IS_ERR(write_dev)) {
> > > +                       err =3D PTR_ERR(write_dev);
> > > +                       goto out_read_dev;
> > > +               }
> > > +
> > >                 /*
> > >                  * For an out of place write, we must supply the writ=
e mapping
> > >                  * via @iomap, and the read mapping via @srcmap.
> > >                  */
> > > -               fuse_iomap_from_server(inode, iomap, &outarg.write);
> > > -               fuse_iomap_from_server(inode, srcmap, &outarg.read);
> > > +               fuse_iomap_from_server(inode, iomap, write_dev, &outa=
rg.write);
> > > +               fuse_iomap_from_server(inode, srcmap, read_dev, &outa=
rg.read);
> > >         } else {
> > >                 /*
> > >                  * For everything else (reads, reporting, and pure ov=
erwrites),
> > >                  * we can return the sole mapping through @iomap and =
leave
> > >                  * @srcmap unchanged from its default (HOLE).
> > >                  */
> > > -               fuse_iomap_from_server(inode, iomap, &outarg.read);
> > > +               fuse_iomap_from_server(inode, iomap, read_dev, &outar=
g.read);
> > >         }
> > >
> > > -       return 0;
> > > +       /*
> > > +        * XXX: if we ever want to support closing devices, we need a=
 way to
> > > +        * track the fuse_backing refcount all the way through bio en=
dios.
> > > +        * For now we put the refcount here because you can't remove =
an iomap
> > > +        * device until unmount time.
> > > +        */
> > > +       fuse_backing_put(write_dev);
> > > +out_read_dev:
> > > +       fuse_backing_put(read_dev);
> > > +       return err;
> > >  }
> > >
> > >  /* Decide if we send FUSE_IOMAP_END to the fuse server */
> > > @@ -523,3 +565,42 @@ const struct iomap_ops fuse_iomap_ops =3D {
> > >         .iomap_begin            =3D fuse_iomap_begin,
> > >         .iomap_end              =3D fuse_iomap_end,
> > >  };
> > > +
> > > +static int fuse_iomap_may_admin(struct fuse_conn *fc, unsigned int f=
lags)
> > > +{
> > > +       if (!fc->iomap)
> > > +               return -EPERM;
> > > +
> >
> > IIRC, on RFC I asked why is iomap exempt from CAP_SYS_ADMIN
> > check. If there was a good reason, I forgot it.
>
> CAP_SYS_ADMIN means that the fuse server (or the fuservicemount helper)
> can make quite a lot of other changes to the system that are not at all
> related to being a filesystem.  I'd rather not use that one.
>
> Instead I require CAP_SYS_RAWIO to enable fc->iomap, so that the fuse
> server has to have *some* privilege, but only enough to write to raw
> block devices since that's what iomap does.
>
> > The problem is that while fuse-iomap fs is only expected to open
> > a handful of backing devs, we would like to prevent abuse of this ioctl
> > by a buggy or malicious user.
> >
> > I think that if you want to avoid CAP_SYS_ADMIN here you should
> > enforce a limit on the number of backing bdevs.
> >
> > If you accept my suggestion to mutually exclude passthrough and
> > iomap features per fs, then you'd just need to keep track on numbers
> > of fuse_backing ids and place a limit for iomap fs.
> >
> > BTW, I think it is enough keep track of the number of backing ids
> > and no need to keep track of the number of fuse_backing objects
> > (which can outlive a backing id), because an "anonymous" fuse_backing
> > object is always associated with an open fuse file - that's the same as
> > an overlayfs backing file, which is not accounted for in ulimit.
>
> How about restricting the backing ids to RLIMIT_NOFILE?  The @end param
> to idr_alloc_cyclic constrains them in exactly that way.

IDK. My impression was that Miklos didn't like having a large number
of unaccounted files, but it's up to him.

Do you have an estimate on the worst case number of backing blockdev
for fuse iomap?

Thanks,
Amir.
