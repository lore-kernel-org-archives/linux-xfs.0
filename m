Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 4739E7F54
	for <xfs@oss.sgi.com>; Sat,  1 Mar 2014 07:47:13 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id D944FAC008
	for <xfs@oss.sgi.com>; Sat,  1 Mar 2014 05:47:09 -0800 (PST)
Received: from a.painless.aa.net.uk (a.painless.aa.net.uk [81.187.30.51]) by
	cuda.sgi.com with ESMTP id FpeKFdgYZHn3rTBI (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Sat, 01 Mar 2014 05:47:07 -0800 (PST)
From: Andrew Clayton <andrew@digital-domain.net>
Subject: [PATCH] man: xfs_repair.8: Fix a grammatical error
Date: Sat,  1 Mar 2014 13:46:40 +0000
Message-Id: <1393681600-13098-1-git-send-email-andrew@digital-domain.net>
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
Cc: Andrew Clayton <andrew@digital-domain.net>

Fix an issue in the -o force_geometry suboption text.

Signed-off-by: Andrew Clayton <andrew@digital-domain.net>
---
 man/man8/xfs_repair.8 | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/man/man8/xfs_repair.8 b/man/man8/xfs_repair.8
index ed20fb7..b7c2d8c 100644
--- a/man/man8/xfs_repair.8
+++ b/man/man8/xfs_repair.8
@@ -144,7 +144,7 @@ reduce repair times on concat based filesystems.
 .BI force_geometry
 Check the filesystem even if geometry information could not be validated.
 Geometry information can not be validated if only a single allocation
-group and exist and thus we do not have a backup superblock available, or
+group exists and thus we do not have a backup superblock available, or
 if there are two allocation groups and the two superblocks do not
 agree on the filesystem geometry.  Only use this option if you validated
 the geometry yourself and know what you are doing.  If In doubt run
-- 
1.8.5.3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
