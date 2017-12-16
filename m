Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:42122 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756953AbdLPNrY (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sat, 16 Dec 2017 08:47:24 -0500
From: Jeff Layton <jlayton@kernel.org>
Subject: [PATCH v2 10/19] nfs: convert to new i_version API
Date: Sat, 16 Dec 2017 08:46:47 -0500
Message-Id: <20171216134656.15561-11-jlayton@kernel.org>
In-Reply-To: <20171216134656.15561-1-jlayton@kernel.org>
References: <20171216134656.15561-1-jlayton@kernel.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk, linux-nfs@vger.kernel.org, bfields@fieldses.org, neilb@suse.de, jack@suse.de, linux-ext4@vger.kernel.org, tytso@mit.edu, adilger.kernel@dilger.ca, linux-xfs@vger.kernel.org, darrick.wong@oracle.com, david@fromorbit.com, linux-btrfs@vger.kernel.org, clm@fb.com, jbacik@fb.com, dsterba@suse.com, linux-integrity@vger.kernel.org, zohar@linux.vnet.ibm.com, dmitry.kasatkin@gmail.com, linux-afs@lists.infradead.org, dhowells@redhat.com

From: Jeff Layton <jlayton@redhat.com>

For NFS, we just use the "raw" API since the i_version is mostly
managed by the server. The exception there is when the client
holds a write delegation, but we only need to bump it once
there anyway to handle CB_GETATTR.

Signed-off-by: Jeff Layton <jlayton@redhat.com>
---
 fs/nfs/delegation.c    |  2 +-
 fs/nfs/fscache-index.c |  4 ++--
 fs/nfs/inode.c         | 16 ++++++++--------
 fs/nfs/nfs4proc.c      |  9 +++++----
 fs/nfs/nfstrace.h      |  4 ++--
 fs/nfs/write.c         |  7 ++-----
 6 files changed, 20 insertions(+), 22 deletions(-)

diff --git a/fs/nfs/delegation.c b/fs/nfs/delegation.c
index ade44ca0c66c..89b22b2a111c 100644
--- a/fs/nfs/delegation.c
+++ b/fs/nfs/delegation.c
@@ -347,7 +347,7 @@ int nfs_inode_set_delegation(struct inode *inode, struct rpc_cred *cred, struct
 	nfs4_stateid_copy(&delegation->stateid, &res->delegation);
 	delegation->type = res->delegation_type;
 	delegation->pagemod_limit = res->pagemod_limit;
-	delegation->change_attr = inode->i_version;
+	delegation->change_attr = inode_peek_iversion_raw(inode);
 	delegation->cred = get_rpccred(cred);
 	delegation->inode = inode;
 	delegation->flags = 1<<NFS_DELEGATION_REFERENCED;
diff --git a/fs/nfs/fscache-index.c b/fs/nfs/fscache-index.c
index 3025fe8584a0..8bf080ce4984 100644
--- a/fs/nfs/fscache-index.c
+++ b/fs/nfs/fscache-index.c
@@ -211,7 +211,7 @@ static uint16_t nfs_fscache_inode_get_aux(const void *cookie_netfs_data,
 	auxdata.ctime = nfsi->vfs_inode.i_ctime;
 
 	if (NFS_SERVER(&nfsi->vfs_inode)->nfs_client->rpc_ops->version == 4)
-		auxdata.change_attr = nfsi->vfs_inode.i_version;
+		auxdata.change_attr = inode_peek_iversion_raw(&nfsi->vfs_inode);
 
 	if (bufmax > sizeof(auxdata))
 		bufmax = sizeof(auxdata);
@@ -243,7 +243,7 @@ enum fscache_checkaux nfs_fscache_inode_check_aux(void *cookie_netfs_data,
 	auxdata.ctime = nfsi->vfs_inode.i_ctime;
 
 	if (NFS_SERVER(&nfsi->vfs_inode)->nfs_client->rpc_ops->version == 4)
-		auxdata.change_attr = nfsi->vfs_inode.i_version;
+		auxdata.change_attr = inode_peek_iversion_raw(&nfsi->vfs_inode);
 
 	if (memcmp(data, &auxdata, datalen) != 0)
 		return FSCACHE_CHECKAUX_OBSOLETE;
diff --git a/fs/nfs/inode.c b/fs/nfs/inode.c
index b992d2382ffa..c55b86c87bce 100644
--- a/fs/nfs/inode.c
+++ b/fs/nfs/inode.c
@@ -483,7 +483,7 @@ nfs_fhget(struct super_block *sb, struct nfs_fh *fh, struct nfs_fattr *fattr, st
 		memset(&inode->i_atime, 0, sizeof(inode->i_atime));
 		memset(&inode->i_mtime, 0, sizeof(inode->i_mtime));
 		memset(&inode->i_ctime, 0, sizeof(inode->i_ctime));
-		inode->i_version = 0;
+		inode_set_iversion_raw(inode, 0);
 		inode->i_size = 0;
 		clear_nlink(inode);
 		inode->i_uid = make_kuid(&init_user_ns, -2);
@@ -508,7 +508,7 @@ nfs_fhget(struct super_block *sb, struct nfs_fh *fh, struct nfs_fattr *fattr, st
 		else if (nfs_server_capable(inode, NFS_CAP_CTIME))
 			nfs_set_cache_invalid(inode, NFS_INO_INVALID_ATTR);
 		if (fattr->valid & NFS_ATTR_FATTR_CHANGE)
-			inode->i_version = fattr->change_attr;
+			inode_set_iversion_raw(inode, fattr->change_attr);
 		else
 			nfs_set_cache_invalid(inode, NFS_INO_INVALID_ATTR
 				| NFS_INO_REVAL_PAGECACHE);
@@ -1289,8 +1289,8 @@ static unsigned long nfs_wcc_update_inode(struct inode *inode, struct nfs_fattr
 
 	if ((fattr->valid & NFS_ATTR_FATTR_PRECHANGE)
 			&& (fattr->valid & NFS_ATTR_FATTR_CHANGE)
-			&& inode->i_version == fattr->pre_change_attr) {
-		inode->i_version = fattr->change_attr;
+			&& !inode_cmp_iversion(inode, fattr->pre_change_attr)) {
+		inode_set_iversion_raw(inode, fattr->change_attr);
 		if (S_ISDIR(inode->i_mode))
 			nfs_set_cache_invalid(inode, NFS_INO_INVALID_DATA);
 		ret |= NFS_INO_INVALID_ATTR;
@@ -1348,7 +1348,7 @@ static int nfs_check_inode_attributes(struct inode *inode, struct nfs_fattr *fat
 
 	if (!nfs_file_has_buffered_writers(nfsi)) {
 		/* Verify a few of the more important attributes */
-		if ((fattr->valid & NFS_ATTR_FATTR_CHANGE) != 0 && inode->i_version != fattr->change_attr)
+		if ((fattr->valid & NFS_ATTR_FATTR_CHANGE) != 0 && inode_cmp_iversion(inode, fattr->change_attr))
 			invalid |= NFS_INO_INVALID_ATTR | NFS_INO_REVAL_PAGECACHE;
 
 		if ((fattr->valid & NFS_ATTR_FATTR_MTIME) && !timespec_equal(&inode->i_mtime, &fattr->mtime))
@@ -1642,7 +1642,7 @@ int nfs_post_op_update_inode_force_wcc_locked(struct inode *inode, struct nfs_fa
 	}
 	if ((fattr->valid & NFS_ATTR_FATTR_CHANGE) != 0 &&
 			(fattr->valid & NFS_ATTR_FATTR_PRECHANGE) == 0) {
-		fattr->pre_change_attr = inode->i_version;
+		fattr->pre_change_attr = inode_peek_iversion_raw(inode);
 		fattr->valid |= NFS_ATTR_FATTR_PRECHANGE;
 	}
 	if ((fattr->valid & NFS_ATTR_FATTR_CTIME) != 0 &&
@@ -1778,7 +1778,7 @@ static int nfs_update_inode(struct inode *inode, struct nfs_fattr *fattr)
 
 	/* More cache consistency checks */
 	if (fattr->valid & NFS_ATTR_FATTR_CHANGE) {
-		if (inode->i_version != fattr->change_attr) {
+		if (inode_cmp_iversion(inode, fattr->change_attr)) {
 			dprintk("NFS: change_attr change on server for file %s/%ld\n",
 					inode->i_sb->s_id, inode->i_ino);
 			/* Could it be a race with writeback? */
@@ -1790,7 +1790,7 @@ static int nfs_update_inode(struct inode *inode, struct nfs_fattr *fattr)
 				if (S_ISDIR(inode->i_mode))
 					nfs_force_lookup_revalidate(inode);
 			}
-			inode->i_version = fattr->change_attr;
+			inode_set_iversion_raw(inode, fattr->change_attr);
 		}
 	} else {
 		nfsi->cache_validity |= save_cache_validity;
diff --git a/fs/nfs/nfs4proc.c b/fs/nfs/nfs4proc.c
index 56fa5a16e097..67ce69bce04e 100644
--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -1045,16 +1045,16 @@ static void update_changeattr(struct inode *dir, struct nfs4_change_info *cinfo,
 
 	spin_lock(&dir->i_lock);
 	nfsi->cache_validity |= NFS_INO_INVALID_ATTR|NFS_INO_INVALID_DATA;
-	if (cinfo->atomic && cinfo->before == dir->i_version) {
+	if (cinfo->atomic && cinfo->before == inode_peek_iversion_raw(dir)) {
 		nfsi->cache_validity &= ~NFS_INO_REVAL_PAGECACHE;
 		nfsi->attrtimeo_timestamp = jiffies;
 	} else {
 		nfs_force_lookup_revalidate(dir);
-		if (cinfo->before != dir->i_version)
+		if (cinfo->before != inode_peek_iversion_raw(dir))
 			nfsi->cache_validity |= NFS_INO_INVALID_ACCESS |
 				NFS_INO_INVALID_ACL;
 	}
-	dir->i_version = cinfo->after;
+	inode_set_iversion_raw(dir, cinfo->after);
 	nfsi->read_cache_jiffies = timestamp;
 	nfsi->attr_gencount = nfs_inc_attr_generation_counter();
 	nfs_fscache_invalidate(dir);
@@ -2454,7 +2454,8 @@ static int _nfs4_proc_open(struct nfs4_opendata *data)
 			data->file_created = true;
 		else if (o_res->cinfo.before != o_res->cinfo.after)
 			data->file_created = true;
-		if (data->file_created || dir->i_version != o_res->cinfo.after)
+		if (data->file_created ||
+		    inode_peek_iversion_raw(dir) != o_res->cinfo.after)
 			update_changeattr(dir, &o_res->cinfo,
 					o_res->f_attr->time_start);
 	}
diff --git a/fs/nfs/nfstrace.h b/fs/nfs/nfstrace.h
index 093290c42d7c..3e4b20d8994a 100644
--- a/fs/nfs/nfstrace.h
+++ b/fs/nfs/nfstrace.h
@@ -61,7 +61,7 @@ DECLARE_EVENT_CLASS(nfs_inode_event,
 			__entry->dev = inode->i_sb->s_dev;
 			__entry->fileid = nfsi->fileid;
 			__entry->fhandle = nfs_fhandle_hash(&nfsi->fh);
-			__entry->version = inode->i_version;
+			__entry->version = inode_peek_iversion_raw(inode);
 		),
 
 		TP_printk(
@@ -100,7 +100,7 @@ DECLARE_EVENT_CLASS(nfs_inode_event_done,
 			__entry->fileid = nfsi->fileid;
 			__entry->fhandle = nfs_fhandle_hash(&nfsi->fh);
 			__entry->type = nfs_umode_to_dtype(inode->i_mode);
-			__entry->version = inode->i_version;
+			__entry->version = inode_peek_iversion_raw(inode);
 			__entry->size = i_size_read(inode);
 			__entry->nfsi_flags = nfsi->flags;
 			__entry->cache_validity = nfsi->cache_validity;
diff --git a/fs/nfs/write.c b/fs/nfs/write.c
index 5b5f464f6f2a..258f2c85b921 100644
--- a/fs/nfs/write.c
+++ b/fs/nfs/write.c
@@ -753,11 +753,8 @@ static void nfs_inode_add_request(struct inode *inode, struct nfs_page *req)
 	 */
 	spin_lock(&mapping->private_lock);
 	if (!nfs_have_writebacks(inode) &&
-	    NFS_PROTO(inode)->have_delegation(inode, FMODE_WRITE)) {
-		spin_lock(&inode->i_lock);
-		inode->i_version++;
-		spin_unlock(&inode->i_lock);
-	}
+	    NFS_PROTO(inode)->have_delegation(inode, FMODE_WRITE))
+		inode_inc_iversion(inode);
 	if (likely(!PageSwapCache(req->wb_page))) {
 		set_bit(PG_MAPPED, &req->wb_flags);
 		SetPagePrivate(req->wb_page);
-- 
2.14.3

