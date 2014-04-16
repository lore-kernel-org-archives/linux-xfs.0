Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 2C9837F3F
	for <xfs@oss.sgi.com>; Tue, 15 Apr 2014 23:19:46 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id AD91AAC004
	for <xfs@oss.sgi.com>; Tue, 15 Apr 2014 21:19:45 -0700 (PDT)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id x3LPSpwk0ba3Ld9H (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 15 Apr 2014 21:19:44 -0700 (PDT)
From: NeilBrown <neilb@suse.de>
Date: Wed, 16 Apr 2014 14:03:37 +1000
Subject: [PATCH 16/19] VFS: use GFP_NOFS rather than GFP_KERNEL in __d_alloc.
Message-ID: <20140416040337.10604.61837.stgit@notabene.brown>
In-Reply-To: <20140416033623.10604.69237.stgit@notabene.brown>
References: <20140416033623.10604.69237.stgit@notabene.brown>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: linux-mm@kvack.org, linux-nfs@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: xfs@oss.sgi.com

__d_alloc can be called with i_mutex held, so it is safer to
use GFP_NOFS.

lockdep reports this can deadlock when loop-back NFS is in use,
as nfsd may be required to write out for reclaim, and nfsd certainly
takes i_mutex.

Signed-off-by: NeilBrown <neilb@suse.de>
---
 fs/dcache.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/dcache.c b/fs/dcache.c
index ca02c13a84aa..3651ff6185b4 100644
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -1483,7 +1483,7 @@ struct dentry *__d_alloc(struct super_block *sb, const struct qstr *name)
 	struct dentry *dentry;
 	char *dname;
 
-	dentry = kmem_cache_alloc(dentry_cache, GFP_KERNEL);
+	dentry = kmem_cache_alloc(dentry_cache, GFP_NOFS);
 	if (!dentry)
 		return NULL;
 
@@ -1495,7 +1495,7 @@ struct dentry *__d_alloc(struct super_block *sb, const struct qstr *name)
 	 */
 	dentry->d_iname[DNAME_INLINE_LEN-1] = 0;
 	if (name->len > DNAME_INLINE_LEN-1) {
-		dname = kmalloc(name->len + 1, GFP_KERNEL);
+		dname = kmalloc(name->len + 1, GFP_NOFS);
 		if (!dname) {
 			kmem_cache_free(dentry_cache, dentry); 
 			return NULL;


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
