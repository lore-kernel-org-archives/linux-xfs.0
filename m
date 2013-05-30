Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id DA9D77F37
	for <xfs@oss.sgi.com>; Thu, 30 May 2013 17:32:53 -0500 (CDT)
Received: from xmail.sgi.com (pv-excas1-dc21.corp.sgi.com [137.38.106.7])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 5B5CDAC001
	for <xfs@oss.sgi.com>; Thu, 30 May 2013 15:32:50 -0700 (PDT)
Message-ID: <51A7D390.3040108@sgi.com>
Date: Thu, 30 May 2013 17:32:48 -0500
From: Rich Johnston <rjohnston@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH V2] xfstests: Fix test wildcard expansion.
References: <51A7CC6B.3030607@sgi.com>
In-Reply-To: <51A7CC6B.3030607@sgi.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfstests <xfs@oss.sgi.com>


Before commit 38d58591 "xfstests: fix typo in check",
check xfs/[0-9]?? would execute all tests/xfs/[0-9]?? because:

Change to use egrep to fix the parsing.

Signed-off-by: Rich Johnston <rjohnston@sgi.com>
---
V1-V2
Use egrep instead of my bulky method

diff --git a/check b/check
index 8d32486..ff8fbcf 100755
--- a/check
+++ b/check
@@ -242,7 +242,7 @@ if $have_test_arg; then
  			test_name=`basename $1`
  			group_file=$SRC_DIR/$test_dir/group

-			if grep "^$test_name" $group_file >/dev/null ; then
+			if egrep "^$test_name" $group_file >/dev/null ; then
  				# in group file ... OK
  				echo $SRC_DIR/$1 >>$tmp.list
  			else


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
