Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5625DC433E0
	for <linux-xfs@archiver.kernel.org>; Sat, 16 Jan 2021 09:24:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 05EDE23A9D
	for <linux-xfs@archiver.kernel.org>; Sat, 16 Jan 2021 09:24:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726246AbhAPJYi (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 16 Jan 2021 04:24:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726025AbhAPJYf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 16 Jan 2021 04:24:35 -0500
Received: from mail-ed1-x544.google.com (mail-ed1-x544.google.com [IPv6:2a00:1450:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1EBBC0613D3
        for <linux-xfs@vger.kernel.org>; Sat, 16 Jan 2021 01:23:54 -0800 (PST)
Received: by mail-ed1-x544.google.com with SMTP id b2so12204890edm.3
        for <linux-xfs@vger.kernel.org>; Sat, 16 Jan 2021 01:23:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fishpost-de.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Hpat0mIqOhjGOTo842QK8erQ0eM9mDAQAatNsIZcFQs=;
        b=kw7KFSXkIUz/OtBmpPPo1p7U6frx4kjsd4q2dx0iolV9LKRy7hJuQ7b9gcxcYNBbMl
         dWfxupBWiwPanaFpuImhu/gn5p5T05+qWitbP30gO9+UtrMmVMuXUzhIq4CjDqLZc4YH
         F2kSND1bvfHhXHroNH6okLR5ikwq4cyvoJz89tSYGLvcF2zWuNgSMRL+5BdOK5jmOCdt
         TZqKVccjIuXHXeChuciZHXwOBadeLP6bPcVV/gkGTTWuaKWUeubfUYNJsvXzwJgJnhjT
         yVN5UQBybqAbUmqSbEO2Sr4dF4TgikKZMpz0pQBqkoyCo/X4Qy4VDlMjqWQCcpl89BaI
         VN8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Hpat0mIqOhjGOTo842QK8erQ0eM9mDAQAatNsIZcFQs=;
        b=hhIPus/9JfwWO60qE/Mm9n8RIna5LVeLBqOYkADBy54bPRZIQw8BNFGzbAPPuuVBb3
         mddi6ENbr0NymN3W+MBT5jCxw3yrUonc0Kie62X2b7nu1oDvPrrIksAFOK4x1APSMS7E
         AKjVBhq8LXGi7p05ONroewlzQfXMmOj8uX3KR93VT8Xnk8XVRp8oPB7NFqRXD8dLgVca
         UnOwctRxngar1Mal4b3xJY9THKH2WqzbAk4d+xKzBZQfwLoMx2UESRl6LbM/jd+pt04K
         HctWIhf99ba5Rh7Rph86LTXcXWM6R4wd5AEhXlFkWxuJIJ4gPxawBa5gJ/SjWq6Y8zPs
         +zdg==
X-Gm-Message-State: AOAM5325qoBJmFFRY6z0M1VKB3W64qZ15Jo7WLIOneg7E8GRBmMweEv2
        VZ3uScKGIaX6irzXrCz791Ekef3C1+3T3Ujk
X-Google-Smtp-Source: ABdhPJw/xvgMxRWdrWKn2mETh4IylwGp7ymjIeypaYHWptHEsJSodXJuBOs+IJ2jq+mysnlMmjtFiA==
X-Received: by 2002:a05:6402:a59:: with SMTP id bt25mr10282037edb.73.1610789032948;
        Sat, 16 Jan 2021 01:23:52 -0800 (PST)
Received: from thinkbage.fritz.box (p200300d06f355400ebbce7b10bde1433.dip0.t-ipconnect.de. [2003:d0:6f35:5400:ebbc:e7b1:bde:1433])
        by smtp.gmail.com with ESMTPSA id j25sm6166851edy.13.2021.01.16.01.23.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 16 Jan 2021 01:23:52 -0800 (PST)
From:   Bastian Germann <bastiangermann@fishpost.de>
To:     linux-xfs@vger.kernel.org
Cc:     Bastian Germann <bastiangermann@fishpost.de>,
        Nathan Scott <nathans@debian.org>
Subject: [PATCH v2 1/6] debian: cryptographically verify upstream tarball
Date:   Sat, 16 Jan 2021 10:23:23 +0100
Message-Id: <20210116092328.2667-2-bastiangermann@fishpost.de>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210116092328.2667-1-bastiangermann@fishpost.de>
References: <20210114183747.2507-1-bastiangermann@fishpost.de>
 <20210116092328.2667-1-bastiangermann@fishpost.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Debian's uscan utility can verify a downloaded tarball. As the
uncompressed tarball is signed, the decompress rule has to be applied.

Signed-off-by: Bastian Germann <bastiangermann@fishpost.de>
Reviewed-by: Nathan Scott <nathans@debian.org>
---
 debian/upstream/signing-key.asc | 63 +++++++++++++++++++++++++++++++++
 debian/watch                    |  2 +-
 2 files changed, 64 insertions(+), 1 deletion(-)
 create mode 100644 debian/upstream/signing-key.asc

diff --git a/debian/upstream/signing-key.asc b/debian/upstream/signing-key.asc
new file mode 100644
index 00000000..5a9ec9b8
--- /dev/null
+++ b/debian/upstream/signing-key.asc
@@ -0,0 +1,63 @@
+-----BEGIN PGP PUBLIC KEY BLOCK-----
+
+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
+=El1H
+-----END PGP PUBLIC KEY BLOCK-----
diff --git a/debian/watch b/debian/watch
index 88f6a0f1..ecf0648c 100644
--- a/debian/watch
+++ b/debian/watch
@@ -1,3 +1,3 @@
 version=3
-opts=uversionmangle=s/(\d)[_\.\-\+]?((RC|rc|pre|dev|beta|alpha)\d*)$/$1~$2/ \
+opts=pgpsigurlmangle=s/xz$/sign/,decompress,uversionmangle=s/(\d)[_\.\-\+]?((RC|rc|pre|dev|beta|alpha)\d*)$/$1~$2/ \
 https://www.kernel.org/pub/linux/utils/fs/xfs/xfsprogs/xfsprogs-(.+)\.tar\.xz
-- 
2.30.0

