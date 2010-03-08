Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o28HEPFd052479 for <xfs@oss.sgi.com>; Mon, 8 Mar 2010 11:14:25 -0600
Received: from mx1.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D89ED22454A
	for <xfs@oss.sgi.com>; Mon,  8 Mar 2010 09:15:54 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id r8ZxGsZnlqSPPjyb for
	<xfs@oss.sgi.com>; Mon, 08 Mar 2010 09:15:54 -0800 (PST)
Received: from int-mx03.intmail.prod.int.phx2.redhat.com
	(int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o28HFqcf016794
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Mon, 8 Mar 2010 12:15:52 -0500
Message-ID: <4B9530C5.30705@redhat.com>
Date: Mon, 08 Mar 2010 11:15:49 -0600
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
Subject: [PATCH] xfstests: avoid blkid cache with -c /dev/null not -p
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
To: xfs-oss <xfs@oss.sgi.com>
Cc: Lukas Czerner <lczerner@redhat.com>

From: Lukas Czerner <lczerner@redhat.com>

The addition of "-p" to blkid calls broke xfstests
on older systems where this was not supported.

Signed-off-by: Eric Sandeen <sandeen@sandeen.net>

---
 common |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/common b/common
index 9679b15..828563d 100644
--- a/common
+++ b/common
@@ -47,7 +47,7 @@ rm -f $tmp.list $tmp.tmp $tmp.sed
 # Autodetect fs type based on what's on $TEST_DEV
 if [ "$HOSTOS" == "Linux" ]
 then
-    export FSTYP=`blkid -p -s TYPE -o value $TEST_DEV`
+    export FSTYP=`blkid -c /dev/null -s TYPE -o value $TEST_DEV`
 else
     export FSTYP=xfs
 fi

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
