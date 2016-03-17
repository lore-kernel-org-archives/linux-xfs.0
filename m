Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 4F68E7CA4
	for <xfs@oss.sgi.com>; Wed, 16 Mar 2016 23:28:39 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 1281B8F804B
	for <xfs@oss.sgi.com>; Wed, 16 Mar 2016 21:28:36 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id vJ9IxrMjHLv5Bdny (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 16 Mar 2016 21:28:34 -0700 (PDT)
From: Eryu Guan <eguan@redhat.com>
Subject: [PATCH] common: filter out all metadata related options not only crc
Date: Thu, 17 Mar 2016 12:28:12 +0800
Message-Id: <1458188892-14905-1-git-send-email-eguan@redhat.com>
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
To: fstests@vger.kernel.org
Cc: Eryu Guan <eguan@redhat.com>, xfs@oss.sgi.com

Remove all metadata related mkfs options in _scratch_mkfs_xfs_opts() if
mkfs.xfs has no metadata support, not only the crc option.

Signed-off-by: Eryu Guan <eguan@redhat.com>
---
 common/rc | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/common/rc b/common/rc
index a34c387..38d3189 100644
--- a/common/rc
+++ b/common/rc
@@ -444,9 +444,9 @@ _scratch_mkfs_xfs_opts()
 {
 	mkfs_opts=$*
 
-	# remove crc related mkfs options if mkfs.xfs doesn't support v5 xfs
+	# remove metadata related mkfs options if mkfs.xfs doesn't support them
 	if [ -n "$XFS_MKFS_HAS_NO_META_SUPPORT" ]; then
-		mkfs_opts=`echo $mkfs_opts | sed "s/-m\s\+crc=.//"`
+		mkfs_opts=`echo $mkfs_opts | sed "s/-m\s\+\S\+//g"`
 	fi
 
 	_scratch_options mkfs
-- 
2.5.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
