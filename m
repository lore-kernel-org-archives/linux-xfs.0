Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 3AC9A7F4E
	for <xfs@oss.sgi.com>; Fri, 24 May 2013 03:54:30 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 27FE4304051
	for <xfs@oss.sgi.com>; Fri, 24 May 2013 01:54:30 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	1R8klRUDoR6ztB04 for <xfs@oss.sgi.com>;
	Fri, 24 May 2013 01:54:27 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1UfnlX-0001NX-KR
	for xfs@oss.sgi.com; Fri, 24 May 2013 18:54:23 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1UfnlX-0004QM-G8
	for xfs@oss.sgi.com; Fri, 24 May 2013 18:54:23 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 1/2] xfstests: generic/193 needs some help
Date: Fri, 24 May 2013 18:54:18 +1000
Message-Id: <1369385659-16970-2-git-send-email-david@fromorbit.com>
In-Reply-To: <1369385659-16970-1-git-send-email-david@fromorbit.com>
References: <1369385659-16970-1-git-send-email-david@fromorbit.com>
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

From: Dave Chinner <dchinner@redhat.com>

generic/192 runs the test in $here - the root of the xfstests source
tree/installation. IOWs, it doesn't test the filesystem on either
the TEST_DIR or SCRATCH_MNT, and so it not testing the filesystem
we think it is testing. Bad. Fixing this is the majority of the
change - introducing $test_root and $test_user for the files with
different owners, and then redirecting error output and filtering
the output appropriately.

And then add checks that truncate clears the suid/sgid bits
appropriately, somethign that has never been tested on XFS (and
likely other filesystems) so will cause kernels between 3.1 and 3.9
to assert fail as Dave Jones has recently reported.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 tests/generic/193     |  135 ++++++++++++++++++++++++++++++++-----------------
 tests/generic/193.out |   17 ++++++-
 2 files changed, 105 insertions(+), 47 deletions(-)

diff --git a/tests/generic/193 b/tests/generic/193
index cdf04c2..4fa20ff 100755
--- a/tests/generic/193
+++ b/tests/generic/193
@@ -43,9 +43,9 @@ tag="added by qa $seq"
 #
 _create_files()
 {
-	touch test.root
-	touch test.${qa_user}
-	chown ${qa_user}:${qa_user} test.${qa_user}
+	touch $test_root
+	touch $test_user
+	chown ${qa_user}:${qa_user} $test_user
 }
 
 #
@@ -53,8 +53,13 @@ _create_files()
 #
 _cleanup_files()
 {
-	rm -f test.${qa_user}
-	rm -f test.root
+	rm -f $test_user
+	rm -f $test_root
+}
+
+_filter_files()
+{
+	sed -e "s,$test_root,test.root,g" -e "s,$test_user,test.user,g"
 }
 
 # get standard environment, filters and checks
@@ -68,6 +73,9 @@ _supported_os Linux
 _require_user
 _need_to_be_root
 
+test_root=$TEST_DIR/$seq.$$.root
+test_user=$TEST_DIR/$seq.$$.user
+
 #
 # make sure we have a normal umask set
 #
@@ -83,17 +91,17 @@ echo
 _create_files
 
 echo "user: chown root owned file to qa_user (should fail)"
-su ${qa_user} -c "chown ${qa_user} test.root"
+su ${qa_user} -c "chown ${qa_user} $test_root" 2>&1 | _filter_files
 
 echo "user: chown root owned file to root (should fail)"
-su ${qa_user} -c "chown root test.root"
+su ${qa_user} -c "chown root $test_root" 2>&1 | _filter_files
 
 echo "user: chown qa_user owned file to qa_user (should succeed)"
-su ${qa_user} -c "chown ${qa_user} test.${qa_user}"
+su ${qa_user} -c "chown ${qa_user} $test_user"
 
 # this would work without _POSIX_CHOWN_RESTRICTED
 echo "user: chown qa_user owned file to root (should fail)"
-su ${qa_user} -c "chown root test.${qa_user}"
+su ${qa_user} -c "chown root $test_user" 2>&1 | _filter_files
 
 _cleanup_files
 
@@ -107,19 +115,19 @@ echo
 _create_files
 
 echo "user: chgrp root owned file to root (should fail)"
-su ${qa_user} -c "chgrp root test.root"
+su ${qa_user} -c "chgrp root $test_root" 2>&1 | _filter_files
 
 echo "user: chgrp qa_user owned file to root (should fail)"
-su ${qa_user} -c "chgrp root test.${qa_user}"
+su ${qa_user} -c "chgrp root $test_user" 2>&1 | _filter_files
 
 echo "user: chgrp root owned file to qa_user (should fail)"
-su ${qa_user} -c "chgrp ${qa_user} test.root"
+su ${qa_user} -c "chgrp ${qa_user} $test_root" 2>&1 | _filter_files
 
 echo "user: chgrp qa_user owned file to qa_user (should succeed)"
-su ${qa_user} -c "chgrp ${qa_user} test.${qa_user}"
+su ${qa_user} -c "chgrp ${qa_user} $test_user"
 
 #echo "user: chgrp qa_user owned file to secondary group (should succeed)"
-#su ${qa_user} -c "chgrp ${group2} test.${qa_user}"
+#su ${qa_user} -c "chgrp ${group2} $test_user"
 
 _cleanup_files
 
@@ -133,10 +141,10 @@ echo
 _create_files
 
 echo "user: chmod a+r on qa_user owned file (should succeed)"
-su ${qa_user} -c "chmod a+r test.${qa_user}"
+su ${qa_user} -c "chmod a+r $test_user"
 
 echo "user: chmod a+r on root owned file (should fail)"
-su ${qa_user} -c "chmod a+r test.root"
+su ${qa_user} -c "chmod a+r $test_root" 2>&1 | _filter_files
 
 #
 # Setup a file owned by the qa_user, but with a group ID that
@@ -153,12 +161,12 @@ su ${qa_user} -c "chmod a+r test.root"
 # reg file + file's gid not in process' group set + no approp. privileges -> clear sgid
 #
 echo "check that the sgid bit is cleared"
-chown ${qa_user}:root test.${qa_user}
-chmod g+s test.${qa_user}
+chown ${qa_user}:root $test_user
+chmod g+s $test_user
 
 # and let the qa_user change permission bits
-su ${qa_user} -c "chmod a+w test.${qa_user}"
-stat -c '%A' test.${qa_user}
+su ${qa_user} -c "chmod a+w $test_user"
+stat -c '%A' $test_user
 
 #
 # Setup a file owned by the qa_user and with the suid bit set.
@@ -166,9 +174,9 @@ stat -c '%A' test.${qa_user}
 # There is nothing in Posix that says it should but just checking.
 #
 echo "check that suid bit is not cleared"
-chmod u+s test.${qa_user}
-chmod a+w test.${qa_user}
-stat -c '%A' test.${qa_user}
+chmod u+s $test_user
+chmod a+w $test_user
+stat -c '%A' $test_user
 
 _cleanup_files
 
@@ -196,35 +204,72 @@ _create_files
 echo "check that suid/sgid bits are cleared after successful chown..."
 
 echo "with no exec perm"
-chmod ug+s test.${qa_user}
-echo -n "before: "; stat -c '%A' test.${qa_user}
-chown root test.${qa_user}
-echo -n "after:  "; stat -c '%A' test.${qa_user}
+chmod ug+s $test_user
+echo -n "before: "; stat -c '%A' $test_user
+chown root $test_user
+echo -n "after:  "; stat -c '%A' $test_user
 
 echo "with user exec perm"
-chmod ug+s test.${qa_user}
-chmod u+x test.${qa_user}
-echo -n "before: "; stat -c '%A' test.${qa_user}
-chown root test.${qa_user}
-echo -n "after:  "; stat -c '%A' test.${qa_user}
+chmod ug+s $test_user
+chmod u+x $test_user
+echo -n "before: "; stat -c '%A' $test_user
+chown root $test_user
+echo -n "after:  "; stat -c '%A' $test_user
 
 echo "with group exec perm"
-chmod ug+s test.${qa_user}
-chmod g+x test.${qa_user}
-chmod u-x test.${qa_user}
-echo -n "before: "; stat -c '%A' test.${qa_user}
-chown root test.${qa_user}
-echo -n "after:  "; stat -c '%A' test.${qa_user}
+chmod ug+s $test_user
+chmod g+x $test_user
+chmod u-x $test_user
+echo -n "before: "; stat -c '%A' $test_user
+chown root $test_user
+echo -n "after:  "; stat -c '%A' $test_user
 
 echo "with user+group exec perm"
-chmod ug+s test.${qa_user}
-chmod ug+x test.${qa_user}
-echo -n "before: "; stat -c '%A' test.${qa_user}
-chown root test.${qa_user}
-echo -n "after:  "; stat -c '%A' test.${qa_user}
+chmod ug+s $test_user
+chmod ug+x $test_user
+echo -n "before: "; stat -c '%A' $test_user
+chown root $test_user
+echo -n "after:  "; stat -c '%A' $test_user
 
 _cleanup_files
 
+_create_files
+# Now test out the clear of suid/sgid for truncate
+#
+echo "check that suid/sgid bits are cleared after successful truncate..."
+
+echo "with no exec perm"
+echo frobnozzle >> $test_user
+chmod ug+s $test_user
+echo -n "before: "; stat -c '%A' $test_user
+su ${qa_user} -c "echo > $test_user"
+echo -n "after:  "; stat -c '%A' $test_user
+
+echo "with user exec perm"
+echo frobnozzle >> $test_user
+chmod ug+s $test_user
+chmod u+x $test_user
+echo -n "before: "; stat -c '%A' $test_user
+su ${qa_user} -c "echo > $test_user"
+echo -n "after:  "; stat -c '%A' $test_user
+
+echo "with group exec perm"
+echo frobnozzle >> $test_user
+chmod ug+s $test_user
+chmod g+x $test_user
+chmod u-x $test_user
+echo -n "before: "; stat -c '%A' $test_user
+su ${qa_user} -c "echo > $test_user"
+echo -n "after:  "; stat -c '%A' $test_user
+
+echo "with user+group exec perm"
+echo frobnozzle >> $test_user
+chmod ug+s $test_user
+chmod ug+x $test_user
+echo -n "before: "; stat -c '%A' $test_user
+su ${qa_user} -c "echo > $test_user"
+echo -n "after:  "; stat -c '%A' $test_user
+
 #
 # Test ATTR_*TIMES_SET
 #
@@ -235,10 +280,10 @@ echo
 _create_files
 
 echo "user: touch qa_user file (should succeed)"
-su ${qa_user} -c "touch test.${qa_user}"
+su ${qa_user} -c "touch $test_user"
 
 echo "user: touch root file (should fail)"
-su ${qa_user} -c "touch test.root"
+su ${qa_user} -c "touch $test_root" 2>&1 | _filter_files
 
 _cleanup_files
 
diff --git a/tests/generic/193.out b/tests/generic/193.out
index b89add3..357a7c1 100644
--- a/tests/generic/193.out
+++ b/tests/generic/193.out
@@ -8,14 +8,14 @@ user: chown root owned file to root (should fail)
 chown: changing ownership of `test.root': Operation not permitted
 user: chown qa_user owned file to qa_user (should succeed)
 user: chown qa_user owned file to root (should fail)
-chown: changing ownership of `test.fsgqa': Operation not permitted
+chown: changing ownership of `test.user': Operation not permitted
 
 testing ATTR_GID
 
 user: chgrp root owned file to root (should fail)
 chgrp: changing group of `test.root': Operation not permitted
 user: chgrp qa_user owned file to root (should fail)
-chgrp: changing group of `test.fsgqa': Operation not permitted
+chgrp: changing group of `test.user': Operation not permitted
 user: chgrp root owned file to qa_user (should fail)
 chgrp: changing group of `test.root': Operation not permitted
 user: chgrp qa_user owned file to qa_user (should succeed)
@@ -42,6 +42,19 @@ after:  -rw-r-xr--
 with user+group exec perm
 before: -rwsr-sr--
 after:  -rwxr-xr--
+check that suid/sgid bits are cleared after successful truncate...
+with no exec perm
+before: -rwSr-Sr--
+after:  -rw-r-Sr--
+with user exec perm
+before: -rwsr-Sr--
+after:  -rwxr-Sr--
+with group exec perm
+before: -rwSr-sr--
+after:  -rw-r-xr--
+with user+group exec perm
+before: -rwsr-sr--
+after:  -rwxr-xr--
 
 testing ATTR_*TIMES_SET
 
-- 
1.7.10.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
