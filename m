Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B324C636D6
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Feb 2023 21:16:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229830AbjBPVQr (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Feb 2023 16:16:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229741AbjBPVQq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Feb 2023 16:16:46 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 587AE3B864;
        Thu, 16 Feb 2023 13:16:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 09401B828F3;
        Thu, 16 Feb 2023 21:16:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6E41C433D2;
        Thu, 16 Feb 2023 21:16:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676582202;
        bh=SNZMUJmgZ801vECqX41o4i3O8/trkBJpr6nqBKNOpcg=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=cXtMSyXe5TpSUXhy9qFaI6AfD8J/xhJlzoalxJQoB4/mbrkSmRnJuPpugCOjG22lA
         u9MMuvadKIu/N8VZbEQjjusYm3n4/Lk8ALMHd8YIJfr6btISOOZIeX+1PGpLRKkejX
         rL6pcojqFpOylSpoRmkdVlFGqdH/DQY7f3wEon2UCLDjqdaf+ym2ffWwb/Pms9Sdtq
         fnfh4XrfOWIgX4rzNQq/AL5wqcoc1Ys/DvBx6YeffGy5c/MK/a2i5LDOPAj0BIySs1
         3QsF3aG70QVtEdIA2HSE8STiShWR5ziuHVpOkMQYJMK2QbFtPw/M703pU1AbetVR9D
         ViyW0y8XfzeOg==
Date:   Thu, 16 Feb 2023 13:16:42 -0800
Subject: [PATCH 12/14] common/parent: don't _fail on missing parent pointer
 components
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, zlang@redhat.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Message-ID: <167657884648.3481377.7584825166252358074.stgit@magnolia>
In-Reply-To: <167657884480.3481377.14824439551809919632.stgit@magnolia>
References: <167657884480.3481377.14824439551809919632.stgit@magnolia>
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
index a734a8017d..7e63765d56 100644
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

