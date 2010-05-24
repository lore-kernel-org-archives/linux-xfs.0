Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o4OECFhl183217 for <xfs@oss.sgi.com>; Mon, 24 May 2010 09:12:16 -0500
Received: from mx2.suse.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id CB90A369D36
	for <xfs@oss.sgi.com>; Mon, 24 May 2010 07:14:37 -0700 (PDT)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id gAbtavk5QeMCcs02 for <xfs@oss.sgi.com>;
	Mon, 24 May 2010 07:14:37 -0700 (PDT)
From: Jan Kara <jack@suse.cz>
Subject: [PATCH 1/8] Fix test whether kernel supports quotas
Date: Mon, 24 May 2010 16:14:12 +0200
Message-Id: <1274710459-11446-2-git-send-email-jack@suse.cz>
In-Reply-To: <1274710459-11446-1-git-send-email-jack@suse.cz>
References: <1274710459-11446-1-git-send-email-jack@suse.cz>
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
 common.quota |    9 +++++----
 1 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/common.quota b/common.quota
index 51bdc71..d32e285 100644
--- a/common.quota
+++ b/common.quota
@@ -27,10 +27,11 @@
 _require_quota()
 {
     [ -x /usr/bin/quota ] || _notrun "Quota user tools not installed"
-    _scratch_mount "-o usrquota,grpquota"
-    ret=$?
-    umount $SCRATCH_MNT
-    [ $ret -ne 0 ] && _notrun "Installed kernel does not support quota"
+    if [ $FSTYP = "xfs" ]; then
+	[ -f /proc/fs/xfs/xqmstat ] || _notrun "Installed kernel does not support XFS quota"
+    elif [ $FSTYP != "gfs2" ]; then
+	[ -d /proc/sys/fs/quota ] || _notrun "Installed kernel does not support quota"
+    fi
 }
 
 #
-- 
1.6.4.2

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
