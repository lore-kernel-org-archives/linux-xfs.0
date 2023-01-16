Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1640AC46467
	for <linux-xfs@archiver.kernel.org>; Mon, 16 Jan 2023 20:14:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231364AbjAPUN7 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 16 Jan 2023 15:13:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231171AbjAPUN6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 16 Jan 2023 15:13:58 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E878D23D95
        for <linux-xfs@vger.kernel.org>; Mon, 16 Jan 2023 12:13:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1673899991;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=5xF7YGLwbuC9Apo1B8+fwnT3i5wfmG74o0bhvHar/PM=;
        b=SMxKOZ2jb6xUTkB61zewifdDe7IxAHog1eZUKXTw4AmeG3PoP5zHVKe7DVMzxP1N0ZR3Ud
        F9qJV74vK0RxlXSsyOt0z38L0Y0++ocG40PdqI6CpsALiq7LxNUcO82wnQMZZ1KwH/N+iy
        Od8BKpHA/JuVlYHklvaT9ScxonoNnk4=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-450-pqoGR64fNXGOdBpSm0E-tA-1; Mon, 16 Jan 2023 15:13:09 -0500
X-MC-Unique: pqoGR64fNXGOdBpSm0E-tA-1
Received: by mail-ed1-f71.google.com with SMTP id b15-20020a056402350f00b0048477a5114bso19495923edd.2
        for <linux-xfs@vger.kernel.org>; Mon, 16 Jan 2023 12:13:08 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5xF7YGLwbuC9Apo1B8+fwnT3i5wfmG74o0bhvHar/PM=;
        b=Caf7RMYNL1erkJVd7WMxkJFHQvGO/QUQxgwqXgI3yrhVw7R4VS934XATsNgjvBrpbY
         IsCGqDJfONjNrm6QVrlw3Uq2kwvbrCWpnx7O0hFrPLwfNGj53eFhXv3RyMJtIRPPgNB/
         mqZrDBjlE8fUdPbAPw6nf9C8X7tlbJjIZKWMO09L3QoKsIMsN4Bc7zT+wErA371x8Bf1
         RJXxw7zhMHPpvT7E/FzD1smZDgUkBSojuPySpr95uZK6ZGcK0bSVshRB4hbDJnuHCryM
         VcBQgq1zP416Ml04CDMYqsNX5J+ZJ5jvBH3QPdA97T+SfXg0kqMDk/5mB+axU0j6xwQ1
         nEJg==
X-Gm-Message-State: AFqh2kqiyYrRt83yf8aixvo84TZk69db8W+6jUOuUBmoChVDBRKPRdJO
        zlziQ7bqaVBdYueHF+KgpE0Q8P2T6vQ0LC8+a1uMuDyDJg891g+L/N68qbU9zFmQ7KDQ2SVc+97
        gfbqr3pGVZo53a8KCo8eTgMASic39lrI/yiOLFBdFHUuaOQgxPMBJNh95renWeIEe3Vsh
X-Received: by 2002:a05:6402:219:b0:499:70a8:f915 with SMTP id t25-20020a056402021900b0049970a8f915mr467341edv.21.1673899987386;
        Mon, 16 Jan 2023 12:13:07 -0800 (PST)
X-Google-Smtp-Source: AMrXdXtd4x78A5dMMNao/td6JJSnInINwwgwltHWiUkgC2Wz2lq9uOOe5wX6eFAedCTlw5ULTbPM2Q==
X-Received: by 2002:a05:6402:219:b0:499:70a8:f915 with SMTP id t25-20020a056402021900b0049970a8f915mr467322edv.21.1673899987074;
        Mon, 16 Jan 2023 12:13:07 -0800 (PST)
Received: from nixos ([2a00:1110:21c:7bf4:669c:ae15:39b5:5f4a])
        by smtp.gmail.com with ESMTPSA id u9-20020a056402110900b00499d0d78540sm7341365edv.39.2023.01.16.12.13.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Jan 2023 12:13:06 -0800 (PST)
Date:   Mon, 16 Jan 2023 21:12:58 +0100
From:   Csaba Henk <chenk@redhat.com>
To:     linux-xfs@vger.kernel.org
Cc:     Dave Chinner <david@fromorbit.com>,
        "Darrick J. Wong" <djwong@kernel.org>
Subject: [PATCH v2] xfsdocs: add epub output
Message-ID: <20230116201258.a4debvbbbr724ilm@nixos>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Epub is a widespread open format for standalone reflowable
electronic documents, and it's a core feature of Asciidoc tooling
to be able to produce it, so we can get it "for free".
---
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

