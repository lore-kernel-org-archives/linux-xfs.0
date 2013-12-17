Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id C9A3E29E09
	for <xfs@oss.sgi.com>; Tue, 17 Dec 2013 08:02:41 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id AB2DC8F8049
	for <xfs@oss.sgi.com>; Tue, 17 Dec 2013 06:02:38 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id wnvk1DkON0hJn6Yu for
	<xfs@oss.sgi.com>; Tue, 17 Dec 2013 06:02:36 -0800 (PST)
Received: from int-mx01.intmail.prod.int.phx2.redhat.com
	(int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id rBHE2Zwr000954
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Tue, 17 Dec 2013 09:02:35 -0500
From: Lukas Czerner <lczerner@redhat.com>
Subject: [PATCH 1/3] common: Filter out lost+found directory from _ls_l()
	output
Date: Tue, 17 Dec 2013 15:02:25 +0100
Message-Id: <1387288947-12650-1-git-send-email-lczerner@redhat.com>
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
Cc: Lukas Czerner <lczerner@redhat.com>

Signed-off-by: Lukas Czerner <lczerner@redhat.com>
---
 common/rc | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/common/rc b/common/rc
index 5f61d57..7a168e9 100644
--- a/common/rc
+++ b/common/rc
@@ -74,10 +74,11 @@ _md5_checksum()
 
 # ls -l w/ selinux sometimes puts a dot at the end:
 # -rwxrw-r--. id1 id2 file1
+# Also filter out lost+found directory on extN file system if present
 
 _ls_l()
 {
-	ls -l $* | sed "s/\(^[-rwxdlbcpsStT]*\)\. /\1 /"
+	ls -l $* | sed "s/\(^[-rwxdlbcpsStT]*\)\. /\1 /" | grep -v 'lost+found'
 }
 
 _mount_opts()
-- 
1.8.3.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
