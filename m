Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:40484 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S936547AbcLUREG (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 21 Dec 2016 12:04:06 -0500
From: Jeff Layton <jlayton@redhat.com>
Subject: [RFC PATCH v1 19/30] nfs: convert to new i_version API
Date: Wed, 21 Dec 2016 12:03:36 -0500
Message-Id: <1482339827-7882-20-git-send-email-jlayton@redhat.com>
In-Reply-To: <1482339827-7882-1-git-send-email-jlayton@redhat.com>
References: <1482339827-7882-1-git-send-email-jlayton@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-nfs@vger.kernel.org, linux-ext4@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-xfs@vger.kernel.org

For NFS, we just use the "raw" API since the i_version is mostly
managed by the server. The exception there is when the client
holds a write delegation, but we only need to bump it once
there anyway to handle CB_GETATTR.

Signed-off-by: Jeff Layton <jlayton@redhat.com>
---
 fs/nfs/delegation.c    |  2 +-
 fs/nfs/fscache-index.c |  4 ++--
 fs/nfs/inode.c         | 16 ++++++++--------
 fs/nfs/nfs4proc.c      |  4 ++--
 fs/nfs/nfstrace.h      |  4 ++--
 fs/nfs/write.c         |  2 +-
 6 files changed, 16 insertions(+), 16 deletions(-)

diff --git a/fs/nfs/delegation.c b/fs/nfs/delegation.c
index d7df5e67b0c1..36d8a000e664 100644
--- a/fs/nfs/delegation.c
+++ b/fs/nfs/delegation.c
@@ -347,7 +347,7 @@ int nfs_inode_set_delegation(struct inode *inode, struct rpc_cred *cred, struct
 	nfs4_stateid_copy(&delegation->stateid, &res->delegation);
 	delegation->type = res->delegation_type;
 	delegation->pagemod_limit = res->pagemod_limit;
-	delegation->change_attr = inode->i_version;
+	delegation->change_attr = inode_get_iversion_raw(inode);
 	delegation->cred = get_rpccred(cred);
 	delegation->inode = inode;
 	delegation->flags = 1<<NFS_DELEGATION_REFERENCED;
diff --git a/fs/nfs/fscache-index.c b/fs/nfs/fscache-index.c
index 777b055063f6..40f2ea03cf4f 100644
--- a/fs/nfs/fscache-index.c
+++ b/fs/nfs/fscache-index.c
@@ -211,7 +211,7 @@ static uint16_t nfs_fscache_inode_get_aux(const void *cookie_netfs_data,
 	auxdata.ctime = nfsi->vfs_inode.i_ctime;
 
 	if (NFS_SERVER(&nfsi->vfs_inode)->nfs_client->rpc_ops->version == 4)
-		auxdata.change_attr = nfsi->vfs_inode.i_version;
+		auxdata.change_attr = inode_get_iversion_raw(&nfsi->vfs_inode);
 
 	if (bufmax > sizeof(auxdata))
 		bufmax = sizeof(auxdata);
@@ -243,7 +243,7 @@ enum fscache_checkaux nfs_fscache_inode_check_aux(void *cookie_netfs_data,
 	auxdata.ctime = nfsi->vfs_inode.i_ctime;
 
 	if (NFS_SERVER(&nfsi->vfs_inode)->nfs_client->rpc_ops->version == 4)
-		auxdata.change_attr = nfsi->vfs_inode.i_version;
+		auxdata.change_attr = inode_get_iversion_raw(&nfsi->vfs_inode);
 
 	if (memcmp(data, &auxdata, datalen) != 0)
 		return FSCACHE_CHECKAUX_OBSOLETE;
diff --git a/fs/nfs/inode.c b/fs/nfs/inode.c
index 5864146e05e6..d38ec9c92c1d 100644
--- a/fs/nfs/inode.c
+++ b/fs/nfs/inode.c
@@ -424,7 +424,7 @@ nfs_fhget(struct super_block *sb, struct nfs_fh *fh, struct nfs_fattr *fattr, st
 		memset(&inode->i_atime, 0, sizeof(inode->i_atime));
 		memset(&inode->i_mtime, 0, sizeof(inode->i_mtime));
 		memset(&inode->i_ctime, 0, sizeof(inode->i_ctime));
-		inode->i_version = 0;
+		inode_set_iversion(inode, 0);
 		inode->i_size = 0;
 		clear_nlink(inode);
 		inode->i_uid = make_kuid(&init_user_ns, -2);
@@ -449,7 +449,7 @@ nfs_fhget(struct super_block *sb, struct nfs_fh *fh, struct nfs_fattr *fattr, st
 		else if (nfs_server_capable(inode, NFS_CAP_CTIME))
 			nfs_set_cache_invalid(inode, NFS_INO_INVALID_ATTR);
 		if (fattr->valid & NFS_ATTR_FATTR_CHANGE)
-			inode->i_version = fattr->change_attr;
+			inode_set_iversion(inode, fattr->change_attr);
 		else
 			nfs_set_cache_invalid(inode, NFS_INO_INVALID_ATTR
 				| NFS_INO_REVAL_PAGECACHE);
@@ -1244,8 +1244,8 @@ static unsigned long nfs_wcc_update_inode(struct inode *inode, struct nfs_fattr
 
 	if ((fattr->valid & NFS_ATTR_FATTR_PRECHANGE)
 			&& (fattr->valid & NFS_ATTR_FATTR_CHANGE)
-			&& inode->i_version == fattr->pre_change_attr) {
-		inode->i_version = fattr->change_attr;
+			&& !inode_cmp_iversion(inode, fattr->pre_change_attr)) {
+		inode_set_iversion(inode, fattr->change_attr);
 		if (S_ISDIR(inode->i_mode))
 			nfs_set_cache_invalid(inode, NFS_INO_INVALID_DATA);
 		ret |= NFS_INO_INVALID_ATTR;
@@ -1303,7 +1303,7 @@ static int nfs_check_inode_attributes(struct inode *inode, struct nfs_fattr *fat
 
 	if (!nfs_file_has_buffered_writers(nfsi)) {
 		/* Verify a few of the more important attributes */
-		if ((fattr->valid & NFS_ATTR_FATTR_CHANGE) != 0 && inode->i_version != fattr->change_attr)
+		if ((fattr->valid & NFS_ATTR_FATTR_CHANGE) != 0 && inode_cmp_iversion(inode, fattr->change_attr))
 			invalid |= NFS_INO_INVALID_ATTR | NFS_INO_REVAL_PAGECACHE;
 
 		if ((fattr->valid & NFS_ATTR_FATTR_MTIME) && !timespec_equal(&inode->i_mtime, &fattr->mtime))
@@ -1604,7 +1604,7 @@ int nfs_post_op_update_inode_force_wcc_locked(struct inode *inode, struct nfs_fa
 	}
 	if ((fattr->valid & NFS_ATTR_FATTR_CHANGE) != 0 &&
 			(fattr->valid & NFS_ATTR_FATTR_PRECHANGE) == 0) {
-		fattr->pre_change_attr = inode->i_version;
+		fattr->pre_change_attr = inode_get_iversion_raw(inode);
 		fattr->valid |= NFS_ATTR_FATTR_PRECHANGE;
 	}
 	if ((fattr->valid & NFS_ATTR_FATTR_CTIME) != 0 &&
@@ -1740,7 +1740,7 @@ static int nfs_update_inode(struct inode *inode, struct nfs_fattr *fattr)
 
 	/* More cache consistency checks */
 	if (fattr->valid & NFS_ATTR_FATTR_CHANGE) {
-		if (inode->i_version != fattr->change_attr) {
+		if (inode_cmp_iversion(inode, fattr->change_attr)) {
 			dprintk("NFS: change_attr change on server for file %s/%ld\n",
 					inode->i_sb->s_id, inode->i_ino);
 			/* Could it be a race with writeback? */
@@ -1752,7 +1752,7 @@ static int nfs_update_inode(struct inode *inode, struct nfs_fattr *fattr)
 				if (S_ISDIR(inode->i_mode))
 					nfs_force_lookup_revalidate(inode);
 			}
-			inode->i_version = fattr->change_attr;
+			inode_set_iversion(inode, fattr->change_attr);
 		}
 	} else {
 		nfsi->cache_validity |= save_cache_validity;
diff --git a/fs/nfs/nfs4proc.c b/fs/nfs/nfs4proc.c
index d33242c8d95d..3751f735310d 100644
--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -1089,9 +1089,9 @@ static void update_changeattr(struct inode *dir, struct nfs4_change_info *cinfo)
 
 	spin_lock(&dir->i_lock);
 	nfsi->cache_validity |= NFS_INO_INVALID_ATTR|NFS_INO_INVALID_DATA;
-	if (!cinfo->atomic || cinfo->before != dir->i_version)
+	if (!cinfo->atomic || inode_cmp_iversion(dir, cinfo->before))
 		nfs_force_lookup_revalidate(dir);
-	dir->i_version = cinfo->after;
+	inode_set_iversion(dir, cinfo->after);
 	nfsi->attr_gencount = nfs_inc_attr_generation_counter();
 	nfs_fscache_invalidate(dir);
 	spin_unlock(&dir->i_lock);
diff --git a/fs/nfs/nfstrace.h b/fs/nfs/nfstrace.h
index 2ca9167bc97d..16acb94bbf20 100644
--- a/fs/nfs/nfstrace.h
+++ b/fs/nfs/nfstrace.h
@@ -60,7 +60,7 @@ DECLARE_EVENT_CLASS(nfs_inode_event,
 			__entry->dev = inode->i_sb->s_dev;
 			__entry->fileid = nfsi->fileid;
 			__entry->fhandle = nfs_fhandle_hash(&nfsi->fh);
-			__entry->version = inode->i_version;
+			__entry->version = inode_get_iversion_raw(inode);
 		),
 
 		TP_printk(
@@ -99,7 +99,7 @@ DECLARE_EVENT_CLASS(nfs_inode_event_done,
 			__entry->fileid = nfsi->fileid;
 			__entry->fhandle = nfs_fhandle_hash(&nfsi->fh);
 			__entry->type = nfs_umode_to_dtype(inode->i_mode);
-			__entry->version = inode->i_version;
+			__entry->version = inode_get_iversion_raw(inode);
 			__entry->size = i_size_read(inode);
 			__entry->nfsi_flags = nfsi->flags;
 			__entry->cache_validity = nfsi->cache_validity;
diff --git a/fs/nfs/write.c b/fs/nfs/write.c
index 6e761f3f4cbf..da05b57e394d 100644
--- a/fs/nfs/write.c
+++ b/fs/nfs/write.c
@@ -692,7 +692,7 @@ static void nfs_inode_add_request(struct inode *inode, struct nfs_page *req)
 	spin_lock(&inode->i_lock);
 	if (!nfsi->nrequests &&
 	    NFS_PROTO(inode)->have_delegation(inode, FMODE_WRITE))
-		inode->i_version++;
+		inode_inc_iversion_locked(inode);
 	/*
 	 * Swap-space should not get truncated. Hence no need to plug the race
 	 * with invalidate/truncate.
-- 
2.7.4

