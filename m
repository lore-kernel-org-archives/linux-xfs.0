Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3639145B27
	for <linux-xfs@vger.kernel.org>; Sun, 12 Jul 2026 22:08:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783894139; cv=none; b=ZHvdED9LTnKS7j3Lwwq/xh7HNaAIHmK1KrQ/KWk5omEYLjCxkXWNFeW32y0ykLSGRCzlCbqH0RnXsePbpmMbraDoB5mS6Lqh6zXOiHQ3x3czvu6VKx3ZCrcFqVFNLpoWiS7B+EcO+GxMbrh2AR3mINNLAr7bsOlHX2p4A4HG3fE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783894139; c=relaxed/simple;
	bh=4BuUyPARn/tz3lsDji72T9JUUe3DM1Pt0tBK6CMeVoY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=YrbvmsRhZ64LmxEQatAQ/NlqcqU/F2aDqmUSz8mC7VConHcYcEcEQr7ty5u54bXAMXBUcro6480noxwDYWMobnaR9ql4vptmW7i/MKIj+ZSbmANOiUH77MSrzoucR+N4Mw+xtUy8Vuv0qjTyTXgPDWeOrYPifb2Ez5Nbkzgg67U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=asu.edu; spf=pass smtp.mailfrom=asu.edu; dkim=pass (2048-bit key) header.d=asu.edu header.i=@asu.edu header.b=lvfcki/m; arc=none smtp.client-ip=209.85.214.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=asu.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=asu.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=asu.edu header.i=@asu.edu header.b="lvfcki/m"
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-2ca64c3ce5fso28822555ad.3
        for <linux-xfs@vger.kernel.org>; Sun, 12 Jul 2026 15:08:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=asu.edu; s=google; t=1783894137; x=1784498937; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=DL9w1+Cjadf8xCjP1+t/5nY7oqPs2u0aMgQpWvEYT3U=;
        b=lvfcki/meoukVb5r0i8x3095dmV/CLivCb3YzBDo4vD+JM0AUXGZyoQRKlS/+xOlNJ
         UkAjZ1m6wtQ0dXt+H9l7IO3QdHdP4c3Itm8mNmVHxOd03iw0a8yw2Ojs0JdvQBcWFPF2
         21UYPRQHEA3C/htowzYw7SX2yiURiT7r4MhXOTbRt9dMa6UHY9Rb635sc+sMGjNkim8m
         LuWm3w1/pUyV0fbLKb3Ab2AffihCdBVDqyevlszqC0NkZT5QTNt6ptZzG8bkX75JVUna
         0hnWdk/uOJTB1NwHc6U2yj7JHyHXkzIJryuVukrK/bMyVpDSK7VZxpE3Wpz4X9Sk7USV
         oM5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783894137; x=1784498937;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=DL9w1+Cjadf8xCjP1+t/5nY7oqPs2u0aMgQpWvEYT3U=;
        b=qwsT3YkytwSkn96wd7Vo8qNwzE+qFFLHprGgeRLVPquuATvW6K5kuhdO/szstB4Bqx
         yGOXFbh2hMGBNqVgWRcKHuFbFQhIwPTEyfYaqcojQlC0T2L66pDTbYHlBQmbv7MoUbpq
         z+7g5p4XuQwPhqv4mv1/Cv3YTCDb2Jqfsbtbfom1A93VyuwlvImLvWDC6X7SfufXauXH
         9MXxpY5TYx3xI873MQy7hvd0sN2M8mDaa1OPKSF76ZlODN4a3XPiUXfjCbYJqoODG1Id
         9oywk1xlwUN6LYI1mSeOWC74QRMJX0pNKljXzJ11So0jW0m6yf6U9hXY0SX5fh6mq6In
         6ikQ==
X-Gm-Message-State: AOJu0Yx55f+dt0gL4C9GOCvFuSt56X9BOCMXEIcCHpCfdSQT33MUvpNE
	zgeB16nD7syNgd6fyt4uZLSmto+f9csRAuu867A30YNxZQaaqH/HF1cd9FsU8ICHo2E+3opOMem
	ClSo=
X-Gm-Gg: AfdE7cmOWDW7MZJLbkt0zlSDOz1oKUCW0c5EGmtKo6ekI5AgvMJpZpWPqCqv6li3/vB
	ic1WGTGmsrkWLDJjWrocMOm5L3r+65du3G+Wk44BM2boXlr5nWGo0GYJxZb0w4myoV3QlP5t9lv
	oHV2pxOrMyqmRdl6Qyv5wv3QUQbTH8ueBLJ3A4Xb5hLsac6dh+XIM1m+Dpaxi8kaKlSrECfTFDX
	woNHwaIsb/VjSwf62MYqzYDGaRMOLje29IPtUCo3YZqbeaVGwfqjTe3zoUTqy8Jv9oyuLtlLhow
	ypqo1wJOa+v+SSe7NA1ncZF4K8CcxmPjaqRFP2+X2GU868Au9jKco3m1vP57ywAphztELSKIS19
	KGJsVgAVr2BXNIzT4RsPtYN281bB7IndQoXwgP2b9Mff3JNU9WD/1SvFNzXJN/3G+O+Ca3cDSiW
	gNNFejFbU=
X-Received: by 2002:a17:902:f683:b0:2ca:481:de45 with SMTP id d9443c01a7336-2ce9e7ac3d4mr66677185ad.6.1783894137334;
        Sun, 12 Jul 2026 15:08:57 -0700 (PDT)
Received: from p1.. ([2607:fb90:eca4:601:96a2:dc03:fbca:601e])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ccc9bdb775sm89285145ad.2.2026.07.12.15.08.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 12 Jul 2026 15:08:57 -0700 (PDT)
From: Xiang Mei <xmei5@asu.edu>
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	bestswngs@gmail.com,
	Xiang Mei <xmei5@asu.edu>
Subject: [PATCH] xfs: reject log continuation for a header-only item in recovery
Date: Sun, 12 Jul 2026 15:08:54 -0700
Message-ID: <20260712220854.3131445-1-xmei5@asu.edu>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On an XLOG_WAS_CONT_TRANS op, xlog_recover_add_to_cont_trans() extends the
tail item's last region via item->ri_buf[item->ri_cnt-1] without checking
that the item has one. A header-only item, created by
xlog_recover_add_to_trans() when a transaction's first op is a bare
sizeof(struct xfs_trans_header) op carrying XFS_TRANS_HEADER_MAGIC, sits on
r_itemq with ri_cnt == 0 and ri_buf == NULL. A crafted log whose ops are
XLOG_START_TRANS, that header op, then XLOG_WAS_CONT_TRANS thus
dereferences ((struct kvec *)NULL)[-1] and faults during mount(2) log
recovery of an untrusted XFS image.

A valid XLOG_WAS_CONT_TRANS only follows a region written with
XLOG_CONTINUE_TRANS, so ri_cnt >= 1 always holds for a real log. Reject the
ri_cnt == 0 case as corruption with -EFSCORRUPTED, which the caller already
propagates to abort recovery.

  BUG: unable to handle page fault for address: fffffffffffffff0
  #PF: supervisor read access in kernel mode
  Oops: 0000 [#1] SMP KASAN NOPTI
  RIP: 0010:xlog_recover_add_to_cont_trans (fs/xfs/xfs_log_recover.c:2135)
  Call Trace:
   xlog_recovery_process_trans (fs/xfs/xfs_log_recover.c:2306)
   xlog_recover_process_data (fs/xfs/xfs_log_recover.c:2500)
   xlog_do_recovery_pass (fs/xfs/xfs_log_recover.c:3243)
   xlog_do_log_recovery (fs/xfs/xfs_log_recover.c:3331)
   xlog_do_recover (fs/xfs/xfs_log_recover.c:3368)
   xlog_recover (fs/xfs/xfs_log_recover.c:3493)
   xfs_log_mount (fs/xfs/xfs_log.c:617)
   xfs_mountfs (fs/xfs/xfs_mount.c:1031)
   xfs_fs_fill_super (fs/xfs/xfs_super.c:1940)
   get_tree_bdev_flags (fs/super.c:1634)
   vfs_get_tree (fs/super.c:1694)
   fc_mount (fs/namespace.c:1198)
   path_mount (fs/namespace.c:4161)
   __x64_sys_mount (fs/namespace.c:4367)
   do_syscall_64 (arch/x86/entry/syscall_64.c:94)
   entry_SYSCALL_64_after_hwframe (arch/x86/entry/entry_64.S:121)
  Kernel panic - not syncing: Fatal exception

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Reported-by: Weiming Shi <bestswngs@gmail.com>
Assisted-by: Claude:claude-opus-4-8
Signed-off-by: Xiang Mei <xmei5@asu.edu>
---
 fs/xfs/xfs_log_recover.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 5f984bf5698a..fa8e04bf1aac 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -2131,6 +2131,9 @@ xlog_recover_add_to_cont_trans(
 	item = list_entry(trans->r_itemq.prev, struct xlog_recover_item,
 			  ri_list);
 
+	if (item->ri_cnt == 0)
+		return -EFSCORRUPTED;
+
 	old_ptr = item->ri_buf[item->ri_cnt-1].iov_base;
 	old_len = item->ri_buf[item->ri_cnt-1].iov_len;
 
-- 
2.43.0

