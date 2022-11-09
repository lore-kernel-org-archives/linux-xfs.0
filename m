Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 818EDC4332F
	for <linux-xfs@archiver.kernel.org>; Wed,  9 Nov 2022 02:08:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229846AbiKICID (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 8 Nov 2022 21:08:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229790AbiKICIA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 8 Nov 2022 21:08:00 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A906868ADD
        for <linux-xfs@vger.kernel.org>; Tue,  8 Nov 2022 18:07:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 681FAB81CF2
        for <linux-xfs@vger.kernel.org>; Wed,  9 Nov 2022 02:07:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17577C433C1;
        Wed,  9 Nov 2022 02:07:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667959677;
        bh=nWpajHOeICKFAToJyw/7xZBo1ulOqQgMlGieysfB9R0=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=dq4LTqyKIoRf7Ih+oD3MRnBQWodbCTgnzS4pdpaUb8Q/U028kySZ/YF9jIVwTh4c8
         XUBU+huv02L7t1ijJhSkWuMejm0a3gvDkDMvE3GMQy8liAL0DVF+ZlTBhSPKW3jNBN
         nmPxyO3LNbVzyRzK+N0v1rIRNP7KoagTbNphXA0mxKqig6fXE5lqQQYtk73Df4eiFr
         JuHXB1zYz90itq4VDOcDj0qDHxysysOS2vMBH5//tL4NEjzrxcfN1fgcjAs44gZMN2
         xN72lL9gbAJsVWsp9vASHhpvyDsbCPGddJqFF35H4Ua3l3cdEgKcRX1WXgOvy1kJM8
         lBCK+DAmwougA==
Subject: [PATCH 24/24] mkfs.xfs: add mkfs config file for the 6.1 LTS kernel
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     cem@kernel.org, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 08 Nov 2022 18:07:56 -0800
Message-ID: <166795967667.3761583.11171982365663628466.stgit@magnolia>
In-Reply-To: <166795954256.3761583.3551179546135782562.stgit@magnolia>
References: <166795954256.3761583.3551179546135782562.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Add a new mkfs config file to reflect the default featureset for the 6.1
LTS release.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 mkfs/Makefile     |    3 ++-
 mkfs/lts_6.1.conf |   14 ++++++++++++++
 2 files changed, 16 insertions(+), 1 deletion(-)
 create mode 100644 mkfs/lts_6.1.conf


diff --git a/mkfs/Makefile b/mkfs/Makefile
index 55d9362f6b..6c7ee186fa 100644
--- a/mkfs/Makefile
+++ b/mkfs/Makefile
@@ -14,7 +14,8 @@ CFGFILES = \
 	lts_4.19.conf \
 	lts_5.4.conf \
 	lts_5.10.conf \
-	lts_5.15.conf
+	lts_5.15.conf \
+	lts_6.1.conf
 
 LLDLIBS += $(LIBXFS) $(LIBXCMD) $(LIBFROG) $(LIBRT) $(LIBBLKID) \
 	$(LIBUUID) $(LIBINIH) $(LIBURCU) $(LIBPTHREAD)
diff --git a/mkfs/lts_6.1.conf b/mkfs/lts_6.1.conf
new file mode 100644
index 0000000000..08bbe9f3c7
--- /dev/null
+++ b/mkfs/lts_6.1.conf
@@ -0,0 +1,14 @@
+# V5 features that were the mkfs defaults when the upstream Linux 6.1 LTS
+# kernel was released at the end of 2022.
+
+[metadata]
+nrext64=0
+bigtime=1
+crc=1
+finobt=1
+inobtcount=1
+reflink=1
+rmapbt=0
+
+[inode]
+sparse=1

