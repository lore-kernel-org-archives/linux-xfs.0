Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q6Q9SKr4006738 for <xfs@oss.sgi.com>; Thu, 26 Jul 2012 04:28:20 -0500
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	mpVHSFSuxn2gylLc for <xfs@oss.sgi.com>;
	Thu, 26 Jul 2012 02:28:18 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1SuKMh-0001AY-0p
	for xfs@oss.sgi.com; Thu, 26 Jul 2012 19:28:15 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1SuKMg-0005Uy-TS
	for xfs@oss.sgi.com; Thu, 26 Jul 2012 19:28:14 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 01/18] xfstests: remove remake script
Date: Thu, 26 Jul 2012 19:27:55 +1000
Message-Id: <1343294892-20991-2-git-send-email-david@fromorbit.com>
In-Reply-To: <1343294892-20991-1-git-send-email-david@fromorbit.com>
References: <1343294892-20991-1-git-send-email-david@fromorbit.com>
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

We don't ever do wholesale rebuilds of the output files anymore, so
kill the script that does it to reduce the dependency on common and
common.rc.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 remake |   72 ----------------------------------------------------------------
 1 file changed, 72 deletions(-)
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
1.7.10

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
