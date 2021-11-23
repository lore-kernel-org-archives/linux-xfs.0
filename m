Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 977A8C433F5
	for <linux-xfs@archiver.kernel.org>; Tue, 23 Nov 2021 20:08:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239308AbhKWULU (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 23 Nov 2021 15:11:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:41652 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236505AbhKWULU (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 23 Nov 2021 15:11:20 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A55586056B;
        Tue, 23 Nov 2021 20:08:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637698091;
        bh=wflllseVxY4W52dnzv5ITiu2TFr4Q+E+gxXbqZJglrk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=gUSyQKbIHrTJSA1aaT83A0l0hz1ZdGouG0jF865DxSNRDo/B7RVT/yeJMvJ1uD+2i
         l6JEyPyXB2oEGY3s66/LM+/jAJQmYKSPUYmhFbl3fBXuCsDVluQ6d8hnAFpn/YNmQX
         Fa1BzeKVqCmMih70eRuUEJ0UiullxfSvurA/TvflDwdrSmwxU8+xqjaaxALkkjY7+5
         SDatr5AfB6CRLqQaluK/omTPxJluunY5cOnTib8oEzP7qWtT2uQq94mmmVzqssVyJX
         TQSguMCz2xCahm9vP7SWZ7IzEKujc7y8TErQbNDtT/ANnu798PAm6puUF2xRcEi4jf
         jfkeQ5t5DWVyA==
Date:   Tue, 23 Nov 2021 12:08:11 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Bastian Germann <bage@debian.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/2] debian: Generate .gitcensus instead of .census
 (Closes: #999743)
Message-ID: <20211123200811.GC266024@magnolia>
References: <20211119171241.102173-1-bage@debian.org>
 <20211119171241.102173-2-bage@debian.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211119171241.102173-2-bage@debian.org>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Nov 19, 2021 at 06:12:40PM +0100, Bastian Germann wrote:
> Fix the Debian build outside a git tree (e.g., Debian archive builds) by
> creating an empty .gitcensus instead of .census file on config.
> 
> Signed-off-by: Bastian Germann <bage@debian.org>

Heh.  I used to have a patch that more or less did this, until I
switched to building development packages only from git.  Sorry I forgot
to come back to this one.

Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  debian/rules | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/debian/rules b/debian/rules
> index 615289b4..6d5b82a8 100755
> --- a/debian/rules
> +++ b/debian/rules
> @@ -43,15 +43,15 @@ built: dibuild config
>  	$(MAKE) $(PMAKEFLAGS) default
>  	touch built
>  
> -config: .census
> -.census:
> +config: .gitcensus
> +.gitcensus:
>  	@echo "== dpkg-buildpackage: configure" 1>&2
>  	$(checkdir)
>  	AUTOHEADER=/bin/true dh_autoreconf
>  	dh_update_autotools_config
>  	$(options) $(MAKE) $(PMAKEFLAGS) include/platform_defs.h
>  	cp -f include/install-sh .
> -	touch .census
> +	touch .gitcensus
>  
>  dibuild:
>  	$(checkdir)
> @@ -72,7 +72,7 @@ dibuild:
>  clean:
>  	@echo "== dpkg-buildpackage: clean" 1>&2
>  	$(checkdir)
> -	-rm -f built .census mkfs/mkfs.xfs-$(bootpkg)
> +	-rm -f built .gitcensus mkfs/mkfs.xfs-$(bootpkg)
>  	$(MAKE) distclean
>  	-rm -rf $(dirme) $(dirdev) $(dirdi)
>  	-rm -f debian/*substvars debian/files* debian/*.debhelper
> -- 
> 2.30.2
> 
> 
