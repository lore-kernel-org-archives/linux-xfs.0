Received: from va-2-113.ptr.blmpb.com (va-2-113.ptr.blmpb.com [209.127.231.113])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21D5E3FE35A
	for <linux-xfs@vger.kernel.org>; Mon, 29 Jun 2026 12:01:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.113
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782734521; cv=none; b=nxsHvBQyC2w1ntR2ytrnF9qSYubGzGvrpnWi94aaRKWU1UChxea/FoR8A1u7SeeM1PNcOdk9uHiGpY4gDiJbVk5UDcupm2p38AJnSy9J8lphCsIBA2b4xN17gKAORrv78LCk+lJjXF68Kz4e0x26qcLxvw5OtbLOB2r3iHwqlTM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782734521; c=relaxed/simple;
	bh=ZlzapoUmrW76+tshVOkkSmVTNQbD1bxNbbgkPGwgVxU=;
	h=Date:Message-Id:Mime-Version:From:Content-Type:Subject:To:Cc; b=fgcZuLncmniCaJ2AV3h44hOldpga76J5likHQQ4kTNIZidTNkQqnZ3brGVSg5A9PxM/6M9+oaPyynmXYVSMOCDzZrxYBNMoLhqCzDHVX9BJjbILJhdhCq0zI3DkpyOg/lsGJHTxZKoUTIzx7GO37WGl74EL8bBZ6BOHGqn6Wwu4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com; spf=pass smtp.mailfrom=bytedance.com; dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b=LlV0pFS8; arc=none smtp.client-ip=209.127.231.113
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b="LlV0pFS8"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1782734508; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=iVdG+euIA/bBbS9aNnCKi0pWZy/7dVFUmK8L1nVtZIE=;
 b=LlV0pFS8mcU/91YlRVVtl8qioAmnmUG03fnmhJQ+OGznPgmjaFaSvCVhWtm1vN3gSSx/uS
 bYKB9USj6Rqi+UZ63ASGeVKrLwfhKNuJrJIL55d2tjqJK3H6tenv8b05c/xbG55Ti3Qsyw
 Y1USu3FH0MTtGiU/XT8tvZZGlVRqkxncY3w9q8zorNJTY1OjAAi85B/hDNkADTdGFGhoC6
 uLxYY7o1JZJ0mCPO0ZWPV43YOf7YfRSc8kBoWLSOgWIiSUN3UKW98/D2awOTfREstbbHCf
 BsNL/+2bYHdjGDNB6BQl56/R0gnqa5teUd3mhI2B/4TXO2w4dgCdrQ16bBWLJg==
X-Lms-Return-Path: <lba+26a425eaa+cb6d65+vger.kernel.org+changfengnan@bytedance.com>
Date: Mon, 29 Jun 2026 20:01:20 +0800
Message-Id: <20260629120124.25223-1-changfengnan@bytedance.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
From: "Fengnan Chang" <changfengnan@bytedance.com>
X-Original-From: Fengnan Chang <changfengnan@bytedance.com>
Content-Type: text/plain; charset=UTF-8
Subject: [PATCH v5 0/4] iomap: add simple dio path for small direct I/O
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
To: <brauner@kernel.org>, <djwong@kernel.org>, <hch@infradead.org>, 
	<ojaswin@linux.ibm.com>, <dgc@kernel.org>, <linux-xfs@vger.kernel.org>, 
	<linux-fsdevel@vger.kernel.org>, <linux-ext4@vger.kernel.org>, 
	<linux-kernel@vger.kernel.org>, <lidiangang@bytedance.com>, 
	<pankaj.raghav@linux.dev>
Cc: "Fengnan Chang" <changfengnan@bytedance.com>
Content-Transfer-Encoding: 7bit

When running 4K random read workloads on high-performance Gen5 NVMe
SSDs, the software overhead in the iomap direct I/O path
(__iomap_dio_rw) becomes a significant bottleneck.

Using io_uring with poll mode for a 4K randread test on a raw block
device:
taskset -c 30 ./t/io_uring -p1 -d512 -b4096 -s32 -c32 -F1 -B1 -R1 -X1
-n1 -P1 /dev/nvme10n1
Result: ~3.2M IOPS

Running the exact same workload on ext4 and XFS:
taskset -c 30 ./t/io_uring -p1 -d512 -b4096 -s32 -c32 -F1 -B1 -R1 -X1
-n1 -P1 /mnt/testfile
Result: ~1.92M IOPS

Profiling the ext4 workload reveals that a significant portion of CPU
time is spent on memory allocation and the iomap state machine
iteration:
  5.33%  [kernel]  [k] __iomap_dio_rw
  3.26%  [kernel]  [k] iomap_iter
  2.37%  [kernel]  [k] iomap_dio_bio_iter
  2.35%  [kernel]  [k] kfree
  1.33%  [kernel]  [k] iomap_dio_complete

This series introduces a simple dio fast path to reduce the overhead.
It is triggered when the request satisfies all of:
- a READ request whose I/O size is <= inode blocksize (fits in a single
  block, no splits);
- no custom iomap_dio_ops (dops) registered by the filesystem;
- no caller-accumulated residual (done_before == 0);
- none of IOMAP_DIO_FORCE_WAIT / IOMAP_DIO_PARTIAL / IOMAP_DIO_BOUNCE
  set, the range is within i_size, and the inode is not encrypted.

The bio is allocated from a dedicated bioset whose front_pad embeds
struct iomap_dio_simple, so the whole request lives in a single
cacheline-aligned allocation and no separate struct iomap_dio is
needed.  Completion is handled inline from ->bi_end_io for the common
success case, and only punted to the s_dio_done_wq workqueue on error.

With this patch, 4K random read IOPS on ext4 increases from 1.92M to
2.19M in the original single-core io_uring poll-mode workload.

Below are the fio 4K direct randread results from a broader QD
sweep on a SOLIDIGM SB5PH27X038T NVMe SSD.  Each result is the
average of three 20-second runs after a 5-second ramp time, using a
128G test file and toggling /sys/kernel/iomap/simple_read:

  fs    workload       qd    simple=0      simple=1      gain
  ext4  libaio         1     18,740        18,761        +0.11%
  ext4  libaio         64    462,850       480,587       +3.83%
  ext4  libaio         128   459,498       478,824       +4.21%
  ext4  libaio         256   459,938       480,156       +4.40%
  ext4  io_uring       1     18,836        18,880        +0.24%
  ext4  io_uring       64    568,193       600,625       +5.71%
  ext4  io_uring       128   570,998       602,148       +5.46%
  ext4  io_uring       256   572,052       602,536       +5.33%
  ext4  io_uring_poll  1     19,283        19,272        -0.06%
  ext4  io_uring_poll  64    989,735       1,013,342     +2.39%
  ext4  io_uring_poll  128   1,467,336     1,538,444     +4.85%
  ext4  io_uring_poll  256   1,663,498     1,830,842     +10.06%
  xfs   libaio         1     18,764        18,776        +0.06%
  xfs   libaio         64    462,408       480,860       +3.99%
  xfs   libaio         128   461,280       480,819       +4.24%
  xfs   libaio         256   461,626       480,190       +4.02%
  xfs   io_uring       1     18,871        18,903        +0.17%
  xfs   io_uring       64    570,383       597,399       +4.74%
  xfs   io_uring       128   568,290       597,370       +5.12%
  xfs   io_uring       256   570,616       598,775       +4.93%
  xfs   io_uring_poll  1     19,211        19,315        +0.54%
  xfs   io_uring_poll  64    989,726       1,008,455     +1.89%
  xfs   io_uring_poll  128   1,430,426     1,513,064     +5.78%
  xfs   io_uring_poll  256   1,587,339     1,742,220     +9.76%

Changes since v4:
- update test data based on v7.2-rc1
- Split refactoring into prep patches (patches 1-3).
- Remove three-state atomic synchronization; use submit_bio_wait for
  sync and direct ki_complete from end_io for async.
- Drop _read suffix from struct/function names.
- Remove bounce buffer handling (bounce requires dops).
- Remove redundant iomap.offset > pos check.
- Guard s_dio_done_wq allocation with !wait_for_completion.
- Add explicit !count early-return in supported() check.

v4:
fix fserror report and update test data based on v7.1-rc3.

v3:
Test data updated based on v7.1-rc3.

Fengnan Chang (4):
  iomap: factor out iomap_dio_alignment helper
  iomap: factor out iomap_dio_bio_release_pages helper
  iomap: pass error code to should_report_dio_fserror directly
  iomap: add simple dio path for small direct I/O

 fs/iomap/direct-io.c | 291 ++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 277 insertions(+), 14 deletions(-)

-- 
2.39.5 (Apple Git-154)
