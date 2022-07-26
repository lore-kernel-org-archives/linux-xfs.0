Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE2BAC19F2B
	for <linux-xfs@archiver.kernel.org>; Tue, 26 Jul 2022 19:49:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239829AbiGZTtR (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 26 Jul 2022 15:49:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239654AbiGZTtQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 26 Jul 2022 15:49:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0571E357C7;
        Tue, 26 Jul 2022 12:49:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 97FD161588;
        Tue, 26 Jul 2022 19:49:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00281C433C1;
        Tue, 26 Jul 2022 19:49:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658864955;
        bh=djyo2JEBh3td34QgGNsyWl5ZLJ5jgS6nCmNZbIAPiGk=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=r8SN2XvpB5+7IvCOuIqzW/NPQptgEgS+U4OQaMqHQVXJSia8gXvwgLqKy3tLwK71A
         0C7ouvzUkFcr3sycz3TpyJhxL4vzabtD1Ih9f6Ra8um9QHWKmS7djvi9RVRhDMrnlv
         WqCdNJXw3gFPZOkLPjf7G9UafGpe4GJB/q3akvYZVRsIOgmw0taGWp/P/Nmw0fT4FL
         7KGYB/5Xnk6G9fefq7Cf3MhoGSQdQYu6rTkN1ojRTbxvtchwiOjvRM1RzdwFDXqQ3i
         1oZFXJ/gUydGEy0NmXBVCb1Pnyl/8Nm7qRku38XJpJcAW88U6OLOBcGW/Tz5ghALlW
         In47rTw1kqwwQ==
Subject: [PATCH 1/3] common/xfs: fix _reset_xfs_sysfs_error_handling reset to
 actual defaults
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, guaneryu@gmail.com, zlang@redhat.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Tue, 26 Jul 2022 12:49:14 -0700
Message-ID: <165886495460.1585306.10074516195471640063.stgit@magnolia>
In-Reply-To: <165886494905.1585306.15343417924888857310.stgit@magnolia>
References: <165886494905.1585306.15343417924888857310.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

There's a slight mistake in _reset_xfs_sysfs_error_handling: it sets
retry_timeout_seconds to 0, which is not the current default (-1) in
upstream Linux.  Fix this.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 common/xfs        |    2 +-
 tests/xfs/006.out |    6 +++---
 tests/xfs/264.out |   12 ++++++------
 3 files changed, 10 insertions(+), 10 deletions(-)


diff --git a/common/xfs b/common/xfs
index 9f84dffb..ba72027c 100644
--- a/common/xfs
+++ b/common/xfs
@@ -781,7 +781,7 @@ _reset_xfs_sysfs_error_handling()
 		_get_fs_sysfs_attr $dev error/metadata/${e}/max_retries
 
 		_set_fs_sysfs_attr $dev \
-				   error/metadata/${e}/retry_timeout_seconds 0
+				   error/metadata/${e}/retry_timeout_seconds -1
 		echo -n "error/metadata/${e}/retry_timeout_seconds="
 		_get_fs_sysfs_attr $dev \
 				   error/metadata/${e}/retry_timeout_seconds
diff --git a/tests/xfs/006.out b/tests/xfs/006.out
index 3260b3a2..433b0bc3 100644
--- a/tests/xfs/006.out
+++ b/tests/xfs/006.out
@@ -1,8 +1,8 @@
 QA output created by 006
 error/fail_at_unmount=1
 error/metadata/default/max_retries=-1
-error/metadata/default/retry_timeout_seconds=0
+error/metadata/default/retry_timeout_seconds=-1
 error/metadata/EIO/max_retries=-1
-error/metadata/EIO/retry_timeout_seconds=0
+error/metadata/EIO/retry_timeout_seconds=-1
 error/metadata/ENOSPC/max_retries=-1
-error/metadata/ENOSPC/retry_timeout_seconds=0
+error/metadata/ENOSPC/retry_timeout_seconds=-1
diff --git a/tests/xfs/264.out b/tests/xfs/264.out
index 502e72d3..e45ac5a5 100644
--- a/tests/xfs/264.out
+++ b/tests/xfs/264.out
@@ -2,20 +2,20 @@ QA output created by 264
 === Test EIO/max_retries ===
 error/fail_at_unmount=1
 error/metadata/default/max_retries=-1
-error/metadata/default/retry_timeout_seconds=0
+error/metadata/default/retry_timeout_seconds=-1
 error/metadata/EIO/max_retries=-1
-error/metadata/EIO/retry_timeout_seconds=0
+error/metadata/EIO/retry_timeout_seconds=-1
 error/metadata/ENOSPC/max_retries=-1
-error/metadata/ENOSPC/retry_timeout_seconds=0
+error/metadata/ENOSPC/retry_timeout_seconds=-1
 error/fail_at_unmount=0
 error/metadata/EIO/max_retries=1
 === Test EIO/retry_timeout_seconds ===
 error/fail_at_unmount=1
 error/metadata/default/max_retries=-1
-error/metadata/default/retry_timeout_seconds=0
+error/metadata/default/retry_timeout_seconds=-1
 error/metadata/EIO/max_retries=-1
-error/metadata/EIO/retry_timeout_seconds=0
+error/metadata/EIO/retry_timeout_seconds=-1
 error/metadata/ENOSPC/max_retries=-1
-error/metadata/ENOSPC/retry_timeout_seconds=0
+error/metadata/ENOSPC/retry_timeout_seconds=-1
 error/fail_at_unmount=0
 error/metadata/EIO/retry_timeout_seconds=1

