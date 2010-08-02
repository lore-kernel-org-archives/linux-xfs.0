Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o72HoimQ199857 for <xfs@oss.sgi.com>; Mon, 2 Aug 2010 12:50:44 -0500
Received: from cf--amer001e--3.americas.sgi.com
	(cf--amer001e--3.americas.sgi.com [137.38.100.5])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 1ED838F804B
	for <xfs@oss.sgi.com>; Mon,  2 Aug 2010 10:51:01 -0700 (PDT)
Subject: [PATCH] xfstests: update README file to document some recent changes
From: Alex Elder <aelder@sgi.com>
Date: Mon, 02 Aug 2010 12:51:00 -0500
Message-ID: <1280771460.2236.68.camel@doink>
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

Update the README file to document the new _cat_passwd and
_cat_group functions, and to recommend passing "-n" to
getfacl(1) so it produces numeric output.

Signed-off-by: Alex Elder <aelder@sgi.com>

---
 README |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

Index: b/README
===================================================================
--- a/README
+++ b/README
@@ -160,6 +160,20 @@ Test script environment:
 				  string DATE for deterministic
 				  output
 
+	_cat_passwd,		- dump the content of the password
+	_cat_group		  or group file (both the local file
+				  and the content of the NIS database
+				  if it is likely to be present)
+
+     4. General recommendations, usage conventions, etc.:
+	- When the content of the password or group file is
+	  required, get it using the _cat_passwd and _cat_group
+	  functions, to ensure NIS information is included if NIS
+	  is active.
+	- When calling getfacl in a test, pass the "-n" argument so
+	  that numeric rather than symbolic identifiers are used in
+	  the output.
+
 Verified output:
 
     Each test script has a numerical name, e.g. 007, and an associated


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
