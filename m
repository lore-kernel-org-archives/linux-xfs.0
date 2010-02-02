Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o12N5dL6197575 for <xfs@oss.sgi.com>; Tue, 2 Feb 2010 17:05:40 -0600
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 96A5913706F4
	for <xfs@oss.sgi.com>; Tue,  2 Feb 2010 15:06:48 -0800 (PST)
Received: from mail.sandeen.net (64-131-60-146.usfamily.net [64.131.60.146])
	by cuda.sgi.com with ESMTP id OLdKQtKIpdWIJOx5 for
	<xfs@oss.sgi.com>; Tue, 02 Feb 2010 15:06:48 -0800 (PST)
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.4])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mail.sandeen.net (Postfix) with ESMTP id 543EB109E858
	for <xfs@oss.sgi.com>; Tue,  2 Feb 2010 17:06:47 -0600 (CST)
Message-ID: <4B68B007.1020705@sandeen.net>
Date: Tue, 02 Feb 2010 17:06:47 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH V3] xfstests: filter selinux output in _acl_ls etc
References: <4B61C1BC.4050800@sandeen.net> <4B626697.3080006@sandeen.net>
In-Reply-To: <4B626697.3080006@sandeen.net>
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

When selinux is on, ls -l gives us a "." to indicate selinux
attrs, which breaks some tests:

 === Test minimal ACE ===
 Setup file
--rwxrw-r-- id1 id2 file1
+-rwxrw-r--. id1 id2 file1

so make an _ls_l helper to filter that out.

Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
---

V3: after talking to christoph, maybe a sed that looks
just for the ls -l chars might be better.

diff --git a/105 b/105
index e3163fd..9544c66 100755
--- a/105
+++ b/105
@@ -76,7 +76,7 @@ chown $acl1 subdir
 
 # put a file in the directory
 echo data > subdir/file
-ls -l subdir/file | awk '{ print $1, $3 }'
+_ls_l subdir/file | awk '{ print $1, $3 }'
 
 # add an ACL with a user ACE which has no exec permission 
 if [ "$HOSTOS" == "Linux" ]; then
@@ -91,7 +91,7 @@ fi
 # With the bug this gives: `ls: subdir/file: Permission denied'
 # because one needs at least an exec perm somewhere in acl
 # However, this should not hold true for directories.
-ls -l subdir/file | awk '{ print $1, $3 }'
+_ls_l subdir/file | awk '{ print $1, $3 }'
 
 # With the bug this gives: `subdir/file2: Permission denied'.
 echo data2 > subdir/file2
diff --git a/common.attr b/common.attr
index a6b9b3b..d12cc02 100644
--- a/common.attr
+++ b/common.attr
@@ -58,7 +58,7 @@ _acl_filter_id()
 #
 _acl_ls()
 {
-    ls -ln $* | awk '{ print $1, $3, $4, $NF }' | _acl_filter_id
+    _ls_l -n $* | awk '{ print $1, $3, $4, $NF }' | _acl_filter_id
 } 
 
 #
diff --git a/common.rc b/common.rc
index 6424871..4425007 100644
--- a/common.rc
+++ b/common.rc
@@ -37,6 +37,14 @@ dd()
    fi
 }
 
+# ls -l w/ selinux sometimes puts a dot at the end:
+# -rwxrw-r--. id1 id2 file1
+
+_ls_l()
+{
+	ls -l $* | sed "s/\(^[-rwxdlbcpsStT]*\)\. /\1 /"
+}
+
 _mount_opts()
 {
     case $FSTYP in

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
