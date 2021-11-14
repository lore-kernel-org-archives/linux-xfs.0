Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63301C433EF
	for <linux-xfs@archiver.kernel.org>; Sun, 14 Nov 2021 22:59:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 46CFB6112E
	for <linux-xfs@archiver.kernel.org>; Sun, 14 Nov 2021 22:59:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232607AbhKNXCJ convert rfc822-to-8bit (ORCPT
        <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 14 Nov 2021 18:02:09 -0500
Received: from sender11-of-o53.zoho.eu ([31.186.226.239]:21825 "EHLO
        sender11-of-o53.zoho.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233998AbhKNXCI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 14 Nov 2021 18:02:08 -0500
ARC-Seal: i=1; a=rsa-sha256; t=1636929827; cv=none; 
        d=zohomail.eu; s=zohoarc; 
        b=H1YIK5RfNXkn0/9dWlrXJ1RSEwT3FMghhEaF6BE4jkdLT5rNi23E3CGBKZ5d1XknrgPA6BjqmYeTAXgkLOiSZAwhrbMniMPdAETrxFcJfqSA4fRvxnu5hU3Ep9+KgYmOZ7xWmf5qN0Do3IrX41zhRChvoS2wBdk20x727qoQ//o=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
        t=1636929827; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=05i2Faie2gNb1tI5K4AVC2wrU8vAIfq33J9t9uN+y5Q=; 
        b=W3ARuga4jUFnpRzGO9Xdo1kJl4pXzBQxR1/9BRMMJn/GeCVzgT8vwhTWrFK9btfku7OLsPoojzMyXuFF4THUwpe1yliLApAK9LXfE+6eWn4mGWFgJ8JaUjQXFkVLNjqwSbtXJHdBxuY8wNve8qUXnO2byIjIAgK3uNpZblecDeo=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
        spf=pass  smtp.mailfrom=hostmaster@neglo.de;
        dmarc=pass header.from=<bage@debian.org>
Received: from thinkbage.fritz.box (pd9544ed8.dip0.t-ipconnect.de [217.84.78.216]) by mx.zoho.eu
        with SMTPS id 1636929826341663.974986742343; Sun, 14 Nov 2021 23:43:46 +0100 (CET)
From:   Bastian Germann <bage@debian.org>
To:     linux-xfs@vger.kernel.org
Cc:     Bastian Germann <bage@debian.org>,
        "Darrick J . Wong" <djwong@kernel.org>
Message-ID: <20211114224339.20246-2-bage@debian.org>
Subject: [PATCH v2 1/4] debian: Update Uploaders list
Date:   Sun, 14 Nov 2021 23:43:36 +0100
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211114224339.20246-1-bage@debian.org>
References: <20211114224339.20246-1-bage@debian.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset=utf8
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Set Bastian's debian.org email address.

Signed-off-by: Bastian Germann <bage@debian.org>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 debian/control | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/debian/control b/debian/control
index 71c08167..344466de 100644
--- a/debian/control
+++ b/debian/control
@@ -2,7 +2,7 @@ Source: xfsprogs
 Section: admin
 Priority: optional
 Maintainer: XFS Development Team <linux-xfs@vger.kernel.org>
-Uploaders: Nathan Scott <nathans@debian.org>, Anibal Monsalve Salazar <anibal@debian.org>, Bastian Germann <bastiangermann@fishpost.de>
+Uploaders: Nathan Scott <nathans@debian.org>, Anibal Monsalve Salazar <anibal@debian.org>, Bastian Germann <bage@debian.org>
 Build-Depends: libinih-dev (>= 53), uuid-dev, dh-autoreconf, debhelper (>= 5), gettext, libtool, libedit-dev, libblkid-dev (>= 2.17), linux-libc-dev, libdevmapper-dev, libattr1-dev, libicu-dev, pkg-config, liburcu-dev
 Standards-Version: 4.0.0
 Homepage: https://xfs.wiki.kernel.org/
-- 
2.33.1


