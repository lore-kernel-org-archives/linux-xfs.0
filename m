Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 3766E7CBE
	for <xfs@oss.sgi.com>; Fri, 26 Apr 2013 14:17:00 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id AB603AC004
	for <xfs@oss.sgi.com>; Fri, 26 Apr 2013 12:16:56 -0700 (PDT)
Received: from dkim1.fusionio.com (dkim1.fusionio.com [66.114.96.53]) by
	cuda.sgi.com with ESMTP id hUud3O0QfC0BckuC (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 26 Apr 2013 12:16:55 -0700 (PDT)
Received: from mx1.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id A01C07C067C
	for <xfs@oss.sgi.com>; Fri, 26 Apr 2013 13:16:55 -0600 (MDT)
From: Josef Bacik <jbacik@fusionio.com>
Subject: [PATCH] [PATCH] xfstests: use -F when making scratch ext4 fs
Date: Fri, 26 Apr 2013 15:16:53 -0400
Message-ID: <1367003813-17686-1-git-send-email-jbacik@fusionio.com>
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
To: linux-ext4@vger.kernel.org, xfs@oss.sgi.com

mkfs.ext4 will ask you if you are sure if you try to mkfs an entire disk instead
of just a partition, so any xfstest that uses a scratch device and you specify a
full disk will appear to hang because it's waiting for you to say yes.  This
fixes the problem by just forcing it to do its thing.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fusionio.com>
---
 common/rc |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/common/rc b/common/rc
index ff18cc2..9d1c3fc 100644
--- a/common/rc
+++ b/common/rc
@@ -485,7 +485,7 @@ _scratch_mkfs_ext4()
 {
 	local tmp_dir=/tmp/
 
-	/sbin/mkfs -t $FSTYP -- $MKFS_OPTIONS $* $SCRATCH_DEV \
+	/sbin/mkfs -t $FSTYP -- -F $MKFS_OPTIONS $* $SCRATCH_DEV \
 			2>$tmp_dir.mkfserr 1>$tmp_dir.mkfsstd
 	local mkfs_status=$?
 
-- 
1.7.7.6

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
