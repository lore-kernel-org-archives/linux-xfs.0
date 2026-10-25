Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=113.46.200.218
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792920226;
	b=IDTU/l5xLceD46djcb0ujjwGfmJrYlyyAu2y7pYPW+9nuAcefmKkf2C2ZYmUys93t+1W
	 LtdbKwZsk620m9NeYl7YP8Z1KWj9wEZjQiEwtUHn5JJ8D8oSNhnHsLH8+ifo8xANYNJ4V
	 NpcncJWHngS5P3OLzjgWlXU2BLnWPfbjGlqR7jh07nBpxpAs+mCpTYEiSsWSCm+EBeYgh
	 Y45vwpR29lCHkvmg6Ei0CfSEpGlGVu8w2TvleJKQPW1KS/24NJm9sCwkEHoBExwZZFX2F
	 LAsdm2TPH7YCx/+iJV4hliZQvTPKvCfJuMW4ST1sG4AHA/XVsfeqUFlJz+Zz5/krm9A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792920226;
	h=DMARC-Filter:dkim-signature:Received:Received:Received:Received:From:
	 To:CC:Subject:Thread-Topic:Thread-Index:Date:Message-ID:
	 Accept-Language:Content-Language:X-MS-Has-Attach:X-MS-TNEF-Correlator:
	 x-originating-ip:Content-Type:Content-Transfer-Encoding:MIME-Version;
	bh=IqKI4LM6XVwEFw5OcR4MCKFBHEzsLZL8E7gqK3/pUrI=;
	b=kmyf63LXoMcD7aDGvInhZSS8jif9M4dPJ+SNcvXOuhSJGPoWoPWBttWGj9Rr+iXjynKc
	 3ECCgBtkHwOsavwFNJM43EAKI+bdeYTINn/slzmdO4qiIxCwU295C0jNUPeqybs9zteM/
	 WO51gnDEi2f9PEZzk27QisUIHx9xgXnGs1unGnK4THzYGlzuhyw4U8YiqXTfTEA97WV2h
	 NzPm8T7xtIAtwYSpAh8wTOI5wPiTUTzgTotWJyGOd0AVlWvwKM6IrcYIO1JhSEDeQ944a
	 FkyyoYwhXWfEnDf6+SLKRKGpkaEHpmYLi/+HusYSNLFwD5uLo0JckzGDIhEpgtbe7ig==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=huawei.com;
	spf=pass smtp.mailfrom=huawei.com;
	dkim=pass header.d=huawei.com header.i=@huawei.com header.a=rsa-sha256 header.s=dkim header.b=hf9PQs5u;
	arc=none smtp.remote-ip=113.46.200.218
Received: from canpmsgout03.his.huawei.com (canpmsgout03.his.huawei.com [113.46.200.218])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5342606A31A;
	Sun, 25 Oct 2026 09:23:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E5342606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=huawei.com header.i=@huawei.com header.a=rsa-sha256 header.s=dkim header.b=hf9PQs5u
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=IqKI4LM6XVwEFw5OcR4MCKFBHEzsLZL8E7gqK3/pUrI=;
	b=hf9PQs5uTVJI34XIOJvVBBspkD8VpedxsNnj/tsSl+9WWD/04DxV4c8Pf3BUpl5p/NuGLlNPW
	INVQ2g0L2nQ4kKS8cl7etHGk/L3NNimjwDnT/gpUsRgvubyI+nfROBMfrotd0Igl8Fni1ZThBT3
	NXTVF+96M9GsrijX7TN31mI=
Received: from mail.maildlp.com (unknown [172.19.162.144])
	by canpmsgout03.his.huawei.com (SkyGuard) with ESMTPS id 4jCBBk4D47zpSt9;
	Sun, 25 Oct 2026 17:23:26 +0800 (CST)
Received: from kwepemf200008.china.huawei.com (unknown [7.202.181.234])
	by mail.maildlp.com (Postfix) with ESMTPS id C3F2740538;
	Sun, 25 Oct 2026 17:23:33 +0800 (CST)
Received: from kwepemf100015.china.huawei.com (7.202.181.14) by
 kwepemf200008.china.huawei.com (7.202.181.234) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Sun, 25 Oct 2026 17:23:33 +0800
Received: from kwepemf100015.china.huawei.com ([7.202.181.14]) by
 kwepemf100015.china.huawei.com ([7.202.181.14]) with mapi id 15.02.2562.045;
 Sun, 25 Oct 2026 17:23:33 +0800
From: "Liuwenliang (Abbott Liu)" <liuwenliang@huawei.com>
To: "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>, "brauner@kernel.org"
	<brauner@kernel.org>, "jack@suse.cz" <jack@suse.cz>, "pliard@google.com"
	<pliard@google.com>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"phillip@squashfs.org.uk" <phillip@squashfs.org.uk>, "cem@kernel.org"
	<cem@kernel.org>, "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
	"tytso@mit.edu" <tytso@mit.edu>, "adilger.kernel@dilger.ca"
	<adilger.kernel@dilger.ca>, "libaokun@linux.alibaba.com"
	<libaokun@linux.alibaba.com>, "ojaswin@linux.ibm.com"
	<ojaswin@linux.ibm.com>, "ritesh.list@gmail.com" <ritesh.list@gmail.com>,
	"zhangyi (F)" <yi.zhang@huawei.com>
CC: "yangzhuohao (A)" <yangzhuohao1@huawei.com>, douzhaolei
	<douzhaolei@huawei.com>, Wangbing <wangbing6@huawei.com>, Nixiaoming
	<nixiaoming@huawei.com>, liaohua <liaohua4@huawei.com>, "Chenjie (K)"
	<chenjie6@huawei.com>, chengzhihao <chengzhihao1@huawei.com>, heyuqiang
	<heyuqiang1@huawei.com>
Subject: Re: [PATCH] initrd: flush deferred fput() before mounting root
Thread-Topic: [PATCH] initrd: flush deferred fput() before mounting root
Thread-Index: Ad1kX9AjglmBfdg0QUm6eVPEjTE/+g==
Date: Sun, 25 Oct 2026 09:23:33 +0000
Message-ID: <3d64d109188e492da5939ebacc8631f4@huawei.com>
Accept-Language: en-US
Content-Language: zh-CN
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0

On Wed, 30 Sep 2026 16:47 +0800 Abbott Liu <liuwenliang@huawei.com> wrote:
> Booting an old-style initrd, i.e. a bare filesystem image rather than a
> cpio archive, with "root=3D/dev/ram rootfstype=3Dsquashfs" can fail to
> mount the root filesystem and panic:
>=20
>     RAMDISK: squashfs filesystem found at block 0
>     RAMDISK: Loading 68449KiB [1 disk] into ram disk... done.
>     No filesystem could mount root, tried:
>      squashfs
>     Kernel panic - not syncing: VFS: Unable to mount root fs on
>     "/dev/ram" or unknown-block(1,0)
>=20
> The panic requires three conditions to hold simultaneously:
>=20
>  1. The initrd is a filesystem image, so initrd_load() copies it into
>     /dev/ram with rd_load_image() instead of unpacking a cpio archive
>     into rootfs.
>  2. The root filesystem is mounted from that ramdisk and reads it with
>     bios that bypass the block device page cache. Squashfs has done so
>     for every read since commit 93e72b3c612a ("squashfs: migrate from
>     ll_rw_block usage to BIO").
>  3. The ramdisk's block size equals squashfs's device block size:
>     inode->i_blkbits =3D=3D blksize_bits(SQUASHFS_DEVBLK_SIZE).  The firs=
t
>     open of /dev/ram computes i_blkbits in set_init_blocksize() from
>     the queue's logical block size (512 for brd) and the ramdisk size,
>     capped at 12 (blksize_bits(PAGE_SIZE)).  When the ramdisk size is
>     aligned to PAGE_SIZE, inode->i_blkbits =3D blksize_bits(PAGE_SIZE).
>     The ramdisk size comes from CONFIG_BLK_DEV_RAM_SIZE at build time
>     and can be overridden on the kernel command line with ramdisk_size=3D
>     (or the rd_size module parameter when brd is built as a module);
>     all sizes are in kibibytes.
>=20
> When the conditions hold, the boot races as follows:
>=20
>  1. rd_load_image() opens /dev/ram for buffered writing; the first open
>     fixes i_blkbits as described above.
>  2. Its copy loop writes the image with kernel_write(), which leaves
>     all of the data dirty in the block device page cache.  Nothing has
>     reached the ramdisk's backing store yet.
>  3. rd_load_image() then drops the ramdisk file with fput() and no
>     explicit sync.  The final __fput() - and with it blkdev_put() ->
>     blkdev_flush_mapping() -> sync_blockdev(), the writeback that would
>     push the dirty pages into the ramdisk - is asynchronous.  While
>     init was a kernel thread, __fput() ran as delayed fput work at
>     least a jiffy later; since commit 343f4c49f243 ("kthread: Don't
>     allocate kthread_struct for init and umh") init is a user mode
>     task, so __fput() is deferred via task_work and only runs once init
>     returns to user space, i.e. after mount_root().
>  4. prepare_namespace() calls mount_root() right after initrd_load().
>     squashfs_fill_super() starts with
>     sb_min_blocksize(sb, SQUASHFS_DEVBLK_SIZE), which ultimately calls
>     set_blocksize().  That function reconfigures the device only when
>     the requested block size differs from the device's current block
>     size, and it calls sync_blockdev() and kill_bdev() first - a page
>     cache geometry change that incidentally flushes the dirty pages.
>     With both block sizes equal, this incidental rescue is skipped, and
>     the mount path contains no other writeback point.
>  5. squashfs reads the superblock via squashfs_bio_read(), which builds
>     BIOs on its own pages and submits them with submit_bio_wait() -
>     raw I/O that bypasses the block device page cache completely.  brd
>     has no backing page for that range yet and zero-fills the result,
>     so the "hsqs" magic check fails and the mount returns -EINVAL.
>  6. mount_root_generic() calls init_flush_fput() only after the failed
>     mount.  Since rootfstype=3D names a single filesystem type and the
>     root device is read-only by default, no candidate is left to retry
>     with.  It panics.
>=20
> The failure is intermittent because most geometries get the incidental
> sync from step 4: the race only surfaces when both block sizes match.
> Such a geometry arises when CONFIG_SQUASHFS_4K_DEVBLK_SIZE=3Dy.  The
> ramdisk size is normally aligned to PAGE_SIZE, so on the first open of
> /dev/ram the ramdisk block size equals PAGE_SIZE (4K on typical
> systems).  Without CONFIG_SQUASHFS_4K_DEVBLK_SIZE,
> SQUASHFS_DEVBLK_SIZE
> is 1K and differs from the ramdisk block size, so set_blocksize()
> calls sync_blockdev() and kill_bdev() and flushes the dirty pages.
> With CONFIG_SQUASHFS_4K_DEVBLK_SIZE=3Dy, SQUASHFS_DEVBLK_SIZE is 4K
> and
> matches the ramdisk block size, the flush in set_blocksize() is
> skipped, and the mount panics.
>=20
> Several ways to close this window were considered.
>=20
> Fixing the reader, e.g. by syncing in squashfs_fill_super(), addresses
> the wrong end of the race.  Reading a block device with bios that
> bypass the page cache is not a squashfs peculiarity: of the 28
> block-backed filesystems in the tree, 26 do it in at least one read
> stage.  squashfs, xfs, gfs2, zonefs, hfsplus and ntfs read their
> superblock with raw bios; btrfs, f2fs and jfs read their metadata that
> way; and the file data of ext4 and 20 more filesystems is read through
> mpage, iomap or block_read_full_folio into the file's own address
> space instead of the block device cache.  Only romfs and cramfs
> consult bd_mapping at every stage.  A squashfs-only fix would leave
> the same race in place everywhere else, where it usually does not even
> fail loudly - the mount succeeds and file data silently reads back as
> zeros - and repeating a sync in every filesystem would scatter the
> same barrier across the tree.
>=20
> That leaves the producer, rd_load_image(), with two candidates:
>=20
>  1. Call vfs_fsync(out_file, 0) once the copy loop is done.  This
>     pushes the ramdisk's dirty pages into the backing store and waits
>     for them, costs a single batched writeback, and returns an error
>     that can be checked.
>=20
>  2. Keep fput(out_file) and follow it with init_flush_fput(), which
>     drains both deferral mechanisms - the delayed fput work and the
>     task_work - so the final __fput() and its
>     blkdev_put() -> blkdev_flush_mapping() -> sync_blockdev() run to
>     completion before rd_load_image() returns.  The ramdisk then
>     reaches the mount closed, synced and with its page cache dropped,
>     i.e. in the state it would have in without the deferral.
>=20
> Both options complete the writeback before the mount and either one
> fixes the race.  Take the second one, which matches the established
> use of the helper in the boot path: mount_root_generic() already
> calls init_flush_fput() before retrying the mount with another
> filesystem type, and flush_delayed_fput() documents the boot as its
> only user.  Draining the deferred closes here is also well contained,
> as at this point in the boot they all belong to files the boot itself
> created: the ramdisk file just written, the /initrd.image it was
> copied from, and the files unpacked into rootfs.
>=20
> Flush the deferred __fput() right after dropping the last reference to
> the ramdisk file, so the writeback completes before mount_root() runs.
>=20
> Verified on arm64 QEMU with an openEuler Embedded rootfs image packed
> as squashfs: the boot panics as shown above without the fix and boots
> to userspace with it.
>=20
> Fixes: 93e72b3c612a ("squashfs: migrate from ll_rw_block usage to BIO")
> Signed-off-by: Abbott Liu <liuwenliang@huawei.com>
> ---
>  init/do_mounts_rd.c | 11 +++++++++++
>  1 file changed, 11 insertions(+)
>=20
> diff --git a/init/do_mounts_rd.c b/init/do_mounts_rd.c
> index 48bfab2fc62f..24e57f30e167 100644
> --- a/init/do_mounts_rd.c
> +++ b/init/do_mounts_rd.c
> @@ -258,6 +258,17 @@ int __init rd_load_image(void)
>  	fput(in_file);
>  noclose_input:
>  	fput(out_file);
> +	/*
> +	 * The image data is still dirty in the ramdisk's block device page
> +	 * cache and only reaches the ramdisk once the final __fput() of
> +	 * out_file runs blkdev_put() -> blkdev_flush_mapping() ->
> +	 * sync_blockdev().  That __fput() is deferred (delayed fput work,
> +	 * or task_work that runs when init returns to user mode), while
> +	 * mount_root() runs right after this and may read the ramdisk with
> +	 * bios bypassing the page cache (e.g. squashfs).  Flush it now so
> +	 * the ramdisk is up to date before it gets mounted.
> +	 */
> +	init_flush_fput();
>  out:
>  	kfree(buf);
>  	init_unlink("/dev/ram");
> --
> 2.43.0

Hi,
Friendly ping on this patch.=20

Please let me know if there is anything inappropriate in the patch
or if it is ready to be applied to the tree.

Best regards,
Abbott Liu
