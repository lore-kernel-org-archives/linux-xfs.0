Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id BA5997F5F
	for <xfs@oss.sgi.com>; Thu, 10 Oct 2013 10:51:51 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 48E9BAC006
	for <xfs@oss.sgi.com>; Thu, 10 Oct 2013 08:51:51 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 9aeWbiSG3eMmIzEi for
	<xfs@oss.sgi.com>; Thu, 10 Oct 2013 08:51:50 -0700 (PDT)
Received: from int-mx02.intmail.prod.int.phx2.redhat.com
	(int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r9AFpnoA015928
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Thu, 10 Oct 2013 11:51:50 -0400
Received: from bfoster.bfoster ([10.18.41.237])
	by int-mx02.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id r9AFpn5m006412
	for <xfs@oss.sgi.com>; Thu, 10 Oct 2013 11:51:49 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH 12/12] xfsprogs/repair: account for finobt in ag 0 geometry
	pre-calculation
Date: Thu, 10 Oct 2013 11:51:12 -0400
Message-Id: <1381420272-13249-13-git-send-email-bfoster@redhat.com>
In-Reply-To: <1381420272-13249-1-git-send-email-bfoster@redhat.com>
References: <1381420272-13249-1-git-send-email-bfoster@redhat.com>
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
To: xfs@oss.sgi.com

Account for the finobt in calc_mkfs().

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 repair/xfs_repair.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/repair/xfs_repair.c b/repair/xfs_repair.c
index 820e7a2..b14d805 100644
--- a/repair/xfs_repair.c
+++ b/repair/xfs_repair.c
@@ -405,6 +405,8 @@ calc_mkfs(xfs_mount_t *mp)
 	bcntbt_root = bnobt_root + 1;
 	inobt_root = bnobt_root + 2;
 	fino_bno = inobt_root + XFS_MIN_FREELIST_RAW(1, 1, mp) + 1;
+	if (xfs_sb_version_hasfinobt(&mp->m_sb))
+		fino_bno++;
 
 	/*
 	 * If the log is allocated in the first allocation group we need to
-- 
1.8.1.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
