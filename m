Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 915B9C38142
	for <linux-xfs@archiver.kernel.org>; Wed, 18 Jan 2023 00:59:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229840AbjARA7P (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 17 Jan 2023 19:59:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229522AbjARA6w (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 17 Jan 2023 19:58:52 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86BC91555C
        for <linux-xfs@vger.kernel.org>; Tue, 17 Jan 2023 16:47:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 30942B81645
        for <linux-xfs@vger.kernel.org>; Wed, 18 Jan 2023 00:47:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDDAEC433D2;
        Wed, 18 Jan 2023 00:47:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674002824;
        bh=B4oQvr+tfr4Pb5FPP78HRw/EyvGdq74RL/krXK2xZJ4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=jff9S6ESedfkgZACQliUbgfcZSxnMMI2KICtW0w2gZG4Qb7rjcAZNm1SBUxOExLXK
         5iH0aopEdSCGOsjo2dDAwJomHnULAaXT7Zqr59QMGcnY9NmrJwTybDTd4Xkx+1NxXt
         rBgsbTl7/+eDeovtDZK/ERhF+SC6SYVNfdAG1MoxOWo6bPHYXT6BkAvZw7CWGxxwmf
         0p/o1pSLHBdzruvKieFAyBlWdtNgLoTaLdrm+o/8itG5uF4Om3ro2jcMDXkfTy3tu+
         BrpD4VAeSJWfojl+Hqy85RD7auZU3j4mgnSmHt6ZwL+DeMy7izfWHeWf+ni9lj6bgr
         qIpTTTkvA9tNg==
Date:   Tue, 17 Jan 2023 16:47:04 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Csaba Henk <chenk@redhat.com>
Cc:     linux-xfs@vger.kernel.org, Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v3] xfsdocs: add epub output
Message-ID: <Y8dBiHKZgqZeX+e6@magnolia>
References: <20230118001408.mfx424iq67dfxr3t@nixos>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230118001408.mfx424iq67dfxr3t@nixos>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jan 18, 2023 at 01:14:08AM +0100, Csaba Henk wrote:
> Epub is a widespread open format for standalone reflowable
> electronic documents, and it's a core feature of Asciidoc tooling
> to be able to produce it, so we can get it "for free".
> 
> Signed-off-by: Csaba Henk <chenk@redhat.com>

Looks good, thank you for correcting that oversight!
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
> Delivering SoB that was missing from v2.
> 
>  .gitignore                               |  1 +
>  admin/Makefile                           | 13 +++++++++++--
>  admin/XFS_Performance_Tuning/Makefile    | 13 +++++++++++--
>  design/Makefile                          | 13 +++++++++++--
>  design/XFS_Filesystem_Structure/Makefile | 13 +++++++++++--
>  5 files changed, 45 insertions(+), 8 deletions(-)
> 
> diff --git a/.gitignore b/.gitignore
> index a2e10b4..412ff1c 100644
> --- a/.gitignore
> +++ b/.gitignore
> @@ -1,3 +1,4 @@
>  *.html
>  *.pdf
>  *.css
> +*.epub
> diff --git a/admin/Makefile b/admin/Makefile
> index de27f3b..dcffc63 100644
> --- a/admin/Makefile
> +++ b/admin/Makefile
> @@ -11,6 +11,7 @@ DOCFILES=$(wildcard *.asciidoc)
>  
>  HTML_TARGETS=$(addsuffix .html, $(basename $(DOCFILES)))
>  PDF_TARGETS=$(addsuffix .pdf, $(basename $(DOCFILES)))
> +EPUB_TARGETS=$(addsuffix .epub, $(basename $(DOCFILES)))
>  
>  %.html: %.asciidoc
>  	@echo "[html] $*"
> @@ -20,7 +21,11 @@ PDF_TARGETS=$(addsuffix .pdf, $(basename $(DOCFILES)))
>  	@echo "[pdf] $*"
>  	$(Q)a2x -f pdf $<
>  
> -default: html pdf $(SUBDIRS)
> +%.epub: %.asciidoc
> +	@echo "[epub] $*"
> +	$(Q)a2x -f epub $<
> +
> +default: html pdf epub $(SUBDIRS)
>  
>  $(SUBDIRS):
>  	@echo "Building $@"
> @@ -30,14 +35,18 @@ html: $(HTML_TARGETS)
>  
>  pdf: $(PDF_TARGETS)
>  
> +epub: $(EPUB_TARGETS)
> +
>  # manually construct build dependencies for target builds so that modification
>  # of individual files will trigger a rebuild of the document correctly.
>  $(PDF_TARGETS): $(DOCFILES)
>  
>  $(HTML_TARGETS): $(DOCFILES)
>  
> +$(EPUB_TARGETS): $(DOCFILES)
> +
>  clean: $(addsuffix -clean, $(SUBDIRS))
> -	$(Q)rm -f *.html *.pdf *.css
> +	$(Q)rm -f *.html *.pdf *.css *.epub
>  
>  %-clean:
>  	@echo "Cleaning $*"
> diff --git a/admin/XFS_Performance_Tuning/Makefile b/admin/XFS_Performance_Tuning/Makefile
> index 06451f1..2b929a4 100644
> --- a/admin/XFS_Performance_Tuning/Makefile
> +++ b/admin/XFS_Performance_Tuning/Makefile
> @@ -8,8 +8,9 @@ DOCFILES=$(wildcard *.asciidoc) \
>  
>  HTML_TARGET=$(addsuffix .html, $(TARGET))
>  PDF_TARGET=$(addsuffix .pdf, $(TARGET))
> +EPUB_TARGET=$(addsuffix .epub, $(TARGET))
>  
> -default: html pdf
> +default: html pdf epub
>  
>  %.html: %.asciidoc
>  	@echo "[html] $*"
> @@ -19,16 +20,24 @@ default: html pdf
>  	@echo "[pdf] $*"
>  	$(Q)a2x -f pdf -d book $<
>  
> +%.epub: %.asciidoc
> +	@echo "[epub] $*"
> +	$(Q)a2x -f epub -d book $<
> +
>  html: $(HTML_TARGET)
>  
>  pdf: $(PDF_TARGET)
>  
> +epub: $(EPUB_TARGET)
> +
>  # manually construct build dependencies for target builds so that modification
>  # of individual files will trigger a rebuild of the document correctly.
>  $(PDF_TARGET): $(DOCFILES)
>  
>  $(HTML_TARGET): $(DOCFILES)
>  
> +$(EPUB_TARGET): $(DOCFILES)
> +
>  clean:
> -	$(Q)rm -f *.html *.pdf *.css
> +	$(Q)rm -f *.html *.pdf *.css *.epub
>  
> diff --git a/design/Makefile b/design/Makefile
> index 0879470..0847896 100644
> --- a/design/Makefile
> +++ b/design/Makefile
> @@ -11,6 +11,7 @@ DOCFILES=$(wildcard *.asciidoc)
>  
>  HTML_TARGETS=$(addsuffix .html, $(basename $(DOCFILES)))
>  PDF_TARGETS=$(addsuffix .pdf, $(basename $(DOCFILES)))
> +EPUB_TARGETS=$(addsuffix .epub, $(basename $(DOCFILES)))
>  
>  %.html: %.asciidoc
>  	@echo "[html] $*"
> @@ -20,7 +21,11 @@ PDF_TARGETS=$(addsuffix .pdf, $(basename $(DOCFILES)))
>  	@echo "[pdf] $*"
>  	$(Q)a2x -f pdf --dblatex-opts "-P latex.output.revhistory=0" $<
>  
> -default: html pdf $(SUBDIRS)
> +%.epub: %.asciidoc
> +	@echo "[epub] $*"
> +	$(Q)a2x -f epub $<
> +
> +default: html pdf epub $(SUBDIRS)
>  
>  $(SUBDIRS):
>  	@echo "Building $@"
> @@ -30,14 +35,18 @@ html: $(HTML_TARGETS)
>  
>  pdf: $(PDF_TARGETS)
>  
> +epub: $(EPUB_TARGETS)
> +
>  # manually construct build dependencies for target builds so that modification
>  # of individual files will trigger a rebuild of the document correctly.
>  $(PDF_TARGETS): $(DOCFILES)
>  
>  $(HTML_TARGETS): $(DOCFILES)
>  
> +$(EPUB_TARGETS): $(DOCFILES)
> +
>  clean: $(addsuffix -clean, $(SUBDIRS))
> -	$(Q)rm -f *.html *.pdf *.css
> +	$(Q)rm -f *.html *.pdf *.css *.epub
>  
>  %-clean:
>  	@echo "Cleaning $*"
> diff --git a/design/XFS_Filesystem_Structure/Makefile b/design/XFS_Filesystem_Structure/Makefile
> index 359dd98..be78a75 100644
> --- a/design/XFS_Filesystem_Structure/Makefile
> +++ b/design/XFS_Filesystem_Structure/Makefile
> @@ -8,8 +8,9 @@ DOCFILES=$(wildcard *.asciidoc) \
>  
>  HTML_TARGET=$(addsuffix .html, $(TARGET))
>  PDF_TARGET=$(addsuffix .pdf, $(TARGET))
> +EPUB_TARGET=$(addsuffix .epub, $(TARGET))
>  
> -default: html pdf
> +default: html pdf epub
>  
>  %.html: %.asciidoc
>  	@echo "[html] $*"
> @@ -19,16 +20,24 @@ default: html pdf
>  	@echo "[pdf] $*"
>  	$(Q)a2x -f pdf -d book $<
>  
> +%.epub: %.asciidoc
> +	@echo "[epub] $*"
> +	$(Q)a2x -f epub -d book $<
> +
>  html: $(HTML_TARGET)
>  
>  pdf: $(PDF_TARGET)
>  
> +epub: $(EPUB_TARGET)
> +
>  # manually construct build dependencies for target builds so that modification
>  # of individual files will trigger a rebuild of the document correctly.
>  $(PDF_TARGET): $(DOCFILES)
>  
>  $(HTML_TARGET): $(DOCFILES)
>  
> +$(EPUB_TARGET): $(DOCFILES)
> +
>  clean:
> -	$(Q)rm -f *.html *.pdf *.css
> +	$(Q)rm -f *.html *.pdf *.css *.epub
>  
> -- 
> 2.39.0
> 
