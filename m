Received: from mail-oa1-f50.google.com (mail-oa1-f50.google.com [209.85.160.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 685843A1A3
	for <linux-xfs@vger.kernel.org>; Wed, 10 Jan 2024 07:14:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TfCrVG12"
Received: by mail-oa1-f50.google.com with SMTP id 586e51a60fabf-204b216e4easo709204fac.1
        for <linux-xfs@vger.kernel.org>; Tue, 09 Jan 2024 23:14:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1704870859; x=1705475659; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=S4q1TtMGlpj/P51jJZp7ptXwjPr/m+bIST11rhUxS5I=;
        b=TfCrVG12t9VItQD3/JNTau1W/QZJqJXdhunY7mPasUX5o6O6pJORWcCqUCTl8buWay
         xJ6c80Lhwj8xqXvsNETR7BIJSfCI7aHBUR8kaX+0PLu5Bh9OQYhOQLzgDqPVd7rnotkm
         T/45+68TGJ3ciSyc68vWb9FME3jKbcekHF9OfCYDcKFeUVk/6xcQswUWhhuo9IhAelV0
         EDnm/N7JsgpAj0QNQp6m1Z8VNT41gvuM6eRWpQ/pKqRojpo6hK6H2jaa10nopiPgOHCX
         RwOOVgFP7XamGPlUyLARNwz404CpxrFV3WdRl3E3xANCT7uMEyBTmwocwkI+OIXRC58C
         yxdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704870859; x=1705475659;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=S4q1TtMGlpj/P51jJZp7ptXwjPr/m+bIST11rhUxS5I=;
        b=CTKW2xlIQI9tjdmyxz73PN7jOz5Qwb5eTkbBSM6t8BOOtd7jOwOc8wO8H3nPkuia7n
         zIsWokfsiMCcp2+9QPZUQs5whksDeK401iC+Fjok2KgtlUOa8S2ontXwTq1uZfwFIJQT
         JkJ0xGGSspUPF31oeqDDxxAcVKx2LQdzfeMQEAZCePuxrclGE1GquDVW8bYA5haV6XW2
         ejgCzASuCrLsea6GA5QLcolf4Nbue0Vvb1OMlheDcwicQld0W4nzmoNKQWzUO4LeT4dD
         cbUo2Ch39TY5fDjnfl8XtUcTyyoYW7caXPga/W91qqHK3YPYT9gBS2KzmnqU7XVGup3n
         dNYQ==
X-Gm-Message-State: AOJu0YytKB9Ia9KeM/L+UgtOZsvuTUI5hf97j2oXEbq7WIKw/OT1ewsQ
	eCJ131vlKpRSfZ+7kT/v5k4e0rphKmEdbg==
X-Google-Smtp-Source: AGHT+IEgkzS92IBPafc76EmaNdI3/fGpH4Ra+8x/xMev3amjrrdqCY+1ndPx3RAHHKywLFwl4mHIwQ==
X-Received: by 2002:a05:6358:91d:b0:175:75d9:e93e with SMTP id r29-20020a056358091d00b0017575d9e93emr1091389rwi.0.1704870859088;
        Tue, 09 Jan 2024 23:14:19 -0800 (PST)
Received: from mi.mioffice.cn ([43.224.245.240])
        by smtp.gmail.com with ESMTPSA id x22-20020a056a00271600b006d638fd230bsm2892112pfv.93.2024.01.09.23.14.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Jan 2024 23:14:18 -0800 (PST)
From: Jian Wen <wenjianhn@gmail.com>
X-Google-Original-From: Jian Wen <wenjian1@xiaomi.com>
To: linux-xfs@vger.kernel.org
Cc: Jian Wen <wenjianhn@gmail.com>,
	djwong@kernel.org,
	hch@lst.de,
	dchinner@redhat.com,
	Jian Wen <wenjian1@xiaomi.com>
Subject: [PATCH] xfs: explicitly call cond_resched in xfs_itruncate_extents_flags
Date: Wed, 10 Jan 2024 15:13:47 +0800
Message-Id: <20240110071347.3711925-1-wenjian1@xiaomi.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Jian Wen <wenjianhn@gmail.com>

Deleting a file with lots of extents may cause a soft lockup if the
preemption model is none(CONFIG_PREEMPT_NONE=y or preempt=none is set
in the kernel cmdline). Alibaba cloud kernel and Oracle UEK container
kernel are affected by the issue, since they select CONFIG_PREEMPT_NONE=y.

Explicitly call cond_resched in xfs_itruncate_extents_flags avoid
the below softlockup warning.
watchdog: BUG: soft lockup - CPU#0 stuck for 23s! [kworker/0:13:139]
CPU: 0 PID: 139 Comm: kworker/0:13 Not tainted 6.7.0-rc8-g610a9b8f49fb #23
 Workqueue: xfs-inodegc/vda1 xfs_inodegc_worker
 Call Trace:
  _raw_spin_lock+0x30/0x80
  ? xfs_extent_busy_trim+0x38/0x200
  xfs_extent_busy_trim+0x38/0x200
  xfs_alloc_compute_aligned+0x38/0xd0
  xfs_alloc_ag_vextent_size+0x1f1/0x870
  xfs_alloc_fix_freelist+0x58a/0x770
  xfs_free_extent_fix_freelist+0x60/0xa0
  __xfs_free_extent+0x66/0x1d0
  xfs_trans_free_extent+0xac/0x290
  xfs_extent_free_finish_item+0xf/0x40
  xfs_defer_finish_noroll+0x1db/0x7f0
  xfs_defer_finish+0x10/0xa0
  xfs_itruncate_extents_flags+0x169/0x4c0
  xfs_inactive_truncate+0xba/0x140
  xfs_inactive+0x239/0x2a0
  xfs_inodegc_worker+0xa3/0x210
  ? process_scheduled_works+0x273/0x550
  process_scheduled_works+0x2da/0x550
  worker_thread+0x180/0x350

Most of the Linux distributions default to voluntary preemption,
might_sleep() would yield CPU if needed. Thus they are not affected.
kworker/0:24+xf     298 [000]  7294.810021: probe:__cond_resched:
  __cond_resched+0x5 ([kernel.kallsyms])
  __kmem_cache_alloc_node+0x17c ([kernel.kallsyms])
  __kmalloc+0x4d ([kernel.kallsyms])
  kmem_alloc+0x7a ([kernel.kallsyms])
  xfs_extent_busy_insert_list+0x2e ([kernel.kallsyms])
  __xfs_free_extent+0xd3 ([kernel.kallsyms])
  xfs_trans_free_extent+0x93 ([kernel.kallsyms])
  xfs_extent_free_finish_item+0xf ([kernel.kallsyms])

kworker/0:24+xf     298 [000]  7294.810045: probe:__cond_resched:
  __cond_resched+0x5 ([kernel.kallsyms])
  down+0x11 ([kernel.kallsyms])
  xfs_buf_lock+0x2c ([kernel.kallsyms])
  xfs_buf_find_lock+0x62 ([kernel.kallsyms])
  xfs_buf_get_map+0x1fd ([kernel.kallsyms])
  xfs_buf_read_map+0x51 ([kernel.kallsyms])
  xfs_trans_read_buf_map+0x1c5 ([kernel.kallsyms])
  xfs_btree_read_buf_block.constprop.0+0xa1 ([kernel.kallsyms])
  xfs_btree_lookup_get_block+0x97 ([kernel.kallsyms])
  xfs_btree_lookup+0xc5 ([kernel.kallsyms])
  xfs_alloc_lookup_eq+0x18 ([kernel.kallsyms])
  xfs_free_ag_extent+0x63f ([kernel.kallsyms])
  __xfs_free_extent+0xa7 ([kernel.kallsyms])
  xfs_trans_free_extent+0x93 ([kernel.kallsyms])
  xfs_extent_free_finish_item+0xf ([kernel.kallsyms])

Signed-off-by: Jian Wen <wenjian1@xiaomi.com>
---
 fs/xfs/xfs_inode.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index c0f1c89786c2..194381e10472 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -4,6 +4,7 @@
  * All Rights Reserved.
  */
 #include <linux/iversion.h>
+#include <linux/sched.h>
 
 #include "xfs.h"
 #include "xfs_fs.h"
@@ -1383,6 +1384,8 @@ xfs_itruncate_extents_flags(
 		error = xfs_defer_finish(&tp);
 		if (error)
 			goto out;
+
+		cond_resched();
 	}
 
 	if (whichfork == XFS_DATA_FORK) {
-- 
2.25.1

