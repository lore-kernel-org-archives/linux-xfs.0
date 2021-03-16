Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9CAB1C433E0
	for <linux-xfs@archiver.kernel.org>; Tue, 16 Mar 2021 13:46:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 69B7265053
	for <linux-xfs@archiver.kernel.org>; Tue, 16 Mar 2021 13:46:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229537AbhCPNpk (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 16 Mar 2021 09:45:40 -0400
Received: from sandeen.net ([63.231.237.45]:51172 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229947AbhCPNpW (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 16 Mar 2021 09:45:22 -0400
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.146])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 5DB032AD3;
        Tue, 16 Mar 2021 08:44:45 -0500 (CDT)
To:     Carlos Maiolino <cmaiolino@redhat.com>, linux-xfs@vger.kernel.org
References: <20210316090400.35180-1-cmaiolino@redhat.com>
From:   Eric Sandeen <sandeen@sandeen.net>
Subject: Re: [PATCH] xfs_logprint: Fix buffer overflow printing quotaoff
Message-ID: <0a4f390e-53d2-7be9-fc6b-6064f4f8249b@sandeen.net>
Date:   Tue, 16 Mar 2021 08:45:20 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <20210316090400.35180-1-cmaiolino@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 3/16/21 4:04 AM, Carlos Maiolino wrote:
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
> print each flag. 

Yeah, that makes sense. Not sure why it was using a static buffer,
unless I was missing something?

> Also add a trailling space before each flag, so they

"trailing space before?" :) I can fix that up on commit.

> are a bit more readable on the output.
> 
> Reported-by: Eric Sandeen <sandeen@sandeen.net>
> Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
> ---
>  logprint/log_print_all.c | 12 ++++++------
>  1 file changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/logprint/log_print_all.c b/logprint/log_print_all.c
> index 20f2a445..03a32331 100644
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

Ok, we printed this unconditionally before, anyway.

>  	if (qoff_f->qf_flags & XFS_UQUOTA_ACCT)
> -		strcat(str, "USER QUOTA");
> +		printf(" USER QUOTA");
>  	if (qoff_f->qf_flags & XFS_GQUOTA_ACCT)
> -		strcat(str, "GROUP QUOTA");
> +		printf(" GROUP QUOTA");
>  	if (qoff_f->qf_flags & XFS_PQUOTA_ACCT)
> -		strcat(str, "PROJECT QUOTA");
> -	printf(_("\tQUOTAOFF: #regs:%d   type:%s\n"),
> -	       qoff_f->qf_size, str);
> +		printf(" PROJECT QUOTA");

Seems like a clean solution, thanks.

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

> +	printf("\n");
>  }
>  
>  STATIC void
> 
