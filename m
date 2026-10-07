Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com [209.85.218.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2826426158B
	for <linux-xfs@vger.kernel.org>; Wed,  7 Oct 2026 14:46:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791384418; cv=none; b=MqwjJtU1Tr07r0HfR1SW2E2Mj5IZkPoPMOpANK+z5hbRHFYbvUtrHhAU6sG1CR/+ShFtl68ln31e+jhMmIoE94nyQ806skRj/+6WcbtwGDG+gg7Uc30KtiXyQxAxduiB7xcGSXjMbapFL2RwtNT+qvymMFJvUyr/gH5i6gHPy6c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791384418; c=relaxed/simple;
	bh=LQxbivjCGyqDbxZy2LJXRp9z66oqcoQIm73zu8ZoxUo=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=VjQG288nrcwbupXt7lbwcxHNXe9rzNWgwav7sGs+7XrLiAhNlmHckVPSEwPdlxJg3AkCyMoulI5AktrmWM0QrtYwtlH4KUqGjssnFFxzbx77v8mZ15VwoktNtPMNMpD1VJsJy0BVtr+Qqv9qkGNQXBI0a1mueVXB+khEMdXac8s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=doyensec.com; spf=pass smtp.mailfrom=doyensec.com; dkim=pass (2048-bit key) header.d=doyensec.com header.i=@doyensec.com header.b=K8cqxA32; arc=none smtp.client-ip=209.85.218.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=doyensec.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=doyensec.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=doyensec.com header.i=@doyensec.com header.b="K8cqxA32"
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-c2e5e801487so291282966b.3
        for <linux-xfs@vger.kernel.org>; Wed, 07 Oct 2026 07:46:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=doyensec.com; s=google; t=1791384411; x=1791989211; darn=vger.kernel.org;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:content-type:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=GgBzhITFVaSirn9fvp94o4tVDNcjUuD9galN/ab+RMg=;
        b=K8cqxA32d26CBXyeaNyhMMOS/HDU10DQcml0GpkoVPWYwzO+NVNEB6IZA30XGwD4wM
         TIdX9lANU8OrPIrQQ8CHKNVIy+H+iIMQz9neR8Dr4OMUHZOHjFkl2J8f8lkGopu3CpFT
         DiU5uJ0LVmq+poY+qNFXrzukzY0owGlT+W0ZL2fVMFnyVyFnrxPZ4zot6chLJllhxnm8
         ZW7kzqg8uGQS0QRDrNq6CikBWOXPe8jII5OTHVjhZzdXzgl3hMuGPBa8HiAnciIMJsLT
         a4ajrI61RJ4Y5o50/KwYt9sX5lSfsqdWPBrghVbFxv0yLI+Ra5CFCtX3bsgwQskcLw68
         GcYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791384411; x=1791989211;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:content-type:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=GgBzhITFVaSirn9fvp94o4tVDNcjUuD9galN/ab+RMg=;
        b=2MkG0j/w8/9BZBC9eaBIUmRqh9ioLbBbwID0Z6asxcygNCHaCZdgeAkFkfiq2FHMsE
         Dv1iK3XyF/CDu0jZpbBQ6HsW+T2GXTRfvu65FpTGzF+HknF7Wpt7JiWnuv5o23PvvAFP
         F3v+in+r1tFZ1LlFMM/cR9c++T8v+uOata9LPkS9INYOCd5GPO6Ew++fqdEiiJPvudHW
         L8TThSnApu2fc+ypFp8KfAq2Bey89dfboC9ddo7MRQUhYQDZyLatAjw1/GODk0HZlBTy
         Y2vOVcpha6XbWH7/D+NZTDvRe6Nr1YPBmDpDySz54/L5UCuxqexe9HE3PZgIfDtPtkeR
         OAbw==
X-Forwarded-Encrypted: i=1; AKwUvBwOXn4ghR3CebjOKJlT+Y1WtfqIZLA4enjlsIcmeh+L2lQE0pmV/20VAN63HeZeNMOYst8jCG4banY=@vger.kernel.org
X-Gm-Message-State: AFuF++mEhwQC89HmVr+vjePa6a/KIzIFbyvaQ0+ihQbpldwE7e4kFmbi
	ViGxj/AYU310a846OQPHxzomAxPSN0RXfn3RaddfoXPPaW43rSeLNSPCoYi1ksSMsUo8Pq94A8H
	hmkVKbgo=
X-Gm-Gg: AYBFou2NmCSfL9pJnIZ8GZHxZUXV2/XBVoKDGISHuIezVQ8i9yr3J3Kuw7HbS1AKsaf
	O6CSqNtR6PzOblMwn2ZT3CQm/ZI2gDso4fzKWZ+wXV/XNAdWz4lLkPYV5zCoZ+VAQqsYm/O4tI/
	mDy6y7C7t6zotU6yQjyfkjRTqeTvDrtN6/O1U+TlAPGBFiLLFKG2g2nFvwH+u5eYoOYCIr4uZ0w
	o7fNnDU1oE1AC1GlZwCd/xiu951DaEGESOdQQ2b9svy+Vx7VDdQIXaLt8WFEBEwIFfsT5QxFl/u
	gU3ukp33ZYJswmrPtlOdWupehWJgPbfUUuHQcaKm7QI1CFrTtjmrjxz170qXWnwv6nhhh0XoXVd
	aNrVZqp5apcBby3zYwBZ8lB1OjSG/u0VgDcXqsJU4Z98bomUNSpw0GqV6Tzy9ixmNX4fxwikYbM
	HOGHgUu41FKdJI+P38bzzyGSRAwj+FJ1WyYcDm9NGH1w2UWunXTfPxZXXYJ9PGhcguV4WDGp/uJ
	pRYiOIeJ2/9kZqOMk72G1vYoyoEmIRCecyk37cmE0VR9HlHW0TW5IkkyGKeQZs=
X-Received: by 2002:a17:907:c0c:b0:c2e:4de1:956f with SMTP id a640c23a62f3a-c317c0c854fmr262902466b.43.1791384411098;
        Wed, 07 Oct 2026 07:46:51 -0700 (PDT)
Received: from smtpclient.apple (80.49.145.194.ipv4.supernova.orange.pl. [80.49.145.194])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c317c1c0e91sm112457366b.40.2026.10.07.07.46.50
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 07 Oct 2026 07:46:50 -0700 (PDT)
Content-Type: text/plain;
	charset=us-ascii
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.700.51.1.1\))
Subject: Re: [PATCH v2] xfs: stop exchanging reflink flags when exchanging
 mappings
From: Norbert Szetei <norbert@doyensec.com>
In-Reply-To: <EFFDC5C8-D154-419E-BC3E-050AD53F55F8@doyensec.com>
Date: Wed, 7 Oct 2026 16:46:39 +0200
Cc: Dave Chinner <dgc@kernel.org>,
 Carlos Maiolino <cem@kernel.org>,
 linux-xfs@vger.kernel.org,
 Christoph Hellwig <hch@infradead.org>
Content-Transfer-Encoding: 7bit
Message-Id: <1E97806E-3236-4BC4-A3F5-8197FE07F077@doyensec.com>
References: <EFFDC5C8-D154-419E-BC3E-050AD53F55F8@doyensec.com>
To: "Darrick J. Wong" <djwong@kernel.org>
X-Mailer: Apple Mail (2.3864.700.51.1.1)

Here is a reproducer for the XFS_IOC_SWAPEXT case, since there wasn't
one on the list yet, in case it's useful for fstests.

	$ truncate -s 512M img && mkfs.xfs -q -m rmapbt=1,reflink=1 img
	$ mkdir -p /tmp/m && sudo mount -o loop img /tmp/m && sudo chmod 1777 /tmp/m
	$ sudo xfs_io -f -c "pwrite -q -S 0x50 0 4096" /tmp/m/peer
	$ sudo chmod 644 /tmp/m/peer
	$ cd /tmp/m && ./xfs_swapext_poc

On an unpatched kernel it reports peer as rewritten. With v2 applied,
peer is left intact. It needs rmapbt=1.

// SPDX-License-Identifier: GPL-2.0
#define _GNU_SOURCE
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <fcntl.h>
#include <sys/ioctl.h>
#include <sys/stat.h>
#include <sys/vfs.h>
#include <linux/fs.h>
#include <linux/fiemap.h>

#ifndef FICLONERANGE
#define FICLONERANGE _IOW(0x94, 13, struct file_clone_range)
#endif

/* fs/xfs/libxfs/xfs_fs.h */
struct xfs_exchange_range {
	__s32		file1_fd;
	__u32		pad;
	__u64		file1_offset;
	__u64		file2_offset;
	__u64		length;
	__u64		flags;
};
#define XFS_IOC_EXCHANGE_RANGE		_IOW('X', 129, struct xfs_exchange_range)
#define XFS_EXCHANGE_RANGE_TO_EOF	(1ULL << 0)

typedef struct xfs_bstime {
	long		tv_sec;
	__s32		tv_nsec;
} xfs_bstime_t;

struct xfs_bstat {
	__u64		bs_ino;
	__u16		bs_mode;
	__u16		bs_nlink;
	__u32		bs_uid;
	__u32		bs_gid;
	__u32		bs_rdev;
	__s32		bs_blksize;
	__s64		bs_size;
	xfs_bstime_t	bs_atime;
	xfs_bstime_t	bs_mtime;
	xfs_bstime_t	bs_ctime;
	__s64		bs_blocks;
	__u32		bs_xflags;
	__s32		bs_extsize;
	__s32		bs_extents;
	__u32		bs_gen;
	__u16		bs_projid_lo;
	__u16		bs_forkoff;
	__u16		bs_projid_hi;
	__u16		bs_sick;
	__u16		bs_checked;
	unsigned char	bs_pad[2];
	__u32		bs_cowextsize;
	__u32		bs_dmevmask;
	__u16		bs_dmstate;
	__u16		bs_aextents;
};

struct xfs_swapext {
	__s64			sx_version;
#define XFS_SX_VERSION		0
	__s64			sx_fdtarget;
	__s64			sx_fdtmp;
	__s64			sx_offset;
	__s64			sx_length;
	char			sx_pad[16];
	struct xfs_bstat	sx_stat;
};
#define XFS_IOC_SWAPEXT		_IOWR('X', 109, struct xfs_swapext)

static unsigned long blksz;
static int peer, f1;

static unsigned long long phys(int fd, unsigned long long off)
{
	struct { struct fiemap f; struct fiemap_extent e[1]; } q;

	memset(&q, 0, sizeof q);
	q.f.fm_start = off;
	q.f.fm_length = blksz;
	q.f.fm_extent_count = 1;
	if (ioctl(fd, FS_IOC_FIEMAP, &q.f) || q.f.fm_mapped_extents < 1)
		return 0;
	return (q.e[0].fe_physical + (off - q.e[0].fe_logical)) / blksz;
}

static void show(const char *tag)
{
	struct stat st;
	int i;

	fstat(f1, &st);
	printf("%-26s peer [%llu]   file1 size %5lld  [", tag, phys(peer, 0),
	       (long long)st.st_size);
	for (i = 0; i < 3; i++)
		printf("%llu%s", phys(f1, (unsigned long long)i * blksz),
		       i == 2 ? "]\n" : "] [");
}

static int mkfile(const char *name, char fill, int blocks)
{
	char *buf;
	int fd;

	unlink(name);
	fd = open(name, O_RDWR | O_CREAT | O_EXCL, 0600);
	if (fd < 0)
		return fprintf(stderr, "open %s: %m\n", name), -1;
	buf = malloc(blocks * blksz);
	memset(buf, fill, blocks * blksz);
	if (pwrite(fd, buf, blocks * blksz, 0) != (ssize_t)(blocks * blksz))
		return fprintf(stderr, "pwrite %s: %m\n", name), -1;
	free(buf);
	fsync(fd);
	return fd;
}

int main(void)
{
	struct xfs_exchange_range xr;
	struct file_clone_range cr;
	struct xfs_swapext sx;
	char before[65536], after[65536], *buf;
	struct statfs sfs;
	struct stat st;
	int d1, d2;

	if (statfs(".", &sfs))
		return fprintf(stderr, "statfs: %m\n"), 2;
	blksz = sfs.f_bsize;

	peer = open("peer", O_RDONLY);
	if (peer < 0)
		return fprintf(stderr, "open peer: %m\n"), 2;
	fstat(peer, &st);
	printf("peer uid %u mode %04o size %lld, block size %lu\n\n",
	       st.st_uid, st.st_mode & 07777, (long long)st.st_size, blksz);
	if (pread(peer, before, blksz, 0) != (ssize_t)blksz)
		return fprintf(stderr, "read peer: %m\n"), 2;
	syncfs(peer);	/* so FIEMAP reports peer's real block */

	f1 = mkfile("file1", 'A', 3);
	d1 = mkfile("donor1", 'B', 1);
	d2 = mkfile("donor2", 'C', 1);
	if (f1 < 0 || d1 < 0 || d2 < 0)
		return 2;
	show("start");

	/* 1. share peer's block into the middle of file1 */
	cr = (struct file_clone_range){ .src_fd = peer, .src_offset = 0,
					.src_length = blksz,
					.dest_offset = blksz };
	if (ioctl(f1, FICLONERANGE, &cr))
		return fprintf(stderr, "FICLONERANGE: %m\n"), 2;
	show("1 FICLONERANGE");

	/*
	 * 2. exchange file1's last block against the whole of donor1 with
	 * TO_EOF.  The sizes are exchanged too, so file1 claims one block
	 * while still owning three.  file2_offset is block 2, so this exchange
	 * cannot clear a reflink flag.
	 */
	xr = (struct xfs_exchange_range){ .file1_fd = d1, .file1_offset = 0,
					  .file2_offset = 2 * blksz,
					  .length = 0,
					  .flags = XFS_EXCHANGE_RANGE_TO_EOF };
	if (ioctl(f1, XFS_IOC_EXCHANGE_RANGE, &xr))
		return fprintf(stderr, "EXCHANGE_RANGE TO_EOF: %m\n"), 2;
	show("2 EXCHANGE_RANGE TO_EOF");

	/*
	 * 3. XFS_IOC_SWAPEXT with file1 as the target.  sx_offset is 0 and
	 * sx_length equals both inodes' i_disk_size, so the "Verify all data
	 * are being swapped" test passes.  xfs_swap_extent_rmap() then bounds
	 * its remap loop with XFS_B_TO_FSB(mp, i_size_read(VFS_I(ip))), which
	 * is one block, so file1's two mappings above its size are left in
	 * place -- and the reflink flags are swapped anyway, clearing file1's.
	 */
	fsync(f1);
	fsync(d2);
	if (fstat(f1, &st))
		return fprintf(stderr, "fstat file1: %m\n"), 2;
	memset(&sx, 0, sizeof sx);
	sx.sx_version		= XFS_SX_VERSION;
	sx.sx_fdtarget		= f1;
	sx.sx_fdtmp		= d2;
	sx.sx_offset		= 0;
	sx.sx_length		= st.st_size;
	sx.sx_stat.bs_mtime.tv_sec  = st.st_mtim.tv_sec;
	sx.sx_stat.bs_mtime.tv_nsec = st.st_mtim.tv_nsec;
	sx.sx_stat.bs_ctime.tv_sec  = st.st_ctim.tv_sec;
	sx.sx_stat.bs_ctime.tv_nsec = st.st_ctim.tv_nsec;
	if (ioctl(f1, XFS_IOC_SWAPEXT, &sx))
		return fprintf(stderr, "SWAPEXT: %m\n"), 2;
	show("3 SWAPEXT");

	/* 4. write to the block file1 still shares with peer */
	buf = malloc(blksz);
	memset(buf, 'X', blksz);
	if (pwrite(f1, buf, blksz, blksz) != (ssize_t)blksz)
		return fprintf(stderr, "pwrite: %m\n"), 2;
	fsync(f1);
	show("4 pwrite(file1, 4096)");

	posix_fadvise(peer, 0, 0, POSIX_FADV_DONTNEED);
	if (pread(peer, after, blksz, 0) != (ssize_t)blksz)
		return fprintf(stderr, "re-read peer: %m\n"), 2;
	printf("\npeer first byte %c -> %c   %s\n", before[0], after[0],
	       memcmp(before, after, blksz) ? "PEER REWRITTEN" : "peer intact");
	return memcmp(before, after, blksz) ? 0 : 1;
}

