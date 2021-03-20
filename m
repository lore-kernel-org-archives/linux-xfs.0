Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1392EC433E1
	for <linux-xfs@archiver.kernel.org>; Sat, 20 Mar 2021 22:36:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CDCD76146D
	for <linux-xfs@archiver.kernel.org>; Sat, 20 Mar 2021 22:36:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229846AbhCTWf0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 20 Mar 2021 18:35:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229772AbhCTWfC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 20 Mar 2021 18:35:02 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90A32C061574;
        Sat, 20 Mar 2021 15:35:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Sender:Content-Type:MIME-Version:
        References:Message-ID:In-Reply-To:Subject:cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=J2jkC+1KKBdiXpQmgAO286wapUuhXi76EXsr1/Qf3CY=; b=yvCqVYbRaFJ5yqYEat5fifXRIw
        c+TDL/5rR5eb3/Z+fCM7SwlDGlEFELne4tP+zdeJ0Bl5i0g1KNyTY1PNImshdZ+Hyezyrg2Q9YI8h
        emr3oi2BSAMSZuX2NqP+ghiB76BqjvJ4Tk6HXfE12xFmhptpDXwHG9wovVdiEgl1Oo1n06vysStos
        U0MgB6dDGq+vNs5qKv82IdgIGZLsKoL1IUj7x37BvjnpFENYKsdDHuHKe84etrqUpX6fQJGeVaLA2
        X1YqZuXVytpXHGShT7pqBmnQS6vRQIVsuURgEg2EPkEx3hq9Yz5fsIbwNWCOuVvegVn8IH6R6Qtac
        jw131fDg==;
Received: from rdunlap (helo=localhost)
        by bombadil.infradead.org with local-esmtp (Exim 4.94 #2 (Red Hat Linux))
        id 1lNkBO-0024VP-Vx; Sat, 20 Mar 2021 22:35:00 +0000
Date:   Sat, 20 Mar 2021 15:34:58 -0700 (PDT)
From:   Randy Dunlap <rdunlap@bombadil.infradead.org>
To:     Bhaskar Chowdhury <unixbhaskar@gmail.com>
cc:     djwong@kernel.org, linux-xfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] xfs: Rudimentary typo fixes
In-Reply-To: <20210320195626.19400-1-unixbhaskar@gmail.com>
Message-ID: <87752a94-b0d7-1648-7b97-5a9cf6717211@bombadil.infradead.org>
References: <20210320195626.19400-1-unixbhaskar@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed
Sender: Randy Dunlap <rdunlap@infradead.org>
X-CRM114-Version: 20100106-BlameMichelson ( TRE 0.8.0 (BSD) ) MR-646709E3 
X-CRM114-CacheID: sfid-20210320_153459_050098_FE5985D7 
X-CRM114-Status: GOOD (  13.88  )
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On Sun, 21 Mar 2021, Bhaskar Chowdhury wrote:

>
> s/filesytem/filesystem/
> s/instrumention/instrumentation/
>
> Signed-off-by: Bhaskar Chowdhury <unixbhaskar@gmail.com>

Acked-by: Randy Dunlap <rdunlap@infradead.org>


> ---
> fs/xfs/xfs_log_recover.c | 4 ++--
> 1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
> index 97f31308de03..ffa4f6f2f31e 100644
> --- a/fs/xfs/xfs_log_recover.c
> +++ b/fs/xfs/xfs_log_recover.c
> @@ -2736,7 +2736,7 @@ xlog_recover_process_one_iunlink(
>  * of log space.
>  *
>  * This behaviour is bad for latency on single CPU and non-preemptible kernels,
> - * and can prevent other filesytem work (such as CIL pushes) from running. This
> + * and can prevent other filesystem work (such as CIL pushes) from running. This
>  * can lead to deadlocks if the recovery process runs out of log reservation
>  * space. Hence we need to yield the CPU when there is other kernel work
>  * scheduled on this CPU to ensure other scheduled work can run without undue
> @@ -3404,7 +3404,7 @@ xlog_recover(
>
> 		/*
> 		 * Delay log recovery if the debug hook is set. This is debug
> -		 * instrumention to coordinate simulation of I/O failures with
> +		 * instrumentation to coordinate simulation of I/O failures with
> 		 * log recovery.
> 		 */
> 		if (xfs_globals.log_recovery_delay) {
> --
> 2.26.2
>
>
