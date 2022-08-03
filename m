Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA2EBC19F28
	for <linux-xfs@archiver.kernel.org>; Wed,  3 Aug 2022 04:22:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233759AbiHCEWe (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 3 Aug 2022 00:22:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233637AbiHCEWd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 3 Aug 2022 00:22:33 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A77B1564F7;
        Tue,  2 Aug 2022 21:22:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6191BB82189;
        Wed,  3 Aug 2022 04:22:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 115C1C433C1;
        Wed,  3 Aug 2022 04:22:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659500550;
        bh=fwLneSQEvK1E2ZbQamoDrrp9wiNA/G3mQjzy/FdIltI=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=iif+VMjFguKvWoknLCrY0IHIDuo4E2QxksZ5RFC5BbGIb7dEUy0EFZcWUO5tpJ1TS
         geslCbq0uIqFEwlSPOvSapApLYKBctN14C6n62tcsvlG/1h7Jd7o0e+mo1zcJbbgS6
         05zIhFpJKQR+KrwkfHdn+wwANgdelUHjoJn1YdMa+qJ3i15wNuEmrgUWZofHllS1Ys
         E7TVM1uhYIy+SspF/oYK/zVoIGiiZGtkGc2ChxcEXWmF5i2Buu4wI6foVEqk9kdxBT
         vH4/DKD9Si1SjOKRePp2qu9WrQEBbMXnYd8xk/1MI5Qd8TKalOn3aBEo5KqGllMwyj
         WS7UPI9ORCGqA==
Subject: [PATCH 1/3] common/xfs: fix _reset_xfs_sysfs_error_handling reset to
 actual defaults
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, guaneryu@gmail.com, zlang@redhat.com
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org, guan@eryu.me
Date:   Tue, 02 Aug 2022 21:22:29 -0700
Message-ID: <165950054961.199222.14288700692275773893.stgit@magnolia>
In-Reply-To: <165950054404.199222.5615656337332007333.stgit@magnolia>
References: <165950054404.199222.5615656337332007333.stgit@magnolia>
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
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 common/xfs        |    2 +-
 tests/xfs/006.out |    6 +++---
 tests/xfs/264.out |   12 ++++++------
 3 files changed, 10 insertions(+), 10 deletions(-)


diff --git a/common/xfs b/common/xfs
index f6f4cdd2..92c281c6 100644
--- a/common/xfs
+++ b/common/xfs
@@ -804,7 +804,7 @@ _reset_xfs_sysfs_error_handling()
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

