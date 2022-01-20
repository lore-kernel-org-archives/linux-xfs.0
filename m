Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7EEE2C433F5
	for <linux-xfs@archiver.kernel.org>; Thu, 20 Jan 2022 00:22:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345141AbiATAWJ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 19 Jan 2022 19:22:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240471AbiATAWJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 19 Jan 2022 19:22:09 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E6B0C061574
        for <linux-xfs@vger.kernel.org>; Wed, 19 Jan 2022 16:22:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D2E7F61516
        for <linux-xfs@vger.kernel.org>; Thu, 20 Jan 2022 00:22:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35F79C340E3;
        Thu, 20 Jan 2022 00:22:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642638128;
        bh=YJTp3cRwBoKpyFEyR8g0QuI1AOD9njSmO12skqT7J+g=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=O1ZJDRqmyBwTVMBNBVsyXeB2Tqa81clUqZDjbuYpCYgwblSWuKsNNQllZI0Gsxwjq
         0pk3miEQ0ZQ4265XuBdEzTniYmPhurwJe2w4RDy+wsSrCTSihoXjsOWWNpJx02rytT
         LGUWaIlBfBqwsKMN/mnMXrVmw78GrfHIo0tTa3+OO+u9v78RMMFfeL8H8hXXKJodtc
         CU30huO9J0vEPEJ8TlV9TdxH+emJfGc0BgAiYw1f1HRzoJbeiQCLQHrPg+lNmPikwO
         rl+UDMjdqKw4MtLjP3Q7n8kU3l/z9oBTDy370+BigdUFNU25cTmwqG/r3CKwQJdTqF
         b5vAbf5NEiXYg==
Subject: [PATCH 06/17] libxfs-apply: support filterdiff >= 0.4.2 only
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     Dave Chinner <dchinner@redhat.com>, linux-xfs@vger.kernel.org,
        allison.henderson@oracle.com
Date:   Wed, 19 Jan 2022 16:22:07 -0800
Message-ID: <164263812790.863810.4865922459784834091.stgit@magnolia>
In-Reply-To: <164263809453.863810.8908193461297738491.stgit@magnolia>
References: <164263809453.863810.8908193461297738491.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
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
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 tools/libxfs-apply |   42 +++++++++++++++++-------------------------
 1 file changed, 17 insertions(+), 25 deletions(-)


diff --git a/tools/libxfs-apply b/tools/libxfs-apply
index 9271db38..097a695f 100755
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

