Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:49194 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932845AbeFUTsj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 21 Jun 2018 15:48:39 -0400
Date: Thu, 21 Jun 2018 12:48:25 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH v2] xfs_bmap: don't reject -e
Message-ID: <20180621194825.GG4838@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@redhat.com>
Cc: xfs <linux-xfs@vger.kernel.org>

From: Darrick J. Wong <darrick.wong@oracle.com>

The xfs_io bmap command has an -e switch that prints delalloc extents
without fsync'ing the file first.  The xfs_bmap manpage says it'll pass
-e through, but it doesn't.  Fix the script and fix the weird manpage
discrepancy where it doesn't list -e in the available options but
discusses it anyway.

Fixes: 7536ce44f6 ("xfs_io: bmap should support querying CoW fork, shared blocks")
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
v2: add Fixes:
---
 io/xfs_bmap.sh      |    5 +++--
 man/man8/xfs_bmap.8 |    2 +-
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/io/xfs_bmap.sh b/io/xfs_bmap.sh
index b4e7992b..753d57cb 100755
--- a/io/xfs_bmap.sh
+++ b/io/xfs_bmap.sh
@@ -5,14 +5,15 @@
 
 OPTS=""
 VERSION=false
-USAGE="Usage: xfs_bmap [-adlpvV] [-n nx] file..."
+USAGE="Usage: xfs_bmap [-adelpvV] [-n nx] file..."
 DIRNAME=`dirname $0`
 
-while getopts "adln:pvV" c
+while getopts "adeln:pvV" c
 do
 	case $c in
 	a)	OPTS=$OPTS" -a";;
 	d)	OPTS=$OPTS" -d";;
+	e)	OPTS=$OPTS" -e";;
 	l)	OPTS=$OPTS" -l";;
 	n)	OPTS=$OPTS" -n "$OPTARG;;
 	p)	OPTS=$OPTS" -p";;
diff --git a/man/man8/xfs_bmap.8 b/man/man8/xfs_bmap.8
index c7255192..ae923481 100644
--- a/man/man8/xfs_bmap.8
+++ b/man/man8/xfs_bmap.8
@@ -4,7 +4,7 @@ xfs_bmap \- print block mapping for an XFS file
 .SH SYNOPSIS
 .B xfs_bmap
 [
-.B \-adlpv
+.B \-adelpv
 ] [
 .B \-n
 .I num_extents
