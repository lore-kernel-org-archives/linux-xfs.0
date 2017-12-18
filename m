Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:55582 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932804AbdLRPMi (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 18 Dec 2017 10:12:38 -0500
From: Jeff Layton <jlayton@kernel.org>
Subject: [PATCH v3 15/19] IMA: switch IMA over to new i_version API
Date: Mon, 18 Dec 2017 10:11:52 -0500
Message-Id: <20171218151156.14565-16-jlayton@kernel.org>
In-Reply-To: <20171218151156.14565-1-jlayton@kernel.org>
References: <20171218151156.14565-1-jlayton@kernel.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk, linux-nfs@vger.kernel.org, bfields@fieldses.org, neilb@suse.de, jack@suse.de, linux-ext4@vger.kernel.org, tytso@mit.edu, adilger.kernel@dilger.ca, linux-xfs@vger.kernel.org, darrick.wong@oracle.com, david@fromorbit.com, linux-btrfs@vger.kernel.org, clm@fb.com, jbacik@fb.com, dsterba@suse.com, linux-integrity@vger.kernel.org, zohar@linux.vnet.ibm.com, dmitry.kasatkin@gmail.com, linux-afs@lists.infradead.org, dhowells@redhat.com, jaltman@auristor.com

From: Jeff Layton <jlayton@redhat.com>

Signed-off-by: Jeff Layton <jlayton@redhat.com>
---
 security/integrity/ima/ima_api.c  | 3 ++-
 security/integrity/ima/ima_main.c | 3 ++-
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/security/integrity/ima/ima_api.c b/security/integrity/ima/ima_api.c
index c7e8db0ea4c0..c6ae42266270 100644
--- a/security/integrity/ima/ima_api.c
+++ b/security/integrity/ima/ima_api.c
@@ -18,6 +18,7 @@
 #include <linux/fs.h>
 #include <linux/xattr.h>
 #include <linux/evm.h>
+#include <linux/iversion.h>
 
 #include "ima.h"
 
@@ -215,7 +216,7 @@ int ima_collect_measurement(struct integrity_iint_cache *iint,
 	 * which do not support i_version, support is limited to an initial
 	 * measurement/appraisal/audit.
 	 */
-	i_version = file_inode(file)->i_version;
+	i_version = inode_query_iversion(inode);
 	hash.hdr.algo = algo;
 
 	/* Initialize hash digest to 0's in case of failure */
diff --git a/security/integrity/ima/ima_main.c b/security/integrity/ima/ima_main.c
index 50b82599994d..06a70c5a2329 100644
--- a/security/integrity/ima/ima_main.c
+++ b/security/integrity/ima/ima_main.c
@@ -24,6 +24,7 @@
 #include <linux/slab.h>
 #include <linux/xattr.h>
 #include <linux/ima.h>
+#include <linux/iversion.h>
 
 #include "ima.h"
 
@@ -128,7 +129,7 @@ static void ima_check_last_writer(struct integrity_iint_cache *iint,
 	inode_lock(inode);
 	if (atomic_read(&inode->i_writecount) == 1) {
 		if (!IS_I_VERSION(inode) ||
-		    (iint->version != inode->i_version) ||
+		    inode_cmp_iversion(inode, iint->version) ||
 		    (iint->flags & IMA_NEW_FILE)) {
 			iint->flags &= ~(IMA_DONE_MASK | IMA_NEW_FILE);
 			iint->measured_pcrs = 0;
-- 
2.14.3

