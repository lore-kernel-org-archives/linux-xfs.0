Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45F3CC433DB
	for <linux-xfs@archiver.kernel.org>; Fri,  5 Feb 2021 00:49:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F332364F7C
	for <linux-xfs@archiver.kernel.org>; Fri,  5 Feb 2021 00:49:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232063AbhBEAt5 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 4 Feb 2021 19:49:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:58988 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232032AbhBEAt5 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 4 Feb 2021 19:49:57 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B878764F51;
        Fri,  5 Feb 2021 00:49:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612486156;
        bh=uOfKQVftWvbzIDkZtVVtNbP7lYoo3snGAK2lfBY7XZM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=JnLX8z78aJYmuVvo/4M5RcpsD+tX/sfKT8GJ2qJxygQPFiUEZAzS164X4lZlsxxDj
         G+Myiz2VARF6VqYnVW2/kSlySOJaqGX+FTZrn2s6whpLmCp9Dlyvg+cDwNEl8qY+1R
         dGEisp1gxRe67xv4B4YGCknXdBE3g2aKMdQ5Pl5lkvC0A6+CsKqClGh/DTWbwNVErd
         2AMFPfAGFbIULk+5bDTZPAluUMRj0fgfuNFG8IKe8Eois7Wmpy4fjv20mzu27Pf+UB
         1Hnbc0UvU7VtayUYCNGkyE1RDsO0xE14xwwhG98lR6qBOOCH9N1vQGtPq+zJxvZNlP
         aPcN6Wgg+S3TA==
Date:   Thu, 4 Feb 2021 16:49:15 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Bastian Germann <bastiangermann@fishpost.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/3] debian: Prevent installing duplicate changelog
Message-ID: <20210205004915.GJ7193@magnolia>
References: <20210205003125.24463-1-bastiangermann@fishpost.de>
 <20210205003125.24463-4-bastiangermann@fishpost.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210205003125.24463-4-bastiangermann@fishpost.de>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Feb 05, 2021 at 01:31:25AM +0100, Bastian Germann wrote:
> The doc/CHANGES file is both processed by dh_installdocs and
> dh_installchangelogs. So it ends up as changelog.gz and CHANGES.gz.
> Prevent that by excluding it from dh_installdocs.
> 
> Signed-off-by: Bastian Germann <bastiangermann@fishpost.de>

/me wonders if a wider cleanup (isn't debhelper up to v12 now?) is in
order but for now,

Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  debian/changelog | 1 +
>  debian/rules     | 2 +-
>  2 files changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/debian/changelog b/debian/changelog
> index 2da58f30..5421aed6 100644
> --- a/debian/changelog
> +++ b/debian/changelog
> @@ -2,6 +2,7 @@ xfsprogs (5.10.0-3) unstable; urgency=medium
>  
>    * Drop unused dh-python from Build-Depends (Closes: #981361)
>    * Only build for Linux
> +  * Prevent installing duplicate changelog (Closes: #570704)
>  
>   -- Bastian Germann <bastiangermann@fishpost.de>  Fri, 05 Feb 2021 00:18:31 +0100
>  
> diff --git a/debian/rules b/debian/rules
> index 7304222c..c6ca5491 100755
> --- a/debian/rules
> +++ b/debian/rules
> @@ -87,7 +87,7 @@ binary-arch: checkroot built
>  	rm -f debian/xfslibs-dev/lib/libhandle.la
>  	rm -f debian/xfslibs-dev/lib/libhandle.a
>  	rm -fr debian/xfslibs-dev/usr/lib
> -	dh_installdocs
> +	dh_installdocs -XCHANGES
>  	dh_installchangelogs
>  	dh_strip
>  	dh_compress
> -- 
> 2.30.0
> 
