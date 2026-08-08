Received: from mail-vk1-f181.google.com (mail-vk1-f181.google.com [209.85.221.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B510A1E1A3D
	for <linux-xfs@vger.kernel.org>; Sat,  8 Aug 2026 23:40:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786232423; cv=none; b=jIuDjIPrXMho9H70hKbwcCXeSbLkl+ngkXXXd33cmQEzSkUyXBwgytyd+L4bo/hkHaeAgP87uMN8p2SUEp+la87RlGd4NcnTTG2LOzG1IpzbLGCUDsrQA+etBG5DGgX57M57FApM/F4Sud+y15kM89RJ0KppyHIfFJTH75IFzkQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786232423; c=relaxed/simple;
	bh=nfqcfUXZggsT/KsvSLurdO997OgIEC17lEMDCnsCJoQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=nwfa+b9F2WLq88kcva+kqODv+LSkdOqb+R6NzmKZEQSxx+9nh6GHAnGEvvWS5UJRBKFDwd9WmOW/yOvNdEyXvZmmGcQsK9Mq+50P06nCHqLCc84d+6nZd+Tr4MLZST0GlaT3VOatxy+dqeerRcR3vexCPlf11Ipy71J7IzDmtIU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=peridio.com; spf=pass smtp.mailfrom=peridio.com; dkim=pass (2048-bit key) header.d=peridio.com header.i=@peridio.com header.b=krFjzaMp; arc=none smtp.client-ip=209.85.221.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=peridio.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=peridio.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=peridio.com header.i=@peridio.com header.b="krFjzaMp"
Received: by mail-vk1-f181.google.com with SMTP id 71dfb90a1353d-5bfa60aa6caso14626e0c.2
        for <linux-xfs@vger.kernel.org>; Sat, 08 Aug 2026 16:40:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=peridio.com; s=google; t=1786232420; x=1786837220; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:sender:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=qnN9BG62sSM56ywY1WynCBREJ9MtM7BNGGBR6l8TuxA=;
        b=krFjzaMp6QB7JKP/n+NTh3X4coYgCfCPaCCzrNSWe2CIhLH+1Rkfu6wM8yos/fqF40
         4c4p/WzbzTi9ZCEHyKcFcXfKnnpeTYqRVvx2UywOww2EFX6kwQyk2PuVgOgb5rKmAxDs
         PcxrkUM2XgUeWLlwaiuebcnaFl8VI23p7foUZNHPBTs6FsdX5XAiHGKt38WcIsG4QhjB
         LVa12Ydx/Z/zkHmKOrwqrn0jkgbJq5Vv9khD+BDS7SjjgI2JdrHXCDKgJoxq+d/mItZ4
         2ryxvjIQdgMTLzEUqxdTzZ9CkGYSvV3kQXMmVEdyMDRtS7Nk2dPrchchxGYlJBZWDGRe
         y9Tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786232420; x=1786837220;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:sender:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=qnN9BG62sSM56ywY1WynCBREJ9MtM7BNGGBR6l8TuxA=;
        b=fBilxvt29tgYbtztrPuxV2KSpEdxoA5eXsTmye9fOOTXmxMXGG/t+bhV1Z85b1tfR/
         9ijcSJayo0HOXG/WvPYQ14R9F5YpOY6i3zOeYZJBuFIfOicg/cNwtNkxrmpsXfcEwcFR
         D/34JMdwQoZ2Y+hoxtWZvWSatKpUwhOTlNvj5lVqcelL/pczSKRSEz5893buKG8tJUgK
         TbZeXL4Q3rZJ/cLmAPOXTf3WdTEWlH0O6bbRgTGDbPOFfXjq0q4jJ2djbqO53RicAGFt
         m1wJqTSNeLuoqb5PjPl29IT+XClgMy8HluvCFJwytO4EDTEL68heGVE3aVnCWqe4w4DI
         S44A==
X-Forwarded-Encrypted: i=1; AHgh+RqwzsKlW+zVXNmDzJlyzj0apBZ51Paw1mujBcwBVWO8zOAk2rHphA90z6ke95313sgHsYCiqN77Wh0=@vger.kernel.org
X-Gm-Message-State: AOJu0YzTYpwzJ/QmUn9NgvgXJ/M4G32hOQlc48ahAfPl5aFL4r2LfuKt
	3Hu4nMcxABlT/ggrklLRVAIi1tST1HYNPkmM7tP9LA4JjBsWYwAC8mr8sSmnekPZjgw=
X-Gm-Gg: AR+sD139ZN36mfvmoUOZck9AZyvCnxdS+byK/q8nXlFDTZJxvfF67tgR7/EmZgJcn6X
	P2iEr+1La9jHwAZ9s5UV3ZpzErWcQArAk/LjM38O9WDwDzedSVk4T0NNNlSfoKnvdSX5aX7v3wL
	hUw3faL65gohVzDK0JJufiRhBZLwF9HzcpKYwiPVIojOVqMrz45dhh/AMDcnTrUo0hQT3bY3AOm
	bMZz0TL1ZKKF6TwwzCgtiJNfCF0hE9oFmUcqbMUxIO5gAZv8/4sTwNtJcVs8SMtqg2VlQr9SDxx
	rtwXFxtUDuYK4zGrwRefzmdP6dF7VkxjpZUDlzsBBOBbwnjazCbOP1rshzLK2p6vPXWH0fVSYTn
	cYyuvHCWwxTtp5u8oz44emCxSW9okrb/Mf5frPCWUdH4zt8hNVOKAl4ggTM96TQygpM1PKfFxzX
	nVkhstf0TeJ8VCWYqE5E3s82U/JYK89mOAr+BYQ16nCJL3Qi9T/lpsrss=
X-Received: by 2002:a05:6122:3b1a:b0:5be:146a:7b09 with SMTP id 71dfb90a1353d-5c3d912c87emr3093685e0c.1.1786232420430;
        Sat, 08 Aug 2026 16:40:20 -0700 (PDT)
Received: from localhost ([190.113.101.40])
        by smtp.gmail.com with ESMTPSA id 71dfb90a1353d-5c40af097absm2570115e0c.8.2026.08.08.16.40.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 08 Aug 2026 16:40:19 -0700 (PDT)
Sender: Javier Tia <j.tia@peridio.com>
From: Javier Tia <javier@peridio.com>
X-Google-Original-From: Javier Tia <floss@jetm.me>
To: Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J . Wong" <djwong@kernel.org>,
	Dave Chinner <dchinner@redhat.com>,
	Allison Henderson <allison.henderson@oracle.com>,
	Andrey Albershteyn <aalbersh@kernel.org>,
	linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 0/5] xfs: fix filesystem shutdown from parent pointer reservation underflow
Date: Sat,  8 Aug 2026 17:40:17 -0600
Message-ID: <20260808234016.246054-7-floss@jetm.me>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=9304; i=floss@jetm.me; h=from:subject; bh=nfqcfUXZggsT/KsvSLurdO997OgIEC17lEMDCnsCJoQ=; b=owEB7QES/pANAwAKAbXuwwuoZ3cfAcsmYgBqd75gCOuxZpNRMZlRxdQHHv6W69iPvzIYMForA 9MBsNGJPZeJAbMEAAEKAB0WIQSbE7ILzw7eI0VKk8m17sMLqGd3HwUCane+YAAKCRC17sMLqGd3 HzaiC/4lHqy4V/3tQvymkM/jLUA30pkTdF7hbFWN2Q9zVpF+NUWbopUeX2cW8GcyAV+pti0FfYg p0w4DxlkISAGyxLhtUuSohdmg/C1ERIYlvuarBBMmzVia3OrbLt9bH2OEm9hFMShNlr5ndmLxq8 KOTKZnMl4qdZ4zTHMDcD6pn0UuJfy7kLtYGD04zDS4f2CiGTw0CPt8ioRdjIlwVLfibuQpTFKQE 3PYFTLMAviSLwFNVN+Dtztmsq7DHz5zxTgacFyRK07VsDcptaNBxlPcrfn1fbw0/Y3S/gZpRjGf e23jWq/Pui8S+Kk6xtYSjoK8p9zG9AY6zS0AQeDrQjlFE+U2KxLedrAbGFxfZFf59vthHyJu/n9 TY49DGVOHOiH0v1XIfJ8E4oZ3eOVcteepjL0jDr+IrzGrDbo5MzWN0W8sCtCMxm5TTFZyCJDc1h 5J8H9zZq7iImMXETHbGN38GL6g3ZnHGBmKfpSZrFHehU5JUY7GfSBbZFCzDbl29ZHRz6g=
X-Developer-Key: i=floss@jetm.me; a=openpgp; fpr=9B13B20BCF0EDE23454A93C9B5EEC30BA867771F
Content-Transfer-Encoding: 8bit

The first parent pointer update that has to grow the attribute fork
twice in one operation can shut the filesystem down with

    XFS (loop0): Corruption of in-memory data (0x8) detected at
    xfs_defer_finish_noroll+0x29a/0x4b0 (fs/xfs/libxfs/xfs_defer.c:721)

The message names in-core corruption, but nothing is corrupt.  The
deferred work that failed is a block allocation that returned a bare
-ENOSPC on a filesystem with hundreds of gigabytes free, and
xfs_defer_finish_noroll() treats any non-EAGAIN error as fatal.

xfs_parent_da_args_init() fills in every field of the xfs_da_args it
builds except total, and the containing xfs_parent_args comes from
kmem_cache_zalloc(), so a runtime parent pointer update reaches the
block allocator with args->total == 0.  That field is not a constant.
xfs_da_grow_inode_int() treats it as a running remainder and subtracts
from it, and xfs_da_args.total is an xfs_extlen_t (uint32_t), so
subtracting the first block the attr fork gains wraps it to 0xffffffff.
It reaches the minimum-free-space test in xfs_alloc_space_available() as
(int)max(args->total, alloc_len), where the cast turns ~0U back into -1
and the test can no longer fail.  Execution falls into the clamp below
it, args->maxlen = available, and when available is 0 the result is
maxlen == 0.  Both ASSERTs guarding that clamp are compiled out without
CONFIG_XFS_DEBUG.  xfs_alloc_vextent_check_args() then rejects
minlen(1) > maxlen(0) with -ENOSPC, and the filesystem goes down.

The log recovery path already does this correctly, which is the
clearest statement that the runtime path is wrong.
xfs_attri_recover_work() does args->total = xfs_attr_calc_size(args,
&local) for PPTR_SET and PPTR_REPLACE, so replaying a parent pointer
insert from the log runs with a correct total while performing the same
insert at runtime runs with zero.  Patch 5 sets the field the same way
at init time.

One detail is worth stating because it is not obvious from the diff.
In the captured trace total changes from 0xffffffff to 1 one step
before the failure: xfs_bmap_btalloc_low_space() sets args->total =
ap->minlen before its last-ditch sweep of every AG.  Nothing resets
args->maxlen, so the clamped zero survives into check_args.  The
fallback that exists to rescue an over-large reservation cannot rescue a
clamped maxlen.

Two conditions have to coincide, which is why the bug looks rare.  The
first is two xfs_da_grow_inode() calls sharing one xfs_da_args; that
happens whenever a leaf-to-node conversion is followed by a node split
in the same operation, which is ordinary rather than a corner case.
The second is an AG at the later growth whose available block count,
pagf_freeblks + agflcount - reservation - min_free - minleft, is exactly
zero.  At available == -1 the same code takes a different path and at
available >= 1 the allocation succeeds; only the exact-zero coincidence
is fatal.  The underflow itself is common and usually harmless.  In one
capture an earlier link() carried total 4294967295 with maxlen 1 and
allocated successfully a few hundred milliseconds before the fatal one.

xfs_attr_calc_size() returns 25 blocks on a 4 KiB-block filesystem and
does not depend on name length, since a parent pointer's value is a
struct xfs_parent_rec and the leaf entry is always local.  I fixed the
caller rather than the unsigned subtraction in xfs_da_grow_inode_int()
to keep the runtime and recovery paths consistent.  This bounds the
underflow rather than eliminating the class: args->total is still a
monotonically decreasing unsigned counter that is never re-derived
across the deferred state machine.  XFS_DA_NODE_MAXDEPTH is 5, so the 26
growths on one xfs_da_args that underflowing from 25 would take are
unreachable in practice, but I put it on the record so the bound is
explicit.

I reproduced this deterministically on the same machine, same script,
only the kernel differing.  Unpatched, the filesystem shuts down within
0.2 s of link activity and eight "total 4294967295" allocator events are
recorded; patched, 400 steps and 25,024 links complete clean with zero
such events.  The attr fork counter goes 0 -> 4294967295 unpatched and
25 -> 24 patched, while the data fork counter goes 78 -> 77 in both:
that last row is the control, the same subtraction happening correctly
and unchanged by the patch.  A second machine on different hardware, on
its own unpatched kernel, produced a byte-identical event distribution.
The patched kernel has since carried ordinary Yocto build load for eight
days with no filesystem shutdown; before the patch the same machine died
within five to seven minutes once the triggering conditions coincided.

I ran ./check -g parent -g attr on the patched kernel, 53 of 55 passing.
The two failures are environmental, a setfattr deprecation warning newer
than the golden output and an O_TMPFILE EOVERFLOW in the harness, and
neither mentions parent pointers, allocation or ENOSPC.  I have not run
the same tests against an unpatched kernel, so I am not claiming those
two are unrelated to this series.  A dedicated regression test is posted
separately to fstests as tests/xfs/842; it fails on an unpatched kernel
and passes on a patched one.

The workload that first hit this is a Yocto/BitBake do_package run, which
hardlinks one file into many package staging directories so that every
link() writes another parent pointer, on a 1.9 TB filesystem with 862
GiB free.

Related work is in flight.  On 2026-07-29 Dave Chinner posted an RFC,
"XFS: Atomic multi-extent operations via rolling transactions"
(20260729100629.1943710-1-dgc@kernel.org), which is not merged.  Its
patch 18, "xfs: add block reservation renewal to xfs_defer_finish",
touches fs/xfs/libxfs/xfs_defer.c, which patches 1 to 3 here also
modify; the hunks are unrelated, so if it lands first this series needs
a rebase rather than a redesign.  The overlap is also conceptual, and
worth naming because a reviewer will see it anyway: that RFC addresses a
transaction reservation carried forward by xfs_trans_dup() and depleted
over successive rolls even though each iteration needs the same amount.
This bug is the same shape one level down, with xfs_da_args.total
depleting across the xfs_da_grow_inode_int() calls that span one of
those rolls.  The two are independent, and patch 5 stands whether or not
the RFC is merged.

Only patch 5 is the fix.  The other four are independent and a
maintainer can take them separately:

  1. xfs: initialise error in xfs_defer_finish_one() is a separate bug.
     error is used uninitialised on the item-less barrier path reachable
     via xfs_defer_add_barrier() under CONFIG_XFS_ONLINE_REPAIR, so a
     successful barrier can be reported as corruption depending on stack
     contents.  It carries a Fixes: tag and Cc: stable.
  2. xfs: give the deferred barrier op type a name fills the only
     xfs_defer_op_type with a NULL .name.
  3. xfs: report the error that made deferred work shut down the fs moves
     the tracepoint ahead of the shutdown and logs the errno and the
     remaining reservation, so the failure is diagnosable from the log
     alone.  This is the patch that would have saved most of this
     investigation.
  4. xfs: correct the parent pointer space reservation comment.

For anyone who wants to watch it happen.  Root required; it creates and
destroys a 512 MiB loop filesystem under /var/tmp.  If fs.xfs.panic_mask
is non-zero the shutdown becomes a BUG() and the machine reboots instead
of reporting, so lower it for the run.

    truncate -s 512M /var/tmp/pptr.img
    mkfs.xfs -q -f -m crc=1 -n parent=1 -d agcount=2 /var/tmp/pptr.img
    mkdir -p /mnt/pptr && mount -o loop /var/tmp/pptr.img /mnt/pptr

    mkdir /mnt/pptr/d
    dd if=/dev/urandom of=/mnt/pptr/src bs=4096 count=1 status=none

    # Fill to within ~460 free blocks, then walk that margin down one
    # block per step, hardlinking with 240-byte names so the attr fork
    # leaves shortform quickly.
    free=$(stat -f -c '%a' /mnt/pptr)
    fallocate -l $(( (free - 464) * 4096 )) /mnt/pptr/ballast
    name=$(printf 'x%.0s' $(seq 1 240))

    for step in $(seq 0 400); do
        fallocate --punch-hole --keep-size -o $((step * 4096)) -l 4096 \
            /mnt/pptr/ballast
        for i in $(seq 1 64); do
            ln /mnt/pptr/src "/mnt/pptr/d/${step}_${i}_$name" \
                2>/dev/null || break
        done
        rm -f /mnt/pptr/d/* 2>/dev/null
        touch /mnt/pptr/.alive 2>/dev/null \
            || { echo "shut down at step $step"; break; }
    done

Javier Tia (5):
  xfs: initialise error in xfs_defer_finish_one()
  xfs: give the deferred barrier op type a name
  xfs: report the error that made deferred work shut down the fs
  xfs: correct the parent pointer space reservation comment
  xfs: initialise args->total for parent pointer updates

 fs/xfs/libxfs/xfs_defer.c       | 18 ++++++++++++++++--
 fs/xfs/libxfs/xfs_parent.c      | 13 +++++++++++++
 fs/xfs/libxfs/xfs_trans_space.c | 19 +++++++++++++++++--
 3 files changed, 46 insertions(+), 4 deletions(-)

base-commit: 155b42bec9cbb6b8cdc47dd9bd09503a81fbe493
-- 
Javier Tia

