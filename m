Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 202E3C433E0
	for <linux-xfs@archiver.kernel.org>; Wed, 10 Feb 2021 02:57:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D7D6864E5B
	for <linux-xfs@archiver.kernel.org>; Wed, 10 Feb 2021 02:57:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233310AbhBJC5G (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 9 Feb 2021 21:57:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:41450 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229711AbhBJC5G (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 9 Feb 2021 21:57:06 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9795E64E50;
        Wed, 10 Feb 2021 02:56:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612925785;
        bh=Mt+wfWHPNvz0RPytu9MZYRqFwIJ8VG1vCjg4GS/+4ec=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=AapKa6Mm9c9++ch8rh05WqmIMvnZRTnbiysvMtqWZ6j4bXwlbA0QzQjGc/6tIIIbz
         IrdJepiZFRVZK9OD19lcbeFX6xvoBNBqRBbqjYYK9AZdRBMj90OS1t6xIq1W4YsRNU
         nSzREPklIWJuPNk8T7w3fKFA5x3mR5gQGHlgBCScP+HdxqzcHCaPT6Wmb/B/60QzGg
         bMsG4CEHiwzP5cUNC5R7KWeElgXwmYOOwWDUJnnz+PqMuBKUHu7CDcROJKZ33xL3uy
         cPM4HEnMvZnSxuVmK9wSZm3qU5r3sFX5omalxQpdAc6F5acoWcLN5Uqb/YrXelbotz
         TVKrcIutf16Hw==
Subject: [PATCH 1/6] config: wrap xfs_metadump as $XFS_METADUMP_PROG like the
 other tools
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, guaneryu@gmail.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Tue, 09 Feb 2021 18:56:25 -0800
Message-ID: <161292578528.3504537.14906312392933175461.stgit@magnolia>
In-Reply-To: <161292577956.3504537.3260962158197387248.stgit@magnolia>
References: <161292577956.3504537.3260962158197387248.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

When we set up a fstests run, preserve the path xfs_metadump binary with
an $XFS_METADUMP_PROG wrapper, like we do for the other xfsprogs tools.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 common/config |    1 +
 common/rc     |    2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)


diff --git a/common/config b/common/config
index d83dfb28..d4cf8089 100644
--- a/common/config
+++ b/common/config
@@ -156,6 +156,7 @@ MKSWAP_PROG="$MKSWAP_PROG -f"
 export XFS_LOGPRINT_PROG="$(type -P xfs_logprint)"
 export XFS_REPAIR_PROG="$(type -P xfs_repair)"
 export XFS_DB_PROG="$(type -P xfs_db)"
+export XFS_METADUMP_PROG="$(type -P xfs_metadump)"
 export XFS_ADMIN_PROG="$(type -P xfs_admin)"
 export XFS_GROWFS_PROG=$(type -P xfs_growfs)
 export XFS_SPACEMAN_PROG="$(type -P xfs_spaceman)"
diff --git a/common/rc b/common/rc
index 649b1cfd..ad54b3de 100644
--- a/common/rc
+++ b/common/rc
@@ -509,7 +509,7 @@ _scratch_metadump()
 	[ "$USE_EXTERNAL" = yes -a ! -z "$SCRATCH_LOGDEV" ] && \
 		options="-l $SCRATCH_LOGDEV"
 
-	xfs_metadump $options "$@" $SCRATCH_DEV $dumpfile
+	$XFS_METADUMP_PROG $options "$@" $SCRATCH_DEV $dumpfile
 }
 
 _setup_large_ext4_fs()

