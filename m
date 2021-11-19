Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF24EC433F5
	for <linux-xfs@archiver.kernel.org>; Fri, 19 Nov 2021 17:13:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D524061A56
	for <linux-xfs@archiver.kernel.org>; Fri, 19 Nov 2021 17:13:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229811AbhKSRQP convert rfc822-to-8bit (ORCPT
        <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 19 Nov 2021 12:16:15 -0500
Received: from sender11-of-o53.zoho.eu ([31.186.226.239]:21860 "EHLO
        sender11-of-o53.zoho.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236357AbhKSRQO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 19 Nov 2021 12:16:14 -0500
ARC-Seal: i=1; a=rsa-sha256; t=1637341982; cv=none; 
        d=zohomail.eu; s=zohoarc; 
        b=XMsXFQaFzDePjRuLvxLAYs6oOXoZWZl82K2c+2//onF1Q0ogAMGMHLy+snHuiQsvaxq9LfaeQnktUCGd/932oTk8UeuGEGa0Vb8t39u2u27tqVEQZkUEnFFq/6lQPQygTtpLpP0HdHdbME4vk0y0j+vgxf3tXVaYDK+5ljFkpjI=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
        t=1637341982; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=33keUX5B+eGQkVt2MCjQNk/oCUikdemzpDOuatxyk/E=; 
        b=cGXbVKh2v0afPtAeMR3xIaempzdW0Ewf+lpZD5aqc2H1cVPKLyItSe8YXWMR8yL2urXU3az8tKC/RMP7NtKXE+87j+CBTBPvotOHhhQ5DvUxHCZihMP6chMb37j8UbrfMXf4YEuu3WUIKWy9g5Bdh6TTOECjYEInwMXsfng57mk=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
        spf=pass  smtp.mailfrom=hostmaster@neglo.de;
        dmarc=pass header.from=<bage@debian.org>
Received: from adam.tec.linutronix.de (port-92-200-1-46.dynamic.as20676.net [92.200.1.46]) by mx.zoho.eu
        with SMTPS id 1637341979742448.76393405943054; Fri, 19 Nov 2021 18:12:59 +0100 (CET)
From:   Bastian Germann <bage@debian.org>
To:     linux-xfs@vger.kernel.org
Cc:     Bastian Germann <bage@debian.org>,
        Helmut Grohne <helmut@subdivi.de>
Message-ID: <20211119171241.102173-3-bage@debian.org>
Subject: [PATCH 2/2] debian: Fix FTCBFS: Skip crc32 test (Closes: #999879)
Date:   Fri, 19 Nov 2021 18:12:41 +0100
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211119171241.102173-1-bage@debian.org>
References: <20211119171241.102173-1-bage@debian.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset=utf8
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

xfsprogs fails to cross build from source, because it attempts to build
its crc32 test with the build architecture compiler and thus fails
finding the liburcu, which is only requested for the host architecture.
While this test is useful for native builds, it is not that useful for
cross builds. Skip it by pre-creating the output file.

Reported-by: Helmut Grohne <helmut@subdivi.de>
Signed-off-by: Bastian Germann <bage@debian.org>
---
 debian/rules | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/debian/rules b/debian/rules
index 6d5b82a8..28cc414d 100755
--- a/debian/rules
+++ b/debian/rules
@@ -40,6 +40,9 @@ build-arch: built
 build-indep: built
 built: dibuild config
 	@echo "== dpkg-buildpackage: build" 1>&2
+ifneq ($(DEB_BUILD_ARCH),$(DEB_HOST_ARCH))
+	touch --date=+3day libfrog/crc32selftest
+endif
 	$(MAKE) $(PMAKEFLAGS) default
 	touch built
 
-- 
2.30.2


