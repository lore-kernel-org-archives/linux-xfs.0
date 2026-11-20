Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=198.137.202.133
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795192220;
	b=XTXGMFwrfxABlHew5HCoqBmbdxSfDvNRfvJ+0BuVSefArs7Ay5bPP1A4YzSEM+Jq9Lm3
	 ovJgped1gFGKzbIUHLMgOs/sJMKmy3VkwGa/G3fxZw4DMZfWlFbBB5Wyc5dImDdwcl0fz
	 KxhoJjJynyEj238bwidAXaYHQp97doE93yqiH+X5DZixx0Ftu+/jzjamhwR8aSPLblmGB
	 hsvha6+IUzSrshlO8EpbkOPI4/QDABlwXsmwM2Re9uDtSqtFprpFtCutTC1pW23SletIK
	 y+9PV4MS0A3FeT3S2DUhxW5FXDnD+MR/3/s3PY5JbHEr9RNw8HBHxtOuyyPvUOFyDVA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795192220;
	h=DMARC-Filter:DKIM-Signature:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 Content-Transfer-Encoding:In-Reply-To:X-SRS-Rewrite;
	bh=DLn/nRLdH7tnntHWkgxOvyOlyiVy+UUcBurM4sXK35M=;
	b=1180pKBM8FypxRXNqoNmQGpNX88VAZpzS2h4aIpEG9ZAxwCVTinPdohujWTlNJdXlIS4
	 0yg0deR1yZ3RNiYB0IAvHA7R6oCg2BK9HrarAHIwH8vUGJeG/6GKqriOJbRVJeujXg9/5
	 cWfbKlTfP2iinYTKKQEJaj8IUF5nrnuDcbRfN71VKv3MVyyvn+tKhoTOX3NuzLbwc5lVK
	 K74B0ibXOSlMp+t3U+TuCseRmd9pNrKBFwJbzDCgAcIcDPIJarfFzhl8KBEW+JNqrwiZZ
	 Q0lWQCS/PLASaFTaihpt285VwXekBV9XAm04J6v3lO+psyX/baELuWNqmUHup8B5OHQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=infradead.org;
	spf=none smtp.mailfrom=bombadil.srs.infradead.org;
	dkim=pass header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=erFWOLMK;
	arc=none smtp.remote-ip=198.137.202.133
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 783DF606A33D;
	Fri, 20 Nov 2026 16:30:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 783DF606A33D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=erFWOLMK
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Transfer-Encoding
	:Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
	Sender:Reply-To:Content-ID:Content-Description;
	bh=DLn/nRLdH7tnntHWkgxOvyOlyiVy+UUcBurM4sXK35M=; b=erFWOLMKbsbc1kXKJ1RIFYCDBK
	xKZf864qLcHPkgt9GIvjmgLCXHSrZ3+7YeFM9od+hFegwD2cx8w3WIDerJ1d3axhHd5fvkzhgnLpe
	smvc1g/thqACMdSO6TzuI6aDZZheGvNBzg8sQAlUYm0h/wJ7ZZ2QHxk8q+x6fgqZQe+jk/VKfAzkX
	rpipoMBqyenJQ9wiLlAOebVQcVkcX35hRu7W+R0gGyNU44uVTyG8+bnpMqN7OyVLGGztewE+PHLqs
	OUJj6l3e+oaMXHJxF+cnez+HxrdGduXzgYGHKGrbrB+J6WtSZzwM747MCukVqWCnFVtox8D3S5erV
	J4Uwh7KA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xURVC-0000000FYuK-3p0t;
	Fri, 20 Nov 2026 16:30:18 +0000
Date: Fri, 20 Nov 2026 08:30:18 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Kyuwon Cho <kyuwoncho18@gmail.com>
Cc: Carlos Maiolino <cem@kernel.org>, "Darrick J. Wong" <djwong@kernel.org>,
	Aldo Ariel Panzardo <qwe.aldo@gmail.com>, linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [BUG] xfs: a remote xattr valuelen larger than its blocks makes
 getxattr() read a hole and warn
Message-ID: <awB1mmg22PhD_efC@infradead.org>
References: <179505710272.3511680.12978324583605871086@gmail.com>
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <179505710272.3511680.12978324583605871086@gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Not going to complain about a fix if you send it, but the usual PSA
applies:  іnjecting malicious changes to the on-disk format (and
regenerating the CRC) is not part of the threat model for XFS.

On Wed, Nov 18, 2026 at 07:04:53PM -0800, Kyuwon Cho wrote:
> Hi Carlos, Darrick,
> 
> While testing v7.4-rc3 with an LLM-guided test generator that we are
> developing as a research prototype, we found that a remote xattr whose
> on-disk valuelen is larger than the blocks the value owns makes
> getxattr() read a hole, which ends in the WARN_ON() of
> xfs_buf_map_verify():
> 
>   XFS (loop0): xfs_buf_map_verify: daddr 0x258000001a7f0 out of range, EOFS 0x96000
>   WARNING: fs/xfs/xfs_buf.c:423 at xfs_find_get_buf+0x160f/0x2350, CPU#1: test/114
>   CPU: 1 UID: 0 PID: 114 Comm: test Not tainted 7.4.0-rc3 #1 PREEMPT(lazy)
>   RIP: 0010:xfs_find_get_buf (fs/xfs/xfs_buf.c:423 fs/xfs/xfs_buf.c:567)
>   Call Trace:
>    <TASK>
>    xfs_buf_read_map (fs/xfs/xfs_buf.c:648)
>    xfs_attr_rmtval_get (fs/xfs/xfs_buf.h:243 fs/xfs/libxfs/xfs_attr_remote.c:434)
>    xfs_attr3_leaf_getvalue (fs/xfs/libxfs/xfs_attr_leaf.c:2718)
>    xfs_attr_node_get (fs/xfs/libxfs/xfs_attr.c:1597)
>    xfs_attr_get (fs/xfs/libxfs/xfs_attr.c:287)
>    xfs_xattr_get (fs/xfs/xfs_xattr.c:150)
>    __vfs_getxattr (fs/xattr.c:446)
>    vfs_getxattr (fs/xattr.c:479)
>    do_getxattr (fs/xattr.c:808)
>    filename_getxattr (fs/xattr.c:837)
>    path_getxattrat (fs/xattr.c:876)
>    do_syscall_64 (arch/x86/entry/syscall_64.c:61 arch/x86/entry/syscall_64.c:89)
>    entry_SYSCALL_64_after_hwframe (arch/x86/entry/entry_64.S:121)
>    </TASK>
> 
> 15ccd92a782a ("xfs: reject remote xattr entries with an out-of-range
> value length") makes the leaf verifier reject a remote valuelen above
> XFS_XATTR_SIZE_MAX, but a valuelen up to that limit is not checked
> against the value's blocks. xfs_attr3_leaf_getvalue() computes
> rmtblkcnt from the on-disk valuelen, and xfs_attr_rmtval_get() maps
> that many blocks of the attr fork. It only asserts that a mapping is
> not a hole:
> 
> 		for (i = 0; (i < nmap) && (valuelen > 0); i++) {
> 			...
> 			ASSERT((map[i].br_startblock != DELAYSTARTBLOCK) &&
> 			       (map[i].br_startblock != HOLESTARTBLOCK));
> 			dblkno = XFS_FSB_TO_DADDR(mp, map[i].br_startblock);
> 			...
> 			error = xfs_buf_read(mp->m_ddev_targp, dblkno, dblkcnt,
> 					0, &bp, &xfs_attr3_rmt_buf_ops);
> 
> Without CONFIG_XFS_DEBUG, a hole becomes the out-of-range daddr above.
> xfs_attr_rmtval_stale() in the same file checks for a hole at run time
> and returns -EFSCORRUPTED.
> 
> The reproducer runs as root on an empty XFS image (mkfs.xfs, 300 MiB,
> default v5 features). It gives a file a 16160-byte user.big xattr (four
> remote blocks), unmounts, rewrites the entry's valuelen in the attr
> leaf block to 65536 and fixes the block's CRC, mounts again, and calls
> getxattr() with a 65536-byte buffer. On an x86_64 QEMU guest with 2
> vCPUs and KASAN (gcc 13.3), it warns every time, and getxattr() fails.
> 
> Checked against v7.4-rc3 (aebb72744764); xfs_attr_remote.c and
> xfs_attr_leaf.c are the same in the xfs for-next branch.
> 
> A patch is attached (git format-patch against v7.4-rc3; it applies to
> the xfs for-next branch):
> 
>   0001-xfs-reject-a-hole-in-a-remote-xattr-value.patch
> 
> It replaces the ASSERT in xfs_attr_rmtval_get() with the run-time check
> that xfs_attr_rmtval_stale() uses, so the read fails with -EFSCORRUPTED.
> It was written with LLM assistance; we reviewed and tested it. With it,
> the reproducer no longer triggers the report.
> 
> The reproducer (repro.c), the kernel config and the patch are attached.
> 
> Thanks,
> Kyuwon Cho

> // WARNING in xfs_find_get_buf (xfs_buf_map_verify) from getxattr() on a remote xattr whose on-disk valuelen is
> // larger than the blocks it owns.
> // Needs an empty XFS image at /files/attr.img (mkfs.xfs -f, 300 MiB, default v5 features) and runs as root.
> // 1. Mount it and give /tmp/mnt/leaf a 16160-byte user.big xattr (a leaf-form attr fork with a 4-block remote
> //    value; 16160 is 4 remote payloads of 4040 bytes).
> // 2. Unmount and rewrite user.big's valuelen in the attr leaf block to 65536, which the leaf verifier accepts
> //    (it only rejects > XFS_XATTR_SIZE_MAX), and fix the block's CRC.
> // 3. Mount again and getxattr() with a 65536-byte buffer: xfs_attr_rmtval_get() maps past the value's 4 blocks
> //    into a hole and reads a daddr past the end of the device.
> #define _GNU_SOURCE
> #include <endian.h>
> #include <errno.h>
> #include <fcntl.h>
> #include <linux/fiemap.h>
> #include <linux/fs.h>
> #include <stdint.h>
> #include <stdio.h>
> #include <stdlib.h>
> #include <string.h>
> #include <sys/ioctl.h>
> #include <sys/mount.h>
> #include <sys/stat.h>
> #include <sys/xattr.h>
> #include <unistd.h>
> 
> #define IMG "/files/attr.img"
> #define MNT "/tmp/mnt"
> #define BLK 4096
> #define LOOP_CTL_GET_FREE 0x4C82
> #define LOOP_SET_FD 0x4C00
> #define LOOP_CLR_FD 0x4C01
> #define BIG 16160
> #define FAKE_LEN 65536
> 
> struct ext { uint64_t phys, len; };
> 
> static char loopdev[32];
> static int loopfd = -1;
> 
> static void die(const char *m) { printf("FATAL %s: %s\n", m, strerror(errno)); fflush(stdout); exit(2); }
> 
> static void attach(void) {
> 	int img = open(IMG, O_RDWR);
> 	if (img < 0) die("open image");
> 	int n = -1;
> 	int ctl = open("/dev/loop-control", O_RDWR);
> 	if (ctl >= 0) { n = ioctl(ctl, LOOP_CTL_GET_FREE); close(ctl); }
> 	for (int t = 0; t < 8; t++) {
> 		snprintf(loopdev, sizeof loopdev, "/dev/loop%d", n >= 0 ? n : t);
> 		loopfd = open(loopdev, O_RDWR);
> 		if (loopfd >= 0 && ioctl(loopfd, LOOP_SET_FD, img) == 0) { close(img); return; }
> 		if (loopfd >= 0) close(loopfd);
> 		if (n >= 0) break;
> 	}
> 	die("attach loop");
> }
> 
> static void detach(void) {
> 	ioctl(loopfd, LOOP_CLR_FD, 0);
> 	close(loopfd);
> 	loopfd = -1;
> }
> 
> static void mount_xfs(void) {
> 	if (mount(loopdev, MNT, "xfs", 0, NULL)) die("mount xfs");
> }
> 
> static void umount_xfs(void) {
> 	sync();
> 	if (umount2(MNT, 0)) die("umount");
> }
> 
> static uint32_t crc32c_raw(uint32_t crc, const unsigned char *p, size_t n) {
> 	for (size_t i = 0; i < n; i++) {
> 		crc ^= p[i];
> 		for (int k = 0; k < 8; k++)
> 			crc = (crc >> 1) ^ (0x82F63B78u & -(crc & 1));
> 	}
> 	return crc;
> }
> 
> static uint32_t xfs_blk_crc(const unsigned char *blk) {
> 	unsigned char tmp[BLK];
> 	memcpy(tmp, blk, BLK);
> 	memset(tmp + 12, 0, 4);
> 	return ~crc32c_raw(0xffffffffu, tmp, BLK);
> }
> 
> static int attr_extents(const char *path, struct ext *out, int max) {
> 	int fd = open(path, O_RDONLY);
> 	if (fd < 0) die("open file for fiemap");
> 	size_t sz = sizeof(struct fiemap) + 128 * sizeof(struct fiemap_extent);
> 	struct fiemap *fm = calloc(1, sz);
> 	fm->fm_start = 0;
> 	fm->fm_length = ~0ULL;
> 	fm->fm_flags = FIEMAP_FLAG_SYNC | FIEMAP_FLAG_XATTR;
> 	fm->fm_extent_count = 128;
> 	if (ioctl(fd, FS_IOC_FIEMAP, fm) < 0) die("fiemap xattr");
> 	int n = 0;
> 	for (unsigned i = 0; i < fm->fm_mapped_extents && n < max; i++) {
> 		out[n].phys = fm->fm_extents[i].fe_physical;
> 		out[n].len = fm->fm_extents[i].fe_length;
> 		n++;
> 	}
> 	free(fm);
> 	close(fd);
> 	return n;
> }
> 
> // Patch the valuelen of the "big" remote entry in a leaf block in the image file.
> // Returns 1 if this block was patched.
> static int patch_block(int img, uint64_t off) {
> 	unsigned char blk[BLK];
> 	unsigned char pat[8] = { 0 };
> 	uint32_t pbe = htobe32(BIG);
> 	memcpy(pat, &pbe, 4);
> 	pat[4] = 3;
> 	memcpy(pat + 5, "big", 3);
> 	if (pread(img, blk, BLK, off) != BLK) die("pread leaf");
> 	if (blk[8] != 0x3b || blk[9] != 0xee) return 0;           // XFS_ATTR3_LEAF_MAGIC
> 	unsigned char *hit = memmem(blk, BLK, pat, sizeof pat);
> 	if (!hit) return 0;
> 	uint32_t stored;
> 	memcpy(&stored, blk + 12, 4);
> 	uint32_t calc = xfs_blk_crc(blk);
> 	if (calc != stored) {
> 		printf("CRC self-check FAILED at off %llu: stored=%08x calc=%08x\n",
> 		       (unsigned long long)off, stored, calc);
> 		fflush(stdout);
> 		exit(3);
> 	}
> 	uint32_t be = htobe32(FAKE_LEN);
> 	memcpy(hit, &be, 4);                                      // valuelen field
> 	uint32_t nc = xfs_blk_crc(blk);
> 	memcpy(blk + 12, &nc, 4);
> 	if (pwrite(img, blk, BLK, off) != BLK) die("pwrite leaf");
> 	return 1;
> }
> 
> int main(void)
> {
> 	char *v = malloc(FAKE_LEN), path[] = MNT "/leaf";
> 	struct ext e[64];
> 	int n, patched = 0, img;
> 
> 	memset(v, 'A', BIG);
> 	mkdir(MNT, 0755);
> 	attach();
> 	mount_xfs();
> 	close(creat(path, 0644));
> 	if (setxattr(path, "user.big", v, BIG, 0))
> 		die("setxattr");
> 	n = attr_extents(path, e, 64);		/* the extents stay valid after unmount */
> 	umount_xfs();
> 	detach();
> 
> 	img = open(IMG, O_RDWR);
> 	for (int i = 0; i < n; i++)
> 		for (uint64_t o = 0; o < e[i].len; o += BLK)
> 			patched += patch_block(img, e[i].phys + o);
> 	fsync(img);
> 	close(img);
> 	printf("patched %d leaf block(s)\n", patched);
> 
> 	attach();
> 	mount_xfs();
> 	printf("getxattr(65536) = %zd (%s)\n", getxattr(path, "user.big", v, FAKE_LEN), strerror(errno));
> 	umount_xfs();
> 	detach();
> 	return 0;
> }


> >From 497e52f18128c6f7c83ab8d52bc8506fac24f1d2 Mon Sep 17 00:00:00 2001
> From: Kyuwon Cho <kyuwoncho18@gmail.com>
> Date: Thu, 19 Nov 2026 11:36:52 +0900
> Subject: [PATCH] xfs: reject a hole in a remote xattr value
> 
> xfs_attr_rmtval_get() maps the blocks of a remote xattr value from the
> on-disk value length and only asserts that a mapping is not a hole. The
> leaf verifier caps the length at XFS_XATTR_SIZE_MAX but does not check
> it against the blocks the value owns, so a larger length makes the read
> reach a hole. Without CONFIG_XFS_DEBUG the hole becomes a disk address
> past the end of the device:
> 
>   xfs_buf_map_verify: daddr 0x258000001a7f0 out of range, EOFS 0x96000
>   WARNING: fs/xfs/xfs_buf.c:423 at xfs_find_get_buf+0x160f/0x2350
>   Call Trace:
>    xfs_buf_read_map (fs/xfs/xfs_buf.c:648)
>    xfs_attr_rmtval_get (fs/xfs/libxfs/xfs_attr_remote.c:434)
>    xfs_attr3_leaf_getvalue (fs/xfs/libxfs/xfs_attr_leaf.c:2718)
> 
> Check for a hole or a delalloc extent at run time and return
> -EFSCORRUPTED, as xfs_attr_rmtval_stale() does.
> 
> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> Signed-off-by: Kyuwon Cho <kyuwoncho18@gmail.com>
> ---
>  fs/xfs/libxfs/xfs_attr_remote.c | 7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr_remote.c b/fs/xfs/libxfs/xfs_attr_remote.c
> index e6c8dd1a997a..722440f005ca 100644
> --- a/fs/xfs/libxfs/xfs_attr_remote.c
> +++ b/fs/xfs/libxfs/xfs_attr_remote.c
> @@ -427,8 +427,11 @@ xfs_attr_rmtval_get(
>  			xfs_daddr_t	dblkno;
>  			int		dblkcnt;
>  
> -			ASSERT((map[i].br_startblock != DELAYSTARTBLOCK) &&
> -			       (map[i].br_startblock != HOLESTARTBLOCK));
> +			if (XFS_IS_CORRUPT(mp, map[i].br_startblock == DELAYSTARTBLOCK) ||
> +			    XFS_IS_CORRUPT(mp, map[i].br_startblock == HOLESTARTBLOCK)) {
> +				xfs_bmap_mark_sick(args->dp, XFS_ATTR_FORK);
> +				return -EFSCORRUPTED;
> +			}
>  			dblkno = XFS_FSB_TO_DADDR(mp, map[i].br_startblock);
>  			dblkcnt = XFS_FSB_TO_BB(mp, map[i].br_blockcount);
>  			error = xfs_buf_read(mp->m_ddev_targp, dblkno, dblkcnt,
> -- 
> 2.43.0
> 

---end quoted text---
