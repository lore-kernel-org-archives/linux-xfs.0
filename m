Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B976CEB64DA
	for <linux-xfs@archiver.kernel.org>; Wed, 12 Jul 2023 17:00:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229446AbjGLRAZ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 12 Jul 2023 13:00:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229907AbjGLRAY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 12 Jul 2023 13:00:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8934E121
        for <linux-xfs@vger.kernel.org>; Wed, 12 Jul 2023 10:00:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 275D261874
        for <linux-xfs@vger.kernel.org>; Wed, 12 Jul 2023 17:00:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80C0AC433C8;
        Wed, 12 Jul 2023 17:00:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1689181222;
        bh=WtkNRMFar5gGJYIHew77v9w52wfWQkiJyZcOFgYhceo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=uIIopRNQKmcXcUwLWsp6gcMVfl7/Utu8p7FrRNdMHhQJPJRXojtHsA/spj2JN4ATn
         GxfpTm68joIt9TkZ8uCHSpvUOKPJpSio/z1v2HthnPfEqqMbJsr/Fs5arH5h54+F7Q
         C5AMcJ9PYpaoUc4U4+qTdpyhJWgWgJK4AoQZlUhO4zJuLo+Fn8bCaZQ0TpGN9nNwCw
         sFvoI3TPnf94MeBtiLQ3Uzy/yD3iswrC2ZQZVzZTdPhJEnQlLn5Vw8QJ/Vw97hHPRU
         COX3sThPHV8MujOS2rgItu9tzIkOPirnnn9MR8xXe/FjsMciGcmWlQxniq5yulctk2
         VTPneFTJ8eXtA==
Date:   Wed, 12 Jul 2023 10:00:21 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Chandan Babu R <chandan.babu@oracle.com>
Cc:     linux-xfs@vger.kernel.org, cem@kernel.org
Subject: Re: [PATCH V2 06/23] metadump: Postpone invocation of init_metadump()
Message-ID: <20230712170021.GF108251@frogsfrogsfrogs>
References: <20230606092806.1604491-1-chandan.babu@oracle.com>
 <20230606092806.1604491-7-chandan.babu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230606092806.1604491-7-chandan.babu@oracle.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jun 06, 2023 at 02:57:49PM +0530, Chandan Babu R wrote:
> The metadump v2 initialization function (introduced in a later commit) writes
> the header structure into the metadump file. This will require the program to
> open the metadump file before the initialization function has been invoked.
> 
> Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>

Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  db/metadump.c | 11 ++++++-----
>  1 file changed, 6 insertions(+), 5 deletions(-)
> 
> diff --git a/db/metadump.c b/db/metadump.c
> index ddb5c622..91150664 100644
> --- a/db/metadump.c
> +++ b/db/metadump.c
> @@ -3124,10 +3124,6 @@ metadump_f(
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
> @@ -3172,6 +3168,10 @@ metadump_f(
>  		}
>  	}
>  
> +	ret = init_metadump();
> +	if (ret)
> +		goto out;
> +
>  	exitcode = 0;
>  
>  	for (agno = 0; agno < mp->m_sb.sb_agcount; agno++) {
> @@ -3209,8 +3209,9 @@ metadump_f(
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
