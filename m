Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E6C33033CB
	for <linux-xfs@vger.kernel.org>; Fri, 16 Oct 2026 00:01:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=170.10.133.124
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792108879; cv=pass; b=gwnGdCQ4ockR6kTG0DFCAYqk2dfkSqIQ0Qu4y/Gf533J1IaUyL2nmEgII6X6os/qh5K8dDYPt6NE2ObZl1TcBlNqeNa8xtO+MpJgntcGO5lrTfsg/zO7JX8mdXCeEsEjrdD3qb3cLgaz6RHHLuxyttZ6juCX0HAZBi5ELzUFfk8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792108879; c=relaxed/simple;
	bh=cDzYndgVLHSlgLhviEcKgLhvTsb8mhyEeRWsU/W6ToA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=R2BvPfxSGaCIWEmQrGIph6u1Xieu0/wr5zY+cQ/OBt0kuuwJdMgP/NV29HF8WRTPdDZvOPTzXRC46Vf2V+pd2rX8HDp2wwFsJso6Yc22UxzGBnsIguwHzqBPRlZ2l/L/JldcZyWsDoJK/NsAgX58cRSybNs968fxYPuc/kv8IL0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=KTETuX7B; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=Gjw/fAig; arc=pass smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="KTETuX7B";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="Gjw/fAig"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1792108877;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+iJ5ftvCuZ0dzn9DuBnu06m+Dldzk+vmqioG+hhsp4M=;
	b=KTETuX7Bl3yIhSOlAfpbYsDoM2mEeWbG4yFqGwJLAjN5xRFOtGKRqWrHkk23Ug2u+58dXA
	NMVAC7O9jfTfSNp14Rx0DdkRd1Od6zfHn7EEBxyrh4bwXi1q6T3xq17TIP53MZJJeosHLX
	ymVquHJYjctdp7Viv8QvTgcua59O07E=
Received: from mail-yx1-f70.google.com (mail-yx1-f70.google.com
 [74.125.224.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-610-jRaZHbWNNfqW3_xJw-i1IA-1; Fri, 16 Oct 2026 00:01:15 +0000
X-MC-Unique: jRaZHbWNNfqW3_xJw-i1IA-1
X-Mimecast-MFC-AGG-ID: jRaZHbWNNfqW3_xJw-i1IA_1792108875
Received: by mail-yx1-f70.google.com with SMTP id 956f58d0204a3-6755fef4f96so2542105d50.0
        for <linux-xfs@vger.kernel.org>; Thu, 15 Oct 2026 17:01:15 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792108875; cv=none;
        d=google.com; s=arc-20260327;
        b=PyeDjDl79ssjYPkF9ZVxq6ABKGEsX/6TEFpqpDbihTWTJGQB34K8ipb8RJsBxOXhUK
         YzP/U34O5l1W8aihQvSXtH8Htz+dPAQhycJ47AAyApvVsSzGRvhhBHttRZd8XMVP7mHX
         pIZmVOF4KasmwoaeYi0kTjFppdInrO0AorTLZKScmJXROj2tOrqd9M6WZB6nFRt2Jpy5
         lOO8Sb9lgu+wLxnnp1+ofnW1UE8IDzuoyteWitgaJ+pjabTR4J4PufMjaRtc0Uiq+TDr
         eRrh/1UTRa1UOFXIRFRv4FoX/37S4dY8pPzAxX0LwfczSJgNhGThcWVI3itN1jnP27HR
         To3g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=+iJ5ftvCuZ0dzn9DuBnu06m+Dldzk+vmqioG+hhsp4M=;
        fh=LbDYlZOQq8q6prAxRVbt1LsyaXffcUmGlTJAiyzvZzA=;
        b=kBfaAw/F6lykIzsLjGcZq2vY6H4108fwiIS1bikuOii9OKdAo6s7czb/oqm0ceyNln
         vdLQteYG8lP+K8llSV3ZSwZPaFm1E/8A1pUczRUgSahPu6KTRIfAao3urmKWpE42Hl8O
         UJRukOrlLwXdFKPBrxfq/rS1N/68xTj9FPXHiqxzv6PSjLLuudIB5no1UjmSBwHVojKi
         6+82QWB2I+Q/3qZT9vl/GZFtcYgBF4t1R16WiWM2kXmVfq2xNxMkuowQkniDIYoynca4
         Am0jzr2o4k9PA9e1ncArbXJSq3yVc5yTZ8Y17FpNuj/ybJy6dKxmsAJTYYU0i+AMNLaN
         fIUA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1792108875; x=1792713675; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=+iJ5ftvCuZ0dzn9DuBnu06m+Dldzk+vmqioG+hhsp4M=;
        b=Gjw/fAigpWk+a4RfgY4lZTbn3zZbY0OZauyvIEHlKGHBRTZfaSPChY++86oazyoFzP
         EOZF7CBoHWj85aNbBoihvzdpGV1Zd1GTOmYM7NnB7H8FoFmu5hJ1NQ4nr7220mgrO3gJ
         Ncez7b9pBGu4e57gaUUjGtkW/cA8c2lSV/lo8w1B6CaUbd6HOQYnJhS+P+MG+EqowmRs
         CDpOuffQNHUMIixAFZmpASiqEVyTRO3sEYIm+nvQWa0QIx3L46DK/THuNs+j6Lg+ZK7i
         3GHeXCJIUU0Vvk0Zn/5mxUVVL5SbRBsIfdc7OR8sQIIdK9RTMVqeIBpDr29kzOzuuSFZ
         5yPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792108875; x=1792713675;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=+iJ5ftvCuZ0dzn9DuBnu06m+Dldzk+vmqioG+hhsp4M=;
        b=BQWpQtMq1wlPjbGs7gh3CacUY+MjUUqarKsYEVkveebRkOvFEpRxI9h+JHYbyqU3y+
         euZtznL9e+0CdGzr7JalHdZ+iPQ9jpkrdCBSgUL2oFHV/ebb+zG1f3/mIazaGmkpfCxw
         78dqJj36ySoiwGNlAamxAJ6QErJqEYp/m8/YO9rRpx/CXLrE5/whWUuBA3Lo1iHDLv8c
         MCeeXiEuWDvef09j6UcOcxV/Ll/VPkvNHm2PVwomxeQ6J42XjQKIcDTc6vWMW3JgCSbv
         0DnvkpSBWCI4NZah4UH3svQ7pZ21jmfM8vTF1IkuMeTDwr2lEe62aV8IVzAg0LcY3F/j
         MchA==
X-Forwarded-Encrypted: i=1; AKwUvBwA0xcN5WevuhHPdCjy+DO+50Sp5cPDICtv/1ACM+pi7p+JxOjcQOlgVtQwDbQ5vNY6hnwScQc60uA=@vger.kernel.org
X-Gm-Message-State: AFq9FYJqnMNADfbyJdtM+JKyeBEXNxGCRP8qE4PbOxOwVLpSi9oO3J8d
	3MF8++9OeWbN8GXMyMqWI/woV0+y41991t+YyqksbiAi9ZaCe49cINy1c7UTZtEpBs3CQVofN/3
	y9OfzcQBTStkKd5NqnqDD/M8O41CJCNPbZziP/twBc0hq0axaZNVFzSeKDqyI+oGdMOCOO8oLH3
	voSSKZxfIIQfzS6obRykM0yEcUPDZRGBT51hEE
X-Gm-Gg: AYBFou2zJjXF4mHMt+z3wdnfLIKiA6jtY2si/3kNnaOyRmvI+O9CBXvuJnjgkpjOqBC
	VI/JfsIZoMDrKTSrfmRsVfdrGBvZnajRf/OIyuiULon8gqApI/hnRBsDCQ5Phz7D5Obh6EDrU5Q
	sxFaVAFi2UGR2lutgjtYS7t6OUwQqZnsYHWI1gih1bbFlgN5L3qWoPTjXP/zQWoy4F5/lmWTc3R
	SOzoKpgSMcelBjpebWzvz1oDozIk1FCxoOirohlWFov8A==
X-Received: by 2002:a05:690e:b8c:b0:679:980d:996a with SMTP id 956f58d0204a3-679980da3fcmr1447548d50.33.1792108872641;
        Thu, 15 Oct 2026 17:01:12 -0700 (PDT)
X-Received: by 2002:a05:690e:b8c:b0:679:980d:996a with SMTP id
 956f58d0204a3-679980da3fcmr1447535d50.33.1792108871774; Thu, 15 Oct 2026
 17:01:11 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20261012-work-fs-sb_rdonly-v1-0-60743a3dc326@kernel.org> <20261012-work-fs-sb_rdonly-v1-21-60743a3dc326@kernel.org>
In-Reply-To: <20261012-work-fs-sb_rdonly-v1-21-60743a3dc326@kernel.org>
From: Andreas Gruenbacher <agruenba@redhat.com>
Date: Fri, 16 Oct 2026 02:01:00 +0200
X-Gm-Features: AclHuK-sAjCgZe2jZlpOS_f9wdrUdBca6HiO3TEkm1pT3ImiObIJ5_3wwDvQKVU
Message-ID: <CAHc6FU6z4kX5R3Og8m0dYOHsjFcw+4Btvfe87AGPxy_EWs0E7A@mail.gmail.com>
Subject: Re: [PATCH RFC 21/28] gfs2: don't set SB_RDONLY on withdraw
To: Christian Brauner <brauner@kernel.org>
Cc: Jan Kara <jack@suse.com>, Al Viro <viro@zeniv.linux.org.uk>, ecryptfs@vger.kernel.org, 
	linux-ext4@vger.kernel.org, jfs-discussion@lists.sourceforge.net, 
	linux-nilfs@vger.kernel.org, exfat@lists.linux.dev, 
	linux-fsdevel@vger.kernel.org, ntfs@lists.linux.dev, 
	ocfs2-devel@lists.linux.dev, linux-btrfs@vger.kernel.org, 
	gfs2@lists.linux.dev, linux-efi@vger.kernel.org, 
	linux-mtd@lists.infradead.org, linux-xfs@vger.kernel.org, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Christian,

thanks for looking into this. I agree with a lot of the points you are
making. This message is still difficult to reply to because it
conflates multiple problems.

On Mon, Oct 12, 2026 at 1:06=E2=80=AFPM Christian Brauner <brauner@kernel.o=
rg> wrote:
> do_withdraw() sets SB_RDONLY from the withdraw work item without holding
> sb->s_umount. gfs2_withdraw() sets SDF_WITHDRAWN right away and queues
> gfs2_withdraw_func() which runs do_withdraw(). That also happens on a
> frozen filesystem. SDF_JOURNAL_LIVE is still set then because the
> freeze log flush doesn't clear it.

Agreed, do_withdraw() shouldn't set SB_RDONLY.

> freeze_super() and thaw_super() both look at sb_rdonly() to figure out
> whether the s_writers rwsems need to be taken or released. gfs2 doesn't
> even get that far. FITHAW goes through gfs2_thaw_super() to
> gfs2_do_thaw() whose gfs2_freeze_lock_shared() fails with -EIO for a
> withdrawn filesystem. So FITHAW never gets to thaw_super() and the
> filesystem stays frozen.

So when gfs2_thaw_super() is called on a withdrawn filesystem, it
should still call thaw_super(). Fair enough.

> The only ways out are emergency thaw, which
> calls thaw_super_locked() directly, and writing 0 to the gfs2 "freeze"
> sysfs file, which calls thaw_super() directly. Both see SB_RDONLY and
> skip sb_freeze_unlock(). The rwsems stay write-locked, writes through
> file descriptors opened before the withdraw hang and umount warns:
>
>   gfs2: fsid=3Ds2test:s2fs.0: can't lock the freeze glock: -5
>   gfs2: fsid=3Ds2test:s2fs.0: GFS2: couldn't thaw filesystem: -5
>   sysrq: Emergency Thaw of all frozen filesystems
>   WARNING: kernel/rcu/sync.c:177 at rcu_sync_dtor+0x143/0x190
>
>   [<0>] percpu_rwsem_wait+0x203/0x500
>   [<0>] vfs_write+0xb57/0xfa0

According to commit d564053f0746 ("GFS2: Clean up freeze code"), the
idea of the freeze sysfs file was to make it behave like the FIFREEZE
/ FITHAW ioctls. This isn't what the code is doing at all.

> Withdrawing first and freezing afterwards isn't any better.
> freeze_super() freezes the read-only superblock without the rwsems,
> gfs2_lock_fs_check_clean() fails with -EIO and gfs2_do_thaw() can't get
> the freeze glock. FIFREEZE fails with -EIO and the superblock stays
> frozen and pinned for good.
>
> SDF_WITHDRAWN already stops all modifications. Glocks fail with -EIO,
> gfs2_trans_begin() with -EROFS and log flushes and metadata reads are
> refused. So stop setting SB_RDONLY in do_withdraw() like ext4 did in
> commit d3476f3dad4a ("ext4: don't set SB_RDONLY after filesystem
> errors").

Yes, do_withdraw() shouldn't set SB_RDONLY.

> A few things have to come with that:
>
> (1) gfs2_evict_inode() and gfs2_quota_sync() check gfs2_withdrawn() next
>     to sb_rdonly(). Eviction writes the inode glock's metadata in place
>     and umount evicts everything.
>
> (2) gfs2_write_inode() returns -EIO once withdrawn. sync(2), syncfs(2),
>     freeze and umount skipped writeback for the read-only superblock.
>     Now they reach ->write_inode() which writes the glock address space
>     in place without a withdrawn check, and gfs2_ail_drain() leaves
>     committed buffers dirty. Data writeback needs no check because the
>     block mapping goes through gfs2_meta_read() which fails once
>     withdrawn.

Okay, (1) and (2) are related to the SB_RDONLY change.

> (3) gfs2_do_thaw() thaws even if the freeze glock can't be taken again
>     because the filesystem withdrew. A withdrawn filesystem can't write
>     anything and its lockspace is gone anyway.
>
> (4) gfs2_freeze_super() refuses a withdrawn filesystem with -EIO before
>     calling freeze_super(). It can't take the freeze glock anymore and
>     freeze_super() would now take the rwsems of the read-write
>     superblock before gfs2_lock_fs_check_clean() fails.

And (3) and (4) are related to thawing a withdrawn filesystem.

> Note that the SB_RDONLY change and (3) have to go in together and the
> rest has to be in place by then. With only the SB_RDONLY change a freeze
> after a withdraw takes the rwsems of the now read-write superblock and
> stays frozen for good with writers blocked. With only (3) FITHAW reaches
> thaw_super() on the read-only superblock and leaks the rwsems. And
> without (4) a freeze after a withdraw goes through the error path of
> gfs2_freeze_super() which re-locks sd_freeze_gh while
> gfs2_lock_fs_check_clean() still holds it. The umount that is now
> possible then hangs in gfs2_wait_glocks().

Not sure what should prevent us from fixing withdrawn filesystem
thawing and the SB_RDONLY issue in separate commits. Both need fixing
in the end, but that's okay.

> While withdrawn a remount to read-write fails with -EROFS instead of the
> -EIO from gfs2_make_fs_rw().

So before this patch, 'mount -o remount,rw' of a withdrawn filesystem
fails with -EIO, and this patch changes it to -EROFS. What's wrong
with -EIO? Once do_withdraw() doesn't set SB_RDONLY anymore, the
filesystem will remain read-write mounted; getting an -EROFS error in
that state seems odd.

> A remount to read-only goes through
> gfs2_make_fs_ro() which writes nothing once do_withdraw() has run, and
> since the previous patch gfs2_make_fs_ro() waits for that. So emergency
> remount (sysrq u), which now forces every withdrawn gfs2 read-only,
> works without a WARN.

Alright.

> We show "withdrawn" in the mount options next to the existing
> "demote_interface_used". A withdrawn filesystem stays "rw" so statfs()
> doesn't report ST_RDONLY anymore, and the "Mounted RO" line in the sysfs
> status file and the RDONLY=3D uevent field read 0 too. A second mount of
> the device and a gfs2meta mount have to be read-write now. And like with
> "emergency_ro" on ext4, remount helpers that pass the shown options back
> fail. busybox mount for example now gets "Unknown parameter
> 'withdrawn'".
>
> Path based operations fail with -EIO as before. The mount root is the
> exception because it isn't looked up. So operations on it now fail with
> -EIO from the glocks instead of -EROFS from mnt_want_write(), and the
> same goes for fd based chmod, chown, utimes, setxattr and fileattr
> changes. syncfs(2) on a withdrawn filesystem returns gfs2_sync_fs()'s
> sd_log_error, e.g. -EIO, instead of 0. FITHAW of a filesystem that
> withdrew while frozen works now and FIFREEZE of a withdrawn filesystem
> fails with -EIO without freezing it.
>
> Reproducer (the sb_rdonly selftest at the end of this series covers it
> as well):
>
>   mkfs.gfs2 -O -p lock_nolock -j 1 -t test:fs img; mount -o loop img /mnt
>   exec 3>>/mnt/a 4</mnt          # paths stop working after the withdraw
>   fsfreeze -f /mnt
>   echo 1 > /sys/fs/gfs2/test:fs/withdraw; sleep 8
>   <FITHAW on fd 4>               # before: EIO, stays frozen; after: thaw=
ed
>   echo j > /proc/sysrq-trigger   # before: the only way out, leaks the rw=
sems
>   echo x >&3                     # before: hangs in percpu_rwsem_wait(); =
after: EIO
>   umount /mnt                    # before: WARNING at rcu_sync_dtor()
>
> Fixes: 601ef0d52e96 ("gfs2: Force withdraw to replay journals and wait fo=
r it to finish")
> Fixes: b77b4a4815a9 ("gfs2: Rework freeze / thaw logic")
> Cc: stable@vger.kernel.org
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
> ---
>  fs/gfs2/ops_fstype.c |  6 +++++-
>  fs/gfs2/quota.c      |  2 +-
>  fs/gfs2/super.c      | 19 +++++++++++++++++--
>  fs/gfs2/util.c       |  6 ++++--
>  4 files changed, 27 insertions(+), 6 deletions(-)
>
> diff --git a/fs/gfs2/ops_fstype.c b/fs/gfs2/ops_fstype.c
> index 718e0da7dfce..d7f7e8b75971 100644
> --- a/fs/gfs2/ops_fstype.c
> +++ b/fs/gfs2/ops_fstype.c
> @@ -1594,7 +1594,11 @@ static int gfs2_reconfigure(struct fs_context *fc)
>                 if (fc->sb_flags & SB_RDONLY) {
>                         gfs2_make_fs_ro(sdp);
>                 } else {
> -                       error =3D gfs2_make_fs_rw(sdp);
> +                       /* A withdrawn filesystem can't go back to read-w=
rite. */
> +                       if (gfs2_withdrawn(sdp))
> +                               error =3D -EROFS;
> +                       else
> +                               error =3D gfs2_make_fs_rw(sdp);
>
>                         if (error)
>                                 errorfc(fc, "unable to remount read-write=
");
>                 }
> diff --git a/fs/gfs2/quota.c b/fs/gfs2/quota.c
> index 001c8b39ca55..7fac70bae129 100644
> --- a/fs/gfs2/quota.c
> +++ b/fs/gfs2/quota.c
> @@ -1329,7 +1329,7 @@ int gfs2_quota_sync(struct super_block *sb, int typ=
e)
>         u64 sync_gen;
>         int error =3D 0;
>
> -       if (sb_rdonly(sdp->sd_vfs))
> +       if (sb_rdonly(sdp->sd_vfs) || gfs2_withdrawn(sdp))
>                 return 0;
>
>         qda =3D kzalloc_objs(struct gfs2_quota_data *, max_qd);
> diff --git a/fs/gfs2/super.c b/fs/gfs2/super.c
> index 1d7b39354d65..ec7bce124376 100644
> --- a/fs/gfs2/super.c
> +++ b/fs/gfs2/super.c
> @@ -456,6 +456,9 @@ static int gfs2_write_inode(struct inode *inode, stru=
ct writeback_control *wbc)
>         int ret =3D 0;
>         bool flush_all =3D (wbc->sync_mode =3D=3D WB_SYNC_ALL || gfs2_is_=
jdata(ip));
>
> +       if (gfs2_withdrawn(sdp))
> +               return -EIO;
> +
>         if (flush_all)
>                 gfs2_log_flush(GFS2_SB(inode), ip->i_gl,
>                                GFS2_LOG_HEAD_FLUSH_NORMAL |
> @@ -686,7 +689,12 @@ static int gfs2_do_thaw(struct gfs2_sbd *sdp, enum f=
reeze_holder who, const void
>         int error;
>
>         error =3D gfs2_freeze_lock_shared(sdp);
> -       if (error)
> +       /*
> +        * A withdrawn filesystem can't get the freeze glock back, but it=
 won't
> +        * write anything either. Thaw it anyway instead of leaving it fr=
ozen
> +        * for good.
> +        */
> +       if (error && !gfs2_withdrawn(sdp))
>                 goto fail;
>         error =3D thaw_super(sb, who, freeze_owner);
>         if (!error)
> @@ -751,6 +759,11 @@ static int gfs2_freeze_super(struct super_block *sb,=
 enum freeze_holder who,
>                 mutex_unlock(&sdp->sd_freeze_mutex);
>                 return -EBUSY;
>         }
> +       /* A withdrawn filesystem can't take the freeze glock anymore. */
> +       if (gfs2_withdrawn(sdp)) {
> +               mutex_unlock(&sdp->sd_freeze_mutex);
> +               return -EIO;
> +       }

This is racy; the filesystem can still be withdrawn after this
gfs2_withdrawn() check. It should make more sense to bail out of the
for loop in gfs2_freeze_super() on withdrawn filesystems.

>         for (;;) {
>                 error =3D freeze_super(sb, who, freeze_owner);
> @@ -1165,6 +1178,8 @@ static int gfs2_show_options(struct seq_file *s, st=
ruct dentry *root)
>                 seq_puts(s, ",nobarrier");
>         if (test_bit(SDF_DEMOTE, &sdp->sd_flags))
>                 seq_puts(s, ",demote_interface_used");
> +       if (gfs2_withdrawn(sdp))
> +               seq_puts(s, ",withdrawn");

I'm not a fan of those fake mount options. It doesn't matter all that
much for "withdrawn" because remounting will fail anyway, but it's
still messy.

Filesystems with "demote_interface_used" can be remounted, so that
fake option is worse.

"demote_rq" and "demote_interface_used" should never have been added
in the first place, but here we are.

>         if (args->ar_rgrplvb)
>                 seq_puts(s, ",rgrplvb");
>         if (args->ar_loccookie)
> @@ -1466,7 +1481,7 @@ static void gfs2_evict_inode(struct inode *inode)
>         int ret;
>
>         gfs2_holder_mark_uninitialized(&gh);
> -       if (sb_rdonly(sb) || !ip->i_no_addr || !ip->i_gl)
> +       if (sb_rdonly(sb) || gfs2_withdrawn(sdp) || !ip->i_no_addr || !ip=
->i_gl)
>                 goto out;
>
>         /*
> diff --git a/fs/gfs2/util.c b/fs/gfs2/util.c
> index 1535ce2b7aa8..990552f42a0b 100644
> --- a/fs/gfs2/util.c
> +++ b/fs/gfs2/util.c
> @@ -133,9 +133,11 @@ static void do_withdraw(struct gfs2_sbd *sdp)
>                            gfs2_log_is_empty(sdp),
>                            HZ * 5);
>
> -       sdp->sd_vfs->s_flags |=3D SB_RDONLY;
> -
>         /*
> +        * We don't set SB_RDONLY. That requires sb->s_umount, and changi=
ng it
> +        * under freeze_super() and thaw_super() leaves the freeze protec=
tion
> +        * unbalanced. SDF_WITHDRAWN already stops all modifications.
> +        *
>          * Dequeue any pending non-system glock holders that can no
>          * longer be granted because the file system is withdrawn.
>          */
>
> --
> 2.53.0
>

Thanks,
Andreas

