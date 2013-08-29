Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 825F07F3F
	for <xfs@oss.sgi.com>; Thu, 29 Aug 2013 06:09:08 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 703DE8F8050
	for <xfs@oss.sgi.com>; Thu, 29 Aug 2013 04:09:05 -0700 (PDT)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id 5UZ5mUXE5Mvov7be for <xfs@oss.sgi.com>;
	Thu, 29 Aug 2013 04:09:04 -0700 (PDT)
Received: from relay1.suse.de (unknown [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id 834AEA52BF
	for <xfs@oss.sgi.com>; Thu, 29 Aug 2013 13:09:03 +0200 (CEST)
From: David Sterba <dsterba@suse.cz>
Subject: [PATCH] xfstests: accept tests/ prefix for test name on commandline
Date: Thu, 29 Aug 2013 13:09:01 +0200
Message-Id: <1377774541-10120-1-git-send-email-dsterba@suse.cz>
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
Cc: David Sterba <dsterba@suse.cz>

Just for convenience to let tab completion or shell globs work (files
that are not in the group file are ignored).

Signed-off-by: David Sterba <dsterba@suse.cz>
---
 check | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/check b/check
index 4085eae..51b1d8e 100755
--- a/check
+++ b/check
@@ -235,12 +235,13 @@ if $have_test_arg; then
 			exit $status
 			;;
 		*)	test_dir=`dirname $1`
+			test_dir=${test_dir#$SRC_DIR/*}
 			test_name=`basename $1`
 			group_file=$SRC_DIR/$test_dir/group
 
 			if egrep "^$test_name" $group_file >/dev/null ; then
 				# in group file ... OK
-				echo $SRC_DIR/$1 >>$tmp.list
+				echo $SRC_DIR/$test_dir/$test_name >>$tmp.list
 			else
 				# oops
 				echo "$1 - unknown test, ignored"
-- 
1.8.3.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
