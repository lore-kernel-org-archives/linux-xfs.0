Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o1QIRkld200519 for <xfs@oss.sgi.com>; Fri, 26 Feb 2010 12:27:46 -0600
Received: from cf--amer001e--3.americas.sgi.com
	(cf--amer001e--3.americas.sgi.com [137.38.100.5])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 0C524AC042
	for <xfs@oss.sgi.com>; Fri, 26 Feb 2010 10:29:07 -0800 (PST)
Subject: xfstests: honor comments in the test group file
From: Alex Elder <aelder@sgi.com>
Date: Fri, 26 Feb 2010 12:29:07 -0600
Message-ID: <1267208947.2756.11.camel@doink>
Mime-Version: 1.0
Reply-To: aelder@sgi.com
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

There are some spots in the "group" file where test numbers have
groups listed after a '#' character, clearly intending for those
groups to be commented out.  But the way the group list gets
generated that commenting doesn't work, and in fact these tests
explicitly *are* included in such commented-out groups.

This patch fixes that, stripping out all comments (which start with
a '#' character and end with a newline) from the file before
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
-       group_list=`sed -n <group -e 's/$/ /' -e "/^[0-9][0-9][0-9].*
$r /"'{
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
