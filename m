Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 1E22C7F37
	for <linux-xfs@oss.sgi.com>; Tue, 17 Sep 2013 11:57:02 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 0AFBD304048
	for <linux-xfs@oss.sgi.com>; Tue, 17 Sep 2013 09:57:01 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id MkUem6TXRVRCgR1l for
	<linux-xfs@oss.sgi.com>; Tue, 17 Sep 2013 09:57:01 -0700 (PDT)
Received: from int-mx02.intmail.prod.int.phx2.redhat.com
	(int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r8HGv0N5020213
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-xfs@oss.sgi.com>; Tue, 17 Sep 2013 12:57:00 -0400
Received: from Liberator.local (ovpn01.gateway.prod.ext.phx2.redhat.com
	[10.5.9.1])
	by int-mx02.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id r8HGuxoJ014756
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-xfs@oss.sgi.com>; Tue, 17 Sep 2013 12:57:00 -0400
Message-ID: <523889DB.1000001@redhat.com>
Date: Tue, 17 Sep 2013 11:56:59 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
Subject: [PATCH] xfsprogs: initialize filetype for xfs_name_dot
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
To: "'linux-xfs@oss.sgi.com'" <linux-xfs@oss.sgi.com>

If we add the '.' entry in repair, make sure it has a file type
initialized.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/repair/phase6.c b/repair/phase6.c
index a4ad7a3..580dbf7 100644
--- a/repair/phase6.c
+++ b/repair/phase6.c
@@ -34,7 +34,9 @@ static struct cred		zerocr;
 static struct fsxattr 		zerofsx;
 static xfs_ino_t		orphanage_ino;
 
-static struct xfs_name		xfs_name_dot = {(unsigned char *)".", 1};
+static struct xfs_name		xfs_name_dot = {(unsigned char *)".",
+						1,
+						XFS_DIR3_FT_DIR};
 
 /*
  * Data structures used to keep track of directories where the ".."

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
