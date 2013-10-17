Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 1BAEF7F4E
	for <xfs@oss.sgi.com>; Thu, 17 Oct 2013 10:43:13 -0500 (CDT)
Received: from eagdhcp-232-150.americas.sgi.com
	(eagdhcp-232-150.americas.sgi.com [128.162.232.150])
	by relay1.corp.sgi.com (Postfix) with ESMTP id EB7B28F8065
	for <xfs@oss.sgi.com>; Thu, 17 Oct 2013 08:43:09 -0700 (PDT)
Received: from eagdhcp-232-150.americas.sgi.com (localhost [127.0.0.1])
	by eagdhcp-232-150.americas.sgi.com (8.14.5/8.14.5) with ESMTP id
	r9HFhAFj002751
	for <xfs@oss.sgi.com>; Thu, 17 Oct 2013 10:43:10 -0500 (CDT)
	(envelope-from tinguely@eagdhcp-232-150.americas.sgi.com)
Message-Id: <20131017152955.604007124@sgi.com>
Date: Thu, 17 Oct 2013 10:28:07 -0500
From: Mark Tinguely <tinguely@sgi.com>
Subject: [PATCH v3 3/4] xfs_progs: add dirent filetype to xfs_db version
References: <20131017152804.204045257@sgi.com>
Content-Disposition: inline;
	filename=3-4-xfsprog-add-ftype-to-version-in-xfs_db.patch
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

Add directory inode type to the xfs_db version command.

Signed-off-by: Mark Tinguely <tinguely@sgi.com>
---
new to v3

 db/sb.c |    2 ++
 1 file changed, 2 insertions(+)

Index: b/db/sb.c
===================================================================
--- a/db/sb.c
+++ b/db/sb.c
@@ -644,6 +644,8 @@ version_string(
 		strcat(s, ",PROJID32BIT");
 	if (xfs_sb_version_hascrc(sbp))
 		strcat(s, ",CRC");
+	if (xfs_sb_version_hasftype(sbp))
+		strcat(s, ",FTYPE");
 	return s;
 }
 


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
