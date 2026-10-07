Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8D0B4973B3
	for <linux-xfs@vger.kernel.org>; Wed,  7 Oct 2026 16:55:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791392141; cv=none; b=H1NiZN0WyhCtRqLsniNqbWLRIDQWC9vIk4cmYdsvi2A+oTWxERbIE7K1PkKo5jnRm0byI9jCs/mC91onI7scmQmZgUj9fmYord8UQ543B/fXTDxXIpZVgMpLE9Ut+DWPjkp4ENxkpryQDTUu9IoAAy01SWwwV/98AXBsbsPWFow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791392141; c=relaxed/simple;
	bh=A/4aglhO6O5YLMNEaoippsjd9c6kpQAocfhLNBZF+uM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rkupKCygIKi0Nvn9LmzJwLU8g5/6j+kwl58og3cr1dIC6/qpoFLr4Ayl/zXx3lJRYGtwstjuzhEaJGL6yuoHG+XwLk80w+QLzZsrc5Rl0IbHIgwOQmx2KlRoc3Y50/YbHLJDOsLsSxtLi9A203B+wXrffwqrHcx8gAykMzIAVFo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=apHr8bZm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="apHr8bZm"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 587261F000FF;
	Wed,  7 Oct 2026 16:55:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791392140;
	bh=qB5KEcOW4iZwbtFhHF3GUCdPDS06m66RvlVy8U3y4Is=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=apHr8bZmFRZersKI2QZtJA5MvBwtLbXe3vtXGBr0oG6eSCzptsTG3Pb4IfwP6lLc+
	 rH3IOIR1lChyUpZx/92zzXfllfPr59dTf1XG3BSSAfJpoTuG+fkOFYZrvQTQrLDSfI
	 Qyl/z6wN6Mk0XWM5ts970my3VVVJnQHEGBqdpZoOLsDLq8/9JNlRcg2lLzVzdbj+qR
	 cTiKOpGGzXYz6T3kDZtouh4rC/t/Aoa+04ucr6/PIB3sT9CEkZ/ZpE37mR1P/rSxW+
	 /85u67igvJn1kYrmf9G8+22DS+fDoWEuqt5+RsKF1akom0ZjhCv0T4kVTZbuLQr/2f
	 HFEO8mZ1gWzzg==
Date: Wed, 7 Oct 2026 09:55:39 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Norbert Szetei <norbert@doyensec.com>
Cc: Dave Chinner <dgc@kernel.org>, Carlos Maiolino <cem@kernel.org>,
	linux-xfs@vger.kernel.org, Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v2] xfs: stop exchanging reflink flags when exchanging
 mappings
Message-ID: <20261007165539.GF2705364@frogsfrogsfrogs>
References: <EFFDC5C8-D154-419E-BC3E-050AD53F55F8@doyensec.com>
 <1E97806E-3236-4BC4-A3F5-8197FE07F077@doyensec.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1E97806E-3236-4BC4-A3F5-8197FE07F077@doyensec.com>

On Wed, Oct 07, 2026 at 04:46:39PM +0200, Norbert Szetei wrote:
> Here is a reproducer for the XFS_IOC_SWAPEXT case, since there wasn't
> one on the list yet, in case it's useful for fstests.
> 
> 	$ truncate -s 512M img && mkfs.xfs -q -m rmapbt=1,reflink=1 img
> 	$ mkdir -p /tmp/m && sudo mount -o loop img /tmp/m && sudo chmod 1777 /tmp/m
> 	$ sudo xfs_io -f -c "pwrite -q -S 0x50 0 4096" /tmp/m/peer
> 	$ sudo chmod 644 /tmp/m/peer
> 	$ cd /tmp/m && ./xfs_swapext_poc
> 
> On an unpatched kernel it reports peer as rewritten. With v2 applied,
> peer is left intact. It needs rmapbt=1.

Thanks for the third repro, I'll kludge that into a fstests too.

--D

> // SPDX-License-Identifier: GPL-2.0
> #define _GNU_SOURCE
> #include <stdio.h>
> #include <stdlib.h>
> #include <string.h>
> #include <unistd.h>
> #include <fcntl.h>
> #include <sys/ioctl.h>
> #include <sys/stat.h>
> #include <sys/vfs.h>
> #include <linux/fs.h>
> #include <linux/fiemap.h>
> 
> #ifndef FICLONERANGE
> #define FICLONERANGE _IOW(0x94, 13, struct file_clone_range)
> #endif
> 
> /* fs/xfs/libxfs/xfs_fs.h */
> struct xfs_exchange_range {
> 	__s32		file1_fd;
> 	__u32		pad;
> 	__u64		file1_offset;
> 	__u64		file2_offset;
> 	__u64		length;
> 	__u64		flags;
> };
> #define XFS_IOC_EXCHANGE_RANGE		_IOW('X', 129, struct xfs_exchange_range)
> #define XFS_EXCHANGE_RANGE_TO_EOF	(1ULL << 0)
> 
> typedef struct xfs_bstime {
> 	long		tv_sec;
> 	__s32		tv_nsec;
> } xfs_bstime_t;
> 
> struct xfs_bstat {
> 	__u64		bs_ino;
> 	__u16		bs_mode;
> 	__u16		bs_nlink;
> 	__u32		bs_uid;
> 	__u32		bs_gid;
> 	__u32		bs_rdev;
> 	__s32		bs_blksize;
> 	__s64		bs_size;
> 	xfs_bstime_t	bs_atime;
> 	xfs_bstime_t	bs_mtime;
> 	xfs_bstime_t	bs_ctime;
> 	__s64		bs_blocks;
> 	__u32		bs_xflags;
> 	__s32		bs_extsize;
> 	__s32		bs_extents;
> 	__u32		bs_gen;
> 	__u16		bs_projid_lo;
> 	__u16		bs_forkoff;
> 	__u16		bs_projid_hi;
> 	__u16		bs_sick;
> 	__u16		bs_checked;
> 	unsigned char	bs_pad[2];
> 	__u32		bs_cowextsize;
> 	__u32		bs_dmevmask;
> 	__u16		bs_dmstate;
> 	__u16		bs_aextents;
> };
> 
> struct xfs_swapext {
> 	__s64			sx_version;
> #define XFS_SX_VERSION		0
> 	__s64			sx_fdtarget;
> 	__s64			sx_fdtmp;
> 	__s64			sx_offset;
> 	__s64			sx_length;
> 	char			sx_pad[16];
> 	struct xfs_bstat	sx_stat;
> };
> #define XFS_IOC_SWAPEXT		_IOWR('X', 109, struct xfs_swapext)
> 
> static unsigned long blksz;
> static int peer, f1;
> 
> static unsigned long long phys(int fd, unsigned long long off)
> {
> 	struct { struct fiemap f; struct fiemap_extent e[1]; } q;
> 
> 	memset(&q, 0, sizeof q);
> 	q.f.fm_start = off;
> 	q.f.fm_length = blksz;
> 	q.f.fm_extent_count = 1;
> 	if (ioctl(fd, FS_IOC_FIEMAP, &q.f) || q.f.fm_mapped_extents < 1)
> 		return 0;
> 	return (q.e[0].fe_physical + (off - q.e[0].fe_logical)) / blksz;
> }
> 
> static void show(const char *tag)
> {
> 	struct stat st;
> 	int i;
> 
> 	fstat(f1, &st);
> 	printf("%-26s peer [%llu]   file1 size %5lld  [", tag, phys(peer, 0),
> 	       (long long)st.st_size);
> 	for (i = 0; i < 3; i++)
> 		printf("%llu%s", phys(f1, (unsigned long long)i * blksz),
> 		       i == 2 ? "]\n" : "] [");
> }
> 
> static int mkfile(const char *name, char fill, int blocks)
> {
> 	char *buf;
> 	int fd;
> 
> 	unlink(name);
> 	fd = open(name, O_RDWR | O_CREAT | O_EXCL, 0600);
> 	if (fd < 0)
> 		return fprintf(stderr, "open %s: %m\n", name), -1;
> 	buf = malloc(blocks * blksz);
> 	memset(buf, fill, blocks * blksz);
> 	if (pwrite(fd, buf, blocks * blksz, 0) != (ssize_t)(blocks * blksz))
> 		return fprintf(stderr, "pwrite %s: %m\n", name), -1;
> 	free(buf);
> 	fsync(fd);
> 	return fd;
> }
> 
> int main(void)
> {
> 	struct xfs_exchange_range xr;
> 	struct file_clone_range cr;
> 	struct xfs_swapext sx;
> 	char before[65536], after[65536], *buf;
> 	struct statfs sfs;
> 	struct stat st;
> 	int d1, d2;
> 
> 	if (statfs(".", &sfs))
> 		return fprintf(stderr, "statfs: %m\n"), 2;
> 	blksz = sfs.f_bsize;
> 
> 	peer = open("peer", O_RDONLY);
> 	if (peer < 0)
> 		return fprintf(stderr, "open peer: %m\n"), 2;
> 	fstat(peer, &st);
> 	printf("peer uid %u mode %04o size %lld, block size %lu\n\n",
> 	       st.st_uid, st.st_mode & 07777, (long long)st.st_size, blksz);
> 	if (pread(peer, before, blksz, 0) != (ssize_t)blksz)
> 		return fprintf(stderr, "read peer: %m\n"), 2;
> 	syncfs(peer);	/* so FIEMAP reports peer's real block */
> 
> 	f1 = mkfile("file1", 'A', 3);
> 	d1 = mkfile("donor1", 'B', 1);
> 	d2 = mkfile("donor2", 'C', 1);
> 	if (f1 < 0 || d1 < 0 || d2 < 0)
> 		return 2;
> 	show("start");
> 
> 	/* 1. share peer's block into the middle of file1 */
> 	cr = (struct file_clone_range){ .src_fd = peer, .src_offset = 0,
> 					.src_length = blksz,
> 					.dest_offset = blksz };
> 	if (ioctl(f1, FICLONERANGE, &cr))
> 		return fprintf(stderr, "FICLONERANGE: %m\n"), 2;
> 	show("1 FICLONERANGE");
> 
> 	/*
> 	 * 2. exchange file1's last block against the whole of donor1 with
> 	 * TO_EOF.  The sizes are exchanged too, so file1 claims one block
> 	 * while still owning three.  file2_offset is block 2, so this exchange
> 	 * cannot clear a reflink flag.
> 	 */
> 	xr = (struct xfs_exchange_range){ .file1_fd = d1, .file1_offset = 0,
> 					  .file2_offset = 2 * blksz,
> 					  .length = 0,
> 					  .flags = XFS_EXCHANGE_RANGE_TO_EOF };
> 	if (ioctl(f1, XFS_IOC_EXCHANGE_RANGE, &xr))
> 		return fprintf(stderr, "EXCHANGE_RANGE TO_EOF: %m\n"), 2;
> 	show("2 EXCHANGE_RANGE TO_EOF");
> 
> 	/*
> 	 * 3. XFS_IOC_SWAPEXT with file1 as the target.  sx_offset is 0 and
> 	 * sx_length equals both inodes' i_disk_size, so the "Verify all data
> 	 * are being swapped" test passes.  xfs_swap_extent_rmap() then bounds
> 	 * its remap loop with XFS_B_TO_FSB(mp, i_size_read(VFS_I(ip))), which
> 	 * is one block, so file1's two mappings above its size are left in
> 	 * place -- and the reflink flags are swapped anyway, clearing file1's.
> 	 */
> 	fsync(f1);
> 	fsync(d2);
> 	if (fstat(f1, &st))
> 		return fprintf(stderr, "fstat file1: %m\n"), 2;
> 	memset(&sx, 0, sizeof sx);
> 	sx.sx_version		= XFS_SX_VERSION;
> 	sx.sx_fdtarget		= f1;
> 	sx.sx_fdtmp		= d2;
> 	sx.sx_offset		= 0;
> 	sx.sx_length		= st.st_size;
> 	sx.sx_stat.bs_mtime.tv_sec  = st.st_mtim.tv_sec;
> 	sx.sx_stat.bs_mtime.tv_nsec = st.st_mtim.tv_nsec;
> 	sx.sx_stat.bs_ctime.tv_sec  = st.st_ctim.tv_sec;
> 	sx.sx_stat.bs_ctime.tv_nsec = st.st_ctim.tv_nsec;
> 	if (ioctl(f1, XFS_IOC_SWAPEXT, &sx))
> 		return fprintf(stderr, "SWAPEXT: %m\n"), 2;
> 	show("3 SWAPEXT");
> 
> 	/* 4. write to the block file1 still shares with peer */
> 	buf = malloc(blksz);
> 	memset(buf, 'X', blksz);
> 	if (pwrite(f1, buf, blksz, blksz) != (ssize_t)blksz)
> 		return fprintf(stderr, "pwrite: %m\n"), 2;
> 	fsync(f1);
> 	show("4 pwrite(file1, 4096)");
> 
> 	posix_fadvise(peer, 0, 0, POSIX_FADV_DONTNEED);
> 	if (pread(peer, after, blksz, 0) != (ssize_t)blksz)
> 		return fprintf(stderr, "re-read peer: %m\n"), 2;
> 	printf("\npeer first byte %c -> %c   %s\n", before[0], after[0],
> 	       memcmp(before, after, blksz) ? "PEER REWRITTEN" : "peer intact");
> 	return memcmp(before, after, blksz) ? 0 : 1;
> }
> 
> 
