Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id F27AD7F4E
	for <xfs@oss.sgi.com>; Sat, 12 Oct 2013 01:43:06 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id D5476304043
	for <xfs@oss.sgi.com>; Fri, 11 Oct 2013 23:43:06 -0700 (PDT)
Received: from e23smtp05.au.ibm.com (e23smtp05.au.ibm.com [202.81.31.147]) by
	cuda.sgi.com with ESMTP id jWi0VroANVgqhrp6 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 11 Oct 2013 23:43:04 -0700 (PDT)
Received: from /spool/local
	by e23smtp05.au.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use
	Only! Violators will be prosecuted
	for <xfs@oss.sgi.com> from <zhong@linux.vnet.ibm.com>;
	Sat, 12 Oct 2013 16:42:59 +1000
Received: from d23relay05.au.ibm.com (d23relay05.au.ibm.com [9.190.235.152])
	by d23dlp02.au.ibm.com (Postfix) with ESMTP id AD64A2BB0040
	for <xfs@oss.sgi.com>; Sat, 12 Oct 2013 17:42:57 +1100 (EST)
Received: from d23av03.au.ibm.com (d23av03.au.ibm.com [9.190.234.97])
	by d23relay05.au.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id
	r9C6Pm4t8388892
	for <xfs@oss.sgi.com>; Sat, 12 Oct 2013 17:25:48 +1100
Received: from d23av03.au.ibm.com (localhost [127.0.0.1])
	by d23av03.au.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id
	r9C6gvCw019038 for <xfs@oss.sgi.com>; Sat, 12 Oct 2013 17:42:57 +1100
Message-ID: <1381560174.3064.4.camel@ThinkPad-T5421>
Subject: [PATCH] xfsprogs: fix resouce leak in longform_dir2_rebuild()
From: Li Zhong <zhong@linux.vnet.ibm.com>
Date: Sat, 12 Oct 2013 14:42:54 +0800
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
To: xfsprogs <xfs@oss.sgi.com>
Cc: Chandra Seetharaman <sekharan@us.ibm.com>

coverity scan 997010 reported following leak in repair/phase6.c

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
so I also added a bmap cancel there.

Signed-off-by: Li Zhong <zhong@linux.vnet.ibm.com>
---
 repair/phase6.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/repair/phase6.c b/repair/phase6.c
index a4ad7a3..0d88ad2 100644
--- a/repair/phase6.c
+++ b/repair/phase6.c
@@ -1310,6 +1310,8 @@ longform_dir2_rebuild(
 			do_warn(
 	_("space reservation failed (%d), filesystem may be out of space\n"),
 				error);
+			libxfs_trans_cancel(tp, XFS_TRANS_RELEASE_LOG_RES |
+						XFS_TRANS_ABORT);
 			break;
 		}
 
@@ -1323,6 +1325,7 @@ longform_dir2_rebuild(
 			do_warn(
 _("name create failed in ino %" PRIu64 " (%d), filesystem may be out of space\n"),
 				ino, error);
+			libxfs_bmap_cancel(&flist);
 			libxfs_trans_cancel(tp, XFS_TRANS_RELEASE_LOG_RES |
 						XFS_TRANS_ABORT);
 			break;
-- 
1.8.1.4


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
