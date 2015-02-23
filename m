Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 838787F47
	for <xfs@oss.sgi.com>; Mon, 23 Feb 2015 13:15:51 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 70A72304059
	for <xfs@oss.sgi.com>; Mon, 23 Feb 2015 11:15:51 -0800 (PST)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id 020fi5qlzJCOYblm for <xfs@oss.sgi.com>;
	Mon, 23 Feb 2015 11:15:50 -0800 (PST)
Message-ID: <54EB7C65.3000307@sandeen.net>
Date: Mon, 23 Feb 2015 13:15:49 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH 1/2] xfs: log unmount events on console
References: <54EB7BDB.7080202@redhat.com>
In-Reply-To: <54EB7BDB.7080202@redhat.com>
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
To: Eric Sandeen <sandeen@redhat.com>, xfs-oss <xfs@oss.sgi.com>

There are times, when doing triage and forensics,
that we would like to know whether a filesystem was unmounted,
or if the plug was pulled without a clean unmount.  Log
unmounts at the same level (NOTICE) as we log mounts.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 8fcc4cc..dd40d25 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1039,6 +1039,7 @@ xfs_fs_put_super(
 {
 	struct xfs_mount	*mp = XFS_M(sb);
 
+	xfs_notice(mp, "Unmounting Filesystem");
 	xfs_filestream_unmount(mp);
 	xfs_unmountfs(mp);
 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
