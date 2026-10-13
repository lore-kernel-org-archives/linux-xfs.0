Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C40251A726
	for <linux-xfs@vger.kernel.org>; Tue, 13 Oct 2026 16:01:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.221.51
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791907284; cv=pass; b=U/BZouvjgBD2pmQzIPnwpcZwzvgkwnk3xL0QfSdNzPeo0+2r+gxy2GeCYvZF+IX4z+6RRoDaOy2SXw725FvNlRWTkFUNhLjU+AFZHx5nT7lAiVSfYd40wnTiEa8dYZR0sfVoGUTF5NtJWQjeDS9WHgdGkgfCxsecCSr0s1dty/c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791907284; c=relaxed/simple;
	bh=X76yH4SRvkB0KYQ4ndhMh74X8GjAVXcRS9Vo55WGTo0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=aP4+JWxTOjWdUSwJp3DkDP84mDdVctTWHBZAXoBzOUDIe6beXBlWfPAMgHImU2X0XVwOZSskOMzm+6a6s6dkD80CJIUFYuebXTD5NMlImU9kTMPCb8S5w+CaiHSd5r4fOLUhz6meds+0chC72CpfeTFPF2ebiUkqxCCXZpDLvDM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QUrMP8wV; arc=pass smtp.client-ip=209.85.221.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QUrMP8wV"
Received: by mail-wr1-f51.google.com with SMTP id ffacd0b85a97d-48b02b1b4cfso3343244f8f.0
        for <linux-xfs@vger.kernel.org>; Tue, 13 Oct 2026 09:01:20 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1791907278; cv=none;
        d=google.com; s=arc-20260327;
        b=UZKqEL3P4Wr9tY9WmQaZPFQKu+28vvE3gUq8gzpZaAwk50ksV1SBcw1dGH6VSNkWS/
         9ATmDRF0xmAHhsVBbWHPT73MVXDqvnqfZHV5QNJxZjbE/Sz4YmGJMivPhUtDMwtCo0Ii
         yT4NbVAodxp/rFlp/COa6JRigTiMRPWmydpd6GzQsR/uabCj7Ik/ScKeEoqxpD+2Gmir
         oVmJti/nwb7+uQKddqgHSBv5zRTDTnBTJv28WVX3EkGWdEAPErxtxh8toTA2bbUkH8Be
         B2bVbjWeOXLpNrSnP5lwltNob6qsT1tAg8AyxVXqRaXrMj3mUfNBCovqEGq4OSp4YYil
         1INw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=qRuzTmy8QvIIH1aAenqhCcAXaaKxqjhhEwzLm0j86Q0=;
        fh=9TgQIkhwBXXhVlUnnorMBU+v1nO8iVnGxD038/yJhA0=;
        b=iW/9/Pd69v8eM5FARx7gH/TZ8AJH8l8zlO7WdJVU52dc/joLxbN1XumcB25RfvP6f3
         l+eHmIGTlGIe/EtAoEyN2wt8xtByaK/t9BrUVlVtNGuo9b2u7xQM/TJTx6Gg3ngLR+q6
         09dc2aWD5zkCsU+ITkMy/HDKkFOvQbIP/QSHDyrH0VloxwVPr8TkCp0hwFv2SundEOud
         ykp9pIpUsw3h2pW3oUWIlh+lnrnTiDLstwEmXg4cSEVzpo7ymRHKLdNOVLEt5FG0q8iY
         4S9yfFftnP7+8ULCZzwMXv/x2hSRbU4KdBVigSOiGOglbF2UObr3L0XGTDhgGjOl5CWs
         CkiA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791907278; x=1792512078; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=qRuzTmy8QvIIH1aAenqhCcAXaaKxqjhhEwzLm0j86Q0=;
        b=QUrMP8wVBM6kkdwBekFIpwVWWopMcDGuejCFS7q7+nhU3QZzieRD/jvRXXIj5Fu9bq
         ekAyVMlskOZz3oT4ybKZp0pnB9oc1UaET4ji37dxASCjIipaaW3BnhE2wD4S79ajyVuS
         OjhS8WJQukUo+WuK6K0Uts1McRV7my8pU0k0AEsv1tcokoreawHnFBqA5phyUtAqZweb
         TM/yQUnU0fw+2S1ynNrelSJqqkE4zN6JBSfaoum1m/Tv3Gx66AdfjzpAKB86WE/H7z0R
         IxoV3rfyHXZlfKf7PQk2s71VJblKJ74W39EI/GrSR7LJhxkmSacJcFS2CTG7AQ/QaSIH
         MGTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791907278; x=1792512078;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=qRuzTmy8QvIIH1aAenqhCcAXaaKxqjhhEwzLm0j86Q0=;
        b=i8jVTLF96IVU7bPmgsehT3WbZEnOiJakH/x+L/zcxLj5INqC7iPPFD4e87uFrogJy/
         VLE8APruFnYYXH126B3u843NpFBfrbDctWJhhYZO1XHmS8Uz++0D/ZpS+c8g1cJc/pyn
         4v56pt/q97kOztvPi7+FBWsZgCp1TBkn0tNy2VT54L/xZBnUQWkxfKHEXMQefb4cXDdO
         /wfhSe+16eDXq2q76bZvS0FREu7xaXRg6WRAjDHl8Ch94B7HHgS5NKTGjJJeeUR8RJ+e
         l0yHObcUSJyQa4jK9GJgTWi3XgDU0lF5gUNnFBHZ8RpKkzBBdcgV2IvqmcYHCxfAmQwU
         40Kg==
X-Forwarded-Encrypted: i=1; AKwUvBzDUL3r1Uo4ySqLz9o8u6L9Ei/x/MMJbLQDmDoh1RAmGtZKieOi/ed62m+19a4yMfMuYLm8U9+z35o=@vger.kernel.org
X-Gm-Message-State: AFq9FYJ1SKBOIKi8/bNQa1ceSUz9vdzBts9AutsRnhkdap/ghE4N5saS
	Pkdai/FDC18P3Tv3I0NabTb9ISWJv7916I0I35KgHwdzlauUfPA/xQ+X1bKgVRh5eWLifS7NqU8
	OscANZsKPj75GpIgGnEdSGaXkXNJx8T0=
X-Gm-Gg: AYBFou0MthirPJT+Kja6SiQwSjR0eb5Jyz8j9ZRYQruj59tsSSaTbFq/dWUpwAkZaNJ
	gMo58h4VhZcEPTv4CZKfso0RgfsHXa7z2tgNOuE4kErAbyRvXK0glLYOU4qcifNPzfrPqjfWogJ
	gjEg+QjcumzYSwxierETCgyxzfZ1KQyKWVKXBvQzXhl9lHiQJ8Sf7dH7bSa2/fduQblK9DKTE3M
	pzmMeqWIVDKBoLYtKl/TtumVyibpwOQgOxsQPBZSd6T3o+yz7SQ8d2/cJBrwIfhcR27FZVPG1kW
	AmDylTDcdMRREiySEQqWUs1uqP8yQAmUWPBMMCfE9vVeNuShhTucgFRl
X-Received: by 2002:a05:600d:4443:10b0:4a1:9c71:9f17 with SMTP id
 5b1f17b1804b1-4a19c71a176mr106991385e9.9.1791907278067; Tue, 13 Oct 2026
 09:01:18 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20261012-work-fs-sb_rdonly-v1-0-60743a3dc326@kernel.org> <20261012-work-fs-sb_rdonly-v1-5-60743a3dc326@kernel.org>
In-Reply-To: <20261012-work-fs-sb_rdonly-v1-5-60743a3dc326@kernel.org>
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Date: Wed, 14 Oct 2026 01:01:00 +0900
X-Gm-Features: AclHuK_PPS1_NVEQIlqEOwtchFvXH7m530N3mEwmecS77mqXkEhqFxAbpQ2_6lM
Message-ID: <CAKFNMonNC1iKjc4Z=PzE9DJJ3X+SmWofbGFXGhHpiN-o1kQGrQ@mail.gmail.com>
Subject: Re: [PATCH RFC 05/28] nilfs2: don't set SB_RDONLY after filesystem errors
To: Christian Brauner <brauner@kernel.org>
Cc: Jan Kara <jack@suse.com>, Al Viro <viro@zeniv.linux.org.uk>, ecryptfs@vger.kernel.org, 
	linux-ext4@vger.kernel.org, jfs-discussion@lists.sourceforge.net, 
	linux-nilfs@vger.kernel.org, exfat@lists.linux.dev, 
	linux-fsdevel@vger.kernel.org, ntfs@lists.linux.dev, 
	ocfs2-devel@lists.linux.dev, linux-btrfs@vger.kernel.org, 
	gfs2@lists.linux.dev, linux-efi@vger.kernel.org, 
	linux-mtd@lists.infradead.org, linux-xfs@vger.kernel.org, 
	Karl Mehltretter <kmehltretter@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 12, 2026 at 7:24=E2=80=AFPM Christian Brauner  wrote:
>
> __nilfs_error() sets SB_RDONLY with errors=3Dremount-ro, the nilfs2
> default. That happens without holding sb->s_umount and from any context,
> also while the filesystem is frozen. FIFREEZE doesn't block reads and a
> lookup in a corrupted directory gets there:
>
>   NILFS error (device vda): nilfs_check_folio: bad entry in directory #11=
: rec_len is smaller than minimal - offset=3D32, inode=3D17, rec_len=3D0, n=
ame_len=3D16
>   Remounting filesystem read-only
>
> freeze_super() and thaw_super() both look at sb_rdonly() to figure out
> whether the s_writers rwsems need to be taken or released. So the thaw
> after such an error skips ->unfreeze_fs() and sb_freeze_unlock() and
> leaves all three rwsems write-locked on a superblock that is marked
> unfrozen. Writers hang in sb_start_write() and umount warns when the
> rwsems are freed:
>
>   WARNING: kernel/rcu/sync.c:177 at rcu_sync_dtor+0x143/0x190, CPU#3: kwo=
rker/3:1/54
>   WARNING: kernel/rcu/sync.c:180 at rcu_sync_dtor+0x14c/0x190
>   WARNING: kernel/rcu/sync.c:188 at rcu_sync_dtor+0x13d/0x190
>
> nilfs2 already treats a runtime SB_RDONLY as "degraded to read-only
> because of corruption" in a lot of places. nilfs_writepages() and
> nilfs_mdt_write_folio() discard dirty pages, nilfs_evict_inode() skips
> the deletion, the segment constructor returns -EROFS and a few
> WARN_ONCE()s accept it. That can all stay as it is. Only what triggers
> it changes. Like ext4 did in commit d3476f3dad4a ("ext4: don't set
> SB_RDONLY after filesystem errors") record the error in a new
> THE_NILFS_EMERGENCY_RO bit and add nilfs_sb_rdonly() which is true for
> a read-only mount and for the emergency state. Then use that for every
> sb_rdonly() check that guards a write.
>
> The VFS won't refuse anything for us anymore so nilfs2 has to do that
> itself. nilfs_permission() returns -EROFS for MAY_WRITE in that state,
> the same way sb_permission() does for a read-only superblock and the
> same way nilfs2 already handles snapshots. That takes care of most
> operations. setattr, write_iter and fileattr_set check the bit as well.
> Symlinks didn't have a ->setattr so far and get nilfs_setattr() for
> that. page_mkwrite fails with VM_FAULT_SIGBUS, the modifying ioctls go
> through a new nilfs_mnt_want_write_file() and FITRIM is refused.
> nilfs_sync_fs() writes neither a segment nor the superblock anymore.
>
> A remount to read-write fails with -EROFS. Note that nilfs2 explicitly
> supported "mount -o remount,rw" after __nilfs_error() so far.
> nilfs_attach_log_writer() reuses the existing log writer for exactly
> that case. Now the state lasts until umount like on ext4 and the comment
> there is updated. A remount to read-only still sets SB_RDONLY but skips
> nilfs_cleanup_super() so the superblock isn't written.
>
> Like ext4 we show "emergency_ro" in the mount options. The mount stays
> "rw". Writes through file descriptors opened before the error now fail
> with -EROFS instead of being accepted and silently dropped by
> nilfs_writepages(). Stores through shared mappings set up before the
> error get SIGBUS once they fault. Stores to pages that were already
> dirty don't fault until nilfs_writepages() discarded the page so those
> are still dropped.
>
> While the current tree is mounted a second mount of the device has to
> match the read-only state of the superblock. So a read-only mount now
> fails with -EBUSY and a read-write mount shares the superblock. If only
> snapshot mounts keep the superblock alive a new mount reconfigures it
> instead. Then a read-only mount makes it read-only and a read-write
> mount after that fails with -EROFS. And a non-forced remount to
> read-only fails with -EBUSY while files are still open for writing.
>
> Reproducer (the sb_rdonly selftest at the end of this series covers it
> as well):
>
>   truncate -s 512M img; mkfs.nilfs2 -q img
>   mount -o loop img /mnt           # errors=3Dremount-ro is the default
>   mkdir /mnt/d; touch /mnt/d/marker0123456789; sync
>   touch /mnt/z; sync               # keep d's block out of the last log, =
the
>   umount /mnt                      # only one checksummed at mount
>   off=3D$(grep -obUa marker0123456789 img | head -1 | cut -d: -f1)
>   printf '\0\0' | dd of=3Dimg bs=3D1 seek=3D$((off - 4)) conv=3Dnotrunc  =
 # rec_len :=3D 0
>   mount -o loop img /mnt
>   fsfreeze -f /mnt; ls /mnt/d; fsfreeze -u /mnt
>   touch /mnt/x     # blocks forever in sb_start_write()
>   # or umount instead: rcu_sync_dtor() warns three times
>
> Reported-by: Karl Mehltretter <kmehltretter@gmail.com>
> Link: https://lore.kernel.org/r/20260903060855.4610-1-kmehltretter@gmail.=
com
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
> ---
>  fs/nilfs2/file.c      | 15 ++++++++++++++-
>  fs/nilfs2/inode.c     | 13 +++++++++++--
>  fs/nilfs2/ioctl.c     | 36 ++++++++++++++++++++++++++++++------
>  fs/nilfs2/mdt.c       |  2 +-
>  fs/nilfs2/namei.c     |  1 +
>  fs/nilfs2/page.c      |  2 +-
>  fs/nilfs2/segment.c   | 13 ++++++-------
>  fs/nilfs2/sufile.h    |  2 +-
>  fs/nilfs2/super.c     | 35 ++++++++++++++++++++++++++++-------
>  fs/nilfs2/the_nilfs.h |  8 ++++++++
>  10 files changed, 101 insertions(+), 26 deletions(-)

Hi Christian,

Thank you very much for this patch.
I've reviewed the change for nilfs2 and its rationale.

I am in favor of this change, even if the emergency read-only flag
ends up being placed in the super_block structure as a result of the
ongoing review.  Feel free to add:

Acked-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>

Thanks,
Ryusuke Konishi

>
> diff --git a/fs/nilfs2/file.c b/fs/nilfs2/file.c
> index f93b68c4877c..17d5e932dba5 100644
> --- a/fs/nilfs2/file.c
> +++ b/fs/nilfs2/file.c
> @@ -54,6 +54,8 @@ static vm_fault_t nilfs_page_mkwrite(struct vm_fault *v=
mf)
>
>         if (unlikely(nilfs_near_disk_full(inode->i_sb->s_fs_info)))
>                 return VM_FAULT_SIGBUS; /* -ENOSPC */
> +       if (unlikely(nilfs_emergency_ro(inode->i_sb->s_fs_info)))
> +               return VM_FAULT_SIGBUS; /* -EROFS */
>
>         sb_start_pagefault(inode->i_sb);
>         folio_lock(folio);
> @@ -133,6 +135,17 @@ static int nilfs_file_mmap_prepare(struct vm_area_de=
sc *desc)
>         return 0;
>  }
>
> +static ssize_t nilfs_file_write_iter(struct kiocb *iocb, struct iov_iter=
 *from)
> +{
> +       struct inode *inode =3D file_inode(iocb->ki_filp);
> +
> +       /* refuse before file_update_time() touches the inode */
> +       if (unlikely(nilfs_emergency_ro(inode->i_sb->s_fs_info)))
> +               return -EROFS;
> +
> +       return generic_file_write_iter(iocb, from);
> +}
> +
>  /*
>   * We have mostly NULL's here: the current defaults are ok for
>   * the nilfs filesystem.
> @@ -140,7 +153,7 @@ static int nilfs_file_mmap_prepare(struct vm_area_des=
c *desc)
>  const struct file_operations nilfs_file_operations =3D {
>         .llseek         =3D generic_file_llseek,
>         .read_iter      =3D generic_file_read_iter,
> -       .write_iter     =3D generic_file_write_iter,
> +       .write_iter     =3D nilfs_file_write_iter,
>         .unlocked_ioctl =3D nilfs_ioctl,
>  #ifdef CONFIG_COMPAT
>         .compat_ioctl   =3D nilfs_compat_ioctl,
> diff --git a/fs/nilfs2/inode.c b/fs/nilfs2/inode.c
> index 34e6096069ad..7dab8cfaad45 100644
> --- a/fs/nilfs2/inode.c
> +++ b/fs/nilfs2/inode.c
> @@ -162,7 +162,7 @@ static int nilfs_writepages(struct address_space *map=
ping,
>         struct inode *inode =3D mapping->host;
>         int err =3D 0;
>
> -       if (sb_rdonly(inode->i_sb)) {
> +       if (nilfs_sb_rdonly(inode->i_sb)) {
>                 nilfs_clear_dirty_pages(mapping);
>                 return -EROFS;
>         }
> @@ -868,7 +868,7 @@ void nilfs_evict_inode(struct inode *inode)
>         truncate_inode_pages_final(&inode->i_data);
>
>         nilfs =3D sb->s_fs_info;
> -       if (unlikely(sb_rdonly(sb) || !nilfs->ns_writer)) {
> +       if (unlikely(nilfs_sb_rdonly(sb) || !nilfs->ns_writer)) {
>                 /*
>                  * If this inode is about to be disposed after the file s=
ystem
>                  * has been degraded to read-only due to file system corr=
uption
> @@ -912,6 +912,9 @@ int nilfs_setattr(struct mnt_idmap *idmap, struct den=
try *dentry,
>         struct super_block *sb =3D inode->i_sb;
>         int err;
>
> +       if (nilfs_emergency_ro(sb->s_fs_info))
> +               return -EROFS;
> +
>         err =3D setattr_prepare(&nop_mnt_idmap, dentry, iattr);
>         if (err)
>                 return err;
> @@ -952,6 +955,12 @@ int nilfs_permission(struct mnt_idmap *idmap, struct=
 inode *inode,
>             root->cno !=3D NILFS_CPTREE_CURRENT_CNO)
>                 return -EROFS; /* snapshot is not writable */
>
> +       /* After an error made us read-only, like sb_permission() would *=
/
> +       if ((mask & MAY_WRITE) && nilfs_emergency_ro(inode->i_sb->s_fs_in=
fo) &&
> +           (S_ISREG(inode->i_mode) || S_ISDIR(inode->i_mode) ||
> +            S_ISLNK(inode->i_mode)))
> +               return -EROFS;
> +
>         return generic_permission(&nop_mnt_idmap, inode, mask);
>  }
>
> diff --git a/fs/nilfs2/ioctl.c b/fs/nilfs2/ioctl.c
> index 01a04080ef70..ac3e1a770162 100644
> --- a/fs/nilfs2/ioctl.c
> +++ b/fs/nilfs2/ioctl.c
> @@ -143,6 +143,9 @@ int nilfs_fileattr_set(struct mnt_idmap *idmap,
>         unsigned int flags, oldflags;
>         int ret;
>
> +       if (nilfs_emergency_ro(inode->i_sb->s_fs_info))
> +               return -EROFS;
> +
>         if (fileattr_has_fsx(fa))
>                 return -EOPNOTSUPP;
>
> @@ -176,6 +179,23 @@ static int nilfs_ioctl_getversion(struct inode *inod=
e, void __user *argp)
>         return put_user(inode->i_generation, (int __user *)argp);
>  }
>
> +/*
> + * Like mnt_want_write_file(), but also refuse writers once an error mad=
e the
> + * filesystem read-only, the VFS doesn't know about that.
> + */
> +static int nilfs_mnt_want_write_file(struct file *filp)
> +{
> +       struct the_nilfs *nilfs =3D file_inode(filp)->i_sb->s_fs_info;
> +       int ret;
> +
> +       ret =3D mnt_want_write_file(filp);
> +       if (!ret && nilfs_emergency_ro(nilfs)) {
> +               mnt_drop_write_file(filp);
> +               ret =3D -EROFS;
> +       }
> +       return ret;
> +}
> +
>  /**
>   * nilfs_ioctl_change_cpmode - change checkpoint mode (checkpoint/snapsh=
ot)
>   * @inode: inode object
> @@ -203,7 +223,7 @@ static int nilfs_ioctl_change_cpmode(struct inode *in=
ode, struct file *filp,
>         if (!capable(CAP_SYS_ADMIN))
>                 return -EPERM;
>
> -       ret =3D mnt_want_write_file(filp);
> +       ret =3D nilfs_mnt_want_write_file(filp);
>         if (ret)
>                 return ret;
>
> @@ -255,7 +275,7 @@ nilfs_ioctl_delete_checkpoint(struct inode *inode, st=
ruct file *filp,
>         if (!capable(CAP_SYS_ADMIN))
>                 return -EPERM;
>
> -       ret =3D mnt_want_write_file(filp);
> +       ret =3D nilfs_mnt_want_write_file(filp);
>         if (ret)
>                 return ret;
>
> @@ -866,7 +886,7 @@ static int nilfs_ioctl_clean_segments(struct inode *i=
node, struct file *filp,
>         if (!capable(CAP_SYS_ADMIN))
>                 return -EPERM;
>
> -       ret =3D mnt_want_write_file(filp);
> +       ret =3D nilfs_mnt_want_write_file(filp);
>         if (ret)
>                 return ret;
>
> @@ -1014,7 +1034,7 @@ static int nilfs_ioctl_resize(struct inode *inode, =
struct file *filp,
>         if (!capable(CAP_SYS_ADMIN))
>                 goto out;
>
> -       ret =3D mnt_want_write_file(filp);
> +       ret =3D nilfs_mnt_want_write_file(filp);
>         if (ret)
>                 goto out;
>
> @@ -1050,6 +1070,10 @@ static int nilfs_ioctl_trim_fs(struct inode *inode=
, void __user *argp)
>         if (!capable(CAP_SYS_ADMIN))
>                 return -EPERM;
>
> +       /* Don't trust the segment usage after an error. */
> +       if (nilfs_emergency_ro(nilfs))
> +               return -EROFS;
> +
>         if (!bdev_max_discard_sectors(nilfs->ns_bdev))
>                 return -EOPNOTSUPP;
>
> @@ -1202,7 +1226,7 @@ static int nilfs_ioctl_set_suinfo(struct inode *ino=
de, struct file *filp,
>         if (!capable(CAP_SYS_ADMIN))
>                 return -EPERM;
>
> -       ret =3D mnt_want_write_file(filp);
> +       ret =3D nilfs_mnt_want_write_file(filp);
>         if (ret)
>                 return ret;
>
> @@ -1295,7 +1319,7 @@ static int nilfs_ioctl_set_fslabel(struct super_blo=
ck *sb, struct file *filp,
>         if (!capable(CAP_SYS_ADMIN))
>                 return -EPERM;
>
> -       ret =3D mnt_want_write_file(filp);
> +       ret =3D nilfs_mnt_want_write_file(filp);
>         if (ret)
>                 return ret;
>
> diff --git a/fs/nilfs2/mdt.c b/fs/nilfs2/mdt.c
> index 2a435349fd21..7863fbc559a2 100644
> --- a/fs/nilfs2/mdt.c
> +++ b/fs/nilfs2/mdt.c
> @@ -398,7 +398,7 @@ static int nilfs_mdt_write_folio(struct folio *folio,
>         struct super_block *sb;
>         int err =3D 0;
>
> -       if (inode && sb_rdonly(inode->i_sb)) {
> +       if (inode && nilfs_sb_rdonly(inode->i_sb)) {
>                 /*
>                  * It means that filesystem was remounted in read-only
>                  * mode because of error or metadata corruption. But we
> diff --git a/fs/nilfs2/namei.c b/fs/nilfs2/namei.c
> index e037e0c6e31a..06b928387212 100644
> --- a/fs/nilfs2/namei.c
> +++ b/fs/nilfs2/namei.c
> @@ -583,6 +583,7 @@ const struct inode_operations nilfs_special_inode_ope=
rations =3D {
>
>  const struct inode_operations nilfs_symlink_inode_operations =3D {
>         .get_link       =3D page_get_link,
> +       .setattr        =3D nilfs_setattr,
>         .permission     =3D nilfs_permission,
>  };
>
> diff --git a/fs/nilfs2/page.c b/fs/nilfs2/page.c
> index cf4f1c6798f5..01c80ed12138 100644
> --- a/fs/nilfs2/page.c
> +++ b/fs/nilfs2/page.c
> @@ -259,7 +259,7 @@ int nilfs_copy_dirty_pages(struct address_space *dmap=
,
>
>                 folio_lock(folio);
>                 if (unlikely(!folio_test_dirty(folio))) {
> -                       if (WARN_ONCE(!sb_rdonly(smap_inode->i_sb),
> +                       if (WARN_ONCE(!nilfs_sb_rdonly(smap_inode->i_sb),
>                                         "inconsistent dirty state\n"))
>                                 goto unlock_folio;
>
> diff --git a/fs/nilfs2/segment.c b/fs/nilfs2/segment.c
> index 829573cb6131..eb79245de60d 100644
> --- a/fs/nilfs2/segment.c
> +++ b/fs/nilfs2/segment.c
> @@ -317,7 +317,7 @@ void nilfs_relax_pressure_in_lock(struct super_block =
*sb)
>         struct the_nilfs *nilfs =3D sb->s_fs_info;
>         struct nilfs_sc_info *sci =3D nilfs->ns_writer;
>
> -       if (sb_rdonly(sb) || unlikely(!sci) || !sci->sc_flush_request)
> +       if (nilfs_sb_rdonly(sb) || unlikely(!sci) || !sci->sc_flush_reque=
st)
>                 return;
>
>         set_bit(NILFS_SC_PRIOR_FLUSH, &sci->sc_flags);
> @@ -2097,7 +2097,7 @@ static int nilfs_segctor_do_construct(struct nilfs_=
sc_info *sci, int mode)
>         struct the_nilfs *nilfs =3D sci->sc_super->s_fs_info;
>         int err;
>
> -       if (sb_rdonly(sci->sc_super))
> +       if (nilfs_sb_rdonly(sci->sc_super))
>                 return -EROFS;
>
>         nilfs_sc_cstage_set(sci, NILFS_ST_INIT);
> @@ -2321,7 +2321,7 @@ int nilfs_construct_segment(struct super_block *sb)
>         struct nilfs_sc_info *sci =3D nilfs->ns_writer;
>         struct nilfs_transaction_info *ti;
>
> -       if (sb_rdonly(sb) || unlikely(!sci))
> +       if (nilfs_sb_rdonly(sb) || unlikely(!sci))
>                 return -EROFS;
>
>         /* A call inside transactions causes a deadlock. */
> @@ -2354,7 +2354,7 @@ int nilfs_construct_dsync_segment(struct super_bloc=
k *sb, struct inode *inode,
>         struct nilfs_transaction_info ti;
>         int err =3D 0;
>
> -       if (sb_rdonly(sb) || unlikely(!sci))
> +       if (nilfs_sb_rdonly(sb) || unlikely(!sci))
>                 return -EROFS;
>
>         nilfs_transaction_lock(sb, &ti, 0);
> @@ -2868,9 +2868,8 @@ int nilfs_attach_log_writer(struct super_block *sb,=
 struct nilfs_root *root)
>
>         if (nilfs->ns_writer) {
>                 /*
> -                * This happens if the filesystem is made read-only by
> -                * __nilfs_error or nilfs_remount and then remounted
> -                * read/write.  In these cases, reuse the existing
> +                * This happens if the filesystem is remounted read-only =
and
> +                * then read/write again.  In this case, reuse the existi=
ng
>                  * writer.
>                  */
>                 return 0;
> diff --git a/fs/nilfs2/sufile.h b/fs/nilfs2/sufile.h
> index 5888ed479c8b..d5e7598e36b3 100644
> --- a/fs/nilfs2/sufile.h
> +++ b/fs/nilfs2/sufile.h
> @@ -76,7 +76,7 @@ int nilfs_sufile_trim_fs(struct inode *sufile, struct f=
strim_range *range);
>                 int _err =3D (err);                                      =
 \
>                                                                         \
>                 if (unlikely(_err))                                     \
> -                       _err =3D WARN_ONCE(!sb_rdonly((sufile)->i_sb),   =
 \
> +                       _err =3D WARN_ONCE(!nilfs_sb_rdonly((sufile)->i_s=
b), \
>                                 "unexpected sufile error %d\n", _err) ? \
>                                 -EIO : -EROFS;                          \
>                 _err;                                                   \
> diff --git a/fs/nilfs2/super.c b/fs/nilfs2/super.c
> index 893a504cb80c..22ae5b51d4ee 100644
> --- a/fs/nilfs2/super.c
> +++ b/fs/nilfs2/super.c
> @@ -137,12 +137,17 @@ void __nilfs_error(struct super_block *sb, const ch=
ar *function,
>
>         va_end(args);
>
> -       if (!sb_rdonly(sb)) {
> +       if (!nilfs_sb_rdonly(sb)) {
>                 nilfs_set_error(sb);
>
>                 if (nilfs_test_opt(nilfs, ERRORS_RO)) {
>                         printk(KERN_CRIT "Remounting filesystem read-only=
\n");
> -                       sb->s_flags |=3D SB_RDONLY;
> +                       /*
> +                        * Don't set SB_RDONLY, that needs sb->s_umount a=
nd a
> +                        * remount. Flipping it on a frozen filesystem ma=
kes
> +                        * thaw leave s_writers locked forever.
> +                        */
> +                       set_nilfs_emergency_ro(nilfs);
>                 }
>         }
>
> @@ -508,7 +513,7 @@ static void nilfs_put_super(struct super_block *sb)
>
>         nilfs_detach_log_writer(sb);
>
> -       if (!sb_rdonly(sb)) {
> +       if (!nilfs_sb_rdonly(sb)) {
>                 down_write(&nilfs->ns_sem);
>                 nilfs_cleanup_super(sb);
>                 up_write(&nilfs->ns_sem);
> @@ -529,6 +534,10 @@ static int nilfs_sync_fs(struct super_block *sb, int=
 wait)
>         struct nilfs_super_block **sbp;
>         int err =3D 0;
>
> +       /* Nothing may be written after an error made us read-only. */
> +       if (nilfs_emergency_ro(nilfs))
> +               return 0;
> +
>         /* This function is called when super block should be written bac=
k */
>         if (wait)
>                 err =3D nilfs_construct_segment(sb);
> @@ -588,7 +597,7 @@ static int nilfs_freeze(struct super_block *sb)
>         struct the_nilfs *nilfs =3D sb->s_fs_info;
>         int err;
>
> -       if (sb_rdonly(sb))
> +       if (nilfs_sb_rdonly(sb))
>                 return 0;
>
>         /* Mark super block clean */
> @@ -602,7 +611,7 @@ static int nilfs_unfreeze(struct super_block *sb)
>  {
>         struct the_nilfs *nilfs =3D sb->s_fs_info;
>
> -       if (sb_rdonly(sb))
> +       if (nilfs_sb_rdonly(sb))
>                 return 0;
>
>         down_write(&nilfs->ns_sem);
> @@ -698,6 +707,8 @@ static int nilfs_show_options(struct seq_file *seq, s=
truct dentry *dentry)
>                 seq_puts(seq, ",norecovery");
>         if (nilfs_test_opt(nilfs, DISCARD))
>                 seq_puts(seq, ",discard");
> +       if (nilfs_emergency_ro(nilfs))
> +               seq_puts(seq, ",emergency_ro");
>
>         return 0;
>  }
> @@ -1087,7 +1098,7 @@ nilfs_fill_super(struct super_block *sb, struct fs_=
context *fc)
>                 goto failed_unload;
>         }
>
> -       if (!sb_rdonly(sb)) {
> +       if (!nilfs_sb_rdonly(sb)) {
>                 err =3D nilfs_attach_log_writer(sb, fsroot);
>                 if (err)
>                         goto failed_checkpoint;
> @@ -1099,7 +1110,7 @@ nilfs_fill_super(struct super_block *sb, struct fs_=
context *fc)
>
>         nilfs_put_root(fsroot);
>
> -       if (!sb_rdonly(sb)) {
> +       if (!nilfs_sb_rdonly(sb)) {
>                 down_write(&nilfs->ns_sem);
>                 nilfs_setup_super(sb, true);
>                 up_write(&nilfs->ns_sem);
> @@ -1145,6 +1156,10 @@ static int nilfs_reconfigure(struct fs_context *fc=
)
>         if (fc->sb_flags & SB_RDONLY) {
>                 sb->s_flags |=3D SB_RDONLY;
>
> +               /* After an error nothing may be written, just go read-on=
ly. */
> +               if (nilfs_emergency_ro(nilfs))
> +                       goto out;
> +
>                 /*
>                  * Remounting a valid RW partition RDONLY, so set
>                  * the RDONLY flag and then mark the partition as valid a=
gain.
> @@ -1156,6 +1171,12 @@ static int nilfs_reconfigure(struct fs_context *fc=
)
>                 __u64 features;
>                 struct nilfs_root *root;
>
> +               /* An error made the filesystem read-only until umount. *=
/
> +               if (nilfs_emergency_ro(nilfs)) {
> +                       err =3D -EROFS;
> +                       goto ignore_opts;
> +               }
> +
>                 /*
>                  * Mounting a RDONLY partition read-write, so reread and
>                  * store the current valid flag.  (It may have been chang=
ed
> diff --git a/fs/nilfs2/the_nilfs.h b/fs/nilfs2/the_nilfs.h
> index 4776a70f01ae..0b300d08898e 100644
> --- a/fs/nilfs2/the_nilfs.h
> +++ b/fs/nilfs2/the_nilfs.h
> @@ -30,6 +30,7 @@ enum {
>         THE_NILFS_GC_RUNNING,   /* gc process is running */
>         THE_NILFS_SB_DIRTY,     /* super block is dirty */
>         THE_NILFS_PURGING,      /* disposing dirty files for cleanup */
> +       THE_NILFS_EMERGENCY_RO, /* read-only after an error */
>  };
>
>  /**
> @@ -204,6 +205,13 @@ THE_NILFS_FNS(DISCONTINUED, discontinued)
>  THE_NILFS_FNS(GC_RUNNING, gc_running)
>  THE_NILFS_FNS(SB_DIRTY, sb_dirty)
>  THE_NILFS_FNS(PURGING, purging)
> +THE_NILFS_FNS(EMERGENCY_RO, emergency_ro)
> +
> +/* Mounted read-only or read-only after an error: nothing may be written=
. */
> +static inline bool nilfs_sb_rdonly(struct super_block *sb)
> +{
> +       return sb_rdonly(sb) || nilfs_emergency_ro(sb->s_fs_info);
> +}
>
>  /*
>   * Mount option operations
>
> --
> 2.53.0
>
>
