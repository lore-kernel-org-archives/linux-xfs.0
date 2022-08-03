Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DFE24C3F6B0
	for <linux-xfs@archiver.kernel.org>; Wed,  3 Aug 2022 04:22:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235525AbiHCEWZ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 3 Aug 2022 00:22:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233637AbiHCEWY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 3 Aug 2022 00:22:24 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D54FD558F7;
        Tue,  2 Aug 2022 21:22:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 84245B82189;
        Wed,  3 Aug 2022 04:22:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35EB3C4347C;
        Wed,  3 Aug 2022 04:22:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659500541;
        bh=K+JkoKbltQEHGPAcK1s7C616KoQJgcIhXxgNtTnm5/g=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=DiSz1vcEoRgztJR7taoKXVkGc+qJuGIM5yI/PJnWmWci2f4ssEAkZgm+2MU+ubcOl
         ilUmqi4yMsktPkFz9o9tCLBjbhHjClSEZU5WNqiTL3NW9j9uSMPOBHMGQCYwcUiGJ7
         JcWPdhG+HOjQbCCxDmktw6/lP0poYdQyAx0ZWXgnuZSs9K95k+1yaROdjl+9jLtAYI
         RE0yf+RqoXhaR2sSX+NKx56mRaMjn4/4nbVpNUvW/WM67b5ccAodQf8jANc9u5BZjX
         P/3IdPBcJXaMoLX841BhF74c2e823kt65V9uO2zpbhtDJHBjuBpuXO2YZDwrllt471
         wD4SWuCijqprA==
Subject: [PATCH 2/2] fail_make_request: teach helpers about external devices
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, guaneryu@gmail.com, zlang@redhat.com
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org, guan@eryu.me
Date:   Tue, 02 Aug 2022 21:22:20 -0700
Message-ID: <165950054077.199134.460570469384371889.stgit@magnolia>
In-Reply-To: <165950052948.199134.11841652463463547824.stgit@magnolia>
References: <165950052948.199134.11841652463463547824.stgit@magnolia>
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
Reviewed-by: Christoph Hellwig <hch@lst.de>
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

