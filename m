Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o761IQN8112744 for <xfs@oss.sgi.com>; Thu, 5 Aug 2010 20:18:26 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id BE12D16AE847
	for <xfs@oss.sgi.com>; Thu,  5 Aug 2010 18:18:45 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail12.adl6.internode.on.net
	[150.101.137.97]) by cuda.sgi.com with ESMTP id
	aF1V3ndgBtD7AG68 for <xfs@oss.sgi.com>;
	Thu, 05 Aug 2010 18:18:45 -0700 (PDT)
Received: from dastard (unverified [121.44.216.100])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	34203320-1927428
	for <xfs@oss.sgi.com>; Fri, 06 Aug 2010 10:48:44 +0930 (CST)
Received: from disturbed ([192.168.1.9]) by dastard with esmtp (Exim 4.71)
	(envelope-from <dave@fromorbit.com>) id 1OhBa4-0003on-SU
	for xfs@oss.sgi.com; Fri, 06 Aug 2010 11:18:40 +1000
Received: from dave by disturbed with local (Exim 4.71)
	(envelope-from <dave@disturbed.disaster>) id 1OhBa3-0006RK-7w
	for xfs@oss.sgi.com; Fri, 06 Aug 2010 11:18:39 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH] xfstests: fix NIS detection damage
Date: Fri,  6 Aug 2010 11:18:39 +1000
Message-Id: <1281057519-24730-1-git-send-email-david@fromorbit.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

From: Dave Chinner <dchinner@redhat.com>

NIS detection wasn't tested on machines without NIS enabled, so many tests are
failing on non-NIS machines. the _yp_active function has no specific return
value so always evaluates as 0 (active) and the "_cat_passwd" function is
called from within an awk script which is not valid as the shell may run with a
sanitised environment. Hence the functions do not need specific export calls,
either, as unsanitised subshells will automatically inherit the parent's
environment.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 common.attr |    9 +++++++--
 common.rc   |    6 +++---
 2 files changed, 10 insertions(+), 5 deletions(-)

diff --git a/common.attr b/common.attr
index 51616bc..6ba0b32 100644
--- a/common.attr
+++ b/common.attr
@@ -90,10 +90,14 @@ _create_n_aces()
 #
 _filter_aces()
 {
-    $AWK_PROG '
+    tmp_file=`mktemp /tmp/ace.XXXXXX`
+
+    (_cat_passwd; _cat_group) > $tmp_file
+
+    $AWK_PROG -v tmpfile=$tmp_file '
 	BEGIN {
 	    FS=":"
-	    while ( "_cat_passwd" | getline > 0 ) {
+	    while ( getline <tmpfile > 0 ) {
 		idlist[$1] = $3 
 	    }
 	}
@@ -102,6 +106,7 @@ _filter_aces()
 	/^default:user/ { if ($3 in idlist) sub($3, idlist[$3]); print; next}
 	{print}
     '
+    rm -f $tmp_file
 }
 
 _filter_aces_notypes()
diff --git a/common.rc b/common.rc
index e0cdfe6..08d4f71 100644
--- a/common.rc
+++ b/common.rc
@@ -800,13 +800,14 @@ _yp_active()
 	local dn
 	dn=$(domainname 2>/dev/null)
 	test -n "${dn}" -a "${dn}" != "(none)"
+	echo $?
 }
 
 # cat the password file
 #
 _cat_passwd()
 {
-	[ _yp_active ] && ypcat passwd
+	[ $(_yp_active) -eq 0 ] && ypcat passwd
 	cat /etc/passwd
 }
 
@@ -814,10 +815,9 @@ _cat_passwd()
 #
 _cat_group()
 {
-	[ _yp_active ] && ypcat group
+	[ $(_yp_active) -eq 0 ] && ypcat group
 	cat /etc/group
 }
-export -f _yp_active _cat_passwd _cat_group
 
 # check for the fsgqa user on the machine
 #
-- 
1.7.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
