Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com [209.85.208.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B4C837269C
	for <linux-xfs@vger.kernel.org>; Tue,  6 Oct 2026 20:02:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791316965; cv=none; b=CMRy2aKrSwmxbtOA+GK5x7Bi17SSE254EhR6+5rq/N7h5vIwz3klqhpcoBOKsuSwooWLrZAj1LKY2tM4pInxuBMtfi9mZaqTziIw08EwqbCb/pVwOACPYcLjersyVgg/HElgC6XQdNCRtvNU7yqX2oQbJutc71aKR9Tp9WcBj9k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791316965; c=relaxed/simple;
	bh=0nycPlonUyk22YX2yqIWStJH4IcrSt+sB8tqsFxINpc=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=XmigF6H54yNIS06yqtnoi1X/j014QlJR5Ga/08mMMutQQ8yWDYID3puZTP4Vu5FD4NrWBa9yK99G2PIwZv00h79v+RzFiH166mACdKHH0RIWr9Sw4nqsO6XmJ1EcSt8QDON0jNeE9FNKmIHrNb9PgLVcuiIRDqXcxiJRwBSBcBI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=doyensec.com; spf=pass smtp.mailfrom=doyensec.com; dkim=pass (2048-bit key) header.d=doyensec.com header.i=@doyensec.com header.b=YVAisZaF; arc=none smtp.client-ip=209.85.208.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=doyensec.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=doyensec.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=doyensec.com header.i=@doyensec.com header.b="YVAisZaF"
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-6ae14eecc64so4541902a12.1
        for <linux-xfs@vger.kernel.org>; Tue, 06 Oct 2026 13:02:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=doyensec.com; s=google; t=1791316960; x=1791921760; darn=vger.kernel.org;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:content-type:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=XRsYx3Mq4flRG4hImQJdZfl51viVfoPdWGNO3W9oNuo=;
        b=YVAisZaFqvh1VrPhRSVvTvgw3a5BXTSCP/FDBiw9qj83v/iJHcnXE3Se41n9qKj0Kh
         zFdgw2LFnN0rxYh/9cPuIxbu5JFeH9Mi4fnZnh2cr7Wgle+gfXbVljK6eSEk6QHixpeI
         9ePBCgFphD5ik7X4vHJzCT5nE8sCOxHox6VF3L3GsKA799lW4imyogWftqa/1rGiY4av
         65XaOwbX/nbwqKs9iL1+awcXTKJPXxnPSIpWL+65tGXDv+9IrVB3m7foGssbz2kOCWI2
         bUoX+YxCRXh8ZA6sSiDyqoATJEhblEcHM/SzG2TiZxB92iZ6TqO8rF/zkvu3V0PKEDEZ
         b+VA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791316960; x=1791921760;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:content-type:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=XRsYx3Mq4flRG4hImQJdZfl51viVfoPdWGNO3W9oNuo=;
        b=lBHINuqj7HyoaZp+79n3+IILrQTAMOvxbzwSOg2l74T7e2WRuMabp6aMSAe7lWFd/n
         rwfSy/lviEIJVw4jUaEMNSUJHUS1iX3xp7/xx3Pc173qr9xA9Fy40XNl6enG6y9OtnQ2
         RFAWjPLEoY6IcHuQFmL9cja1mZCfAT9MEOw4NupK1saRpnwEA4lJdoA2mtb8qIQnXAxW
         1djS0L2t9TPYyB6oz/yA9Mbgo0f/wi65/UOqt2eq2UL7hdQnzo8Emt+ylu+8IeidddLW
         aYjACFB1cS7s34aOAg42RAAKAqqwjnkLmCZrsgOLSGs6/akU1+SGYMhnbW+4AxdjxCO2
         hMDw==
X-Forwarded-Encrypted: i=1; AKwUvBwmKzo2K2ORj1UUDE9NWQCur0rKIq04fz90zehXz01TD1uQ9fBwhyWwJYTw/x9jGk7Puxmz1Mz4dU8=@vger.kernel.org
X-Gm-Message-State: AFq9FYKX/ZtO3QZEy5vrhnhPo5QoHo7JxjbTwiIwvZ5PNXZ9fS2BH52N
	jX1Mbk32Uq/VwTb9f8myLKAMiCdvnLdG4ZfsYQSDA+ZMqEov0KTgPmBhTxZh6p4kr4A=
X-Gm-Gg: AYBFou2HK3f3dS1uAoBcYM8GVZpFgnvhxVurWSu5esVT2YJcX9oLJNKBhXcxa6eaogW
	CXcbr8Nan3/3loxcvmDBsT1CRCWXTkSLRjnny9DPJ2N7Z3trK69VB4Xteqc5K6vfHJnfV0lPhKf
	KJBDrIxgpNGjA6ApeWvhjuMN6q/vG3N42fz8q1xcCewp95U327rgtDugtWgr9W8d5hqL3jRZBxZ
	slP/6j/V3occ3k8ARKSw4LQzO3seAPIhRlF0WT2QD+zV3aNmvW/J3vqvXqMh1OWVkkltPvqnYVH
	+YV5H8EZ+9+h0QuG/UDJrmduUhgOVA0VQxnZdI3VBs5aYwQHd0ADz36RrNAwv4T6q2DtpvOTE+M
	2xANURYvdHUzwdkIiBfOBReINsKvSqL7sfDAQnACKEACFX6ijHCQO2WivneqpENipfq/fq310Zf
	hOEcN4fd1CMu20omAeCWdxYEt+vbLxSS1qOnDt0cL0RVUivC22VhnCotyjJaEtqPLcpcGE2V2i6
	0KWNR/5YZizRrTpb8YLT/n4qQzvzPJnzA6FC2mD65r+ml1VBhiMzurMkefgClxx2CCvc5Q+
X-Received: by 2002:a05:6402:2382:b0:6ac:73f8:2e40 with SMTP id 4fb4d7f45d1cf-6aff38ff7d8mr153932a12.27.1791316959714;
        Tue, 06 Oct 2026 13:02:39 -0700 (PDT)
Received: from smtpclient.apple (80.49.145.194.ipv4.supernova.orange.pl. [80.49.145.194])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6aff2e373c6sm78252a12.21.2026.10.06.13.02.37
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 06 Oct 2026 13:02:38 -0700 (PDT)
Content-Type: text/plain;
	charset=us-ascii
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.700.51.1.1\))
Subject: Re: [PATCH] xfs: fix exchange-range-to-eof file size exchange
From: Norbert Szetei <norbert@doyensec.com>
In-Reply-To: <20261006050914.GU2705364@frogsfrogsfrogs>
Date: Tue, 6 Oct 2026 22:02:26 +0200
Cc: Carlos Maiolino <cem@kernel.org>,
 linux-xfs@vger.kernel.org,
 Christoph Hellwig <hch@infradead.org>,
 Dave Chinner <dgc@kernel.org>
Content-Transfer-Encoding: quoted-printable
Message-Id: <471DF337-49EB-46CE-B07F-45D09B899E8B@doyensec.com>
References: <20261006050914.GU2705364@frogsfrogsfrogs>
To: "Darrick J. Wong" <djwong@kernel.org>
X-Mailer: Apple Mail (2.3864.700.51.1.1)

On Oct 6, 2026, at 07:09, Darrick J. Wong <djwong@kernel.org> wrote:
>=20
> From: Darrick J. Wong <djwong@kernel.org>

Thanks for picking this up so fast, and for porting the reproducer to=20
fstests.

> Once the file sizes are set correctly, the second exchange-range no
> longer thinks that it's doing a full-contents swap, so it won't clear
> the reflink flag on either of its file arguments.

The offsets are bounded against the incore i_size but subtracted from =
the
ondisk i_disk_size, so a file that has not been written back gives
xmi_isize1 =3D 0 + (0 - 12288).

For instance, you can do:

	$ xfs_io -f -c "pwrite -q 0 4096" -c fsync file1
	$ xfs_io -f -c "pwrite -q 0 12288" \
		-c "exchangerange -s 0 -d 12288 file1" dirty
	$ stat -c %s file1
	0
	$ stat -c %i file1
	131
	$ sudo xfs_io -r -c "bulkstat_single 131" . | grep bs_size
		bs_size =3D 18446744073709539328

The reflink flag could be cleared too.

Start:
	peer    size  4096                       -> [100]
	file1   size 12288                       -> [200] [201] [202]
	dirty   i_size 4096   i_disk_size 0
	donor   size  4096                       -> [300]

1. FICLONERANGE peer's block into file1's middle block:

	peer    size  4096                       -> [100]
	file1   size 12288   reflink flag set    -> [200] [100] [202]
	                                                  ^^^^^
	                                      both files own block 100

2. EXCHANGE_RANGE file1 against dirty, file1_offset 8192,
   file2_offset 4096, length 0, TO_EOF:

	length =3D max(12288 - 8192, 4096 - 4096) =3D 4096
	dirty's flush range [4096, 8191] is past its EOF, nothing =
written
	back, so i_disk_size is still 0:

	xmi_isize1 =3D 8192 + (0 - 4096) =3D 4096

	file1   i_size 8192  i_disk_size 4096    -> [200] [100] hole
	                                ^^^^
	           one block by the size, two are mapped, and the second
	           one is shared with peer

3. EXCHANGE_RANGE file1 against donor, both offsets 0, length 4096.  By
   i_disk_size this is two one-block files exchanging everything, so
   xmi_can_exchange_reflink_flags() agrees:

	file1   i_disk_size 4096  reflink CLEARED -> [300] [100] hole
	donor                                     -> [200]

   Block 100 is still shared with peer.

4. pwrite(file1, 4096, 4096), file1's second block.
   xfs_is_cow_inode(file1) is false, so no CoW:

	peer    size 4096                        -> [100] new contents


PoC, run after applying your fix:

$ head -c 4096 /dev/zero | tr '\0' 'P' > peer
$ sudo chown root:root peer && sudo chmod 0644 peer
$ ./xfs_exchrange_reflink_after_fix

peer uid 0 mode 0644 size 4096, block size 4096

start                        peer [32]   file1 isize 12288  [13] [14] =
[15]
1 FICLONERANGE               peer [32]   file1 isize 12288  [13] [32] =
[15]
2 EXCHANGE_RANGE TO_EOF      peer [32]   file1 isize  8192  [13] [32] =
[0]
3 EXCHANGE_RANGE             peer [32]   file1 isize  8192  [24] [32] =
[0]
4 pwrite(file1, blksz)       peer [32]   file1 isize  8192  [24] [32] =
[0]

peer first byte P -> X   PEER REWRITTEN

Content of xfs_exchrange_reflink_after_fix.c:

// SPDX-License-Identifier: GPL-2.0
/*
 * Clears XFS_DIFLAG2_REFLINK from a file that still owns a shared =
block, on a
 * kernel carrying "xfs: fix exchange-range-to-eof file size exchange".
 *
 * Needs reflink=3D1 and exchange=3D1, and a readable file called "peer" =
in the
 * current directory.  Brackets are physical block numbers from FIEMAP.
 * Exits 0 if peer was rewritten, 1 if it survived, 2 on a setup error.
 */
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
#include <errno.h>

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
#define XFS_IOC_EXCHANGE_RANGE		_IOW('X', 129, struct =
xfs_exchange_range)
#define XFS_EXCHANGE_RANGE_TO_EOF	(1ULL << 0)


static unsigned long blksz;
static int peer, f1;

static unsigned long long phys(int fd, unsigned long long off)
{
	struct { struct fiemap f; struct fiemap_extent e[1]; } q;

	memset(&q, 0, sizeof q);
	q.f.fm_start =3D off;
	q.f.fm_length =3D blksz;
	q.f.fm_extent_count =3D 1;
	if (ioctl(fd, FS_IOC_FIEMAP, &q.f) || q.f.fm_mapped_extents < 1)
		return 0;
	return (q.e[0].fe_physical + (off - q.e[0].fe_logical)) / blksz;
}

static void show(const char *tag)
{
	struct stat st;
	int i;

	fstat(f1, &st);
	printf("%-28s peer [%llu]   file1 isize %5lld  [", tag, =
phys(peer, 0),
	       (long long)st.st_size);
	for (i =3D 0; i < 3; i++)
		printf("%llu%s", phys(f1, (unsigned long long)i * =
blksz),
		       i =3D=3D 2 ? "]\n" : "] [");
}

/* fsync =3D=3D 0 leaves every block dirty, so i_disk_size stays 0 */
static int mkfile(const char *name, char fill, int blocks, int do_fsync)
{
	char *buf;
	int fd;

	unlink(name);
	fd =3D open(name, O_RDWR | O_CREAT | O_EXCL, 0600);
	if (fd < 0)
		return fprintf(stderr, "open %s: %m\n", name), -1;
	buf =3D malloc((size_t)blocks * blksz);
	memset(buf, fill, (size_t)blocks * blksz);
	if (pwrite(fd, buf, (size_t)blocks * blksz, 0) !=3D
	    (ssize_t)((size_t)blocks * blksz))
		return fprintf(stderr, "pwrite %s: %m\n", name), -1;
	free(buf);
	if (do_fsync)
		fsync(fd);
	return fd;
}

static int exchange(int fd2, int fd1, unsigned long long off1,
		    unsigned long long off2, unsigned long long len,
		    unsigned long long flags, const char *what)
{
	struct xfs_exchange_range xr;

	memset(&xr, 0, sizeof xr);
	xr.file1_fd =3D fd1;
	xr.file1_offset =3D off1;
	xr.file2_offset =3D off2;
	xr.length =3D len;
	xr.flags =3D flags;
	if (ioctl(fd2, XFS_IOC_EXCHANGE_RANGE, &xr)) {
		fprintf(stderr, "%s: %m\n", what);
		return -1;
	}
	return 0;
}

int main(void)
{
	struct file_clone_range cr;
	char before[65536], after[65536], *buf;
	struct statfs sfs;
	struct stat st;
	int dirty, d2;

	if (statfs(".", &sfs))
		return fprintf(stderr, "statfs: %m\n"), 2;
	if (sfs.f_type !=3D 0x58465342)	/* XFS_SUPER_MAGIC */
		return fprintf(stderr,
			"this directory is not on XFS (statfs type =
0x%lx)\n",
			(unsigned long)sfs.f_type), 2;
	blksz =3D sfs.f_bsize;
	if (blksz < 512 || blksz > 65536)
		return fprintf(stderr, "unexpected block size %lu\n", =
blksz), 2;

	peer =3D open("peer", O_RDONLY);
	if (peer < 0)
		return fprintf(stderr, "open peer: %m\n"), 2;
	if (fstat(peer, &st))
		return fprintf(stderr, "fstat peer: %m\n"), 2;
	printf("peer uid %u mode 0%o size %lld, block size %lu\n",
	       st.st_uid, st.st_mode & 07777, (long long)st.st_size, =
blksz);
	if ((unsigned long)st.st_size < blksz)
		return fprintf(stderr,
			"peer must be at least one block\n"), 2;
	if (pread(peer, before, blksz, 0) !=3D (ssize_t)blksz)
		return fprintf(stderr, "pread peer: %m\n"), 2;
	syncfs(peer);

	/* file1: three blocks, clean, so its own i_disk_size is honest =
*/
	f1 =3D mkfile("file1", 'A', 3, 1);
	if (f1 < 0)
		return 2;
	/* the lever: one block, entirely dirty, i_disk_size =3D=3D 0 */
	dirty =3D mkfile("dirty", 'D', 1, 0);
	if (dirty < 0)
		return 2;
	d2 =3D mkfile("donor2", 'E', 1, 1);
	if (d2 < 0)
		return 2;
	printf("\n");
	show("start");

	/* share peer's block into file1's middle block */
	memset(&cr, 0, sizeof cr);
	cr.src_fd =3D peer;
	cr.src_offset =3D 0;
	cr.src_length =3D blksz;
	cr.dest_offset =3D blksz;
	if (ioctl(f1, FICLONERANGE, &cr)) {
		fprintf(stderr, "FICLONERANGE: %m\n");
		if (errno =3D=3D EOPNOTSUPP)
			fprintf(stderr,
				"this filesystem needs reflink=3D1, =
check xfs_info\n");
		return 2;
	}
	show("1 FICLONERANGE");

	/*
	 * ip1 =3D file1, ip2 =3D dirty.  off2 =3D=3D i_size(dirty) =3D=3D=
 blksz, so
	 *	length =3D max(3*blksz - 2*blksz, blksz - blksz) =3D =
blksz
	 * and dirty's flush range [blksz, 2*blksz) is entirely past its =
EOF,
	 * so its page cache is never written back and i_disk_size stays =
0:
	 *	isize1 =3D 2*blksz + (0 - blksz) =3D blksz
	 * file1's ondisk size becomes one block while it still owns the
	 * shared block at offset blksz.
	 */
	if (exchange(dirty, f1, 2 * blksz, blksz, 0,
		     XFS_EXCHANGE_RANGE_TO_EOF, "exchange TO_EOF"))
		return 2;
	show("2 EXCHANGE_RANGE TO_EOF");

	/*
	 * By i_disk_size file1 is now a one-block file, so this looks =
like a
	 * full-contents exchange of two one-block files and
	 * xmi_can_exchange_reflink_flags() clears the flag.
	 */
	if (exchange(f1, d2, 0, 0, blksz, 0, "exchange flag-clear"))
		return 2;
	show("3 EXCHANGE_RANGE");

	/* in-place write to the still-shared block */
	buf =3D malloc(blksz);
	memset(buf, 'X', blksz);
	if (pwrite(f1, buf, blksz, blksz) !=3D (ssize_t)blksz)
		return fprintf(stderr, "pwrite file1: %m\n"), 2;
	fsync(f1);
	show("4 pwrite(file1, blksz)");

	posix_fadvise(peer, 0, 0, POSIX_FADV_DONTNEED);
	if (pread(peer, after, blksz, 0) !=3D (ssize_t)blksz)
		return fprintf(stderr, "pread peer: %m\n"), 2;
	printf("\npeer first byte %c -> %c   %s\n", before[0], after[0],
	       memcmp(before, after, blksz) ? "PEER REWRITTEN" : "peer =
intact");
	return memcmp(before, after, blksz) ? 0 : 1;
}

N.

> Link: =
https://lore.kernel.org/linux-xfs/1E196589-DEBE-40AC-AFEA-D420DAAB067F@doy=
ensec.com/
> Reported-by: Norbert Szetei <norbert@doyensec.com>
> Cc: <stable@vger.kernel.org> # v6.10
> Fixes: 966ceafc7a4371 ("xfs: create deferred log items for file =
mapping exchanges")
> Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
> ---
> fs/xfs/libxfs/xfs_exchmaps.c |    8 ++++++--
> fs/xfs/xfs_exchrange.c       |   10 ++++++----
> 2 files changed, 12 insertions(+), 6 deletions(-)
>=20
> diff --git a/fs/xfs/libxfs/xfs_exchmaps.c =
b/fs/xfs/libxfs/xfs_exchmaps.c
> index 6a66b6075e0af4..c9d9464e9d39f5 100644
> --- a/fs/xfs/libxfs/xfs_exchmaps.c
> +++ b/fs/xfs/libxfs/xfs_exchmaps.c
> @@ -987,6 +987,7 @@ xfs_exchmaps_init_intent(
> const struct xfs_exchmaps_req *req)
> {
> struct xfs_exchmaps_intent *xmi;
> + struct xfs_mount *mp =3D req->ip1->i_mount;
> unsigned int rs =3D 0;
>=20
> xmi =3D kmem_cache_zalloc(xfs_exchmaps_intent_cache,
> @@ -1006,9 +1007,12 @@ xfs_exchmaps_init_intent(
> }
>=20
> if (req->flags & XFS_EXCHMAPS_SET_SIZES) {
> + loff_t off1 =3D XFS_FSB_TO_B(mp, xmi->xmi_startoff1);
> + loff_t off2 =3D XFS_FSB_TO_B(mp, xmi->xmi_startoff2);
> +
> xmi->xmi_flags |=3D XFS_EXCHMAPS_SET_SIZES;
> - xmi->xmi_isize1 =3D req->ip2->i_disk_size;
> - xmi->xmi_isize2 =3D req->ip1->i_disk_size;
> + xmi->xmi_isize1 =3D off1 + (req->ip2->i_disk_size - off2);
> + xmi->xmi_isize2 =3D off2 + (req->ip1->i_disk_size - off1);
> }
>=20
> /* Record the state of each inode's reflink flag before the op. */
> diff --git a/fs/xfs/xfs_exchrange.c b/fs/xfs/xfs_exchrange.c
> index fafb4e3f065c75..a4016116f5f1a9 100644
> --- a/fs/xfs/xfs_exchrange.c
> +++ b/fs/xfs/xfs_exchrange.c
> @@ -296,11 +296,13 @@ xfs_exchrange_mappings(
> * the mappings, and updated the ondisk sizes.
> */
> if (fxr->flags & XFS_EXCHANGE_RANGE_TO_EOF) {
> - loff_t temp;
> + loff_t old_ip1_size =3D i_size_read(VFS_I(ip1));
> + loff_t old_ip2_size =3D i_size_read(VFS_I(ip2));
>=20
> - temp =3D i_size_read(VFS_I(ip2));
> - i_size_write(VFS_I(ip2), i_size_read(VFS_I(ip1)));
> - i_size_write(VFS_I(ip1), temp);
> + i_size_write(VFS_I(ip2), fxr->file2_offset +
> + (old_ip1_size - fxr->file1_offset));
> + i_size_write(VFS_I(ip1), fxr->file1_offset +
> + (old_ip2_size - fxr->file2_offset));
> }
>=20
> out_unlock:

