Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D644C4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 00:34:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235712AbiLaAeC (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 19:34:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235655AbiLaAeC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 19:34:02 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76B9A1DDE4
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 16:34:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1314561C63
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 00:34:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70E03C433EF;
        Sat, 31 Dec 2022 00:34:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672446840;
        bh=hpP4MJ9V6YvRymh4jocqoLMyOjhd22/YYU85ABgSC4M=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=aFsvZ97Da0kBK2QI4dWZ0ZqQr9+zlj1m4jBs9jlfmsuC+5vI7b8svqJ0no1NXQ/GF
         OKGXwJu0hdbKqIIakNdarSgEvjph6RZ5l9HbiCBy9HK9dHtst3P/3gE6nC5oxoNEwY
         E+FTOadWPwRhWdKjjQadlpBmGW/oM4Glalbv+XY5E1bbliELO7pOaRa1NLCs9yJHoc
         RfvSswqaKhYHfof/YC17+JBQHdYWdOoYafdAhMnOlCT+IPLljtHtN07mfALvdejYsY
         9fhkQrCr002MFCQ7qG301XD0d1lKGKEMKI9/1H3Gi64JsHydC8NKIo0vMuRMUL46do
         WAnLss6/l3EqA==
Subject: [PATCH 1/8] debian: install scrub services with dh_installsystemd
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     cem@kernel.org, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:18:31 -0800
Message-ID: <167243871113.717702.9657625631265376492.stgit@magnolia>
In-Reply-To: <167243871097.717702.15336500890922415647.stgit@magnolia>
References: <167243871097.717702.15336500890922415647.stgit@magnolia>
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

