Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05582C433C1
	for <linux-xfs@archiver.kernel.org>; Mon, 22 Mar 2021 10:29:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C37406198E
	for <linux-xfs@archiver.kernel.org>; Mon, 22 Mar 2021 10:29:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230080AbhCVK3X (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 22 Mar 2021 06:29:23 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:58220 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230179AbhCVK3I (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 22 Mar 2021 06:29:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1616408947;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ox2FhJ25pkp3n51UNvGgFgCRT1dJN1jVHFdpwBNRx0g=;
        b=YtIPrGgTwP2kNofHedrbENxmUgFnzljeyrTIuZ0CLA0KNg32HDlWBBcksAN7dZqbhDqJg6
        UdX2dHZ5uGTrC9y3N3MnQFDMwY3mxQdrIrrZ/Akd6DjBR2OuQDzJofHbO1WZyYl3q+UDE9
        UYkj+yRm1qIJMxnYbPmZmPDVp+1KHiU=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-155-ncV-w4tCOpij6TxyW3P8Ng-1; Mon, 22 Mar 2021 06:29:05 -0400
X-MC-Unique: ncV-w4tCOpij6TxyW3P8Ng-1
Received: by mail-wm1-f69.google.com with SMTP id c7so14862305wml.8
        for <linux-xfs@vger.kernel.org>; Mon, 22 Mar 2021 03:29:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ox2FhJ25pkp3n51UNvGgFgCRT1dJN1jVHFdpwBNRx0g=;
        b=MigdkXjaRf4wKhdAaoYKfZ96rs/vWBqjR01AI+f4L5R7Ho0R/XnymMI/cjOrM/liaB
         udqC3Q2BI833P50CaVlQrheVIOUDFf5ZyE6M2hXcyh+Xx4InS63vK9/pYYQfV+yEt+St
         5TAlgmtEalpfVFnC3HYmq9RKW4pZBRML4w/zwUdm1282kBAS3QmNPr9rmqyMSOHGp4dg
         RNyQrOIAGp2PpUHC1pk5BQKu4ph1jLmrhgOEpN+BJgUxd+4asMBiL73xebGaFBpkoQJg
         ZWDY2NVG9BucZrEfsziC9FnK16gjg9hFrIbIRF05+2cyO98PeOhCOvIWeYLBnrO0DuFL
         nCIA==
X-Gm-Message-State: AOAM533Srqql86wQpqkiVO2UA6Gi2SoSbEChBynARCfZeIEIAUhhPW2o
        dzGS/MywxJA1G/9hgkZEgxfUlHm8yBWjeUkhAa8fWAN1g9EFzdkyKGzop7mh10SZXqbAhbFUSuK
        C2hlSFcZG0PuHz/BzmQt7Wk6vmXGKoU6tC4exeUxxNn1J1KHddiKRztgdxka1khF2+uqG82U=
X-Received: by 2002:a05:6000:4b:: with SMTP id k11mr17300549wrx.35.1616408944240;
        Mon, 22 Mar 2021 03:29:04 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxejYWsnruS2u3lwPEktkL1HvwhB516nmv9MX4sbEaNWC+Vv8Pyi+DTrM1d1UlXT5MfWxUjpg==
X-Received: by 2002:a05:6000:4b:: with SMTP id k11mr17300536wrx.35.1616408944071;
        Mon, 22 Mar 2021 03:29:04 -0700 (PDT)
Received: from localhost.localdomain ([84.19.91.9])
        by smtp.gmail.com with ESMTPSA id k4sm24794792wrd.9.2021.03.22.03.29.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 22 Mar 2021 03:29:03 -0700 (PDT)
Subject: Re: [PATCH] xfs: Fix a typo
To:     Bhaskar Chowdhury <unixbhaskar@gmail.com>,
        linux-xfs@vger.kernel.org
References: <20210322063926.3755645-1-unixbhaskar@gmail.com>
From:   Pavel Reichl <preichl@redhat.com>
Message-ID: <1ae6dc85-35f1-9e07-af9f-7f50b8f2176c@redhat.com>
Date:   Mon, 22 Mar 2021 11:29:03 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210322063926.3755645-1-unixbhaskar@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 3/22/21 7:39 AM, Bhaskar Chowdhury wrote:
> 
> s/strutures/structures/
> 
> Signed-off-by: Bhaskar Chowdhury <unixbhaskar@gmail.com>
> ---
>  fs/xfs/xfs_aops.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
> index b4186d666157..1cc7c36d98e9 100644
> --- a/fs/xfs/xfs_aops.c
> +++ b/fs/xfs/xfs_aops.c
> @@ -158,7 +158,7 @@ xfs_end_ioend(
>  	nofs_flag = memalloc_nofs_save();
> 
>  	/*
> -	 * Just clean up the in-memory strutures if the fs has been shut down.
> +	 * Just clean up the in-memory structures if the fs has been shut down.
>  	 */
>  	if (XFS_FORCED_SHUTDOWN(ip->i_mount)) {
>  		error = -EIO;
> --
> 2.31.0
> 

Hi,

LGTM,

Reviewed-by: Pavel Reichl <preichl@redhat.com>

Thanks!

