Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14FC9C4167D
	for <linux-xfs@archiver.kernel.org>; Tue, 14 Nov 2023 01:53:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231985AbjKNBx6 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 13 Nov 2023 20:53:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231969AbjKNBx5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 13 Nov 2023 20:53:57 -0500
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 195D9D43
        for <linux-xfs@vger.kernel.org>; Mon, 13 Nov 2023 17:53:54 -0800 (PST)
Received: by mail-pg1-x52d.google.com with SMTP id 41be03b00d2f7-5c19a328797so1128603a12.3
        for <linux-xfs@vger.kernel.org>; Mon, 13 Nov 2023 17:53:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1699926833; x=1700531633; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YS8Dp+7hh1oASlwguxu+0te537Whw1CvUWHKOgCqLJc=;
        b=Z0k9IOD7HrkNqA95v9YwGI+ilJ7lFDQRzBoJQh4NdSFTGQDGWdfw4kyh6Y1N14xbkO
         w26X7XGi/n2sl15DEELKh2fCnuwOuu8M7kX6mrj3gtdibXo6y054TWsBfSFKaXTeRTTu
         ZqGieSgv5sP4tz/U2VsYo97mJ/hlfg+ka5jyX/BLnuf3cY4qfCfbJwcTukRZkAeL7e7o
         8+RmsrqwhFMbzsyVgHEFUtAKQeAUVYYS6hbdZvNDkWNe2i52YyLo8uBxz/jycf5aIDGI
         yTshmQ2vYhmCYDX8SUhgosh2hOK9Sv3Z0DjOalztLpq171FfoyTz8QQxQ/9N8YnwueQe
         lnBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699926833; x=1700531633;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YS8Dp+7hh1oASlwguxu+0te537Whw1CvUWHKOgCqLJc=;
        b=AaNqBOGkQO6Kn6ZA85dsSfWIZu7+SzLGlDXlxjoTaYVNUzNsFlizHhyzIIpZeqS+Xu
         Hs2yHCF/OMoYU9U+Sxlc2/Q0qfK9KpfPT8yDOdacxDg+ZcwTYNC42xnHPpBV4vStuahO
         VwXcGD8UN+8M12c8aEYPraFWWfAiqFYBqFM3c0MNlx1ltxXIvQM9oNz8t8t10Syc+Rin
         k2mFiQ1sxgyJ8npK847pcMxLRCYoPrEg//3qS//M6sSEiRJpzB7A+jaZMEcEqzAfVLd9
         nmgJbTidb6ySIbUdgjFJEroeZTY+BjGqgzDI7FtNWlPIMuKh0h5oP+ILhn9/cDWiGVOV
         cfgA==
X-Gm-Message-State: AOJu0YyWchdtZrcE4P72Ymyqn+mHlT57G7C+qQ5hhOlsAxwOIksV92m5
        6EYbf8eP2sUl2cOhdegcpDvzUyEo2gGmjA==
X-Google-Smtp-Source: AGHT+IEEZiMsIVYQgHONwJz6Jc7quX4566Ir6MvSZc8GHx/f+dHGxdgIa5ySPHZEhgEBQsKcjLuCmA==
X-Received: by 2002:a05:6a20:3c9f:b0:187:174b:cc78 with SMTP id b31-20020a056a203c9f00b00187174bcc78mr69194pzj.39.1699926833401;
        Mon, 13 Nov 2023 17:53:53 -0800 (PST)
Received: from lrumancik.svl.corp.google.com ([2620:15c:2a3:200:d177:a8ad:804f:74f1])
        by smtp.gmail.com with ESMTPSA id a17-20020a170902ecd100b001c9cb2fb8d8sm4668592plh.49.2023.11.13.17.53.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Nov 2023 17:53:53 -0800 (PST)
From:   Leah Rumancik <leah.rumancik@gmail.com>
To:     linux-xfs@vger.kernel.org
Cc:     amir73il@gmail.com, chandan.babu@oracle.com, fred@cloudflare.com,
        "Darrick J. Wong" <djwong@kernel.org>, hch@lst.de,
        kernel test robot <oliver.sang@intel.com>,
        Dave Chinner <dchinner@redhat.com>,
        Leah Rumancik <leah.rumancik@gmail.com>
Subject: [PATCH 5.15 CANDIDATE 07/17] xfs: fix use-after-free in xattr node block inactivation
Date:   Mon, 13 Nov 2023 17:53:28 -0800
Message-ID: <20231114015339.3922119-8-leah.rumancik@gmail.com>
X-Mailer: git-send-email 2.43.0.rc0.421.g78406f8d94-goog
In-Reply-To: <20231114015339.3922119-1-leah.rumancik@gmail.com>
References: <20231114015339.3922119-1-leah.rumancik@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: "Darrick J. Wong" <djwong@kernel.org>

[ Upstream commit 95ff0363f3f6ae70c21a0f2b0603e54438e5988b ]

The kernel build robot reported a UAF error while running xfs/433
(edited somewhat for brevity):

 BUG: KASAN: use-after-free in xfs_attr3_node_inactive (fs/xfs/xfs_attr_inactive.c:214) xfs
 Read of size 4 at addr ffff88820ac2bd44 by task kworker/0:2/139

 CPU: 0 PID: 139 Comm: kworker/0:2 Tainted: G S                5.19.0-rc2-00004-g7cf2b0f9611b #1
 Hardware name: Hewlett-Packard p6-1451cx/2ADA, BIOS 8.15 02/05/2013
 Workqueue: xfs-inodegc/sdb4 xfs_inodegc_worker [xfs]
 Call Trace:
  <TASK>
 dump_stack_lvl (lib/dump_stack.c:107 (discriminator 1))
 print_address_description+0x1f/0x200
 print_report.cold (mm/kasan/report.c:430)
 kasan_report (mm/kasan/report.c:162 mm/kasan/report.c:493)
 xfs_attr3_node_inactive (fs/xfs/xfs_attr_inactive.c:214) xfs
 xfs_attr3_root_inactive (fs/xfs/xfs_attr_inactive.c:296) xfs
 xfs_attr_inactive (fs/xfs/xfs_attr_inactive.c:371) xfs
 xfs_inactive (fs/xfs/xfs_inode.c:1781) xfs
 xfs_inodegc_worker (fs/xfs/xfs_icache.c:1837 fs/xfs/xfs_icache.c:1860) xfs
 process_one_work
 worker_thread
 kthread
 ret_from_fork
  </TASK>

 Allocated by task 139:
 kasan_save_stack (mm/kasan/common.c:39)
 __kasan_slab_alloc (mm/kasan/common.c:45 mm/kasan/common.c:436 mm/kasan/common.c:469)
 kmem_cache_alloc (mm/slab.h:750 mm/slub.c:3214 mm/slub.c:3222 mm/slub.c:3229 mm/slub.c:3239)
 _xfs_buf_alloc (include/linux/instrumented.h:86 include/linux/atomic/atomic-instrumented.h:41 fs/xfs/xfs_buf.c:232) xfs
 xfs_buf_get_map (fs/xfs/xfs_buf.c:660) xfs
 xfs_buf_read_map (fs/xfs/xfs_buf.c:777) xfs
 xfs_trans_read_buf_map (fs/xfs/xfs_trans_buf.c:289) xfs
 xfs_da_read_buf (fs/xfs/libxfs/xfs_da_btree.c:2652) xfs
 xfs_da3_node_read (fs/xfs/libxfs/xfs_da_btree.c:392) xfs
 xfs_attr3_root_inactive (fs/xfs/xfs_attr_inactive.c:272) xfs
 xfs_attr_inactive (fs/xfs/xfs_attr_inactive.c:371) xfs
 xfs_inactive (fs/xfs/xfs_inode.c:1781) xfs
 xfs_inodegc_worker (fs/xfs/xfs_icache.c:1837 fs/xfs/xfs_icache.c:1860) xfs
 process_one_work
 worker_thread
 kthread
 ret_from_fork

 Freed by task 139:
 kasan_save_stack (mm/kasan/common.c:39)
 kasan_set_track (mm/kasan/common.c:45)
 kasan_set_free_info (mm/kasan/generic.c:372)
 __kasan_slab_free (mm/kasan/common.c:368 mm/kasan/common.c:328 mm/kasan/common.c:374)
 kmem_cache_free (mm/slub.c:1753 mm/slub.c:3507 mm/slub.c:3524)
 xfs_buf_rele (fs/xfs/xfs_buf.c:1040) xfs
 xfs_attr3_node_inactive (fs/xfs/xfs_attr_inactive.c:210) xfs
 xfs_attr3_root_inactive (fs/xfs/xfs_attr_inactive.c:296) xfs
 xfs_attr_inactive (fs/xfs/xfs_attr_inactive.c:371) xfs
 xfs_inactive (fs/xfs/xfs_inode.c:1781) xfs
 xfs_inodegc_worker (fs/xfs/xfs_icache.c:1837 fs/xfs/xfs_icache.c:1860) xfs
 process_one_work
 worker_thread
 kthread
 ret_from_fork

I reproduced this for my own satisfaction, and got the same report,
along with an extra morsel:

 The buggy address belongs to the object at ffff88802103a800
  which belongs to the cache xfs_buf of size 432
 The buggy address is located 396 bytes inside of
  432-byte region [ffff88802103a800, ffff88802103a9b0)

I tracked this code down to:

	error = xfs_trans_get_buf(*trans, mp->m_ddev_targp,
			child_blkno,
			XFS_FSB_TO_BB(mp, mp->m_attr_geo->fsbcount), 0,
			&child_bp);
	if (error)
		return error;
	error = bp->b_error;

That doesn't look right -- I think this should be dereferencing
child_bp, not bp.  Looking through the codebase history, I think this
was added by commit 2911edb653b9 ("xfs: remove the mappedbno argument to
xfs_da_get_buf"), which replaced a call to xfs_da_get_buf with the
current call to xfs_trans_get_buf.  Not sure why we trans_brelse'd @bp
earlier in the function, but I'm guessing it's to avoid pinning too many
buffers in memory while we inactivate the bottom of the attr tree.
Hence we now have to get the buffer back.

I /think/ this was supposed to check child_bp->b_error and fail the rest
of the invalidation if child_bp had experienced any kind of IO or
corruption error.  I bet the xfs_da3_node_read earlier in the loop will
catch most cases of incoming on-disk corruption which makes this check
mostly moot unless someone corrupts the buffer and the AIL pushes it out
to disk while the buffer's unlocked.

In the first case we'll never get to the bad check, and in the second
case the AIL will shut down the log, at which point there's no reason to
check b_error.  Remove the check, and null out @bp to avoid this problem
in the future.

Cc: hch@lst.de
Reported-by: kernel test robot <oliver.sang@intel.com>
Fixes: 2911edb653b9 ("xfs: remove the mappedbno argument to xfs_da_get_buf")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Leah Rumancik <leah.rumancik@gmail.com>
---
 fs/xfs/xfs_attr_inactive.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/fs/xfs/xfs_attr_inactive.c b/fs/xfs/xfs_attr_inactive.c
index 2b5da6218977..2afa6d9a7f8f 100644
--- a/fs/xfs/xfs_attr_inactive.c
+++ b/fs/xfs/xfs_attr_inactive.c
@@ -158,6 +158,7 @@ xfs_attr3_node_inactive(
 	}
 	child_fsb = be32_to_cpu(ichdr.btree[0].before);
 	xfs_trans_brelse(*trans, bp);	/* no locks for later trans */
+	bp = NULL;
 
 	/*
 	 * If this is the node level just above the leaves, simply loop
@@ -211,12 +212,8 @@ xfs_attr3_node_inactive(
 				&child_bp);
 		if (error)
 			return error;
-		error = bp->b_error;
-		if (error) {
-			xfs_trans_brelse(*trans, child_bp);
-			return error;
-		}
 		xfs_trans_binval(*trans, child_bp);
+		child_bp = NULL;
 
 		/*
 		 * If we're not done, re-read the parent to get the next
@@ -233,6 +230,7 @@ xfs_attr3_node_inactive(
 						  bp->b_addr);
 			child_fsb = be32_to_cpu(phdr.btree[i + 1].before);
 			xfs_trans_brelse(*trans, bp);
+			bp = NULL;
 		}
 		/*
 		 * Atomically commit the whole invalidate stuff.
-- 
2.43.0.rc0.421.g78406f8d94-goog

