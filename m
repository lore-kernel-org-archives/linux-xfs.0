Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id F3F1E7F62
	for <xfs@oss.sgi.com>; Thu, 22 Jan 2015 05:11:18 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id B7411304062
	for <xfs@oss.sgi.com>; Thu, 22 Jan 2015 03:11:18 -0800 (PST)
Received: from casper.infradead.org (casper.infradead.org [85.118.1.10]) by
	cuda.sgi.com with ESMTP id Lzyff4eqsbcX1n0q (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 22 Jan 2015 03:11:17 -0800 (PST)
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 07/20] nfsd: make lookup/alloc/unhash_stid available outside
	nfs4state.c
Date: Thu, 22 Jan 2015 12:09:53 +0100
Message-Id: <1421925006-24231-8-git-send-email-hch@lst.de>
In-Reply-To: <1421925006-24231-1-git-send-email-hch@lst.de>
References: <1421925006-24231-1-git-send-email-hch@lst.de>
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
 fs/nfsd/nfs4state.c | 8 ++++----
 fs/nfsd/state.h     | 6 ++++++
 2 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/fs/nfsd/nfs4state.c b/fs/nfsd/nfs4state.c
index b4f86f8..7515207 100644
--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -486,7 +486,7 @@ static void nfs4_file_put_access(struct nfs4_file *fp, u32 access)
 		__nfs4_file_put_access(fp, O_RDONLY);
 }
 
-static struct nfs4_stid *nfs4_alloc_stid(struct nfs4_client *cl,
+struct nfs4_stid *nfs4_alloc_stid(struct nfs4_client *cl,
 					 struct kmem_cache *slab)
 {
 	struct nfs4_stid *stid;
@@ -690,7 +690,7 @@ static void nfs4_put_deleg_lease(struct nfs4_file *fp)
 	}
 }
 
-static void unhash_stid(struct nfs4_stid *s)
+void nfs4_unhash_stid(struct nfs4_stid *s)
 {
 	s->sc_type = 0;
 }
@@ -998,7 +998,7 @@ static void unhash_lock_stateid(struct nfs4_ol_stateid *stp)
 
 	list_del_init(&stp->st_locks);
 	unhash_ol_stateid(stp);
-	unhash_stid(&stp->st_stid);
+	nfs4_unhash_stid(&stp->st_stid);
 }
 
 static void release_lock_stateid(struct nfs4_ol_stateid *stp)
@@ -4438,7 +4438,7 @@ out_unlock:
 	return status;
 }
 
-static __be32
+__be32
 nfsd4_lookup_stateid(struct nfsd4_compound_state *cstate,
 		     stateid_t *stateid, unsigned char typemask,
 		     struct nfs4_stid **s, struct nfsd_net *nn)
diff --git a/fs/nfsd/state.h b/fs/nfsd/state.h
index 9d3be37..534983a 100644
--- a/fs/nfsd/state.h
+++ b/fs/nfsd/state.h
@@ -545,6 +545,12 @@ struct nfsd_net;
 extern __be32 nfs4_preprocess_stateid_op(struct net *net,
 		struct nfsd4_compound_state *cstate,
 		stateid_t *stateid, int flags, struct file **filp);
+__be32 nfsd4_lookup_stateid(struct nfsd4_compound_state *cstate,
+		     stateid_t *stateid, unsigned char typemask,
+		     struct nfs4_stid **s, struct nfsd_net *nn);
+struct nfs4_stid *nfs4_alloc_stid(struct nfs4_client *cl,
+		struct kmem_cache *slab);
+void nfs4_unhash_stid(struct nfs4_stid *s);
 void nfs4_put_stid(struct nfs4_stid *s);
 void nfs4_remove_reclaim_record(struct nfs4_client_reclaim *, struct nfsd_net *);
 extern void nfs4_release_reclaim(struct nfsd_net *);
-- 
1.9.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
