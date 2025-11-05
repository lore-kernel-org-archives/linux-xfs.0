Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com [209.85.208.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5024530F929
	for <linux-xfs@vger.kernel.org>; Wed,  5 Nov 2025 11:15:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762341307; cv=none; b=Sp1/MGcIJi5kM+uR6gtmmDE5RyAmRWnoI+/kvwE2pgeZ/Y7AabMtvzsZNyOQBNLtfcpv7a9hgyzqzqwE2IhR/oIXx0GrsCk1miokGBCmjvnBulmTMl5fgAuph62kziONYicshOdNzaQUQ3F7LfgB+PU6AGdtVx5U/BkV1Y7SDgM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762341307; c=relaxed/simple;
	bh=S83DNfO0HG92dfkWDZsUYdj0PDxHeoyCZZyNBwXdLIA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=mSbkA49b7BuKxXq+PkulPbyjG388LhietuwlWH+EXM0avG+ImvbqgZJUXlEU9dgd7gh4te8i7uwVQYdaw5X+Ns0vO7JEbrng2SwpNs/mqE22q2Iwm3g8Kxqb53FVV1eKSsPas6LO57nAXa6T5cYxZnetlKNK2hy8h+U5mCazxd0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=d3bMZp6r; arc=none smtp.client-ip=209.85.208.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="d3bMZp6r"
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-640c1fda178so4901782a12.1
        for <linux-xfs@vger.kernel.org>; Wed, 05 Nov 2025 03:15:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762341304; x=1762946104; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KsD/Dhl4t99GvJL5Ke+OPPsrHvEVtNZwMkhdc9rUqcI=;
        b=d3bMZp6rAPHJvdPOy5B3kJ/vqWckP5KoQURZ/PKetbyfiQ3gGsxYtPZUqc0Tn2cvR2
         PjStY7Y2+q6A23lZmjerFUB7Uk1vNZS3Z0N4KSMzoSQOMv21g2lP+0Y8VGCwYgN6oAy4
         xfhUgl4bRVaLwSR5c6gEdkK8t0dreBvTbHPEqDPbGHffsOnZBgsBhoNg0J6KpSXpzRks
         vUU6R0prEomDDprLShf6UnkUq1GwI6bvgL+3K9sqFJ9aZHOyAZVY20XoStzELvoR95ol
         XwKNVcYSqlfHT6iMGIpwPLBxPn78SFsBD7IwlIYPy9ELbZqgJE1NXLA6FzmB3BYU7NRd
         xHsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762341304; x=1762946104;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KsD/Dhl4t99GvJL5Ke+OPPsrHvEVtNZwMkhdc9rUqcI=;
        b=WYS2Ha7PVkMB/Zx8Vv+q+sTX01WDC5uBru4OWXF3/40CzVUNSXvzozU9GRidDxHflP
         ezX/zQs2O4ga+AbCsPkeR+/fE6Ei8CXErwOkcMJFHF4DHn1LwnwLj6zC8aigBf2cS5M8
         GlmaPowTKlG2DliKElwcm8TIhR+yyOKAGJvs3NUjxNca0wPEH0HG0WqRlRvz1ZV7Cwyd
         ZOUukVqA0ZUro9K5kXZHVnoKEa3qyrYru7L03xu74g9gP1MVrXqHkqdpfv4rnq4LTyrS
         o33wx4VlTQfzQe1yCmmaCB3TxGpjrG8QVHgKKveHb0zi+Rnw8nH9kMpvaOJl65/nAoQ5
         56Cw==
X-Forwarded-Encrypted: i=1; AJvYcCUm9NGIFGYiWS3F9FUop7sRVbatN3cyNPUhZbUxZ70Y6WEo76nRJkA6Md4oTftfO//6Kt/54TofNak=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxdvu+jQ+3s9CH4PHDj2cf4/fnPxmd6g2WHhIYgsOOdo11Xzs34
	mXjoVOXzcP2hh4iIy6NWKQX1duZWTEW5GOWDqYM6PVcJ2B16p4C1UTxXNqIyRNw+rcVtZ2/q80E
	eCan/yCwGMB8+i2htUDQVKVyysKs9l7Y=
X-Gm-Gg: ASbGnctdeoOHH/6UO0VggYlIlkZ1dZisGweFD8bPax6/LIrUpx+e9BaQM5Crt27yK3n
	i3fQzI33PACXfXeMdgCEo14q3j5hdW86O/YNkHr9kMnyIpbbeDphyUeM3+vRQPZIVSTzfmahCcU
	nBXbRgH8rEe/XaggyPEWPBG5Zy0EtUH/3N8cGGxAnFiN0zrAHHGLT+NWcr5ob1gwoaClb0hd+f3
	t85TmGixL6/Zc7x7UopoiCnNSNXo8D+i63VeWQYxB3T9QSgQUw7ywOaZ6m6bKQYdbHaftfQCG+K
	lgqNk5H+rAFap+bg+fk=
X-Google-Smtp-Source: AGHT+IGJZrQfj6YGdkTUJv0nwz0hWjjf+nTDXnsRhoRZxEJ2PhGIJAdhb+GPXfHXuI0eaVDeHYZXrn+l1MrC8fIfosc=
X-Received: by 2002:a05:6402:1454:b0:63b:f22d:9254 with SMTP id
 4fb4d7f45d1cf-64105a4c93amr2413729a12.23.1762341303447; Wed, 05 Nov 2025
 03:15:03 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <176230366393.1647991.7608961849841103569.stgit@frogsfrogsfrogs>
 <176230366453.1647991.17002688390201603817.stgit@frogsfrogsfrogs> <ewqcnrecsvpi5wy3mufy3swnf46ejnz4kc5ph2eb4iriftdddi@mamiprlrvi75>
In-Reply-To: <ewqcnrecsvpi5wy3mufy3swnf46ejnz4kc5ph2eb4iriftdddi@mamiprlrvi75>
From: Amir Goldstein <amir73il@gmail.com>
Date: Wed, 5 Nov 2025 12:14:52 +0100
X-Gm-Features: AWmQ_bkztXnxFOVa3AQuvTjQrg0lv6QJ-KJy3C1E7cBVZUO1j--jX0BJOTU7810
Message-ID: <CAOQ4uxhfrHNk+b=BW5o7We=jC7ob4JbuL4vQz8QhUKD0VaRP=A@mail.gmail.com>
Subject: Re: [PATCH 1/6] iomap: report file IO errors to fsnotify
To: Jan Kara <jack@suse.cz>
Cc: "Darrick J. Wong" <djwong@kernel.org>, cem@kernel.org, hch@lst.de, 
	linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org, gabriel@krisman.be, 
	Christian Brauner <brauner@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 5, 2025 at 12:00=E2=80=AFPM Jan Kara <jack@suse.cz> wrote:
>
> On Tue 04-11-25 16:54:24, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> >
> > Create a generic hook for iomap filesystems to report IO errors to
> > fsnotify and in-kernel subsystems that want to know about such things.
> >
> > Suggested-by: Christoph Hellwig <hch@lst.de>
> > Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
>
> Looks good to me. Feel free to add:
>
> Reviewed-by: Jan Kara <jack@suse.cz>
>
>                                                                 Honza
>
> > ---
> >  include/linux/fs.h     |   64 ++++++++++++++++++++++++++++++++++++++++=
++++++++
> >  fs/iomap/buffered-io.c |    6 +++++
> >  fs/iomap/direct-io.c   |    5 ++++
> >  fs/super.c             |   53 ++++++++++++++++++++++++++++++++++++++++
> >  4 files changed, 128 insertions(+)
> >
> >
> > diff --git a/include/linux/fs.h b/include/linux/fs.h
> > index 5e4b3a4b24823f..1cb3965db3275c 100644
> > --- a/include/linux/fs.h
> > +++ b/include/linux/fs.h
> > @@ -80,6 +80,7 @@ struct fs_context;
> >  struct fs_parameter_spec;
> >  struct file_kattr;
> >  struct iomap_ops;
> > +struct notifier_head;
> >
> >  extern void __init inode_init(void);
> >  extern void __init inode_init_early(void);
> > @@ -1587,6 +1588,7 @@ struct super_block {
> >
> >       spinlock_t              s_inode_wblist_lock;
> >       struct list_head        s_inodes_wb;    /* writeback inodes */
> > +     struct blocking_notifier_head   s_error_notifier;
> >  } __randomize_layout;
> >
> >  static inline struct user_namespace *i_user_ns(const struct inode *ino=
de)
> > @@ -4069,4 +4071,66 @@ static inline bool extensible_ioctl_valid(unsign=
ed int cmd_a,
> >       return true;
> >  }
> >
> > +enum fs_error_type {
> > +     /* pagecache reads and writes */
> > +     FSERR_READAHEAD,
> > +     FSERR_WRITEBACK,
> > +
> > +     /* directio read and writes */
> > +     FSERR_DIO_READ,
> > +     FSERR_DIO_WRITE,
> > +
> > +     /* media error */
> > +     FSERR_DATA_LOST,
> > +
> > +     /* filesystem metadata */
> > +     FSERR_METADATA,
> > +};
> > +
> > +struct fs_error {
> > +     struct work_struct work;
> > +     struct super_block *sb;
> > +     struct inode *inode;
> > +     loff_t pos;
> > +     u64 len;
> > +     enum fs_error_type type;
> > +     int error;
> > +};
> > +
> > +struct fs_error_hook {
> > +     struct notifier_block nb;
> > +};
> > +
> > +static inline int sb_hook_error(struct super_block *sb,
> > +                             struct fs_error_hook *h)
> > +{
> > +     return blocking_notifier_chain_register(&sb->s_error_notifier, &h=
->nb);
> > +}
> > +
> > +static inline void sb_unhook_error(struct super_block *sb,
> > +                                struct fs_error_hook *h)
> > +{
> > +     blocking_notifier_chain_unregister(&sb->s_error_notifier, &h->nb)=
;
> > +}
> > +
> > +static inline void sb_init_error_hook(struct fs_error_hook *h, notifie=
r_fn_t fn)
> > +{
> > +     h->nb.notifier_call =3D fn;
> > +     h->nb.priority =3D 0;
> > +}
> > +
> > +void __sb_error(struct super_block *sb, struct inode *inode,
> > +             enum fs_error_type type, loff_t pos, u64 len, int error);
> > +
> > +static inline void sb_error(struct super_block *sb, int error)
> > +{
> > +     __sb_error(sb, NULL, FSERR_METADATA, 0, 0, error);
> > +}
> > +
> > +static inline void inode_error(struct inode *inode, enum fs_error_type=
 type,
> > +                            loff_t pos, u64 len, int error)
> > +{
> > +     __sb_error(inode->i_sb, inode, type, pos, len, error);
> > +}
> > +

Apart from the fact that Christian is not going to be happy with this
bloat of fs.h
shouldn't all this be part of fsnotify.h?

I do not see why ext4 should not use the same workqueue
or why any code would need to call fsnotify_sb_error() directly.
...

> >  #endif /* _LINUX_FS_H */
> > diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
> > index 8dd5421cb910b5..dc19311fe1c6c0 100644
> > --- a/fs/iomap/buffered-io.c
> > +++ b/fs/iomap/buffered-io.c
> > @@ -291,6 +291,12 @@ static inline bool iomap_block_needs_zeroing(const=
 struct iomap_iter *iter,
> >  inline void iomap_mapping_ioerror(struct address_space *mapping, int d=
irection,
> >               loff_t pos, u64 len, int error)
> >  {
> > +     struct inode *inode =3D mapping->host;
> > +
> > +     inode_error(inode,
> > +                 direction =3D=3D READ ? FSERR_READAHEAD : FSERR_WRITE=
BACK,
> > +                 pos, len, error);
> > +
> >       if (mapping && mapping->a_ops->ioerror)
> >               mapping->a_ops->ioerror(mapping, direction, pos, len,
> >                               error);
> > diff --git a/fs/iomap/direct-io.c b/fs/iomap/direct-io.c
> > index 1512d8dbb0d2e7..9f6ce0d9c531bb 100644
> > --- a/fs/iomap/direct-io.c
> > +++ b/fs/iomap/direct-io.c
> > @@ -95,6 +95,11 @@ ssize_t iomap_dio_complete(struct iomap_dio *dio)
> >
> >       if (dops && dops->end_io)
> >               ret =3D dops->end_io(iocb, dio->size, ret, dio->flags);
> > +     if (dio->error)
> > +             inode_error(file_inode(iocb->ki_filp),
> > +                         (dio->flags & IOMAP_DIO_WRITE) ? FSERR_DIO_WR=
ITE :
> > +                                                          FSERR_DIO_RE=
AD,
> > +                         offset, dio->size, dio->error);
> >       if (dio->error && dops && dops->ioerror)
> >               dops->ioerror(file_inode(iocb->ki_filp),
> >                               (dio->flags & IOMAP_DIO_WRITE) ? WRITE : =
READ,
> > diff --git a/fs/super.c b/fs/super.c
> > index 5bab94fb7e0358..f6d38e4b3d76b2 100644
> > --- a/fs/super.c
> > +++ b/fs/super.c
> > @@ -363,6 +363,7 @@ static struct super_block *alloc_super(struct file_=
system_type *type, int flags,
> >       spin_lock_init(&s->s_inode_list_lock);
> >       INIT_LIST_HEAD(&s->s_inodes_wb);
> >       spin_lock_init(&s->s_inode_wblist_lock);
> > +     BLOCKING_INIT_NOTIFIER_HEAD(&s->s_error_notifier);
> >
> >       s->s_count =3D 1;
> >       atomic_set(&s->s_active, 1);
> > @@ -2267,3 +2268,55 @@ int sb_init_dio_done_wq(struct super_block *sb)
> >       return 0;
> >  }
> >  EXPORT_SYMBOL_GPL(sb_init_dio_done_wq);
> > +
> > +static void handle_sb_error(struct work_struct *work)
> > +{
> > +     struct fs_error *fserr =3D container_of(work, struct fs_error, wo=
rk);
> > +
> > +     fsnotify_sb_error(fserr->sb, fserr->inode, fserr->error);
> > +     blocking_notifier_call_chain(&fserr->sb->s_error_notifier, fserr-=
>type,
> > +                                  fserr);
> > +     iput(fserr->inode);
> > +     kfree(fserr);
> > +}
> > +
> > +/**
> > + * Report a filesystem error.  The actual work is deferred to a workqu=
eue so
> > + * that we're always in process context and to avoid blowing out the c=
aller's
> > + * stack.
> > + *
> > + * @sb Filesystem superblock
> > + * @inode Inode within filesystem, if applicable
> > + * @type Type of error
> > + * @pos Start of file range affected, if applicable
> > + * @len Length of file range affected, if applicable
> > + * @error Error encountered.
> > + */
> > +void __sb_error(struct super_block *sb, struct inode *inode,
> > +             enum fs_error_type type, loff_t pos, u64 len, int error)
> > +{
> > +     struct fs_error *fserr =3D kzalloc(sizeof(struct fs_error), GFP_A=
TOMIC);
> > +
> > +     if (!fserr) {
> > +             printk(KERN_ERR
> > + "lost fs error report for ino %lu type %u pos 0x%llx len 0x%llx error=
 %d",
> > +                             inode ? inode->i_ino : 0, type,
> > +                             pos, len, error);
> > +             return;
> > +     }
> > +
> > +     if (inode) {
> > +             fserr->sb =3D inode->i_sb;
> > +             fserr->inode =3D igrab(inode);
> > +     } else {
> > +             fserr->sb =3D sb;
> > +     }
> > +     fserr->type =3D type;
> > +     fserr->pos =3D pos;
> > +     fserr->len =3D len;
> > +     fserr->error =3D error;
> > +     INIT_WORK(&fserr->work, handle_sb_error);
> > +
> > +     schedule_work(&fserr->work);
> > +}
> > +EXPORT_SYMBOL_GPL(__sb_error);
> >

...
We recently discovered that fsnotify_sb_error() calls are exposed to
races with generic_shutdown_super():
https://lore.kernel.org/linux-fsdevel/scmyycf2trich22v25s6gpe3ib6ejawflwf76=
znxg7sedqablp@ejfycd34xvpa/

Will punting all FS_ERROR events to workqueue help to improve this
situation or will it make it worse?

Another question to ask is whether reporting fs error duing fs shutdown
is a feature or anti feature?

If this is needed then we could change fsnotify_sb_error() to
take ino,gen or file handle directly instead of calling filesystem to encod=
e
a file handle to report with the event.

Thanks,
Amir.
