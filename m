Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F8F3C433E0
	for <linux-xfs@archiver.kernel.org>; Sat, 20 Feb 2021 12:17:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 61D2164DE9
	for <linux-xfs@archiver.kernel.org>; Sat, 20 Feb 2021 12:17:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229542AbhBTMRF (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 20 Feb 2021 07:17:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229543AbhBTMRF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 20 Feb 2021 07:17:05 -0500
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD15DC061786
        for <linux-xfs@vger.kernel.org>; Sat, 20 Feb 2021 04:16:24 -0800 (PST)
Received: by mail-wr1-x42f.google.com with SMTP id n8so13525717wrm.10
        for <linux-xfs@vger.kernel.org>; Sat, 20 Feb 2021 04:16:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fishpost-de.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=EZbHTlhmLEJZfhKfXiwGYwo+2s3OfTWv5K82yc3xR7Q=;
        b=v2Lf8xo/s9DeEzalG84KLfdkxJ62JvElhzrzrK4aRakPysD6ZjyBPEeKO/+qJPl9vi
         xN0si3CmQTQUrtRt8MULT69c/KiM3xlzUXp1YQM0Q3mdDSZoIbRYkMZJXfasnACZSSzc
         IFWiSf/r3ygq72p33uW6MIlk1Fn0dBq2B3s4/6ZEyc92eoA6q2ZbOdJDJb8MXLCmjeT8
         rovYUtjStpqKxJKf1NVywO27gX0oyOMcW7duqH68nli/ykH4zgVp+Ts0fOMZJLP1qPT/
         b7kVTLRVBd+Npv8Znh8Ua1TcHimRrkwxOX4pEjm94+8ohma9AMtUhhI+IpCWgy/oRPxV
         JqnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=EZbHTlhmLEJZfhKfXiwGYwo+2s3OfTWv5K82yc3xR7Q=;
        b=b2grdtHXdlPRUAp5HbgJsuKr4nWu3pYEz6zX7c0NKpbV1SPDKgl8aVcYXQIkdkuuSB
         YvTS8Hq432Qbl8sKXZVY4zrZaz0r8yQRSfgXDMMclFrDs1pJw5LNvJGC6hnqT+6OXd8M
         cHtWz08FtJ7GtIgNVtCNbTCV71A0QPzsCZxXab8cS4tdVbCkjk6HPYkESFFmQzJajxMO
         u8dtj7jEcJUxWWdd5Ek/eqK6yh+LB3ADCpdPNS/3fzmNytaDgn7qLdePJdX8832C5hwH
         xZAbAEJjRk5BHpBiHCDy2VmxIDRPoiTNu3O5EYT++EeBDIVMOna4Hbwf6O78zI+PpJJX
         MCRQ==
X-Gm-Message-State: AOAM530z1C5Cduth7LslHmXiKJgrAe0zhEExQuQ+qHDRDHDNZNjKeiWd
        60e+AuO7tFTxWl+ifZjSlkRKXNZm6nanUQ==
X-Google-Smtp-Source: ABdhPJyN0sAMN5wN7++z9s9oPqNKcjb5I5jv+yU9edeGCbq3Rp5+Nzj9Ap5iYDgfULfxdDBI+QU+9w==
X-Received: by 2002:a5d:5441:: with SMTP id w1mr13376080wrv.366.1613823383507;
        Sat, 20 Feb 2021 04:16:23 -0800 (PST)
Received: from thinkbage.fritz.box (p200300d06f2cdf002a7b928337dce408.dip0.t-ipconnect.de. [2003:d0:6f2c:df00:2a7b:9283:37dc:e408])
        by smtp.gmail.com with ESMTPSA id h13sm18708286wrv.20.2021.02.20.04.16.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 20 Feb 2021 04:16:23 -0800 (PST)
From:   Bastian Germann <bastiangermann@fishpost.de>
To:     linux-xfs@vger.kernel.org
Cc:     Bastian Germann <bastiangermann@fishpost.de>,
        Dimitri John Ledkov <xnox@ubuntu.com>
Subject: [PATCH 1/4] debian: Drop trying to create upstream distribution
Date:   Sat, 20 Feb 2021 13:16:06 +0100
Message-Id: <20210220121610.3982-2-bastiangermann@fishpost.de>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210220121610.3982-1-bastiangermann@fishpost.de>
References: <20210220121610.3982-1-bastiangermann@fishpost.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This is a change introduced in 4.3.0+nmu1ubuntu1.

Reported-by: Dimitri John Ledkov <xnox@ubuntu.com>
Signed-off-by: Bastian Germann <bastiangermann@fishpost.de>
---
 debian/changelog | 7 +++++++
 debian/rules     | 1 -
 2 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/debian/changelog b/debian/changelog
index 5421aed6..8320a2e8 100644
--- a/debian/changelog
+++ b/debian/changelog
@@ -1,3 +1,10 @@
+xfsprogs (5.11.0-rc0-1) experimental; urgency=medium
+
+  [ Dimitri John Ledkov ]
+  * Drop trying to create upstream distribution
+
+ -- Bastian Germann <bastiangermann@fishpost.de>  Sat, 20 Feb 2021 11:57:31 +0100
+
 xfsprogs (5.10.0-3) unstable; urgency=medium
 
   * Drop unused dh-python from Build-Depends (Closes: #981361)
diff --git a/debian/rules b/debian/rules
index c6ca5491..8a3345b6 100755
--- a/debian/rules
+++ b/debian/rules
@@ -81,7 +81,6 @@ binary-arch: checkroot built
 	$(pkgme)  $(MAKE) -C . install
 	$(pkgdev) $(MAKE) -C . install-dev
 	$(pkgdi)  $(MAKE) -C debian install-d-i
-	$(pkgme)  $(MAKE) dist
 	install -D -m 0755 debian/local/initramfs.hook debian/xfsprogs/usr/share/initramfs-tools/hooks/xfs
 	rmdir debian/xfslibs-dev/usr/share/doc/xfsprogs
 	rm -f debian/xfslibs-dev/lib/libhandle.la
-- 
2.30.1

