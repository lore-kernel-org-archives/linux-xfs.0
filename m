Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n55LHdgG064828 for <xfs@oss.sgi.com>; Fri, 5 Jun 2009 16:17:39 -0500
Received: from mx2.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id DA5B02D75CC
	for <xfs@oss.sgi.com>; Fri,  5 Jun 2009 14:17:57 -0700 (PDT)
Received: from mx2.redhat.com (mx2.redhat.com [66.187.237.31]) by cuda.sgi.com
	with ESMTP id A8luaQXndeXDfFWL for <xfs@oss.sgi.com>;
	Fri, 05 Jun 2009 14:17:57 -0700 (PDT)
Received: from int-mx2.corp.redhat.com (int-mx2.corp.redhat.com [172.16.27.26])
	by mx2.redhat.com (8.13.8/8.13.8) with ESMTP id n55LHuc0010044
	for <xfs@oss.sgi.com>; Fri, 5 Jun 2009 17:17:56 -0400
Received: from ns3.rdu.redhat.com (ns3.rdu.redhat.com [10.11.255.199])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n55LHuQX026173
	for <xfs@oss.sgi.com>; Fri, 5 Jun 2009 17:17:56 -0400
Received: from neon.msp.redhat.com (neon.msp.redhat.com [10.15.80.10])
	by ns3.rdu.redhat.com (8.13.8/8.13.8) with ESMTP id n55LHs3k020198
	for <xfs@oss.sgi.com>; Fri, 5 Jun 2009 17:17:55 -0400
Message-ID: <4A298B82.3050903@sandeen.net>
Date: Fri, 05 Jun 2009 16:17:54 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH xfstests: Make "new" script insert appropriate license on tests
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
To: xfs mailing list <xfs@oss.sgi.com>

Don't default to SGI copyright, someone else may be
making this test...

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

iff --git a/new b/new
index 45ff163..8e32824 100755
--- a/new
+++ b/new
@@ -79,6 +79,8 @@ fi
 
 echo -n "Creating skeletal script for you to edit ..."
 
+year=`date +%Y`
+
 cat <<End-of-File >$id
 #! /bin/sh
 # FS QA Test No. $id
@@ -86,7 +88,20 @@ cat <<End-of-File >$id
 # what am I here for?
 #
 #-----------------------------------------------------------------------
-# Copyright (c) 2000-2005 Silicon Graphics, Inc.  All Rights Reserved.
+# Copyright (c) $year YOUR NAME HERE.  All Rights Reserved.
+#
+# This program is free software; you can redistribute it and/or
+# modify it under the terms of the GNU General Public License as
+# published by the Free Software Foundation.
+#
+# This program is distributed in the hope that it would be useful,
+# but WITHOUT ANY WARRANTY; without even the implied warranty of
+# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+# GNU General Public License for more details.
+#
+# You should have received a copy of the GNU General Public License
+# along with this program; if not, write the Free Software Foundation,
+# Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
 #-----------------------------------------------------------------------
 #
 # creator


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
