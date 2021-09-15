Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DCEA2C433F5
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Sep 2021 23:42:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C6C1861164
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Sep 2021 23:42:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233094AbhIOXn0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 15 Sep 2021 19:43:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:45348 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233162AbhIOXnZ (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 15 Sep 2021 19:43:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3A0BD60F25;
        Wed, 15 Sep 2021 23:42:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631749326;
        bh=J6afXhYUJhfjvhm0Oj2J5P5yH5fOBL3R9W15pHLq2Lg=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=E3n+Zp84s+IH+rZrj35kM78Ny/4SQylyOb+EdqPYID9OQ/O3/p4agepAr+KpFDIhs
         pDqOTqt7Bq7Wmh8utzJWAm6TzbVrapncfI4MGkJV4Bu6sWZtq09KGxpzMr4itTyIJ7
         wr/vquWyeKUR9toFBs6OAWY9c9EW3x9VdO/p4plekeSrGyX7jFll2DYyRgWzcZLPke
         JmiaEsFSmoEKZESDD82HlMfdJSxJ7+GQq06tOaofaWWU30qH15+QdeBWNUwNcc9LN/
         g4+AF0i4lg1XcNvo/xxrFif6cR9CfaBiWGueOAHBctwCfqBt98N63l3sTDIqFz4ixH
         DQElebDKeJ7yQ==
Subject: [PATCH 1/1] common/rc: re-fix detection of device-mapper/persistent
 memory incompatibility
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, guaneryu@gmail.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Wed, 15 Sep 2021 16:42:06 -0700
Message-ID: <163174932597.379383.18426474248994143835.stgit@magnolia>
In-Reply-To: <163174932046.379383.10637812567210248503.stgit@magnolia>
References: <163174932046.379383.10637812567210248503.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

In commit e05491b3, I tried to resolve false test failures that were a
result of device mapper refusing to change access modes on a block
device that supports the FSDAX access mode.  Unfortunately, I did not
realize that there are two ways that fsdax support can be detected via
sysfs: /sys/block/XXX/queue/dax and /sys/block/XXX/dax/, so I only added
a test for the latter.

As of 5.15-rc1 this doesn't seem to work anymore for some reason.  I
don't know enough about the byzantine world of pmem device driver
initialization, but fsdax mode actually does work even though the
/sys/block/XXX/dax/ path went away.  So clearly we have to detect it
via the other sysfs path.

Fixes: e05491b3 ("common/rc: fix detection of device-mapper/persistent memory incompatibility")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 common/rc |   18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)


diff --git a/common/rc b/common/rc
index 154bc2dd..275b1f24 100644
--- a/common/rc
+++ b/common/rc
@@ -1964,6 +1964,20 @@ _require_sane_bdev_flush()
 	fi
 }
 
+# Decide if the scratch filesystem is likely to be mounted in fsdax mode.
+# If there's a dax clause in the mount options we assume the test runner
+# wants us to test DAX; or if the scratch device itself advertises dax mode
+# in sysfs.
+__detect_scratch_fsdax()
+{
+	_normalize_mount_options | egrep -q "dax(=always| |$)" && return 0
+
+	local sysfs="/sys/block/$(_short_dev $SCRATCH_DEV)"
+	test -e "${sysfs}/dax" && return 0
+	test "$(cat "${sysfs}/queue/dax" 2>/dev/null)" = "1" && return 0
+	return 1
+}
+
 # this test requires a specific device mapper target
 _require_dm_target()
 {
@@ -1975,9 +1989,7 @@ _require_dm_target()
 	_require_sane_bdev_flush $SCRATCH_DEV
 	_require_command "$DMSETUP_PROG" dmsetup
 
-	_normalize_mount_options | egrep -q "dax(=always| |$)" || \
-			test -e "/sys/block/$(_short_dev $SCRATCH_DEV)/dax"
-	if [ $? -eq 0 ]; then
+	if __detect_scratch_fsdax; then
 		case $target in
 		stripe|linear|log-writes)
 			;;

