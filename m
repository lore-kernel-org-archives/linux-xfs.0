Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89DFCEE7FE1
	for <linux-xfs@archiver.kernel.org>; Fri,  8 Sep 2023 12:12:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243233AbjIHMMn (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 8 Sep 2023 08:12:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240839AbjIHMMn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 8 Sep 2023 08:12:43 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93A531BC5;
        Fri,  8 Sep 2023 05:12:39 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14A6EC433C8;
        Fri,  8 Sep 2023 12:12:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1694175159;
        bh=Uyx5Gq0uaYkqAfjzVD4SP/i8eS3DtLvrWwNfHuJQh9Q=;
        h=From:To:Cc:Subject:Date:From;
        b=l660PCO6x9FLjJ5yJaHTD6KwcxEFCVwXFctKDyyrRNDvu6Dg5zuoscLaw5fPTib2U
         1ECDpKE0T4Sc7WWm9PWcSJ2uhGhc3TiMHGJxpCZ4x7k3SZed7mJqxcN9iWIjGdi0xj
         yd/FoFOmEqNoKSRGdfdBmGvB0CVlI6DP5tVYq8MI3ZT7H4Y+wNNV6bWls5kCLs2Ytf
         uFJzNDMncG0vk8HbsEnXNfrVqM1ZhIShCBht20uS4rzh/v1U7H59vT9uNun5ehFWUr
         DhyERetfZ4q26LvLuIFcKZ0m9UITj3ILTkhTVRnbo8QrzsyAHt8e2YeO5oaja5IcPJ
         6Vxpr/GcOASEQ==
From:   cem@kernel.org
To:     fstests@vger.kernel.org
Cc:     zlang@kernel.org, linux-xfs@vger.kernel.org
Subject: [PATCH] common: fix rt_ops setup in _scratch_mkfs_sized
Date:   Fri,  8 Sep 2023 14:12:34 +0200
Message-Id: <20230908121234.553218-1-cem@kernel.org>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Carlos Maiolino <cem@kernel.org>

Tests using _scratch_mkfs_sized() will fail if SCRATCH_RTDEV is set,
but, USE_EXTERNAL is not, this happens because the function pass
"-r size=$fssize" to the _scratch_mkfs_xfs argument line, which in turn
will not set rtdev because USE_EXTERNAL is not set.

Tests like xfs/015 will fail as:

xfs/015 6s ... [failed, exit status 1]- output mismatch
.
.
    +size specified for non-existent rt subvolume
    +Usage: mkfs.xfs
.
.

with this patch the test runs properly using the rtdev if USE_EXTERNAL
is set.

Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
---

Particularly I think SCRATCH_RTDEV should not depend on USE_EXTERNAL, as the
latter is also linked to external logdevs, but I noticed tests specific for RT
devices also set USE_EXTERNAL, so  I opted to change it according to the current
usage

 common/rc | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/common/rc b/common/rc
index 1618ded5..20608fbe 100644
--- a/common/rc
+++ b/common/rc
@@ -965,7 +965,7 @@ _scratch_mkfs_sized()
 		[ "$fssize" -gt "$devsize" ] && _notrun "Scratch device too small"
 	fi
 
-	if [ "$FSTYP" = "xfs" ] && [ -b "$SCRATCH_RTDEV" ]; then
+	if [ "$FSTYP" = "xfs" ] && [ "$USE_EXTERNAL" = yes -a -b "$SCRATCH_RTDEV" ]; then
 		local rtdevsize=`blockdev --getsize64 $SCRATCH_RTDEV`
 		[ "$fssize" -gt "$rtdevsize" ] && _notrun "Scratch rt device too small"
 		rt_ops="-r size=$fssize"
-- 
2.39.2

