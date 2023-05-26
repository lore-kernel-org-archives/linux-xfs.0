Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86873C77B7E
	for <linux-xfs@archiver.kernel.org>; Fri, 26 May 2023 01:52:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231495AbjEZBwq (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 May 2023 21:52:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229689AbjEZBwp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 May 2023 21:52:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F37A8E7
        for <linux-xfs@vger.kernel.org>; Thu, 25 May 2023 18:52:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 80C9C64C45
        for <linux-xfs@vger.kernel.org>; Fri, 26 May 2023 01:52:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4B15C433D2;
        Fri, 26 May 2023 01:52:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685065962;
        bh=hpP4MJ9V6YvRymh4jocqoLMyOjhd22/YYU85ABgSC4M=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=K7nJeDNFJdp7rPnHG6roVLT9TFl/XSogXwfrLpkX/1P/u3IyUIbpHaZ58c5s9qHm8
         UfAZtiGMEwfUmuIfcEw3Dkij4oUqww80gQ4/Cbo7s2gIq8JaxLZSb6IfHUdZ99//B+
         Q774fO/N9UYKAcVm6YtL2Yy6FmvmwMtNK5+XYzNUYw43+B9FDS0c64W389zzNVXDhT
         S5g3oEyCkt17A3wxVSpm3huwCgZ5H/IaPUl7anQXRRtCWkRkmqX0NmxcsLiv8sMzzV
         qwdu3SclYHOPkDHEl+A8/L0cd2dbX9Xq0M8j/7MDZuCb+lXo53kkDwp4P2TTEv0Dmm
         7r6X0IkSU3aPQ==
Date:   Thu, 25 May 2023 18:52:42 -0700
Subject: [PATCH 1/5] debian: install scrub services with dh_installsystemd
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Message-ID: <168506073846.3745766.1338318814898903856.stgit@frogsfrogsfrogs>
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

Use dh_installsystemd to handle the installation and activation of the
scrub systemd services.  This requires bumping the compat version to 11.
Note that the services are /not/ activated on installation.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 debian/rules |    1 +
 1 file changed, 1 insertion(+)


diff --git a/debian/rules b/debian/rules
index 95df4835b25..57baad625c5 100755
--- a/debian/rules
+++ b/debian/rules
@@ -108,6 +108,7 @@ binary-arch: checkroot built
 	dh_compress
 	dh_fixperms
 	dh_makeshlibs
+	dh_installsystemd -p xfsprogs --no-enable --no-start --no-restart-after-upgrade --no-stop-on-upgrade
 	dh_installdeb
 	dh_shlibdeps
 	dh_gencontrol

