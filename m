Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id F282A7CA0
	for <xfs@oss.sgi.com>; Wed, 11 May 2016 21:41:16 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 8442FAC001
	for <xfs@oss.sgi.com>; Wed, 11 May 2016 19:41:16 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id cWyjq45MsdTcYDn5 for <xfs@oss.sgi.com>;
	Wed, 11 May 2016 19:41:13 -0700 (PDT)
From: Eric Sandeen <sandeen@sandeen.net>
Subject: [PATCH] xfs_quota: check report_mount return value
Message-ID: <1e8b9ace-2fa3-bc11-4487-19be60053ef9@sandeen.net>
Date: Wed, 11 May 2016 21:41:12 -0500
MIME-Version: 1.0
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
Cc: Zorro Lang <zlang@redhat.com>

The new call to report_mount doesn't check the return value
like every other caller does...

Returning 1 means it printed something; if the terse flag
is used and there is no usage, nothing gets printed.
If we set the NO_HEADER_FLAG anyway, then we won't see
the header for subsequent entries as we expect.

For example, project ID 0 has no usage in this case:

# xfs_quota -x -c "report -a" /mnt/test
Project quota on /mnt/test (/dev/sdb1)
                               Blocks                     
Project ID       Used       Soft       Hard    Warn/Grace     
---------- -------------------------------------------------- 
#0                  0          0          0     00 [--------]
project          2048          4          4     00 [--none--]

So using the terse flag results in no header when it prints
projects with usage:

# xfs_quota -x -c "report -t -a" /mnt/test
project          2048          4          4     00 [--none--]

With this fix it prints the header as expected:

# xfs_quota -x -c "report -t -a" /mnt/test
Project quota on /mnt/test (/dev/sdb1)
                               Blocks                     
Project ID       Used       Soft       Hard    Warn/Grace     
---------- -------------------------------------------------- 
project          2048          4          4     00 [--none--]


Addresses-Coverity-Id: 1361552
Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/quota/report.c b/quota/report.c
index cc422d1..59290e1 100644
--- a/quota/report.c
+++ b/quota/report.c
@@ -580,9 +580,9 @@ report_project_mount(
 			 * Print default project quota, even if projid 0
 			 * isn't defined
 			 */
-			report_mount(fp, 0, NULL, NULL, form, XFS_PROJ_QUOTA,
-			             mount, flags);
-			flags |= NO_HEADER_FLAG;
+			if (report_mount(fp, 0, NULL, NULL,
+					form, XFS_PROJ_QUOTA, mount, flags))
+				flags |= NO_HEADER_FLAG;
 		}
 
 		setprent();

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
