Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o6F0Zs8w173180 for <xfs@oss.sgi.com>; Wed, 14 Jul 2010 19:35:54 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E6B644478B4
	for <xfs@oss.sgi.com>; Wed, 14 Jul 2010 17:38:49 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail13.adl6.internode.on.net
	[150.101.137.98]) by cuda.sgi.com with ESMTP id
	ZH7ewUouIzZ8nmwy for <xfs@oss.sgi.com>;
	Wed, 14 Jul 2010 17:38:49 -0700 (PDT)
Received: from dastard (unverified [121.44.38.238])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	31611919-1927428
	for <xfs@oss.sgi.com>; Thu, 15 Jul 2010 10:08:48 +0930 (CST)
Received: from disturbed ([192.168.1.9]) by dastard with esmtp (Exim 4.71)
	(envelope-from <dave@fromorbit.com>) id 1OZCTP-0002zJ-SZ
	for xfs@oss.sgi.com; Thu, 15 Jul 2010 10:38:47 +1000
Received: from dave by disturbed with local (Exim 4.71)
	(envelope-from <dave@disturbed.disaster>) id 1OZCTC-0000Xz-Cp
	for xfs@oss.sgi.com; Thu, 15 Jul 2010 10:38:34 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 4/5] xfs: use GFP_NOFS for page cache allocation
Date: Thu, 15 Jul 2010 10:38:19 +1000
Message-Id: <1279154300-2018-5-git-send-email-david@fromorbit.com>
In-Reply-To: <1279154300-2018-1-git-send-email-david@fromorbit.com>
References: <1279154300-2018-1-git-send-email-david@fromorbit.com>
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

From: Dave Chinner <dchinner@redhat.com>

Avoid a lockdep warning by preventing page cache allocation from
recursing back into the filesystem during memory reclaim.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/linux-2.6/xfs_aops.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_aops.c b/fs/xfs/linux-2.6/xfs_aops.c
index ed9c3db..1075791 100644
--- a/fs/xfs/linux-2.6/xfs_aops.c
+++ b/fs/xfs/linux-2.6/xfs_aops.c
@@ -1501,8 +1501,9 @@ xfs_vm_write_begin(
 	void			**fsdata)
 {
 	*pagep = NULL;
-	return block_write_begin(file, mapping, pos, len, flags, pagep, fsdata,
-								xfs_get_blocks);
+	return block_write_begin(file, mapping, pos, len,
+				 (flags | AOP_FLAG_NOFS),
+				 pagep, fsdata, xfs_get_blocks);
 }
 
 STATIC sector_t
-- 
1.7.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
