Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 6E0447F3F
	for <xfs@oss.sgi.com>; Fri, 18 Oct 2013 17:09:21 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 796CB304081
	for <xfs@oss.sgi.com>; Fri, 18 Oct 2013 15:09:09 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id YU8N60XQBJMCFRr9 for
	<xfs@oss.sgi.com>; Fri, 18 Oct 2013 15:09:08 -0700 (PDT)
Received: from int-mx09.intmail.prod.int.phx2.redhat.com
	(int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r9IM988a009399
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Fri, 18 Oct 2013 18:09:08 -0400
Received: from Liberator.local (ovpn01.gateway.prod.ext.phx2.redhat.com
	[10.5.9.1])
	by int-mx09.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id r9IM97qY022964
	(version=TLSv1/SSLv3 cipher=DHE-RSA-CAMELLIA256-SHA bits=256 verify=NO)
	for <xfs@oss.sgi.com>; Fri, 18 Oct 2013 18:09:08 -0400
Message-ID: <5261B183.7040309@redhat.com>
Date: Fri, 18 Oct 2013 17:09:07 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
Subject: [PATCH 1/2] xfs_fsr: extra debugging info
References: <5261B11F.1040000@redhat.com>
In-Reply-To: <5261B11F.1040000@redhat.com>
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

Provide 2 new pieces of information when -d is specified to
xfs_fsr:

* If we needed to grow the forkoffset and couldn't
* If we were unable to match the fork offset

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/fsr/xfs_fsr.c b/fsr/xfs_fsr.c
index 7596834..c949f07 100644
--- a/fsr/xfs_fsr.c
+++ b/fsr/xfs_fsr.c
@@ -1022,6 +1022,7 @@ fsr_setup_attr_fork(
 {
 	struct stat64	tstatbuf;
 	int		i;
+	int		diff = 0;
 	int		last_forkoff = 0;
 	int		no_change_cnt = 0;
 	int		ret;
@@ -1057,7 +1058,6 @@ fsr_setup_attr_fork(
 		xfs_bstat_t	tbstat;
 		xfs_ino_t	ino;
 		char		name[64];
-		int		diff;
 
 		/*
 		 * bulkstat the temp inode  to see what the forkoff is. Use
@@ -1123,6 +1123,8 @@ fsr_setup_attr_fork(
 			 * non-contiguous offsets.
 			 */
 			/* XXX: unimplemented! */
+			if (dflag)
+				printf(_("data fork growth unimplemented\n"));
 			goto out;
 		}
 
@@ -1138,6 +1140,10 @@ fsr_setup_attr_fork(
 out:
 	if (dflag)
 		fsrprintf(_("set temp attr\n"));
+	/* We failed to resolve the fork difference */
+	if (dflag && diff)
+		fsrprintf(_("failed to match fork offset\n"));;
+
 	return 0;
 }
 


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
