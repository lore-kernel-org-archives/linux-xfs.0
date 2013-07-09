Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 10CD07F5A
	for <xfs@oss.sgi.com>; Tue,  9 Jul 2013 14:07:37 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id E8022304082
	for <xfs@oss.sgi.com>; Tue,  9 Jul 2013 12:07:33 -0700 (PDT)
Received: from dkim1.fusionio.com (dkim1.fusionio.com [66.114.96.53]) by
	cuda.sgi.com with ESMTP id 46josX8AUpd6D66C (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 09 Jul 2013 12:07:30 -0700 (PDT)
Received: from mx1.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id C1FED7C0417
	for <xfs@oss.sgi.com>; Tue,  9 Jul 2013 13:07:29 -0600 (MDT)
From: Josef Bacik <jbacik@fusionio.com>
Subject: [PATCH] xfstests: exit out if _scratch_mount fails
Date: Tue, 9 Jul 2013 15:07:27 -0400
Message-ID: <1373396847-7975-1-git-send-email-jbacik@fusionio.com>
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
To: xfs@oss.sgi.com, linxu-btrfs@vger.kernel.org

I test some of the different mkfs options for btrfs, one set doesn't work
properly with small file systems, so the fs won't mount.  This is fine from a
btrfs point of view, but tests that fail to mount the scratch fs will run
anyway, so if it's a "fill the fs" sort of test this will wreak havoc.  To fix
this just error out of _scratch_mount fails.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fusionio.com>
---
 common/rc |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/common/rc b/common/rc
index 4de1329..f11699f 100644
--- a/common/rc
+++ b/common/rc
@@ -276,6 +276,10 @@ _scratch_mount_options()
 _scratch_mount()
 {
     _mount -t $FSTYP `_scratch_mount_options $*`
+    if [ $? -ne 0 ]; then
+	echo "mount failed"
+	exit 1
+    fi
 }
 
 _scratch_unmount()
-- 
1.7.7.6

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
