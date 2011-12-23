Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pBN6nf16205485 for <xfs@oss.sgi.com>; Fri, 23 Dec 2011 00:49:42 -0600
Received: from DB3EHSOBE006.bigfish.com (db3ehsobe006.messaging.microsoft.com
	[213.199.154.144]) by cuda.sgi.com with ESMTP id
	VpvUuhg7JDlpPr0Z for <xfs@oss.sgi.com>;
	Thu, 22 Dec 2011 22:49:39 -0800 (PST)
Received: from mail78-db3 (localhost [127.0.0.1])	by mail78-db3-R.bigfish.com
	(Postfix) with ESMTP id C95FA6A006D	for <xfs@oss.sgi.com>;
	Fri, 23 Dec 2011 06:50:05 +0000 (UTC)
Received: from DB3EHSMHS015.bigfish.com (unknown [10.3.81.246])	by
	mail78-db3.bigfish.com (Postfix) with ESMTP id B008C540058	for
	<xfs@oss.sgi.com>; Fri, 23 Dec 2011 06:50:05 +0000 (UTC)
From: <b19537@freescale.com>
Subject: [PATCH] xfsprogs: use uid/gid instead of actual name to fix install
	issue
Date: Fri, 23 Dec 2011 14:52:53 +0800
Message-ID: <1324623173-32707-1-git-send-email-b19537@freescale.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: Zhenhua Luo <b19537@freescale.com>

From: Zhenhua Luo <b19537@freescale.com>

    > when running install-sh during the install process, following
      error might appear:
	> ../../install-sh -o bj -g bj -m 644 -T so_dot_version libhandle.lai /lib; ../../install-sh -o bj -g bj -T so_dot_current libhandle.lai /lib
	> chown: invalid user: `bj:bj'
	> chown: invalid user: `bj:bj'
	> Installing libdisk-install
	> make[1]: Nothing to be done for `install'.
	> Installing copy-install
	> ../install-sh -o bj -g bj -m 755 -d /usr/sbin
	> chown: invalid user: `bj:bj'
	> make[1]: *** [install] Error 1
	> make: *** [copy-install] Error 2

Signed-off-by: Zhenhua Luo <b19537@freescale.com>
---
 include/install-sh |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/install-sh b/include/install-sh
index 18c051f..9d8ff06 100755
--- a/include/install-sh
+++ b/include/install-sh
@@ -105,10 +105,10 @@ do
    c)
 	;;
    g)
-	GROUP=$OPTARG
+	GROUP=`id -g $OPTARG`
 	;;
    o)
-	OWNER=$OPTARG
+	OWNER=`id -u $OPTARG`
 	;;
    m)
 	DIRMODE=`expr $OPTARG`
-- 
1.7.0.4


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
