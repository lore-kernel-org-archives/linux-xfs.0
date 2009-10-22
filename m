Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n9MGov6x115100 for <xfs@oss.sgi.com>; Thu, 22 Oct 2009 11:50:58 -0500
Received: from estes.americas.sgi.com (estes.americas.sgi.com [128.162.236.10])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 62B5A8F8078
	for <xfs@oss.sgi.com>; Thu, 22 Oct 2009 09:52:33 -0700 (PDT)
Received: from [128.162.233.117] (augusta.americas.sgi.com [128.162.233.117])
	by estes.americas.sgi.com (Postfix) with ESMTP id 4419D7000103
	for <xfs@oss.sgi.com>; Thu, 22 Oct 2009 11:52:33 -0500 (CDT)
Message-ID: <4AE08DD0.50304@sgi.com>
Date: Thu, 22 Oct 2009 11:52:32 -0500
From: Bill Kendall <wkendall@sgi.com>
MIME-Version: 1.0
Subject: [PATCH 2/2] use lpath_to_handle when restoring symlinks
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Update xfsrestore to use the new lpath_to_handle function
when dealing with symlinks.

Signed-off-by: Bill Kendall <wkendall@sgi.com>

diff --git a/restore/content.c b/restore/content.c
index eb6e78c..99549a8 100644
--- a/restore/content.c
+++ b/restore/content.c
@@ -797,7 +797,6 @@ static void partial_reg(ix_t d_index, xfs_ino_t ino, off64_t fsize,
                          off64_t offset, off64_t sz);
  static bool_t partial_check (xfs_ino_t ino, off64_t fsize);
  static bool_t partial_check2 (partial_rest_t *isptr, off64_t fsize);
-static int do_fssetdm_by_handle( char *path, fsdmidata_t *fdmp);
  static int quotafilecheck(char *type, char *dstdir, char *quotafile);

  /* definition of locally defined global variables ****************************/
@@ -7895,14 +7894,28 @@ restore_symlink( drive_t *drivep,
  		}

  		if ( persp->a.restoredmpr) {
-		fsdmidata_t fssetdm;
-		
-		/*	Restore DMAPI fields. */
+			fsdmidata_t fssetdm;
+			void *hanp;
+			size_t hlen=0;

-		fssetdm.fsd_dmevmask = bstatp->bs_dmevmask;
-		fssetdm.fsd_padding = 0;
-		fssetdm.fsd_dmstate = bstatp->bs_dmstate;
-		rval = do_fssetdm_by_handle(path, &fssetdm);
+			/*	Restore DMAPI fields. */
+			fssetdm.fsd_dmevmask = bstatp->bs_dmevmask;
+			fssetdm.fsd_padding = 0;
+			fssetdm.fsd_dmstate = bstatp->bs_dmstate;
+
+			if (lpath_to_handle(persp->a.dstdir, path, &hanp, &hlen)) {
+				mlog( MLOG_NORMAL | MLOG_WARNING, _(
+					"lpath_to_handle of %s failed: %s\n"),
+					path, strerror( errno ));
+			} else {
+				if (fssetdm_by_handle(hanp, hlen, &fssetdm)) {
+					mlog( MLOG_NORMAL | MLOG_WARNING,
+						_("fssetdm_by_handle of %s "
+						"failed: %s\n"),
+						path, strerror( errno ));
+				}
+				free_handle(hanp, hlen);
+			}
  		}
  	}

@@ -9525,32 +9538,6 @@ display_needed_objects( purp_t purp,
  }

  static int
-do_fssetdm_by_handle(
-	char		*path,
-	fsdmidata_t	*fdmp)
-{
-	void		*hanp;
-	size_t		hlen=0;
-	int		rc;
-
-	if (path_to_handle(path, &hanp, &hlen)) {
-		mlog( MLOG_NORMAL | MLOG_WARNING, _(
-			"path_to_handle of %s failed:%s\n"),
-			path, strerror( errno ));
-		return -1;
-	}
-
-	rc = fssetdm_by_handle(hanp, hlen, fdmp);
-	free_handle(hanp, hlen);
-	if (rc) {
-		mlog( MLOG_NORMAL | MLOG_WARNING, _(
-			"fssetdm_by_handle of %s failed %s\n"),
-			path, strerror( errno ));
-	}
-	return rc;
-}
-
-static int
  quotafilecheck(char *type, char *dstdir, char *quotafile)
  {
  	struct stat s;

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
