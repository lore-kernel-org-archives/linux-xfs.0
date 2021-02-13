Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CDD4DC433DB
	for <linux-xfs@archiver.kernel.org>; Sat, 13 Feb 2021 15:57:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 97AA764DEB
	for <linux-xfs@archiver.kernel.org>; Sat, 13 Feb 2021 15:57:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229647AbhBMP5L (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 13 Feb 2021 10:57:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229574AbhBMP5L (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 13 Feb 2021 10:57:11 -0500
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C99FDC061574;
        Sat, 13 Feb 2021 07:56:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:To:Subject:Sender:
        Reply-To:Cc:Content-ID:Content-Description;
        bh=CEyXeoNTaz3XbI92wKE/JqnYXrD1vSkpetze3AUboaY=; b=D5NYkqVbrl1OGutqjclXUgKuAQ
        ZfZEPJQvm7X+t9Dhdc2FFPTP4tOTa3XhvC6ZnjcdMGbwH9Nd+hQK00e6HFVwZVUYEJNUdJviRzgTY
        e2DqAc6rTI9a5OrIdW6asnKa/ZxbifpQr0pgKRbneGNEYsB31VswXyaurON6zzjkXAoL0yBqgXy7q
        wn47vAriL+RyCvpLi+iyoupTZOqi/beQtmBrWwF1rzwOKiTnF+5J4SRb9vS8aUZGaZgF8AkcIiO2n
        EpugEJx2/xhbTFGQeHk+A9uSqJxg0Tmr/oFX7sQnqLtf9vyYUzjmLPmHB2ZYp5uXfhbD3qMyHko35
        XOMRNo/Q==;
Received: from [2601:1c0:6280:3f0::6444]
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1lAxHX-0007oc-Ji; Sat, 13 Feb 2021 15:56:28 +0000
Subject: Re: [PATCH] docs: ABI: Fix the spelling oustanding to outstanding in
 the file sysfs-fs-xfs
To:     Bhaskar Chowdhury <unixbhaskar@gmail.com>, djwong@kernel.org,
        linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20210213152436.1639458-1-unixbhaskar@gmail.com>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <65a0531d-84b4-0f7f-df5c-ec154af810b8@infradead.org>
Date:   Sat, 13 Feb 2021 07:56:23 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210213152436.1639458-1-unixbhaskar@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 2/13/21 7:24 AM, Bhaskar Chowdhury wrote:
> 
> s/oustanding/outstanding/
> 
> Signed-off-by: Bhaskar Chowdhury <unixbhaskar@gmail.com>

Acked-by: Randy Dunlap <rdunlap@infradead.org>


> ---
>  Documentation/ABI/testing/sysfs-fs-xfs | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/Documentation/ABI/testing/sysfs-fs-xfs b/Documentation/ABI/testing/sysfs-fs-xfs
> index ea0cc8c42093..f704925f6fe9 100644
> --- a/Documentation/ABI/testing/sysfs-fs-xfs
> +++ b/Documentation/ABI/testing/sysfs-fs-xfs
> @@ -33,7 +33,7 @@ Contact:	xfs@oss.sgi.com
>  Description:
>  		The current state of the log write grant head. It
>  		represents the total log reservation of all currently
> -		oustanding transactions, including regrants due to
> +		outstanding transactions, including regrants due to
>  		rolling transactions. The grant head is exported in
>  		"cycle:bytes" format.
>  Users:		xfstests
> --
> 2.30.1
> 


-- 
~Randy

