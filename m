Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9CEC9C38142
	for <linux-xfs@archiver.kernel.org>; Wed, 18 Jan 2023 00:22:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229664AbjARAWT (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 17 Jan 2023 19:22:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229675AbjARAVy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 17 Jan 2023 19:21:54 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB1095864D
        for <linux-xfs@vger.kernel.org>; Tue, 17 Jan 2023 15:36:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2C6A8B81A2C
        for <linux-xfs@vger.kernel.org>; Tue, 17 Jan 2023 23:36:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC208C433EF;
        Tue, 17 Jan 2023 23:36:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673998580;
        bh=EVkKaJqJigdr16gkUeW8LCJx8ArEZJq8NkxxUk9jL94=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=sWJ4djidK/+oKU3JAy8lFOP2cljxDBETtvJ5KuNSJL/y0IJXtaaST+dnzChW7/CF6
         xOXCJNEs/C2dH3QAtycS7RyIpeu7p2xLPcKRNnQcbKJyqsXcabFfncFHSNPeqkZXsf
         7ZuMiJgsaEU5psm0peZkmPqy0SAz0k13zRBUkwRFCcjSBrvgqY0mOcUBZtWw7rxHlI
         OgCnCUqbrxiJKH+TolNauaolyvjsdUO9bhcRQ6kqTeaww+4kE6rOljvOLHCNs5X5va
         4TWR3w7nVInZe5053beqo07xjgvmDLUhpc5wmHrmkbxj1UlQfBajC4uL2Wrh1UpX3C
         L8y6hEnArPy1w==
Date:   Tue, 17 Jan 2023 15:36:20 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Csaba Henk <chenk@redhat.com>
Cc:     linux-xfs@vger.kernel.org, Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v2] xfsdocs: add epub output
Message-ID: <Y8cw9FmPu0torrs3@magnolia>
References: <20230116201258.a4debvbbbr724ilm@nixos>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230116201258.a4debvbbbr724ilm@nixos>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jan 16, 2023 at 09:12:58PM +0100, Csaba Henk wrote:
> Epub is a widespread open format for standalone reflowable
> electronic documents, and it's a core feature of Asciidoc tooling
> to be able to produce it, so we can get it "for free".
> ---
>  .gitignore                               |  1 +

This patch lacks a SoB tag and on those grounds cannot be reviewed.

--D

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
