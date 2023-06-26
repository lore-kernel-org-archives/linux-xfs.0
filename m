Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F4E5EB64DD
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Jun 2023 11:39:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229757AbjFZLjN (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 26 Jun 2023 07:39:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230206AbjFZLjA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 26 Jun 2023 07:39:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18675121
        for <linux-xfs@vger.kernel.org>; Mon, 26 Jun 2023 04:39:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A2E8E60DF6
        for <linux-xfs@vger.kernel.org>; Mon, 26 Jun 2023 11:38:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1387C433C8;
        Mon, 26 Jun 2023 11:38:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1687779539;
        bh=T7VEYL2aIDzfDJfreLWJ7Cu00x7XsN0vhp6av2GCR64=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Y2HWaw7caAdNEwOQlhLzx8njhxeJr6zqCkEKjwAczE0fOG8chavoMDjrqfi3zjfJR
         f6g82ijwQikzN6unNdWa7qcqp09sPrwEf//RyHE0hTtfFe77WPVtYAI51WwKARYTAa
         +TEentjNn0jEFNnjTpVSVV+qmjyHzgoPqdi5IghfXb7nQgfRZilX+2u0Fym+O29IFb
         tK6dgnxX5gxN6eXcfa8kN0XLNJBMhvP2GRYvJdCw+yJ+H6dnX699dGozi0+21v1xaS
         V89WHRKDZlwea4/6p9jDjZuvu3jW9YEEyh1b6d13pPDif+ZSMIwvEo494aI2gut+2s
         +2GSiEOHj8ApA==
Date:   Mon, 26 Jun 2023 13:38:54 +0200
From:   Carlos Maiolino <cem@kernel.org>
To:     Sam James <sam@gentoo.org>
Cc:     linux-xfs@vger.kernel.org, David Seifert <soap@gentoo.org>
Subject: Re: [PATCH] po: Fix invalid .de translation format string
Message-ID: <20230626113854.4y7dw72oolodof5n@andromeda>
References: <Bkm2-y9eNDPYVugYDyDJBsF2cCDMR80Go-hAUvMXnJt8E8J4UHgrh2AutjxJmpqQGWYFFkAwIZkAUAUECZsLXQ==@protonmail.internalid>
 <20230626095048.1290476-1-sam@gentoo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230626095048.1290476-1-sam@gentoo.org>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jun 26, 2023 at 10:50:46AM +0100, Sam James wrote:
> From: David Seifert <soap@gentoo.org>
> 
> * gettext-0.22 validates format strings now
>   https://savannah.gnu.org/bugs/index.php?64332#comment1
> 
> Bug: https://bugs.gentoo.org/908864
> Signed-off-by: David Seifert <soap@gentoo.org>
> Signed-off-by: Sam James <sam@gentoo.org>

Seems legit, will test.
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

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
