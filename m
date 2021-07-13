Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48025C07E95
	for <linux-xfs@archiver.kernel.org>; Tue, 13 Jul 2021 23:53:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0B5966128E
	for <linux-xfs@archiver.kernel.org>; Tue, 13 Jul 2021 23:53:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236983AbhGMX4g (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 13 Jul 2021 19:56:36 -0400
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:46212 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235437AbhGMX4g (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 13 Jul 2021 19:56:36 -0400
Received: from dread.disaster.area (pa49-181-34-10.pa.nsw.optusnet.com.au [49.181.34.10])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 2480B1045246
        for <linux-xfs@vger.kernel.org>; Wed, 14 Jul 2021 09:53:32 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1m3SDS-006EuK-T6
        for linux-xfs@vger.kernel.org; Wed, 14 Jul 2021 09:53:30 +1000
Received: from dave by discord.disaster.area with local (Exim 4.94)
        (envelope-from <david@fromorbit.com>)
        id 1m3SDS-00AsCJ-LM
        for linux-xfs@vger.kernel.org; Wed, 14 Jul 2021 09:53:30 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH] libxfs-apply: support filterdiff >= 0.4.2 only
Date:   Wed, 14 Jul 2021 09:53:30 +1000
Message-Id: <20210713235330.2591572-1-david@fromorbit.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=Tu+Yewfh c=1 sm=1 tr=0
        a=hdaoRb6WoHYrV466vVKEyw==:117 a=hdaoRb6WoHYrV466vVKEyw==:17
        a=e_q4qTt1xDgA:10 a=20KFwNOVAAAA:8 a=5xOlfOR4AAAA:8 a=7-415B0cAAAA:8
        a=7HMVMU26m-sjItLBmGoA:9 a=SGlsW6VomvECssOqsvzv:22
        a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

We currently require filterdiff v0.3.4 as a minimum for handling git
based patches. This was the first version to handle git diff
metadata well enough to do patch reformatting. It was, however, very
buggy and required several workarounds to get it to do what we
needed.

However, these bugs have been fixed and on a machine with v0.4.2,
the workarounds result in libxfs-apply breaking and creating corrupt
patches. Rather than try to carry around workarounds for a broken
filterdiff version and one that just works, just increase the
minimum required version to 0.4.2 and remove all the workarounds for
the bugs in 0.3.4.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 tools/libxfs-apply | 42 +++++++++++++++++-------------------------
 1 file changed, 17 insertions(+), 25 deletions(-)

diff --git a/tools/libxfs-apply b/tools/libxfs-apply
index 9271db380198..097a695f942b 100755
--- a/tools/libxfs-apply
+++ b/tools/libxfs-apply
@@ -30,21 +30,22 @@ fail()
 	exit
 }
 
-# filterdiff 0.3.4 is the first version that handles git diff metadata (almost)
-# correctly. It just doesn't work properly in prior versions, so those versions
-# can't be used to extract the commit message prior to the diff. Hence just
-# abort and tell the user to upgrade if an old version is detected. We need to
+# filterdiff didn't start handling git diff metadata correctly until some time
+# after 0.3.4. The handling in 0.3.4 was buggy and broken, requiring working
+# around that bugs to use it. Now that 0.4.2 has fixed all those bugs, the
+# work-arounds for 0.3.4 do not work. Hence set 0.4.2 as the minimum required
+# version and tell the user to upgrade if an old version is detected. We need to
 # check against x.y.z version numbers here.
 _version=`filterdiff --version | cut -d " " -f 5`
 _major=`echo $_version | cut -d "." -f 1`
 _minor=`echo $_version | cut -d "." -f 2`
 _patch=`echo $_version | cut -d "." -f 3`
 if [ $_major -eq 0 ]; then
-	if [ $_minor -lt 3 ]; then
-		fail "filterdiff $_version found. 0.3.4 or greater is required."
+	if [ $_minor -lt 4 ]; then
+		fail "filterdiff $_version found. 0.4.2 or greater is required."
 	fi
-	if [ $_minor -eq 3 -a $_patch -le 3 ]; then
-		fail "filterdiff $_version found. 0.3.4 or greater is required."
+	if [ $_minor -eq 4 -a $_patch -lt 2 ]; then
+		fail "filterdiff $_version found. 0.4.2 or greater is required."
 	fi
 fi
 
@@ -158,8 +159,7 @@ filter_kernel_patch()
 			--addoldprefix=a/fs/xfs/ \
 			--addnewprefix=b/fs/xfs/ \
 			$_patch | \
-		sed -e 's, [ab]\/fs\/xfs\/\(\/dev\/null\), \1,' \
-		    -e '/^diff --git/d'
+		sed -e 's, [ab]\/fs\/xfs\/\(\/dev\/null\), \1,'
 
 
 	rm -f $_libxfs_files
@@ -187,8 +187,7 @@ filter_xfsprogs_patch()
 			--addoldprefix=a/ \
 			--addnewprefix=b/ \
 			$_patch | \
-		sed -e 's, [ab]\/\(\/dev\/null\), \1,' \
-		    -e '/^diff --git/d'
+		sed -e 's, [ab]\/\(\/dev\/null\), \1,'
 
 	rm -f $_libxfs_files
 }
@@ -209,30 +208,23 @@ fixup_header_format()
 	local _diff=`mktemp`
 	local _new_hdr=$_hdr.new
 
-	# there's a bug in filterdiff that leaves a line at the end of the
-	# header in the filtered git show output like:
-	#
-	# difflibxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
-	#
-	# split the header on that (convenient!)
-	sed -e /^difflib/q $_patch > $_hdr
+	# Split the header on the first ^diff --git line (convenient!)
+	sed -e /^diff/q $_patch > $_hdr
 	cat $_patch | awk '
-		BEGIN { difflib_seen = 0; index_seen = 0 }
-		/^difflib/ { difflib_seen++; next }
+		BEGIN { diff_seen = 0; index_seen = 0 }
+		/^diff/ { diff_seen++; next }
 		/^index/ { if (++index_seen == 1) { next } }
-		// { if (difflib_seen) { print $0 } }' > $_diff
+		// { if (diff_seen) { print $0 } }' > $_diff
 
 	# the header now has the format:
 	# commit 0d5a75e9e23ee39cd0d8a167393dcedb4f0f47b2
 	# Author: Eric Sandeen <sandeen@sandeen.net>
 	# Date:   Wed Jun 1 17:38:15 2016 +1000
-	# 
+	#
 	#     xfs: make several functions static
 	#....
 	#     Signed-off-by: Dave Chinner <david@fromorbit.com>
 	#
-	#difflibxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
-	#
 	# We want to format it like a normal patch with a line to say what repo
 	# and commit it was sourced from:
 	#
-- 
2.31.1

