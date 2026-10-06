Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90F094CEE52
	for <linux-xfs@vger.kernel.org>; Tue,  6 Oct 2026 22:53:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791327223; cv=none; b=cd5tS9KJGA9dEqobM3Hnwgs4CpWaRAv17ROaR9BdeMecnDYxPeGVQe+wYcpw0PGt2fai8pP8A0JQUeN0DD06hhcRhIpq+rkMmii0B94Q04oCFOO3+eJtWYATryr99CgxwQiRGfF0hVT9h6essM7DpqUVcQBui9tqNQ+tdrecZlk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791327223; c=relaxed/simple;
	bh=KPEF/D04XmU/PHl7M5Q7f5/vK6hK66BFDoPZ58Plb6A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mTCEwn0QVmYMlGiQriNzTJLCckQJdIJMy7kSFpcFF8f1BdoBC790QXYc0KnJeqer8XAZNHwoaTyllqIpm4FE7DlQOpcuC781OjqjHUj8+FuigxCNVru5I/F54cXdWJrhCrrYXor3Ppnax1lqqqBuxxCREimtzh04yIbHBKD3ig4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Vty8+VsZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Vty8+VsZ"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 6BCE61F0089C;
	Tue,  6 Oct 2026 22:43:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791326615;
	bh=9uvZhY/WNoKtDKSUcpL3GWKQCwZ3ydrQt2jnYJ13BLw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Vty8+VsZfLaINf8WLOCV29lx4psa3xUsOnmPc3wtmOCLPaGV6UrlcN505U/l1HLyO
	 mWCKlzn15r/zx8CeuI0DQ63WohaRuYesgZEXjdWmOuAC87oPCQCcXYzOT8qUVu04ae
	 WZyKKMxxqbdyu+zwNN5heFnt7a6cPpIr4vPTuagVztRvHJBkVBvLfStF+jvT8r7NN1
	 oCv7zJjMqcxFB2qnxA2Nqx+2udvr0QoGBV4mPlsTvxePzt94GP3xxIE4pTsJLYZaUC
	 qUx8bOFJdhpNPxUbwCr67w4AAYZ8YjXOu3FHAiXBj1r0ixi1vyIFYdwrtVpg4zeLeW
	 UhKjuzj5yVlcA==
Date: Tue, 6 Oct 2026 15:43:34 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Norbert Szetei <norbert@doyensec.com>
Cc: Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org,
	Christoph Hellwig <hch@infradead.org>,
	Dave Chinner <dgc@kernel.org>
Subject: Re: [PATCH] xfs: fix exchange-range-to-eof file size exchange
Message-ID: <20261006224334.GZ2705364@frogsfrogsfrogs>
References: <20261006050914.GU2705364@frogsfrogsfrogs>
 <471DF337-49EB-46CE-B07F-45D09B899E8B@doyensec.com>
 <20261006214749.GQ1615495@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261006214749.GQ1615495@frogsfrogsfrogs>

On Tue, Oct 06, 2026 at 02:47:49PM -0700, Darrick J. Wong wrote:
> On Tue, Oct 06, 2026 at 10:02:26PM +0200, Norbert Szetei wrote:
> > On Oct 6, 2026, at 07:09, Darrick J. Wong <djwong@kernel.org> wrote:
> > > 
> > > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > Thanks for picking this up so fast, and for porting the reproducer to 
> > fstests.
> > 
> > > Once the file sizes are set correctly, the second exchange-range no
> > > longer thinks that it's doing a full-contents swap, so it won't clear
> > > the reflink flag on either of its file arguments.
> > 
> > The offsets are bounded against the incore i_size but subtracted from the
> > ondisk i_disk_size, so a file that has not been written back gives
> > xmi_isize1 = 0 + (0 - 12288).
> 
> <groan> How do we fix this??
> 
> --D
> 
> > For instance, you can do:
> > 
> > 	$ xfs_io -f -c "pwrite -q 0 4096" -c fsync file1
> > 	$ xfs_io -f -c "pwrite -q 0 12288" \
> > 		-c "exchangerange -s 0 -d 12288 file1" dirty
> > 	$ stat -c %s file1
> > 	0
> > 	$ stat -c %i file1
> > 	131
> > 	$ sudo xfs_io -r -c "bulkstat_single 131" . | grep bs_size
> > 		bs_size = 18446744073709539328
> > 
> > The reflink flag could be cleared too.
> > 
> > Start:
> > 	peer    size  4096                       -> [100]
> > 	file1   size 12288                       -> [200] [201] [202]
> > 	dirty   i_size 4096   i_disk_size 0
> > 	donor   size  4096                       -> [300]
> > 
> > 1. FICLONERANGE peer's block into file1's middle block:
> > 
> > 	peer    size  4096                       -> [100]
> > 	file1   size 12288   reflink flag set    -> [200] [100] [202]
> > 	                                                  ^^^^^
> > 	                                      both files own block 100
> > 
> > 2. EXCHANGE_RANGE file1 against dirty, file1_offset 8192,
> >    file2_offset 4096, length 0, TO_EOF:
> > 
> > 	length = max(12288 - 8192, 4096 - 4096) = 4096
> > 	dirty's flush range [4096, 8191] is past its EOF, nothing written
> > 	back, so i_disk_size is still 0:
> > 
> > 	xmi_isize1 = 8192 + (0 - 4096) = 4096
> > 
> > 	file1   i_size 8192  i_disk_size 4096    -> [200] [100] hole
> > 	                                ^^^^
> > 	           one block by the size, two are mapped, and the second
> > 	           one is shared with peer

All right.  It looks like the simple answer is to flush all the dirty
data in the pagecache if TO_EOF is set, that way the file size update
logic works correctly.

As for the !TO_EOF case, I think we should flush all the dirty data
between the ondisk i_disk_size all the way to the end of the range being
exchanged to avoid weird post-crash file contents such as:

file1: A B
file2: C D
(don't flush anything else)

The exchange of B and D will flush those two blocks to disk, but not
A or C.  If we crash just after committing the exchange, after recovery
the files will be:

file1: _ B
file2: _ D

(where "_" is a sparse hole with zeroes)

That also probably wasn't what the user wanted.

Thanks also for the second reproducer, I've incorporated that into the
testcase.  With the above flush change, it no longer trips the obviously
overhuge file size thing you noted, and the corruption goes away.

Obviously, applying your patch to kill the reflink flag clearing also
makes the corruption stop.

--D

> > 
> > 3. EXCHANGE_RANGE file1 against donor, both offsets 0, length 4096.  By
> >    i_disk_size this is two one-block files exchanging everything, so
> >    xmi_can_exchange_reflink_flags() agrees:
> > 
> > 	file1   i_disk_size 4096  reflink CLEARED -> [300] [100] hole
> > 	donor                                     -> [200]
> > 
> >    Block 100 is still shared with peer.
> > 
> > 4. pwrite(file1, 4096, 4096), file1's second block.
> >    xfs_is_cow_inode(file1) is false, so no CoW:
> > 
> > 	peer    size 4096                        -> [100] new contents
> > 
> > 
> > PoC, run after applying your fix:
> > 
> > $ head -c 4096 /dev/zero | tr '\0' 'P' > peer
> > $ sudo chown root:root peer && sudo chmod 0644 peer
> > $ ./xfs_exchrange_reflink_after_fix
> > 
> > peer uid 0 mode 0644 size 4096, block size 4096
> > 
> > start                        peer [32]   file1 isize 12288  [13] [14] [15]
> > 1 FICLONERANGE               peer [32]   file1 isize 12288  [13] [32] [15]
> > 2 EXCHANGE_RANGE TO_EOF      peer [32]   file1 isize  8192  [13] [32] [0]
> > 3 EXCHANGE_RANGE             peer [32]   file1 isize  8192  [24] [32] [0]
> > 4 pwrite(file1, blksz)       peer [32]   file1 isize  8192  [24] [32] [0]
> > 
> > peer first byte P -> X   PEER REWRITTEN
> > 
> > Content of xfs_exchrange_reflink_after_fix.c:
> > 
> > // SPDX-License-Identifier: GPL-2.0
> > /*
> >  * Clears XFS_DIFLAG2_REFLINK from a file that still owns a shared block, on a
> >  * kernel carrying "xfs: fix exchange-range-to-eof file size exchange".
> >  *
> >  * Needs reflink=1 and exchange=1, and a readable file called "peer" in the
> >  * current directory.  Brackets are physical block numbers from FIEMAP.
> >  * Exits 0 if peer was rewritten, 1 if it survived, 2 on a setup error.
> >  */
> > #define _GNU_SOURCE
> > #include <stdio.h>
> > #include <stdlib.h>
> > #include <string.h>
> > #include <unistd.h>
> > #include <fcntl.h>
> > #include <sys/ioctl.h>
> > #include <sys/stat.h>
> > #include <sys/vfs.h>
> > #include <linux/fs.h>
> > #include <linux/fiemap.h>
> > #include <errno.h>
> > 
> > #ifndef FICLONERANGE
> > #define FICLONERANGE _IOW(0x94, 13, struct file_clone_range)
> > #endif
> > 
> > /* fs/xfs/libxfs/xfs_fs.h */
> > struct xfs_exchange_range {
> > 	__s32		file1_fd;
> > 	__u32		pad;
> > 	__u64		file1_offset;
> > 	__u64		file2_offset;
> > 	__u64		length;
> > 	__u64		flags;
> > };
> > #define XFS_IOC_EXCHANGE_RANGE		_IOW('X', 129, struct xfs_exchange_range)
> > #define XFS_EXCHANGE_RANGE_TO_EOF	(1ULL << 0)
> > 
> > 
> > static unsigned long blksz;
> > static int peer, f1;
> > 
> > static unsigned long long phys(int fd, unsigned long long off)
> > {
> > 	struct { struct fiemap f; struct fiemap_extent e[1]; } q;
> > 
> > 	memset(&q, 0, sizeof q);
> > 	q.f.fm_start = off;
> > 	q.f.fm_length = blksz;
> > 	q.f.fm_extent_count = 1;
> > 	if (ioctl(fd, FS_IOC_FIEMAP, &q.f) || q.f.fm_mapped_extents < 1)
> > 		return 0;
> > 	return (q.e[0].fe_physical + (off - q.e[0].fe_logical)) / blksz;
> > }
> > 
> > static void show(const char *tag)
> > {
> > 	struct stat st;
> > 	int i;
> > 
> > 	fstat(f1, &st);
> > 	printf("%-28s peer [%llu]   file1 isize %5lld  [", tag, phys(peer, 0),
> > 	       (long long)st.st_size);
> > 	for (i = 0; i < 3; i++)
> > 		printf("%llu%s", phys(f1, (unsigned long long)i * blksz),
> > 		       i == 2 ? "]\n" : "] [");
> > }
> > 
> > /* fsync == 0 leaves every block dirty, so i_disk_size stays 0 */
> > static int mkfile(const char *name, char fill, int blocks, int do_fsync)
> > {
> > 	char *buf;
> > 	int fd;
> > 
> > 	unlink(name);
> > 	fd = open(name, O_RDWR | O_CREAT | O_EXCL, 0600);
> > 	if (fd < 0)
> > 		return fprintf(stderr, "open %s: %m\n", name), -1;
> > 	buf = malloc((size_t)blocks * blksz);
> > 	memset(buf, fill, (size_t)blocks * blksz);
> > 	if (pwrite(fd, buf, (size_t)blocks * blksz, 0) !=
> > 	    (ssize_t)((size_t)blocks * blksz))
> > 		return fprintf(stderr, "pwrite %s: %m\n", name), -1;
> > 	free(buf);
> > 	if (do_fsync)
> > 		fsync(fd);
> > 	return fd;
> > }
> > 
> > static int exchange(int fd2, int fd1, unsigned long long off1,
> > 		    unsigned long long off2, unsigned long long len,
> > 		    unsigned long long flags, const char *what)
> > {
> > 	struct xfs_exchange_range xr;
> > 
> > 	memset(&xr, 0, sizeof xr);
> > 	xr.file1_fd = fd1;
> > 	xr.file1_offset = off1;
> > 	xr.file2_offset = off2;
> > 	xr.length = len;
> > 	xr.flags = flags;
> > 	if (ioctl(fd2, XFS_IOC_EXCHANGE_RANGE, &xr)) {
> > 		fprintf(stderr, "%s: %m\n", what);
> > 		return -1;
> > 	}
> > 	return 0;
> > }
> > 
> > int main(void)
> > {
> > 	struct file_clone_range cr;
> > 	char before[65536], after[65536], *buf;
> > 	struct statfs sfs;
> > 	struct stat st;
> > 	int dirty, d2;
> > 
> > 	if (statfs(".", &sfs))
> > 		return fprintf(stderr, "statfs: %m\n"), 2;
> > 	if (sfs.f_type != 0x58465342)	/* XFS_SUPER_MAGIC */
> > 		return fprintf(stderr,
> > 			"this directory is not on XFS (statfs type 0x%lx)\n",
> > 			(unsigned long)sfs.f_type), 2;
> > 	blksz = sfs.f_bsize;
> > 	if (blksz < 512 || blksz > 65536)
> > 		return fprintf(stderr, "unexpected block size %lu\n", blksz), 2;
> > 
> > 	peer = open("peer", O_RDONLY);
> > 	if (peer < 0)
> > 		return fprintf(stderr, "open peer: %m\n"), 2;
> > 	if (fstat(peer, &st))
> > 		return fprintf(stderr, "fstat peer: %m\n"), 2;
> > 	printf("peer uid %u mode 0%o size %lld, block size %lu\n",
> > 	       st.st_uid, st.st_mode & 07777, (long long)st.st_size, blksz);
> > 	if ((unsigned long)st.st_size < blksz)
> > 		return fprintf(stderr,
> > 			"peer must be at least one block\n"), 2;
> > 	if (pread(peer, before, blksz, 0) != (ssize_t)blksz)
> > 		return fprintf(stderr, "pread peer: %m\n"), 2;
> > 	syncfs(peer);
> > 
> > 	/* file1: three blocks, clean, so its own i_disk_size is honest */
> > 	f1 = mkfile("file1", 'A', 3, 1);
> > 	if (f1 < 0)
> > 		return 2;
> > 	/* the lever: one block, entirely dirty, i_disk_size == 0 */
> > 	dirty = mkfile("dirty", 'D', 1, 0);
> > 	if (dirty < 0)
> > 		return 2;
> > 	d2 = mkfile("donor2", 'E', 1, 1);
> > 	if (d2 < 0)
> > 		return 2;
> > 	printf("\n");
> > 	show("start");
> > 
> > 	/* share peer's block into file1's middle block */
> > 	memset(&cr, 0, sizeof cr);
> > 	cr.src_fd = peer;
> > 	cr.src_offset = 0;
> > 	cr.src_length = blksz;
> > 	cr.dest_offset = blksz;
> > 	if (ioctl(f1, FICLONERANGE, &cr)) {
> > 		fprintf(stderr, "FICLONERANGE: %m\n");
> > 		if (errno == EOPNOTSUPP)
> > 			fprintf(stderr,
> > 				"this filesystem needs reflink=1, check xfs_info\n");
> > 		return 2;
> > 	}
> > 	show("1 FICLONERANGE");
> > 
> > 	/*
> > 	 * ip1 = file1, ip2 = dirty.  off2 == i_size(dirty) == blksz, so
> > 	 *	length = max(3*blksz - 2*blksz, blksz - blksz) = blksz
> > 	 * and dirty's flush range [blksz, 2*blksz) is entirely past its EOF,
> > 	 * so its page cache is never written back and i_disk_size stays 0:
> > 	 *	isize1 = 2*blksz + (0 - blksz) = blksz
> > 	 * file1's ondisk size becomes one block while it still owns the
> > 	 * shared block at offset blksz.
> > 	 */
> > 	if (exchange(dirty, f1, 2 * blksz, blksz, 0,
> > 		     XFS_EXCHANGE_RANGE_TO_EOF, "exchange TO_EOF"))
> > 		return 2;
> > 	show("2 EXCHANGE_RANGE TO_EOF");
> > 
> > 	/*
> > 	 * By i_disk_size file1 is now a one-block file, so this looks like a
> > 	 * full-contents exchange of two one-block files and
> > 	 * xmi_can_exchange_reflink_flags() clears the flag.
> > 	 */
> > 	if (exchange(f1, d2, 0, 0, blksz, 0, "exchange flag-clear"))
> > 		return 2;
> > 	show("3 EXCHANGE_RANGE");
> > 
> > 	/* in-place write to the still-shared block */
> > 	buf = malloc(blksz);
> > 	memset(buf, 'X', blksz);
> > 	if (pwrite(f1, buf, blksz, blksz) != (ssize_t)blksz)
> > 		return fprintf(stderr, "pwrite file1: %m\n"), 2;
> > 	fsync(f1);
> > 	show("4 pwrite(file1, blksz)");
> > 
> > 	posix_fadvise(peer, 0, 0, POSIX_FADV_DONTNEED);
> > 	if (pread(peer, after, blksz, 0) != (ssize_t)blksz)
> > 		return fprintf(stderr, "pread peer: %m\n"), 2;
> > 	printf("\npeer first byte %c -> %c   %s\n", before[0], after[0],
> > 	       memcmp(before, after, blksz) ? "PEER REWRITTEN" : "peer intact");
> > 	return memcmp(before, after, blksz) ? 0 : 1;
> > }
> > 
> > N.
> > 
> > > Link: https://lore.kernel.org/linux-xfs/1E196589-DEBE-40AC-AFEA-D420DAAB067F@doyensec.com/
> > > Reported-by: Norbert Szetei <norbert@doyensec.com>
> > > Cc: <stable@vger.kernel.org> # v6.10
> > > Fixes: 966ceafc7a4371 ("xfs: create deferred log items for file mapping exchanges")
> > > Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
> > > ---
> > > fs/xfs/libxfs/xfs_exchmaps.c |    8 ++++++--
> > > fs/xfs/xfs_exchrange.c       |   10 ++++++----
> > > 2 files changed, 12 insertions(+), 6 deletions(-)
> > > 
> > > diff --git a/fs/xfs/libxfs/xfs_exchmaps.c b/fs/xfs/libxfs/xfs_exchmaps.c
> > > index 6a66b6075e0af4..c9d9464e9d39f5 100644
> > > --- a/fs/xfs/libxfs/xfs_exchmaps.c
> > > +++ b/fs/xfs/libxfs/xfs_exchmaps.c
> > > @@ -987,6 +987,7 @@ xfs_exchmaps_init_intent(
> > > const struct xfs_exchmaps_req *req)
> > > {
> > > struct xfs_exchmaps_intent *xmi;
> > > + struct xfs_mount *mp = req->ip1->i_mount;
> > > unsigned int rs = 0;
> > > 
> > > xmi = kmem_cache_zalloc(xfs_exchmaps_intent_cache,
> > > @@ -1006,9 +1007,12 @@ xfs_exchmaps_init_intent(
> > > }
> > > 
> > > if (req->flags & XFS_EXCHMAPS_SET_SIZES) {
> > > + loff_t off1 = XFS_FSB_TO_B(mp, xmi->xmi_startoff1);
> > > + loff_t off2 = XFS_FSB_TO_B(mp, xmi->xmi_startoff2);
> > > +
> > > xmi->xmi_flags |= XFS_EXCHMAPS_SET_SIZES;
> > > - xmi->xmi_isize1 = req->ip2->i_disk_size;
> > > - xmi->xmi_isize2 = req->ip1->i_disk_size;
> > > + xmi->xmi_isize1 = off1 + (req->ip2->i_disk_size - off2);
> > > + xmi->xmi_isize2 = off2 + (req->ip1->i_disk_size - off1);
> > > }
> > > 
> > > /* Record the state of each inode's reflink flag before the op. */
> > > diff --git a/fs/xfs/xfs_exchrange.c b/fs/xfs/xfs_exchrange.c
> > > index fafb4e3f065c75..a4016116f5f1a9 100644
> > > --- a/fs/xfs/xfs_exchrange.c
> > > +++ b/fs/xfs/xfs_exchrange.c
> > > @@ -296,11 +296,13 @@ xfs_exchrange_mappings(
> > > * the mappings, and updated the ondisk sizes.
> > > */
> > > if (fxr->flags & XFS_EXCHANGE_RANGE_TO_EOF) {
> > > - loff_t temp;
> > > + loff_t old_ip1_size = i_size_read(VFS_I(ip1));
> > > + loff_t old_ip2_size = i_size_read(VFS_I(ip2));
> > > 
> > > - temp = i_size_read(VFS_I(ip2));
> > > - i_size_write(VFS_I(ip2), i_size_read(VFS_I(ip1)));
> > > - i_size_write(VFS_I(ip1), temp);
> > > + i_size_write(VFS_I(ip2), fxr->file2_offset +
> > > + (old_ip1_size - fxr->file1_offset));
> > > + i_size_write(VFS_I(ip1), fxr->file1_offset +
> > > + (old_ip2_size - fxr->file2_offset));
> > > }
> > > 
> > > out_unlock:
> > 
> 
