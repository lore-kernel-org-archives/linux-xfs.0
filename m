Received: from mail-ed1-f48.google.com (mail-ed1-f48.google.com [209.85.208.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3201C305674
	for <linux-xfs@vger.kernel.org>; Mon,  6 Jul 2026 21:45:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.48
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783374346; cv=pass; b=blJTIMDTvw5nPGWLqufiAAjO9UzVgf33x9vGQr+M53+J32dzMBnkyQud4Ne6hzpEsjuQ3Q9rM/gHLNXNsPkMyxKTKPZ46jqQPVsPQ6G09CjheW4+qFE53B+nML0DgOzfJ/FkFtkT+ABdY/CcDQeNobj3apS5r+pdH0Iyt+hmyac=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783374346; c=relaxed/simple;
	bh=o1+Klzgz9qbXKn1OqhRpGG81QS23X3rQB9XhGpOBG/A=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=c05dNm14atAuZv7ux/pzCgab1H/FKv3IvWMj3bjESPoDr5nYoYDmWFz2Yon4GcwPKPHsEH1UsKfzaLDOOM/wcTRbq9B3/wvBKC54Nun5XYugTtJsbJ7xCze3G5XzYJ3kgqbYmaShcIfIHc+7CagMtUXSEgDrJJQfJXXAZ+t7d0k=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=I8CSmuhD; arc=pass smtp.client-ip=209.85.208.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="I8CSmuhD"
Received: by mail-ed1-f48.google.com with SMTP id 4fb4d7f45d1cf-68bd9fce347so6643372a12.2
        for <linux-xfs@vger.kernel.org>; Mon, 06 Jul 2026 14:45:44 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1783374343; cv=none;
        d=google.com; s=arc-20260327;
        b=KEHxAsEOwfgWXpWf3nuA7GiL2+uKG0RV5S9zH5+KWM7x0mUinRtN8+9oNc8poOxv76
         WPJ9ElfX44SaBgKnKtpx0hW//kwJtBgHuPZ0we/8OiW1D6yKbzq3Z03+RrFbIrj1Qw0c
         jTQyj3uTRK8cJAmMabmXPUovG+XjF8mZwxUqd0SA0CgcMvaE6GeKZY0LcUq7AcX7Iop9
         4ys1nsmunQMl5TFTDORpb2gFOjzWv4JbtJI4WH+6mkz5pyh45dj7+9C4TAO6KOSV1ReA
         tYY6kbbVE+2BXrBc8585vGJMaOhzOYWf/gRDtnm7U3LqQYsR7vlqNnPaWtdEeEG31LXY
         DS6Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=2DPvSyU7YJFM/rt0Z4vyBYnfq0fpp8XvXcIGy6cOSSU=;
        fh=d2aANL2YEMEYIGn9/M4ayneJ/wPj6wvbQ/U5R5HZhQg=;
        b=bWovvRoZi/f4CEzxS15Kqntp5Dl8nuSbOtTaFbsaIPhQvWV2VulFcZmNflJT5O6k09
         ii1n6tfutxOg3RKG8+rvuiOxPkOsBqItEYtYPBdlX9gaSEXWntHp8u/W5q/sFQj6C2C+
         kgj9LaaQBOpnzrQuSwrm9kV+1lBwNzvui3C3awrymidtU0bLpV4n8yoxtisjPP3Fqnv0
         1VLyaNu+/S2K6FjP8kPPwtDijaBp3fLGsU6Wuzbf6DMxBopCDzWEz5FajDpOi8rPYARX
         3utVWOzK4ZM5xz3qe5y9DgyzH+4Y7VbkSEZGTMJyVJU+w37/3n0zoELpNfCis/6dIbu6
         RUNA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783374343; x=1783979143; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=2DPvSyU7YJFM/rt0Z4vyBYnfq0fpp8XvXcIGy6cOSSU=;
        b=I8CSmuhDS52cKPame0URyLJ+IJyZMvTJZ2t2s/VHUremWP2GxPE6PnBPM5NMfNvSTG
         bgwNxdTw+lGirhBOrloyKbsOBOCSdvngDgLOs3WnXsTeGC+1XCDVCHgjtWmVMKiKKulN
         B+EQ5XjuWjojm8SCOAl57FDLKGDjNSw++llmIbqcE5cx/8TIO6o/tZHUT7Po9ejfouXs
         8v0mrAK+ZD+rxU8M8ix5Cps44dZtVkUf97r3N+ezmT2x6ONYcb6cQv2JfPQl3W0z2wc4
         ZzVDp9s/hAzXy5wW48DKhbL9rVw81el55JS6Lm7gLHK6Gt2LFuFxK31XB/OD2rAa25MF
         JzFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783374343; x=1783979143;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2DPvSyU7YJFM/rt0Z4vyBYnfq0fpp8XvXcIGy6cOSSU=;
        b=ltdkALWmpwH02g1Cc7h5UbpzdpYZCbu0QDFeq2dlSTkeo0ebxBU/9agLTr58i0Sg3C
         RbZ4ZEOAgGhjNa1vEl+8ngq/dNzEBoQ7huu0Zb6w5r89TzyehB9SSZ0D2Q1uNsTKXHqh
         8HCrnpokxyyGlrFXLzGWydKxj+sV9B/NTArdTT68KivsCZOqeX6Yvpt/Nujb41+zwE0j
         YFdk71bTahqBvF3rwbxWv2GPi7D8y8K9z5rBM7gepEnj4XtQY6JMo033DFWWWcpZ9Hlb
         jMmdgiyFpJ0thrOFCR41/gpGgARhO/CCMkeWBYehnIijBfrbNXhsO/i427F2z9HmMP8i
         TNbw==
X-Gm-Message-State: AOJu0YyVpNK63cnId3XGeF6aVBQ5quHPGH8D/l99lnwJ2fQWLOvbexP8
	tM566sUgzyh0Ixb/peYbh51SN8akJ+ZDPS8twCaS8SxnbdYECBSfyOgk7BDdnLedVnbfhLITMok
	TlDjD9M8z74OvtQk8GmXlYwL9kj27Xg5Rwr9R
X-Gm-Gg: AfdE7ckBVsnYbxyMIqQnBk2oo5s31GpYNumELIDtxDsijGvya3ycpO8y2SWD6yWhkT8
	yXcMhVKICJvNR5lKNSJhEVluEcGNgtBwZiWFvyaAgX1LwqNw9s5+ymgh1ea2OSKTEk8Zu/9zSXl
	t6lpqwI0W+3fHCjHW925NeGaO2FBu+k0Yy6hopeXn2PYdfDEYxPImiO/KLBPjIifZ5Kx9xxn3fe
	lXgoDDiHTBVvVnxFmGbR45n8aaeOOOwu3XzqKw7VklxSyE+q5paK4N7SQ/17kSFVSx791OfLA==
X-Received: by 2002:a05:6402:a209:10b0:698:b60b:d8f4 with SMTP id
 4fb4d7f45d1cf-69a856476eamr1030049a12.6.1783374343341; Mon, 06 Jul 2026
 14:45:43 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Matteo Croce <technoboy85@gmail.com>
Date: Mon, 6 Jul 2026 23:45:07 +0200
X-Gm-Features: AVVi8CdDfhD7Xm4G59sme1-7LbgHTN8A47jfw6jwlAW2z63pAzpcCNgHOdP7-3c
Message-ID: <CAFnufp2NJj=eXCpfoU4ZzPwSX31oUbsUr=Kstz6NedTZ3dsqZA@mail.gmail.com>
Subject: ftruncate() after FICLONERANGE costs 300-600us/file, ~10x more than
 the clone itself
To: linux-xfs@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

Hi,

while adding reflink support to GNU tar I found that on XFS a
FICLONERANGE followed by a shrinking ftruncate() is pathologically
expensive: 300-600us for the truncate, plus another ~100us at close()
for the post-EOF cleanup, around 10x the cost of the clone itself.
The file has no dirty pages at that point, so this is not writeback:
it looks like synchronous per-file metadata work. BtrFS (the only
other mainstream filesystem with reflinks, so my only comparison
point) does the same shrink in a flat ~15us.

Any program cloning a non-block-aligned range out of a larger file
hits this (in my case, tar extracting a member from an archive):
FICLONERANGE requires block-aligned lengths (unless the range ends at
the source EOF), so the only option is to clone the length rounded up
to the fs block and truncate to the real size. Whole-file cloners
like cp --reflink use FICLONE and are not affected, which is probably
why nobody noticed so far. Extracting a linux source tree (~93k
files) this way with tar --reflink on XFS is 3.4x SLOWER than a
regular copy (68s vs 20s); the same binary on BtrFS, on another
partition of the same spinning disk, is 1.7x faster than the copy.

The core of the issue reproduces with xfs_io alone (on a freshly
created filesystem with mkfs defaults, rmapbt=1):

  $ dd if=/dev/urandom of=src.dat bs=1M count=1; sync
  $ strace -T -e trace=ioctl,ftruncate xfs_io -f \
        -c "reflink src.dat 0 0 90112" -c "truncate 90000" dest.dat
  ioctl(3, FICLONERANGE, {src_fd=4, src_offset=0, src_length=90112,
        dest_offset=0}) = 0 <0.000089>
  ftruncate(3, 90000) = 0 <0.000446>        <-- shrink by 112 bytes

and the control, a no-op truncate at the exact cloned size:

  $ xfs_io -f -c "reflink src.dat 0 0 90112" -c "truncate 90112" ...
  ioctl(3, FICLONERANGE, ...) = 0 <0.000088>
  ftruncate(3, 90112) = 0 <0.000030>

For the statistics over many files, the reproducer below creates
20000 files of SIZE bytes from a common (fsync'ed) source file,
timing each syscall. Modes:

  write        plain write() of the content
  write-trunc  write() rounded up to the block, then ftruncate()
  clone-tail   FICLONERANGE of the whole blocks, then write() of
               the final partial block (no truncate)
  clone-trunc  FICLONERANGE rounded up to the block, then
               ftruncate() to the real size

XFS with mkfs defaults (rmapbt=1), per-file cost of the ftruncate in
clone-trunc, plus the neighboring syscalls for context (us):

  size      clone   trunc   close     whole loop
  1000       40.2   294.2    82.4        9.10s
  5000       60.8   285.5    95.5        9.61s
  20000      61.8   416.0    99.4       12.31s
  65536      50.1     7.3     2.7        1.86s   <-- block-aligned,
  90000      62.9   306.7    94.1       10.06s       truncate is a no-op

The 65536 control row (exact multiple of the block size) shows the
whole overhead vanishing when the truncate does not shrink into the
cloned extent; at 90000 (21 blocks + 3984 bytes) it is back.

To rule out the reverse-mapping btree, I recreated the fs on the same
partition with -m rmapbt=0 and reran the matrix:

  size      clone   trunc   close     whole loop
  1000       21.8   295.8    52.0        8.14s
  5000       27.1   332.8    56.2        9.09s
  20000      27.1   366.6    58.4        9.81s
  65536      19.7     6.7     2.6        1.21s
  90000      27.1   574.3    57.0       13.94s

The clone and the close get cheaper without rmapbt, but the truncate
does not improve at all; if anything it grows with the number of
cloned blocks (~13us per block from 1 to 22 blocks). So the rmap
btree is not where the cost is.

For reference, on the same mkfs-default filesystem:

  - clone-tail (no truncate): clone ~50us, tail write ~12us, close
    ~7us, at every size. A prototype of tar using this scheme turns
    the 3.4x slowdown into a 1.6x speedup on XFS, so a userspace
    workaround exists, but it should not be needed.
  - The clone path is otherwise excellent: at size=90000, plain
    write pays 11.6s of writeback at syncfs time, the clone modes
    ~0.1s.
  - BtrFS clone-trunc for comparison: trunc ~15us and close ~2.3us,
    flat from 1k to 90k.

Unrelated, maybe: the write-trunc mode (not shown in the tables
above) also shows that on XFS an ftruncate on a file with dirty
delalloc data synchronously flushes it (the deferred writeback cost
moves into the truncate, sync time drops to ~0.1s), even when the
truncate does not change the size: at size=65536 the no-op ftruncate
costs 514us on the freshly written file, versus the 7.3us that the
same no-op costs on a clean cloned file in the table above. BtrFS
only pays this for an actual shrink, not for the no-op (19.6us).
This does not apply to the clone case above, where the cloned file
has nothing dirty, which is why the 300-600us look like pure
metadata work.

Environment:
  kernel 7.1.2 vanilla
  All filesystems were freshly created on the same partition of a
  spinning HDD, with mkfs defaults.
  meta-data: isize=512 agcount=4
             sectsz=4096 crc=1 finobt=1, sparse=1, rmapbt=1
             reflink=1 bigtime=1 inobtcount=1 nrext64=1
  mount: rw,noatime,inode64,logbufs=8,logbsize=32k,noquota
  data:  bsize=4096

The benchmark and its driver script are here:

  https://gist.github.com/teknoraver/67b50ce366d7cf430bb7f82a8018acfa

(gcc -O2 -o clone_bench clone_bench.c; the script runs the whole
mode/size matrix in fresh subdirectories of the given target dir.)

Happy to run further tests (tracepoints, perf, other mkfs/mount
options) if useful.

Regards,
-- 
Matteo Croce

per aspera ad upstream
