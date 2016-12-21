Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:34792 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S936642AbcLUREL (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 21 Dec 2016 12:04:11 -0500
From: Jeff Layton <jlayton@redhat.com>
Subject: [RFC PATCH v1 24/30] IMA: switch IMA over to new i_version API
Date: Wed, 21 Dec 2016 12:03:41 -0500
Message-Id: <1482339827-7882-25-git-send-email-jlayton@redhat.com>
In-Reply-To: <1482339827-7882-1-git-send-email-jlayton@redhat.com>
References: <1482339827-7882-1-git-send-email-jlayton@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-nfs@vger.kernel.org, linux-ext4@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-xfs@vger.kernel.org

This change is straightforward, but I have some serious doubts about
this code.

Signed-off-by: Jeff Layton <jlayton@redhat.com>
---
 security/integrity/ima/ima_api.c  | 2 +-
 security/integrity/ima/ima_main.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/security/integrity/ima/ima_api.c b/security/integrity/ima/ima_api.c
index 9df26a2b75ba..1f676313c30b 100644
--- a/security/integrity/ima/ima_api.c
+++ b/security/integrity/ima/ima_api.c
@@ -204,7 +204,7 @@ int ima_collect_measurement(struct integrity_iint_cache *iint,
 	} hash;
 
 	if (!(iint->flags & IMA_COLLECTED)) {
-		u64 i_version = file_inode(file)->i_version;
+		u64 i_version = inode_get_iversion(file_inode(file));
 
 		if (file->f_flags & O_DIRECT) {
 			audit_cause = "failed(directio)";
diff --git a/security/integrity/ima/ima_main.c b/security/integrity/ima/ima_main.c
index 423d111b3b94..8d95cf42d20c 100644
--- a/security/integrity/ima/ima_main.c
+++ b/security/integrity/ima/ima_main.c
@@ -122,7 +122,7 @@ static void ima_check_last_writer(struct integrity_iint_cache *iint,
 
 	inode_lock(inode);
 	if (atomic_read(&inode->i_writecount) == 1) {
-		if ((iint->version != inode->i_version) ||
+		if (inode_cmp_iversion(inode, iint->version) ||
 		    (iint->flags & IMA_NEW_FILE)) {
 			iint->flags &= ~(IMA_DONE_MASK | IMA_NEW_FILE);
 			iint->measured_pcrs = 0;
-- 
2.7.4

