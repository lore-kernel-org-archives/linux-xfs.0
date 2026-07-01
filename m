Received: from va-1-111.ptr.blmpb.com (va-1-111.ptr.blmpb.com [209.127.230.111])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AAAA3630AF
	for <linux-xfs@vger.kernel.org>; Wed,  1 Jul 2026 03:33:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.230.111
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782876814; cv=none; b=O45JPht+xh7PwG0ayLDthB2Z9mIy8nwE8OvUyjLX0SM3O7FbR7FORoRzf7L2Ru0OevuY9jLrfmidjmXd2iByqmsmXUwJBlmMdVY0pGLW2Ujena0UCJpAo2OWceifo1qItb1HGlnQPYmFgy5PHTn0dnUy9dmMYQ/3nhJq3Xaj6d4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782876814; c=relaxed/simple;
	bh=ZM1IJ6mhSVKzIIJ/IqFh1sjqKwaqjT0Il3Q6CAeBItU=;
	h=From:Subject:Date:Mime-Version:To:Cc:Message-Id:Content-Type; b=hHbbxCdo4nvyMUDDfSGvRkfTDNQtwscdyRzYXqJUIbxOhHNVpB5qAKn8MycEiozusCx38bWftF+yCTy7sFQ6fx3kLht+L7D8+tqbukbrg3RmjkWt9WEyqEIgs4aOOxEBhKIdq71FZm+NIuRjEedbx7wp/vN2dmzVAs+musmdhjU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com; spf=pass smtp.mailfrom=bytedance.com; dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b=JyrfbDQk; arc=none smtp.client-ip=209.127.230.111
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b="JyrfbDQk"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1782876806; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=IKK8LU/Wb3ZuGrBCv/2xxvWMEeMBbcLTbcZDIUYuWww=;
 b=JyrfbDQkCqaczrZCuxnqkLhSp0c856oEI10yW02L0Ndx2P3ix4G5QbQuMFDYwAmyhpG7k8
 ybv/4n3P0KpSX+PPh16Nxp55w7peITIPB0vX3o2Yr2GYLxfhN0jGL+EsrW2oyYurtY4fmb
 jPi9X1AKxToce4qYVFniJlmoDWX1X52bxEg11EYqvBXseyi+xyQsvPRn3SL71+jel+kNau
 2cluye5y3SaCuC1BgnTCDMiTqydaJWyp6xmMhiVlDApgLRmdFCCgDuFWgvIXGSxmATrTV6
 hOZO/nPteAj2btj/f6OuLq9DWXT4WKsDMy8QS7iNSE8p63HMRjUar/PSfEgMPA==
From: "Fengnan Chang" <changfengnan@bytedance.com>
Subject: [PATCH v6 0/3] iomap: add simple dio path for small direct I/O
Date: Wed,  1 Jul 2026 11:32:50 +0800
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Lms-Return-Path: <lba+26a448a84+2ad2c2+vger.kernel.org+changfengnan@bytedance.com>
X-Original-From: Fengnan Chang <changfengnan@bytedance.com>
Content-Transfer-Encoding: 7bit
To: <brauner@kernel.org>, <djwong@kernel.org>, <hch@infradead.org>, 
	<ojaswin@linux.ibm.com>, <dgc@kernel.org>, <linux-xfs@vger.kernel.org>, 
	<linux-fsdevel@vger.kernel.org>, <linux-ext4@vger.kernel.org>, 
	<linux-kernel@vger.kernel.org>, <lidiangang@bytedance.com>, 
	<pankaj.raghav@linux.dev>
Cc: "Fengnan Chang" <changfengnan@bytedance.com>
Message-Id: <20260701033253.46420-1-changfengnan@bytedance.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
Content-Type: text/plain; charset=UTF-8

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

Introduce a simple dio path to reduce the overhead of iomap. It is
triggered when the request satisfies all of:
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

After this optimization, the heavy generic functions disappear from the
profile, replaced by a single streamlined execution path:
  4.83%  [kernel]  [k] iomap_dio_simple

With this patch, 4K random read IOPS on ext4 increases from 1.92M to
2.19M in the original single-core io_uring poll-mode workload.

Below are the test results using fio:

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

Changes since v5:
- Collect Reviewed-by tags from Christoph for the two prep patches.
- Drop the iomap_dio_bio_release_pages() helper and open-code the simple
  path page release logic.
- Remove unused kobject.h and sysfs.h includes.
- Clean up iomap_dio_simple_complete() to branch on bio->bi_status and
  pass the final error value to trace_iomap_dio_complete().
- Move the fast path documentation above iomap_dio_simple(), and fold
  the dops and done_before checks into iomap_dio_simple_supported().
- Fix declaration ordering, indentation, and field alignment nits.

Changes since v4:
- Update test data based on v7.2-rc1.
- Split refactoring into prep patches.
- Remove three-state atomic synchronization; use submit_bio_wait for
  sync and direct ki_complete from end_io for async.
- Drop the _read suffix from struct and function names.
- Remove bounce buffer handling as bounce requires dops.
- Remove redundant iomap.offset > pos check.
- Guard s_dio_done_wq allocation with !wait_for_completion.
- Add explicit !count early-return in supported() check.

Changes since v3:
- Fix fserror report and update test data based on v7.1-rc3.

Changes since v2:
- Update test data based on v7.1-rc3.

Fengnan Chang (3):
  iomap: factor out iomap_dio_alignment helper
  iomap: pass error code to should_report_dio_fserror directly
  iomap: add simple dio path for small direct I/O

 fs/iomap/direct-io.c | 293 +++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 286 insertions(+), 7 deletions(-)

-- 
2.39.5 (Apple Git-154)
