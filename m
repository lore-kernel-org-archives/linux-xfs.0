Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35C6DC433EF
	for <linux-xfs@archiver.kernel.org>; Sat, 18 Dec 2021 00:23:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229573AbhLRAXH (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 17 Dec 2021 19:23:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229449AbhLRAXH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 17 Dec 2021 19:23:07 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2502DC061574
        for <linux-xfs@vger.kernel.org>; Fri, 17 Dec 2021 16:23:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AA9E3623C0
        for <linux-xfs@vger.kernel.org>; Sat, 18 Dec 2021 00:23:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09777C36AE5;
        Sat, 18 Dec 2021 00:23:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639786986;
        bh=HEZL3NHLYHkjgeD3ukkhWdwgBC6Qu5w9Hd+n5CLNTTQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=CUG9AsXBV1Sgy/YPAg6HzveTLQWgT5nV3SC2qA/NOlyftqB/VZ4aKVk5H2MSPU/GF
         r0xF1nc5lRd6+7JYyMsVfPlLLX/ANi+ytxiuZyKPqTq5OEj/7MO5Hnh652bSAC9rAj
         LEZKh6zoWltxaNeCzxXI7ZbsOg40ZX66Vlb9xMKB2SGawJIINJ7HyXBbDaXb/YifSv
         ogogPLvagUoRmtLeTHurpAkHbJnGaKbx9K7kkDYagDjFZrYuaG9+QmrnLXWuiq4+1X
         avEIcgkstTejS+UiZpEz8ZzNJei2Xtt1pJDSxggo3nX9y4T3NQri3hZEQj2YtfSmcv
         0x38yUlh0ZWsw==
Date:   Fri, 17 Dec 2021 16:23:05 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Eric Sandeen <sandeen@redhat.com>
Cc:     xfs <linux-xfs@vger.kernel.org>
Subject: [PATCH v2 4/3] mkfs: document sample configuration file location
Message-ID: <20211218002305.GV27664@magnolia>
References: <20211218001616.GB27676@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211218001616.GB27676@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Update the documentation to note where one can find sample configuration
files.  While we're at it, add -c to the topmost list of mkfs.xfs
options.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
v2: use the mkfs config file directory from the build system
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
