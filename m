Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 407537F54
	for <xfs@oss.sgi.com>; Tue,  2 Jul 2013 16:47:16 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id CF4C0AC007
	for <xfs@oss.sgi.com>; Tue,  2 Jul 2013 14:47:12 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id H0OdYSziN5tXUQwF (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 02 Jul 2013 14:47:11 -0700 (PDT)
Received: from acsinet21.oracle.com (acsinet21.oracle.com [141.146.126.237])
	by userp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with
	ESMTP id r62Len0W032623
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Tue, 2 Jul 2013 21:40:50 GMT
Received: from userz7022.oracle.com (userz7022.oracle.com [156.151.31.86])
	by acsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id
	r62Ll8mQ018107
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <xfs@oss.sgi.com>; Tue, 2 Jul 2013 21:47:09 GMT
Received: from abhmt108.oracle.com (abhmt108.oracle.com [141.146.116.60])
	by userz7022.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id
	r62Ll8js005704 for <xfs@oss.sgi.com>; Tue, 2 Jul 2013 21:47:08 GMT
From: Koen De Wit <koen.de.wit@oracle.com>
Subject: [PATCH] xfstests: fix _mount_ops_filter() to support $TEST_DIR
	containing -o
Date: Tue,  2 Jul 2013 23:44:57 +0200
Message-Id: <1372801497-3941-1-git-send-email-koen.de.wit@oracle.com>
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
Cc: Koen De Wit <koen.de.wit@oracle.com>

If multiple mount options are given with multiple -o parameters,
_mount_ops_filter concatenates them by replacing all -o's with a comma
(except for the first -o).

If $TEST_DIR contains "-o" (e.g. /mnt/test-os/) you get errors like this:

   # ./check generic/002
     mount: mount point /mnt/test,s/ does not exist
     common/rc: retrying test device mount with external set
     mount: mount point /mnt/test,s/ does not exist
     common/rc: could not mount /dev/sdc3 on /mnt/test-os/

Fix it by only replacing -o's that are preceded by at least one space.

Signed-off-by: Koen De Wit <koen.de.wit@oracle.com>
---
 common/rc |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/common/rc b/common/rc
index fe6bbfc..2a3c040 100644
--- a/common/rc
+++ b/common/rc
@@ -260,7 +260,7 @@ _mount_ops_filter()
     # the sed script replaces all -o's (except the first) with a comma
     # not required for linux, but won't hurt
     
-    echo $params | sed -e 's/[[:space:]]*-o[[:space:]]*/UnIqUe/1; s/[[:space:]]*-o[[:space:]]*/,/g; s/UnIqUe/ -o /1' \
+    echo $params | sed -e 's/[[:space:]]\+-o[[:space:]]*/UnIqUe/1; s/[[:space:]]\+-o[[:space:]]*/,/g; s/UnIqUe/ -o /1' \
         | sed -e 's/dmapi/dmi/' \
         | $PERL_PROG -ne "s#mtpt=[^,|^\n|^\s]*#mtpt=$FS_ESCAPED\1\2#; print;"
 
-- 
1.7.2.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
