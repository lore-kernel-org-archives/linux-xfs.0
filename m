Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A601C77B7E
	for <linux-xfs@archiver.kernel.org>; Fri, 26 May 2023 01:53:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229890AbjEZBxr (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 May 2023 21:53:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233496AbjEZBxq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 May 2023 21:53:46 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4088F189
        for <linux-xfs@vger.kernel.org>; Thu, 25 May 2023 18:53:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D07B861298
        for <linux-xfs@vger.kernel.org>; Fri, 26 May 2023 01:53:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42CB9C433D2;
        Fri, 26 May 2023 01:53:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685066025;
        bh=67n3qLMTUPziJjblmFHoAovqstmfXJeOAIJh23UhJsg=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=jeeK1JRn/mg9B2TZ6+pYlib55+O7/0vXjO1l+Pf2TzGfowszeLyBha/alEXs8cd8g
         DKtYefF/5o9gRVShAo23VjiKG6fqGpSE68U/7jbynD4wT25akr3kMLLoUchmhzQH5J
         Y69o7RtjU9IjLAsPx4DZJRQGnzGRrlSEvU7PiWm8s0KWzO1P4cKCbRlcDemRucFcxv
         w1Tvf3qLi6a2EdsGUWjmr4/emx+zK0E0yNHzPI0chUW1mgasxizPXgVFMh8pEVS0MF
         PKN14y2jtJuLh385UKfjGfZyRlamyY8v4qUlF7Ug3sevgOWAMxcgZCzJDyt5nDnLM9
         /xm8/ui1qggLQ==
Date:   Thu, 25 May 2023 18:53:44 -0700
Subject: [PATCH 5/5] xfs_scrub_fail: return the failure status of the mailer
 program
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Message-ID: <168506073900.3745766.12097252494988640270.stgit@frogsfrogsfrogs>
In-Reply-To: <168506073832.3745766.10929690168821459226.stgit@frogsfrogsfrogs>
References: <168506073832.3745766.10929690168821459226.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

We should return the exit code of the mailer program sending the scrub
failure reports, since that's much more important to anyone watching the
system.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 scrub/xfs_scrub_fail.in |    1 +
 1 file changed, 1 insertion(+)


diff --git a/scrub/xfs_scrub_fail.in b/scrub/xfs_scrub_fail.in
index a69be8a54cb..8f77e3d96cd 100755
--- a/scrub/xfs_scrub_fail.in
+++ b/scrub/xfs_scrub_fail.in
@@ -33,3 +33,4 @@ So sorry, the automatic xfs_scrub of ${mntpoint} on ${hostname} failed.
 A log of what happened follows:
 ENDL
 systemctl status --full --lines 4294967295 "${scrub_svc}") | "${mailer}" -t -i
+exit "${PIPESTATUS[1]}"

