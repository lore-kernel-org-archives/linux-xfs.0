Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B301C433DB
	for <linux-xfs@archiver.kernel.org>; Fri,  5 Feb 2021 00:32:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5A05E64F8C
	for <linux-xfs@archiver.kernel.org>; Fri,  5 Feb 2021 00:32:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231987AbhBEAcR (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 4 Feb 2021 19:32:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232001AbhBEAcR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 4 Feb 2021 19:32:17 -0500
Received: from mail-ed1-x544.google.com (mail-ed1-x544.google.com [IPv6:2a00:1450:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 035FBC061786
        for <linux-xfs@vger.kernel.org>; Thu,  4 Feb 2021 16:31:37 -0800 (PST)
Received: by mail-ed1-x544.google.com with SMTP id s11so6676480edd.5
        for <linux-xfs@vger.kernel.org>; Thu, 04 Feb 2021 16:31:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fishpost-de.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=aYCOTjO6WozIooYceftlno/ysjgOrFBqjPgUsjyco2g=;
        b=ivX/dFXMV2txEcBVXhjt2tRIGW13jy5PCfzCKOtUM9L8/yjp2GLLGh0OA2THcFO32E
         0X3hwdRSP51wLewgNuzIm0P1NJbNtEoOPJ1GS+DtXThZTLlYq0A4fjHV8iY6iSiwrcEG
         PKeACfZGLeu58PcXsMQCUSOHDx4Ik/OeVhDmn0pmGk9VnPGfFu1+fIFsWuf287KS/Whk
         KFaoqB3L5Dquhy7wf2DiRLc0LIorHu3cODeVTDE9lptqK+TYUc/fzziVfSQ9tUj870ts
         eqK9W/d1obdm67zhr3641Lw6u5NUQNxiXK4SZ6lUVUb6uXO5le7WESE91zigVM7OT/vm
         Xelw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=aYCOTjO6WozIooYceftlno/ysjgOrFBqjPgUsjyco2g=;
        b=tJJUCsHW1WAMpySa8w4wkLSWLJUFMoDDyx84N6W8MxGCeDJSmrrAkIbSufXzADmIp1
         k2SO2zoEEo2YRJgJlSdlZuKTDl06NQpnrB4dtzGA/TgCpHiV2CTqnAzn0dPswakSN0Nm
         0Cv6Uu7K18VlCGUlzcLY8xYNLt3UhC7GJC7uZa23mTHC9ji6586C8bnSVrnzoJzkAOIo
         YkJIluhk4N52wiH+mlekBdOqT6m/W8fgAOpXiFn0bqs2wal7+AHMOmy3RpAKBsfK20lg
         9UrIFToO3cTLMVo8A9epMf7E5UvwdnyMIhMNOywJYVKsirDEk9Q4SwFTmeAkwe2E9x0A
         HoUw==
X-Gm-Message-State: AOAM532bxH3vlVOGs56U8IxJ6J8O8YkvZovxxWS5HHkkMH4irL2/lcq+
        7RVUG+upa8RbVjgJh256DslFF+duxyCdFzzS06k=
X-Google-Smtp-Source: ABdhPJw/5YnRUkqXSKlRKRQJm6JWVpME1+zSwEx/XhWIUJaFZB9Oob65i1ukH7PIR0jt5+gUHje1Ig==
X-Received: by 2002:a05:6402:4391:: with SMTP id o17mr1134025edc.196.1612485095758;
        Thu, 04 Feb 2021 16:31:35 -0800 (PST)
Received: from thinkbage.fritz.box (p200300d06f355400ebbce7b10bde1433.dip0.t-ipconnect.de. [2003:d0:6f35:5400:ebbc:e7b1:bde:1433])
        by smtp.gmail.com with ESMTPSA id o10sm3202222eju.89.2021.02.04.16.31.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Feb 2021 16:31:35 -0800 (PST)
From:   Bastian Germann <bastiangermann@fishpost.de>
To:     linux-xfs@vger.kernel.org
Cc:     Bastian Germann <bastiangermann@fishpost.de>,
        Helmut Grohne <helmut@subdivi.de>
Subject: [PATCH 1/3] debian: Drop unused dh-python from Build-Depends
Date:   Fri,  5 Feb 2021 01:31:23 +0100
Message-Id: <20210205003125.24463-2-bastiangermann@fishpost.de>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210205003125.24463-1-bastiangermann@fishpost.de>
References: <20210205003125.24463-1-bastiangermann@fishpost.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

xfsprogs participates in dependency loops relevant to architecture
bootstrap. Identifying easily droppable dependencies, it was found
that xfsprogs does not use dh-python in any way.

Reported-by: Helmut Grohne <helmut@subdivi.de>
Signed-off-by: Bastian Germann <bastiangermann@fishpost.de>
---
 debian/changelog | 6 ++++++
 debian/control   | 2 +-
 2 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/debian/changelog b/debian/changelog
index ce4a224d..7b0120c2 100644
--- a/debian/changelog
+++ b/debian/changelog
@@ -1,3 +1,9 @@
+xfsprogs (5.10.0-3) unstable; urgency=medium
+
+  * Drop unused dh-python from Build-Depends (Closes: #981361)
+
+ -- Bastian Germann <bastiangermann@fishpost.de>  Fri, 05 Feb 2021 00:18:31 +0100
+
 xfsprogs (5.10.0-2) unstable; urgency=low
 
   * Team upload
diff --git a/debian/control b/debian/control
index b0eb1566..8975bd13 100644
--- a/debian/control
+++ b/debian/control
@@ -3,7 +3,7 @@ Section: admin
 Priority: optional
 Maintainer: XFS Development Team <linux-xfs@vger.kernel.org>
 Uploaders: Nathan Scott <nathans@debian.org>, Anibal Monsalve Salazar <anibal@debian.org>, Bastian Germann <bastiangermann@fishpost.de>
-Build-Depends: libinih-dev, uuid-dev, dh-autoreconf, debhelper (>= 5), gettext, libtool, libedit-dev, libblkid-dev (>= 2.17), linux-libc-dev, libdevmapper-dev, libattr1-dev, libicu-dev, dh-python, pkg-config
+Build-Depends: libinih-dev, uuid-dev, dh-autoreconf, debhelper (>= 5), gettext, libtool, libedit-dev, libblkid-dev (>= 2.17), linux-libc-dev, libdevmapper-dev, libattr1-dev, libicu-dev, pkg-config
 Standards-Version: 4.0.0
 Homepage: https://xfs.wiki.kernel.org/
 
-- 
2.30.0

