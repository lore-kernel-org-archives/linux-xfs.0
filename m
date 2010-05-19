Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o4JDa6Jv131886 for <xfs@oss.sgi.com>; Wed, 19 May 2010 08:36:06 -0500
Received: from mx1.suse.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 458221DF3500
	for <xfs@oss.sgi.com>; Wed, 19 May 2010 06:38:24 -0700 (PDT)
Received: from mx1.suse.de (cantor.suse.de [195.135.220.2]) by cuda.sgi.com
	with ESMTP id RBLivk6etzTFGTAZ for <xfs@oss.sgi.com>;
	Wed, 19 May 2010 06:38:24 -0700 (PDT)
From: Jan Kara <jack@suse.cz>
Subject: [PATCH 2/7] Fix test whether kernel supports quotas
Date: Wed, 19 May 2010 15:38:04 +0200
Message-Id: <1274276289-8839-3-git-send-email-jack@suse.cz>
In-Reply-To: <1274276289-8839-1-git-send-email-jack@suse.cz>
References: <1274276289-8839-1-git-send-email-jack@suse.cz>
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
Cc: hch@infradead.org, Jan Kara <jack@suse.cz>

For all 2.6 kernels presence of quota support in kernel can be detected by
checking /proc/sys/fs/quota. This is actually more reliable than trying to
mount a filesystem with quota options (for example because SCRATCH_DEV does
not have to contain a filesystem type we are going to test).

Signed-off-by: Jan Kara <jack@suse.cz>
---
 common.quota |    5 +----
 1 files changed, 1 insertions(+), 4 deletions(-)

diff --git a/common.quota b/common.quota
index 51bdc71..033390f 100644
--- a/common.quota
+++ b/common.quota
@@ -27,10 +27,7 @@
 _require_quota()
 {
     [ -x /usr/bin/quota ] || _notrun "Quota user tools not installed"
-    _scratch_mount "-o usrquota,grpquota"
-    ret=$?
-    umount $SCRATCH_MNT
-    [ $ret -ne 0 ] && _notrun "Installed kernel does not support quota"
+    [ -d /proc/sys/fs/quota ] || _notrun "Installed kernel does not support quota"
 }
 
 #
-- 
1.6.4.2

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
