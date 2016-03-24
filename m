Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id BCA4D7CA7
	for <xfs@oss.sgi.com>; Thu, 24 Mar 2016 06:15:57 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 31512AC002
	for <xfs@oss.sgi.com>; Thu, 24 Mar 2016 04:15:57 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id UK32YIzI6vqmUNWq (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 24 Mar 2016 04:15:56 -0700 (PDT)
Received: from int-mx13.intmail.prod.int.phx2.redhat.com
	(int-mx13.intmail.prod.int.phx2.redhat.com [10.5.11.26])
	by mx1.redhat.com (Postfix) with ESMTPS id 732B5C00F5D6
	for <xfs@oss.sgi.com>; Thu, 24 Mar 2016 11:15:55 +0000 (UTC)
Received: from localhost.localdomain (vpn1-7-36.ams2.redhat.com [10.36.7.36])
	by int-mx13.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with
	ESMTP id u2OBFbLO009274
	for <xfs@oss.sgi.com>; Thu, 24 Mar 2016 07:15:54 -0400
From: jtulak@redhat.com
Subject: [PATCH 18/19] mkfs: unit conversions are case insensitive
Date: Thu, 24 Mar 2016 12:15:35 +0100
Message-Id: <1458818136-56043-19-git-send-email-jtulak@redhat.com>
In-Reply-To: <1458818136-56043-1-git-send-email-jtulak@redhat.com>
References: <1458818136-56043-1-git-send-email-jtulak@redhat.com>
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

From: Jan Tulak <jtulak@redhat.com>

Solves the question "Should I use 10g or 10G?"

Signed-off-by: Jan Tulak <jtulak@redhat.com>
---
 mkfs/xfs_mkfs.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 2bb3b35..680c6c4 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -3625,17 +3625,17 @@ cvtnum(
 	if (*sp == 's' && sp[1] == '\0')
 		return i * sectsize;
 
-	if (*sp == 'k' && sp[1] == '\0')
+	if ((*sp == 'k'  || *sp == 'K' ) && sp[1] == '\0')
 		return 1024LL * i;
-	if (*sp == 'm' && sp[1] == '\0')
+	if ((*sp == 'm'  || *sp == 'M' ) && sp[1] == '\0')
 		return 1024LL * 1024LL * i;
-	if (*sp == 'g' && sp[1] == '\0')
+	if ((*sp == 'g'  || *sp == 'G' ) && sp[1] == '\0')
 		return 1024LL * 1024LL * 1024LL * i;
-	if (*sp == 't' && sp[1] == '\0')
+	if ((*sp == 't'  || *sp == 'T' ) && sp[1] == '\0')
 		return 1024LL * 1024LL * 1024LL * 1024LL * i;
-	if (*sp == 'p' && sp[1] == '\0')
+	if ((*sp == 'p'  || *sp == 'P' ) && sp[1] == '\0')
 		return 1024LL * 1024LL * 1024LL * 1024LL * 1024LL * i;
-	if (*sp == 'e' && sp[1] == '\0')
+	if ((*sp == 'e'  || *sp == 'E' ) && sp[1] == '\0')
 		return 1024LL * 1024LL * 1024LL * 1024LL * 1024LL * 1024LL * i;
 	return -1LL;
 }
-- 
2.6.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
