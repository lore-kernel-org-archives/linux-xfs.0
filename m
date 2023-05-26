Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E844C77B7E
	for <linux-xfs@archiver.kernel.org>; Fri, 26 May 2023 01:59:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229567AbjEZB7v (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 May 2023 21:59:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229523AbjEZB7u (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 May 2023 21:59:50 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BBBE194
        for <linux-xfs@vger.kernel.org>; Thu, 25 May 2023 18:59:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B289864C47
        for <linux-xfs@vger.kernel.org>; Fri, 26 May 2023 01:59:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1AFC4C433EF;
        Fri, 26 May 2023 01:59:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685066386;
        bh=FfrCLFJa6ALaVXkisSKixa5IlJR7IXXSAf5Y9rGJhDk=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=pUgqE/8NytY4dm+kkIFUc6F/g6d3ot016DaIFU4/+XwbszJ+8/90TsS9ODtvtepen
         RjHhSMhxcK+r26z1Ro2Vf+7Mh78l4Se4ez73cSkKKKQlHvOFG2qQyITqAPgpJHEt7e
         hRl2Ztgv4RijIr2oztE7g7SVe+5FnIUt3nYcRLSrBQFoQW3w9LwyW+JH+NY9LiilJJ
         xe40X3j3GcAVbGHDB6dmEJYQs4kJfNDgSBFUB2/LwBheNH4cLjwH8baAFJHUpFVixT
         HrVwlCgx14ITrNh+FnjA0DvM2FYiwiydh95Rgw7ERvohEdFxnscO/kIEyVxzZ51SMG
         7l4a/VwE9EHgQ==
Date:   Thu, 25 May 2023 18:59:45 -0700
Subject: [PATCH 3/3] debian: enable xfs_scrub systemd services by default
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Message-ID: <168506075599.3746649.11660351227592928307.stgit@frogsfrogsfrogs>
In-Reply-To: <168506075558.3746649.11825051260686897396.stgit@frogsfrogsfrogs>
References: <168506075558.3746649.11825051260686897396.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Now that we're finished building online fsck, enable the background
services by default.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 debian/rules |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/debian/rules b/debian/rules
index 97fbbbfa1ab..c040b460c44 100755
--- a/debian/rules
+++ b/debian/rules
@@ -109,7 +109,7 @@ binary-arch: checkroot built
 	dh_compress
 	dh_fixperms
 	dh_makeshlibs
-	dh_installsystemd -p xfsprogs --no-enable --no-start --no-restart-after-upgrade --no-stop-on-upgrade
+	dh_installsystemd -p xfsprogs
 	dh_installdeb
 	dh_shlibdeps
 	dh_gencontrol

