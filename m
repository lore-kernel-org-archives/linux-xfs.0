Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D65F1CE79A5
	for <linux-xfs@archiver.kernel.org>; Mon, 25 Sep 2023 21:42:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233429AbjIYVnE (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 25 Sep 2023 17:43:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231358AbjIYVnD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 25 Sep 2023 17:43:03 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDE0DA3;
        Mon, 25 Sep 2023 14:42:56 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C37EC433C7;
        Mon, 25 Sep 2023 21:42:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1695678176;
        bh=Y/YqlZQAYBm3mDj+1uXjgj5Xp1EKKzQzCKzWTpHjPqw=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=puP6+fTPqRpS0z8UvJKZ49h3mUwijikTFgxM00lwZtXxFu6aPeohN7ulnqrLGtmIB
         TGqiyllaSo1WgxevESR9Sj1evrdi0CGVBDRXrnhJubDME+8KvGi/mzJUsilOI5ie9z
         lTLAUqIM9FLKwKQjCh0/F5w8I5KEEbYkY3PdqNaKytSTen4+6C8ZYUQIzhI8h7um5x
         pKwi9LORiVZdcJiwa2VnozeKpNvEt4A5BOnFMYAF/9rFUZ9yhH+5HunIAxBAj0kvKq
         L30yoQXL+jmvUkQTHr83Xkrv4Ka2x3/EGcgouSxIRLZ5c6KdkESisn4JoOqi6U1iek
         hrwYSperEW5yA==
Subject: [PATCH 1/1] xfs/270: update commit id for _fixed_by tag.
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, zlang@redhat.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me,
        david@fromorbit.com, sandeen@sandeen.net
Date:   Mon, 25 Sep 2023 14:42:56 -0700
Message-ID: <169567817607.2269889.5897696336492740125.stgit@frogsfrogsfrogs>
In-Reply-To: <169567817047.2269889.16262169848413312221.stgit@frogsfrogsfrogs>
References: <169567817047.2269889.16262169848413312221.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Update the commit id in the _fixed_by tag now that we've merged the
kernel fix.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 tests/xfs/270 |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/tests/xfs/270 b/tests/xfs/270
index 7d4e1f6a87..4e4f767dc1 100755
--- a/tests/xfs/270
+++ b/tests/xfs/270
@@ -17,7 +17,7 @@ _begin_fstest auto quick mount
 
 # real QA test starts here
 _supported_fs xfs
-_fixed_by_kernel_commit xxxxxxxxxxxx \
+_fixed_by_kernel_commit 74ad4693b647 \
 	"xfs: fix log recovery when unknown rocompat bits are set"
 # skip fs check because superblock contains unknown ro-compat features
 _require_scratch_nocheck

