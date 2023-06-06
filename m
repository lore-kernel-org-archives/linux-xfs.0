Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A9ECC77B7A
	for <linux-xfs@archiver.kernel.org>; Tue,  6 Jun 2023 11:05:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235310AbjFFLEY (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 6 Jun 2023 07:04:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236800AbjFFLDK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 6 Jun 2023 07:03:10 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E8B419B4
        for <linux-xfs@vger.kernel.org>; Tue,  6 Jun 2023 04:00:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3A38D630C2
        for <linux-xfs@vger.kernel.org>; Tue,  6 Jun 2023 11:00:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F18EBC433D2;
        Tue,  6 Jun 2023 11:00:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1686049222;
        bh=ImnGcQqNL+3RrdLvPC5xVI7bkQ1qR2hRQKOOqlMJ76o=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=OaAACOEasCm+NNP+Cz1JsqB+if1FSBQh1XokorV9ljSx9vGtUUfP+rZi8ZDhEfrne
         rADXX6WAsMww1kMMIUTjh3ll2C+jmzpOtwKGsbbaxxxS1ijEMQKweltiOQ5twTMhrr
         R3hP0zostOfgxL+v35Tferq8S+aq/M7Q/UHpsALgROBGtEktC3iu4b2fZXt6VWKycE
         A1Zru22KrjzsXlIf4EOudp8gN490NipX6gEqpfAF6HhhqIfKzh90a46VKzD4+IGyHJ
         fwjQGFsYZmB7eXL50PsRN7bJ0dD06dqOmkoolvsRLShcbmF4JdjGWw0V4RLuCu+w1+
         pFOAi3nanrR1A==
Date:   Tue, 6 Jun 2023 13:00:18 +0200
From:   Carlos Maiolino <cem@kernel.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 5/5] xfs_repair: fix messaging when fixing imap due to
 sparse cluster
Message-ID: <20230606110018.7nulh32o4sofkfe4@andromeda>
References: <168597945354.1226461.5438962607608083851.stgit@frogsfrogsfrogs>
 <aJGAtH45k9Jhcs30spzFYZFSq8nTC3m_VIeUiYqCtnJnp2edA7w_3H8sySrsaFYlOGTa_eb3Rj9Xiy_rW-9tVw==@protonmail.internalid>
 <168597948159.1226461.18433540672354330389.stgit@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <168597948159.1226461.18433540672354330389.stgit@frogsfrogsfrogs>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jun 05, 2023 at 08:38:01AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> This logic is wrong -- if we're in verbose dry-run mode, we do NOT want
> to say that we're correcting the imap.  Otherwise, we print things like:
> 
> imap claims inode XXX is present, but inode cluster is sparse,
> 
> But then we can erroneously tell the user that we would correct the
> imap when in fact we /are/ correcting it.
> 
> Fixes: f4ff8086586 ("xfs_repair: don't crash on partially sparse inode clusters")
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

> ---
>  repair/dino_chunks.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> 
> diff --git a/repair/dino_chunks.c b/repair/dino_chunks.c
> index 33008853789..171756818a6 100644
> --- a/repair/dino_chunks.c
> +++ b/repair/dino_chunks.c
> @@ -834,7 +834,7 @@ process_inode_chunk(
>  			do_warn(
>  	_("imap claims inode %" PRIu64 " is present, but inode cluster is sparse, "),
>  						ino);
> -			if (verbose || !no_modify)
> +			if (!no_modify)
>  				do_warn(_("correcting imap\n"));
>  			else
>  				do_warn(_("would correct imap\n"));
> 
