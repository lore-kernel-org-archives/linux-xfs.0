Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id C0B0C7F85
	for <xfs@oss.sgi.com>; Sun, 29 Sep 2013 22:15:52 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 97EC2304059
	for <xfs@oss.sgi.com>; Sun, 29 Sep 2013 20:15:52 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	IPlNG0qGMkmdOLHe for <xfs@oss.sgi.com>;
	Sun, 29 Sep 2013 20:15:51 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1VQTxZ-0006Oi-Rw
	for xfs@oss.sgi.com; Mon, 30 Sep 2013 13:15:45 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1VQTxZ-0002FA-RD
	for xfs@oss.sgi.com; Mon, 30 Sep 2013 13:15:45 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 02/32] libxfs: fix missing filetype updates to xfs_dir2.c
Date: Mon, 30 Sep 2013 13:15:14 +1000
Message-Id: <1380510944-8571-3-git-send-email-david@fromorbit.com>
In-Reply-To: <1380510944-8571-1-git-send-email-david@fromorbit.com>
References: <1380510944-8571-1-git-send-email-david@fromorbit.com>
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

From: Dave Chinner <dchinner@redhat.com>

They were missed in the original patch that was committed.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 libxfs/xfs_dir2.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/libxfs/xfs_dir2.c b/libxfs/xfs_dir2.c
index 010c701..96a3c1d 100644
--- a/libxfs/xfs_dir2.c
+++ b/libxfs/xfs_dir2.c
@@ -194,6 +194,7 @@ xfs_dir_createname(
 	memset(&args, 0, sizeof(xfs_da_args_t));
 	args.name = name->name;
 	args.namelen = name->len;
+	args.filetype = name->type;
 	args.hashval = dp->i_mount->m_dirnameops->hashname(name);
 	args.inumber = inum;
 	args.dp = dp;
@@ -268,6 +269,7 @@ xfs_dir_lookup(
 	memset(&args, 0, sizeof(xfs_da_args_t));
 	args.name = name->name;
 	args.namelen = name->len;
+	args.filetype = name->type;
 	args.hashval = dp->i_mount->m_dirnameops->hashname(name);
 	args.dp = dp;
 	args.whichfork = XFS_DATA_FORK;
@@ -323,6 +325,7 @@ xfs_dir_removename(
 	memset(&args, 0, sizeof(xfs_da_args_t));
 	args.name = name->name;
 	args.namelen = name->len;
+	args.filetype = name->type;
 	args.hashval = dp->i_mount->m_dirnameops->hashname(name);
 	args.inumber = ino;
 	args.dp = dp;
-- 
1.8.3.2

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
