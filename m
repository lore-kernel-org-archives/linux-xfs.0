Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA20114E2CF
	for <linux-xfs@vger.kernel.org>; Tue,  7 May 2024 09:37:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715074632; cv=none; b=fCRDL4wjF6iR4r2ivkgtx5ngYv2mHG9nkg+fM9RYj1XqDI1nKuhBLN1mYzSRxMrieYXRAWWK7u5EIGOvqnf6SPvtdEuP71JQBLn6SD6lsACXhZFiQyueEauqyNliDszgL4jwERSgS7SbRc+AR6FjOHWtn0F9jFGIfQYafxJ8Lys=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715074632; c=relaxed/simple;
	bh=shEijL8kbOhHu5Kz4+l/siVB4BXE08suIwf+RlHPU3s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HzNDlIJ5SuFltVuPq9x0QiOhXAfXndQ0wi9PtuTOSqVxQPIsjaqMvP7XDoM4SE03qPyxMJR8ZeNAI7uLLrsKhBBSsYfNyDfQhbjP1OE/8CTGaE0aweHvPE0JdOP48SGG0AYQgs1bdoLWZf74ncw+U2a3rKh+eAsCZbW8Ymh7NsA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=DGkrkv6r; arc=none smtp.client-ip=209.85.214.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DGkrkv6r"
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-1e50a04c317so13478605ad.1
        for <linux-xfs@vger.kernel.org>; Tue, 07 May 2024 02:37:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1715074628; x=1715679428; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RkqU0x7qhPKQL3s9sehYOXpVvL4C5XlveH89N21UO3Y=;
        b=DGkrkv6rNSqrlVWQLk0OuiAw/5TGEnjn0VQvhFL6KPkeAnNEtjYMQmQx6B/GB1zSuc
         4HPWmAM+rPDyPBzAOmUMsACg2tvl6Phwc9t0aOjxmpkA/bBgSkNL5k7KbBKFJLpnuyb3
         wYg3yLaAjEmW4Qk4bBbMDXih4TCOgb7bcVJGfQrpihHsvAfC1uO0s1lmHgmXuWjX8U2A
         F6VLT5gBD6KGZzRrKDJZU2iMuV4y8x+2vH+NXJtydGVKnVeH+RwA6MxMX/Cynbh5eVae
         1vN+/yLKkfUwZbFvAtLPMhdjSQ6fnVqOWNNW6vIMSrN3oxM9mCCzGt3A926SHBhuYSNg
         X9GQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715074629; x=1715679429;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=RkqU0x7qhPKQL3s9sehYOXpVvL4C5XlveH89N21UO3Y=;
        b=YGX/aubsli52kPu3PQItSESHSJ6iQ2JdjV9aEpHtV1dm0jNC5ubVaD3HpTSmY6T8k5
         97dVgsVgfcLhwGwq+ZZvtpPC2jlGgbPu9OkqCsYKRZvScs/LlXG7n9sGMZkm/UwdKPP+
         2WM6WF93uHnBPWDmdYfzTR8BPmzv3y4iBVzvPvKnJ/O4nEy8IGwFyQEXGTzVpaFC179K
         eMSK/4asZgebtiKwfa1aF4K1Q5TXrGRZiqjsGfAK6KfP7PAPeHXZA0iseV34Wv6gz1TA
         eJOyUyRvzHTyYi8BPUSav6eiuUAActdskm7BE3XGg1g7FkLggv3qpUiM1n7SuHlq0KHT
         MF0Q==
X-Gm-Message-State: AOJu0YwvQePudKYGIVgkgFE4p5S5AcJNw3hqgPswv4Q7LDVpkt/Xgv9p
	4p9FqVQO5Wk8J/mLLhCDNqoTNBEbXzquhNMhOdSY6VCYv3mn3ve7xipR86v1
X-Google-Smtp-Source: AGHT+IHZzFqlqMHFcYBj3xJ8IxAIn3CK7jRVPChlusv5PoDdEwUECVuv301aQNuDIafhwUip9cbnJA==
X-Received: by 2002:a17:902:da87:b0:1e2:1915:2479 with SMTP id j7-20020a170902da8700b001e219152479mr15776914plx.12.1715074628612;
        Tue, 07 May 2024 02:37:08 -0700 (PDT)
Received: from dw-tp.ibmuc.com ([171.76.81.176])
        by smtp.gmail.com with ESMTPSA id j1-20020a17090276c100b001e49428f327sm9639129plt.176.2024.05.07.02.37.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 May 2024 02:37:08 -0700 (PDT)
From: "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>
To: linux-xfs@vger.kernel.org
Cc: Dave Chinner <david@fromorbit.com>,
	"Darrick J . Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@infradead.org>,
	Ojaswin Mujoo <ojaswin@linux.ibm.com>,
	Ritesh Harjani <ritesh.list@gmail.com>
Subject: [PATCHv4 1/1] xfs: Add cond_resched to block unmap range and reflink remap path
Date: Tue,  7 May 2024 15:06:55 +0530
Message-ID: <3e1986b79faa3307059ce9d57ff3e44c0d85fe4f.1715073983.git.ritesh.list@gmail.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <cover.1715073983.git.ritesh.list@gmail.com>
References: <cover.1715073983.git.ritesh.list@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

An async dio write to a sparse file can generate a lot of extents
and when we unlink this file (using rm), the kernel can be busy in umapping
and freeing those extents as part of transaction processing.

Similarly xfs reflink remapping path can also iterate over a million
extent entries in xfs_reflink_remap_blocks().

Since we can busy loop in these two functions, so let's add cond_resched()
to avoid softlockup messages like these.

watchdog: BUG: soft lockup - CPU#1 stuck for 22s! [kworker/1:0:82435]
CPU: 1 PID: 82435 Comm: kworker/1:0 Tainted: G S  L   6.9.0-rc5-0-default #1
Workqueue: xfs-inodegc/sda2 xfs_inodegc_worker
NIP [c000000000beea10] xfs_extent_busy_trim+0x100/0x290
LR [c000000000bee958] xfs_extent_busy_trim+0x48/0x290
Call Trace:
  xfs_alloc_get_rec+0x54/0x1b0 (unreliable)
  xfs_alloc_compute_aligned+0x5c/0x144
  xfs_alloc_ag_vextent_size+0x238/0x8d4
  xfs_alloc_fix_freelist+0x540/0x694
  xfs_free_extent_fix_freelist+0x84/0xe0
  __xfs_free_extent+0x74/0x1ec
  xfs_extent_free_finish_item+0xcc/0x214
  xfs_defer_finish_one+0x194/0x388
  xfs_defer_finish_noroll+0x1b4/0x5c8
  xfs_defer_finish+0x2c/0xc4
  xfs_bunmapi_range+0xa4/0x100
  xfs_itruncate_extents_flags+0x1b8/0x2f4
  xfs_inactive_truncate+0xe0/0x124
  xfs_inactive+0x30c/0x3e0
  xfs_inodegc_worker+0x140/0x234
  process_scheduled_works+0x240/0x57c
  worker_thread+0x198/0x468
  kthread+0x138/0x140
  start_kernel_thread+0x14/0x18

run fstests generic/175 at 2024-02-02 04:40:21
[   C17] watchdog: BUG: soft lockup - CPU#17 stuck for 23s! [xfs_io:7679]
 watchdog: BUG: soft lockup - CPU#17 stuck for 23s! [xfs_io:7679]
 CPU: 17 PID: 7679 Comm: xfs_io Kdump: loaded Tainted: G X 6.4.0
 NIP [c008000005e3ec94] xfs_rmapbt_diff_two_keys+0x54/0xe0 [xfs]
 LR [c008000005e08798] xfs_btree_get_leaf_keys+0x110/0x1e0 [xfs]
 Call Trace:
  0xc000000014107c00 (unreliable)
  __xfs_btree_updkeys+0x8c/0x2c0 [xfs]
  xfs_btree_update_keys+0x150/0x170 [xfs]
  xfs_btree_lshift+0x534/0x660 [xfs]
  xfs_btree_make_block_unfull+0x19c/0x240 [xfs]
  xfs_btree_insrec+0x4e4/0x630 [xfs]
  xfs_btree_insert+0x104/0x2d0 [xfs]
  xfs_rmap_insert+0xc4/0x260 [xfs]
  xfs_rmap_map_shared+0x228/0x630 [xfs]
  xfs_rmap_finish_one+0x2d4/0x350 [xfs]
  xfs_rmap_update_finish_item+0x44/0xc0 [xfs]
  xfs_defer_finish_noroll+0x2e4/0x740 [xfs]
  __xfs_trans_commit+0x1f4/0x400 [xfs]
  xfs_reflink_remap_extent+0x2d8/0x650 [xfs]
  xfs_reflink_remap_blocks+0x154/0x320 [xfs]
  xfs_file_remap_range+0x138/0x3a0 [xfs]
  do_clone_file_range+0x11c/0x2f0
  vfs_clone_file_range+0x60/0x1c0
  ioctl_file_clone+0x78/0x140
  sys_ioctl+0x934/0x1270
  system_call_exception+0x158/0x320
  system_call_vectored_common+0x15c/0x2ec

Cc: Ojaswin Mujoo <ojaswin@linux.ibm.com>
Signed-off-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
---
 fs/xfs/libxfs/xfs_bmap.c | 1 +
 fs/xfs/xfs_reflink.c     | 1 +
 2 files changed, 2 insertions(+)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 656c95a22f2e..44d5381bc66f 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -6354,6 +6354,7 @@ xfs_bunmapi_range(
 		error = xfs_defer_finish(tpp);
 		if (error)
 			goto out;
+		cond_resched();
 	}
 out:
 	return error;
diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index 7da0e8f961d3..5f26a608bc09 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -1417,6 +1417,7 @@ xfs_reflink_remap_blocks(
 		destoff += imap.br_blockcount;
 		len -= imap.br_blockcount;
 		remapped_len += imap.br_blockcount;
+		cond_resched();
 	}

 	if (error)
--
2.44.0

