Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 959B8C77B7E
	for <linux-xfs@archiver.kernel.org>; Fri, 26 May 2023 01:43:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230297AbjEZBnj (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 May 2023 21:43:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230140AbjEZBnj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 May 2023 21:43:39 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FE33189
        for <linux-xfs@vger.kernel.org>; Thu, 25 May 2023 18:43:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C937B64B2A
        for <linux-xfs@vger.kernel.org>; Fri, 26 May 2023 01:43:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 370F1C433D2;
        Fri, 26 May 2023 01:43:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685065417;
        bh=2YdUsO97+15Yopw/3abufyg10E/wEE92E7vWWGa6k4Q=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=YgMTFpqKuD5I8PJuRKWz3vKROgl3OZDTiijOFJM8BtzqUZNf30CX+SVEHcJVyisEd
         cUCusZo5z7t/lAZDKxsZEoAU8jZCjeRwAt/zIJu0ZEE9xgUT26uQmZDxuRB/1zd8OS
         wAiEgVCTeXHESYwWqc67IfKCM3cVoAehuhSP/i35adIdSvqckOpJS3x5y/EkrUVPDR
         DH0TFRsATRnOvQHk9S3cUcDuIMQKo9O9I8KmzQKHiY43H/P9pTrKR33tMxKdpmOvIu
         BjdX2BIInyhbiI0UBok9Bzh1CWjhBYh+CHFH5qQc5gtZNtA6WVwg/FZfcAxMJ2F2EM
         ZGVtAMHKqRrnQ==
Date:   Thu, 25 May 2023 18:43:36 -0700
Subject: [PATCH 5/6] xfs_scrub: any inconsistency in metadata should trigger
 difficulty warnings
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Message-ID: <168506071733.3742978.18385344984536814923.stgit@frogsfrogsfrogs>
In-Reply-To: <168506071665.3742978.12693465390096953510.stgit@frogsfrogsfrogs>
References: <168506071665.3742978.12693465390096953510.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Any inconsistency in the space metadata can be a sign that repairs will
be difficult, so set off the warning if there were cross referencing
problems too.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 scrub/repair.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)


diff --git a/scrub/repair.c b/scrub/repair.c
index a68383cf05a..405b9e117f1 100644
--- a/scrub/repair.c
+++ b/scrub/repair.c
@@ -319,7 +319,9 @@ action_list_difficulty(
 	unsigned int			ret = 0;
 
 	list_for_each_entry_safe(aitem, n, &alist->list, list) {
-		if (!(aitem->flags & XFS_SCRUB_OFLAG_CORRUPT))
+		if (!(aitem->flags & (XFS_SCRUB_OFLAG_CORRUPT |
+				      XFS_SCRUB_OFLAG_XCORRUPT |
+				      XFS_SCRUB_OFLAG_XFAIL)))
 			continue;
 
 		switch (aitem->type) {

