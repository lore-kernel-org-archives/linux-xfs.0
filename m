Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF002C433DB
	for <linux-xfs@archiver.kernel.org>; Tue, 23 Mar 2021 16:09:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AD34E619B2
	for <linux-xfs@archiver.kernel.org>; Tue, 23 Mar 2021 16:09:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233043AbhCWQJF (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 23 Mar 2021 12:09:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:36322 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233092AbhCWQIm (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 23 Mar 2021 12:08:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 49C40619C1;
        Tue, 23 Mar 2021 16:08:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616515722;
        bh=hO1oN82kk1N6ajvF5m7nUI4TvWsCm4XawOwdSpk82vw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=T3CdyNpQNReLUwvcHSZVkE3RJFjwpEfMBjjtCOFu3xWtrlLdwe8BRfiYl8+iyB8W7
         qj+/Tnj46DTYW4eyrbgsKuEe248rID4QHdOQ0RCgXNKP2uk3XJd46fVFTfa5yXPAwV
         orY/ijA6C68VMQXxtO0DVE77E5G2oJZsoctRl2OnnmlR0vVMCEBpIkLCneQJb5Oapm
         CiY7SdzAb9Rmi50l7jwvUawjnZZWx+FqHP6vTjPzcAsRrjs+Pwji4+oZyi3uSuRaSX
         HFp+cJE0qhBhUPq0j3RXy5/OgEdCuefRBAFOMYZ4KDfFOF8rRMetK38Tv4pXVSw6Ng
         LVVsLbeyqTqZw==
Date:   Tue, 23 Mar 2021 09:08:41 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Carlos Maiolino <cmaiolino@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH V2] xfs_logprint: Fix buffer overflow printing quotaoff
Message-ID: <20210323160841.GK22100@magnolia>
References: <20210323135314.1595521-1-cmaiolino@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210323135314.1595521-1-cmaiolino@redhat.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Mar 23, 2021 at 02:53:14PM +0100, Carlos Maiolino wrote:
> xlog_recover_print_quotaoff() was using a static buffer to aggregate
> quota option strings to be printed at the end. The buffer size was
> miscalculated and when printing all 3 flags, a buffer overflow occurs
> crashing xfs_logprint, like:
> 
> QOFF: cnt:1 total:1 a:0x560530ff3bb0 len:160
> *** buffer overflow detected ***: terminated
> Aborted (core dumped)
> 
> Fix this by removing the static buffer and using printf() directly to
> print each flag. Also add a trailling space before each flag, so they
> are a bit more readable on the output.
> 
> Reported-by: Eric Sandeen <sandeen@sandeen.net>
> Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>

Seems reasonable to me,
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
> Changelog:
> 
>  - V2:
> 	Update strings removing the "QUOTA" of each printf, resulting
> 	in: "USER GROUP PROJECT"
> 
>  logprint/log_print_all.c | 12 ++++++------
>  1 file changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/logprint/log_print_all.c b/logprint/log_print_all.c
> index 20f2a445..c9c453f6 100644
> --- a/logprint/log_print_all.c
> +++ b/logprint/log_print_all.c
> @@ -186,18 +186,18 @@ xlog_recover_print_quotaoff(
>  	struct xlog_recover_item *item)
>  {
>  	xfs_qoff_logformat_t	*qoff_f;
> -	char			str[32] = { 0 };
>  
>  	qoff_f = (xfs_qoff_logformat_t *)item->ri_buf[0].i_addr;
> +
>  	ASSERT(qoff_f);
> +	printf(_("\tQUOTAOFF: #regs:%d   type:"), qoff_f->qf_size);
>  	if (qoff_f->qf_flags & XFS_UQUOTA_ACCT)
> -		strcat(str, "USER QUOTA");
> +		printf(" USER");
>  	if (qoff_f->qf_flags & XFS_GQUOTA_ACCT)
> -		strcat(str, "GROUP QUOTA");
> +		printf(" GROUP");
>  	if (qoff_f->qf_flags & XFS_PQUOTA_ACCT)
> -		strcat(str, "PROJECT QUOTA");
> -	printf(_("\tQUOTAOFF: #regs:%d   type:%s\n"),
> -	       qoff_f->qf_size, str);
> +		printf(" PROJECT");
> +	printf("\n");
>  }
>  
>  STATIC void
> -- 
> 2.29.2
> 
