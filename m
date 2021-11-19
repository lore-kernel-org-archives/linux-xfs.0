Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3CCB7C433F5
	for <linux-xfs@archiver.kernel.org>; Fri, 19 Nov 2021 17:13:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0DFBA61A56
	for <linux-xfs@archiver.kernel.org>; Fri, 19 Nov 2021 17:13:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236404AbhKSRQM convert rfc822-to-8bit (ORCPT
        <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 19 Nov 2021 12:16:12 -0500
Received: from sender11-of-o53.zoho.eu ([31.186.226.239]:21858 "EHLO
        sender11-of-o53.zoho.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236357AbhKSRQM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 19 Nov 2021 12:16:12 -0500
ARC-Seal: i=1; a=rsa-sha256; t=1637341980; cv=none; 
        d=zohomail.eu; s=zohoarc; 
        b=f+apWEFMYTJOjycBVxzayIn5JnszYOzDQDTWwX8lZCoRk4a/ggA42KADq+ONB+1xhIcSt9z0CgW+EoRkttIWD7ZqDboVCYg8UcMT8/SmDSCLTg84Xup4JmdC6kRAmYyl7BffGN5Qb20thchvdJ8n7BMJZkzpa6skE2sSTsoiT8M=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
        t=1637341980; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=TlyXti0r6ItYx7OTgCGhhqs+3dHjszN+gmHQ/0kBMfo=; 
        b=esRnbK94zJfY8/9nr+24aR8xbMzZXjyJCwDmkeP51xyP7XymnqcWGiwliHd/X58j0+fCIs/MChK3lxglA/YBicGSi8yt8nWCdK/G+u8NAy3Z1cRNxGLVi/ghgLDMSw5PTx2v/DcamlktEHNZUTCcRVXcSkCER4w/087JCmBIh/I=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
        spf=pass  smtp.mailfrom=hostmaster@neglo.de;
        dmarc=pass header.from=<bage@debian.org>
Received: from adam.tec.linutronix.de (port-92-200-1-46.dynamic.as20676.net [92.200.1.46]) by mx.zoho.eu
        with SMTPS id 1637341978799689.1009790231003; Fri, 19 Nov 2021 18:12:58 +0100 (CET)
From:   Bastian Germann <bage@debian.org>
To:     linux-xfs@vger.kernel.org
Cc:     Bastian Germann <bage@debian.org>
Message-ID: <20211119171241.102173-2-bage@debian.org>
Subject: [PATCH 1/2] debian: Generate .gitcensus instead of .census (Closes: #999743)
Date:   Fri, 19 Nov 2021 18:12:40 +0100
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211119171241.102173-1-bage@debian.org>
References: <20211119171241.102173-1-bage@debian.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset=utf8
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Fix the Debian build outside a git tree (e.g., Debian archive builds) by
creating an empty .gitcensus instead of .census file on config.

Signed-off-by: Bastian Germann <bage@debian.org>
---
 debian/rules | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/debian/rules b/debian/rules
index 615289b4..6d5b82a8 100755
--- a/debian/rules
+++ b/debian/rules
@@ -43,15 +43,15 @@ built: dibuild config
 	$(MAKE) $(PMAKEFLAGS) default
 	touch built
 
-config: .census
-.census:
+config: .gitcensus
+.gitcensus:
 	@echo "== dpkg-buildpackage: configure" 1>&2
 	$(checkdir)
 	AUTOHEADER=/bin/true dh_autoreconf
 	dh_update_autotools_config
 	$(options) $(MAKE) $(PMAKEFLAGS) include/platform_defs.h
 	cp -f include/install-sh .
-	touch .census
+	touch .gitcensus
 
 dibuild:
 	$(checkdir)
@@ -72,7 +72,7 @@ dibuild:
 clean:
 	@echo "== dpkg-buildpackage: clean" 1>&2
 	$(checkdir)
-	-rm -f built .census mkfs/mkfs.xfs-$(bootpkg)
+	-rm -f built .gitcensus mkfs/mkfs.xfs-$(bootpkg)
 	$(MAKE) distclean
 	-rm -rf $(dirme) $(dirdev) $(dirdi)
 	-rm -f debian/*substvars debian/files* debian/*.debhelper
-- 
2.30.2


