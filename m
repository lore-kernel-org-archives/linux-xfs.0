Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:36942 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S936642AbcLUREH (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 21 Dec 2016 12:04:07 -0500
From: Jeff Layton <jlayton@redhat.com>
Subject: [RFC PATCH v1 20/30] nfsd: convert to new i_version API
Date: Wed, 21 Dec 2016 12:03:37 -0500
Message-Id: <1482339827-7882-21-git-send-email-jlayton@redhat.com>
In-Reply-To: <1482339827-7882-1-git-send-email-jlayton@redhat.com>
References: <1482339827-7882-1-git-send-email-jlayton@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-nfs@vger.kernel.org, linux-ext4@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-xfs@vger.kernel.org

Mostly just making sure we use the "get" wrappers so we know when
it is being fetched for later use.

Signed-off-by: Jeff Layton <jlayton@redhat.com>
---
 fs/nfsd/nfs3xdr.c | 2 +-
 fs/nfsd/nfs4xdr.c | 2 +-
 fs/nfsd/nfsfh.h   | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/nfsd/nfs3xdr.c b/fs/nfsd/nfs3xdr.c
index dba2ff8eaa68..a645b1dbc4e3 100644
--- a/fs/nfsd/nfs3xdr.c
+++ b/fs/nfsd/nfs3xdr.c
@@ -260,7 +260,7 @@ void fill_post_wcc(struct svc_fh *fhp)
 		printk("nfsd: inode locked twice during operation.\n");
 
 	err = fh_getattr(fhp, &fhp->fh_post_attr);
-	fhp->fh_post_change = d_inode(fhp->fh_dentry)->i_version;
+	fhp->fh_post_change = inode_get_iversion(d_inode(fhp->fh_dentry));
 	if (err) {
 		fhp->fh_post_saved = false;
 		/* Grab the ctime anyway - set_change_info might use it */
diff --git a/fs/nfsd/nfs4xdr.c b/fs/nfsd/nfs4xdr.c
index 7ecf16be4a44..98bd030f849a 100644
--- a/fs/nfsd/nfs4xdr.c
+++ b/fs/nfsd/nfs4xdr.c
@@ -1969,7 +1969,7 @@ nfsd4_decode_compound(struct nfsd4_compoundargs *argp)
 static __be32 *encode_change(__be32 *p, struct kstat *stat, struct inode *inode)
 {
 	if (IS_I_VERSION(inode)) {
-		p = xdr_encode_hyper(p, inode->i_version);
+		p = xdr_encode_hyper(p, inode_get_iversion(inode));
 	} else {
 		*p++ = cpu_to_be32(stat->ctime.tv_sec);
 		*p++ = cpu_to_be32(stat->ctime.tv_nsec);
diff --git a/fs/nfsd/nfsfh.h b/fs/nfsd/nfsfh.h
index f84fe6bf9aee..7a66065f6e74 100644
--- a/fs/nfsd/nfsfh.h
+++ b/fs/nfsd/nfsfh.h
@@ -253,7 +253,7 @@ fill_pre_wcc(struct svc_fh *fhp)
 		fhp->fh_pre_mtime = inode->i_mtime;
 		fhp->fh_pre_ctime = inode->i_ctime;
 		fhp->fh_pre_size  = inode->i_size;
-		fhp->fh_pre_change = inode->i_version;
+		fhp->fh_pre_change = inode_get_iversion(inode);
 		fhp->fh_pre_saved = true;
 	}
 }
-- 
2.7.4

