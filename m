Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2096C433DB
	for <linux-xfs@archiver.kernel.org>; Sat, 20 Mar 2021 20:18:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C3F826193A
	for <linux-xfs@archiver.kernel.org>; Sat, 20 Mar 2021 20:18:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229894AbhCTUR7 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 20 Mar 2021 16:17:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:57622 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229893AbhCTURy (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sat, 20 Mar 2021 16:17:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6653061920;
        Sat, 20 Mar 2021 20:17:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616271474;
        bh=+FBmHMz2aanrmCLBmM0xvTEi8h0RxYjPcLTsDh3uW5Y=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=bSJUeBLRfNhCec1aesohxIhInsQTekSLvJhCH+1jZA9ZmO+Ea58StSw1HrMvH8qGd
         We0Hgnz+eq9/0Z7JLao8lSy1jyrQMzu6zm5vrYd8qNhCBkTWA81fIXjMT951LY3bBz
         CJurk1ehnzssfKQgsEOYuKPeF7vpF/1UJdN3Fq1sh9wDrvz1wy4ggNkcfiptH3MMku
         5fYRht6goMPoUwAHoFzHHv0DdK4jRZPgsRtg3JeIJpIb0ObsXlr+pobGnczEU6Li96
         6TAK+w9MNKrOwkE8C0O0MJfMio1FuBgBzizQdkw2U4XgnO1afd5BK2woxv4n0qLjhi
         XRlSibKookdEA==
Date:   Sat, 20 Mar 2021 13:17:54 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Bhaskar Chowdhury <unixbhaskar@gmail.com>
Cc:     linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        rdunlap@infradead.org
Subject: Re: [PATCH] xfs: Rudimentary typo fixes
Message-ID: <20210320201754.GZ22100@magnolia>
References: <20210320195626.19400-1-unixbhaskar@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210320195626.19400-1-unixbhaskar@gmail.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Mar 21, 2021 at 01:26:26AM +0530, Bhaskar Chowdhury wrote:
> 
> s/filesytem/filesystem/
> s/instrumention/instrumentation/
> 
> Signed-off-by: Bhaskar Chowdhury <unixbhaskar@gmail.com>

Looks good to me,
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_log_recover.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
> index 97f31308de03..ffa4f6f2f31e 100644
> --- a/fs/xfs/xfs_log_recover.c
> +++ b/fs/xfs/xfs_log_recover.c
> @@ -2736,7 +2736,7 @@ xlog_recover_process_one_iunlink(
>   * of log space.
>   *
>   * This behaviour is bad for latency on single CPU and non-preemptible kernels,
> - * and can prevent other filesytem work (such as CIL pushes) from running. This
> + * and can prevent other filesystem work (such as CIL pushes) from running. This
>   * can lead to deadlocks if the recovery process runs out of log reservation
>   * space. Hence we need to yield the CPU when there is other kernel work
>   * scheduled on this CPU to ensure other scheduled work can run without undue
> @@ -3404,7 +3404,7 @@ xlog_recover(
> 
>  		/*
>  		 * Delay log recovery if the debug hook is set. This is debug
> -		 * instrumention to coordinate simulation of I/O failures with
> +		 * instrumentation to coordinate simulation of I/O failures with
>  		 * log recovery.
>  		 */
>  		if (xfs_globals.log_recovery_delay) {
> --
> 2.26.2
> 
