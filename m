Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id D41447F56
	for <xfs@oss.sgi.com>; Thu, 22 Jan 2015 05:11:17 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id C18748F8049
	for <xfs@oss.sgi.com>; Thu, 22 Jan 2015 03:11:14 -0800 (PST)
Received: from casper.infradead.org (casper.infradead.org [85.118.1.10]) by
	cuda.sgi.com with ESMTP id 1CxAL9xVdCOpj3Dw (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 22 Jan 2015 03:11:12 -0800 (PST)
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 02/20] fs: track fl_owner for leases
Date: Thu, 22 Jan 2015 12:09:48 +0100
Message-Id: <1421925006-24231-3-git-send-email-hch@lst.de>
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

Just like for other lock types we should allow different owners to have
a read lease on a file.  Currently this can't happen, but with the addition
of pNFS layout leases we'll need this feature.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/locks.c          | 12 +++++++-----
 fs/nfsd/nfs4state.c |  2 +-
 2 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/fs/locks.c b/fs/locks.c
index 2fc36b3..65350a23 100644
--- a/fs/locks.c
+++ b/fs/locks.c
@@ -1661,7 +1661,8 @@ generic_add_lease(struct file *filp, long arg, struct file_lock **flp, void **pr
 	 */
 	error = -EAGAIN;
 	list_for_each_entry(fl, &ctx->flc_lease, fl_list) {
-		if (fl->fl_file == filp) {
+		if (fl->fl_file == filp &&
+		    fl->fl_owner == lease->fl_owner) {
 			my_fl = fl;
 			continue;
 		}
@@ -1721,7 +1722,7 @@ out:
 	return error;
 }
 
-static int generic_delete_lease(struct file *filp)
+static int generic_delete_lease(struct file *filp, void *owner)
 {
 	int error = -EAGAIN;
 	struct file_lock *fl, *victim = NULL;
@@ -1737,7 +1738,8 @@ static int generic_delete_lease(struct file *filp)
 
 	spin_lock(&ctx->flc_lock);
 	list_for_each_entry(fl, &ctx->flc_lease, fl_list) {
-		if (fl->fl_file == filp) {
+		if (fl->fl_file == filp &&
+		    fl->fl_owner == owner) {
 			victim = fl;
 			break;
 		}
@@ -1778,7 +1780,7 @@ int generic_setlease(struct file *filp, long arg, struct file_lock **flp,
 
 	switch (arg) {
 	case F_UNLCK:
-		return generic_delete_lease(filp);
+		return generic_delete_lease(filp, *priv);
 	case F_RDLCK:
 	case F_WRLCK:
 		if (!(*flp)->fl_lmops->lm_break) {
@@ -1857,7 +1859,7 @@ static int do_fcntl_add_lease(unsigned int fd, struct file *filp, long arg)
 int fcntl_setlease(unsigned int fd, struct file *filp, long arg)
 {
 	if (arg == F_UNLCK)
-		return vfs_setlease(filp, F_UNLCK, NULL, NULL);
+		return vfs_setlease(filp, F_UNLCK, NULL, (void **)&filp);
 	return do_fcntl_add_lease(fd, filp, arg);
 }
 
diff --git a/fs/nfsd/nfs4state.c b/fs/nfsd/nfs4state.c
index 532a60c..30ff0d4 100644
--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -693,7 +693,7 @@ static void nfs4_put_deleg_lease(struct nfs4_file *fp)
 	spin_unlock(&fp->fi_lock);
 
 	if (filp) {
-		vfs_setlease(filp, F_UNLCK, NULL, NULL);
+		vfs_setlease(filp, F_UNLCK, NULL, (void **)&fp);
 		fput(filp);
 	}
 }
-- 
1.9.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
