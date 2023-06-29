Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1CC77EB64D9
	for <linux-xfs@archiver.kernel.org>; Thu, 29 Jun 2023 14:56:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231882AbjF2O4s (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 29 Jun 2023 10:56:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232084AbjF2O4r (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 29 Jun 2023 10:56:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7662DE4
        for <linux-xfs@vger.kernel.org>; Thu, 29 Jun 2023 07:56:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 150CA61557
        for <linux-xfs@vger.kernel.org>; Thu, 29 Jun 2023 14:56:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73F6EC433C8;
        Thu, 29 Jun 2023 14:56:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1688050605;
        bh=VaoUGZqLDMWC7h5Gd3AHCR/M/ZlbPjaUHJIsZfVOeEU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=qpNz4FlNqCxXK8WEbptIAXtArl/vklJf2x/6Qk/CPxBStERGunz7wcWiAnP+r0FfA
         N9BjNHf/5h/ZWlCVw1chXxLudeSHaRze/SLqMSI8FZsckKJjZKLNMKEwjAr2TB91/B
         5d12f5Pyi6WsaXkLFbK7PbP2mgmiO+jind4PIUjJOojYs6wPN34pJED4wU9dEcNYGf
         lkril4Z7skwH/QyIVhsdDlxpm36W0+9vzuWgoLjLOqvtT+cTe3NBgBDCyywOxu5xqd
         aAoHHqMQz4frGhlyJTkPBGigzYlBJiq4FgcWU/bBlqrvapcTdFS3mxnaOq9BSNKtZe
         DcXerEQdH09Rw==
Date:   Thu, 29 Jun 2023 07:56:45 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Yaakov Selkowitz <yselkowi@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH] po: fix German translation
Message-ID: <20230629145645.GD11441@frogsfrogsfrogs>
References: <20230627212959.1155472-1-yselkowi@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230627212959.1155472-1-yselkowi@redhat.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jun 27, 2023 at 05:29:31PM -0400, Yaakov Selkowitz wrote:
> gettext-0.22 raises an error on what is clearly an typo in the translation:
> 
>   de.po:3087: 'msgstr' is not a valid C format string, unlike 'msgid'.
>   Reason: In the directive number 2, the argument size specifier is invalid.
> 
> Signed-off-by: Yaakov Selkowitz <yselkowi@redhat.com>

Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  po/de.po | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/po/de.po b/po/de.po
> index 944b0e91..a6f8fde1 100644
> --- a/po/de.po
> +++ b/po/de.po
> @@ -3084,7 +3084,7 @@ msgstr "%llu Spezialdateien\n"
>  #: .././estimate/xfs_estimate.c:191
>  #, c-format
>  msgid "%s will take about %.1f megabytes\n"
> -msgstr "%s wird etwa %.lf Megabytes einnehmen\n"
> +msgstr "%s wird etwa %.1f Megabytes einnehmen\n"
>  
>  #: .././estimate/xfs_estimate.c:198
>  #, c-format
> -- 
> 2.41.0
> 
