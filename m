Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 894D07F37
	for <xfs@oss.sgi.com>; Mon, 14 Oct 2013 21:55:46 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 5B226304039
	for <xfs@oss.sgi.com>; Mon, 14 Oct 2013 19:55:46 -0700 (PDT)
Received: from e28smtp02.in.ibm.com (e28smtp02.in.ibm.com [122.248.162.2]) by
	cuda.sgi.com with ESMTP id ZQch5XmoQYLyCYEY (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 14 Oct 2013 19:55:41 -0700 (PDT)
Received: from /spool/local
	by e28smtp02.in.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use
	Only! Violators will be prosecuted
	for <xfs@oss.sgi.com> from <zhong@linux.vnet.ibm.com>;
	Tue, 15 Oct 2013 08:25:37 +0530
Received: from d28relay02.in.ibm.com (d28relay02.in.ibm.com [9.184.220.59])
	by d28dlp01.in.ibm.com (Postfix) with ESMTP id EEB80E004A
	for <xfs@oss.sgi.com>; Tue, 15 Oct 2013 08:26:57 +0530 (IST)
Received: from d28av04.in.ibm.com (d28av04.in.ibm.com [9.184.220.66])
	by d28relay02.in.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id
	r9F2wJWj40763496
	for <xfs@oss.sgi.com>; Tue, 15 Oct 2013 08:28:20 +0530
Received: from d28av04.in.ibm.com (localhost [127.0.0.1])
	by d28av04.in.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id
	r9F2tXxI023917 for <xfs@oss.sgi.com>; Tue, 15 Oct 2013 08:25:33 +0530
Message-ID: <1381805731.3106.5.camel@ThinkPad-T5421>
Subject: [PATCH v2] xfsprogs: fix resource leak in longform_dir2_rebuild()
From: Li Zhong <zhong@linux.vnet.ibm.com>
Date: Tue, 15 Oct 2013 10:55:31 +0800
In-Reply-To: <20131014214601.GJ5663@dastard>
References: <1381560174.3064.4.camel@ThinkPad-T5421>
	<20131014214601.GJ5663@dastard>
Mime-Version: 1.0
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
To: Dave Chinner <david@fromorbit.com>
Cc: Chandra Seetharaman <sekharan@us.ibm.com>, xfsprogs <xfs@oss.sgi.com>

coverity scan 997010 reported following leak:

1309                if (error) {
1310                        do_warn(
1311        _("space reservation failed (%d), filesystem may be out of space\n"),
1312                                error);
    	25. Breaking from loop
1313                        break;
1314                }

......

1342                libxfs_trans_commit(tp,
1343                                XFS_TRANS_RELEASE_LOG_RES|XFS_TRANS_SYNC);
1344        }

CID 997010 (#1 of 1): Resource leak (RESOURCE_LEAK)
26. leaked_storage: Variable "tp" going out of scope leaks the storage it points to.
1345}

Though not reported by coverity, it seems that there might be some entries in
flist which needs to be freed in the failure case below libxfs_dir_createname(),
and libxfs_bunmapi().

The fix cleans up the code by stacking the error handling at the end of the
function, and jumping to the error handler label for the above cases. (fail
directly by calling res_failed() for reservation failure.)

Signed-off-by: Li Zhong <zhong@linux.vnet.ibm.com>
---
v2: as Dave suggested,
        use res_failed() for libxfs_trans_reserve()
        adding bmap cancel for one missed case
        using error handling lables to clean up the code

 repair/phase6.c | 28 ++++++++++++----------------
 1 file changed, 12 insertions(+), 16 deletions(-)

diff --git a/repair/phase6.c b/repair/phase6.c
index a4ad7a3..6b3fb09 100644
--- a/repair/phase6.c
+++ b/repair/phase6.c
@@ -1280,9 +1280,7 @@ longform_dir2_rebuild(
 				&firstblock, &flist, &done);
 	if (error) {
 		do_warn(_("xfs_bunmapi failed -- error - %d\n"), error);
-		libxfs_trans_cancel(tp, XFS_TRANS_RELEASE_LOG_RES |
-					XFS_TRANS_ABORT);
-		return;
+		goto out_bmap_cancel;
 	}
 
 	ASSERT(done);
@@ -1306,12 +1304,8 @@ longform_dir2_rebuild(
 		nres = XFS_CREATE_SPACE_RES(mp, p->name.len);
 		error = libxfs_trans_reserve(tp, &M_RES(mp)->tr_create,
 					     nres, 0);
-		if (error) {
-			do_warn(
-	_("space reservation failed (%d), filesystem may be out of space\n"),
-				error);
-			break;
-		}
+		if (error)
+			res_failed(error);
 
 		libxfs_trans_ijoin(tp, ip, 0);
 		libxfs_trans_ihold(tp, ip);
@@ -1323,9 +1317,7 @@ longform_dir2_rebuild(
 			do_warn(
 _("name create failed in ino %" PRIu64 " (%d), filesystem may be out of space\n"),
 				ino, error);
-			libxfs_trans_cancel(tp, XFS_TRANS_RELEASE_LOG_RES |
-						XFS_TRANS_ABORT);
-			break;
+			goto out_bmap_cancel;
 		}
 
 		error = libxfs_bmap_finish(&tp, &flist, &committed);
@@ -1333,15 +1325,19 @@ _("name create failed in ino %" PRIu64 " (%d), filesystem may be out of space\n"
 			do_warn(
 	_("bmap finish failed (%d), filesystem may be out of space\n"),
 				error);
-			libxfs_bmap_cancel(&flist);
-			libxfs_trans_cancel(tp, XFS_TRANS_RELEASE_LOG_RES |
-						XFS_TRANS_ABORT);
-			break;
+			goto out_bmap_cancel;
 		}
 
 		libxfs_trans_commit(tp,
 				XFS_TRANS_RELEASE_LOG_RES|XFS_TRANS_SYNC);
 	}
+
+	return;
+
+out_bmap_cancel:
+	libxfs_bmap_cancel(&flist);
+	libxfs_trans_cancel(tp, XFS_TRANS_RELEASE_LOG_RES | XFS_TRANS_ABORT);
+	return;
 }
 
 
-- 
1.8.1.4



_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
