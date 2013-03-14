Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cthulhu.engr.sgi.com (cthulhu.engr.sgi.com [150.166.39.100])
	by oss.sgi.com (Postfix) with ESMTP id DBF507F51
	for <xfs@oss.sgi.com>; Thu, 14 Mar 2013 08:06:11 -0500 (CDT)
Received: from polaris-admin.engr.sgi.com (polaris-admin.engr.sgi.com
	[150.166.41.54])
	by cthulhu.engr.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id
	r2ED6Bx7007450 for <xfs@oss.sgi.com>; Thu, 14 Mar 2013 06:06:11 -0700
Date: Thu, 14 Mar 2013 06:06:11 -0700
Subject: [PATCH 01/18] xfstests: Remove obsolete remake script
MIME-Version: 1.0
Message-Id: <20130314130611.405A853DEAEF@polaris-admin.engr.sgi.com>
From: pwhite@sgi.com (Philip White)
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

From: Phil White <pwhite@sgi.com>


This is a rebasing & resubmit of a dchinner patch.  His comments on the
original:
-----------------
We don't ever do wholesale rebuilds of the output files anymore, so
kill the script that does it to reduce the dependency on common and
common.rc.
-----------------

Signed-off-by: Phil White <pwhite@sgi.com>
---
 remake |   72 ----------------------------------------------------------------
 1 files changed, 0 insertions(+), 72 deletions(-)
 delete mode 100755 remake

diff --git a/remake b/remake
deleted file mode 100755
index a95aae7..0000000
--- a/remake
+++ /dev/null
@@ -1,72 +0,0 @@
-#! /bin/bash
-#
-# Copyright (c) 2000-2001 Silicon Graphics, Inc.  All Rights Reserved.
-#
-# This program is free software; you can redistribute it and/or
-# modify it under the terms of the GNU General Public License as
-# published by the Free Software Foundation.
-#
-# This program is distributed in the hope that it would be useful,
-# but WITHOUT ANY WARRANTY; without even the implied warranty of
-# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-# GNU General Public License for more details.
-#
-# You should have received a copy of the GNU General Public License
-# along with this program; if not, write the Free Software Foundation,
-# Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
-#
-#
-# Rebuild NNN.out files
-#
-# $Header: /build2/depot/linux/pcp/dev/qa/RCS/remake,v 2.11 1999/09/20 03:42:19 kenmcd Exp $
-#
-
-tmp=/tmp/$$
-trap "rm -f NO-PREVIOUS-OUTPUT $tmp.*; exit" 0 1 2 3 15
-
-# generic initialization
-iam=remake
-. ./common.rc
-
-. ./common
-
-[ -f check.time ] || touch check.time
-
-for seq in $list
-do
-    if [ ! -f $seq ]
-    then
-	echo "Remake: cannot find \"$seq\""
-    else
-	echo -n "$seq"
-	lasttime=`sed -n -e "/^$seq /s/.* //p" <check.time`
-	[ "X$lasttime" != X ] && echo -n " ${lasttime}s"
-	rm -f $seq.bak $seq.full.bak
-	if sh $seq >$seq.new 2>&1
-	then
-	    if [ -f $seq.out ]
-	    then
-		$diff $seq.out $seq.new
-		rm -f $seq.out.bad
-	    else
-		touch NO-PREVIOUS-OUTPUT
-		$diff NO-PREVIOUS-OUTPUT $seq.new
-		rm -f NO-PREVIOUS-OUTPUT
-	    fi
-	    echo ""
-	    [ -f $seq.out ] && mv $seq.out $seq.bak
-	    if [ -f $seq.full ]
-	    then
-		[ -f $seq.full.ok ] && mv $seq.full.ok $seq.full.bak
-		mv $seq.full $seq.full.ok
-	    fi
-	    mv $seq.new $seq.out
-	else
-	    echo " - failed (exit status $?)"
-	    sed 's/^/	/' $seq.new
-	    exit 1
-	fi
-    fi
-done
-
-exit 0
-- 
1.5.3.8

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
