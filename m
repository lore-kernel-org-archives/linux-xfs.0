Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AEE27C433EF
	for <linux-xfs@archiver.kernel.org>; Tue,  7 Dec 2021 12:21:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235669AbhLGMZN convert rfc822-to-8bit (ORCPT
        <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 7 Dec 2021 07:25:13 -0500
Received: from sender11-of-o53.zoho.eu ([31.186.226.239]:21825 "EHLO
        sender11-of-o53.zoho.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230107AbhLGMZM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 7 Dec 2021 07:25:12 -0500
ARC-Seal: i=1; a=rsa-sha256; t=1638879691; cv=none; 
        d=zohomail.eu; s=zohoarc; 
        b=C7CKwV6g9c0ScUjwDKG4NqIBdfSfjgvOjSQp2UWqH0E6FBPc9U9hXMSQytmnpGLNh3KtUh1BJM+SVSnprREwKz0j1hh54TilZ+9Hw8D//F/qq5xG0rw156NGXU4RlVCYUQgxFyAzoxOnhoa/H8tUADBk/hWs2/6w6T1X+335Hqg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
        t=1638879691; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=cXhWbnuuDa2tk9Uq+QqWcbSJhT661DsZeagpE0aowvU=; 
        b=ijdcOTxYDVCXSAziPEMUus0T2Y/nV54PL2Pj9EwZAk4/tW+7X0IGlNnqrFlXe2QhmNddLOCXbESx8w1cAQ9OKmy8m02/QUaRUDovJtYycgjGKAcYUHe+IMb5Zz4VYv7MJfM475NO4+PI0n3L2jCAzLRh1Q/VwqKWUxMTSBpUhp4=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
        spf=pass  smtp.mailfrom=hostmaster@neglo.de;
        dmarc=pass header.from=<bage@debian.org>
Received: from thinkbage.fritz.box (p5de0b257.dip0.t-ipconnect.de [93.224.178.87]) by mx.zoho.eu
        with SMTPS id 1638879687900652.9336696653417; Tue, 7 Dec 2021 13:21:27 +0100 (CET)
From:   Bastian Germann <bage@debian.org>
To:     linux-xfs@vger.kernel.org
Cc:     Bastian Germann <bage@debian.org>,
        "Darrick J . Wong" <djwong@kernel.org>
Message-ID: <20211207122110.1448-2-bage@debian.org>
Subject: [PATCH v2 1/1] debian: Generate .gitcensus instead of .census (Closes: #999743)
Date:   Tue,  7 Dec 2021 13:21:10 +0100
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211207122110.1448-1-bage@debian.org>
References: <20211207122110.1448-1-bage@debian.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset=utf8
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Fix the Debian build outside a git tree (e.g., Debian archive builds) by
creating an empty .gitcensus instead of .census file on config.

Signed-off-by: Bastian Germann <bage@debian.org>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
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
2.34.1


