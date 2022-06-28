Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1547CC43334
	for <linux-xfs@archiver.kernel.org>; Tue, 28 Jun 2022 20:25:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230118AbiF1UY7 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 28 Jun 2022 16:24:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229866AbiF1UYU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 28 Jun 2022 16:24:20 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CA3A140EE;
        Tue, 28 Jun 2022 13:21:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8275FB8203F;
        Tue, 28 Jun 2022 20:21:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 284DFC3411D;
        Tue, 28 Jun 2022 20:21:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656447706;
        bh=XYlAphFMdsvmnzakkhya87ROjW4zWZT4k+Q/98btdiM=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=ae6GU5qv7wBWgIvFP8u7UBUSO0nBVK7Sf5yY8DRayFbSL6Scj72RBcmnnwuWiv/wF
         YR0rnqNEJlPoHvV+/wHDVZSuXIsuS2BAh72+UgCpi/94EifuCjUWN/FkB7qElPCGLV
         ztFwi7m8IzQfsNWvWDYppg+a7nNpRJkxfMD1tA2azjXy8+R0UXFIaYlKLfRTy+h/Vk
         EdZriT3hv8S6oEcy1do7txmDtHZy9j2EM9RZ+YN0VIlt9L0TAvN7EoeVPEaoof0EQ4
         7XSxO2XKcNGoESS95Nejz0EhBod9pHLVjbSwSQs4sNhEV8W4/2LuRV5E2z2r1m3zTp
         mtjZjvk9wYaEA==
Subject: [PATCH 5/9] check: document mkfs.xfs reliance on fstests exports
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, guaneryu@gmail.com, zlang@redhat.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Tue, 28 Jun 2022 13:21:45 -0700
Message-ID: <165644770574.1045534.3646229611370914936.stgit@magnolia>
In-Reply-To: <165644767753.1045534.18231838177395571946.stgit@magnolia>
References: <165644767753.1045534.18231838177395571946.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

There are a number of fstests that employ special (and now unsupported)
XFS filesystem configurations to perform testing in a controlled
environment.  The presence of the QA_CHECK_FS and MSGVERB variables are
used by mkfs.xfs to detect that it's running inside fstests, which
enables the unsupported configurations.  Nobody else should be using
filesystems with tiny logs, non-redundant superblocks, or smaller than
the (new) minimum supported size.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 check |    3 +++
 1 file changed, 3 insertions(+)


diff --git a/check b/check
index 2ea2920f..4b0ebad6 100755
--- a/check
+++ b/check
@@ -33,6 +33,9 @@ _err_msg=""
 # start the initialisation work now
 iam=check
 
+# mkfs.xfs uses the presence of both of these variables to enable formerly
+# supported tiny filesystem configurations that fstests use for fuzz testing
+# in a controlled environment
 export MSGVERB="text:action"
 export QA_CHECK_FS=${QA_CHECK_FS:=true}
 

