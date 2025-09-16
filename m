Received: from mail-yb1-f176.google.com (mail-yb1-f176.google.com [209.85.219.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62A652DF149
	for <linux-xfs@vger.kernel.org>; Tue, 16 Sep 2025 06:41:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758004907; cv=none; b=ILKcVWFqaTQLq03t9079r7trQt2o5rGMA7fkFgDjqWiCoXZhiAA7gE0MtR6UmB/6DmQRC2XScplSsb3n0RJAnBJrfzGN6uP3756QSHLsk7LmOh9J2pyymIyZV0k32yBGK40il9/M/qv/5YHmnFU737XbKSjAAg2+Z2YUPwb8KeA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758004907; c=relaxed/simple;
	bh=aOqdtF6vKv2N4buSArHUuoQOds/my4Xf2GebP68+mPA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=O/sFlUf0xznJeF6w1nbPOKyloq88FBzxUfNui0wajxLZ5nUz8pWTap7W1chrlXvdPDjESzuiauoUZZrlUB3DZzyWD5fJUPtzCPeGDb36KOWVktY/H1I/et9Zo7A+Oud6QybniV2l0py3yDqh9MgD9ksGAY9Q9OACmpbL95LsxTE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=black-desk.cn; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.219.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=black-desk.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-yb1-f176.google.com with SMTP id 3f1490d57ef6-ea3dbcc5410so2450112276.2
        for <linux-xfs@vger.kernel.org>; Mon, 15 Sep 2025 23:41:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758004903; x=1758609703;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DUtKMNKxtvgWRZoirTPKx9vVVwcjpbmiSQpSjnBdNlQ=;
        b=e6hHZKEamHZUS2LMYkWl3IUasKo3FVIx27K3W3AICvDeK0h0HG8KCxuoWlFDlB/J22
         UnlUUO5DPZ1oQbwhFALMDNdOi8jZer0MTkrxuVU8gKqxjQRGdQKbOVIojfMNgpP54kZm
         C4W5lQzI1kAM6Phy6L8zeD1gFwh2RkdP3D3MykZwDBWIownq6cAK9NdZirNKZ5Z/9aWL
         l+eOTbCT75TBFXciCEZ5Do8NW4HRH3KuJ0cQadA0x/RNAikbjrUIi7CprEfTXnY9icMS
         C2KQjXdISlYOmkr5riisG74zsVwjCI0xKWV3Cd0UXe9TrqmJZFGX6x46KeiT01sDw5us
         vQDw==
X-Forwarded-Encrypted: i=1; AJvYcCUofNIjH1+8F/yzNFH0NQt0iqeeRCrd/9gHyzImhnmh0YF/N8gEZNSV5P5M89oa4jmde50r13Opevo=@vger.kernel.org
X-Gm-Message-State: AOJu0YzU2NfWo/M/LEM1e04ugO9g/sfcLjQmBtPBTmDObLIli+b0S5XU
	UJHlRudRWdOgSXsRxnDL0vXmgfq62u4QMLmWxd76h2UceCYBOYzhR4tz53VxUgkeAa0=
X-Gm-Gg: ASbGncujN0lDAWu1EA+H52S6h4+kgeEr/bMc8O0PmDDAR498CNbTaBeNAcz7VDahiQk
	gbvDCOlTyAZ5iGt3aJJcT9NjBNhtb2Q98lMjr3RRpLAtXdr2CeGx4qmbMUF8Fzij38EUzkoQIlY
	IBXuS2S+hGNp2/PX2vkqdTfarOWPk+jHwABMxJz3MCfSbC5x0V4CTqF72AR4FzYuOLKJ9XeeuYP
	JbWpHTaYdHC89x5fVH7ymQXWEqC4IWYfn10rBHF+PwPVtSGzjziYL1RFUBGMJ8JTm22JOKm0dHj
	f2N25Ro5LjMjkQPQFUDRpvNnvVXV2SmEf0zhOcu6TYj3DS+hvXO5N4VI4qXnD1XISR+iuORQ8C+
	uYPkFkL9rbqYLSJuuLfG/9EayQSgBWhLPMBwK7FbWYP44xa3hDhM2JNSLnNrMBgcmZ9hjD9ymf5
	FdmYjTCVoXv8mV+OE=
X-Google-Smtp-Source: AGHT+IHIbwLD0kdG9Vtda3m+QcKZKQm9enUN+fO4XWrovv/REcpt0oapxBfPQeTa1oOG/q5pkhrGcQ==
X-Received: by 2002:a05:6902:2b85:b0:ea4:14a2:839a with SMTP id 3f1490d57ef6-ea414a29509mr4133794276.9.1758004902842;
        Mon, 15 Sep 2025 23:41:42 -0700 (PDT)
Received: from mail-yw1-f171.google.com (mail-yw1-f171.google.com. [209.85.128.171])
        by smtp.gmail.com with ESMTPSA id 3f1490d57ef6-ea5460639c9sm616794276.11.2025.09.15.23.41.42
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 15 Sep 2025 23:41:42 -0700 (PDT)
Received: by mail-yw1-f171.google.com with SMTP id 00721157ae682-71d605c6501so34611427b3.3
        for <linux-xfs@vger.kernel.org>; Mon, 15 Sep 2025 23:41:42 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCVFKs+PhH3kZAOiJpntiUk7PAA8RKM/AnjXmuL59owQY4CJbaU4nUunOtMhRAg7GsOQ7+OPQhXGoWU=@vger.kernel.org
X-Received: by 2002:a05:690c:23c1:b0:720:bb3:ec14 with SMTP id
 00721157ae682-73064b08dfcmr139630637b3.25.1758004901891; Mon, 15 Sep 2025
 23:41:41 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <175798149979.381990.14913079500562122255.stgit@frogsfrogsfrogs> <175798150177.381990.5457916685867195048.stgit@frogsfrogsfrogs>
In-Reply-To: <175798150177.381990.5457916685867195048.stgit@frogsfrogsfrogs>
From: Chen Linxuan <me@black-desk.cn>
Date: Tue, 16 Sep 2025 14:41:30 +0800
X-Gmail-Original-Message-ID: <CAC1kPDOv4sy3NPexFtdoROFi18b98W+PbP+9t8y4Jd5fQqCxCg@mail.gmail.com>
X-Gm-Features: Ac12FXzMunJk0T_4Jany0brcbouJMZaEvkm2CjAIMoFEj2ft7BYULOQkF-5rzVw
Message-ID: <CAC1kPDOv4sy3NPexFtdoROFi18b98W+PbP+9t8y4Jd5fQqCxCg@mail.gmail.com>
Subject: Re: [PATCH 7/8] fuse: propagate default and file acls on creation
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: miklos@szeredi.hu, bernd@bsbernd.com, linux-xfs@vger.kernel.org, 
	John@groves.net, linux-fsdevel@vger.kernel.org, neal@gompa.dev, 
	joannelkoong@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Sep 16, 2025 at 8:26=E2=80=AFAM Darrick J. Wong <djwong@kernel.org>=
 wrote:
>
> From: Darrick J. Wong <djwong@kernel.org>
>
> For local filesystems, propagate the default and file access ACLs to new
> children when creating them, just like the other in-kernel local
> filesystems.
>
> Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
> ---
>  fs/fuse/fuse_i.h |    4 ++
>  fs/fuse/acl.c    |   65 ++++++++++++++++++++++++++++++++++++++
>  fs/fuse/dir.c    |   92 +++++++++++++++++++++++++++++++++++++++++-------=
------
>  3 files changed, 138 insertions(+), 23 deletions(-)
>
>
> diff --git a/fs/fuse/fuse_i.h b/fs/fuse/fuse_i.h
> index 52776b77efc0e4..b9306678dcda0d 100644
> --- a/fs/fuse/fuse_i.h
> +++ b/fs/fuse/fuse_i.h
> @@ -1507,6 +1507,10 @@ struct posix_acl *fuse_get_acl(struct mnt_idmap *i=
dmap,
>                                struct dentry *dentry, int type);
>  int fuse_set_acl(struct mnt_idmap *, struct dentry *dentry,
>                  struct posix_acl *acl, int type);
> +int fuse_acl_create(struct inode *dir, umode_t *mode,
> +                   struct posix_acl **default_acl, struct posix_acl **ac=
l);
> +int fuse_init_acls(struct inode *inode, const struct posix_acl *default_=
acl,
> +                  const struct posix_acl *acl);
>
>  /* readdir.c */
>  int fuse_readdir(struct file *file, struct dir_context *ctx);
> diff --git a/fs/fuse/acl.c b/fs/fuse/acl.c
> index 4997827ee83c6d..4faee72f1365a5 100644
> --- a/fs/fuse/acl.c
> +++ b/fs/fuse/acl.c
> @@ -203,3 +203,68 @@ int fuse_set_acl(struct mnt_idmap *idmap, struct den=
try *dentry,
>
>         return ret;
>  }
> +
> +int fuse_acl_create(struct inode *dir, umode_t *mode,
> +                   struct posix_acl **default_acl, struct posix_acl **ac=
l)
> +{
> +       struct fuse_conn *fc =3D get_fuse_conn(dir);
> +
> +       if (fuse_is_bad(dir))
> +               return -EIO;
> +
> +       if (IS_POSIXACL(dir) && fuse_has_local_acls(fc))
> +               return posix_acl_create(dir, mode, default_acl, acl);
> +
> +       if (!fc->dont_mask)
> +               *mode &=3D ~current_umask();
> +
> +       *default_acl =3D NULL;
> +       *acl =3D NULL;
> +       return 0;
> +}
> +
> +static int __fuse_set_acl(struct inode *inode, const char *name,
> +                         const struct posix_acl *acl)
> +{
> +       struct fuse_conn *fc =3D get_fuse_conn(inode);
> +       size_t size =3D posix_acl_xattr_size(acl->a_count);
> +       void *value;
> +       int ret;
> +
> +       if (size > PAGE_SIZE)
> +               return -E2BIG;
> +
> +       value =3D kmalloc(size, GFP_KERNEL);
> +       if (!value)
> +               return -ENOMEM;
> +
> +       ret =3D posix_acl_to_xattr(fc->user_ns, acl, value, size);
> +       if (ret < 0)
> +               goto out_value;
> +
> +       ret =3D fuse_setxattr(inode, name, value, size, 0, 0);
> +out_value:
> +       kfree(value);
> +       return ret;
> +}
> +
> +int fuse_init_acls(struct inode *inode, const struct posix_acl *default_=
acl,
> +                  const struct posix_acl *acl)
> +{
> +       int ret;
> +
> +       if (default_acl) {
> +               ret =3D __fuse_set_acl(inode, XATTR_NAME_POSIX_ACL_DEFAUL=
T,
> +                                    default_acl);
> +               if (ret)
> +                       return ret;
> +       }
> +
> +       if (acl) {
> +               ret =3D __fuse_set_acl(inode, XATTR_NAME_POSIX_ACL_ACCESS=
, acl);
> +               if (ret)
> +                       return ret;
> +       }
> +
> +       return 0;
> +}
> diff --git a/fs/fuse/dir.c b/fs/fuse/dir.c
> index a7f47e43692f1c..b116e42431ee12 100644
> --- a/fs/fuse/dir.c
> +++ b/fs/fuse/dir.c
> @@ -628,26 +628,28 @@ static int fuse_create_open(struct mnt_idmap *idmap=
, struct inode *dir,
>         struct fuse_entry_out outentry;
>         struct fuse_inode *fi;
>         struct fuse_file *ff;
> +       struct posix_acl *default_acl =3D NULL, *acl =3D NULL;
>         int epoch, err;
>         bool trunc =3D flags & O_TRUNC;
>
>         /* Userspace expects S_IFREG in create mode */
>         BUG_ON((mode & S_IFMT) !=3D S_IFREG);
>
> +       err =3D fuse_acl_create(dir, &mode, &default_acl, &acl);
> +       if (err)
> +               return err;
> +
>         epoch =3D atomic_read(&fm->fc->epoch);
>         forget =3D fuse_alloc_forget();
>         err =3D -ENOMEM;
>         if (!forget)
> -               goto out_err;
> +               goto out_acl_release;
>
>         err =3D -ENOMEM;
>         ff =3D fuse_file_alloc(fm, true);
>         if (!ff)
>                 goto out_put_forget_req;
>
> -       if (!fm->fc->dont_mask)
> -               mode &=3D ~current_umask();
> -
>         flags &=3D ~O_NOCTTY;
>         memset(&inarg, 0, sizeof(inarg));
>         memset(&outentry, 0, sizeof(outentry));
> @@ -699,12 +701,16 @@ static int fuse_create_open(struct mnt_idmap *idmap=
, struct inode *dir,
>                 fuse_sync_release(NULL, ff, flags);
>                 fuse_queue_forget(fm->fc, forget, outentry.nodeid, 1);
>                 err =3D -ENOMEM;
> -               goto out_err;
> +               goto out_acl_release;
>         }
>         kfree(forget);
>         d_instantiate(entry, inode);
>         entry->d_time =3D epoch;
>         fuse_change_entry_timeout(entry, &outentry);
> +
> +       err =3D fuse_init_acls(inode, default_acl, acl);
> +       if (err)
> +               goto out_acl_release;
>         fuse_dir_changed(dir);
>         err =3D generic_file_open(inode, file);
>         if (!err) {
> @@ -726,7 +732,9 @@ static int fuse_create_open(struct mnt_idmap *idmap, =
struct inode *dir,
>         fuse_file_free(ff);
>  out_put_forget_req:
>         kfree(forget);
> -out_err:
> +out_acl_release:
> +       posix_acl_release(default_acl);
> +       posix_acl_release(acl);
>         return err;
>  }
>
> @@ -785,7 +793,9 @@ static int fuse_atomic_open(struct inode *dir, struct=
 dentry *entry,
>   */
>  static struct dentry *create_new_entry(struct mnt_idmap *idmap, struct f=
use_mount *fm,
>                                        struct fuse_args *args, struct ino=
de *dir,
> -                                      struct dentry *entry, umode_t mode=
)
> +                                      struct dentry *entry, umode_t mode=
,
> +                                      struct posix_acl *default_acl,
> +                                      struct posix_acl *acl)
>  {
>         struct fuse_entry_out outarg;
>         struct inode *inode;
> @@ -793,14 +803,18 @@ static struct dentry *create_new_entry(struct mnt_i=
dmap *idmap, struct fuse_moun
>         struct fuse_forget_link *forget;
>         int epoch, err;
>
> -       if (fuse_is_bad(dir))
> -               return ERR_PTR(-EIO);
> +       if (fuse_is_bad(dir)) {
> +               err =3D -EIO;
> +               goto out_acl_release;
> +       }
>
>         epoch =3D atomic_read(&fm->fc->epoch);
>
>         forget =3D fuse_alloc_forget();
> -       if (!forget)
> -               return ERR_PTR(-ENOMEM);
> +       if (!forget) {
> +               err =3D -ENOMEM;
> +               goto out_acl_release;
> +       }
>
>         memset(&outarg, 0, sizeof(outarg));
>         args->nodeid =3D get_node_id(dir);
> @@ -830,7 +844,8 @@ static struct dentry *create_new_entry(struct mnt_idm=
ap *idmap, struct fuse_moun
>                           &outarg.attr, ATTR_TIMEOUT(&outarg), 0, 0);
>         if (!inode) {
>                 fuse_queue_forget(fm->fc, forget, outarg.nodeid, 1);
> -               return ERR_PTR(-ENOMEM);
> +               err =3D -ENOMEM;
> +               goto out_acl_release;
>         }
>         kfree(forget);
>
> @@ -846,19 +861,31 @@ static struct dentry *create_new_entry(struct mnt_i=
dmap *idmap, struct fuse_moun
>                 entry->d_time =3D epoch;
>                 fuse_change_entry_timeout(entry, &outarg);
>         }
> +
> +       err =3D fuse_init_acls(inode, default_acl, acl);
> +       if (err)
> +               goto out_acl_release;
>         fuse_dir_changed(dir);
> +
> +       posix_acl_release(default_acl);
> +       posix_acl_release(acl);
>         return d;
>
>   out_put_forget_req:
>         if (err =3D=3D -EEXIST)
>                 fuse_invalidate_entry(entry);
>         kfree(forget);
> + out_acl_release:
> +       posix_acl_release(default_acl);
> +       posix_acl_release(acl);
>         return ERR_PTR(err);
>  }
>
>  static int create_new_nondir(struct mnt_idmap *idmap, struct fuse_mount =
*fm,
>                              struct fuse_args *args, struct inode *dir,
> -                            struct dentry *entry, umode_t mode)
> +                            struct dentry *entry, umode_t mode,
> +                            struct posix_acl *default_acl,
> +                            struct posix_acl *acl)
>  {
>         /*
>          * Note that when creating anything other than a directory we
> @@ -869,7 +896,8 @@ static int create_new_nondir(struct mnt_idmap *idmap,=
 struct fuse_mount *fm,
>          */
>         WARN_ON_ONCE(S_ISDIR(mode));
>
> -       return PTR_ERR(create_new_entry(idmap, fm, args, dir, entry, mode=
));
> +       return PTR_ERR(create_new_entry(idmap, fm, args, dir, entry, mode=
,
> +                                       default_acl, acl));
>  }
>
>  static int fuse_mknod(struct mnt_idmap *idmap, struct inode *dir,
> @@ -877,10 +905,13 @@ static int fuse_mknod(struct mnt_idmap *idmap, stru=
ct inode *dir,
>  {
>         struct fuse_mknod_in inarg;
>         struct fuse_mount *fm =3D get_fuse_mount(dir);
> +       struct posix_acl *default_acl, *acl;
>         FUSE_ARGS(args);
> +       int err;
>
> -       if (!fm->fc->dont_mask)
> -               mode &=3D ~current_umask();
> +       err =3D fuse_acl_create(dir, &mode, &default_acl, &acl);

Please excuse me if this is a dumb question.
In this function (including fuse_mkdir and fuse_symlink),
why can't we pair fuse_acl_create and posix_acl_release together
within the same function,
just like in fuse_create_open?

Thanks,
Chen Linxuan

> +       if (err)
> +               return err;
>
>         memset(&inarg, 0, sizeof(inarg));
>         inarg.mode =3D mode;
> @@ -892,7 +923,8 @@ static int fuse_mknod(struct mnt_idmap *idmap, struct=
 inode *dir,
>         args.in_args[0].value =3D &inarg;
>         args.in_args[1].size =3D entry->d_name.len + 1;
>         args.in_args[1].value =3D entry->d_name.name;
> -       return create_new_nondir(idmap, fm, &args, dir, entry, mode);
> +       return create_new_nondir(idmap, fm, &args, dir, entry, mode,
> +                                default_acl, acl);
>  }
>
>  static int fuse_create(struct mnt_idmap *idmap, struct inode *dir,
> @@ -924,13 +956,17 @@ static struct dentry *fuse_mkdir(struct mnt_idmap *=
idmap, struct inode *dir,
>  {
>         struct fuse_mkdir_in inarg;
>         struct fuse_mount *fm =3D get_fuse_mount(dir);
> +       struct posix_acl *default_acl, *acl;
>         FUSE_ARGS(args);
> +       int err;
>
> -       if (!fm->fc->dont_mask)
> -               mode &=3D ~current_umask();
> +       mode |=3D S_IFDIR;        /* vfs doesn't set S_IFDIR for us */
> +       err =3D fuse_acl_create(dir, &mode, &default_acl, &acl);
> +       if (err)
> +               return ERR_PTR(err);
>
>         memset(&inarg, 0, sizeof(inarg));
> -       inarg.mode =3D mode;
> +       inarg.mode =3D mode & ~S_IFDIR;
>         inarg.umask =3D current_umask();
>         args.opcode =3D FUSE_MKDIR;
>         args.in_numargs =3D 2;
> @@ -938,7 +974,8 @@ static struct dentry *fuse_mkdir(struct mnt_idmap *id=
map, struct inode *dir,
>         args.in_args[0].value =3D &inarg;
>         args.in_args[1].size =3D entry->d_name.len + 1;
>         args.in_args[1].value =3D entry->d_name.name;
> -       return create_new_entry(idmap, fm, &args, dir, entry, S_IFDIR);
> +       return create_new_entry(idmap, fm, &args, dir, entry, S_IFDIR,
> +                               default_acl, acl);
>  }
>
>  static int fuse_symlink(struct mnt_idmap *idmap, struct inode *dir,
> @@ -946,7 +983,14 @@ static int fuse_symlink(struct mnt_idmap *idmap, str=
uct inode *dir,
>  {
>         struct fuse_mount *fm =3D get_fuse_mount(dir);
>         unsigned len =3D strlen(link) + 1;
> +       struct posix_acl *default_acl, *acl;
> +       umode_t mode =3D S_IFLNK | 0777;
>         FUSE_ARGS(args);
> +       int err;
> +
> +       err =3D fuse_acl_create(dir, &mode, &default_acl, &acl);
> +       if (err)
> +               return err;
>
>         args.opcode =3D FUSE_SYMLINK;
>         args.in_numargs =3D 3;
> @@ -955,7 +999,8 @@ static int fuse_symlink(struct mnt_idmap *idmap, stru=
ct inode *dir,
>         args.in_args[1].value =3D entry->d_name.name;
>         args.in_args[2].size =3D len;
>         args.in_args[2].value =3D link;
> -       return create_new_nondir(idmap, fm, &args, dir, entry, S_IFLNK);
> +       return create_new_nondir(idmap, fm, &args, dir, entry, S_IFLNK,
> +                                default_acl, acl);
>  }
>
>  void fuse_flush_time_update(struct inode *inode)
> @@ -1155,7 +1200,8 @@ static int fuse_link(struct dentry *entry, struct i=
node *newdir,
>         args.in_args[0].value =3D &inarg;
>         args.in_args[1].size =3D newent->d_name.len + 1;
>         args.in_args[1].value =3D newent->d_name.name;
> -       err =3D create_new_nondir(&invalid_mnt_idmap, fm, &args, newdir, =
newent, inode->i_mode);
> +       err =3D create_new_nondir(&invalid_mnt_idmap, fm, &args, newdir, =
newent,
> +                               inode->i_mode, NULL, NULL);
>         if (!err)
>                 fuse_update_ctime_in_cache(inode);
>         else if (err =3D=3D -EINTR)
>
>
>
