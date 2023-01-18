Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C76BDC00A5A
	for <linux-xfs@archiver.kernel.org>; Wed, 18 Jan 2023 00:55:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230106AbjARAzO (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 17 Jan 2023 19:55:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229918AbjARAyj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 17 Jan 2023 19:54:39 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6E305086C;
        Tue, 17 Jan 2023 16:42:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 273B3B81A8C;
        Wed, 18 Jan 2023 00:42:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE016C433EF;
        Wed, 18 Jan 2023 00:42:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674002549;
        bh=19ow3edlw8Rsikbi5VudHOFuvJvXwyRdvWaA/MAX0l4=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=L4gVK92bm29srK45fMM8uZo4SkURroE4CQdTgTG2G+mZykbjUcyBhEPzS0F6JOf08
         7csP0DO2SOAuGQiWg4iitybooQIWp9dv6u7qrkafl1p6TstIvL1euJtaJGRrlGtS9l
         HC2AC82j3ZTq3qLoHIdc8EYbAnqZZvE5f9RdIZqUPJyivfm1Z88XLR6nutKy6db2AF
         nFOEN+n6O316p8CABHc6ywJ50GtABUBEOts6paL2LidS51j16eDhvemEwoVzzv68cK
         rEWzE1IKQGiPyStWgvfABvqlyAWteEC0yOgypHmxoWFEqUrWmt+pmee9yMt7Z7AzWz
         sf3R5p6WceePg==
Date:   Tue, 17 Jan 2023 16:42:29 -0800
Subject: [PATCH 2/3] xfs: fix reflink test failures when dax is enabled
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, zlang@redhat.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me,
        yangx.jy@fujitsu.com
Message-ID: <167400102472.1914858.16726369189467075623.stgit@magnolia>
In-Reply-To: <167400102444.1914858.13132645140135239531.stgit@magnolia>
References: <167400102444.1914858.13132645140135239531.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Turn off reflink tests that require delayed allocation to work, because
we don't use delayed allocation when fsdax mode is turned on.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 tests/xfs/184 |    1 +
 tests/xfs/192 |    1 +
 tests/xfs/200 |    1 +
 tests/xfs/204 |    1 +
 tests/xfs/232 |    1 +
 tests/xfs/440 |    1 +
 6 files changed, 6 insertions(+)


diff --git a/tests/xfs/184 b/tests/xfs/184
index c251040e8a..3bdd86addf 100755
--- a/tests/xfs/184
+++ b/tests/xfs/184
@@ -19,6 +19,7 @@ _begin_fstest auto quick clone fiemap unshare
 
 # real QA test starts here
 _supported_fs xfs
+_require_scratch_delalloc
 _require_scratch_reflink
 _require_cp_reflink
 _require_xfs_io_command "fiemap"
diff --git a/tests/xfs/192 b/tests/xfs/192
index 85ed7a48fc..ced18fa3c1 100755
--- a/tests/xfs/192
+++ b/tests/xfs/192
@@ -19,6 +19,7 @@ _begin_fstest auto quick clone fiemap unshare
 
 # real QA test starts here
 _supported_fs xfs
+_require_scratch_delalloc
 _require_scratch_reflink
 _require_cp_reflink
 _require_xfs_io_command "fiemap"
diff --git a/tests/xfs/200 b/tests/xfs/200
index f91bfbf478..b51b9a54f5 100755
--- a/tests/xfs/200
+++ b/tests/xfs/200
@@ -21,6 +21,7 @@ _begin_fstest auto quick clone fiemap unshare
 
 # real QA test starts here
 _supported_fs xfs
+_require_scratch_delalloc
 _require_scratch_reflink
 _require_cp_reflink
 _require_xfs_io_command "fiemap"
diff --git a/tests/xfs/204 b/tests/xfs/204
index d034446bbc..ca21dfe722 100755
--- a/tests/xfs/204
+++ b/tests/xfs/204
@@ -21,6 +21,7 @@ _begin_fstest auto quick clone fiemap unshare
 
 # real QA test starts here
 _supported_fs xfs
+_require_scratch_delalloc
 _require_scratch_reflink
 _require_cp_reflink
 _require_xfs_io_command "fiemap"
diff --git a/tests/xfs/232 b/tests/xfs/232
index f402ad6cf3..59bbc43686 100755
--- a/tests/xfs/232
+++ b/tests/xfs/232
@@ -30,6 +30,7 @@ _cleanup()
 
 # real QA test starts here
 _supported_fs xfs
+_require_scratch_delalloc
 _require_xfs_io_command "cowextsize"
 _require_scratch_reflink
 _require_cp_reflink
diff --git a/tests/xfs/440 b/tests/xfs/440
index 496ee04edf..368ee8a05d 100755
--- a/tests/xfs/440
+++ b/tests/xfs/440
@@ -20,6 +20,7 @@ _begin_fstest auto quick clone quota
 _supported_fs xfs
 
 _require_quota
+_require_scratch_delalloc
 _require_scratch_reflink
 _require_cp_reflink
 _require_user

