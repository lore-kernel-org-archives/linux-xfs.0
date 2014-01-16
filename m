Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 9416A29DF8
	for <xfs@oss.sgi.com>; Thu, 16 Jan 2014 11:07:24 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 5A83B8F8050
	for <xfs@oss.sgi.com>; Thu, 16 Jan 2014 09:07:24 -0800 (PST)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id kY4DLPei1ucemouf (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 16 Jan 2014 09:07:23 -0800 (PST)
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id DC0E4AC3E
	for <xfs@oss.sgi.com>; Thu, 16 Jan 2014 17:07:21 +0000 (UTC)
From: David Sterba <dsterba@suse.cz>
Subject: [PATCH 4/5] xfstests: accept tests/ prefix for test name on
	commandline
Date: Thu, 16 Jan 2014 18:07:14 +0100
Message-Id: <c126152c562d3aba42134874d838fda1f6e80d13.1389891730.git.dsterba@suse.cz>
In-Reply-To: <cover.1389891730.git.dsterba@suse.cz>
References: <cover.1389891730.git.dsterba@suse.cz>
In-Reply-To: <cover.1389891730.git.dsterba@suse.cz>
References: <cover.1389891730.git.dsterba@suse.cz>
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
index d578e49b78d4..a787c4a9f69f 100755
--- a/check
+++ b/check
@@ -263,12 +263,13 @@ if $have_test_arg; then
 			exit $status
 			;;
 		*)	test_dir=`dirname $1`
+			test_dir=${test_dir#$SRC_DIR/*}
 			test_name=`basename $1`
 			group_file=$SRC_DIR/$test_dir/group
 
 			if egrep "^$test_name" $group_file >/dev/null ; then
 				# in group file ... OK
-				echo $SRC_DIR/$1 >>$tmp.arglist
+				echo $SRC_DIR/$test_dir/$test_name >>$tmp.arglist
 			else
 				# oops
 				echo "$1 - unknown test, ignored"
-- 
1.8.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
