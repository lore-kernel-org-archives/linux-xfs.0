Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB77AC76196
	for <linux-xfs@archiver.kernel.org>; Wed, 29 Mar 2023 00:58:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229479AbjC2A6Z (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 28 Mar 2023 20:58:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229683AbjC2A6Y (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 28 Mar 2023 20:58:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 367531724;
        Tue, 28 Mar 2023 17:58:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C5F7661A21;
        Wed, 29 Mar 2023 00:58:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27FBFC433D2;
        Wed, 29 Mar 2023 00:58:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680051502;
        bh=QmpXWT6LReg9Numkt8jhEE44oOAqZQb+vKXg5M8rhqI=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=L3Lb7zO3E32jm19ZNLn7Z9VAcQFqOm7AmiISdK+A8/OZ5dyy1bagvbpsAAFi8giIM
         VhIIYu1Gimd+Zj8/cLAsWym/dYo2UjQto+hjWirGTQ8yrh3CBsO87uUSFCd6G3Tbon
         yToyO1MfPwt3VDsycHcQ3oTJhkBUstRompzg0IgdI5l5X4NdLCt9/fVjcErriTQUIp
         Xw7YZr1/MM6mWAQ8fuRmfD8pUaeQjY1/omR3ZY56GbKNSo3AfqngwurXzXPgG+d1um
         gFCfa1TO7eaW291uWySwQwgowZ8ge7NazhBO/1tv0pR8ZyxP/vMDFX+UC+4hgqpLmy
         pY6aBjsp92yEg==
Subject: [PATCH 3/3] common/report: fix typo in FSSTRESS_AVOID
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, zlang@redhat.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Tue, 28 Mar 2023 17:58:21 -0700
Message-ID: <168005150172.4147931.1361107257343712396.stgit@frogsfrogsfrogs>
In-Reply-To: <168005148468.4147931.1986862498548445502.stgit@frogsfrogsfrogs>
References: <168005148468.4147931.1986862498548445502.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Fix a minor typo.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 common/report |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/common/report b/common/report
index 23ddbb096d..be930e0b06 100644
--- a/common/report
+++ b/common/report
@@ -10,7 +10,7 @@ REPORT_ENV_LIST=("SECTION" "FSTYP" "PLATFORM" "MKFS_OPTIONS" "MOUNT_OPTIONS" \
 		 "SCRATCH_DEV" "SCRATCH_MNT" "OVL_UPPER" "OVL_LOWER" "OVL_WORK")
 
 # Variables that are captured in the report /if/ they are set.
-REPORT_ENV_LIST_OPT=("TAPE_DEV" "RMT_TAPE_DEV" "FSSTRES_AVOID" "FSX_AVOID"
+REPORT_ENV_LIST_OPT=("TAPE_DEV" "RMT_TAPE_DEV" "FSSTRESS_AVOID" "FSX_AVOID"
 		     "KCONFIG_PATH" "PERF_CONFIGNAME" "MIN_FSSIZE"
 		     "IDMAPPED_MOUNTS")
 

