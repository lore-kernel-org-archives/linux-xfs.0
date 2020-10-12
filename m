Return-Path: <SRS0=uuBg=DT=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 355E9C433DF
	for <linux-xfs@archiver.kernel.org>; Mon, 12 Oct 2020 21:23:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DAA9920838
	for <linux-xfs@archiver.kernel.org>; Mon, 12 Oct 2020 21:23:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731984AbgJLVXe (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 12 Oct 2020 17:23:34 -0400
Received: from sandeen.net ([63.231.237.45]:47506 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726897AbgJLVXe (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 12 Oct 2020 17:23:34 -0400
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.146])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id E293F5EDA6;
        Mon, 12 Oct 2020 16:22:24 -0500 (CDT)
Subject: Re: [PATCH] xfs: fix Kconfig asking about XFS_SUPPORT_V4 when
 XFS_FS=n
To:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        Pavel Machek <pavel@ucw.cz>, xfs <linux-xfs@vger.kernel.org>
Cc:     kernel list <linux-kernel@vger.kernel.org>, dchinner@redhat.com,
        sandeen@redhat.com
References: <20201012211157.GE6559@magnolia>
From:   Eric Sandeen <sandeen@sandeen.net>
Message-ID: <4354fb15-9aa0-0957-eea8-89a930774d40@sandeen.net>
Date:   Mon, 12 Oct 2020 16:23:32 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.3.1
MIME-Version: 1.0
In-Reply-To: <20201012211157.GE6559@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 10/12/20 4:11 PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Pavel Machek complained that the question about supporting deprecated
> XFS v4 comes up even when XFS is disabled.  This clearly makes no sense,
> so fix Kconfig.
> 
> Reported-by: Pavel Machek <pavel@ucw.cz>
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

> ---
>  fs/xfs/Kconfig |    1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/fs/xfs/Kconfig b/fs/xfs/Kconfig
> index 5422227e9e93..9fac5ea8d0e4 100644
> --- a/fs/xfs/Kconfig
> +++ b/fs/xfs/Kconfig
> @@ -24,6 +24,7 @@ config XFS_FS
>  
>  config XFS_SUPPORT_V4
>  	bool "Support deprecated V4 (crc=0) format"
> +	depends on XFS_FS
>  	default y
>  	help
>  	  The V4 filesystem format lacks certain features that are supported
> 
