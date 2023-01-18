Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56C10C38142
	for <linux-xfs@archiver.kernel.org>; Wed, 18 Jan 2023 00:41:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229615AbjARAlx (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 17 Jan 2023 19:41:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229620AbjARAlQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 17 Jan 2023 19:41:16 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D14A117171
        for <linux-xfs@vger.kernel.org>; Tue, 17 Jan 2023 16:14:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1674000854;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=JqOE80Do3wOR210dmQVcpHEQ2W63Ro1qw0IV8rR7llA=;
        b=TASwSriEAhdXo3XX3uEcd/N3tb+CHab3Zwx9edEcuNbyrnICYEjo/xt3y0a4gFNcWnACzG
        rnbdPsTOYAFS0occD6Rcdy3+mg7gAlN8u9NQpukl/GfjR5iorE3hfm17zcTsjmf+wbcUcl
        IIIYTTntLfRd5Ej9f6n9wJo4d3eq4NI=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-127-8N81tO__PgqE2yGRPYuvSQ-1; Tue, 17 Jan 2023 19:14:13 -0500
X-MC-Unique: 8N81tO__PgqE2yGRPYuvSQ-1
Received: by mail-ej1-f71.google.com with SMTP id nc27-20020a1709071c1b00b0086dae705676so6450680ejc.12
        for <linux-xfs@vger.kernel.org>; Tue, 17 Jan 2023 16:14:13 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=JqOE80Do3wOR210dmQVcpHEQ2W63Ro1qw0IV8rR7llA=;
        b=DWTyGDQgcLlkqlzVWHNya9cU+GVjSrOfZ3szRjRtG3pSkENHanBxU4xTyZGrU47Jgr
         CR6CP2Xvt8WbLxq+eGARaHRx1hJbsVI98jSM8kJx0B42Gw1Ynv6b45daf849MD83XYye
         uDWAlSXoYjaoYwdmNMP6cMLqT57LWG/IxRs/2CPUyXqXZABXspblqvSWLLq7HGMFlAbD
         QXlDk/m/jO2wejAICvd/KhTT4VgpnUawpbN6TuIjtDc7LmdpmWbEbz//JzIn1ahWERPG
         rKhlVd/Apza4+XbMXNRaHygrrk+R/yCB4EtEhLWuXwg28LLzuxPMkiDGvrRctg8LkDSs
         djSA==
X-Gm-Message-State: AFqh2kq4pevvele5BJZakDuutn3SfoEvAfi449HW26P9CC9ptnoa2l01
        mQ/FMc/B2ZALhaWH7V/A30abVh/NEqP1UWxCGOOiWsErGxP/pvUEfPR+93YaLfQarxcjvKXtfMM
        3IY11ZRXXx6Fu3I0u7fS14RCiZIzUgWgj++jTIByU2PBjyTJxSRlxqJW8DNapD2LinK/g
X-Received: by 2002:aa7:de9a:0:b0:482:d62c:cde with SMTP id j26-20020aa7de9a000000b00482d62c0cdemr18364701edv.13.1674000852005;
        Tue, 17 Jan 2023 16:14:12 -0800 (PST)
X-Google-Smtp-Source: AMrXdXs4Aij5qpX90ON+rI7LldoX4ZpRdvGISrQpIc3A0sGKx1zLFOj3HPbU0FhqESNLeUXoJaSwug==
X-Received: by 2002:aa7:de9a:0:b0:482:d62c:cde with SMTP id j26-20020aa7de9a000000b00482d62c0cdemr18364687edv.13.1674000851725;
        Tue, 17 Jan 2023 16:14:11 -0800 (PST)
Received: from nixos (2A0011100134BA3CEEB24E79074254C1.mobile.pool.telekom.hu. [2a00:1110:134:ba3c:eeb2:4e79:742:54c1])
        by smtp.gmail.com with ESMTPSA id b9-20020a1709063ca900b007c073be0127sm13718903ejh.202.2023.01.17.16.14.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Jan 2023 16:14:11 -0800 (PST)
Date:   Wed, 18 Jan 2023 01:14:08 +0100
From:   Csaba Henk <chenk@redhat.com>
To:     linux-xfs@vger.kernel.org
Cc:     Dave Chinner <david@fromorbit.com>,
        "Darrick J. Wong" <djwong@kernel.org>
Subject: [PATCH v3] xfsdocs: add epub output
Message-ID: <20230118001408.mfx424iq67dfxr3t@nixos>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Epub is a widespread open format for standalone reflowable
electronic documents, and it's a core feature of Asciidoc tooling
to be able to produce it, so we can get it "for free".

Signed-off-by: Csaba Henk <chenk@redhat.com>
---
Delivering SoB that was missing from v2.

 .gitignore                               |  1 +
 admin/Makefile                           | 13 +++++++++++--
 admin/XFS_Performance_Tuning/Makefile    | 13 +++++++++++--
 design/Makefile                          | 13 +++++++++++--
 design/XFS_Filesystem_Structure/Makefile | 13 +++++++++++--
 5 files changed, 45 insertions(+), 8 deletions(-)

diff --git a/.gitignore b/.gitignore
index a2e10b4..412ff1c 100644
--- a/.gitignore
+++ b/.gitignore
@@ -1,3 +1,4 @@
 *.html
 *.pdf
 *.css
+*.epub
diff --git a/admin/Makefile b/admin/Makefile
index de27f3b..dcffc63 100644
--- a/admin/Makefile
+++ b/admin/Makefile
@@ -11,6 +11,7 @@ DOCFILES=$(wildcard *.asciidoc)
 
 HTML_TARGETS=$(addsuffix .html, $(basename $(DOCFILES)))
 PDF_TARGETS=$(addsuffix .pdf, $(basename $(DOCFILES)))
+EPUB_TARGETS=$(addsuffix .epub, $(basename $(DOCFILES)))
 
 %.html: %.asciidoc
 	@echo "[html] $*"
@@ -20,7 +21,11 @@ PDF_TARGETS=$(addsuffix .pdf, $(basename $(DOCFILES)))
 	@echo "[pdf] $*"
 	$(Q)a2x -f pdf $<
 
-default: html pdf $(SUBDIRS)
+%.epub: %.asciidoc
+	@echo "[epub] $*"
+	$(Q)a2x -f epub $<
+
+default: html pdf epub $(SUBDIRS)
 
 $(SUBDIRS):
 	@echo "Building $@"
@@ -30,14 +35,18 @@ html: $(HTML_TARGETS)
 
 pdf: $(PDF_TARGETS)
 
+epub: $(EPUB_TARGETS)
+
 # manually construct build dependencies for target builds so that modification
 # of individual files will trigger a rebuild of the document correctly.
 $(PDF_TARGETS): $(DOCFILES)
 
 $(HTML_TARGETS): $(DOCFILES)
 
+$(EPUB_TARGETS): $(DOCFILES)
+
 clean: $(addsuffix -clean, $(SUBDIRS))
-	$(Q)rm -f *.html *.pdf *.css
+	$(Q)rm -f *.html *.pdf *.css *.epub
 
 %-clean:
 	@echo "Cleaning $*"
diff --git a/admin/XFS_Performance_Tuning/Makefile b/admin/XFS_Performance_Tuning/Makefile
index 06451f1..2b929a4 100644
--- a/admin/XFS_Performance_Tuning/Makefile
+++ b/admin/XFS_Performance_Tuning/Makefile
@@ -8,8 +8,9 @@ DOCFILES=$(wildcard *.asciidoc) \
 
 HTML_TARGET=$(addsuffix .html, $(TARGET))
 PDF_TARGET=$(addsuffix .pdf, $(TARGET))
+EPUB_TARGET=$(addsuffix .epub, $(TARGET))
 
-default: html pdf
+default: html pdf epub
 
 %.html: %.asciidoc
 	@echo "[html] $*"
@@ -19,16 +20,24 @@ default: html pdf
 	@echo "[pdf] $*"
 	$(Q)a2x -f pdf -d book $<
 
+%.epub: %.asciidoc
+	@echo "[epub] $*"
+	$(Q)a2x -f epub -d book $<
+
 html: $(HTML_TARGET)
 
 pdf: $(PDF_TARGET)
 
+epub: $(EPUB_TARGET)
+
 # manually construct build dependencies for target builds so that modification
 # of individual files will trigger a rebuild of the document correctly.
 $(PDF_TARGET): $(DOCFILES)
 
 $(HTML_TARGET): $(DOCFILES)
 
+$(EPUB_TARGET): $(DOCFILES)
+
 clean:
-	$(Q)rm -f *.html *.pdf *.css
+	$(Q)rm -f *.html *.pdf *.css *.epub
 
diff --git a/design/Makefile b/design/Makefile
index 0879470..0847896 100644
--- a/design/Makefile
+++ b/design/Makefile
@@ -11,6 +11,7 @@ DOCFILES=$(wildcard *.asciidoc)
 
 HTML_TARGETS=$(addsuffix .html, $(basename $(DOCFILES)))
 PDF_TARGETS=$(addsuffix .pdf, $(basename $(DOCFILES)))
+EPUB_TARGETS=$(addsuffix .epub, $(basename $(DOCFILES)))
 
 %.html: %.asciidoc
 	@echo "[html] $*"
@@ -20,7 +21,11 @@ PDF_TARGETS=$(addsuffix .pdf, $(basename $(DOCFILES)))
 	@echo "[pdf] $*"
 	$(Q)a2x -f pdf --dblatex-opts "-P latex.output.revhistory=0" $<
 
-default: html pdf $(SUBDIRS)
+%.epub: %.asciidoc
+	@echo "[epub] $*"
+	$(Q)a2x -f epub $<
+
+default: html pdf epub $(SUBDIRS)
 
 $(SUBDIRS):
 	@echo "Building $@"
@@ -30,14 +35,18 @@ html: $(HTML_TARGETS)
 
 pdf: $(PDF_TARGETS)
 
+epub: $(EPUB_TARGETS)
+
 # manually construct build dependencies for target builds so that modification
 # of individual files will trigger a rebuild of the document correctly.
 $(PDF_TARGETS): $(DOCFILES)
 
 $(HTML_TARGETS): $(DOCFILES)
 
+$(EPUB_TARGETS): $(DOCFILES)
+
 clean: $(addsuffix -clean, $(SUBDIRS))
-	$(Q)rm -f *.html *.pdf *.css
+	$(Q)rm -f *.html *.pdf *.css *.epub
 
 %-clean:
 	@echo "Cleaning $*"
diff --git a/design/XFS_Filesystem_Structure/Makefile b/design/XFS_Filesystem_Structure/Makefile
index 359dd98..be78a75 100644
--- a/design/XFS_Filesystem_Structure/Makefile
+++ b/design/XFS_Filesystem_Structure/Makefile
@@ -8,8 +8,9 @@ DOCFILES=$(wildcard *.asciidoc) \
 
 HTML_TARGET=$(addsuffix .html, $(TARGET))
 PDF_TARGET=$(addsuffix .pdf, $(TARGET))
+EPUB_TARGET=$(addsuffix .epub, $(TARGET))
 
-default: html pdf
+default: html pdf epub
 
 %.html: %.asciidoc
 	@echo "[html] $*"
@@ -19,16 +20,24 @@ default: html pdf
 	@echo "[pdf] $*"
 	$(Q)a2x -f pdf -d book $<
 
+%.epub: %.asciidoc
+	@echo "[epub] $*"
+	$(Q)a2x -f epub -d book $<
+
 html: $(HTML_TARGET)
 
 pdf: $(PDF_TARGET)
 
+epub: $(EPUB_TARGET)
+
 # manually construct build dependencies for target builds so that modification
 # of individual files will trigger a rebuild of the document correctly.
 $(PDF_TARGET): $(DOCFILES)
 
 $(HTML_TARGET): $(DOCFILES)
 
+$(EPUB_TARGET): $(DOCFILES)
+
 clean:
-	$(Q)rm -f *.html *.pdf *.css
+	$(Q)rm -f *.html *.pdf *.css *.epub
 
-- 
2.39.0

