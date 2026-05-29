Received: from mail-qv1-f51.google.com (mail-qv1-f51.google.com [209.85.219.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1ED463909B1
	for <linux-xfs@vger.kernel.org>; Fri, 29 May 2026 19:27:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780082849; cv=none; b=OjresE+33rsG5atg0d3jRvy/wicH5BeZUuFL5ujtaLJ3QL5Cctk5Hyu2L6hktHi9ODsaz14y65CwqLYThaHCBrZ2aWN6pKw8kNpud7KKJPeeZ+/2Hjf8pLDaIghkIaG+ZXEW/UNVUm/ur3qgzAym2/GqN/4aArxExm8eK7itbFs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780082849; c=relaxed/simple;
	bh=gB1U8bKM/wiOIdkRr9Pd+jw+4hTWsXjbCn/1NejxI1s=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=nxmum/3DmHEAqAzoTKiwKt+0IzVA45mT39bZSru3Y1YLzl5wFesUp27qk12FIpHmBAMDUjZxxeM9lpp3igNr4jyftaHSwRjBy60NnzKe1N64H7GPl+sg2GluT8KJc0y097LUfnmxHmAB+siyPHhh9LdjNCa5WP0DRHiS96tX3lo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redpanda.com; spf=pass smtp.mailfrom=redpanda.com; dkim=pass (2048-bit key) header.d=redpanda.com header.i=@redpanda.com header.b=lGLmdkkV; arc=none smtp.client-ip=209.85.219.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redpanda.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redpanda.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=redpanda.com header.i=@redpanda.com header.b="lGLmdkkV"
Received: by mail-qv1-f51.google.com with SMTP id 6a1803df08f44-8cce87d7995so12095706d6.0
        for <linux-xfs@vger.kernel.org>; Fri, 29 May 2026 12:27:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redpanda.com; s=google; t=1780082847; x=1780687647; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=1T7lRX1vJ1Wj9JNwItxpA7mGR6CIeTgq8xgA3eOaQnM=;
        b=lGLmdkkVigib5vd4v0G36O53/bNSBdZqSqiCGkwab+wzBTx7PnO7bkM1H6nuiKsamm
         XDv2CuDfv4WOXZWNTUKRyyn73v1bEvUMTUbdikzMDDBpx6gfxst5uWWUCCw8awX3kGrJ
         pesLvVWESyoBDNqc54zFC1YzDxP0PCRdnmoBZUwpQeXTOyGPdbT8r7UBhfRVZ9om37cI
         lM3QeT0AxTcMKScT1tiCHVxAPFKb0sj1YXj9vkpkxJRKlk0FKc0mvib9WPwJYGAvQRs8
         HfOO8UYHhd4aXkC/hRwHQsgnLB2hfkaK44R/svxI/T4m/GYgO02YNTl4MmOvT9wpJFiT
         e1Ag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780082847; x=1780687647;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1T7lRX1vJ1Wj9JNwItxpA7mGR6CIeTgq8xgA3eOaQnM=;
        b=f8gfruU90dOu7xv9ECcih1zCWTImgx2wZWdu2QCg4jmV7jy6V+grAk+daQvqbLoa4e
         IWmJDv1d5EjWXf8jRRra2WoKpNNQ0zlJzZ2lpLMFOh4nOi8iq3HIPZ+FyeEVxfx3iNum
         GO7rBc4ZhzLd3jKW4X/tz21jTVmRTFGK774KnM85iJ+O8pKhais59Wtov/KEwLc8FD3/
         JfEbowIV6MI6YOGLFvpdbaa3T6tGdHEfsIUl9NGjznuoEAC6EyRgI//QmaZmT8G9nphu
         /h1de/PdoeG/QZDZbhgYkXbHF4MK7/t5OQRXPCrqLtomSC7tsxiLhzEf7hxxPDdVj+fx
         bKzw==
X-Forwarded-Encrypted: i=1; AFNElJ/ehNyBEiMQwhV9dvpikfGgZtiW0kvf3naQaV0xswxKi2tPWpHRdv5odNdq6ID/w52+SJxZm3/qPUw=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy6jSlo+cligSm5tYJJrDGa6YR0VYiKLQ+89T5KwVijVh8/lFbq
	AVEYXkL0DQOyy4jewci4a0ehfPR0nujyQj+kEJDM1eFLUjsoqK48+9CNvJhf71HTd5fVQIQSJoe
	ixgOVrRtJZSz0EIzQKQw9fqQGKkmLjPM4C/77Dll2rbQydsRG8+5VZvrU
X-Gm-Gg: Acq92OFdqQ8zHzbbF8WDaFoPJfcopEub59tjCYnNfrtA+o1/25Vie2gaOXGagEWcB4x
	zPZm7KuuJFrw2jUmqPdLf6gdF8Cn/e/9hyGSuNGzxbqOejO3HgJPoJfuhMoGk8d9IDKb22b6Foo
	5Zb7ky5z9lU2OYdclN83+N2IcqIMFSan3OA6+IFUgh+Qn6Cm/sw+7fpp3iyMiT1zrY2O5amHpkV
	ypQY1YRH0ceg9trW4QVa7f00/VRrz1FlOKYkDmaqbJ2qL846yXThT4hGSTWLn4bvK6dekWEv7Lt
	yDO7tMm+auucNVZTkVBdZUYlhJNFcyh/+Mb4PfIpso7cuxd31rGg4KNU52hsRncU9MeQd7PWvWp
	LT5iXM7IG1pF/geKdhNURkEAIjjznP4d8e8fVmnuU0omKuuYTpuV0T8epzkpRZAJx/CmymikrMp
	iwu2KddE2IqKRg0elTm8N/VSal7wHRnfpNvzwSmBdY4VDgO2gt
X-Received: by 2002:ad4:5b87:0:b0:8cc:3546:262b with SMTP id 6a1803df08f44-8ccefd84a0emr18556836d6.24.1780082846949;
        Fri, 29 May 2026 12:27:26 -0700 (PDT)
Received: from fedora.tail5a808e.ts.net ([72.228.86.65])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8ccea2163b0sm25284466d6.38.2026.05.29.12.27.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 May 2026 12:27:26 -0700 (PDT)
From: Brandon Allard <brandon@redpanda.com>
To: fstests@vger.kernel.org
Cc: zlang@kernel.org,
	linux-xfs@vger.kernel.org,
	Brandon Allard <brandon@redpanda.com>
Subject: [PATCH] xfs: test NOWAIT DIO writes that span written/unwritten boundaries
Date: Fri, 29 May 2026 15:27:14 -0400
Message-ID: <20260529192714.21602-1-brandon@redpanda.com>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Gm-Spam: 0
X-Gm-Phishy: 0

Add a regression test exercising IOMAP_NOWAIT direct-IO writes around
the written/unwritten extent boundary that arises from preallocated
sequential append workloads.

Commit 883a790a8440 ("xfs: don't allow NOWAIT DIO across extent
boundaries") added a guard in xfs_direct_write_iomap_begin that returns
-EAGAIN under IOMAP_NOWAIT when the imap returned by xfs_bmapi_read
does not cover the entire requested range. A subsequent kernel patch
coalesces a (NORM, UNWRITTEN) pair into a single in-memory iomap when
the two records are physically contiguous on disk, restoring the
success path for the workload above.

The test covers five scenarios:
  A. NOWAIT DIO inside a single NORM extent must succeed.
  B. NOWAIT DIO inside a single UNWRITTEN extent must succeed.
  C. NOWAIT DIO spans NORM->UNWRITTEN, contiguous must succeed
     (the new code path).
  D. NOWAIT DIO spans UNWRITTEN->NORM, contiguous must return
     -EAGAIN (asymmetric guard; only N->U is safe to merge).
  E. NOWAIT DIO spans NORM->HOLE must return -EAGAIN (hole guard
     from 883a790a8440 preserved).

The scratch filesystem is mounted with -o lazytime so the NOWAIT path
does not bail in the mtime-update transaction (a separate -EAGAIN
source unrelated to extent-boundary handling). It is mkfs'd with
-b size=4096 so byte offsets in the golden output are stable across
host architectures.

Signed-off-by: Brandon Allard <brandon@redpanda.com>

This test exercises behavior introduced by the accompanying kernel
patch "xfs: coalesce contiguous unwritten suffix into iomap for NOWAIT
writes" posted to linux-xfs:
  https://lore.kernel.org/linux-xfs/20260529191100.4142371-1-brandon@redpanda.com/

Scenario C will fail on kernels that do not include that patch. If the
kernel patch is accepted, the XXXXXXXXXXXXX placeholder in
_fixed_by_kernel_commit should be replaced with the real commit SHA.
---
 tests/xfs/842     | 152 ++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/842.out |  42 +++++++++++++
 2 files changed, 194 insertions(+)
 create mode 100755 tests/xfs/842
 create mode 100644 tests/xfs/842.out

diff --git a/tests/xfs/842 b/tests/xfs/842
new file mode 100755
index 0000000..ab93dc3
--- /dev/null
+++ b/tests/xfs/842
@@ -0,0 +1,152 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2026 Redpanda Data, Inc.
+#
+# FS QA Test No. 842
+#
+# Test several scenarios for RWF_NOWAIT direct-IO writes on XFS, focused on
+# the WRITTEN<->UNWRITTEN extent boundary case.
+#
+# Background:
+#   Commit 883a790a8440 ("xfs: don't allow NOWAIT DIO across extent
+#   boundaries") added a guard in xfs_direct_write_iomap_begin that returns
+#   -EAGAIN under IOMAP_NOWAIT when the imap returned by xfs_bmapi_read does
+#   not span the entire requested range. The guard prevents NOWAIT callers
+#   from observing short writes when the range needs multiple bios.
+#
+#   For sequential append-DIO workloads with adaptive preallocation, requests
+#   regularly straddle a NORM extent (just-written head) and a physically
+#   contiguous UNWRITTEN extent (preallocated tail). A single bio covers both
+#   safely; no short-write hazard exists. A subsequent fix coalesces the two
+#   records in the in-memory iomap and reports the merged range as UNWRITTEN
+#   so the completion handler converts the suffix normally.
+#
+# Scenarios:
+#   A. NOWAIT DIO inside a single NORM extent          -- must succeed
+#   B. NOWAIT DIO inside a single UNWRITTEN extent     -- must succeed
+#   C. NOWAIT DIO spans NORM -> UNWRITTEN, physically  -- must succeed
+#      contiguous (the fix)
+#   D. NOWAIT DIO spans UNWRITTEN -> NORM, physically  -- must fail (-EAGAIN)
+#      contiguous (coalesce path is intentionally
+#      asymmetric: only N->U is safe to merge)
+#   E. NOWAIT DIO spans NORM -> HOLE                   -- must fail (-EAGAIN)
+#      (hole guard from 883a790a8440 preserved)
+#
+# The scratch filesystem MUST be mounted with -o lazytime; without it the
+# NOWAIT path bails earlier in the mtime-update transaction (separate
+# -EAGAIN source unrelated to extent-boundary handling) and scenarios B/C
+# would return -EAGAIN for the wrong reason.
+#
+# The scratch filesystem is mkfs'd with -b size=4096 so byte offsets in the
+# golden output are stable across host architectures.
+#
+. ./common/preamble
+_begin_fstest auto quick rw prealloc
+
+# Override the default cleanup function.
+_cleanup()
+{
+	cd /
+	rm -f $tmp.*
+	_scratch_unmount 2>/dev/null
+}
+
+# Import common functions.
+. ./common/filter
+
+_require_scratch
+_require_xfs_io_command "falloc"
+_require_xfs_io_command "fiemap"
+_require_xfs_io_command "pwrite" "-N"
+
+_fixed_by_kernel_commit XXXXXXXXXXXXX \
+	"xfs: coalesce contiguous unwritten suffix into iomap for NOWAIT writes"
+
+_scratch_mkfs_xfs -b size=4096 >> $seqres.full 2>&1
+_scratch_mount "-o lazytime"
+
+# Defensive: confirm mkfs honored the requested block size. The offsets in
+# the golden output assume bsize == 4096.
+bsize=$(_get_file_block_size $SCRATCH_MNT)
+[ "$bsize" -eq 4096 ] || _notrun "fs block size is $bsize, expected 4096"
+
+# All offsets/sizes are multiples of the 4096-byte block size enforced above.
+HEAD_BYTES=4096       # 1 block (NORM head after split)
+TAIL_BYTES=32768      # 8 blocks (UNWRITTEN tail / NORM tail)
+ALLOC_BYTES=36864     # 9 blocks (HEAD + TAIL, one allocation)
+SPAN_BYTES=8192       # 2 blocks (spans a single extent boundary)
+
+# Return 0 if the first two extents in $1 are physically adjacent.
+# _filter_xfs_io_fiemap emits one space-separated record per extent:
+#   first_logical last_logical first_physical last_physical (512-byte sectors).
+_extents_are_contiguous()
+{
+	$XFS_IO_PROG -c "fiemap" "$1" 2>/dev/null \
+		| _filter_xfs_io_fiemap \
+		| awk 'NR==1 { end=$4 } NR==2 { exit !(end + 1 == $3) }'
+}
+
+# Scenario A: NOWAIT DIO inside a single NORM extent. Must succeed.
+echo
+echo "== A: NOWAIT DIO inside a single NORM extent (must succeed) =="
+fa=$SCRATCH_MNT/A
+$XFS_IO_PROG -fd -c "pwrite -S 0xaa 0 $ALLOC_BYTES" $fa | _filter_xfs_io
+$XFS_IO_PROG -d -c "pwrite -N -V 1 -S 0xbb -b $SPAN_BYTES 0 $SPAN_BYTES" $fa \
+	| _filter_xfs_io
+od -A d -t x1 -N $SPAN_BYTES $fa
+
+# Scenario B: NOWAIT DIO inside a single UNWRITTEN extent. Must succeed.
+echo
+echo "== B: NOWAIT DIO inside a single UNWRITTEN extent (must succeed) =="
+fb=$SCRATCH_MNT/B
+$XFS_IO_PROG -fdt -c "falloc 0 $ALLOC_BYTES" $fb | _filter_xfs_io
+$XFS_IO_PROG -d -c "pwrite -N -V 1 -S 0xcc -b $SPAN_BYTES 0 $SPAN_BYTES" $fb \
+	| _filter_xfs_io
+od -A d -t x1 -N $SPAN_BYTES $fb
+
+# Scenario C: NOWAIT DIO spans NORM -> UNWRITTEN, physically contiguous.
+echo
+echo "== C: NOWAIT DIO spans NORM->UNWRITTEN, contiguous (must succeed) =="
+fc=$SCRATCH_MNT/C
+# The allocator preserves physical contiguity across the split, which is
+# what we need to exercise the coalesce path.
+$XFS_IO_PROG -fdt -c "falloc 0 $ALLOC_BYTES" $fc | _filter_xfs_io
+$XFS_IO_PROG -d -c "pwrite -S 0xdd 0 $HEAD_BYTES" $fc | _filter_xfs_io
+
+if ! _extents_are_contiguous $fc; then
+	_notrun "C: allocator placed split extents non-contiguously, cannot exercise W<->U coalesce on this run"
+fi
+
+$XFS_IO_PROG -d -c "pwrite -N -V 1 -S 0xee -b $SPAN_BYTES 0 $SPAN_BYTES" $fc \
+	| _filter_xfs_io
+od -A d -t x1 -N $SPAN_BYTES $fc
+
+# Scenario D: NOWAIT DIO spans UNWRITTEN -> NORM (physically contiguous).
+echo
+echo "== D: NOWAIT DIO spans UNWRITTEN->NORM, contiguous (must EAGAIN) =="
+fd=$SCRATCH_MNT/D
+$XFS_IO_PROG -fdt -c "falloc 0 $ALLOC_BYTES" $fd | _filter_xfs_io
+$XFS_IO_PROG -d -c "pwrite -S 0x11 $TAIL_BYTES $HEAD_BYTES" $fd | _filter_xfs_io
+
+if ! _extents_are_contiguous $fd; then
+	_notrun "D: allocator placed split extents non-contiguously, cannot exercise U<->W asymmetric guard on this run"
+fi
+
+# Span ends at offset (TAIL_BYTES + HEAD_BYTES), crosses the U->N boundary.
+span_d_off=$((TAIL_BYTES - HEAD_BYTES))
+$XFS_IO_PROG -d -c "pwrite -N -V 1 -S 0x22 -b $SPAN_BYTES $span_d_off $SPAN_BYTES" $fd
+# Confirm the would-be data was not written: tail block should still be 0x11.
+od -A d -t x1 -j $TAIL_BYTES -N $HEAD_BYTES $fd
+
+# Scenario E: NOWAIT DIO spans NORM -> HOLE.
+echo
+echo "== E: NOWAIT DIO spans NORM->HOLE (must EAGAIN) =="
+fe=$SCRATCH_MNT/E
+$XFS_IO_PROG -fd -c "pwrite -S 0x33 0 $HEAD_BYTES" $fe | _filter_xfs_io
+$XFS_IO_PROG -d -c "pwrite -N -V 1 -S 0x44 -b $SPAN_BYTES 0 $SPAN_BYTES" $fe
+# Confirm: head block must still hold the original 0x33 pattern; if the
+# NOWAIT write had partial-committed, we would see 0x44 here instead.
+od -A d -t x1 -N $HEAD_BYTES $fe
+
+status=0
+exit
diff --git a/tests/xfs/842.out b/tests/xfs/842.out
new file mode 100644
index 0000000..6cbfc2a
--- /dev/null
+++ b/tests/xfs/842.out
@@ -0,0 +1,42 @@
+QA output created by 842
+
+== A: NOWAIT DIO inside a single NORM extent (must succeed) ==
+wrote 36864/36864 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 8192/8192 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+0000000 bb bb bb bb bb bb bb bb bb bb bb bb bb bb bb bb
+*
+0008192
+
+== B: NOWAIT DIO inside a single UNWRITTEN extent (must succeed) ==
+wrote 8192/8192 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+0000000 cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc
+*
+0008192
+
+== C: NOWAIT DIO spans NORM->UNWRITTEN, contiguous (must succeed) ==
+wrote 4096/4096 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 8192/8192 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+0000000 ee ee ee ee ee ee ee ee ee ee ee ee ee ee ee ee
+*
+0008192
+
+== D: NOWAIT DIO spans UNWRITTEN->NORM, contiguous (must EAGAIN) ==
+wrote 4096/4096 bytes at offset 32768
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+pwrite: Resource temporarily unavailable
+0032768 11 11 11 11 11 11 11 11 11 11 11 11 11 11 11 11
+*
+0036864
+
+== E: NOWAIT DIO spans NORM->HOLE (must EAGAIN) ==
+wrote 4096/4096 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+pwrite: Resource temporarily unavailable
+0000000 33 33 33 33 33 33 33 33 33 33 33 33 33 33 33 33
+*
+0004096
-- 
2.52.0

