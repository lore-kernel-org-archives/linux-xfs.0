Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 1053E29DF5
	for <xfs@oss.sgi.com>; Thu, 27 Aug 2015 16:27:32 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id E5EDC30404E
	for <xfs@oss.sgi.com>; Thu, 27 Aug 2015 14:27:28 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id wcI9323n8xtDk2jA (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 27 Aug 2015 14:27:24 -0700 (PDT)
Received: from int-mx10.intmail.prod.int.phx2.redhat.com
	(int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (Postfix) with ESMTPS id 0D1828C1AC
	for <xfs@oss.sgi.com>; Thu, 27 Aug 2015 21:27:24 +0000 (UTC)
Received: from liberator.sandeen.net (ovpn01.gateway.prod.ext.phx2.redhat.com
	[10.5.9.1])
	by int-mx10.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id t7RLRMvb010685
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <xfs@oss.sgi.com>; Thu, 27 Aug 2015 17:27:23 -0400
Message-ID: <55DF80BA.9020101@redhat.com>
Date: Thu, 27 Aug 2015 16:27:22 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
Subject: [PATCH] xfs: fix error gotos in xfs_setattr_nonsize
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
To: xfs-oss <xfs@oss.sgi.com>

As the code stands today, if xfs_trans_reserve() fails, we
goto out_dqrele, which does not free the allocated transaction.

Fix up the goto targets to undo everything properly.

Addresses-Coverity-Id: 145571
Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

Full disclosure: build tested only, as these are error paths
which we don't easily fail...

diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index 766b23f..8294132 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -609,7 +609,7 @@ xfs_setattr_nonsize(
 	tp = xfs_trans_alloc(mp, XFS_TRANS_SETATTR_NOT_SIZE);
 	error = xfs_trans_reserve(tp, &M_RES(mp)->tr_ichange, 0, 0);
 	if (error)
-		goto out_dqrele;
+		goto out_trans_cancel;
 
 	xfs_ilock(ip, XFS_ILOCK_EXCL);
 
@@ -640,7 +640,7 @@ xfs_setattr_nonsize(
 						NULL, capable(CAP_FOWNER) ?
 						XFS_QMOPT_FORCE_RES : 0);
 			if (error)	/* out of quota */
-				goto out_trans_cancel;
+				goto out_unlock;
 		}
 	}
 
@@ -729,10 +729,10 @@ xfs_setattr_nonsize(
 
 	return 0;
 
+out_unlock:
+	xfs_iunlock(ip, XFS_ILOCK_EXCL);
 out_trans_cancel:
 	xfs_trans_cancel(tp);
-	xfs_iunlock(ip, XFS_ILOCK_EXCL);
-out_dqrele:
 	xfs_qm_dqrele(udqp);
 	xfs_qm_dqrele(gdqp);
 	return error;

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
