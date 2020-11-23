Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB62EC63798
	for <linux-xfs@archiver.kernel.org>; Mon, 23 Nov 2020 18:36:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7249B221F7
	for <linux-xfs@archiver.kernel.org>; Mon, 23 Nov 2020 18:36:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729216AbgKWSgb (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 23 Nov 2020 13:36:31 -0500
Received: from sandeen.net ([63.231.237.45]:59422 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730868AbgKWSga (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 23 Nov 2020 13:36:30 -0500
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.146])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id C20BFEDD;
        Mon, 23 Nov 2020 12:36:26 -0600 (CST)
To:     xiakaixu1987@gmail.com, linux-xfs@vger.kernel.org
Cc:     darrick.wong@oracle.com, Kaixu Xia <kaixuxia@tencent.com>
References: <1606124332-22100-1-git-send-email-kaixuxia@tencent.com>
From:   Eric Sandeen <sandeen@sandeen.net>
Subject: Re: [PATCH] xfs: show the proper user quota options
Message-ID: <9ebecd8a-2b3f-6a24-1d9d-1c9c0bf9f017@sandeen.net>
Date:   Mon, 23 Nov 2020 12:36:29 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <1606124332-22100-1-git-send-email-kaixuxia@tencent.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 11/23/20 3:38 AM, xiakaixu1987@gmail.com wrote:
> From: Kaixu Xia <kaixuxia@tencent.com>
> 
> The quota option 'usrquota' should be shown if both the XFS_UQUOTA_ACCT
> and XFS_UQUOTA_ENFD flags are set. The option 'uqnoenforce' should be
> shown when only the XFS_UQUOTA_ACCT flag is set. The current code logic
> seems wrong, Fix it and show proper options.

I'm failing to see the difference in the logic here.  Under the current
code, what combination of flags yields the wrong string, and what does
this patch change in that respect?

Thanks,
-Eric

> 
> Signed-off-by: Kaixu Xia <kaixuxia@tencent.com>
> ---
>  fs/xfs/xfs_super.c | 10 ++++++----
>  1 file changed, 6 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index e3e229e52512..5ebd6cdc44a7 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -199,10 +199,12 @@ xfs_fs_show_options(
>  		seq_printf(m, ",swidth=%d",
>  				(int)XFS_FSB_TO_BB(mp, mp->m_swidth));
>  
> -	if (mp->m_qflags & (XFS_UQUOTA_ACCT|XFS_UQUOTA_ENFD))
> -		seq_puts(m, ",usrquota");
> -	else if (mp->m_qflags & XFS_UQUOTA_ACCT)
> -		seq_puts(m, ",uqnoenforce");
> +	if (mp->m_qflags & XFS_UQUOTA_ACCT) {
> +		if (mp->m_qflags & XFS_UQUOTA_ENFD)
> +			seq_puts(m, ",usrquota");
> +		else
> +			seq_puts(m, ",uqnoenforce");
> +	}
>  
>  	if (mp->m_qflags & XFS_PQUOTA_ACCT) {
>  		if (mp->m_qflags & XFS_PQUOTA_ENFD)
> 
