Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id B23DE7F3F
	for <xfs@oss.sgi.com>; Thu, 24 Jul 2014 13:51:13 -0500 (CDT)
Received: from eagdhcp-232-188.americas.sgi.com
	(eagdhcp-232-188.americas.sgi.com [128.162.232.188])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 30BF0AC00A
	for <xfs@oss.sgi.com>; Thu, 24 Jul 2014 11:51:13 -0700 (PDT)
Received: from eagdhcp-232-188.americas.sgi.com (localhost [127.0.0.1])
	by eagdhcp-232-188.americas.sgi.com (8.14.5/8.14.5) with ESMTP id
	s6OIpBYT003327
	for <xfs@oss.sgi.com>; Thu, 24 Jul 2014 13:51:11 -0500 (CDT)
	(envelope-from tinguely@eagdhcp-232-188.americas.sgi.com)
Message-Id: <20140724184830.434943824@sgi.com>
Date: Thu, 24 Jul 2014 13:47:49 -0500
From: Mark Tinguely <tinguely@sgi.com>
Subject: [PATCH] xfsprogs: fix typo in mkfs.xfs
References: <20140724184748.800975529@sgi.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="===============3521655532431046858=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

--===============3521655532431046858==
Content-Disposition: inline; filename=xfsprogs-fix-topology-typo.patch

Fix typo in xfs.mkfs output.

Signed-off-by: Mark Tinguely <tinguely@sgi.com>
---
 mkfs/xfs_mkfs.c |    2 +-
 po/pl.po        |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

Index: b/mkfs/xfs_mkfs.c
===================================================================
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -447,7 +447,7 @@ static void blkid_get_topology(
 out_free_probe:
 	blkid_free_probe(pr);
 	fprintf(stderr,
-		_("warning: unable to probe device toplology for device %s\n"),
+		_("warning: unable to probe device topology for device %s\n"),
 		device);
 }
 
Index: b/po/pl.po
===================================================================
--- a/po/pl.po
+++ b/po/pl.po
@@ -7171,7 +7171,7 @@ msgstr "Można użyć -f do wymuszenia u
 
 #: .././mkfs/xfs_mkfs.c:450
 #, c-format
-msgid "warning: unable to probe device toplology for device %s\n"
+msgid "warning: unable to probe device topology for device %s\n"
 msgstr "uwaga: nie udało się odczytać topologii urządzenia %s\n"
 
 #: .././mkfs/xfs_mkfs.c:578



--===============3521655532431046858==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============3521655532431046858==--
