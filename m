Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B72B6C433FE
	for <linux-xfs@archiver.kernel.org>; Thu, 20 Jan 2022 00:23:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345184AbiATAXA (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 19 Jan 2022 19:23:00 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:47500 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345140AbiATAW7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 19 Jan 2022 19:22:59 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D35FCB81A85
        for <linux-xfs@vger.kernel.org>; Thu, 20 Jan 2022 00:22:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F727C004E1;
        Thu, 20 Jan 2022 00:22:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642638177;
        bh=Ua8bISk1CltjDRTsc5gfjGBxbxwg1ntoHanPWUth40w=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=kk2csPx2G19LibQB3Cm/eq3wgGxwx6FFLo2qgT9KQwAAilcYKrCA7TkGkF+acKR9n
         2giUVUZt4xekavevnNaRllRZo1F3Qpch7GzDNaygHEXNQUHkunQto/WR4uHpOJvd8y
         RWnluj4dUQfAj6/GP8mKvDjaE4+BTu1MYaxQ0JRdGVnlo+kI+OsFXenAcAfULTzfNb
         bQoYGBuYF472jkpFBib5M3pwazj2oiFyRjx3yxgb5TgxQpQsgj1rqDt0e9zn5KgOdk
         CIjfn/0R0KppZzY9/7yEWYCzdE87Hli0Qnwcz1NKl/ac+dW09BuzDEh736zhX+r+ZD
         lo3R5idnImD+A==
Subject: [PATCH 15/17] mkfs: document sample configuration file location
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org,
        allison.henderson@oracle.com
Date:   Wed, 19 Jan 2022 16:22:57 -0800
Message-ID: <164263817728.863810.8217395681158803767.stgit@magnolia>
In-Reply-To: <164263809453.863810.8908193461297738491.stgit@magnolia>
References: <164263809453.863810.8908193461297738491.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Update the documentation to note where one can find sample configuration
files.  While we're at it, add -c to the topmost list of mkfs.xfs
options.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 man/man8/Makefile      |    7 +++++++
 man/man8/mkfs.xfs.8.in |    4 ++++
 2 files changed, 11 insertions(+)
 rename man/man8/{mkfs.xfs.8 => mkfs.xfs.8.in} (99%)


diff --git a/man/man8/Makefile b/man/man8/Makefile
index e6a55729..272e45ae 100644
--- a/man/man8/Makefile
+++ b/man/man8/Makefile
@@ -12,8 +12,10 @@ ifneq ("$(ENABLE_SCRUB)","yes")
 else
   MAN_PAGES = $(shell echo *.$(MAN_SECTION))
 endif
+MAN_PAGES	+= mkfs.xfs.8
 MAN_DEST	= $(PKG_MAN_DIR)/man$(MAN_SECTION)
 LSRCFILES	= $(MAN_PAGES)
+DIRT		= mkfs.xfs.8
 
 default : $(MAN_PAGES)
 
@@ -22,4 +24,9 @@ include $(BUILDRULES)
 install : default
 	$(INSTALL) -m 755 -d $(MAN_DEST)
 	$(INSTALL_MAN)
+
+mkfs.xfs.8: mkfs.xfs.8.in
+	@echo "    [SED]    $@"
+	$(Q)$(SED) -e 's|@mkfs_cfg_dir@|$(MKFS_CFG_DIR)|g' < $^ > $@
+
 install-dev :
diff --git a/man/man8/mkfs.xfs.8 b/man/man8/mkfs.xfs.8.in
similarity index 99%
rename from man/man8/mkfs.xfs.8
rename to man/man8/mkfs.xfs.8.in
index 880e949b..a3526753 100644
--- a/man/man8/mkfs.xfs.8
+++ b/man/man8/mkfs.xfs.8.in
@@ -7,6 +7,9 @@ mkfs.xfs \- construct an XFS filesystem
 .B \-b
 .I block_size_options
 ] [
+.B \-c
+.I config_file_options
+] [
 .B \-m
 .I global_metadata_options
 ] [
@@ -159,6 +162,7 @@ The configuration options will be sourced from the file specified by the
 option string.
 This option can be use either an absolute or relative path to the configuration
 file to be read.
+Sample configuration files can be found in @mkfs_cfg_dir@.
 .RE
 .PP
 .PD 0

