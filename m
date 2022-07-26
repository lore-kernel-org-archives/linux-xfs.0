Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76C81C04A68
	for <linux-xfs@archiver.kernel.org>; Tue, 26 Jul 2022 19:49:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229672AbiGZTtQ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 26 Jul 2022 15:49:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239654AbiGZTtI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 26 Jul 2022 15:49:08 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A58F357CB;
        Tue, 26 Jul 2022 12:49:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CDF9F61564;
        Tue, 26 Jul 2022 19:49:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B31CC433C1;
        Tue, 26 Jul 2022 19:49:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658864946;
        bh=VOIgP4g/SVNT3suiuOXNzpJkLJvLj+G7jOTIBKZb7LY=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=u3yEpMXR1joQ2iPJBxZoS8yJBoZ9ZKrBafbIvhZCg4/NKsuL5EAC/IJoa0HnwSmZ5
         h1Y8H//zPPAznAyYaPPL96TDfrONYOW6dAalQ/RMChd7ZaWqW0eoEww72D0MFZWWT/
         gvlcdHBmNmhVH899nuJvABJn54732ePZhqLG7yzRmnT8P9tR6EPs9pDIt3rbKm7tho
         xLeKu1pENmxqgaye5qV29jHZhNdrGvOmol4U8c9AIOWZr9N8oWesP9OqrWwHSrTk7U
         LNvwUhw3DgEDCUwKVtFAtrTd6AjXNZG2tZYJjOPBSMHG3o9gGIzqreSAMG+zHfQc3y
         58IxLi6hPkDEw==
Subject: [PATCH 2/2] fail_make_request: teach helpers about external devices
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, guaneryu@gmail.com, zlang@redhat.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Tue, 26 Jul 2022 12:49:05 -0700
Message-ID: <165886494578.1585218.6398445606846645392.stgit@magnolia>
In-Reply-To: <165886493457.1585218.32410114728132213.stgit@magnolia>
References: <165886493457.1585218.32410114728132213.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Teach the fail_make_request helpers about external log and realtime
devices so that we can use generic/019 on exotic XFS configurations.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 common/fail_make_request |   28 ++++++++++++++++++++++------
 1 file changed, 22 insertions(+), 6 deletions(-)


diff --git a/common/fail_make_request b/common/fail_make_request
index 581d176a..9f8ea500 100644
--- a/common/fail_make_request
+++ b/common/fail_make_request
@@ -30,18 +30,34 @@ _disallow_fail_make_request()
     echo 0 > $DEBUGFS_MNT/fail_make_request/verbose
 }
 
+_bdev_fail_make_request()
+{
+    local bdev="$1"
+    local status="$2"
+    local sysfs_bdev=$(_sysfs_dev $bdev)
+
+    echo " echo $status > $sysfs_bdev/make-it-fail" >> $seqres.full
+    echo "$status" > $sysfs_bdev/make-it-fail
+}
+
 _start_fail_scratch_dev()
 {
-    local SYSFS_BDEV=`_sysfs_dev $SCRATCH_DEV`
     echo "Force SCRATCH_DEV device failure"
-    echo " echo 1 > $SYSFS_BDEV/make-it-fail" >> $seqres.full
-    echo 1 > $SYSFS_BDEV/make-it-fail
+
+    _bdev_fail_make_request $SCRATCH_DEV 1
+    [ "$USE_EXTERNAL" = yes -a ! -z "$SCRATCH_LOGDEV" ] && \
+        _bdev_fail_make_request $SCRATCH_LOGDEV 1
+    [ "$USE_EXTERNAL" = yes -a ! -z "$SCRATCH_RTDEV" ] && \
+        _bdev_fail_make_request $SCRATCH_RTDEV 1
 }
 
 _stop_fail_scratch_dev()
 {
-    local SYSFS_BDEV=`_sysfs_dev $SCRATCH_DEV`
     echo "Make SCRATCH_DEV device operable again"
-    echo " echo 0 > $SYSFS_BDEV/make-it-fail" >> $seqres.full
-    echo 0 > $SYSFS_BDEV/make-it-fail
+
+    [ "$USE_EXTERNAL" = yes -a ! -z "$SCRATCH_RTDEV" ] && \
+        _bdev_fail_make_request $SCRATCH_RTDEV 0
+    [ "$USE_EXTERNAL" = yes -a ! -z "$SCRATCH_LOGDEV" ] && \
+        _bdev_fail_make_request $SCRATCH_LOGDEV 0
+    _bdev_fail_make_request $SCRATCH_DEV 0
 }

