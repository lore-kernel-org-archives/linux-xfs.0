Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09FBEEB64DA
	for <linux-xfs@archiver.kernel.org>; Tue, 20 Jun 2023 03:09:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229901AbjFTDJD (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 19 Jun 2023 23:09:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229948AbjFTDI7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 19 Jun 2023 23:08:59 -0400
Received: from mail-oo1-xc2b.google.com (mail-oo1-xc2b.google.com [IPv6:2607:f8b0:4864:20::c2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9AD810D4
        for <linux-xfs@vger.kernel.org>; Mon, 19 Jun 2023 20:08:52 -0700 (PDT)
Received: by mail-oo1-xc2b.google.com with SMTP id 006d021491bc7-5607b8c33ddso805560eaf.0
        for <linux-xfs@vger.kernel.org>; Mon, 19 Jun 2023 20:08:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20221208.gappssmtp.com; s=20221208; t=1687230532; x=1689822532;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=aXfu7eGXTrEJUxJv00iyegCk72E2j9UH1gdn1muyr9s=;
        b=XiiXq79r6dFj1BSEBYlUi2CD9PC00dTWXMDkLayJ2Gjtua4g6kw1WvAACmf2VoO6Md
         yBWXbBfuiklL+HprhzlZ8xVnmT2AEpfCpSDgHetESYlGtRekR5CwiIfIj0rwDHYRHj2D
         4HFXffgEbVctrLjQbFDXIY14FaaSSNBN0dXByNnHqC1bwRfA3gunJlQvTDxfxGYU8Ljk
         gGXVJuzZX84xcCsEE0FHA5PWij92xnYXVyrKRc0ZlLJzVq0wcWaV0S/dDng9MaJK6nmq
         MqSYDa6vCa5sdL5yxxE10+7M3RmS3c4Tncbm9kzVPn186XXeoRLnHNZryMa3yXD97+a1
         yLug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687230532; x=1689822532;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aXfu7eGXTrEJUxJv00iyegCk72E2j9UH1gdn1muyr9s=;
        b=ZqMd2d5gQrRBGyGT3cbIaBEcers9/kWvzGUpyq7Rvxa6jrf/AdF1El0/VJTIrqQkWQ
         UTHHuGJXRUHyJtV5vZkgbBWpczYUMQvt+pGYoqU63MKOMi2qwC5Hbp1sSv5ZaAscRiG7
         DHeG6c6MDylhFcUteHr4kwsDnyUI7y9NgY/9zfbwhdTA/5YCXlAaY85s8fUiHNPYQYxu
         ewYvU6UVwDkHj1y2W6GLx6lGt2XrdWu+/Vs+wflq/IMShQ1KVjTlA2AuWDIdYn2t38/i
         tRkxdhMnAUhd46UpV1FkzQoTDIE9Ez4W/nXOHzVqJyz48Cg8zdVVaRNO+PN3Nit0qpXC
         U07g==
X-Gm-Message-State: AC+VfDxwVeiRx15mTgmvHjBra1R3142RZdzcRw9fLSKHEPVwyaXkCQFQ
        ry0OnkaFO2sMBicnLLHf9AbWvA==
X-Google-Smtp-Source: ACHHUZ6jl5kqMgmIV7+5JxawBDWmHwYnidkwHEe6UvmIdbS7U+nSv3K70DZmza6gJCCI0ikKloazBw==
X-Received: by 2002:a54:4501:0:b0:39a:a9e6:ae9 with SMTP id l1-20020a544501000000b0039aa9e60ae9mr8426071oil.57.1687230532088;
        Mon, 19 Jun 2023 20:08:52 -0700 (PDT)
Received: from dread.disaster.area (pa49-180-13-202.pa.nsw.optusnet.com.au. [49.180.13.202])
        by smtp.gmail.com with ESMTPSA id h7-20020a170902b94700b001b543b4b07esm438226pls.260.2023.06.19.20.08.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Jun 2023 20:08:51 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
        (envelope-from <david@fromorbit.com>)
        id 1qBRjd-00Dtb0-0D;
        Tue, 20 Jun 2023 13:08:49 +1000
Date:   Tue, 20 Jun 2023 13:08:49 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 5/9] xfs: use deferred frees to reap old btree blocks
Message-ID: <ZJEYQYaYKjO/GP9h@dread.disaster.area>
References: <168506055606.3728180.16225214578338421625.stgit@frogsfrogsfrogs>
 <168506055689.3728180.5922242663769047903.stgit@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <168506055689.3728180.5922242663769047903.stgit@frogsfrogsfrogs>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, May 25, 2023 at 05:44:17PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Use deferred frees (EFIs) to reap the blocks of a btree that we just
> replaced.  This helps us to shrink the window in which those old blocks
> could be lost due to a system crash, though we try to flush the EFIs
> every few hundred blocks so that we don't also overflow the transaction
> reservations during and after we commit the new btree.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  fs/xfs/scrub/reap.c |   27 +++++++++++++++++++++++----
>  1 file changed, 23 insertions(+), 4 deletions(-)

.....
> @@ -207,13 +212,22 @@ xrep_reap_block(
>  		xrep_block_reap_binval(sc, fsbno);
>  		error = xrep_put_freelist(sc, agbno);
>  	} else {
> +		/*
> +		 * Use deferred frees to get rid of the old btree blocks to try
> +		 * to minimize the window in which we could crash and lose the
> +		 * old blocks.  However, we still need to roll the transaction
> +		 * every 100 or so EFIs so that we don't exceed the log
> +		 * reservation.
> +		 */
>  		xrep_block_reap_binval(sc, fsbno);
> -		error = xfs_free_extent(sc->tp, sc->sa.pag, agbno, 1, rs->oinfo,
> -				rs->resv);
> +		__xfs_free_extent_later(sc->tp, fsbno, 1, rs->oinfo, true);

Need to capture the returned error here.

-Dave.
-- 
Dave Chinner
david@fromorbit.com
