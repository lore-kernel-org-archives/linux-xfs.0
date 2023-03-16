Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 485B2C6FD1F
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Mar 2023 19:36:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230076AbjCPTgH (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Mar 2023 15:36:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229654AbjCPTgH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Mar 2023 15:36:07 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEB0537569;
        Thu, 16 Mar 2023 12:36:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 79562B82290;
        Thu, 16 Mar 2023 19:36:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CBA3C433EF;
        Thu, 16 Mar 2023 19:36:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678995363;
        bh=t15N+t2ceXCz/MHzlbqwcMkzvlNu7VE7tzxYy9MKrs4=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=mLt8+b8W10ZIXO8TlmUwUbfQj7NLW4kzM6b/Zs5vTrF0M2rXtgXt7zTHNzSmJZXF3
         astZMLkeZ0B0HNhZ/fgeqWKXgo8CrpSb1qUNsiqYUY7/0V8+ZpEhuZPUAoTrie8wmK
         TnJqqfJYnX6vDF7YjrjG3xBF7vIo1T8dqabj3cnyf1W4OW7Weq5HK2oWvfaOadjXr3
         Tg42NlOtJzwQ8brqISYcKyS5y8fBH2VDuVCw2QCclPS8+dRghF4sHONyutkNSe0ylr
         MdXRWCKrwZCX1NCE/98FoFoALImXoFaFEar65uGyM4VGEKL5DGxO2TOR5PDS/yAygi
         ag4rKp3NDXWew==
Date:   Thu, 16 Mar 2023 12:36:02 -0700
Subject: [PATCH 12/14] common/parent: don't _fail on missing parent pointer
 components
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     zlang@redhat.com, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Message-ID: <167899417813.17926.14215192792910288359.stgit@frogsfrogsfrogs>
In-Reply-To: <167899417650.17926.7405859750613330339.stgit@frogsfrogsfrogs>
References: <167899417650.17926.7405859750613330339.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Use echo instead of _fail here so that we run as much of the test as
possible.  There's no need to stop the test immediately even if the pptr
code isn't working.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 common/parent |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)


diff --git a/common/parent b/common/parent
index 2d52404c39..8d007bd9ad 100644
--- a/common/parent
+++ b/common/parent
@@ -105,21 +105,21 @@ _verify_parent()
 
 	# Verify parent exists
 	if [ ! -d $SCRATCH_MNT/$parent_path ]; then
-		_fail "$SCRATCH_MNT/$parent_path not found"
+		echo "$SCRATCH_MNT/$parent_path not found"
 	else
 		echo "*** $parent_path OK"
 	fi
 
 	# Verify child exists
 	if [ ! -f $SCRATCH_MNT/$child_path ]; then
-		_fail "$SCRATCH_MNT/$child_path not found"
+		echo "$SCRATCH_MNT/$child_path not found"
 	else
 		echo "*** $child_path OK"
 	fi
 
 	# Verify the parent pointer name exists as a child of the parent
 	if [ ! -f $SCRATCH_MNT/$parent_ppath ]; then
-		_fail "$SCRATCH_MNT/$parent_ppath not found"
+		echo "$SCRATCH_MNT/$parent_ppath not found"
 	else
 		echo "*** $parent_ppath OK"
 	fi
@@ -132,7 +132,7 @@ _verify_parent()
 	parents=($($XFS_IO_PROG -x -c \
 	 "parent -f -i $pino -n $parent_pointer_name" $SCRATCH_MNT/$child_path))
 	if [[ $? != 0 ]]; then
-		 _fail "No parent pointers found for $child_path"
+		 echo "No parent pointers found for $child_path"
 	fi
 
 	# Parse parent pointer output.
@@ -141,7 +141,7 @@ _verify_parent()
 
 	# If we didnt find one, bail out
 	if [ $? -ne 0 ]; then
-		_fail "No parent pointer record found for $parent_path"\
+		echo "No parent pointer record found for $parent_path"\
 			"in $child_path"
 	fi
 
@@ -150,7 +150,7 @@ _verify_parent()
 	pppino="$(stat -c '%i' $SCRATCH_MNT/$parent_ppath)"
 	if [ $cino -ne $pppino ]
 	then
-		_fail "Bad parent pointer name value for $child_path."\
+		echo "Bad parent pointer name value for $child_path."\
 			"$SCRATCH_MNT/$parent_ppath belongs to inode $PPPINO,"\
 			"but should be $cino"
 	fi
@@ -174,7 +174,7 @@ _verify_no_parent()
 
 	# Verify child exists
 	if [ ! -f $SCRATCH_MNT/$child_path ]; then
-		_fail "$SCRATCH_MNT/$child_path not found"
+		echo "$SCRATCH_MNT/$child_path not found"
 	else
 		echo "*** $child_path OK"
 	fi
@@ -195,7 +195,7 @@ _verify_no_parent()
 		return 0
 	fi
 
-	_fail "Parent pointer entry found where none should:"\
+	echo "Parent pointer entry found where none should:"\
 			"inode:$PPINO, gen:$PPGEN,"
 			"name:$PPNAME, namelen:$PPNAME_LEN"
 }

