Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id E36E77F51
	for <xfs@oss.sgi.com>; Thu, 22 Jan 2015 05:11:15 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id C96D330405F
	for <xfs@oss.sgi.com>; Thu, 22 Jan 2015 03:11:15 -0800 (PST)
Received: from casper.infradead.org (casper.infradead.org [85.118.1.10]) by
	cuda.sgi.com with ESMTP id FnOrGDNYIMDBGRAj (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 22 Jan 2015 03:11:15 -0800 (PST)
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 05/20] nfsd: move nfsd_fh_match to nfsfh.h
Date: Thu, 22 Jan 2015 12:09:51 +0100
Message-Id: <1421925006-24231-6-git-send-email-hch@lst.de>
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

The pnfs code will need it too.  Also remove the nfsd_ prefix to match the
other filehandle helpers in that file.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/nfsd/nfs4state.c | 12 ++----------
 fs/nfsd/nfsfh.h     |  9 +++++++++
 2 files changed, 11 insertions(+), 10 deletions(-)

diff --git a/fs/nfsd/nfs4state.c b/fs/nfsd/nfs4state.c
index 30ff0d4..b4f86f8 100644
--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -408,14 +408,6 @@ static unsigned int file_hashval(struct knfsd_fh *fh)
 	return nfsd_fh_hashval(fh) & (FILE_HASH_SIZE - 1);
 }
 
-static bool nfsd_fh_match(struct knfsd_fh *fh1, struct knfsd_fh *fh2)
-{
-	return fh1->fh_size == fh2->fh_size &&
-		!memcmp(fh1->fh_base.fh_pad,
-				fh2->fh_base.fh_pad,
-				fh1->fh_size);
-}
-
 static struct hlist_head file_hashtbl[FILE_HASH_SIZE];
 
 static void
@@ -3300,7 +3292,7 @@ find_file_locked(struct knfsd_fh *fh, unsigned int hashval)
 	struct nfs4_file *fp;
 
 	hlist_for_each_entry_rcu(fp, &file_hashtbl[hashval], fi_hash) {
-		if (nfsd_fh_match(&fp->fi_fhandle, fh)) {
+		if (fh_match(&fp->fi_fhandle, fh)) {
 			if (atomic_inc_not_zero(&fp->fi_ref))
 				return fp;
 		}
@@ -4295,7 +4287,7 @@ laundromat_main(struct work_struct *laundry)
 
 static inline __be32 nfs4_check_fh(struct svc_fh *fhp, struct nfs4_ol_stateid *stp)
 {
-	if (!nfsd_fh_match(&fhp->fh_handle, &stp->st_stid.sc_file->fi_fhandle))
+	if (!fh_match(&fhp->fh_handle, &stp->st_stid.sc_file->fi_fhandle))
 		return nfserr_bad_stateid;
 	return nfs_ok;
 }
diff --git a/fs/nfsd/nfsfh.h b/fs/nfsd/nfsfh.h
index 08236d7..e24d954 100644
--- a/fs/nfsd/nfsfh.h
+++ b/fs/nfsd/nfsfh.h
@@ -187,6 +187,15 @@ fh_init(struct svc_fh *fhp, int maxsize)
 	return fhp;
 }
 
+static inline bool fh_match(struct knfsd_fh *fh1, struct knfsd_fh *fh2)
+{
+	if (fh1->fh_size != fh2->fh_size)
+		return false;
+	if (memcmp(fh1->fh_base.fh_pad, fh2->fh_base.fh_pad, fh1->fh_size) != 0)
+		return false;
+	return true;
+}
+
 #ifdef CONFIG_NFSD_V3
 /*
  * The wcc data stored in current_fh should be cleared
-- 
1.9.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
