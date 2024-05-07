Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C8B26BB4E
	for <linux-xfs@vger.kernel.org>; Tue,  7 May 2024 05:13:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715058813; cv=none; b=q+Oo47SHZEXFv7aME+oIBASbScc1+OLDCmqe6vD7M2l8ZmXczxFz5hQNFi/zLh5ezq2hp8yylmLyevyrsx3IgJlCJAScn3QtfjjBiEjSehFh57L/hSO6ZTBVoARW59lNzYcAPiuO35OJ0ARSJkAZlcOrqYaWs28fFgEAEq6JDTQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715058813; c=relaxed/simple;
	bh=/G9VPgx4VqnX3CRRoWGyR4CTbp0c2NOy6sQUHu1frjg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A/v4fJ32Q5D17vgJ7TOjC7Cbsn3/kBTW1ezViPrazhIZ+hZr7cUdoYBWpdxdVciU27JOiPJa8Clm06EUbn6ZKpcExYX4ylTGh/vAq6K0v/ScGapR+se/dMx/TkHwfTrNT8KjVMbt05hjIyjIyNZ3x1wz/tfLp1FJ7Y3qWX05650=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=l17je74s; arc=none smtp.client-ip=209.85.210.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="l17je74s"
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-6f4551f2725so2648469b3a.1
        for <linux-xfs@vger.kernel.org>; Mon, 06 May 2024 22:13:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1715058809; x=1715663609; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GaZTIxBUWXunOhSGdNx/ODtLyca0dgWoQMoZlHIwou4=;
        b=l17je74szk9zuBRDGdCva+SFmjwMb3NA6X7MHM5Zw6ckaRDhcBlGg+QhdMKd7acYa1
         CDohGl7rH7d607+cKjpsErhRtCN6MtNeLEq06Zf5Q0fR7/JuFzh6YkwtC8HM4vWz+mMd
         hKQTTqILBWIZOOEWljyoahF1L/5uMcMCmyBbJry/wjUP23UqQAsrdmTBF5+yuyIb0mlF
         u+XKh0CmGu3Y7SvRlSsxkNY3I1FFqaDeT/R+8BEVmdVWgroYR1HTLvR6irIrNX8cBvPi
         TEXl0qH6q3m0V78MMT/aj6Uj9aXDmF7Sr7yXFlFbCrFtX89q31tcKmZ75g/+6/UU9vz4
         5omg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715058809; x=1715663609;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GaZTIxBUWXunOhSGdNx/ODtLyca0dgWoQMoZlHIwou4=;
        b=f7JU4oIrTr+bsIjWnEq1+dRWc2pQPUVI+VyfOhOnsDF+POnS9gzHZO5W/O4I8q/cg/
         pd4cWwm+ua00fYCsqm9xtS/W4lZ4ZsPQs4l2aS6Intak6S1f28Dl0sh+swpt36xdPv+C
         90Yte3mz4xkZJa+PG2W58VIAn5plBex2HgUOcmaAtVofF76rMZIhKZpqQPECUtdko+QD
         KMh3YRNhhHl6r9ry0he8/TJzP493i7K0IViI7L0Fw5/YB1Mc7gBxtuLHgdt/tTnieXUR
         BPgSZXpxbd42P/Ud9YUrvoyFmaxrUpEGuFOmP+9aFTyjvYUcMD+trummnthck9BsQIBz
         Ma7g==
X-Gm-Message-State: AOJu0Yz2oXRSYAO0iHudsWJ/Di/66MRSxkGEs8NKheY7gqXklvNzEGf+
	4GZb851wxuuZxWUUBaZIM9x7/naNlM6bGjGs2GEVt7b25/GNva5Cz8kQCw==
X-Google-Smtp-Source: AGHT+IFucdQx1lsd747VUauKmpBmv32b/4TWHJsXzFV0Ihjt6PyruZEEw3adFOMd+EHhQS0CmQOAYA==
X-Received: by 2002:a05:6a20:748f:b0:1a9:5b3f:f139 with SMTP id p15-20020a056a20748f00b001a95b3ff139mr15715447pzd.25.1715058809517;
        Mon, 06 May 2024 22:13:29 -0700 (PDT)
Received: from dw-tp.ibmuc.com ([171.76.81.176])
        by smtp.gmail.com with ESMTPSA id t30-20020a056a00139e00b006f45fa013c0sm4763218pfg.85.2024.05.06.22.13.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 May 2024 22:13:28 -0700 (PDT)
From: "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>
To: linux-xfs@vger.kernel.org
Cc: Dave Chinner <david@fromorbit.com>,
	"Darrick J . Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@infradead.org>,
	Ojaswin Mujoo <ojaswin@linux.ibm.com>,
	Ritesh Harjani <ritesh.list@gmail.com>
Subject: [PATCHv3 1/1] xfs: Add cond_resched to xfs_defer_finish_noroll
Date: Tue,  7 May 2024 10:43:07 +0530
Message-ID: <fe5326ac64e9ba3e10e5521fa97061b45632e516.1715057896.git.ritesh.list@gmail.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <cover.1715057896.git.ritesh.list@gmail.com>
References: <cover.1715057896.git.ritesh.list@gmail.com>
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

Similarly xfs reflink remapping path also goes through
xfs_defer_finish_noroll() for transaction processing. Since we can busy loop
in this function, so let's add cond_resched() to avoid softlockup messages
like these.

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
 fs/xfs/libxfs/xfs_defer.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/xfs/libxfs/xfs_defer.c b/fs/xfs/libxfs/xfs_defer.c
index c13276095cc0..cb185b97447d 100644
--- a/fs/xfs/libxfs/xfs_defer.c
+++ b/fs/xfs/libxfs/xfs_defer.c
@@ -705,6 +705,7 @@ xfs_defer_finish_noroll(
 		error = xfs_defer_finish_one(*tp, dfp);
 		if (error && error != -EAGAIN)
 			goto out_shutdown;
+		cond_resched();
 	}

 	/* Requeue the paused items in the outgoing transaction. */
--
2.44.0

