Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 4A17D7F76
	for <xfs@oss.sgi.com>; Tue,  6 Jan 2015 10:29:43 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id DCC1BAC008
	for <xfs@oss.sgi.com>; Tue,  6 Jan 2015 08:29:42 -0800 (PST)
Received: from casper.infradead.org (casper.infradead.org [85.118.1.10]) by
	cuda.sgi.com with ESMTP id u9FstsKTvPGBV5d5 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 06 Jan 2015 08:29:40 -0800 (PST)
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 07/18] nfsd: make find/get/put file available outside
	nfs4state.c
Date: Tue,  6 Jan 2015 17:28:30 +0100
Message-Id: <1420561721-9150-8-git-send-email-hch@lst.de>
In-Reply-To: <1420561721-9150-1-git-send-email-hch@lst.de>
References: <1420561721-9150-1-git-send-email-hch@lst.de>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: "J. Bruce Fields" <bfields@fieldses.org>
Cc: linux-fsdevel@vger.kernel.org, linux-nfs@vger.kernel.org, Jeff Layton <jlayton@primarydata.com>, xfs@oss.sgi.com

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/nfsd/nfs4state.c | 10 ++--------
 fs/nfsd/state.h     |  7 +++++++
 2 files changed, 9 insertions(+), 8 deletions(-)

diff --git a/fs/nfsd/nfs4state.c b/fs/nfsd/nfs4state.c
index e804e9b..b2054d4 100644
--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -282,7 +282,7 @@ static void nfsd4_free_file_rcu(struct rcu_head *rcu)
 	kmem_cache_free(file_slab, fp);
 }
 
-static inline void
+void
 put_nfs4_file(struct nfs4_file *fi)
 {
 	might_lock(&state_lock);
@@ -295,12 +295,6 @@ put_nfs4_file(struct nfs4_file *fi)
 	}
 }
 
-static inline void
-get_nfs4_file(struct nfs4_file *fi)
-{
-	atomic_inc(&fi->fi_ref);
-}
-
 static struct file *
 __nfs4_get_fd(struct nfs4_file *f, int oflag)
 {
@@ -3300,7 +3294,7 @@ find_file_locked(struct knfsd_fh *fh, unsigned int hashval)
 	return NULL;
 }
 
-static struct nfs4_file *
+struct nfs4_file *
 find_file(struct knfsd_fh *fh)
 {
 	struct nfs4_file *fp;
diff --git a/fs/nfsd/state.h b/fs/nfsd/state.h
index 55a3ece..8bc961e 100644
--- a/fs/nfsd/state.h
+++ b/fs/nfsd/state.h
@@ -573,6 +573,13 @@ extern struct nfs4_client_reclaim *nfs4_client_to_reclaim(const char *name,
 							struct nfsd_net *nn);
 extern bool nfs4_has_reclaimed_state(const char *name, struct nfsd_net *nn);
 
+struct nfs4_file *find_file(struct knfsd_fh *fh);
+void put_nfs4_file(struct nfs4_file *fi);
+static inline void get_nfs4_file(struct nfs4_file *fi)
+{
+	atomic_inc(&fi->fi_ref);
+}
+
 /* grace period management */
 void nfsd4_end_grace(struct nfsd_net *nn);
 
-- 
1.9.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
