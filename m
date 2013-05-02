Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 7FBAC7F59
	for <xfs@oss.sgi.com>; Thu,  2 May 2013 09:04:24 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 42F3C304051
	for <xfs@oss.sgi.com>; Thu,  2 May 2013 07:04:24 -0700 (PDT)
Received: from mail-wi0-f180.google.com (mail-wi0-f180.google.com
	[209.85.212.180]) by cuda.sgi.com with ESMTP id
	HBDLjxs3jszfC6ue (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Thu, 02 May 2013 07:04:23 -0700 (PDT)
Received: by mail-wi0-f180.google.com with SMTP id h11so621531wiv.7
	for <xfs@oss.sgi.com>; Thu, 02 May 2013 07:04:21 -0700 (PDT)
From: ranto.boris@gmail.com
Subject: [PATCH 3/3] xfstests: Do not fail on empty exclude groups
Date: Thu,  2 May 2013 16:03:59 +0200
Message-Id: <1367503439-12827-4-git-send-email-ranto.boris@gmail.com>
In-Reply-To: <1367503439-12827-1-git-send-email-ranto.boris@gmail.com>
References: <1367503439-12827-1-git-send-email-ranto.boris@gmail.com>
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
Cc: Boris Ranto <ranto.boris@gmail.com>

From: Boris Ranto <ranto.boris@gmail.com>

Currently, xfstests will fail as soon as it detects an empty exclude
group. However, this may cause problems in automated testing. For
example, if one wishes to exclude otherwise valid group dmapi for file
system like tmpfs or nfs, the ./check script will hit the error about
empty group and fail. This simple patch changes the error to warning,
prints the warning to stderr and simply continue without excluding
anything as there are no tests to be excluded.

Signed-off-by: Boris Ranto <ranto.boris@gmail.com>
---
 check |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/check b/check
index 4af2dbd..b888030 100755
--- a/check
+++ b/check
@@ -194,12 +194,13 @@ while [ $# -gt 0 ]; do
 		[ ! -s $tmp.list ] && get_all_tests
 
 		group_list=$(get_group_list $xgroup)
+		# Trim the test list only if there is something to trim it with
 		if [ -z "$group_list" ]; then
-		    echo "Group \"$xgroup\" is empty or not defined?"
-		    exit 1
+		    echo "Warning: Group \"$xgroup\" seems empty." 1>&2
+		else
+		    trim_test_list $group_list
 		fi
 
-		trim_test_list $group_list
 		;;
 
 	-X)	xfile=$2; shift ;
-- 
1.7.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
