Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4DFA5EE3F10
	for <linux-xfs@archiver.kernel.org>; Tue, 12 Sep 2023 19:40:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231691AbjILTkD (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 12 Sep 2023 15:40:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230443AbjILTkD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 12 Sep 2023 15:40:03 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5323115
        for <linux-xfs@vger.kernel.org>; Tue, 12 Sep 2023 12:39:59 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43374C433C7;
        Tue, 12 Sep 2023 19:39:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1694547599;
        bh=64IVW/An9QO5NauUY4fyCSUaA/Vfi5FTIXfuLOzFD+Y=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=iqUHNSXeeGxyjwYXCh5O3w8eHcW2+7/XcV8cLIaGxavBPRP30gZrFni4ygiCgMawO
         7jo+YdvXRsiS2JY4QHc2DMphQw2Efw5N1pEmE/Iu/UXOrT748TIdRxLK6bCueH4hpT
         Q7HQuWlrbVyYheqkt9i8/6AuBXIyFbZVO9wZQSbilMW7D9vIWqYogmHpSNCJiSKNcu
         FzLbajuPJrfK/KvxQumcbhFhdZ5KP8U0gsUxEwlqD86+7wjqtoD36MgaoS5OmnwHUT
         RtFH3uCzxaKwXMcN5SaQOzf4OaH9p+/o6LbvQ6VPEdzCNW3pyfyokNBFuB4i0WsYZC
         azenbxabLEfpg==
Subject: [PATCH 4/6] xfs_scrub: actually return errno from
 check_xattr_ns_names
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 12 Sep 2023 12:39:58 -0700
Message-ID: <169454759865.3539425.15276862523138913713.stgit@frogsfrogsfrogs>
In-Reply-To: <169454757570.3539425.3597048437340386509.stgit@frogsfrogsfrogs>
References: <169454757570.3539425.3597048437340386509.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Actually return the error code when extended attribute checks fail.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 scrub/phase5.c |    1 +
 1 file changed, 1 insertion(+)


diff --git a/scrub/phase5.c b/scrub/phase5.c
index 1ef234bff68..31405709657 100644
--- a/scrub/phase5.c
+++ b/scrub/phase5.c
@@ -202,6 +202,7 @@ check_xattr_ns_names(
 	if (error) {
 		if (errno == ESTALE)
 			errno = 0;
+		error = errno;
 		if (errno)
 			str_errno(ctx, descr_render(dsc));
 	}

