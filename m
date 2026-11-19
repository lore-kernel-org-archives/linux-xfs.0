Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.216.50
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795057496;
	b=MgxRAJAH+XD/bpVTeofx+BhQl1dK6fRePH+cESDaW4SO1g6RBXxCSWa1u3OJfPRIudj7
	 zkRwlmTGLwmJFYfbpeMvs7DiLCSO/RKDygRAuEpZDr+/nzIZWEEX2lK5oDiES78qsh1KW
	 5fhEXIMBvGvJ4uvfBltBbBa4iQ4Q0Q8H9Ao6r9uBc80LPlfK9G/ihvkzJCnrZjeIngXbO
	 JxmRlYWgYK6XdmFIAa6RYAHfukAq9s6knvSnST1sJvW9jfd0DoePmy6Pc2FRl7rytgldG
	 P6DTGKTMqIz1ejtdwYiq4O7h9OnTgVy52Hht9BLq7+6V8VVxrzm2vUe1ljmi0HNUTPw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795057496;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type;
	bh=ZdTp5KP1uZJeuB9Ab7R4vXvLfdBaZXmlleJjGAyKeCo=;
	b=OOsAUox5ZRxwWNv7YsUFYoKWN4Fp74YN7E6mmBDDeaC4v3wz+aY8GkU63lr76hjzSPR2
	 +Kv2vSU5NZfR/6/VtGg1eMS29n4mODwh2o85xHZUAOyI0dR7D+dtLWrcJeopW7Tn/T2Xc
	 DNnJbcUuuqEIdFDRrY6RY9pDxWpNl65o1rEdktTT0zeK8m+CWDeUg4Jo7GlBitd5EWGNX
	 Xk2TtI0sqyM/Uqq5OZBrBOL6mPwAAjkkkJJWds+Rc2fFq9elWRHwPs/SBXbnfNbdresiU
	 sxX5hVOtxxRQa7qLaTCHDDZMOQbGrGHadQf44Z40B0zfRoYqzFyolGMgCkQAByG1ibQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=GEeUrHCe;
	arc=none smtp.remote-ip=209.85.216.50
Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5596F60A2618
	for <linux-xfs@vger.kernel.org>; Thu, 19 Nov 2026 03:04:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5596F60A2618
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=GEeUrHCe
Received: by mail-pj1-f50.google.com with SMTP id 98e67ed59e1d1-3b0d0b80fb9so1076312a91.1
        for <linux-xfs@vger.kernel.org>; Wed, 18 Nov 2026 19:04:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795057495; x=1795662295; darn=vger.kernel.org;
        h=content-type:mime-version:message-id:subject:cc:to:from:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=ZdTp5KP1uZJeuB9Ab7R4vXvLfdBaZXmlleJjGAyKeCo=;
        b=GEeUrHCeuOlOXbFE4Wm0EFd4mGNqO23CGtZGNlFSqA9nNLrDZossLWG9wfR3j4U0sD
         wW8IxzyqYnL3/G1e/d/lAnmAW2n15dnGYQCCjXg5AKfyBfeYPQImCneXom4FT2Z0+StH
         yk0cXdusGEkTmqPwLjDwcuT5Fz/aiy6zaoHoBqeOGWDKFmME0v+UYDwnC+KhaRe8jlYl
         Qp3zKfAapJlECzARCtj72msVwpJlEi28+4ihF0mMQja9x2upTuHPdHW/DZPhNMPkl9y2
         wmWwY517LnuYfeD2ElB9UyeWyj/e5sTqaBnX66A4HR7tPzDsWMQY9mWDVG8+6X/1x6sk
         rHTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795057495; x=1795662295;
        h=content-type:mime-version:message-id:subject:cc:to:from:date
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=ZdTp5KP1uZJeuB9Ab7R4vXvLfdBaZXmlleJjGAyKeCo=;
        b=19SBfQ4QbLRaH3mjTsJus5H62SvBFrtI9WldT8+DluHS+bx+fbQ7Ed3jVTc9Pvu5L2
         vLtj8ghTaZzeZAFiK1x4/M7FIBqcT5zUZhm7Tt0ImUGZWn7FmuXdjFCxmW04UBdeSPY7
         RWq2MUOkAclI0jokhSsCz6d1sTTN/0GVLuSMaS8QIRLJSFaw8MOhm+WStRLXbBjQKyr9
         KXRGXOlqQo4URkVdTXUiZtAH01XGZpKk8g219fJaVghPLdoamEIZ89FITSBYXXGBy5d+
         Wgx9ohttoGFkYzoh3XbHIRFpK/pkAo8aikc2CBRB/i0IPEAD6vieOjc8bwqDbydW8JFB
         iqzw==
X-Forwarded-Encrypted: i=1; AL+hErH08LNWZNGpTM6IaH7ByJVfnUAARN1hGh1pRiqEjIuFFl+8BssZ5SGfcCCiqCzUNBEqzQRrmqhY8nQ=@vger.kernel.org
X-Gm-Message-State: APuU4Z99VDeH0KeHfXcEFStfVBNNh7qGwrp6uZzkDvp3poezLBVzJnRO
	u6Q2NBqEMDYd30OuxhdMFkDHDzpdpe47+2MboOJWXDlBxedlXu5UBcze
X-Gm-Gg: AZFdTZeBrpNVbNmCI4Id6ZBpBRKtP8hzQGuqZAgE0augETzgX72B8MEfwXqungbiU0M
	USYOUiTKHzikxbdGFEIOU+Bm5h5N+4FM5DgcTY/xvW9zabQRogeZouIAAGpbLWfXxeI4zFCisKo
	MaKllzTysEW24qEpnZApileBBqPBk8NljWLwv/OKHKSwRS2STEzmOygUdRpS3BCvvlmzuCx7Jsk
	hhSzqkP1/OMVhtNEyKwrIGDwcSmpqv9cWv7fVqB5ym5+FAaI/lYk+pnmrnctC1PPBBfhR8JgxXb
	svmH0a5y1JwYo/QSioBU7pnMWYEzheL6k3u3hLRAP1s6XMo9b8uFgNk+gMAaNjLoTqqQ5cItxK8
	m+7EEpK3tOsHsEoQ/FB7m/aJjmYX3N6o4kHAVFlbvg7UMJm3TCJgDGWoXTiDUUQOHTM3v1WtsQq
	CMkZxGb6ZW1oCgegCeVeD7N7BlKcFaZP5cjvsSS8obd6N99/dtm+waG7bv+t05P/YxYxBW3uP1k
	Azqp3cgDIqinLfN/u7mpP+3lOFdG4XI7XAWEFnOHQWEDs07nnKiYfe9L+aEDzxJ9lbeX0M=
X-Received: by 2002:a17:90b:2790:b0:3ac:9d83:8861 with SMTP id 98e67ed59e1d1-3b3d0850989mr4462735a91.67.1795057494488;
        Wed, 18 Nov 2026 19:04:54 -0800 (PST)
Received: from [172.21.0.2] (vldb.skku.ac.kr. [115.145.173.180])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b40578dca0sm200894a91.2.2026.11.18.19.04.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Nov 2026 19:04:53 -0800 (PST)
Date: Wed, 18 Nov 2026 19:04:53 -0800 (PST)
From: Kyuwon Cho <kyuwoncho18@gmail.com>
To: Carlos Maiolino <cem@kernel.org>, "Darrick J. Wong" <djwong@kernel.org>
Cc: Aldo Ariel Panzardo <qwe.aldo@gmail.com>, linux-xfs@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: [BUG] xfs: a remote xattr valuelen larger than its blocks makes
 getxattr() read a hole and warn
Message-ID: <179505710272.3511680.12978324583605871086@gmail.com>
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="===============7553020544942881929=="

--===============7553020544942881929==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Hi Carlos, Darrick,

While testing v7.4-rc3 with an LLM-guided test generator that we are
developing as a research prototype, we found that a remote xattr whose
on-disk valuelen is larger than the blocks the value owns makes
getxattr() read a hole, which ends in the WARN_ON() of
xfs_buf_map_verify():

  XFS (loop0): xfs_buf_map_verify: daddr 0x258000001a7f0 out of range, EOFS 0x96000
  WARNING: fs/xfs/xfs_buf.c:423 at xfs_find_get_buf+0x160f/0x2350, CPU#1: test/114
  CPU: 1 UID: 0 PID: 114 Comm: test Not tainted 7.4.0-rc3 #1 PREEMPT(lazy)
  RIP: 0010:xfs_find_get_buf (fs/xfs/xfs_buf.c:423 fs/xfs/xfs_buf.c:567)
  Call Trace:
   <TASK>
   xfs_buf_read_map (fs/xfs/xfs_buf.c:648)
   xfs_attr_rmtval_get (fs/xfs/xfs_buf.h:243 fs/xfs/libxfs/xfs_attr_remote.c:434)
   xfs_attr3_leaf_getvalue (fs/xfs/libxfs/xfs_attr_leaf.c:2718)
   xfs_attr_node_get (fs/xfs/libxfs/xfs_attr.c:1597)
   xfs_attr_get (fs/xfs/libxfs/xfs_attr.c:287)
   xfs_xattr_get (fs/xfs/xfs_xattr.c:150)
   __vfs_getxattr (fs/xattr.c:446)
   vfs_getxattr (fs/xattr.c:479)
   do_getxattr (fs/xattr.c:808)
   filename_getxattr (fs/xattr.c:837)
   path_getxattrat (fs/xattr.c:876)
   do_syscall_64 (arch/x86/entry/syscall_64.c:61 arch/x86/entry/syscall_64.c:89)
   entry_SYSCALL_64_after_hwframe (arch/x86/entry/entry_64.S:121)
   </TASK>

15ccd92a782a ("xfs: reject remote xattr entries with an out-of-range
value length") makes the leaf verifier reject a remote valuelen above
XFS_XATTR_SIZE_MAX, but a valuelen up to that limit is not checked
against the value's blocks. xfs_attr3_leaf_getvalue() computes
rmtblkcnt from the on-disk valuelen, and xfs_attr_rmtval_get() maps
that many blocks of the attr fork. It only asserts that a mapping is
not a hole:

		for (i = 0; (i < nmap) && (valuelen > 0); i++) {
			...
			ASSERT((map[i].br_startblock != DELAYSTARTBLOCK) &&
			       (map[i].br_startblock != HOLESTARTBLOCK));
			dblkno = XFS_FSB_TO_DADDR(mp, map[i].br_startblock);
			...
			error = xfs_buf_read(mp->m_ddev_targp, dblkno, dblkcnt,
					0, &bp, &xfs_attr3_rmt_buf_ops);

Without CONFIG_XFS_DEBUG, a hole becomes the out-of-range daddr above.
xfs_attr_rmtval_stale() in the same file checks for a hole at run time
and returns -EFSCORRUPTED.

The reproducer runs as root on an empty XFS image (mkfs.xfs, 300 MiB,
default v5 features). It gives a file a 16160-byte user.big xattr (four
remote blocks), unmounts, rewrites the entry's valuelen in the attr
leaf block to 65536 and fixes the block's CRC, mounts again, and calls
getxattr() with a 65536-byte buffer. On an x86_64 QEMU guest with 2
vCPUs and KASAN (gcc 13.3), it warns every time, and getxattr() fails.

Checked against v7.4-rc3 (aebb72744764); xfs_attr_remote.c and
xfs_attr_leaf.c are the same in the xfs for-next branch.

A patch is attached (git format-patch against v7.4-rc3; it applies to
the xfs for-next branch):

  0001-xfs-reject-a-hole-in-a-remote-xattr-value.patch

It replaces the ASSERT in xfs_attr_rmtval_get() with the run-time check
that xfs_attr_rmtval_stale() uses, so the read fails with -EFSCORRUPTED.
It was written with LLM assistance; we reviewed and tested it. With it,
the reproducer no longer triggers the report.

The reproducer (repro.c), the kernel config and the patch are attached.

Thanks,
Kyuwon Cho

--===============7553020544942881929==
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename="repro.c"
MIME-Version: 1.0

// WARNING in xfs_find_get_buf (xfs_buf_map_verify) from getxattr() on a remote xattr whose on-disk valuelen is
// larger than the blocks it owns.
// Needs an empty XFS image at /files/attr.img (mkfs.xfs -f, 300 MiB, default v5 features) and runs as root.
// 1. Mount it and give /tmp/mnt/leaf a 16160-byte user.big xattr (a leaf-form attr fork with a 4-block remote
//    value; 16160 is 4 remote payloads of 4040 bytes).
// 2. Unmount and rewrite user.big's valuelen in the attr leaf block to 65536, which the leaf verifier accepts
//    (it only rejects > XFS_XATTR_SIZE_MAX), and fix the block's CRC.
// 3. Mount again and getxattr() with a 65536-byte buffer: xfs_attr_rmtval_get() maps past the value's 4 blocks
//    into a hole and reads a daddr past the end of the device.
#define _GNU_SOURCE
#include <endian.h>
#include <errno.h>
#include <fcntl.h>
#include <linux/fiemap.h>
#include <linux/fs.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/ioctl.h>
#include <sys/mount.h>
#include <sys/stat.h>
#include <sys/xattr.h>
#include <unistd.h>

#define IMG "/files/attr.img"
#define MNT "/tmp/mnt"
#define BLK 4096
#define LOOP_CTL_GET_FREE 0x4C82
#define LOOP_SET_FD 0x4C00
#define LOOP_CLR_FD 0x4C01
#define BIG 16160
#define FAKE_LEN 65536

struct ext { uint64_t phys, len; };

static char loopdev[32];
static int loopfd = -1;

static void die(const char *m) { printf("FATAL %s: %s\n", m, strerror(errno)); fflush(stdout); exit(2); }

static void attach(void) {
	int img = open(IMG, O_RDWR);
	if (img < 0) die("open image");
	int n = -1;
	int ctl = open("/dev/loop-control", O_RDWR);
	if (ctl >= 0) { n = ioctl(ctl, LOOP_CTL_GET_FREE); close(ctl); }
	for (int t = 0; t < 8; t++) {
		snprintf(loopdev, sizeof loopdev, "/dev/loop%d", n >= 0 ? n : t);
		loopfd = open(loopdev, O_RDWR);
		if (loopfd >= 0 && ioctl(loopfd, LOOP_SET_FD, img) == 0) { close(img); return; }
		if (loopfd >= 0) close(loopfd);
		if (n >= 0) break;
	}
	die("attach loop");
}

static void detach(void) {
	ioctl(loopfd, LOOP_CLR_FD, 0);
	close(loopfd);
	loopfd = -1;
}

static void mount_xfs(void) {
	if (mount(loopdev, MNT, "xfs", 0, NULL)) die("mount xfs");
}

static void umount_xfs(void) {
	sync();
	if (umount2(MNT, 0)) die("umount");
}

static uint32_t crc32c_raw(uint32_t crc, const unsigned char *p, size_t n) {
	for (size_t i = 0; i < n; i++) {
		crc ^= p[i];
		for (int k = 0; k < 8; k++)
			crc = (crc >> 1) ^ (0x82F63B78u & -(crc & 1));
	}
	return crc;
}

static uint32_t xfs_blk_crc(const unsigned char *blk) {
	unsigned char tmp[BLK];
	memcpy(tmp, blk, BLK);
	memset(tmp + 12, 0, 4);
	return ~crc32c_raw(0xffffffffu, tmp, BLK);
}

static int attr_extents(const char *path, struct ext *out, int max) {
	int fd = open(path, O_RDONLY);
	if (fd < 0) die("open file for fiemap");
	size_t sz = sizeof(struct fiemap) + 128 * sizeof(struct fiemap_extent);
	struct fiemap *fm = calloc(1, sz);
	fm->fm_start = 0;
	fm->fm_length = ~0ULL;
	fm->fm_flags = FIEMAP_FLAG_SYNC | FIEMAP_FLAG_XATTR;
	fm->fm_extent_count = 128;
	if (ioctl(fd, FS_IOC_FIEMAP, fm) < 0) die("fiemap xattr");
	int n = 0;
	for (unsigned i = 0; i < fm->fm_mapped_extents && n < max; i++) {
		out[n].phys = fm->fm_extents[i].fe_physical;
		out[n].len = fm->fm_extents[i].fe_length;
		n++;
	}
	free(fm);
	close(fd);
	return n;
}

// Patch the valuelen of the "big" remote entry in a leaf block in the image file.
// Returns 1 if this block was patched.
static int patch_block(int img, uint64_t off) {
	unsigned char blk[BLK];
	unsigned char pat[8] = { 0 };
	uint32_t pbe = htobe32(BIG);
	memcpy(pat, &pbe, 4);
	pat[4] = 3;
	memcpy(pat + 5, "big", 3);
	if (pread(img, blk, BLK, off) != BLK) die("pread leaf");
	if (blk[8] != 0x3b || blk[9] != 0xee) return 0;           // XFS_ATTR3_LEAF_MAGIC
	unsigned char *hit = memmem(blk, BLK, pat, sizeof pat);
	if (!hit) return 0;
	uint32_t stored;
	memcpy(&stored, blk + 12, 4);
	uint32_t calc = xfs_blk_crc(blk);
	if (calc != stored) {
		printf("CRC self-check FAILED at off %llu: stored=%08x calc=%08x\n",
		       (unsigned long long)off, stored, calc);
		fflush(stdout);
		exit(3);
	}
	uint32_t be = htobe32(FAKE_LEN);
	memcpy(hit, &be, 4);                                      // valuelen field
	uint32_t nc = xfs_blk_crc(blk);
	memcpy(blk + 12, &nc, 4);
	if (pwrite(img, blk, BLK, off) != BLK) die("pwrite leaf");
	return 1;
}

int main(void)
{
	char *v = malloc(FAKE_LEN), path[] = MNT "/leaf";
	struct ext e[64];
	int n, patched = 0, img;

	memset(v, 'A', BIG);
	mkdir(MNT, 0755);
	attach();
	mount_xfs();
	close(creat(path, 0644));
	if (setxattr(path, "user.big", v, BIG, 0))
		die("setxattr");
	n = attr_extents(path, e, 64);		/* the extents stay valid after unmount */
	umount_xfs();
	detach();

	img = open(IMG, O_RDWR);
	for (int i = 0; i < n; i++)
		for (uint64_t o = 0; o < e[i].len; o += BLK)
			patched += patch_block(img, e[i].phys + o);
	fsync(img);
	close(img);
	printf("patched %d leaf block(s)\n", patched);

	attach();
	mount_xfs();
	printf("getxattr(65536) = %zd (%s)\n", getxattr(path, "user.big", v, FAKE_LEN), strerror(errno));
	umount_xfs();
	detach();
	return 0;
}

--===============7553020544942881929==
Content-Type: application/gzip
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="config.gz"
MIME-Version: 1.0

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

--===============7553020544942881929==
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="0001-xfs-reject-a-hole-in-a-remote-xattr-value.patch"
MIME-Version: 1.0

>From 497e52f18128c6f7c83ab8d52bc8506fac24f1d2 Mon Sep 17 00:00:00 2001
From: Kyuwon Cho <kyuwoncho18@gmail.com>
Date: Thu, 19 Nov 2026 11:36:52 +0900
Subject: [PATCH] xfs: reject a hole in a remote xattr value

xfs_attr_rmtval_get() maps the blocks of a remote xattr value from the
on-disk value length and only asserts that a mapping is not a hole. The
leaf verifier caps the length at XFS_XATTR_SIZE_MAX but does not check
it against the blocks the value owns, so a larger length makes the read
reach a hole. Without CONFIG_XFS_DEBUG the hole becomes a disk address
past the end of the device:

  xfs_buf_map_verify: daddr 0x258000001a7f0 out of range, EOFS 0x96000
  WARNING: fs/xfs/xfs_buf.c:423 at xfs_find_get_buf+0x160f/0x2350
  Call Trace:
   xfs_buf_read_map (fs/xfs/xfs_buf.c:648)
   xfs_attr_rmtval_get (fs/xfs/libxfs/xfs_attr_remote.c:434)
   xfs_attr3_leaf_getvalue (fs/xfs/libxfs/xfs_attr_leaf.c:2718)

Check for a hole or a delalloc extent at run time and return
-EFSCORRUPTED, as xfs_attr_rmtval_stale() does.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Kyuwon Cho <kyuwoncho18@gmail.com>
---
 fs/xfs/libxfs/xfs_attr_remote.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr_remote.c b/fs/xfs/libxfs/xfs_attr_remote.c
index e6c8dd1a997a..722440f005ca 100644
--- a/fs/xfs/libxfs/xfs_attr_remote.c
+++ b/fs/xfs/libxfs/xfs_attr_remote.c
@@ -427,8 +427,11 @@ xfs_attr_rmtval_get(
 			xfs_daddr_t	dblkno;
 			int		dblkcnt;
 
-			ASSERT((map[i].br_startblock != DELAYSTARTBLOCK) &&
-			       (map[i].br_startblock != HOLESTARTBLOCK));
+			if (XFS_IS_CORRUPT(mp, map[i].br_startblock == DELAYSTARTBLOCK) ||
+			    XFS_IS_CORRUPT(mp, map[i].br_startblock == HOLESTARTBLOCK)) {
+				xfs_bmap_mark_sick(args->dp, XFS_ATTR_FORK);
+				return -EFSCORRUPTED;
+			}
 			dblkno = XFS_FSB_TO_DADDR(mp, map[i].br_startblock);
 			dblkcnt = XFS_FSB_TO_BB(mp, map[i].br_blockcount);
 			error = xfs_buf_read(mp->m_ddev_targp, dblkno, dblkcnt,
-- 
2.43.0


--===============7553020544942881929==--
