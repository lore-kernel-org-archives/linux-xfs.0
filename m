Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F172C7618D
	for <linux-xfs@archiver.kernel.org>; Thu,  6 Apr 2023 19:42:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235437AbjDFTmB (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 6 Apr 2023 15:42:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229845AbjDFTmA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 6 Apr 2023 15:42:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B96A394;
        Thu,  6 Apr 2023 12:41:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 53B1860FA2;
        Thu,  6 Apr 2023 19:41:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7CACC433D2;
        Thu,  6 Apr 2023 19:41:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680810118;
        bh=LH5q+aSG98FcQV9OMtAWhsX747vXiHbVLa2jpTrhpWc=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=C/laM+53faBdiJCZOO5tmqUtBP33msOkiHU6YnJozgAu3qZMD4Onp7GUPj1O3Cpro
         daZfDfzaCxqz0UePOtHhXP9RUwdKWCvgK7hByuvi5yTB+H9aJ9FJeIRaePW+BMT70/
         ueiup5KcTkmzyStuTxwQi/POgwFACO40Mp1aSupVipo9ist8e6LdHFZd5n4sO3T8S7
         zYpGzu/rGE4fL8IDA+Kjc1Ow67wX1NEIlWzAwdDc+hHG0SwklfOd9nvWmQwOmzKqvj
         R0eUeTSXnKYs3PIS1FeW9x4iiS7rzqqys9v9gRCuZwyDDaJ81ks69MXGKdwoqztEzn
         Qu/LhHUAy2IGg==
Date:   Thu, 06 Apr 2023 12:41:58 -0700
Subject: [PATCH 01/11] xfs/206: filter out the parent= status from mkfs
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     zlang@redhat.com, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Message-ID: <168080829020.618488.9961036807783357224.stgit@frogsfrogsfrogs>
In-Reply-To: <168080829003.618488.1769223982280364994.stgit@frogsfrogsfrogs>
References: <168080829003.618488.1769223982280364994.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Filter out the parent pointer bits from the mkfs output so that we don't
cause a regression in this test.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 tests/xfs/206 |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)


diff --git a/tests/xfs/206 b/tests/xfs/206
index cb346b6dc9..af86570a81 100755
--- a/tests/xfs/206
+++ b/tests/xfs/206
@@ -64,7 +64,8 @@ mkfs_filter()
 	    -e "s/\(sunit=\)\([0-9]* blks,\)/\10 blks,/" \
 	    -e "s/, lazy-count=[0-9]//" \
 	    -e "/.*crc=/d" \
-	    -e "/^Default configuration/d"
+	    -e "/^Default configuration/d" \
+	    -e '/parent=/d'
 }
 
 # mkfs slightly smaller than that, small log for speed.

