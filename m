Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93BA6EB64DD
	for <linux-xfs@archiver.kernel.org>; Tue, 11 Jul 2023 13:53:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230048AbjGKNxc (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 11 Jul 2023 09:53:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229637AbjGKNxb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 11 Jul 2023 09:53:31 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23DA499
        for <linux-xfs@vger.kernel.org>; Tue, 11 Jul 2023 06:53:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B221F614F9
        for <linux-xfs@vger.kernel.org>; Tue, 11 Jul 2023 13:53:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CA6AC433C8;
        Tue, 11 Jul 2023 13:53:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1689083610;
        bh=3I6OaePZNVP28vnslwsHt4vLsN8ahpoSkla+1RxACwo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=kUujzu4d7crTuiOhZR+/GyVwUDxlBLfp5lXJsUPF2fLVwLUO/Hhn2kUjG8W0DHuxA
         N2c8tiRou6ZRC2rKGR6qenzuaScwImeE/GKO8H0niKAetZj78xFvBACtGGFUJiHE4U
         Qg66Wgbyudv4vrQvsB8458qeONTRMbB+ObIw0yUciMu23PCVeawWvA/uLeRreZb3B5
         PzfA7sI1OS3kBNY2omLwUa0L0g7EHhpUO6o238Qq3JXOVKa09oZ3ff7caBc33MoeH3
         VcoZlzzFfy81aXobgBvFInJlVpVinlRuFywpCr7VMTMb1qAwGlwM80KmAGlD+s0Hm7
         NgRPVfSE+5CTg==
Date:   Tue, 11 Jul 2023 15:53:26 +0200
From:   Carlos Maiolino <cem@kernel.org>
To:     Yaakov Selkowitz <yselkowi@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH] po: fix German translation
Message-ID: <20230711135326.q3f232mrp5mwewju@andromeda>
References: <GpsnqyLPmsiNrtxxN7vb1BoFfxOi5TQF3L7Jekci0oG4A7TyS0os07JTRxqqQAfGIIQH7qBQblGdKrrc1G8hgw==@protonmail.internalid>
 <20230627212959.1155472-1-yselkowi@redhat.com>
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

I believe this is the same issue as addressed by the patch below?

commit 987373623e127fe476d29c81625d288d7a418f95
Author: David Seifert <soap@gentoo.org>
Date:   Mon Jun 26 10:50:46 2023 +0100

    po: Fix invalid .de translation format string


-- 
Carlos

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
