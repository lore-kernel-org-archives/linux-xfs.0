Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3575C433E9
	for <linux-xfs@archiver.kernel.org>; Wed,  3 Mar 2021 03:19:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BADF464DD8
	for <linux-xfs@archiver.kernel.org>; Wed,  3 Mar 2021 03:19:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350396AbhCCDQV (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 2 Mar 2021 22:16:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:38614 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2361111AbhCBXXb (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 2 Mar 2021 18:23:31 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1167A64F3B;
        Tue,  2 Mar 2021 23:22:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614727371;
        bh=+5fbK8L4V4hl8wvHYx0hPrG7RpEAU7/C0udYIcd6tDc=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=NEHk1gaO5o8ncOl3hG/59z3RaS9DyWHQbQS8pUbq4PTlSK5ZCxbI6UnNA23l3XIDY
         DBoInsp2AR9Kc5He0alB5bwBcavpKOwoSS5Cku5q1YKZlbgotUbS9Ilszpb/EH0oDy
         aU0/WrP/RhCowKClHkPTEWZh+m6vcVg2QF8UmvTrVhPVgj5iBLSnePPdxoLgHrbDZY
         yQNbaUw1DvV5QXgz2TVdpNiCSc2tz+2D4yxVnuuYJUVgrqrKQB2HmxUwrmO+0K09eu
         eYVx/1wClN6jj6MujI1Ycy+VXi9a8ass/704t2rC5GM2jEUBSX6rb0ggE4s+gsHB1h
         HzQr9j0tug+3g==
Subject: [PATCH 3/4] common/rc: fix detection of device-mapper/persistent
 memory incompatibility
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, guaneryu@gmail.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Tue, 02 Mar 2021 15:22:50 -0800
Message-ID: <161472737079.3478298.2584850499235911991.stgit@magnolia>
In-Reply-To: <161472735404.3478298.8179031068431918520.stgit@magnolia>
References: <161472735404.3478298.8179031068431918520.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

In commit fc7b3903, we tried to make _require_dm_target smart enough to
_notrun tests that require a device mapper target that isn't compatible
with "DAX".  However, as of this writing, the incompatibility stems from
device mapper's unwillingness to switch access modes when running atop
DAX (persistent memory) devices, and has nothing to do with the
filesystem mount options.

Since filesystems supporting DAX don't universally require "dax" in the
mount options to enable that functionality, switch the test to query
sysfs to see if the scratch device supports DAX.

Fixes: fc7b3903 ("dax/dm: disable testing on devices that don't support dax")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 common/rc |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)


diff --git a/common/rc b/common/rc
index 7254130f..10e5f40b 100644
--- a/common/rc
+++ b/common/rc
@@ -1889,7 +1889,8 @@ _require_dm_target()
 	_require_sane_bdev_flush $SCRATCH_DEV
 	_require_command "$DMSETUP_PROG" dmsetup
 
-	_normalize_mount_options | egrep -q "dax(=always| |$)"
+	_normalize_mount_options | egrep -q "dax(=always| |$)" || \
+			test -e "/sys/block/$(_short_dev $SCRATCH_DEV)/dax"
 	if [ $? -eq 0 ]; then
 		case $target in
 		stripe|linear|log-writes)

