Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o3J9etBR206365 for <xfs@oss.sgi.com>; Mon, 19 Apr 2010 04:40:55 -0500
Received: from acsinet12.oracle.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 344691D436DD
	for <xfs@oss.sgi.com>; Mon, 19 Apr 2010 02:42:53 -0700 (PDT)
Received: from acsinet12.oracle.com (acsinet12.oracle.com [141.146.126.234])
	by cuda.sgi.com with ESMTP id 9fDZurNKeZOFsX1m for
	<xfs@oss.sgi.com>; Mon, 19 Apr 2010 02:42:53 -0700 (PDT)
Received: from rcsinet13.oracle.com (rcsinet13.oracle.com [148.87.113.125])
	by acsinet12.oracle.com (Switch-3.4.2/Switch-3.4.2) with ESMTP id
	o3J9goej023088
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Mon, 19 Apr 2010 09:42:52 GMT
Received: from acsmt355.oracle.com (acsmt355.oracle.com [141.146.40.155])
	by rcsinet13.oracle.com (Switch-3.4.2/Switch-3.4.1) with ESMTP id
	o3J7aqh5003810 for <xfs@oss.sgi.com>; Mon, 19 Apr 2010 09:42:49 GMT
Message-Id: <201004190942.o3J7aqh5003810@rcsinet13.oracle.com>
Date: Mon, 19 Apr 2010 17:41:36 +0800
From: Wengang Wang <wen.gang.wang@oracle.com>
Subject: [PATCH] xfsprogs: mkfs: make strict check on -ialign option
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: greg.marsden@oracle.com, joe.jin@oracle.com, wen.gang.wang@oracle.com

Though it's clearly said in mkfs.xfs man page that for -ialign option only 1 or
0 are valid values, I would like to make a strict check on it in code.

If a user specified -ialign=y(but he meant -ialign=1 actually), mkfs treats "y"
as "0"(simply by atoi()) thus acts wrongly without complaint. I think we'd better
prevent that from happening, so I made the patch. The patch fails the operation
on values for -ialign option, like "yes", "no", "y", "n".

Signed-off-by: Wengang Wang <wen.gang.wang@oracle.com>
---
 mkfs/xfs_mkfs.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 2d09e36..d7e9eb3 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -1180,14 +1180,17 @@ main(
 			p = optarg;
 			while (*p != '\0') {
 				char	*value;
+				int len;
 
 				switch (getsubopt(&p, (constpp)iopts, &value)) {
 				case I_ALIGN:
 					if (!value)
 						value = "1";
-					iaflag = atoi(value);
-					if (iaflag < 0 || iaflag > 1)
+					len = strlen(value);
+					if (len != 1 || value[0] < '0' ||
+					    value[0] > '1')
 						illegal(value, "i align");
+					iaflag = value[0] - '0';
 					break;
 				case I_LOG:
 					if (!value)
-- 
1.6.6.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
