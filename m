Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id D26407F60
	for <xfs@oss.sgi.com>; Wed, 16 Apr 2014 23:18:36 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 5828FAC001
	for <xfs@oss.sgi.com>; Wed, 16 Apr 2014 21:18:36 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id DpN25XdM9g341qNx for
	<xfs@oss.sgi.com>; Wed, 16 Apr 2014 21:18:35 -0700 (PDT)
Received: from int-mx02.intmail.prod.int.phx2.redhat.com
	(int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id s3H4IYTJ015831
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Thu, 17 Apr 2014 00:18:35 -0400
From: Eryu Guan <eguan@redhat.com>
Subject: [PATCH 3/3] generic/009: get the correct dev name when testing ext4
Date: Thu, 17 Apr 2014 12:16:54 +0800
Message-Id: <1397708214-8197-3-git-send-email-eguan@redhat.com>
In-Reply-To: <1397708214-8197-1-git-send-email-eguan@redhat.com>
References: <1397708214-8197-1-git-send-email-eguan@redhat.com>
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
Cc: Eryu Guan <eguan@redhat.com>

If TEST_DEV is a symlink(usually a lvm), we get the wrong DEV
name. Follow link and get the correct dev name.

Signed-off-by: Eryu Guan <eguan@redhat.com>
---
 tests/generic/009 | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tests/generic/009 b/tests/generic/009
index 1e487b4..7675c69 100644
--- a/tests/generic/009
+++ b/tests/generic/009
@@ -51,7 +51,7 @@ testfile=$TEST_DIR/009.$$
 
 # Disable extent zeroing for ext4 as that change where holes are created
 if [ "$FSTYP" = "ext4" ]; then
-	DEV=`basename $TEST_DEV`
+	DEV=`basename $(readlink -f $TEST_DEV)`
 	echo 0 >/sys/fs/ext4/$DEV/extent_max_zeroout_kb
 fi
 
-- 
1.9.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
