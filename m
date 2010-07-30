Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o59EEjLq068352 for <xfs@oss.sgi.com>; Wed, 9 Jun 2010 09:14:45 -0500
Received: from stout.americas.sgi.com (stout.americas.sgi.com [128.162.232.50])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 115153040CA
	for <xfs@oss.sgi.com>; Fri, 30 Jul 2010 14:52:40 -0700 (PDT)
Received: from stout.americas.sgi.com (localhost6.localdomain6 [127.0.0.1])
	by stout.americas.sgi.com (8.14.3/8.14.2) with ESMTP id o6ULqdge008762
	for <xfs@oss.sgi.com>; Fri, 30 Jul 2010 16:52:39 -0500
Received: (from aelder@localhost)
	by stout.americas.sgi.com (8.14.3/8.14.3/Submit) id o6ULqdcK008761
	for xfs@oss.sgi.com; Fri, 30 Jul 2010 16:52:39 -0500
From: Alex Elder <aelder@sgi.com>
Message-Id: <201007302152.o6ULqdcK008761@stout.americas.sgi.com>
Date: Fri, 30 Jul 2010 16:52:39 -0500
Subject: [PATCH] xfstests: include NIS databases
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

If NIS is active on a test target system, additional password and
group file information is available via their respective databases
in NIS.  Currently, some tests assume that /etc/passwd and /etc/group
are the only places to find this information.

This patch causes both the local database and the NIS database (if
one is likely to be present) to be consulted for needed information.

Signed-off-by: Alex Elder <aelder@sgi.com>

---
 093          |    2 +-
 common.attr  |    4 ++--
 common.quota |   12 ++++++------
 common.rc    |   28 +++++++++++++++++++++++++++-
 4 files changed, 36 insertions(+), 10 deletions(-)

Index: b/093
===================================================================
--- a/093
+++ b/093
@@ -72,7 +72,7 @@ echo ""
 file=$testdir/$seq.file
 
 user=`grep ':all=:all=' /etc/capability | tail -1 | $AWK_PROG -F: '{print $1}'`
-uid=`grep $user /etc/passwd | $AWK_PROG -F: '{print $3}'`
+uid=`_cat_passwd | grep $user | $AWK_PROG -F: '{print $3}'`
 
 cat >$tmp.append <<EOF
 #!/bin/bash
Index: b/common.attr
===================================================================
--- a/common.attr
+++ b/common.attr
@@ -25,7 +25,7 @@
 #
 _acl_setup_ids()
 {
-    eval `cat /etc/passwd /etc/group | awk -F: '
+    eval `(_cat_passwd; _cat_group) | awk -F: '
       { ids[$3]=1 }
       END {
         j=1
@@ -93,7 +93,7 @@ _filter_aces()
     $AWK_PROG '
 	BEGIN {
 	    FS=":"
-	    while ( getline <"/etc/passwd" > 0 ) {
+	    while ( "_cat_passwd" | getline > 0 ) {
 		idlist[$1] = $3 
 	    }
 	}
Index: b/common.quota
===================================================================
--- a/common.quota
+++ b/common.quota
@@ -59,11 +59,11 @@ _require_prjquota()
 #
 _require_nobody()
 {
-    grep -q '^nobody' /etc/passwd
-    [ $? -ne 0 ] && _notrun "/etc/passwd does not contain user nobody."
+    _cat_passwd | grep -q '^nobody'
+    [ $? -ne 0 ] && _notrun "password file does not contain user nobody."
 
-    egrep -q '^no(body|group)' /etc/group
-    [ $? -ne 0 ] && _notrun "/etc/group does not contain nobody/nogroup."
+    _cat_group | egrep -q '^no(body|group)'
+    [ $? -ne 0 ] && _notrun "group file does not contain nobody/nogroup."
 }
 
 # create a file as a specific user (uid)
@@ -108,12 +108,12 @@ EOF
 
 _choose_uid()
 {
-    grep '^nobody' /etc/passwd | perl -ne '@a = split(/:/); END { printf "id=%d name=%s\n", $a[2],$a[0] }'
+    _cat_passwd | grep '^nobody' | perl -ne '@a = split(/:/); END { printf "id=%d name=%s\n", $a[2],$a[0] }'
 }
 
 _choose_gid()
 {
-    egrep '^no(body|group)' /etc/group | perl -ne '@a = split(/:/); END { printf "id=%d name=%s\n", $a[2],$a[0] }'
+    _cat_group | egrep '^no(body|group)' | perl -ne '@a = split(/:/); END { printf "id=%d name=%s\n", $a[2],$a[0] }'
 }
 
 _choose_prid()
Index: b/common.rc
===================================================================
--- a/common.rc
+++ b/common.rc
@@ -793,12 +793,38 @@ _require_nonexternal()
 	_notrun "External device testing in progress, skipped this test"
 }
 
+# indicate whether YP/NIS is active or not
+#
+_yp_active()
+{
+	local dn
+	dn=$(domainname 2>/dev/null)
+	test -n "${DN}" -a "${DN}" != "(none)"
+}
+
+# cat the password file
+#
+_cat_passwd()
+{
+    	[ _yp_active ] && ypcat passwd
+	cat /etc/passwd
+}
+
+# cat the group file
+#
+_cat_group()
+{
+    	[ _yp_active ] && ypcat group
+	cat /etc/group
+}
+export -f _yp_active _cat_passwd _cat_group
+
 # check for the fsgqa user on the machine
 #
 _require_user()
 {
     qa_user=fsgqa
-    cat /etc/passwd | grep -q $qa_user
+    _cat_passwd | grep -q $qa_user
     [ "$?" == "0" ] || _notrun "$qa_user user not defined."
 }
 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
