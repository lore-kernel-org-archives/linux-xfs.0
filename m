Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B61D3C433E0
	for <linux-xfs@archiver.kernel.org>; Sat, 20 Feb 2021 12:17:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8F7FE64ED7
	for <linux-xfs@archiver.kernel.org>; Sat, 20 Feb 2021 12:17:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229645AbhBTMRJ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 20 Feb 2021 07:17:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229630AbhBTMRG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 20 Feb 2021 07:17:06 -0500
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC72AC06178A
        for <linux-xfs@vger.kernel.org>; Sat, 20 Feb 2021 04:16:25 -0800 (PST)
Received: by mail-wr1-x42e.google.com with SMTP id v1so13559811wrd.6
        for <linux-xfs@vger.kernel.org>; Sat, 20 Feb 2021 04:16:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fishpost-de.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=XdnGA00rWYudYvOo8mOHeMSL1on2cEqi8YtXn/C6lCw=;
        b=vV+LEzWFzocYUETN++y6fKCYN11CjwKv7ZdMpiZ5B2IRyn/avKkpWpdeHCSCr1kD/A
         BXstsdlnAfYRh39/JlMEYj6LQQv/C5wCvC8zQPZnNYYfCWzZoM0CkDqto16T78VCSbMI
         NUAwr0+u/f+s6qEOk4c4SAPh8Bm+lNi6FvIYrfZTKiRA98l9b8njqSNWHBZ0w0LkTdIJ
         lWazKav10ayRJ5fXU9bc/pqOeHs13YH66AueqM8e/9OKNlQ/+cd7CrrNqjiJAfsHiyfY
         6VVBjz72+tCGeySNcYo30mCh6wvo7ImjSi9Xiha4Jrj6woCKIxXGwcBEVx8DwCBYbN1c
         u67w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=XdnGA00rWYudYvOo8mOHeMSL1on2cEqi8YtXn/C6lCw=;
        b=ntZNcearFt/o/LOLVFd9hXsJS6AGlBsYXsymJ461J/TCqlf9rekBW1ka/NPuEYj/PK
         7AsZuvmunqILsvxCB1tUbMO4+8bUfcXd+nu/slTJVGlOipUeMo+LwyqqFLaLvb4LjKYo
         3wpGPLLeYi2GAa0V/wJGN2eWexwGqiaDjpURhEPfdDcKPu3sApddsM2UarAqQnQQqSWC
         l6kHxMh6RcBzL9p5Lp2IMMJFihcEVOzaj6FRoucKhKG2MqFe8Uf0wMSFOn7snHxDWncM
         rI5dyGKrBNsoV/c/v/lGK6B6Sjp78CLT7WMVk4br/p1Khqw6w3yfW1OBBCKBDbGwAwvv
         3e8A==
X-Gm-Message-State: AOAM531KVkh4o4+a7mVfCRCdvAhYd0sMeN4rg13c6R3pxrWmBxSi/OVp
        ien099cTwgAYGIT0FB+qi6wRij3UA7kh2A==
X-Google-Smtp-Source: ABdhPJzxJ+wqPCDX/nb0juwt2uEgbSQUFLJDeu1IfqxuT2l0FHxshIEHBU1GY7J4LBLBk+ed2rHe7g==
X-Received: by 2002:a5d:47a2:: with SMTP id 2mr13242786wrb.393.1613823384529;
        Sat, 20 Feb 2021 04:16:24 -0800 (PST)
Received: from thinkbage.fritz.box (p200300d06f2cdf002a7b928337dce408.dip0.t-ipconnect.de. [2003:d0:6f2c:df00:2a7b:9283:37dc:e408])
        by smtp.gmail.com with ESMTPSA id h13sm18708286wrv.20.2021.02.20.04.16.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 20 Feb 2021 04:16:24 -0800 (PST)
From:   Bastian Germann <bastiangermann@fishpost.de>
To:     linux-xfs@vger.kernel.org
Cc:     Bastian Germann <bastiangermann@fishpost.de>,
        Dimitri John Ledkov <xnox@ubuntu.com>
Subject: [PATCH 2/4] debian: Enable CET on amd64
Date:   Sat, 20 Feb 2021 13:16:07 +0100
Message-Id: <20210220121610.3982-3-bastiangermann@fishpost.de>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210220121610.3982-1-bastiangermann@fishpost.de>
References: <20210220121610.3982-1-bastiangermann@fishpost.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This is a change introduced in 5.6.0-1ubuntu3.

Reported-by: Dimitri John Ledkov <xnox@ubuntu.com>
Signed-off-by: Bastian Germann <bastiangermann@fishpost.de>
---
 debian/changelog | 1 +
 debian/rules     | 8 +++++++-
 2 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/debian/changelog b/debian/changelog
index 8320a2e8..c77f04ab 100644
--- a/debian/changelog
+++ b/debian/changelog
@@ -2,6 +2,7 @@ xfsprogs (5.11.0-rc0-1) experimental; urgency=medium
 
   [ Dimitri John Ledkov ]
   * Drop trying to create upstream distribution
+  * Enable CET on amd64
 
  -- Bastian Germann <bastiangermann@fishpost.de>  Sat, 20 Feb 2021 11:57:31 +0100
 
diff --git a/debian/rules b/debian/rules
index 8a3345b6..dd093f2c 100755
--- a/debian/rules
+++ b/debian/rules
@@ -23,8 +23,14 @@ pkgdev = DIST_ROOT=`pwd`/$(dirdev); export DIST_ROOT;
 pkgdi  = DIST_ROOT=`pwd`/$(dirdi); export DIST_ROOT;
 stdenv = @GZIP=-q; export GZIP;
 
+ifeq ($(target),amd64)
+export DEB_CFLAGS_MAINT_APPEND=-fcf-protection
+export DEB_LDFLAGS_MAINT_APPEND=-fcf-protection
+endif
+include /usr/share/dpkg/default.mk
+
 options = export DEBUG=-DNDEBUG DISTRIBUTION=debian \
-	  INSTALL_USER=root INSTALL_GROUP=root \
+	  INSTALL_USER=root INSTALL_GROUP=root LDFLAGS='$(LDFLAGS)' \
 	  LOCAL_CONFIGURE_OPTIONS="--enable-editline=yes --enable-blkid=yes --disable-ubsan --disable-addrsan --disable-threadsan --enable-lto" ;
 diopts  = $(options) \
 	  export OPTIMIZER=-Os LOCAL_CONFIGURE_OPTIONS="--enable-gettext=no --disable-ubsan --disable-addrsan --disable-threadsan --enable-lto" ;
-- 
2.30.1

