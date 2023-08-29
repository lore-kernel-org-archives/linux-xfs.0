Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 847A4C83F12
	for <linux-xfs@archiver.kernel.org>; Tue, 29 Aug 2023 23:16:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240163AbjH2XQG (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 29 Aug 2023 19:16:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240853AbjH2XP5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 29 Aug 2023 19:15:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67319FF;
        Tue, 29 Aug 2023 16:15:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F23B860FB9;
        Tue, 29 Aug 2023 23:15:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BC03C433C9;
        Tue, 29 Aug 2023 23:15:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1693350954;
        bh=1lnIPTcPbqX8W5OcDkw5XUK4qbTCTxJX/mJYL3kZXCc=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=Km5K8XX/VSXpWc/MiPqHD9PVjPWPkr8lwLWqHqDDBmL/RbEPgaoHCeUbWI/33s4/U
         Jj/D1XVI7q45ig4z0tsRYBOJoMOQhxVw7sMkb+qJHD4WiJ/SDrpzgUwAvDqU9E0aE/
         EbWSZ9qzSKwuCL7GleQ6d2BYpb5UI9TNLQ0/ajKUIQnDL9bRpwmSPWSliODdsIvvdW
         RqiJR05Q5C8/J/aigs7cXz69XiTga2Lg2lERYZcjylJgfsKfwArdEiEmKnVolGddpD
         JdWCVHYQ7sQXe+zDfVdhYRri67PEnEC/30YGQZtSynAWO6lkqmNdSs0k6ktbdSEdBP
         lRAVAh+2M1Ocg==
Subject: [PATCH 1/2] generic/61[67]: support SOAK_DURATION
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, zlang@redhat.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Tue, 29 Aug 2023 16:15:53 -0700
Message-ID: <169335095385.3534600.13449847282467855019.stgit@frogsfrogsfrogs>
In-Reply-To: <169335094811.3534600.13011878728080983620.stgit@frogsfrogsfrogs>
References: <169335094811.3534600.13011878728080983620.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Now that I've finally gotten liburing installed on my test machine, I
can actually test io_uring.  Adapt these two tests to support
SOAK_DURATION so I can add it to that too.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 tests/generic/616 |    1 +
 tests/generic/617 |    1 +
 2 files changed, 2 insertions(+)


diff --git a/tests/generic/616 b/tests/generic/616
index 538b480ba7..729898fded 100755
--- a/tests/generic/616
+++ b/tests/generic/616
@@ -33,6 +33,7 @@ fsx_args+=(-N $nr_ops)
 fsx_args+=(-p $((nr_ops / 100)))
 fsx_args+=(-o $op_sz)
 fsx_args+=(-l $file_sz)
+test -n "$SOAK_DURATION" && fsx_args+=(--duration="$SOAK_DURATION")
 
 run_fsx "${fsx_args[@]}" | sed -e '/^fsx.*/d'
 
diff --git a/tests/generic/617 b/tests/generic/617
index 3bb3112e99..f0fd1feb2e 100755
--- a/tests/generic/617
+++ b/tests/generic/617
@@ -39,6 +39,7 @@ fsx_args+=(-r $min_dio_sz)
 fsx_args+=(-t $min_dio_sz)
 fsx_args+=(-w $min_dio_sz)
 fsx_args+=(-Z)
+test -n "$SOAK_DURATION" && fsx_args+=(--duration="$SOAK_DURATION")
 
 run_fsx "${fsx_args[@]}" | sed -e '/^fsx.*/d'
 

