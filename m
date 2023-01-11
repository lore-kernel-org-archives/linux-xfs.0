Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88FEAC6379F
	for <linux-xfs@archiver.kernel.org>; Wed, 11 Jan 2023 08:16:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231804AbjAKIQ5 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 11 Jan 2023 03:16:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231824AbjAKIQu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 11 Jan 2023 03:16:50 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12D473882
        for <linux-xfs@vger.kernel.org>; Wed, 11 Jan 2023 00:16:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1673424963;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type;
        bh=l4a4xbHxNshVvzKdEgK1KHgGwTwt7ZuLi1B/6OWXvDs=;
        b=WM83K5N0zGdAknnensLAgxSP2/18iBfvsm6NvZB89CA0AmZRApqdTO7KpqgMOz+JpBr12a
        qHZEzQA/XDr13fJa9DTv1ej9r494X0N+U6LQk6S9PDdzGUz5TyyIUku+9BtDjex3lLdZLx
        b54Hmx/AWst+LuA6HKDbfsmFT3t0Sm0=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-128-AjD36gGvOLCMzXgcR0QMSQ-1; Wed, 11 Jan 2023 03:16:01 -0500
X-MC-Unique: AjD36gGvOLCMzXgcR0QMSQ-1
Received: by mail-wr1-f70.google.com with SMTP id y5-20020adfc7c5000000b002bc02b72d2dso1799326wrg.19
        for <linux-xfs@vger.kernel.org>; Wed, 11 Jan 2023 00:16:01 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-disposition:mime-version:message-id:subject:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=l4a4xbHxNshVvzKdEgK1KHgGwTwt7ZuLi1B/6OWXvDs=;
        b=4y7mk+7XAdIG/CjSEicCve79SQfmxQ5IJGEO2Zd8+EvMqiE/gjEk/P4jai/Pcfannm
         RkkpRvifAM8sh96ycWUBt0MTw/ycRoTmfRio4c08Ms8sP9yYflPSMhPYhMKOR/WeHRpz
         kwhd+hz2HLCSc2szNZtKSbZc5O/eaBGA8aQblZqIKs2tPrxy/4IXpb10gMCrwZCNkKsa
         nHVERvgTHWGyo8YdB/UjS0Cmnvl78ngo5+i6b3f998r0poLWW7l5Z5aNCKA6vNRjAPnj
         F7k1oWPPviCPVEiefetk8tpzlKGlYuYnt6DBc8R9PaNUaoey3yA6cWsYuZk50y8Tx6JB
         MPUg==
X-Gm-Message-State: AFqh2krcWtbs6dIUuFq1rwCnvU9KJqfPZyVPECUFKKM4ScwcnSjvZVvd
        ME64jUn200Imc/QjQPkF3WemcF9gQTIp3De0W47vVV0DqyMbCUSOL+/uKTpNBH3o0NVdPkE4fs2
        ack8pTd+AvBNTmBg5w4qst+CET4xK8kwBriLLET6Am+kQsfMJYOncUbVxDBdD69QKxE0s
X-Received: by 2002:a05:600c:18a1:b0:3d2:3ec4:7eed with SMTP id x33-20020a05600c18a100b003d23ec47eedmr54945661wmp.10.1673424959983;
        Wed, 11 Jan 2023 00:15:59 -0800 (PST)
X-Google-Smtp-Source: AMrXdXsNd//cKOE91MMQC8h64iBcaeXNTbCCMQKChwl/m+0dtfugY1MKx4ooeXd/aROiDuamT7mlcA==
X-Received: by 2002:a05:600c:18a1:b0:3d2:3ec4:7eed with SMTP id x33-20020a05600c18a100b003d23ec47eedmr54945640wmp.10.1673424959635;
        Wed, 11 Jan 2023 00:15:59 -0800 (PST)
Received: from nixos (2A001110012830AB22DCA33598E10310.mobile.pool.telekom.hu. [2a00:1110:128:30ab:22dc:a335:98e1:310])
        by smtp.gmail.com with ESMTPSA id n14-20020a05600c4f8e00b003c6b7f5567csm5226513wmq.0.2023.01.11.00.15.58
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Jan 2023 00:15:59 -0800 (PST)
Date:   Wed, 11 Jan 2023 09:15:57 +0100
From:   Csaba Henk <chenk@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH] xfsdocs: add epub output
Message-ID: <20230111081557.rpmcmkkat7gagqup@nixos>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

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

