Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04899C433EF
	for <linux-xfs@archiver.kernel.org>; Thu,  5 May 2022 16:03:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231164AbiEEQH0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 5 May 2022 12:07:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381617AbiEEQHZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 5 May 2022 12:07:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2646B5C34A
        for <linux-xfs@vger.kernel.org>; Thu,  5 May 2022 09:03:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A502461D76
        for <linux-xfs@vger.kernel.org>; Thu,  5 May 2022 16:03:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BFDAC385A8;
        Thu,  5 May 2022 16:03:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651766625;
        bh=MKiTUAd7aykBOQd9xoEZ8zmD0u7d56gXDkkLHZJPO7k=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=tBL7DasDoUIFuF9yj4XU2zYAP3DKdL5OHeLVB0ihyCcABRgOHSz7I6A23nmtC7Q8u
         MoFS6FzaGt1l7lv0r2HKI+9qmmvEEZi7UvWiINdIb6Hq/iyg0jcGIDdBEpyP4fIOrB
         8xyvl1sqbvI9VpOM2WHg0AfHpxG3N2cemCJYu3/YmWH25QfzsYf+oBLC3GoWzTMMnP
         voiSSXlKWNR8dKBJ+K1cHvBLAoAs+l+sF8iYVMJfvIaDJ3MFB/IiX+8YqFQGB3WCju
         i1+uUtQ5v2s4WjzQ4+KRn8pvWtb7DNQyEEjLDqq4xw8UjVtwzJiK3J6xVGXh8XHUgW
         uLKiuHmta7uRw==
Subject: [PATCH 1/3] debian: refactor common options
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Thu, 05 May 2022 09:03:44 -0700
Message-ID: <165176662449.246788.9880873924749991016.stgit@magnolia>
In-Reply-To: <165176661877.246788.7113237793899538040.stgit@magnolia>
References: <165176661877.246788.7113237793899538040.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Don't respecify identical configure options; move them into the
configure_options variable.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 debian/rules |   12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)


diff --git a/debian/rules b/debian/rules
index 6d5b82a8..df023c65 100755
--- a/debian/rules
+++ b/debian/rules
@@ -26,13 +26,19 @@ pkgdev = DIST_ROOT=`pwd`/$(dirdev); export DIST_ROOT;
 pkgdi  = DIST_ROOT=`pwd`/$(dirdi); export DIST_ROOT;
 stdenv = @GZIP=-q; export GZIP;
 
-configure_options = --build=$(DEB_BUILD_GNU_TYPE) --host=$(DEB_HOST_GNU_TYPE)
+configure_options = \
+	--build=$(DEB_BUILD_GNU_TYPE) \
+	--host=$(DEB_HOST_GNU_TYPE) \
+	--disable-ubsan \
+	--disable-addrsan \
+	--disable-threadsan \
+	--enable-lto
 
 options = export DEBUG=-DNDEBUG DISTRIBUTION=debian \
 	  INSTALL_USER=root INSTALL_GROUP=root \
-	  LOCAL_CONFIGURE_OPTIONS="$(configure_options) --enable-editline=yes --enable-blkid=yes --disable-ubsan --disable-addrsan --disable-threadsan --enable-lto" ;
+	  LOCAL_CONFIGURE_OPTIONS="$(configure_options) --enable-editline=yes --enable-blkid=yes" ;
 diopts  = $(options) \
-	  export OPTIMIZER=-Os LOCAL_CONFIGURE_OPTIONS="$(configure_options) --enable-gettext=no --disable-ubsan --disable-addrsan --disable-threadsan --enable-lto" ;
+	  export OPTIMIZER=-Os LOCAL_CONFIGURE_OPTIONS="$(configure_options) --enable-gettext=no" ;
 checkdir = test -f debian/rules
 
 build: build-arch build-indep

