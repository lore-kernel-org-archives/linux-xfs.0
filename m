Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B43A27466A;
	Tue,  7 Jul 2026 05:56:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783403813; cv=none; b=IDg31BuFy0hkyofWdVsuiCLVdHMvf+EmigvzMjl8nSMLJtWxNgnSZprjGDxDDP0Nyn57O7Hq8eSTnMCsKtKyYMerP1Kn+kQg31yYPdcLWQxKkWnuNPi3DSgQdh/L1MTw8BDF+UDA+CCeWS1kPi1GIiv74w7p7XFpRrlXTemUs9U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783403813; c=relaxed/simple;
	bh=Q2q87PBOSBSXFzWn5YCeHCGrjVipD0YSI3/0Iz03L7w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CnFezdU28nsslctfbPO0Xa/FuFKg9jSltnxLUn27/wmcnvEqLpmV07KORg3BQGGu4yIiwi9ZhPNV2J8H4Zz8nOhVVx7b9SXfojIcwbbodFo85Nl8x7Ls4iF5mT1GJVRQaODiskgh7smm2rVqa44mCEcQpJOxyfdSuWaILDHiPEw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WWMmFPp+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WWMmFPp+"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 1B2231F000E9;
	Tue,  7 Jul 2026 05:56:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783403812;
	bh=zvBQUMjFfmL8CsoSvQIRXvEDsQttw1ug9PgHP9d/HzI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=WWMmFPp+bGkkqybt7VAybpVaTuiF86+QBW8J2LHv9T6ufX6hL+gXjZpkx6oUB5Djm
	 b6Flpf/nYIrTX7hLKpHUtX8oh0Gw+9eFlLeBLv6UxnfDS+Keq3Li18bEhzBKPY4BGa
	 gDZCb5mW4g1BGNktesUBK4YUXSz1RWXX/2EGCNYmfhxsr53fPbPFt0XK/ROEeqKCHU
	 wCnaqBQzZWPEwWLl+TGaxeXk2Glg8GJlKEKvGLxhQ4kGTihWDgal7dwVecdQu69SC3
	 0IRXQCrHsapQQgdbfPxFzf90xvL526wTViBOUbvpWK9oEuAbhYa1vw9LBBNz4vfHOD
	 ln8DehSUNlytA==
Date: Mon, 6 Jul 2026 22:56:51 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Matteo Croce <technoboy85@gmail.com>
Cc: linux-xfs@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: ftruncate() after FICLONERANGE costs 300-600us/file, ~10x more
 than the clone itself
Message-ID: <20260707055651.GX9392@frogsfrogsfrogs>
References: <CAFnufp2NJj=eXCpfoU4ZzPwSX31oUbsUr=Kstz6NedTZ3dsqZA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFnufp2NJj=eXCpfoU4ZzPwSX31oUbsUr=Kstz6NedTZ3dsqZA@mail.gmail.com>

On Mon, Jul 06, 2026 at 11:45:07PM +0200, Matteo Croce wrote:
> Hi,
> 
> while adding reflink support to GNU tar I found that on XFS a
> FICLONERANGE followed by a shrinking ftruncate() is pathologically
> expensive: 300-600us for the truncate, plus another ~100us at close()
> for the post-EOF cleanup, around 10x the cost of the clone itself.
> The file has no dirty pages at that point, so this is not writeback:
> it looks like synchronous per-file metadata work. BtrFS (the only
> other mainstream filesystem with reflinks, so my only comparison
> point) does the same shrink in a flat ~15us.
> 
> Any program cloning a non-block-aligned range out of a larger file
> hits this (in my case, tar extracting a member from an archive):
> FICLONERANGE requires block-aligned lengths (unless the range ends at
> the source EOF), so the only option is to clone the length rounded up
> to the fs block and truncate to the real size. Whole-file cloners
> like cp --reflink use FICLONE and are not affected, which is probably
> why nobody noticed so far. Extracting a linux source tree (~93k
> files) this way with tar --reflink on XFS is 3.4x SLOWER than a
> regular copy (68s vs 20s); the same binary on BtrFS, on another
> partition of the same spinning disk, is 1.7x faster than the copy.
> 
> The core of the issue reproduces with xfs_io alone (on a freshly
> created filesystem with mkfs defaults, rmapbt=1):
> 
>   $ dd if=/dev/urandom of=src.dat bs=1M count=1; sync
>   $ strace -T -e trace=ioctl,ftruncate xfs_io -f \
>         -c "reflink src.dat 0 0 90112" -c "truncate 90000" dest.dat
>   ioctl(3, FICLONERANGE, {src_fd=4, src_offset=0, src_length=90112,
>         dest_offset=0}) = 0 <0.000089>
>   ftruncate(3, 90000) = 0 <0.000446>        <-- shrink by 112 bytes

XFS zeroes the tail block when you truncate down, which causes an out of
place write.

Assuming src.dat is the fully written 90000 byte file, can you

$ xfs_io -c "reflink src.dat 86016 86016 0" dest.dat

to link only the eof-block into dest.dat and keep its file size at
90000?

--D

> and the control, a no-op truncate at the exact cloned size:
> 
>   $ xfs_io -f -c "reflink src.dat 0 0 90112" -c "truncate 90112" ...
>   ioctl(3, FICLONERANGE, ...) = 0 <0.000088>
>   ftruncate(3, 90112) = 0 <0.000030>
> 
> For the statistics over many files, the reproducer below creates
> 20000 files of SIZE bytes from a common (fsync'ed) source file,
> timing each syscall. Modes:
> 
>   write        plain write() of the content
>   write-trunc  write() rounded up to the block, then ftruncate()
>   clone-tail   FICLONERANGE of the whole blocks, then write() of
>                the final partial block (no truncate)
>   clone-trunc  FICLONERANGE rounded up to the block, then
>                ftruncate() to the real size
> 
> XFS with mkfs defaults (rmapbt=1), per-file cost of the ftruncate in
> clone-trunc, plus the neighboring syscalls for context (us):
> 
>   size      clone   trunc   close     whole loop
>   1000       40.2   294.2    82.4        9.10s
>   5000       60.8   285.5    95.5        9.61s
>   20000      61.8   416.0    99.4       12.31s
>   65536      50.1     7.3     2.7        1.86s   <-- block-aligned,
>   90000      62.9   306.7    94.1       10.06s       truncate is a no-op
> 
> The 65536 control row (exact multiple of the block size) shows the
> whole overhead vanishing when the truncate does not shrink into the
> cloned extent; at 90000 (21 blocks + 3984 bytes) it is back.
> 
> To rule out the reverse-mapping btree, I recreated the fs on the same
> partition with -m rmapbt=0 and reran the matrix:
> 
>   size      clone   trunc   close     whole loop
>   1000       21.8   295.8    52.0        8.14s
>   5000       27.1   332.8    56.2        9.09s
>   20000      27.1   366.6    58.4        9.81s
>   65536      19.7     6.7     2.6        1.21s
>   90000      27.1   574.3    57.0       13.94s
> 
> The clone and the close get cheaper without rmapbt, but the truncate
> does not improve at all; if anything it grows with the number of
> cloned blocks (~13us per block from 1 to 22 blocks). So the rmap
> btree is not where the cost is.
> 
> For reference, on the same mkfs-default filesystem:
> 
>   - clone-tail (no truncate): clone ~50us, tail write ~12us, close
>     ~7us, at every size. A prototype of tar using this scheme turns
>     the 3.4x slowdown into a 1.6x speedup on XFS, so a userspace
>     workaround exists, but it should not be needed.
>   - The clone path is otherwise excellent: at size=90000, plain
>     write pays 11.6s of writeback at syncfs time, the clone modes
>     ~0.1s.
>   - BtrFS clone-trunc for comparison: trunc ~15us and close ~2.3us,
>     flat from 1k to 90k.
> 
> Unrelated, maybe: the write-trunc mode (not shown in the tables
> above) also shows that on XFS an ftruncate on a file with dirty
> delalloc data synchronously flushes it (the deferred writeback cost
> moves into the truncate, sync time drops to ~0.1s), even when the
> truncate does not change the size: at size=65536 the no-op ftruncate
> costs 514us on the freshly written file, versus the 7.3us that the
> same no-op costs on a clean cloned file in the table above. BtrFS
> only pays this for an actual shrink, not for the no-op (19.6us).
> This does not apply to the clone case above, where the cloned file
> has nothing dirty, which is why the 300-600us look like pure
> metadata work.
> 
> Environment:
>   kernel 7.1.2 vanilla
>   All filesystems were freshly created on the same partition of a
>   spinning HDD, with mkfs defaults.
>   meta-data: isize=512 agcount=4
>              sectsz=4096 crc=1 finobt=1, sparse=1, rmapbt=1
>              reflink=1 bigtime=1 inobtcount=1 nrext64=1
>   mount: rw,noatime,inode64,logbufs=8,logbsize=32k,noquota
>   data:  bsize=4096
> 
> The benchmark and its driver script are here:
> 
>   https://gist.github.com/teknoraver/67b50ce366d7cf430bb7f82a8018acfa
> 
> (gcc -O2 -o clone_bench clone_bench.c; the script runs the whole
> mode/size matrix in fresh subdirectories of the given target dir.)
> 
> Happy to run further tests (tracepoints, perf, other mkfs/mount
> options) if useful.
> 
> Regards,
> -- 
> Matteo Croce
> 
> per aspera ad upstream
> 
