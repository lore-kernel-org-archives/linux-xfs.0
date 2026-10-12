Received: from mail-yw1-f182.google.com (mail-yw1-f182.google.com [209.85.128.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC71E3A8723
	for <linux-xfs@vger.kernel.org>; Mon, 12 Oct 2026 22:57:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791845858; cv=none; b=WBRU0gavbgRSBLJSJ1I7ll4BdpRgztILR0liil2809H2+a8RUfcBTopCCP0UYD1CtRvJWh3boEoZHZWKmAkMam9CGO7PG68FuRtEkCT+RLJCBLnnOMnOdkhCFuB8LyxzE7ijSJ6M3kllmob2r8YpEgHRpH3FHYM4qWKc8RViN3c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791845858; c=relaxed/simple;
	bh=eWo760y7gmI9cxnBusd7zY03p9gSKisC9GbRvpjXnnk=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=XHx5FWap45xfZWdrkLNLbtTiP1de4LeBNY5C2bzdEoK3ny3TPluHZm+rQOMZTku5N8lmY8FRwWDNzLFPJZQg/T7QIJ6pJsZ4PuWb4uFYyrnzWfBas6fJXtONEj/Y3fd3EtPf4g9s+il+xzszMz0rIwSZROCvFjFfzdCb7hho1/I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dubeyko.com; spf=pass smtp.mailfrom=dubeyko.com; dkim=pass (2048-bit key) header.d=dubeyko-com.20251104.gappssmtp.com header.i=@dubeyko-com.20251104.gappssmtp.com header.b=gb5MUXUI; arc=none smtp.client-ip=209.85.128.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dubeyko.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dubeyko.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dubeyko-com.20251104.gappssmtp.com header.i=@dubeyko-com.20251104.gappssmtp.com header.b="gb5MUXUI"
Received: by mail-yw1-f182.google.com with SMTP id 00721157ae682-8acda240937so16419777b3.3
        for <linux-xfs@vger.kernel.org>; Mon, 12 Oct 2026 15:57:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dubeyko-com.20251104.gappssmtp.com; s=20251104; t=1791845854; x=1792450654; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :autocrypt:references:in-reply-to:date:cc:to:from:subject:message-id
         :from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=aMcvmUfQuTvPvphd1MGRcussZ+Yz/mLoC8RUhLXVZu0=;
        b=gb5MUXUIFBcHoLiWNooxPrwlhK92hkDG/oz2ioqDX7uSM70i+A9KSjimcUcEA5MOL8
         YWJryvwugkV4j1XnkumuWDtYmcjJW4AeXQXoRDXYt17x3bg4//bKZV2/dOS2+kOYst0T
         fWcSKOB5lo7bLQcRVTEHJbAz/IcN+lklVpLW+Rnx9MkN6Inp3bA7ILY9zUilwLw5oouu
         cpQUvUuB44TkAeIJUA3tmspN8UD/40AC6FQnqyVC2px24gqa8XnaQleT+XnawJ2Mtq33
         ozgn1uAQKzNgxG8RD6pVoFrhaaFuUdqr4gPfQRrwxDvVnk6cyup0Ztopw/wCBDTeaCEz
         7Jsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791845854; x=1792450654;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :autocrypt:references:in-reply-to:date:cc:to:from:subject:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=aMcvmUfQuTvPvphd1MGRcussZ+Yz/mLoC8RUhLXVZu0=;
        b=zAaraPDDum2XbQS1TG3eK+T0QUjGrGpHfkqqIyqKwe+rTf5NabcaOwqiFaUgqEO7j2
         QVbSa1sZoBv6ODSA/MlRYDyEUU79S+TCJPf4KQRuehvQnp2hwykQOeD+fe/3gs96WvsA
         9atwp/KbW7YvjGYWBG3ot19MuH8FRuN31/sbFxcXQfywW+Xw5ZasFqbwmOwVR4qR2AEH
         t9R67hPDJiBVs9/sl4LQDFxjL4+5zMkM+8NJhg83yjcKgVUB2nFMJwlJ15Xo/N+OF9P3
         Z2x0jzsJI2DDGBC7PmVLlplHdbEfLRjRk2HZq+uMhi8BYhFEykbnNZFDDbkCCUP7BmlB
         VuBg==
X-Gm-Message-State: AFq9FYLR8aDrr0BQBxZg911bMSUEnEszZ85Gaj/I8bBW+wb4/ol/brzg
	nQn9uYxox4p56BSj1L1kEl5n4y3A/wZ+Whaoq3dXmT3EEPDjeafrwUIXOgRJotdIkOk=
X-Gm-Gg: AYBFou17/Ei3MR4uWKJ7UJ4uSEoJ5sRdfaXp5ZH7f+33ITirHJrQEd9G3XvOYvQAvpD
	LcrygtKFxataAtMuUtS3MulcmfCSlJ8W2gaQwpapu64Z2PwGCrBCy/P1SK4lZWtDg66RGc2T2FI
	mdzQ59Id9yO4IJ580IipVN4W5Vq1ZTH3jsLoYmpvoHORxKMENi2Us2XTenUkMiYOTduraWsD+XZ
	AaDmFY0RRQfv/G2orAxhOSoGA4hNUGus7R4PPFSC+w+JBF5l5hqAb37JCJVvSYb4ef7Oo37r5y1
	gCg5WcZqLeb3vQ/EinGyKr59qgMzYZ9vlcbEICWQQK/hxCH2VNjLQFvJ2x9HGdOVgTCgBp7EwbM
	59JyP7KXxHtpBSQ7vq8gA8BX32zKWme3A3kD543A9qeAeQ6NFVN7kyIInKeMYiflMP8jlo5yUpg
	f1TNJdJOZewMZQ2nmkIgQdaNkQnSoZc0IeYIxBqefc9BzuWvONQBdspJeTx3w/z6Mx2Nk1kCvhI
	r3JifzFZM6KR+V1Z3HTp2Seb324RZeDjxqxb0lkftFxFRODdx4PI3b7G61qQcyLjGyljA7hXxg5
	6qFNUrWiRns04WfWasntKPpATFvLg3Dq3Q==
X-Received: by 2002:a05:690e:e8b:b0:675:33c4:52be with SMTP id 956f58d0204a3-679360696eamr3300107d50.80.1791845853844;
        Mon, 12 Oct 2026 15:57:33 -0700 (PDT)
Received: from ?IPv6:2600:1700:6476:1430::48? ([2600:1700:6476:1430::48])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-8b0ac533a46sm9216647b3.16.2026.10.12.15.57.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Oct 2026 15:57:32 -0700 (PDT)
Message-ID: <f6ed5d59ab7d0137982e1ea4e7facc48d07d458b.camel@dubeyko.com>
Subject: Re: [Jfs-discussion] [PATCH RFC 09/28] hfs: don't set SB_RDONLY
 after MDB write errors
From: Viacheslav Dubeyko <slava@dubeyko.com>
To: Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.com>
Cc: linux-xfs@vger.kernel.org, jfs-discussion@lists.sourceforge.net, 
	linux-nilfs@vger.kernel.org, ntfs@lists.linux.dev,
 ocfs2-devel@lists.linux.dev, 	ecryptfs@vger.kernel.org,
 stable@vger.kernel.org, gfs2@lists.linux.dev, 	exfat@lists.linux.dev,
 linux-efi@vger.kernel.org, linux-mtd@lists.infradead.org,  Al Viro
 <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org,
 linux-ext4@vger.kernel.org, 	linux-btrfs@vger.kernel.org
Date: Mon, 12 Oct 2026 15:57:29 -0700
In-Reply-To: <20261012-work-fs-sb_rdonly-v1-9-60743a3dc326@kernel.org>
References: <20261012-work-fs-sb_rdonly-v1-0-60743a3dc326@kernel.org>
	 <20261012-work-fs-sb_rdonly-v1-9-60743a3dc326@kernel.org>
Autocrypt: addr=slava@dubeyko.com; prefer-encrypt=mutual;
 keydata=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
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.60.1 (by Flathub.org) 
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Mon, 2026-10-12 at 12:20 +0200, Christian Brauner via Jfs-discussion
wrote:
> Since commit fdbb95ff89b2 ("hfs: don't re-dirty MDB buffers after a
> write failure") hfs_mdb_commit() sets SB_RDONLY when the MDB or the
> alternate MDB buffer lost BH_Uptodate after a failed write.
> hfs_mdb_commit() runs from the flush_mdb work without holding
> sb->s_umount and from ->sync_fs(), e.g. for sync(2) which only holds
> s_umount shared. Neither may change SB_RDONLY.
>=20
> freeze_super() decides from sb_rdonly() whether to take the s_writers
> rwsems and then drops s_umount while it waits for writers in
> sb_wait_write(SB_FREEZE_WRITE). A sync(2) in that window gets to
> hfs_mdb_commit() which flips SB_RDONLY. sync_filesystem() in
> freeze_super() then returns early for the now read-only superblock,
> the
> freeze completes with all three rwsems held and thaw_super() sees
> sb_rdonly() and skips sb_freeze_unlock(). So the rwsems stay
> write-locked on a superblock that is marked unfrozen. The commit from
> sync(2) reports:
>=20
> =C2=A0 hfs: primary MDB is corrupt, mounting read-only
>=20
> and after the thaw writers block forever and umount warns:
>=20
> =C2=A0 INFO: task s3_fsop:162 blocked for more than 30 seconds.
> =C2=A0 WARNING: kernel/rcu/sync.c:177 at rcu_sync_dtor+0x143/0x190
>=20
> hfs has no ->freeze_fs() so this needs bdev_freeze(), e.g. through a
> device mapper suspend with lockfs.
>=20
> Follow what ext4 did in commit d3476f3dad4a ("ext4: don't set
> SB_RDONLY
> after filesystem errors") and record the condition in a new
> HFS_FLG_EMERGENCY_RO bit next to the MDB and bitmap dirty bits
> instead.
> The bit is never cleared. The messages and the -EIO from the call
> that
> detects the problem stay as they are. Later calls to hfs_mdb_commit()
> return 0 early exactly like they did for sb_rdonly(), so syncs and
> freezes keep working after the error. And the MDB is never marked
> cleanly unmounted after the error.
>=20
> hfs now refuses modifications with -EROFS itself. That's the
> namespace
> operations, setattr, the hfs.type and hfs.creator xattrs, opening for
> write, write_begin, O_DIRECT writes and block allocation for files in
> hfs_get_block(). hfs_file_truncate() returns early too. It runs from
> ->release() on the last close and frees preallocated blocks without
> any
> freeze protection.
>=20
> Note that b-tree growth through hfs_bmap_reserve() isn't refused. A
> read
> that needs another extent record first writes back the cached one. If
> that record was created before the error inserting it can need a new
> b-tree node and refusing that would make such reads fail with -EIO
> until
> umount.
>=20
> hfs_write_inode() refuses to write inodes back as well. Writeback
> clears
> the dirty state of an inode before it calls ->write_inode() and
> doesn't
> redirty it when that fails. So fsync() would happily report success
> for
> an inode that never made it to disk. Let fsync() fail with -EROFS
> instead. Like on ext4 an operation that completed shortly before the
> error can end up half-applied on disk and needs fsck.hfs.
>=20
> Only the headers of the extents and catalog b-trees are still
> written.
> Writeback writes the b-tree nodes anyway and a node that gets
> allocated
> after the error, e.g. by a read that writes back a cached extent
> record, needs a header that knows about it. Otherwise the next mount
> starts from a stale root and misses records.
>=20
> A remount to read-write fails with -EROFS until umount and a remount
> to
> read-only is allowed. Like ext4 we show "emergency_ro" in the mount
> options. The mount stays "rw" and writes through file descriptors
> opened
> before the error now fail with -EROFS.
>=20
> Reproducer. The writer parked in sb_start_write() keeps
> freeze_super()
> in sb_wait_write() with s_umount dropped while sync(2) runs:
>=20
> =C2=A0 hformat /dev/vdb; N=3D$(blockdev --getsz /dev/vdb)
> =C2=A0 dmsetup create h0 --table "0 $N linear /dev/vdb 0"
> =C2=A0 mount -t hfs /dev/mapper/h0 /mnt; echo a > /mnt/f; sync
> =C2=A0 printf '0 2 linear /dev/vdb 0\n2 1 error\n3 %d linear /dev/vdb 3\n=
'
> $((N-3)) |
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 dmsetup load h0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 # fai=
l writes to the MDB sector
> =C2=A0 dmsetup suspend --nolockfs h0; dmsetup resume h0
> =C2=A0 echo b > /mnt/h; sleep 6=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 # flush_mdb: MDB write fails,
> mdb_bh !uptodate
> =C2=A0 sync /mnt/f=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 # =
fsync(): consumes the bdev
> mapping's AS_EIO
> =C2=A0 <writer: splice() from an empty pipe into /mnt/f>=C2=A0=C2=A0 # pa=
rked in
> sb_start_write()
> =C2=A0 dmsetup suspend h0 &=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 # freeze_super() waits for the
> writer
> =C2=A0 sync=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 # hfs_mdb_commit(): "primary MDB
> is corrupt" -> SB_RDONLY
> =C2=A0 <feed the pipe>=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 # freeze completes,
> sync_filesystem() skipped
> =C2=A0 dmsetup resume h0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 # thaw_super() skips
> sb_freeze_unlock()
> =C2=A0 touch /mnt/x=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 # hangs =
in sb_start_write()
>=20
> Fixes: fdbb95ff89b2 ("hfs: don't re-dirty MDB buffers after a write
> failure")
> Cc: stable@vger.kernel.org
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
> ---
> =C2=A0fs/hfs/attr.c=C2=A0=C2=A0 |=C2=A0 3 +++
> =C2=A0fs/hfs/dir.c=C2=A0=C2=A0=C2=A0 | 12 ++++++++++++
> =C2=A0fs/hfs/extent.c |=C2=A0 5 +++++
> =C2=A0fs/hfs/hfs_fs.h | 11 +++++++++++
> =C2=A0fs/hfs/inode.c=C2=A0 | 30 ++++++++++++++++++++++++++++++
> =C2=A0fs/hfs/mdb.c=C2=A0=C2=A0=C2=A0 | 18 ++++++++++++------
> =C2=A0fs/hfs/super.c=C2=A0 |=C2=A0 7 ++++++-
> =C2=A07 files changed, 79 insertions(+), 7 deletions(-)
>=20
> diff --git a/fs/hfs/attr.c b/fs/hfs/attr.c
> index f8395cdd1adf..d7f8353322c8 100644
> --- a/fs/hfs/attr.c
> +++ b/fs/hfs/attr.c
> @@ -129,6 +129,9 @@ static int hfs_xattr_set(const struct
> xattr_handler *handler,
> =C2=A0	if (!value)
> =C2=A0		return -EOPNOTSUPP;
> =C2=A0
> +	if (unlikely(hfs_emergency_ro(inode->i_sb)))
> +		return -EROFS;
> +
> =C2=A0	return __hfs_setxattr(inode, handler->flags, value, size,
> flags);
> =C2=A0}
> =C2=A0
> diff --git a/fs/hfs/dir.c b/fs/hfs/dir.c
> index e1f1fb351464..e7ed6e829b77 100644
> --- a/fs/hfs/dir.c
> +++ b/fs/hfs/dir.c
> @@ -189,6 +189,9 @@ static int hfs_create(struct mnt_idmap *idmap,
> struct inode *dir,
> =C2=A0	struct inode *inode;
> =C2=A0	int res;
> =C2=A0
> +	if (unlikely(hfs_emergency_ro(dir->i_sb)))
> +		return -EROFS;
> +
> =C2=A0	inode =3D hfs_new_inode(dir, &dentry->d_name, mode);
> =C2=A0	if (IS_ERR(inode))
> =C2=A0		return PTR_ERR(inode);
> @@ -219,6 +222,9 @@ static struct dentry *hfs_mkdir(struct mnt_idmap
> *idmap, struct inode *dir,
> =C2=A0	struct inode *inode;
> =C2=A0	int res;
> =C2=A0
> +	if (unlikely(hfs_emergency_ro(dir->i_sb)))
> +		return ERR_PTR(-EROFS);
> +
> =C2=A0	inode =3D hfs_new_inode(dir, &dentry->d_name, mode);
> =C2=A0	if (IS_ERR(inode))
> =C2=A0		return ERR_CAST(inode);
> @@ -252,6 +258,9 @@ static int hfs_remove(struct inode *dir, struct
> dentry *dentry)
> =C2=A0	struct inode *inode =3D d_inode(dentry);
> =C2=A0	int res;
> =C2=A0
> +	if (unlikely(hfs_emergency_ro(sb)))
> +		return -EROFS;
> +
> =C2=A0	if (S_ISDIR(inode->i_mode) && inode->i_size !=3D 2)
> =C2=A0		return -ENOTEMPTY;
> =C2=A0
> @@ -290,6 +299,9 @@ static int hfs_rename(struct mnt_idmap *idmap,
> struct inode *old_dir,
> =C2=A0	if (flags & ~RENAME_NOREPLACE)
> =C2=A0		return -EINVAL;
> =C2=A0
> +	if (unlikely(hfs_emergency_ro(old_dir->i_sb)))
> +		return -EROFS;
> +
> =C2=A0	/* Unlink destination if it already exists */
> =C2=A0	if (d_really_is_positive(new_dentry)) {
> =C2=A0		res =3D hfs_remove(new_dir, new_dentry);
> diff --git a/fs/hfs/extent.c b/fs/hfs/extent.c
> index f066a99a863b..dab31f159b1a 100644
> --- a/fs/hfs/extent.c
> +++ b/fs/hfs/extent.c
> @@ -350,6 +350,9 @@ int hfs_get_block(struct inode *inode, sector_t
> block,
> =C2=A0		if (block > HFS_I(inode)->fs_blocks)
> =C2=A0			return -EIO;
> =C2=A0		if (ablock >=3D HFS_I(inode)->alloc_blocks) {
> +			/* No new allocations after an error. */
> +			if (unlikely(hfs_emergency_ro(sb)))
> +				return -EROFS;
> =C2=A0			res =3D hfs_extend_file(inode);
> =C2=A0			if (res)
> =C2=A0				return res;
> @@ -485,6 +488,8 @@ void hfs_file_truncate(struct inode *inode)
> =C2=A0	hfs_dbg("ino %llu, phys_size %llu -> i_size %llu\n",
> =C2=A0		inode->i_ino, (long long)HFS_I(inode)->phys_size,
> =C2=A0		inode->i_size);
> +	if (unlikely(hfs_emergency_ro(sb)))
> +		return;
> =C2=A0	if (inode->i_size > HFS_I(inode)->phys_size) {
> =C2=A0		struct address_space *mapping =3D inode->i_mapping;
> =C2=A0		void *fsdata =3D NULL;
> diff --git a/fs/hfs/hfs_fs.h b/fs/hfs/hfs_fs.h
> index e250f87a5e33..71ab81b649bc 100644
> --- a/fs/hfs/hfs_fs.h
> +++ b/fs/hfs/hfs_fs.h
> @@ -143,6 +143,7 @@ struct hfs_sb_info {
> =C2=A0#define HFS_FLG_BITMAP_DIRTY	0
> =C2=A0#define HFS_FLG_MDB_DIRTY	1
> =C2=A0#define HFS_FLG_ALT_MDB_DIRTY	2
> +#define HFS_FLG_EMERGENCY_RO	3	/* read-only after an MDB
> write error */
> =C2=A0
> =C2=A0/* bitmap.c */
> =C2=A0extern u32 hfs_vbm_search_free(struct super_block *sb, u32 goal, u3=
2
> *num_bits);
> @@ -293,6 +294,16 @@ static inline const char *hfs_mdb_name(struct
> super_block *sb)
> =C2=A0	return sb->s_id;
> =C2=A0}
> =C2=A0
> +/*
> + * Writing back the MDB failed and the filesystem stopped all
> modifications
> + * until unmount. SB_RDONLY isn't used for that because it must not
> change
> + * without s_umount.
> + */
> +static inline bool hfs_emergency_ro(struct super_block *sb)
> +{
> +	return test_bit(HFS_FLG_EMERGENCY_RO, &HFS_SB(sb)->flags);
> +}
> +
> =C2=A0static inline void hfs_bitmap_dirty(struct super_block *sb)
> =C2=A0{
> =C2=A0	set_bit(HFS_FLG_BITMAP_DIRTY, &HFS_SB(sb)->flags);
> diff --git a/fs/hfs/inode.c b/fs/hfs/inode.c
> index 2aef3c36a150..42a2c2e390b2 100644
> --- a/fs/hfs/inode.c
> +++ b/fs/hfs/inode.c
> @@ -54,6 +54,9 @@ int hfs_write_begin(const struct kiocb *iocb,
> struct address_space *mapping,
> =C2=A0	loff_t total_capacity;
> =C2=A0	int ret;
> =C2=A0
> +	if (unlikely(hfs_emergency_ro(inode->i_sb)))
> +		return -EROFS;
> +
> =C2=A0	total_capacity =3D (loff_t)sbi->fs_ablocks * sbi->alloc_blksz;
> =C2=A0
> =C2=A0	if (pos >=3D total_capacity)
> @@ -139,6 +142,10 @@ static ssize_t hfs_direct_IO(struct kiocb *iocb,
> struct iov_iter *iter)
> =C2=A0	size_t count =3D iov_iter_count(iter);
> =C2=A0	ssize_t ret;
> =C2=A0
> +	if (iov_iter_rw(iter) =3D=3D WRITE &&
> +	=C2=A0=C2=A0=C2=A0 unlikely(hfs_emergency_ro(inode->i_sb)))
> +		return -EROFS;
> +
> =C2=A0	ret =3D blockdev_direct_IO(iocb, inode, iter, hfs_get_block);
> =C2=A0
> =C2=A0	/*
> @@ -472,6 +479,20 @@ int hfs_write_inode(struct inode *inode, struct
> writeback_control *wbc)
> =C2=A0	int res;
> =C2=A0
> =C2=A0	hfs_dbg("ino %llu\n", inode->i_ino);
> +	if (unlikely(hfs_emergency_ro(inode->i_sb))) {
> +		/*
> +		 * Writeback still writes the b-tree nodes. Keep the
> headers in
> +		 * sync with them so the trees on disk stay intact.
> +		 */
> +		if (inode->i_ino =3D=3D HFS_EXT_CNID)
> +			hfs_btree_write(HFS_SB(inode->i_sb)-
> >ext_tree);
> +		else if (inode->i_ino =3D=3D HFS_CAT_CNID)
> +			hfs_btree_write(HFS_SB(inode->i_sb)-
> >cat_tree);
> +		else
> +			return -EROFS;
> +		return 0;
> +	}
> +
> =C2=A0	res =3D hfs_ext_write_extent(inode);
> =C2=A0	if (res)
> =C2=A0		return res;
> @@ -619,6 +640,8 @@ void hfs_evict_inode(struct inode *inode)
> =C2=A0
> =C2=A0static int hfs_file_open(struct inode *inode, struct file *file)
> =C2=A0{
> +	if ((file->f_mode & FMODE_WRITE) && hfs_emergency_ro(inode-
> >i_sb))
> +		return -EROFS;
> =C2=A0	if (HFS_IS_RSRC(inode))
> =C2=A0		inode =3D HFS_I(inode)->rsrc_inode;
> =C2=A0	atomic_inc(&HFS_I(inode)->opencnt);
> @@ -650,6 +673,9 @@ int hfs_inode_setattr(struct mnt_idmap *idmap,
> struct dentry *dentry,
> =C2=A0	struct hfs_sb_info *hsb =3D HFS_SB(inode->i_sb);
> =C2=A0	int error;
> =C2=A0
> +	if (unlikely(hfs_emergency_ro(inode->i_sb)))
> +		return -EROFS;
> +
> =C2=A0	error =3D setattr_prepare(&nop_mnt_idmap, dentry, attr);
> =C2=A0	if (error)
> =C2=A0		return error;
> @@ -701,6 +727,10 @@ static int hfs_file_fsync(struct file *filp,
> loff_t start, loff_t end,
> =C2=A0	struct super_block * sb;
> =C2=A0	int ret, err;
> =C2=A0
> +	/* Inodes aren't written back after an error. */
> +	if (unlikely(hfs_emergency_ro(inode->i_sb)))
> +		return -EROFS;
> +
> =C2=A0	ret =3D file_write_and_wait_range(filp, start, end);
> =C2=A0	if (ret)
> =C2=A0		return ret;
> diff --git a/fs/hfs/mdb.c b/fs/hfs/mdb.c
> index 277de712f9d4..ce20824bbdc8 100644
> --- a/fs/hfs/mdb.c
> +++ b/fs/hfs/mdb.c
> @@ -322,8 +322,8 @@ int hfs_mdb_get(struct super_block *sb)
> =C2=A0 *=C2=A0=C2=A0 NONE
> =C2=A0 * Returns:
> =C2=A0 *=C2=A0=C2=A0 0 on success, -EIO if the MDB or alternate MDB buffe=
r is no
> longer
> - *=C2=A0=C2=A0 valid (e.g. after a prior write error), in which case the
> volume is
> - *=C2=A0=C2=A0 remounted read-only.
> + *=C2=A0=C2=A0 valid (e.g. after a prior write error), in which case the
> volume
> + *=C2=A0=C2=A0 refuses all further modifications until it is unmounted.
> =C2=A0 * Preconditions:
> =C2=A0 *=C2=A0=C2=A0 'mdb' points to a "valid" (struct hfs_mdb).
> =C2=A0 * Postconditions:
> @@ -338,12 +338,18 @@ int hfs_mdb_commit(struct super_block *sb)
> =C2=A0	struct hfs_mdb *mdb =3D HFS_SB(sb)->mdb;
> =C2=A0	int ret =3D 0;
> =C2=A0
> -	if (sb_rdonly(sb))
> +	if (sb_rdonly(sb) || hfs_emergency_ro(sb))
> =C2=A0		return 0;
> =C2=A0
> +	/*
> +	 * Don't set SB_RDONLY on errors: changing it requires
> s_umount and a
> +	 * remount. Setting it on a frozen superblock makes
> thaw_super() mark
> +	 * it unfrozen but skip sb_freeze_unlock(), so the s_writers
> rwsems
> +	 * stay write-locked and every writer hangs.
> +	 */
> =C2=A0	if (!buffer_uptodate(HFS_SB(sb)->mdb_bh)) {
> =C2=A0		pr_err("primary MDB is corrupt, mounting read-
> only\n");
> -		sb->s_flags |=3D SB_RDONLY;
> +		set_bit(HFS_FLG_EMERGENCY_RO, &HFS_SB(sb)->flags);
> =C2=A0		return -EIO;
> =C2=A0	}
> =C2=A0
> @@ -377,7 +383,7 @@ int hfs_mdb_commit(struct super_block *sb)
> =C2=A0	=C2=A0=C2=A0=C2=A0 HFS_SB(sb)->alt_mdb) {
> =C2=A0		if (!buffer_uptodate(HFS_SB(sb)->alt_mdb_bh)) {
> =C2=A0			pr_err("alternate MDB is corrupt, mounting
> read-only\n");
> -			sb->s_flags |=3D SB_RDONLY;
> +			set_bit(HFS_FLG_EMERGENCY_RO, &HFS_SB(sb)-
> >flags);
> =C2=A0			ret =3D -EIO;
> =C2=A0			goto out;
> =C2=A0		}
> @@ -428,7 +434,7 @@ int hfs_mdb_commit(struct super_block *sb)
> =C2=A0void hfs_mdb_close(struct super_block *sb)
> =C2=A0{
> =C2=A0	/* update volume attributes */
> -	if (sb_rdonly(sb))
> +	if (sb_rdonly(sb) || hfs_emergency_ro(sb))
> =C2=A0		return;
> =C2=A0
> =C2=A0	if (!buffer_uptodate(HFS_SB(sb)->mdb_bh))
> diff --git a/fs/hfs/super.c b/fs/hfs/super.c
> index 5e6d66ff4bee..0f2c5ab0caf7 100644
> --- a/fs/hfs/super.c
> +++ b/fs/hfs/super.c
> @@ -82,7 +82,7 @@ void hfs_mark_mdb_dirty(struct super_block *sb)
> =C2=A0	struct hfs_sb_info *sbi =3D HFS_SB(sb);
> =C2=A0	unsigned long delay;
> =C2=A0
> -	if (sb_rdonly(sb))
> +	if (sb_rdonly(sb) || hfs_emergency_ro(sb))
> =C2=A0		return;
> =C2=A0
> =C2=A0	spin_lock(&sbi->work_lock);
> @@ -131,6 +131,9 @@ static int hfs_reconfigure(struct fs_context *fc)
> =C2=A0		return 0;
> =C2=A0
> =C2=A0	if (!(fc->sb_flags & SB_RDONLY)) {
> +		/* After an MDB write error it stays read-only until
> unmount. */
> +		if (hfs_emergency_ro(sb))
> +			return -EROFS;
> =C2=A0		if (!(HFS_SB(sb)->mdb->drAtrb &
> cpu_to_be16(HFS_SB_ATTRIB_UNMNT))) {
> =C2=A0			pr_warn("filesystem was not cleanly
> unmounted, running fsck.hfs is recommended.=C2=A0 leaving read-only.\n");
> =C2=A0			sb->s_flags |=3D SB_RDONLY;
> @@ -169,6 +172,8 @@ static int hfs_show_options(struct seq_file *seq,
> struct dentry *root)
> =C2=A0		seq_printf(seq, ",iocharset=3D%s", sbi->nls_io-
> >charset);
> =C2=A0	if (sbi->s_quiet)
> =C2=A0		seq_printf(seq, ",quiet");
> +	if (hfs_emergency_ro(root->d_sb))
> +		seq_puts(seq, ",emergency_ro");
> =C2=A0	return 0;
> =C2=A0}
> =C2=A0

Looks good.

Reviewed-by: Viacheslav Dubeyko <slava@dubeyko.com>

Thanks,
Slava.
