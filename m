Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AA764EB864
	for <linux-xfs@vger.kernel.org>; Wed, 14 Oct 2026 10:04:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=170.10.129.124
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791972271; cv=pass; b=ZldD+dkfAaRUTBfMVFae211cw+vojNmQLjx2P54f+8jEX5vLAmYSqylmRmZiFDtIsinfmegPNOFDWvJl1Ozjy8e2LCxJKHdB4+tBmdPhsrwC27oUXIYwiBeh6ftymkK1pgtXGg5JVO3b67y8xOfftLhHOEk1shH7S3xa84as8nU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791972271; c=relaxed/simple;
	bh=TqmsPJFAydDCQUo6kx8TwRXNfJTbbU9ITh7Lil5oFXM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=evSstvuSWBg4etLxYc6GHlPogjwcRUJ+QpVhj8vDZ8mviya3xgSG/6CHoqhxV8ux49QPYUVSBPjTIatBRLG+SXPhYwAmrNXd1qekFnd9H3y/0cHZcwIDIEXE3vHipkLds8RIFgJDlUh01Njxndsn8ycOM6ZH8SeaJ3/MnBWEFNc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=F0qpR4H2; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=Gboi1E5l; arc=pass smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="F0qpR4H2";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="Gboi1E5l"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1791972268;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Yy8vwH/RoXpMxh37HhgJFxTFAdxrYLgTIo9J4fiSIS4=;
	b=F0qpR4H2+q9ehxEO5U6M7SGLFNcEBeR2wa+uQOMwrlXi0NPhVovI2Ot49vO8WVA7yKzNf1
	8cVWFtq9Bptw8XbpZFntvYeK+i2tTcPoL0Vyrl8G6lVIuI1zPVqeEMDodaa3pTAWkf1Oyn
	2HxbUMz90F6Lc39ujCfg02w/9WZRj90=
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com
 [209.85.214.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-451-WTLE5Jz7NzyKzlOv9smKxg-1; Wed, 14 Oct 2026 10:04:22 +0000
X-MC-Unique: WTLE5Jz7NzyKzlOv9smKxg-1
X-Mimecast-MFC-AGG-ID: WTLE5Jz7NzyKzlOv9smKxg_1791972262
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-2e85f710dbeso10837175ad.1
        for <linux-xfs@vger.kernel.org>; Wed, 14 Oct 2026 03:04:22 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1791972262; cv=none;
        d=google.com; s=arc-20260327;
        b=U3HIYwNha2xWu4dZKpCijU9/0R0ncXQzcnZvm2YULRSGUUUQo1hApFXyLiB+wr3DrQ
         r+OhrC6gwinaNrfVDiutmNkbLrWZV9RpfgU0a39fudzd//hFwuv7ep59Xw1T2X4ahd9r
         S13yoR2H1MoHNah097+GzlA2MxBCaplbjtXrF/M7cM8LgIZjPsfXg+cKy48gBla8EbiA
         CklI3vg+EVi790kU+Y8tSROcGROF41uP3XSn6xp7JmNr/fMJew4Wez/TI+g/PmF/hjPm
         afw6CIc/HG+5pSKhNm063bk7hinIXhLhdRL087mycda/kFcy5hgbazrQBL0UYfjZYIOT
         p5Tg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Yy8vwH/RoXpMxh37HhgJFxTFAdxrYLgTIo9J4fiSIS4=;
        fh=DnLkh0eeiJKbc83NDrASSclCG5FEy0hFpwCo9VIpqQ8=;
        b=mZbVT+RrLzuuMlunlxYC/FO/eEyYiW0x2MqAqXBGsvjCLivxFRzjdzqm1aViLguBTc
         XIQDRmOol1yJtgysuTRsMQniARoyayIKfenbMhDZVBV9biHlxPyf3jKBh8EZDllhCdWK
         Vq1db+/Y5xuVn/88k2BN5jxJzM6DXjXpG1tNlgvgOwxSPalgjyp7LwsJB0HFlSu3goTP
         IRGx3LcW76B60xOIzZvdlX2Hy8uCg8VcJJuCpjQ3vQAjWIdmdgkrqBidmzeDiMnXklFh
         ADKHltaAe0/vH3F19osZfGVDzn+np0y3hUGxIyluHmU0aK+/BM4XYxTrCRQYhhfCBfW+
         OwMw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1791972262; x=1792577062; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Yy8vwH/RoXpMxh37HhgJFxTFAdxrYLgTIo9J4fiSIS4=;
        b=Gboi1E5lbmoHIvW0kbmLl83fDpKe/irGjRQoMJVdQvIPLfhT+Cgu72CBYsRM4sLNok
         gIX9aDZlJ4bMoMaaAVCzZ4Hst+MXoYyZoTixrcuH5z4SUHgimorPohXB1qql3nTArlcB
         ou1E0TPOi73/sEM4GT1kYcoHZb6DJEwG5A8bq0mAtTClhxk7PewLGQSi0fIVxEjKopP9
         +DLzidVtSeHau+YW+W8S77V/Q8QE4tFrVbYKBySbcob1hee/VGzBYglpNkItH4GHqTLE
         ULuMDvH3CmZQGomOhnp9bLWev4ogZPBk1HZV7ZTjxtTW7GYUK3QF5teDNwa7Avn0wpmv
         aw3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791972262; x=1792577062;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Yy8vwH/RoXpMxh37HhgJFxTFAdxrYLgTIo9J4fiSIS4=;
        b=niVQg4sqvrHYGJj1r45qj/QCnmWT4wZw3/L8hG19l6LPTU1OokSxdu6Kt/ZD/+Mlzq
         9YfuCac8h2UHF3FTwLI21ZZYgCN/daIrbUTwZ1/5f2iSWVXszp81ZK+Gi2LCZH351/sc
         WwkRVyiB4k3bYY3/Hb6INshKeiCUZgVx7Gs6usrQeQpsGMdpX5v3BJdkMhWWRSTrHNGE
         QGrD/zbxnrt4tDgaUIGCd25JSrga8KQXnnrzlBIe4+lTEtDlZPai8JH7Xx3Z9lJ6WqNj
         JSP0KHYV0d6YQbxW/qrsVJy9YVlhCZ0biR+AAwMnax4JiDwa452KwXZFaaKIa6u2Rons
         9cfg==
X-Forwarded-Encrypted: i=1; AKwUvBwpOv/RzEbxD+NXm4Aa4gdPUpe5zwaaCnjrKgTdD8+qDJD9kO+lUvCUpoAjNuCD2oXYGhOKXteM/zM=@vger.kernel.org
X-Gm-Message-State: AFq9FYICmP0xOzoftp3JgPMHsUut6Y0Di1/S8XCRCyJt7pPNoM/cgzOR
	aNuJfzd/40iK5+eEk+jDmyIw4G/a+tJcSPIWrWfXeD9XQZhSVVmdCvSFiLXafRePAqVWghCNJ5x
	5zRYV7lwFr2NkdgH3YcyYTRIafxnqUGzZqHYbK4mAfo10gw7QZLNl5pKibZSY9eM31/qJxHmbe1
	W3DhtWM68+2JQjP3XKdPullrwBt/qFLo9nNFREk8Ecuoz6tMQYMQ==
X-Gm-Gg: AYBFou356RApqkJqxK9PmbBK6O1cnioqRZtcW2/LrtIN4EuWt2MsPQolNQOsqOaejkC
	pBtRfDJLHGreSWQ7tqisNFeLO1vz8jHNW11hSDJVjtK5AnNkU3wYqvSCcHZXkksBH96kA0WYe7y
	nCDJ2i+PAlS2nhCfohx4YvSEs5vz2OYTVCNqsFTj5uLqqKvW5+v2sV9Ka/FxVbJs2piIi+YlcQE
	BtoIjISD7h9ts3tpwT6u8WRvWdU8L2s49ClmG9ys0bMCw==
X-Received: by 2002:a17:902:d4d2:b0:2e5:43d8:a946 with SMTP id d9443c01a7336-2e8427eb54dmr123457125ad.8.1791972261276;
        Wed, 14 Oct 2026 03:04:21 -0700 (PDT)
X-Received: by 2002:a17:902:d4d2:b0:2e5:43d8:a946 with SMTP id
 d9443c01a7336-2e8427eb54dmr123456725ad.8.1791972260682; Wed, 14 Oct 2026
 03:04:20 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20261012-work-fs-sb_rdonly-v1-0-60743a3dc326@kernel.org>
 <my2k7257m265fp5ad77n5hfndl23i56gsog3jwnsyocp3yxbnj@aphfqdiej2hs> <20261013-forsten-ammoniak-geknackt-fefec366cc97@brauner>
In-Reply-To: <20261013-forsten-ammoniak-geknackt-fefec366cc97@brauner>
From: Andreas Gruenbacher <agruenba@redhat.com>
Date: Wed, 14 Oct 2026 12:04:08 +0200
X-Gm-Features: AclHuK89XwTjkfX9K2SsPZJlWx-F0zVVEO2vE9D2PZHZPLH37H9mpWJhh9L2Jm4
Message-ID: <CAHc6FU5JuYU8R4=agxgWBoEKrUGyWiitzRn5MwXiV7NZYt=_ag@mail.gmail.com>
Subject: Re: [PATCH RFC 00/28] fs: don't set SB_RDONLY after filesystem errors
To: Christian Brauner <brauner@kernel.org>
Cc: Jan Kara <jack@suse.cz>, Jan Kara <jack@suse.com>, Al Viro <viro@zeniv.linux.org.uk>, 
	ecryptfs@vger.kernel.org, linux-ext4@vger.kernel.org, 
	jfs-discussion@lists.sourceforge.net, linux-nilfs@vger.kernel.org, 
	exfat@lists.linux.dev, linux-fsdevel@vger.kernel.org, ntfs@lists.linux.dev, 
	ocfs2-devel@lists.linux.dev, linux-btrfs@vger.kernel.org, 
	gfs2@lists.linux.dev, linux-efi@vger.kernel.org, 
	linux-mtd@lists.infradead.org, linux-xfs@vger.kernel.org, 
	stable@vger.kernel.org, Karl Mehltretter <kmehltretter@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 14, 2026 at 12:20=E2=80=AFAM Christian Brauner <brauner@kernel.=
org> wrote:
> > I'm in favor of this. Just after checking couple of filesystem changes =
-
> > won't we be better off by using a generic flag in super_block for this =
so
> > that VFS can check for it? Then each filesystem won't have to implement
> > its own wrapper for simple_fsync(), quota operations, and whatever othe=
r
> > generic operations that need to bail on shutdown filesystem...
>
> Do you mean something like?:
>
> From 28c97f2142e255eb835d26deb97b00afccfb7c4a Mon Sep 17 00:00:00 2001
> From: Christian Brauner <brauner@kernel.org>
> Date: Tue, 13 Oct 2026 21:15:36 +0200
> Subject: [PATCH] fs: add a generic emergency read-only state
>
> The filesystems that stopped setting SB_RDONLY after an error refuse
> modifications themselves now. Each of them grew the same checks in
> ->open, ->setattr, ->fsync, ->write_inode, the directory operations, the
> quota operations and ->reconfigure. Jan suggested a generic flag so the
> VFS can do that once (cf. [1]).
>
> So add SB_STATE_EMERGENCY_RO in a new sb->s_state word. It is only ever
> set with set_bit() and never cleared so it can be tested anywhere
> without any ordering against the setter. A filesystem calls
> sb_set_emergency_ro() where it used to set SB_RDONLY. SB_RDONLY itself
> stays untouched so freeze_super() and thaw_super() keep seeing a
> consistent superblock.
>
> The VFS then checks it wherever sb_rdonly() gates a write:
>
> - __mnt_is_readonly() so mnt_want_write(), opening files for writing,
>   access(W_OK), nfsd and overlayfs see a read-only superblock
> - sb_permission() for vfs_create(), vfs_unlink() and friends
> - notify_change(), rw_verify_area(), vfs_fallocate(), vfs_fsync_range()
>   and do_page_mkwrite() for files that were opened before the error
> - reconfigure_super() refuses going read-write
> - sync_filesystem(), sync(2) and write_inode() don't write anymore
> - the dquot code doesn't write the quota files anymore and quotactl(2)
>   refuses to change anything
> - "emergency_ro" is shown in the mount options, /proc/mounts shows the
>   superblock as "ro" and statfs() reports ST_RDONLY like they did when
>   SB_RDONLY was set
>
> What reaches the filesystem without passing through the VFS it still has
> to refuse itself. That's its allocators, its journal, its own writeback
> and the deletion of unlinked inodes.

For shared filesystems like gfs2, the concept of an emergency
read-only state doesn't make sense because in that state (in gfs2
terms, a withdrawn filesystem), we cannot do any more cluster-wide
locking and so we cannot allow any more reads, either. Could we define
the new flag in a way that would allow filesystems to enforce stronger
guarantees? This would suggest a flag name other than
SB_STATE_EMERGENCY_RO, though.

Thanks,
Andreas

> [1]: https://lore.kernel.org/r/my2k7257m265fp5ad77n5hfndl23i56gsog3jwnsyo=
cp3yxbnj@aphfqdiej2hs
>
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
> ---
>  Documentation/filesystems/porting.rst | 16 ++++++++++++++++
>  fs/attr.c                             |  4 ++++
>  fs/fs-writeback.c                     |  3 +++
>  fs/namei.c                            |  3 ++-
>  fs/namespace.c                        |  3 ++-
>  fs/open.c                             |  4 ++++
>  fs/proc_namespace.c                   |  4 +++-
>  fs/quota/dquot.c                      | 23 +++++++++++++++++------
>  fs/quota/quota.c                      | 13 +++++++++++++
>  fs/read_write.c                       |  5 +++++
>  fs/statfs.c                           |  9 +++++++--
>  fs/super.c                            |  4 ++++
>  fs/sync.c                             | 18 +++++++++++++-----
>  include/linux/fs/super.h              | 18 ++++++++++++++++++
>  include/linux/fs/super_types.h        | 21 +++++++++++++++++++++
>  mm/memory.c                           |  6 ++++++
>  16 files changed, 138 insertions(+), 16 deletions(-)
>
> diff --git a/Documentation/filesystems/porting.rst b/Documentation/filesy=
stems/porting.rst
> index 60880eb0c49d..c60f74a99568 100644
> --- a/Documentation/filesystems/porting.rst
> +++ b/Documentation/filesystems/porting.rst
> @@ -1409,3 +1409,19 @@ use only if you have no alternative.
>  The .create inode_operation no longer receives the 'excl' arg.  It must
>  always assume the file does not already exist.  If the filesystem needs
>  to be involved in non-exclusive create, it should provide atomic_open.
> +
> +---
> +
> +**recommended**
> +
> +Filesystems that set SB_RDONLY on the superblock after an error
> +(errors=3Dremount-ro) must not do that anymore.


> SB_RDONLY only changes under
> +sb->s_umount through reconfigure_super() and freeze_super() and thaw_sup=
er()
> +rely on that. Call sb_set_emergency_ro() instead. The VFS then refuses
> +modifications with EROFS, refuses a remount to read-write, shows
> +"emergency_ro" in the mount options and stops syncing the filesystem and
> +writing back its inodes. The filesystem still has to refuse what reaches=
 it
> +without passing through the VFS: its own allocation, journal and writeba=
ck
> +paths and the deletion of unlinked inodes in ->evict_inode(). Test
> +sb_emergency_ro() for that. A remount to read-only must not write anythi=
ng
> +in that state either, in particular it must not mark the filesystem clea=
n.
> diff --git a/fs/attr.c b/fs/attr.c
> index 71888ac903c2..e4973f68b6c6 100644
> --- a/fs/attr.c
> +++ b/fs/attr.c
> @@ -435,6 +435,10 @@ int notify_change(struct mnt_idmap *idmap, struct de=
ntry *dentry,
>
>         WARN_ON_ONCE(!inode_is_locked(inode));
>
> +       /* Nothing can be changed after an error made the filesystem read=
-only. */
> +       if (sb_emergency_ro(inode->i_sb))
> +               return -EROFS;
> +
>         error =3D may_setattr(idmap, inode, ia_valid);
>         if (error)
>                 return error;
> diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
> index ea3eb40bf828..bd095a911620 100644
> --- a/fs/fs-writeback.c
> +++ b/fs/fs-writeback.c
> @@ -1618,6 +1618,9 @@ static int write_inode(struct inode *inode, struct =
writeback_control *wbc)
>  {
>         int ret;
>
> +       /* Nothing may be written after an error made the filesystem read=
-only. */
> +       if (sb_emergency_ro(inode->i_sb))
> +               return -EROFS;
>         if (inode->i_sb->s_op->write_inode && !is_bad_inode(inode)) {
>                 trace_writeback_write_inode_start(inode, wbc);
>                 ret =3D inode->i_sb->s_op->write_inode(inode, wbc);
> diff --git a/fs/namei.c b/fs/namei.c
> index c87c14ee1a25..902a2e998ed4 100644
> --- a/fs/namei.c
> +++ b/fs/namei.c
> @@ -607,7 +607,8 @@ static int sb_permission(struct super_block *sb, stru=
ct inode *inode, int mask)
>                 umode_t mode =3D inode->i_mode;
>
>                 /* Nobody gets write access to a read-only fs. */
> -               if (sb_rdonly(sb) && (S_ISREG(mode) || S_ISDIR(mode) || S=
_ISLNK(mode)))
> +               if ((sb_rdonly(sb) || sb_emergency_ro(sb)) &&
> +                   (S_ISREG(mode) || S_ISDIR(mode) || S_ISLNK(mode)))
>                         return -EROFS;
>         }
>         return 0;
> diff --git a/fs/namespace.c b/fs/namespace.c
> index 3ed3766f3a18..5e172cf70e71 100644
> --- a/fs/namespace.c
> +++ b/fs/namespace.c
> @@ -392,7 +392,8 @@ static struct mount *alloc_vfsmnt(const char *name)
>   */
>  bool __mnt_is_readonly(const struct vfsmount *mnt)
>  {
> -       return (mnt->mnt_flags & MNT_READONLY) || sb_rdonly(mnt->mnt_sb);
> +       return (mnt->mnt_flags & MNT_READONLY) || sb_rdonly(mnt->mnt_sb) =
||
> +              sb_emergency_ro(mnt->mnt_sb);
>  }
>  EXPORT_SYMBOL_GPL(__mnt_is_readonly);
>
> diff --git a/fs/open.c b/fs/open.c
> index 6b1c14e684a9..d7698c4bc8d5 100644
> --- a/fs/open.c
> +++ b/fs/open.c
> @@ -324,6 +324,10 @@ int vfs_fallocate(struct file *file, int mode, loff_=
t offset, loff_t len)
>         if (!S_ISREG(inode->i_mode) && !S_ISBLK(inode->i_mode))
>                 return -ENODEV;
>
> +       /* Files can't be written after an error made the filesystem read=
-only. */
> +       if (S_ISREG(inode->i_mode) && sb_emergency_ro(inode->i_sb))
> +               return -EROFS;
> +
>         /* Check for wraparound */
>         if (check_add_overflow(offset, len, &sum))
>                 return -EFBIG;
> diff --git a/fs/proc_namespace.c b/fs/proc_namespace.c
> index 036356c0a55b..85da3f6865c7 100644
> --- a/fs/proc_namespace.c
> +++ b/fs/proc_namespace.c
> @@ -57,6 +57,8 @@ static int show_sb_opts(struct seq_file *m, struct supe=
r_block *sb)
>                 if (sb->s_flags & fs_infop->flag)
>                         seq_puts(m, fs_infop->str);
>         }
> +       if (sb_emergency_ro(sb))
> +               seq_puts(m, ",emergency_ro");
>
>         return security_sb_show_options(m, sb);
>  }
> @@ -179,7 +181,7 @@ static int show_mountinfo(struct seq_file *m, struct =
vfsmount *mnt)
>         } else {
>                 mangle(m, r->mnt_devname);
>         }
> -       seq_puts(m, sb_rdonly(sb) ? " ro" : " rw");
> +       seq_puts(m, sb_rdonly(sb) || sb_emergency_ro(sb) ? " ro" : " rw")=
;
>         err =3D show_sb_opts(m, sb);
>         if (err)
>                 goto out;
> diff --git a/fs/quota/dquot.c b/fs/quota/dquot.c
> index 1c78c695d0dd..56c54d437c38 100644
> --- a/fs/quota/dquot.c
> +++ b/fs/quota/dquot.c
> @@ -495,6 +495,11 @@ int dquot_acquire(struct dquot *dquot)
>         set_bit(DQ_READ_B, &dquot->dq_flags);
>         /* Instantiate dquot if needed */
>         if (!dquot_active(dquot) && !dquot->dq_off) {
> +               /* Nothing may be written after an error made the fs read=
-only. */
> +               if (sb_emergency_ro(dquot->dq_sb)) {
> +                       ret =3D -EROFS;
> +                       goto out_iolock;
> +               }
>                 ret =3D dqopt->ops[dquot->dq_id.type]->commit_dqblk(dquot=
);
>                 /* Write the info if needed */
>                 if (info_dirty(&dqopt->info[dquot->dq_id.type])) {
> @@ -536,10 +541,12 @@ int dquot_commit(struct dquot *dquot)
>                 goto out_lock;
>         /* Inactive dquot can be only if there was error during read/init
>          * =3D> we have better not writing it */
> -       if (dquot_active(dquot))
> -               ret =3D dqopt->ops[dquot->dq_id.type]->commit_dqblk(dquot=
);
> -       else
> +       if (!dquot_active(dquot))
>                 ret =3D -EIO;
> +       else if (sb_emergency_ro(dquot->dq_sb))
> +               ret =3D -EROFS;
> +       else
> +               ret =3D dqopt->ops[dquot->dq_id.type]->commit_dqblk(dquot=
);
>  out_lock:
>         memalloc_nofs_restore(memalloc);
>         mutex_unlock(&dquot->dq_lock);
> @@ -561,7 +568,8 @@ int dquot_release(struct dquot *dquot)
>         /* Check whether we are not racing with some other dqget() */
>         if (dquot_is_busy(dquot))
>                 goto out_dqlock;
> -       if (dqopt->ops[dquot->dq_id.type]->release_dqblk) {
> +       if (dqopt->ops[dquot->dq_id.type]->release_dqblk &&
> +           !sb_emergency_ro(dquot->dq_sb)) {
>                 ret =3D dqopt->ops[dquot->dq_id.type]->release_dqblk(dquo=
t);
>                 /* Write the info */
>                 if (info_dirty(&dqopt->info[dquot->dq_id.type])) {
> @@ -2132,6 +2140,9 @@ int dquot_commit_info(struct super_block *sb, int t=
ype)
>  {
>         struct quota_info *dqopt =3D sb_dqopt(sb);
>
> +       /* Nothing may be written after an error made the fs read-only. *=
/
> +       if (sb_emergency_ro(sb))
> +               return -EROFS;
>         return dqopt->ops[type]->write_file_info(sb, type);
>  }
>  EXPORT_SYMBOL(dquot_commit_info);
> @@ -2255,7 +2266,7 @@ int dquot_disable(struct super_block *sb, int type,=
 unsigned int flags)
>                  * Now all dquots should be invalidated, all writes done =
so we
>                  * should be only users of the info. No locks needed.
>                  */
> -               if (info_dirty(&dqopt->info[cnt]))
> +               if (info_dirty(&dqopt->info[cnt]) && !sb_emergency_ro(sb)=
)
>                         sb->dq_op->write_info(sb, cnt);
>                 if (dqopt->ops[cnt]->free_file_info)
>                         dqopt->ops[cnt]->free_file_info(sb, cnt);
> @@ -2272,7 +2283,7 @@ int dquot_disable(struct super_block *sb, int type,=
 unsigned int flags)
>
>         /* Sync the superblock so that buffers with quota data are writte=
n to
>          * disk (and so userspace sees correct data afterwards). */
> -       if (sb->s_op->sync_fs)
> +       if (sb->s_op->sync_fs && !sb_emergency_ro(sb))
>                 sb->s_op->sync_fs(sb, 1);
>         sync_blockdev(sb->s_bdev);
>         /* Now the quota files are just ordinary files and we can set the
> diff --git a/fs/quota/quota.c b/fs/quota/quota.c
> index 33bacd707580..7612c96493d1 100644
> --- a/fs/quota/quota.c
> +++ b/fs/quota/quota.c
> @@ -783,6 +783,19 @@ static int do_quotactl(struct super_block *sb, int t=
ype, int cmd, qid_t id,
>         if (ret < 0)
>                 return ret;
>
> +       /* Nothing can be changed after an error made the filesystem read=
-only. */
> +       if (sb_emergency_ro(sb)) {
> +               switch (cmd) {
> +               case Q_QUOTAON:
> +               case Q_SETINFO:
> +               case Q_SETQUOTA:
> +               case Q_XQUOTAON:
> +               case Q_XQUOTARM:
> +               case Q_XSETQLIM:
> +                       return -EROFS;
> +               }
> +       }
> +
>         switch (cmd) {
>         case Q_QUOTAON:
>                 return quota_quotaon(sb, type, id, path);
> diff --git a/fs/read_write.c b/fs/read_write.c
> index e8c14e2760b2..4b587ba084bf 100644
> --- a/fs/read_write.c
> +++ b/fs/read_write.c
> @@ -472,6 +472,11 @@ int rw_verify_area(int read_write, struct file *file=
, const loff_t *ppos, size_t
>                 }
>         }
>
> +       /* Files can't be written after an error made the filesystem read=
-only. */
> +       if (read_write =3D=3D WRITE && S_ISREG(file_inode(file)->i_mode) =
&&
> +           sb_emergency_ro(file_inode(file)->i_sb))
> +               return -EROFS;
> +
>         ret =3D security_file_permission(file, mask);
>         if (ret)
>                 return ret;
> diff --git a/fs/statfs.c b/fs/statfs.c
> index 377bcef7a561..05a90d5a3310 100644
> --- a/fs/statfs.c
> +++ b/fs/statfs.c
> @@ -48,8 +48,13 @@ static int flags_by_sb(int s_flags)
>
>  static int calculate_f_flags(struct vfsmount *mnt)
>  {
> -       return ST_VALID | flags_by_mnt(mnt->mnt_flags) |
> -               flags_by_sb(mnt->mnt_sb->s_flags);
> +       int flags =3D ST_VALID | flags_by_mnt(mnt->mnt_flags) |
> +                   flags_by_sb(mnt->mnt_sb->s_flags);
> +
> +       /* An error made the filesystem read-only, SB_RDONLY stays clear.=
 */
> +       if (sb_emergency_ro(mnt->mnt_sb))
> +               flags |=3D ST_RDONLY;
> +       return flags;
>  }
>
>  static int statfs_by_dentry(struct dentry *dentry, struct kstatfs *buf)
> diff --git a/fs/super.c b/fs/super.c
> index 1d5ccf540a9b..74cde61e8d71 100644
> --- a/fs/super.c
> +++ b/fs/super.c
> @@ -1091,6 +1091,10 @@ int reconfigure_super(struct fs_context *fc)
>                 remount_ro =3D (fc->sb_flags & SB_RDONLY) && !sb_rdonly(s=
b);
>         }
>
> +       /* An error made the filesystem read-only until it is unmounted. =
*/
> +       if (remount_rw && sb_emergency_ro(sb))
> +               return -EROFS;
> +
>         if (remount_ro) {
>                 if (!hlist_empty(&sb->s_pins)) {
>                         super_unlock_excl(sb);
> diff --git a/fs/sync.c b/fs/sync.c
> index 4a84dd837b86..f183c364815c 100644
> --- a/fs/sync.c
> +++ b/fs/sync.c
> @@ -38,9 +38,10 @@ int sync_filesystem(struct super_block *sb)
>         WARN_ON(!rwsem_is_locked(&sb->s_umount));
>
>         /*
> -        * No point in syncing out anything if the filesystem is read-onl=
y.
> +        * No point in syncing out anything if the filesystem is read-onl=
y, and
> +        * nothing may be written after an error made it read-only.
>          */
> -       if (sb_rdonly(sb))
> +       if (sb_rdonly(sb) || sb_emergency_ro(sb))
>                 return 0;
>
>         /*
> @@ -73,14 +74,14 @@ EXPORT_SYMBOL(sync_filesystem);
>
>  static void sync_inodes_one_sb(struct super_block *sb, void *arg)
>  {
> -       if (!sb_rdonly(sb))
> +       if (!sb_rdonly(sb) && !sb_emergency_ro(sb))
>                 sync_inodes_sb(sb);
>  }
>
>  static void sync_fs_one_sb(struct super_block *sb, void *arg)
>  {
> -       if (!sb_rdonly(sb) && !(sb->s_iflags & SB_I_SKIP_SYNC) &&
> -           sb->s_op->sync_fs)
> +       if (!sb_rdonly(sb) && !sb_emergency_ro(sb) &&
> +           !(sb->s_iflags & SB_I_SKIP_SYNC) && sb->s_op->sync_fs)
>                 sb->s_op->sync_fs(sb, *(int *)arg);
>  }
>
> @@ -181,6 +182,13 @@ int vfs_fsync_range(struct file *file, loff_t start,=
 loff_t end, int datasync)
>
>         if (!file->f_op->fsync)
>                 return -EINVAL;
> +       /*
> +        * Inodes aren't written back after an error made the filesystem
> +        * read-only, don't claim they're on disk.
> +        */
> +       if (!special_file(file_inode(file)->i_mode) &&
> +           sb_emergency_ro(file_inode(file)->i_sb))
> +               return -EROFS;
>         if (!datasync)
>                 sync_lazytime(inode);
>         return file->f_op->fsync(file, start, end, datasync);
> diff --git a/include/linux/fs/super.h b/include/linux/fs/super.h
> index 733d439f01ed..346f52047999 100644
> --- a/include/linux/fs/super.h
> +++ b/include/linux/fs/super.h
> @@ -2,6 +2,7 @@
>  #ifndef _LINUX_FS_SUPER_H
>  #define _LINUX_FS_SUPER_H
>
> +#include <linux/bitops.h>
>  #include <linux/fs/super_types.h>
>  #include <linux/unicode.h>
>
> @@ -187,6 +188,23 @@ static inline bool sb_rdonly(const struct super_bloc=
k *sb)
>         return sb->s_flags & SB_RDONLY;
>  }
>
> +/*
> + * True once an error made the filesystem read-only. SB_RDONLY stays cle=
ar, so
> + * this is checked wherever sb_rdonly() gates a write. It must not be ch=
ecked
> + * where sb_rdonly() describes the mount, i.e. by freeze_super() and
> + * thaw_super(), because it can be set while the superblock is frozen.
> + */
> +static inline bool sb_emergency_ro(const struct super_block *sb)
> +{
> +       return test_bit(SB_STATE_EMERGENCY_RO, &sb->s_state);
> +}
> +
> +/* Returns true for the caller that made the filesystem read-only. */
> +static inline bool sb_set_emergency_ro(struct super_block *sb)
> +{
> +       return !test_and_set_bit(SB_STATE_EMERGENCY_RO, &sb->s_state);
> +}
> +
>  static inline bool sb_is_blkdev_sb(struct super_block *sb)
>  {
>         return IS_ENABLED(CONFIG_BLOCK) && sb =3D=3D blockdev_superblock;
> diff --git a/include/linux/fs/super_types.h b/include/linux/fs/super_type=
s.h
> index ecd96aeb1cee..efd924474062 100644
> --- a/include/linux/fs/super_types.h
> +++ b/include/linux/fs/super_types.h
> @@ -238,6 +238,9 @@ struct super_block {
>         /* Read-only state of the superblock is being changed */
>         int                                     s_readonly_remount;
>
> +       /* Runtime state bits, see SB_STATE_*. Set with set_bit(), never =
cleared. */
> +       unsigned long                           s_state;
> +
>         /* per-sb errseq_t for reporting writeback errors via syncfs */
>         errseq_t s_wb_err;
>
> @@ -353,4 +356,22 @@ struct super_block {
>  #define SB_I_ALLOW_HSM 0x00004000      /* Allow HSM events on this super=
block */
>  #define SB_I_NO_DATA_INTEGRITY 0x00008000 /* fs cannot guarantee data pe=
rsistence on sync */
>
> +/*
> + * sb->s_state. These are set with set_bit() from whatever context found=
 the
> + * condition, without s_umount, and are never cleared. So they can be te=
sted
> + * anywhere without any ordering against the setter. That's deliberately=
 not
> + * true for SB_RDONLY: freeze_super() and thaw_super() key off it and it=
 must
> + * only change under s_umount through reconfigure_super().
> + */
> +enum {
> +       /*
> +        * An error made the filesystem read-only, errors=3Dremount-ro st=
yle. The
> +        * VFS refuses modifications with EROFS, refuses a remount to rea=
d-write
> +        * and stops syncing the filesystem and writing back its inodes. =
Lasts
> +        * until umount. The filesystem still has to refuse whatever reac=
hes it
> +        * without going through the VFS, see sb_emergency_ro().
> +        */
> +       SB_STATE_EMERGENCY_RO,
> +};
> +
>  #endif /* _LINUX_FS_SUPER_TYPES_H */
> diff --git a/mm/memory.c b/mm/memory.c
> index 8b0c2c735d3d..f4030571d972 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -3813,6 +3813,12 @@ static vm_fault_t do_page_mkwrite(struct vm_fault =
*vmf, struct folio *folio)
>             IS_SWAPFILE(vmf->vma->vm_file->f_mapping->host))
>                 return VM_FAULT_SIGBUS;
>
> +       /* Files can't be written after an error made the filesystem read=
-only. */
> +       if (vmf->vma->vm_file &&
> +           S_ISREG(file_inode(vmf->vma->vm_file)->i_mode) &&
> +           sb_emergency_ro(file_inode(vmf->vma->vm_file)->i_sb))
> +               return VM_FAULT_SIGBUS;
> +
>         ret =3D vmf->vma->vm_ops->page_mkwrite(vmf);
>         /* Restore original flags so that caller is not surprised */
>         vmf->flags =3D old_flags;
> --
> 2.53.0
>
>

Thanks,
Andreas

