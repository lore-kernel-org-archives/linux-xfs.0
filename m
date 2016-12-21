Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:46122 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933996AbcLURDt (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 21 Dec 2016 12:03:49 -0500
From: Jeff Layton <jlayton@redhat.com>
Subject: [RFC PATCH v1 01/30] lustre: don't set f_version in ll_readdir
Date: Wed, 21 Dec 2016 12:03:18 -0500
Message-Id: <1482339827-7882-2-git-send-email-jlayton@redhat.com>
In-Reply-To: <1482339827-7882-1-git-send-email-jlayton@redhat.com>
References: <1482339827-7882-1-git-send-email-jlayton@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-nfs@vger.kernel.org, linux-ext4@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-xfs@vger.kernel.org

f_version is only ever used by filesystem-specific code, and nothing in
lustre ever looks at it.

Signed-off-by: Jeff Layton <jlayton@redhat.com>
---
 drivers/staging/lustre/lustre/llite/dir.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/staging/lustre/lustre/llite/dir.c b/drivers/staging/lustre/lustre/llite/dir.c
index ea5d247a3f70..1d288ec5f03e 100644
--- a/drivers/staging/lustre/lustre/llite/dir.c
+++ b/drivers/staging/lustre/lustre/llite/dir.c
@@ -367,8 +367,6 @@ static int ll_readdir(struct file *filp, struct dir_context *ctx)
 	}
 	ctx->pos = pos;
 	ll_finish_md_op_data(op_data);
-	filp->f_version = inode->i_version;
-
 out:
 	if (!rc)
 		ll_stats_ops_tally(sbi, LPROC_LL_READDIR, 1);
@@ -1671,7 +1669,6 @@ static loff_t ll_dir_seek(struct file *file, loff_t offset, int origin)
 			else
 				fd->lfd_pos = offset;
 			file->f_pos = offset;
-			file->f_version = 0;
 		}
 		ret = offset;
 	}
-- 
2.7.4

