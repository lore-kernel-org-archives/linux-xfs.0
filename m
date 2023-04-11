Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 863C7C77B6F
	for <linux-xfs@archiver.kernel.org>; Tue, 11 Apr 2023 18:13:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230331AbjDKSNz (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 11 Apr 2023 14:13:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229765AbjDKSNy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 11 Apr 2023 14:13:54 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15D1AE59;
        Tue, 11 Apr 2023 11:13:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A8ED662083;
        Tue, 11 Apr 2023 18:13:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 117BAC433D2;
        Tue, 11 Apr 2023 18:13:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681236833;
        bh=nSohkuAu/zJflIIIHE1aPbfMB0lV4CM8SzAv1SIIhQ0=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=NbTW9hv/j9cSGkAELre6HjKHTj04G37IgBmnOqARZPjP58rXw+Ypa/H9inW39A8IG
         0AO5wEw8HLvShFhZk/588oW768T1gPqoaKHXM+YBgN5UhAnkf0wRTM/YXzpomy9z3e
         vTdbibS52c1+AzLrRRafqwIWQUJqhg93CqD4CCbHrJAVmw4mPpv8Y47X5An4uvmmzw
         Z7XAGA1eGcBoX3pFlduXf3RTQSLvk5iUstBh3qJcjl5KlAkSYgltobF4goS75y8e/r
         vrp5RnYU8AlPNX6kUb2F8neW6B+Htd5DoTAFf97sl5W2mD0X5hqanMiyhXYqNSK1ww
         uHm1a6CNxXEng==
Subject: [PATCH 1/3] generic/476: reclassify this test as a long running soak
 stress test
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, zlang@redhat.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Tue, 11 Apr 2023 11:13:52 -0700
Message-ID: <168123683265.4086541.1415706130542808348.stgit@frogsfrogsfrogs>
In-Reply-To: <168123682679.4086541.13812285218510940665.stgit@frogsfrogsfrogs>
References: <168123682679.4086541.13812285218510940665.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

This test is a long(ish) running stress test, so add it to those groups.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 tests/generic/476 |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/tests/generic/476 b/tests/generic/476
index 212373d17c..edb0be7b50 100755
--- a/tests/generic/476
+++ b/tests/generic/476
@@ -8,7 +8,7 @@
 # bugs in the write path.
 #
 . ./common/preamble
-_begin_fstest auto rw
+_begin_fstest auto rw soak long_rw stress
 
 # Override the default cleanup function.
 _cleanup()

