Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com [209.85.208.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E9331EEA40
	for <linux-xfs@vger.kernel.org>; Wed, 17 Sep 2025 03:09:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758078569; cv=none; b=q4sZ7PzfQKJNSWJlkWL2l+9PcRZEw8JcJA8JMMj2pP37OCxpaLF83pLkm5GU5xOGze8BwBVXuqs1chWBR5Zjfv9g2sU5rXf34eYWukJYxe6cGgIbhF/mTMmL9N8qKg9AjXKhJYJSbQV0iB48PnfEkPj832QOhLZ/0O4yhhfJ2dE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758078569; c=relaxed/simple;
	bh=Kqd/Saes4OE55SY123mfIUrQ1HiOtPBDCpmm03ARoT0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=NAK8WpqaKC8PMaHnl1VTRVFf2iokKTpqNJStxUgMFBQ7xufNObcyabf8tw2mMkQeTLlYXkhtAGloKbdpPQKMJp731BkGqQE9YupeSQ2VGxEl600lu2eMdqFpftjbdEqm5ldgrVkCvx9W5CY5nPiZHEgpWXqgUZ0B6fAdwLvWkKo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=irGNlYDl; arc=none smtp.client-ip=209.85.208.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="irGNlYDl"
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-62f37aebd6bso3460587a12.3
        for <linux-xfs@vger.kernel.org>; Tue, 16 Sep 2025 20:09:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758078566; x=1758683366; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DQISpO/KOSQlc60qkfaLofZlpHkKqo3WtxB9jZ3MGMw=;
        b=irGNlYDlDuNopxeeDcdzVq+9oTk6ZDPQ5QHTJwfSbx06yBuP20MVgtEQ962M/M0HqO
         P2h7KE0x+a4mxSYiOguXtieHBQonoBUiuII+YlFqq4i1ErOkpeGvv13Rzt+Asrpwjojk
         XqtXR4cL0NnebpvwIAt72oCgdwDNnrnwl8LFE9LuROzLxb9TFQn09Q9Jr5F+x3yxr9sZ
         s5bGkfQ1CPeuhK38Aap/fa2TVubjEkMHO58ehAgbDjbIEVJ6tp9t145Vj/gSfw3lXpQc
         54FBS+SGlh+08sDRICSxQf27+7KKA1LR+qRoYDogpsMqh2oplvloaZFu7IlbC5kYj8sC
         546g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758078566; x=1758683366;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DQISpO/KOSQlc60qkfaLofZlpHkKqo3WtxB9jZ3MGMw=;
        b=ZrtccNHnjx+GnvIuUfuH27XAHPepa+7HGTJyLmOdA5N3UGjTcZUpmsQo9Kd/Qs0fXn
         p/dOLZhMU4gr0rvdYeQzpd0/Cq5RIgyyiJoaTR/Q8fUhIQ57AyDrzOV+YWHJyrbDlM6m
         rISHnr4tVqQpckZOPORx6vxOrK451xXF1bF6LjEX3cUz4HBMB/mRsZafkPp6LOloEkM5
         2jM3zny/pZL5mvHqd/K1f/qCWk1YJ39Eqipv1CDyjr+u3pUyl7No+ipCpWTpiuVLBRZk
         +WBFH8UKxwG2YMpBjO5Y/4r1ANC/BUT8Z9DqDOIPiy/i0IsZ1DXoN5AUyWHEqbeT7R1p
         WwfQ==
X-Forwarded-Encrypted: i=1; AJvYcCUVizN26/n+wIemm7VcrtMUZKYdx5vCUzb+i5bbnI77F+CxFqHSr6XR5gDcl/kaD1uuJkkGji7GFnk=@vger.kernel.org
X-Gm-Message-State: AOJu0YyFLFDX+2U/9ynNgoIruGxTANiAKPuX5tQmqX9V1+OsJHV0rKkx
	IHiAjV0y6tBnqnpxglO4odJPbFg+nGoxJYNFzTbqy8HwmydYBBlHvjXCK87AhzTGmDzWRDffbbC
	VrJNRLUwYNn58rT/ki67KFw9fy7rs0gc=
X-Gm-Gg: ASbGncsD0GMLeT6wL7FOhrncMWgc1HAIwGvbGopkVu3DKerNl/I0LXrf6j17O+N3zwC
	VT/ULnNBBijbUMSq/FCFIQxW0GETOrypRZWHWqJQZfhmTADU4Xk9+wBfUculY5Y5Tbuh6eHd/tP
	3It7XIiJz9AWExfRWta85pybmunU/OqHMVFCCIHoc/XXH3Vr7G00n6qEF2uVM2H7gtzGVJBdIHP
	SyEhGPKSmb31T8kqj/ilW+nctrv8pDgoxtLRysAKUAS0NX/ycbs
X-Google-Smtp-Source: AGHT+IGpQiAHDeu3gp7Iyvw58eu1QQfsnEVxzHrMVXmEJCWT+SwX+13n0y3vErJB5AR7sMh1pXOTx7CvEi1NXwbveEI=
X-Received: by 2002:a05:6402:1d4b:b0:62f:4dbc:6785 with SMTP id
 4fb4d7f45d1cf-62f8443531amr830093a12.19.1758078565700; Tue, 16 Sep 2025
 20:09:25 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <175798151087.382724.2707973706304359333.stgit@frogsfrogsfrogs> <175798151352.382724.799745519035147130.stgit@frogsfrogsfrogs>
In-Reply-To: <175798151352.382724.799745519035147130.stgit@frogsfrogsfrogs>
From: Amir Goldstein <amir73il@gmail.com>
Date: Wed, 17 Sep 2025 05:09:14 +0200
X-Gm-Features: AS18NWAvuzfcNKLzObLwIDzq_urQ8n-PHloRWEiou4jflORQao8K4PvaoSPXMeU
Message-ID: <CAOQ4uxibHLq7YVpjtXdrHk74rXrOLSc7sAW7s=RADc7OYN2ndA@mail.gmail.com>
Subject: Re: [PATCH 04/28] fuse: adapt FUSE_DEV_IOC_BACKING_{OPEN,CLOSE} to
 add new iomap devices
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: miklos@szeredi.hu, bernd@bsbernd.com, linux-xfs@vger.kernel.org, 
	John@groves.net, linux-fsdevel@vger.kernel.org, neal@gompa.dev, 
	joannelkoong@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Sep 16, 2025 at 2:30=E2=80=AFAM Darrick J. Wong <djwong@kernel.org>=
 wrote:
>
> From: Darrick J. Wong <djwong@kernel.org>
>
> Enable the use of the backing file open/close ioctls so that fuse
> servers can register block devices for use with iomap.
>
> Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
> ---
>  fs/fuse/fuse_i.h          |    5 ++
>  include/uapi/linux/fuse.h |    3 +
>  fs/fuse/Kconfig           |    1
>  fs/fuse/backing.c         |   12 +++++
>  fs/fuse/file_iomap.c      |   99 +++++++++++++++++++++++++++++++++++++++=
++----
>  fs/fuse/trace.c           |    1
>  6 files changed, 111 insertions(+), 10 deletions(-)
>
>
> diff --git a/fs/fuse/fuse_i.h b/fs/fuse/fuse_i.h
> index 389b123f0bf144..791f210c13a876 100644
> --- a/fs/fuse/fuse_i.h
> +++ b/fs/fuse/fuse_i.h
> @@ -97,12 +97,14 @@ struct fuse_submount_lookup {
>  };
>
>  struct fuse_conn;
> +struct fuse_backing;
>
>  /** Operations for subsystems that want to use a backing file */
>  struct fuse_backing_ops {
>         int (*may_admin)(struct fuse_conn *fc, uint32_t flags);
>         int (*may_open)(struct fuse_conn *fc, struct file *file);
>         int (*may_close)(struct fuse_conn *fc, struct file *file);
> +       int (*post_open)(struct fuse_conn *fc, struct fuse_backing *fb);
>         unsigned int type;
>  };
>
> @@ -110,6 +112,7 @@ struct fuse_backing_ops {
>  struct fuse_backing {
>         struct file *file;
>         struct cred *cred;
> +       struct block_device *bdev;
>         const struct fuse_backing_ops *ops;
>
>         /** refcount */
> @@ -1704,6 +1707,8 @@ static inline bool fuse_has_iomap(const struct inod=
e *inode)
>  {
>         return get_fuse_conn_c(inode)->iomap;
>  }
> +
> +extern const struct fuse_backing_ops fuse_iomap_backing_ops;
>  #else
>  # define fuse_iomap_enabled(...)               (false)
>  # define fuse_has_iomap(...)                   (false)
> diff --git a/include/uapi/linux/fuse.h b/include/uapi/linux/fuse.h
> index 3634cbe602cd9c..3a367f387795ff 100644
> --- a/include/uapi/linux/fuse.h
> +++ b/include/uapi/linux/fuse.h
> @@ -1124,7 +1124,8 @@ struct fuse_notify_retrieve_in {
>
>  #define FUSE_BACKING_TYPE_MASK         (0xFF)
>  #define FUSE_BACKING_TYPE_PASSTHROUGH  (0)
> -#define FUSE_BACKING_MAX_TYPE          (FUSE_BACKING_TYPE_PASSTHROUGH)
> +#define FUSE_BACKING_TYPE_IOMAP                (1)
> +#define FUSE_BACKING_MAX_TYPE          (FUSE_BACKING_TYPE_IOMAP)
>
>  #define FUSE_BACKING_FLAGS_ALL         (FUSE_BACKING_TYPE_MASK)
>
> diff --git a/fs/fuse/Kconfig b/fs/fuse/Kconfig
> index 52e1a04183e760..baa38cf0f295ff 100644
> --- a/fs/fuse/Kconfig
> +++ b/fs/fuse/Kconfig
> @@ -75,6 +75,7 @@ config FUSE_IOMAP
>         depends on FUSE_FS
>         depends on BLOCK
>         select FS_IOMAP
> +       select FUSE_BACKING
>         help
>           Enable fuse servers to operate the regular file I/O path throug=
h
>           the fs-iomap library in the kernel.  This enables higher perfor=
mance
> diff --git a/fs/fuse/backing.c b/fs/fuse/backing.c
> index 229c101ab46b0e..fc58636ac78eaa 100644
> --- a/fs/fuse/backing.c
> +++ b/fs/fuse/backing.c
> @@ -89,6 +89,10 @@ fuse_backing_ops_from_map(const struct fuse_backing_ma=
p *map)
>  #ifdef CONFIG_FUSE_PASSTHROUGH
>         case FUSE_BACKING_TYPE_PASSTHROUGH:
>                 return &fuse_passthrough_backing_ops;
> +#endif
> +#ifdef CONFIG_FUSE_IOMAP
> +       case FUSE_BACKING_TYPE_IOMAP:
> +               return &fuse_iomap_backing_ops;
>  #endif
>         default:
>                 break;
> @@ -137,8 +141,16 @@ int fuse_backing_open(struct fuse_conn *fc, struct f=
use_backing_map *map)
>         fb->file =3D file;
>         fb->cred =3D prepare_creds();
>         fb->ops =3D ops;
> +       fb->bdev =3D NULL;
>         refcount_set(&fb->count, 1);
>
> +       res =3D ops->post_open ? ops->post_open(fc, fb) : 0;
> +       if (res) {
> +               fuse_backing_free(fb);
> +               fb =3D NULL;
> +               goto out;
> +       }
> +
>         res =3D fuse_backing_id_alloc(fc, fb);
>         if (res < 0) {
>                 fuse_backing_free(fb);
> diff --git a/fs/fuse/file_iomap.c b/fs/fuse/file_iomap.c
> index e7d19e2aee4541..3a4161633add0e 100644
> --- a/fs/fuse/file_iomap.c
> +++ b/fs/fuse/file_iomap.c
> @@ -319,10 +319,6 @@ static inline bool fuse_iomap_check_mapping(const st=
ruct inode *inode,
>                 return false;
>         }
>
> -       /* XXX: we don't support devices yet */
> -       if (BAD_DATA(map->dev !=3D FUSE_IOMAP_DEV_NULL))
> -               return false;
> -
>         /* No overflows in the device range, if supplied */
>         if (map->addr !=3D FUSE_IOMAP_NULL_ADDR &&
>             BAD_DATA(check_add_overflow(map->addr, map->length, &end)))
> @@ -334,6 +330,7 @@ static inline bool fuse_iomap_check_mapping(const str=
uct inode *inode,
>  /* Convert a mapping from the server into something the kernel can use *=
/
>  static inline void fuse_iomap_from_server(struct inode *inode,
>                                           struct iomap *iomap,
> +                                         const struct fuse_backing *fb,
>                                           const struct fuse_iomap_io *fma=
p)
>  {
>         iomap->addr =3D fmap->addr;
> @@ -341,7 +338,9 @@ static inline void fuse_iomap_from_server(struct inod=
e *inode,
>         iomap->length =3D fmap->length;
>         iomap->type =3D fuse_iomap_type_from_server(fmap->type);
>         iomap->flags =3D fuse_iomap_flags_from_server(fmap->flags);
> -       iomap->bdev =3D inode->i_sb->s_bdev; /* XXX */
> +
> +       iomap->bdev =3D fb ? fb->bdev : NULL;
> +       iomap->dax_dev =3D NULL;
>  }
>
>  /* Convert a mapping from the kernel into something the server can use *=
/
> @@ -392,6 +391,27 @@ static inline bool fuse_is_iomap_file_write(unsigned=
 int opflags)
>         return opflags & (IOMAP_WRITE | IOMAP_ZERO | IOMAP_UNSHARE);
>  }
>
> +static inline struct fuse_backing *
> +fuse_iomap_find_dev(struct fuse_conn *fc, const struct fuse_iomap_io *ma=
p)
> +{
> +       struct fuse_backing *ret =3D NULL;
> +
> +       if (map->dev !=3D FUSE_IOMAP_DEV_NULL && map->dev < INT_MAX)
> +               ret =3D fuse_backing_lookup(fc, &fuse_iomap_backing_ops,
> +                                         map->dev);
> +
> +       switch (map->type) {
> +       case FUSE_IOMAP_TYPE_MAPPED:
> +       case FUSE_IOMAP_TYPE_UNWRITTEN:
> +               /* Mappings backed by space must have a device/addr */
> +               if (BAD_DATA(ret =3D=3D NULL))
> +                       return ERR_PTR(-EFSCORRUPTED);
> +               break;
> +       }
> +
> +       return ret;
> +}
> +
>  static int fuse_iomap_begin(struct inode *inode, loff_t pos, loff_t coun=
t,
>                             unsigned opflags, struct iomap *iomap,
>                             struct iomap *srcmap)
> @@ -405,6 +425,8 @@ static int fuse_iomap_begin(struct inode *inode, loff=
_t pos, loff_t count,
>         };
>         struct fuse_iomap_begin_out outarg =3D { };
>         struct fuse_mount *fm =3D get_fuse_mount(inode);
> +       struct fuse_backing *read_dev =3D NULL;
> +       struct fuse_backing *write_dev =3D NULL;
>         FUSE_ARGS(args);
>         int err;
>
> @@ -431,24 +453,44 @@ static int fuse_iomap_begin(struct inode *inode, lo=
ff_t pos, loff_t count,
>         if (err)
>                 return err;
>
> +       read_dev =3D fuse_iomap_find_dev(fm->fc, &outarg.read);
> +       if (IS_ERR(read_dev))
> +               return PTR_ERR(read_dev);
> +
>         if (fuse_is_iomap_file_write(opflags) &&
>             outarg.write.type !=3D FUSE_IOMAP_TYPE_PURE_OVERWRITE) {
> +               /* open the write device */
> +               write_dev =3D fuse_iomap_find_dev(fm->fc, &outarg.write);
> +               if (IS_ERR(write_dev)) {
> +                       err =3D PTR_ERR(write_dev);
> +                       goto out_read_dev;
> +               }
> +
>                 /*
>                  * For an out of place write, we must supply the write ma=
pping
>                  * via @iomap, and the read mapping via @srcmap.
>                  */
> -               fuse_iomap_from_server(inode, iomap, &outarg.write);
> -               fuse_iomap_from_server(inode, srcmap, &outarg.read);
> +               fuse_iomap_from_server(inode, iomap, write_dev, &outarg.w=
rite);
> +               fuse_iomap_from_server(inode, srcmap, read_dev, &outarg.r=
ead);
>         } else {
>                 /*
>                  * For everything else (reads, reporting, and pure overwr=
ites),
>                  * we can return the sole mapping through @iomap and leav=
e
>                  * @srcmap unchanged from its default (HOLE).
>                  */
> -               fuse_iomap_from_server(inode, iomap, &outarg.read);
> +               fuse_iomap_from_server(inode, iomap, read_dev, &outarg.re=
ad);
>         }
>
> -       return 0;
> +       /*
> +        * XXX: if we ever want to support closing devices, we need a way=
 to
> +        * track the fuse_backing refcount all the way through bio endios=
.
> +        * For now we put the refcount here because you can't remove an i=
omap
> +        * device until unmount time.
> +        */
> +       fuse_backing_put(write_dev);
> +out_read_dev:
> +       fuse_backing_put(read_dev);
> +       return err;
>  }
>
>  /* Decide if we send FUSE_IOMAP_END to the fuse server */
> @@ -523,3 +565,42 @@ const struct iomap_ops fuse_iomap_ops =3D {
>         .iomap_begin            =3D fuse_iomap_begin,
>         .iomap_end              =3D fuse_iomap_end,
>  };
> +
> +static int fuse_iomap_may_admin(struct fuse_conn *fc, unsigned int flags=
)
> +{
> +       if (!fc->iomap)
> +               return -EPERM;
> +

IIRC, on RFC I asked why is iomap exempt from CAP_SYS_ADMIN
check. If there was a good reason, I forgot it.

The problem is that while fuse-iomap fs is only expected to open
a handful of backing devs, we would like to prevent abuse of this ioctl
by a buggy or malicious user.

I think that if you want to avoid CAP_SYS_ADMIN here you should
enforce a limit on the number of backing bdevs.

If you accept my suggestion to mutually exclude passthrough and
iomap features per fs, then you'd just need to keep track on numbers
of fuse_backing ids and place a limit for iomap fs.

BTW, I think it is enough keep track of the number of backing ids
and no need to keep track of the number of fuse_backing objects
(which can outlive a backing id), because an "anonymous" fuse_backing
object is always associated with an open fuse file - that's the same as
an overlayfs backing file, which is not accounted for in ulimit.

Thanks,
Amir.
