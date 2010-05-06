Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o46HO0kk123514 for <xfs@oss.sgi.com>; Thu, 6 May 2010 12:24:00 -0500
From: Alex Elder <aelder@sgi.com>
Message-Id: <201005061726.o46HQ78v018283@stout.americas.sgi.com>
Date: Thu, 06 May 2010 12:26:07 -0500
Subject: [PATCH] xfstests: honor comments in the test group file
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

(Re-posting unchanged in hopes it will get reviewed this time.)

There are some spots in the "group" file where test numbers have
groups listed after a '#' character, clearly intending for those
groups to be commented out.  But the way the group list gets
generated that commenting doesn't work, and in fact these tests
explicitly *are* included in such commented-out groups.

This patch fixes that, stripping out all comments (which start
with a '#' character and end with a newline) from the file before
building the set of test numbers for a group.

Signed-off-by: Alex Elder <aelder@sgi.com>

---
common |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

Index: b/common
===================================================================
--- a/common
+++ b/common
@@ -58,9 +58,10 @@ do
     if $group
     then
 	# arg after -g
-	group_list=`sed -n <group -e 's/$/ /' -e "/^[0-9][0-9][0-9].* $r /"'{
-s/ .*//p
-}'`
+       group_list=$(sed -n < group \
+                       -e 's/#.*//' \
+                       -e 's/$/ /' \
+                       -e "/^[0-9][0-9][0-9].* $r /"'{ s/ .*//p }')
 	if [ -z "$group_list" ]
 	then
 	    echo "Group \"$r\" is empty or not defined?"

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
