Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:40382 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S965927AbeE2UkQ (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 29 May 2018 16:40:16 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id E5D609EC8A
        for <linux-xfs@vger.kernel.org>; Tue, 29 May 2018 20:40:15 +0000 (UTC)
Received: from [IPv6:::1] (ovpn04.gateway.prod.ext.phx2.redhat.com [10.5.9.4])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 710E0600C2
        for <linux-xfs@vger.kernel.org>; Tue, 29 May 2018 20:40:15 +0000 (UTC)
From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] xfs_repair: fix libxfs api violations in quota repair code
Message-ID: <6aeb5192-00b5-175d-fa3d-7864a2ba2d27@redhat.com>
Date: Tue, 29 May 2018 15:40:14 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs <linux-xfs@vger.kernel.org>

My "repair quotas" patch forgot about our libxfs API tricks,
fix that.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/libxfs/libxfs_api_defs.h b/libxfs/libxfs_api_defs.h
index 56f9f8c..63bf27e 100644
--- a/libxfs/libxfs_api_defs.h
+++ b/libxfs/libxfs_api_defs.h
@@ -126,6 +126,10 @@
  #define xfs_sb_quota_from_disk		libxfs_sb_quota_from_disk
  #define xfs_sb_to_disk			libxfs_sb_to_disk
  
+#define xfs_calc_dquots_per_chunk	libxfs_calc_dquots_per_chunk
+#define xfs_dquot_verify		libxfs_dquot_verify
+#define xfs_dquot_repair		libxfs_dquot_repair
+
  #define xfs_symlink_blocks		libxfs_symlink_blocks
  #define xfs_symlink_hdr_ok		libxfs_symlink_hdr_ok
  
diff --git a/repair/dinode.c b/repair/dinode.c
index e8edcd4..49d5d05 100644
--- a/repair/dinode.c
+++ b/repair/dinode.c
@@ -1345,7 +1345,7 @@ process_quota_inode(
  	}
  
  	dqchunklen = XFS_FSB_TO_BB(mp, XFS_DQUOT_CLUSTER_SIZE_FSB);
-	dqperchunk = xfs_calc_dquots_per_chunk(dqchunklen);
+	dqperchunk = libxfs_calc_dquots_per_chunk(dqchunklen);
  	dqid = 0;
  	qbno = NULLFILEOFF;
  
@@ -1367,12 +1367,12 @@ _("cannot read inode %" PRIu64 ", file block %" PRIu64 ", disk block %" PRIu64 "
  
  		dqb = bp->b_addr;
  		for (i = 0; i < dqperchunk; i++, dqid++, dqb++) {
-			xfs_failaddr_t	fa;
  			int		bad_dqb = 0;
  
  			/* We only print the first problem we find */
  			if (xfs_sb_version_hascrc(&mp->m_sb)) {
-				if (!xfs_verify_cksum((char *)dqb, sizeof(*dqb),
+				if (!libxfs_verify_cksum((char *)dqb,
+							sizeof(*dqb),
  							XFS_DQUOT_CRC_OFF)) {
  					do_warn(_("%s: bad CRC for id %u. "),
  							quota_string, dqid);
@@ -1388,8 +1388,8 @@ _("cannot read inode %" PRIu64 ", file block %" PRIu64 ", disk block %" PRIu64 "
  					goto bad;
  				}
  			}
-			fa = xfs_dquot_verify(mp, &dqb->dd_diskdq, dqid, quota_type, 0);
-			if (fa) {
+			if (libxfs_dquot_verify(mp, &dqb->dd_diskdq, dqid,
+						quota_type, 0) != NULL) {
  				do_warn(_("%s: Corrupt quota for id %u. "),
  						quota_string, dqid);
  				bad_dqb = 1;
@@ -1401,7 +1401,8 @@ bad:
  					do_warn(_("Would correct.\n"));
  				else {
  					do_warn(_("Corrected.\n"));
-					xfs_dquot_repair(mp, &dqb->dd_diskdq, dqid, quota_type);
+					libxfs_dquot_repair(mp, &dqb->dd_diskdq,
+							    dqid, quota_type);
  					writebuf = 1;
  				}
  			}

