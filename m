Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A65BC7EE26
	for <linux-xfs@archiver.kernel.org>; Tue, 23 May 2023 17:13:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237148AbjEWRNq (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 23 May 2023 13:13:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229506AbjEWRNp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 23 May 2023 13:13:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72EFDCA
        for <linux-xfs@vger.kernel.org>; Tue, 23 May 2023 10:13:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 00887634D9
        for <linux-xfs@vger.kernel.org>; Tue, 23 May 2023 17:13:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49331C433EF;
        Tue, 23 May 2023 17:13:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1684862023;
        bh=getX7qP1K35HRibCNWAixKsr2PTL54SiQd+ZUWzQ+58=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=eltBVY2X0a1TpNHk4Bx0TigUHN1tP+rj88tfFc1V1ZOv5KIYchJJ6jjHWx539/5Z4
         8Hck1JDE5D9HwDokUtM0ViUU/vbRT0NyDGWmiF8l61u46llVIBOylr22aUf2srgkcI
         TMD6+kjXLSk6tfNEDRKXAfwFO+0C5tttRNtvh4cMycDu1vWxu7gbNkHB5alVksTfa9
         G5Qs5hZ9j/XmyjRRiTarOh1M5VGE3A+fEuEbKyDmxNpdXE/sOroIo+jWfBm3ZF5dZ0
         F2ssy2BmZLE751PFdUHcMrA3lcAY2U1ogSTOciIig1ZfHKnGd50r33b9XlVkSNpLnN
         JhTNQTtBBd40w==
Date:   Tue, 23 May 2023 10:13:42 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Chandan Babu R <chandan.babu@oracle.com>
Cc:     cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 07/24] metadump: Postpone invocation of init_metadump()
Message-ID: <20230523171342.GN11620@frogsfrogsfrogs>
References: <20230523090050.373545-1-chandan.babu@oracle.com>
 <20230523090050.373545-8-chandan.babu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230523090050.373545-8-chandan.babu@oracle.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, May 23, 2023 at 02:30:33PM +0530, Chandan Babu R wrote:
> A future commit will require that the metadump file be opened before execution
> of init_metadump().

Why is that?

--D

> Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
> ---
>  db/metadump.c | 11 ++++++-----
>  1 file changed, 6 insertions(+), 5 deletions(-)
> 
> diff --git a/db/metadump.c b/db/metadump.c
> index 62a36427d..212b484a2 100644
> --- a/db/metadump.c
> +++ b/db/metadump.c
> @@ -3129,10 +3129,6 @@ metadump_f(
>  		pop_cur();
>  	}
>  
> -	ret = init_metadump();
> -	if (ret)
> -		return 0;
> -
>  	start_iocur_sp = iocur_sp;
>  
>  	if (strcmp(argv[optind], "-") == 0) {
> @@ -3177,6 +3173,10 @@ metadump_f(
>  		}
>  	}
>  
> +	ret = init_metadump();
> +	if (ret)
> +		return 0;
> +
>  	exitcode = 0;
>  
>  	for (agno = 0; agno < mp->m_sb.sb_agcount; agno++) {
> @@ -3215,8 +3215,9 @@ metadump_f(
>  	/* cleanup iocur stack */
>  	while (iocur_sp > start_iocur_sp)
>  		pop_cur();
> -out:
> +
>  	release_metadump();
>  
> +out:
>  	return 0;
>  }
> -- 
> 2.39.1
> 
