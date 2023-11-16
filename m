Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94614C5ACB2
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Nov 2023 02:28:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344494AbjKPC2t (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 15 Nov 2023 21:28:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344525AbjKPC2t (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 15 Nov 2023 21:28:49 -0500
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEEF6127;
        Wed, 15 Nov 2023 18:28:45 -0800 (PST)
Received: by mail-pg1-x532.google.com with SMTP id 41be03b00d2f7-5bd099e3d3cso240465a12.1;
        Wed, 15 Nov 2023 18:28:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1700101725; x=1700706525; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rFn3fe9OQxSopSy46LFtm5cgL5qtFXzAEaP6M9AOGNg=;
        b=QiD+vXtKVG3ByBUPnazv5Wf0xGDqBjpMiP9oiwhFs8HJ6IcFdQPEzymm7OdHxOmM9Z
         nqM/02UXKKAedoiBOgwptgB/ssK/1IFCSvdPBZY/D6rsw1bizZ0JbQvWQSEcJ/PNIIG9
         QfBGOcSMYRV3TOgNr0/WswUPEqod/nfo9osfWMsch0LMeF2g+il/wTGLHBxPATqy/W3x
         DHuMeZyThTDaXQGqUTMvODKJ/vMCMGQEualgpRUwDfJuLl8VTfajMWXs6ElHRyObnAsn
         d7kotgEZrWJkbXQfoOQgOkrL75fT20OFiaE5fSzPfVbPXXTZI2GQtUqQ2LJQCgBZQTMK
         v56Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1700101725; x=1700706525;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rFn3fe9OQxSopSy46LFtm5cgL5qtFXzAEaP6M9AOGNg=;
        b=wUTHDFyc4abOg2Rz0jfb3sb873dlZg5uGNqabrTuzHE1f/rPsSOkyo4gB/nhIJ7kT/
         dW94zccgMiBzgJvyE3LeaGJoAnA71O7sT/iY4mimGCS8Q3sSWOrFrG0ZdYHrDr6OgpCu
         bB7khVlJTJTbKIbN8n3eVfI2nJOEommVTv9c8u6Lmb/jdbP4UKji+2dyNspbMbtjjeno
         paW2CLe2s3w/78pxOIE24SB07Ulnn3EwwQZ44CYKBM71sqqSPXkufsfNtaZu+03UAoua
         FStKo5zrTqaIOd1P0Nc4c5qCaq4pouktG9/W/fndHuGU98sG1VAhRhFgldL8K6z8s7aB
         WulA==
X-Gm-Message-State: AOJu0Yz5hJb8Lm1BMdfWtaRdQjmKc3qDpbT5yDaHw7ITS4YSNmjasTyn
        OF95Pty77XhyaDHIsd95nEEDN7spCOe3+w==
X-Google-Smtp-Source: AGHT+IEC6aN4JDfJi2Q+cDx+FeuAowJ0RLfupj9bp34m3dY8A7Zk3V4jw0rLK/one5r9MNYwgA+wEA==
X-Received: by 2002:a05:6a21:7890:b0:187:20e1:eefc with SMTP id bf16-20020a056a21789000b0018720e1eefcmr6822391pzc.17.1700101724988;
        Wed, 15 Nov 2023 18:28:44 -0800 (PST)
Received: from lrumancik.svl.corp.google.com ([2620:15c:2a3:200:25ea:d6bb:623c:d6a0])
        by smtp.gmail.com with ESMTPSA id j9-20020a170903024900b001b8b1f6619asm8087072plh.75.2023.11.15.18.28.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Nov 2023 18:28:44 -0800 (PST)
From:   Leah Rumancik <leah.rumancik@gmail.com>
To:     stable@vger.kernel.org
Cc:     linux-xfs@vger.kernel.org, amir73il@gmail.com,
        chandan.babu@oracle.com, fred@cloudflare.com,
        "Darrick J. Wong" <djwong@kernel.org>, hch@lst.de,
        kernel test robot <oliver.sang@intel.com>,
        Dave Chinner <dchinner@redhat.com>,
        Leah Rumancik <leah.rumancik@gmail.com>,
        Chandan Babu R <chandanbabu@kernel.org>
Subject: [PATCH 5.15 07/17] xfs: fix use-after-free in xattr node block inactivation
Date:   Wed, 15 Nov 2023 18:28:23 -0800
Message-ID: <20231116022833.121551-7-leah.rumancik@gmail.com>
X-Mailer: git-send-email 2.43.0.rc0.421.g78406f8d94-goog
In-Reply-To: <20231116022833.121551-1-leah.rumancik@gmail.com>
References: <20231116022833.121551-1-leah.rumancik@gmail.com>
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
Acked-by: Chandan Babu R <chandanbabu@kernel.org>
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

