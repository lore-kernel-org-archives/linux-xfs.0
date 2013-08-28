Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id E20417F37
	for <xfs@oss.sgi.com>; Wed, 28 Aug 2013 01:24:22 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 621A9AC00C
	for <xfs@oss.sgi.com>; Tue, 27 Aug 2013 23:24:19 -0700 (PDT)
Received: from e28smtp03.in.ibm.com (e28smtp03.in.ibm.com [122.248.162.3]) by
	cuda.sgi.com with ESMTP id 2oVtCcFA47TOpSgx (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 27 Aug 2013 23:24:17 -0700 (PDT)
Received: from /spool/local
	by e28smtp03.in.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use
	Only! Violators will be prosecuted
	for <xfs@oss.sgi.com> from <chandan@linux.vnet.ibm.com>;
	Wed, 28 Aug 2013 11:46:21 +0530
Received: from d28relay03.in.ibm.com (d28relay03.in.ibm.com [9.184.220.60])
	by d28dlp01.in.ibm.com (Postfix) with ESMTP id 5FC3CE0055
	for <xfs@oss.sgi.com>; Wed, 28 Aug 2013 11:54:47 +0530 (IST)
Received: from d28av05.in.ibm.com (d28av05.in.ibm.com [9.184.220.67])
	by d28relay03.in.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id
	r7S6Pn7m46792724
	for <xfs@oss.sgi.com>; Wed, 28 Aug 2013 11:55:49 +0530
Received: from d28av05.in.ibm.com (localhost [127.0.0.1])
	by d28av05.in.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id
	r7S6OAiI025189 for <xfs@oss.sgi.com>; Wed, 28 Aug 2013 11:54:10 +0530
From: chandan <chandan@linux.vnet.ibm.com>
Subject: [PATCH] xfstests: _test_generic_punch: Obtain block size from
	$TEST_DIR
Date: Wed, 28 Aug 2013 11:54:10 +0530
Message-ID: <2632380.gCujKLhaaV@localhost.localdomain>
MIME-Version: 1.0
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
Cc: Eric Sandeen <sandeen@redhat.com>, Eric Sandeen <sandeen@sandeen.net>, sekharan@linux.vnet.ibm.com

The current code incorrectly gets block size information from $TEST_DEV
instead of from $TEST_DIR. This returns the block size of the filesystem
hosting the device file rather than that of the filesystem on $TEST_DEV.

Signed-off-by: chandan <chandan@linux.vnet.ibm.com>
---
 common/punch | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/common/punch b/common/punch
index 7b3c009..a49638c 100644
--- a/common/punch
+++ b/common/punch
@@ -520,7 +520,7 @@ _test_generic_punch()
 	if [ "$remove_testfile" ]; then
 		rm -f $testfile
 	fi
-	block_size=`stat -f $TEST_DEV | grep "Block size" | cut -d " " -f3`
+	block_size=`stat -f $TEST_DIR | grep "Block size" | cut -d " " -f3`
 	$XFS_IO_PROG -f -c "truncate $block_size" \
 		-c "pwrite 0 $block_size" $sync_cmd \
 		-c "$zero_cmd 128 128" \
-- 
1.8.3.1


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
