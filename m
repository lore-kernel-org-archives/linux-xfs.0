Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4ECDFC7EE43
	for <linux-xfs@archiver.kernel.org>; Tue,  6 Jun 2023 22:29:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239869AbjFFW3g (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 6 Jun 2023 18:29:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239862AbjFFW3g (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 6 Jun 2023 18:29:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CC2A1717;
        Tue,  6 Jun 2023 15:29:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 18D4C6388E;
        Tue,  6 Jun 2023 22:29:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74363C433D2;
        Tue,  6 Jun 2023 22:29:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1686090574;
        bh=VLBWifqvMXkHC5Bk8nQPtw5uVk0zWt5F7qclcEA/EPk=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=A2bcDNSh2GkRmhAKcFQih6F6hkrgG4WnvdOwUgT1MSD7XanKDLlJ7d7QkOmL4ovKn
         VO3X8bcL1s1hZ3kG54xeY+9ERJz8aOanW+9BZUNNsgoxqyjd954U3zqNnnRSyG3vVn
         6V0UtJAGj66z8DrJaanNPhDtvUuSlLc0OvFR0pkpZcAYx80zemyiaG+2jaxBHpmmiD
         pcKPIUL+8V7aimN2DN3+x/u9+rWfXnf8BzXZvFLELX56IaZSgMY4ZJ2mJO+J+ga0Xg
         HoYb1R1Jo7ak3eG8AZXFbqMiUqWzDtuloIqx9+hk8NY1LEHg0EWfjlztV0f8JS8JA9
         TOhw/1ky7MZ3Q==
Subject: [PATCH 2/3] xfs/503: don't rebuild the fs metadata when testing
 metadump
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     zlang@redhat.com, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Tue, 06 Jun 2023 15:29:34 -0700
Message-ID: <168609057408.2592490.14528335416861268945.stgit@frogsfrogsfrogs>
In-Reply-To: <168609056295.2592490.1272515528324889317.stgit@frogsfrogsfrogs>
References: <168609056295.2592490.1272515528324889317.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

This test exercises metadump with the standard populate image.  There's
no need to test rebuilding the entire fs every step of the way since
we're just going to metadump over it.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 tests/xfs/503 |    2 ++
 1 file changed, 2 insertions(+)


diff --git a/tests/xfs/503 b/tests/xfs/503
index c786b04ccd..f5710ece35 100755
--- a/tests/xfs/503
+++ b/tests/xfs/503
@@ -32,6 +32,8 @@ _require_command "$XFS_MDRESTORE_PROG" "xfs_mdrestore"
 _require_xfs_copy
 _require_scratch_nocheck
 _require_populate_commands
+_xfs_skip_online_rebuild
+_xfs_skip_offline_rebuild
 
 echo "Format and populate"
 _scratch_populate_cached nofill > $seqres.full 2>&1

