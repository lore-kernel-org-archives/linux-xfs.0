Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9DB56C77B7E
	for <linux-xfs@archiver.kernel.org>; Fri, 26 May 2023 01:50:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230091AbjEZBuJ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 May 2023 21:50:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230049AbjEZBuI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 May 2023 21:50:08 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8A51199
        for <linux-xfs@vger.kernel.org>; Thu, 25 May 2023 18:50:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8279364868
        for <linux-xfs@vger.kernel.org>; Fri, 26 May 2023 01:50:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E86A2C433EF;
        Fri, 26 May 2023 01:50:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685065807;
        bh=z98nm415xg1dJfZnpsM7dKoE1Vz2/v+jIbqkIHA85R0=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=cr3WgeEMoRHvw0vSM+8wI+SIHOaYaHcsCoaPhHLB5r3jQJLBFdk0C4Ol8w9Tj1XrG
         a9y5RSXH6LNn5h0dwgHg6z98CttmP3OYu1b1eQgVVh9w76N66YVhLffQRI45gQ3ExP
         NqSItfp/Kvl6BCsHZVcHTxxhdIrD8UpS6xhNAG+M3mgdw4NqzF78Ig42eFZxiRS5IO
         734jBO6fdO/3Vigc9HU1MtFF+sHqav3ZKSQJXWuFuHyRaDDmHr3wfyK/l0sFSbf8vx
         SCllhFqfMyWrH8KA/dLmlqsgIx7uJFxMIWQFa6LIU5vS6r0vFlydAFMeRw14GmiL7C
         3GNXaQXdvyTzg==
Date:   Thu, 25 May 2023 18:50:06 -0700
Subject: [PATCH 6/8] xfs_scrub: don't call FITRIM after runtime errors
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Message-ID: <168506073160.3744829.12683524760674073752.stgit@frogsfrogsfrogs>
In-Reply-To: <168506073077.3744829.468307851541842353.stgit@frogsfrogsfrogs>
References: <168506073077.3744829.468307851541842353.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Don't call FITRIM if there have been runtime errors -- we don't want to
touch anything after any kind of unfixable problem.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 scrub/phase8.c |    3 +++
 1 file changed, 3 insertions(+)


diff --git a/scrub/phase8.c b/scrub/phase8.c
index 3e174e400ba..d21f62099b9 100644
--- a/scrub/phase8.c
+++ b/scrub/phase8.c
@@ -39,6 +39,9 @@ fstrim_ok(
 	if (ctx->unfixable_errors != 0)
 		return false;
 
+	if (ctx->runtime_errors != 0)
+		return false;
+
 	return true;
 }
 

