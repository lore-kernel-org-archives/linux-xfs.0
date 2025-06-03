Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21BFF49659;
	Tue,  3 Jun 2025 08:51:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748940667; cv=none; b=jfySVjsI/lzoDmD6k2IS+VZWzfw0vWcg+1BQWMnkIAfXMnQ5iDi7KDGJw1CRetgsN42mL3+EYbXlxsjaVUW2g4nXqOPSgl87OcA0IcNj/iAZ/zrLoXkZtvkeAjhf99BtBWicZ8riCPcXUIAg6Ce4HZlD3sVLjjeKIyUSpDiKrJ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748940667; c=relaxed/simple;
	bh=Lgsa5MJFhl8K4fETFUbeTctJhVv+6uLgpq39ZSdpBPU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Lzpoi/Ht4Hf89bXUen4sIpJLEMWM7Egy+0BzdYAn8quexiLFp57qaTyIfx5oFK90GByZqAGN70QtFOwTlHQXHx2N+Xi0Z7OT1frenyOb/ZQie1yMB3ydBjrB72zvT+pf4YpOAMxIBmj5AUXpwSfyOo5CKIOSRNPBK+LzwHiABC8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=DaasIIU+; arc=none smtp.client-ip=209.85.216.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DaasIIU+"
Received: by mail-pj1-f50.google.com with SMTP id 98e67ed59e1d1-3109f106867so6743967a91.1;
        Tue, 03 Jun 2025 01:51:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1748940665; x=1749545465; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=H/jzSrNNGwegJxjn5PzW04cTG3AcB9ieJwNwESrXMSE=;
        b=DaasIIU+rXBvjGXZuGhne3D3ljLo4ywExIs2r2+GzL0VNDkmsmRfBUv90/ZLfFMFMp
         FM4xdXOdX//w1brQJVSdWUedEUyYrafWCEMK3hCV2jfjjY5mvS6tQ9QldDVTcQ7/hORD
         4PXSAmzMfs2ykjAtiRy8yE7H/KfXod05kI85ekEcgJ2ouZFiTVzQ5tZR58ZYOedPam0i
         uWPrEf0OGozv91BQgw5x7SouAB8o3BKqvHbSHVv0Nh6fEWodegk9BhoNyZn6JDZqga5l
         qaKwZuzbiFDUNe7KgXbQqltcobe/25fN88lC8THccONwij03nyeMWw00LlasALwhGr1x
         lo1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748940665; x=1749545465;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=H/jzSrNNGwegJxjn5PzW04cTG3AcB9ieJwNwESrXMSE=;
        b=pG+AiU33fh/HfYsn11p/GHmFNB7+nYIOSbicScZnv1dcrX6nJAzdbhJcsQhUXFqAnk
         q31Aq9GlLAFHoBwzqD45ikwQlepSoDphzg2k7ZI+YXdl2hQwScRY4D7hYGW3HpAmS1Ri
         Jzf/aViuS6IOwLkfKc8xtMG0CBMbdTnrEbES2Q6muzA9B4JaJFeEOav+MQnJU3xLiImm
         IbL9LwIW1h+z5rzfr7AGwnNQl2mq8OVq000q0BdwGl4UBCcKWhjsgZCxtNu4WaLIRxwe
         e11EOyNcqEBUJzUiC32JnNmZ7EzvT6jGJbaGBSlMSHL2JnE1QgkgPrzH5oOnmri+VX4u
         rcXQ==
X-Forwarded-Encrypted: i=1; AJvYcCWPfLK7BnKqilfz/yuycaaN85hT/g+yNmErzBPWEEzRfDkzARmxDkRsPXxw3idHqN0BXl4iDlG12NEQQJ4=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz8fWDdYETGqeUIdS3Rkakz1iF3wWPRG+ckODos1niuBod4GkD7
	KfnMXcW5GMJx78LTyowHzpR+bgn4PKPaOmLuvlBD5kLzh6y3lpUoHNPA
X-Gm-Gg: ASbGncuQvOjmjpMntHdPkDb3ES534W9bPt0sByWf3x/EGQtEgBdPeSJzZIPkn75tD9b
	eAVQxL8JAsiATX+xt6KmGSO3AO7Psz3gTF+pWvay+JGlvUCF7njlxGZc6ADzeD+BcTKhqF9wSWN
	3Tx/sFQhafYAURiauWC1Pdb6+rvkmnZqoBfZdXg/+K7PBhC2Y8MjYyXspdRvu+xPqe6/etZ+zj9
	AS+lQ3D6hwzEgSQbtNE1x8tMaA2Kg8Hu6dKnUCsSryhgtOtaVA2uu96vjTt6kzFgdlNfAh7ENWX
	6EU1iQaahQlEVCKfLOqSjNjITW2dJM5ylbCziNorwnfs9WVuFbbJmx6EFqNaMv0i78q4vzgZvca
	gJP1/OGPl
X-Google-Smtp-Source: AGHT+IElla0nEGMKETLbUX+7W3iyU+Fakjen00uH8Qq58oXST6ashLmAvUW8ZcSrTXtiFgagP5KfJQ==
X-Received: by 2002:a17:90b:55c5:b0:311:9c9a:58da with SMTP id 98e67ed59e1d1-312413f54eemr24659151a91.8.1748940665215;
        Tue, 03 Jun 2025 01:51:05 -0700 (PDT)
Received: from localhost.localdomain ([117.88.121.64])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-235caa81bc2sm7331655ad.205.2025.06.03.01.51.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Jun 2025 01:51:04 -0700 (PDT)
From: luminosity1999@gmail.com
X-Google-Original-From: txpeng@tencent.com
To: chandan.babu@oracle.com
Cc: linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Tianxiang Peng <txpeng@tencent.com>,
	Qing Zhang <diasyzhang@tencent.com>,
	Hao Peng <flyingpeng@tencent.com>,
	Jinliang Zheng <alexjlzheng@tencent.com>,
	Hui Li <caelli@tencent.com>
Subject: [PATCH 5.4] xfs: Reset cnt_cur to NULL after deletion to prevent UAF
Date: Tue,  3 Jun 2025 16:50:56 +0800
Message-ID: <20250603085056.191073-1-txpeng@tencent.com>
X-Mailer: git-send-email 2.43.5
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Tianxiang Peng <txpeng@tencent.com>

Our test environment detected a use-after-free bug in XFS:

[ 1396.210852] Allocated by task 26155:
[ 1396.212769]  save_stack+0x21/0x90
[ 1396.214670]  __kasan_kmalloc.constprop.8+0xc1/0xd0
[ 1396.216738]  kasan_slab_alloc+0x11/0x20
[ 1396.218694]  kmem_cache_alloc+0xfb/0x280
[ 1396.220750]  kmem_zone_alloc+0xb9/0x240 [xfs]
[ 1396.222859]  xfs_allocbt_init_cursor+0x60/0x270 [xfs]
[ 1396.225058]  xfs_alloc_ag_vextent_near+0x2bc/0x1aa0 [xfs]
[ 1396.227312]  xfs_alloc_ag_vextent+0x3a0/0x5a0 [xfs]
[ 1396.229503]  xfs_alloc_vextent+0xc11/0xd80 [xfs]
[ 1396.231665]  xfs_bmap_btalloc+0x632/0xf20 [xfs]
[ 1396.233804]  xfs_bmap_alloc+0x78/0x90 [xfs]
[ 1396.235883]  xfs_bmapi_allocate+0x243/0x760 [xfs]
[ 1396.238032]  xfs_bmapi_convert_delalloc+0x3cf/0x850 [xfs]
[ 1396.240267]  xfs_map_blocks+0x352/0x820 [xfs]
[ 1396.242379]  xfs_do_writepage+0x2c2/0x8d0 [xfs]
[ 1396.244417]  write_cache_pages+0x341/0x760
[ 1396.246490]  xfs_vm_writepages+0xc8/0x120 [xfs]
[ 1396.248755]  do_writepages+0x8f/0x160
[ 1396.250710]  __filemap_fdatawrite_range+0x1a4/0x200
[ 1396.252823]  filemap_flush+0x1c/0x20
[ 1396.254847]  xfs_release+0x1b3/0x1f0 [xfs]
[ 1396.256920]  xfs_file_release+0x15/0x20 [xfs]
[ 1396.258936]  __fput+0x155/0x390
[ 1396.260781]  ____fput+0xe/0x10
[ 1396.262620]  task_work_run+0xbf/0xe0
[ 1396.264492]  exit_to_usermode_loop+0x11d/0x120
[ 1396.266496]  do_syscall_64+0x1c3/0x1f0
[ 1396.268391]  entry_SYSCALL_64_after_hwframe+0x44/0xa9

[ 1396.272067] Freed by task 26155:
[ 1396.273909]  save_stack+0x21/0x90
[ 1396.275758]  __kasan_slab_free+0x131/0x180
[ 1396.277722]  kasan_slab_free+0xe/0x10
[ 1396.279627]  kmem_cache_free+0x8c/0x2c0
[ 1396.281625]  xfs_btree_del_cursor+0xb2/0x100 [xfs]
[ 1396.283739]  xfs_alloc_ag_vextent_near+0x90b/0x1aa0 [xfs]
[ 1396.285932]  xfs_alloc_ag_vextent+0x3a0/0x5a0 [xfs]
[ 1396.288049]  xfs_alloc_vextent+0xc11/0xd80 [xfs]
[ 1396.290065]  xfs_bmap_btalloc+0x632/0xf20 [xfs]
[ 1396.292008]  xfs_bmap_alloc+0x78/0x90 [xfs]
[ 1396.293871]  xfs_bmapi_allocate+0x243/0x760 [xfs]
[ 1396.295801]  xfs_bmapi_convert_delalloc+0x3cf/0x850 [xfs]
[ 1396.297811]  xfs_map_blocks+0x352/0x820 [xfs]
[ 1396.299706]  xfs_do_writepage+0x2c2/0x8d0 [xfs]
[ 1396.301522]  write_cache_pages+0x341/0x760
[ 1396.303379]  xfs_vm_writepages+0xc8/0x120 [xfs]
[ 1396.305204]  do_writepages+0x8f/0x160
[ 1396.306902]  __filemap_fdatawrite_range+0x1a4/0x200
[ 1396.308756]  filemap_flush+0x1c/0x20
[ 1396.310545]  xfs_release+0x1b3/0x1f0 [xfs]
[ 1396.312386]  xfs_file_release+0x15/0x20 [xfs]
[ 1396.314180]  __fput+0x155/0x390
[ 1396.315825]  ____fput+0xe/0x10
[ 1396.317442]  task_work_run+0xbf/0xe0
[ 1396.319126]  exit_to_usermode_loop+0x11d/0x120
[ 1396.320928]  do_syscall_64+0x1c3/0x1f0
[ 1396.322648]  entry_SYSCALL_64_after_hwframe+0x44/0xa9

[ 1396.325958] The buggy address belongs to the object at ffff8898039945a0
                which belongs to the cache xfs_btree_cur of size 224
[ 1396.330097] The buggy address is located 181 bytes inside of
                224-byte region [ffff8898039945a0, ffff889803994680)

This issue stems from an incomplete backport of upstream commit
8ebbf262d468 ("xfs: don't block in busy flushing when freeing
extents") to the 5.4 LTS kernel. The backport introduced error
handling that may goto error0 when xfs_extent_busy_flush() fails:

-		xfs_extent_busy_flush(args->mp, args->pag, busy_gen,
-				alloc_flags);
+		error = xfs_extent_busy_flush(args->tp, args->pag,
+				busy_gen, alloc_flags);
+		if (error)
+			goto error0;

However, in the 5.4 codebase, the existing cursor deletion logic
failed to reset cnt_cur to NULL after deletion. While the original
code's goto restart path reinitialized the cursor, the new goto
error0 path attempts to delete an already-freed cursor (now
dangling pointer), causing a use-after-free. Reset cnt_cur to NULL
after deletion to prevent double-free. This aligns with the cursor
management pattern used at other deletion sites in the same
function.

This pitfall was eliminated in 5.15+ LTS kernels via XFS code
refactoring, making the fix unnecessary for newer versions.

Signed-off-by: Tianxiang Peng <txpeng@tencent.com>
Reviewed-by: Qing Zhang <diasyzhang@tencent.com>
Reviewed-by: Hao Peng <flyingpeng@tencent.com>
Reviewed-by: Jinliang Zheng <alexjlzheng@tencent.com>
Reviewed-by: Hui Li <caelli@tencent.com>
---
 fs/xfs/libxfs/xfs_alloc.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index 1193fd6e4..ff0c05901 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -1417,6 +1417,7 @@ xfs_alloc_ag_vextent_near(
 	 */
 	if (bno_cur_lt == NULL && bno_cur_gt == NULL) {
 		xfs_btree_del_cursor(cnt_cur, XFS_BTREE_NOERROR);
+		cnt_cur = NULL;
 
 		if (busy) {
 			trace_xfs_alloc_near_busy(args);
-- 
2.43.5

