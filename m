Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 81DE829E06
	for <xfs@oss.sgi.com>; Fri, 17 Jan 2014 14:51:14 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 14CCEAC003
	for <xfs@oss.sgi.com>; Fri, 17 Jan 2014 12:51:13 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id vnL2HOPDnRav1ySa for
	<xfs@oss.sgi.com>; Fri, 17 Jan 2014 12:51:13 -0800 (PST)
Received: from int-mx10.intmail.prod.int.phx2.redhat.com
	(int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id s0HKpAVP018953
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Fri, 17 Jan 2014 15:51:11 -0500
Received: from liberator.sandeen.net (ovpn01.gateway.prod.ext.phx2.redhat.com
	[10.5.9.1])
	by int-mx10.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id s0HKp99b021195
	(version=TLSv1/SSLv3 cipher=DHE-RSA-CAMELLIA256-SHA bits=256 verify=NO)
	for <xfs@oss.sgi.com>; Fri, 17 Jan 2014 15:51:10 -0500
Message-ID: <52D997BD.1090701@redhat.com>
Date: Fri, 17 Jan 2014 14:51:09 -0600
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
Subject: [PATCH] xfs: remove unused tr_swrite
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

tr_swrite is never used, remove it.

>From a very quick look, I think the usage of it (and its ancestor
XFS_SWRITE_LOG_RES) went away in commit 13e6d5cd "xfs: merge fsync
and O_SYNC handling" back in 2009.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/fs/xfs/xfs_trans_resv.c b/fs/xfs/xfs_trans_resv.c
index 2fd59c0..445e171 100644
--- a/fs/xfs/xfs_trans_resv.c
+++ b/fs/xfs/xfs_trans_resv.c
@@ -784,7 +784,6 @@ xfs_trans_resv_calc(
 	/* The following transaction are logged in logical format */
 	resp->tr_ichange.tr_logres = xfs_calc_ichange_reservation(mp);
 	resp->tr_growdata.tr_logres = xfs_calc_growdata_reservation(mp);
-	resp->tr_swrite.tr_logres = xfs_calc_swrite_reservation(mp);
 	resp->tr_fsyncts.tr_logres = xfs_calc_swrite_reservation(mp);
 	resp->tr_writeid.tr_logres = xfs_calc_writeid_reservation(mp);
 	resp->tr_attrsetrt.tr_logres = xfs_calc_attrsetrt_reservation(mp);
diff --git a/fs/xfs/xfs_trans_resv.h b/fs/xfs/xfs_trans_resv.h
index de7de9a..f76c129 100644
--- a/fs/xfs/xfs_trans_resv.h
+++ b/fs/xfs/xfs_trans_resv.h
@@ -42,7 +42,6 @@ struct xfs_trans_resv {
 	struct xfs_trans_res	tr_ifree;	/* inode free trans */
 	struct xfs_trans_res	tr_ichange;	/* inode update trans */
 	struct xfs_trans_res	tr_growdata;	/* fs data section grow trans */
-	struct xfs_trans_res	tr_swrite;	/* sync write inode trans */
 	struct xfs_trans_res	tr_addafork;	/* add inode attr fork trans */
 	struct xfs_trans_res	tr_writeid;	/* write setuid/setgid file */
 	struct xfs_trans_res	tr_attrinval;	/* attr fork buffer

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
