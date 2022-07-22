Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2FE4AC43334
	for <linux-xfs@archiver.kernel.org>; Fri, 22 Jul 2022 20:20:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235888AbiGVUUY (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 22 Jul 2022 16:20:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235563AbiGVUUX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 22 Jul 2022 16:20:23 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 724351183F
        for <linux-xfs@vger.kernel.org>; Fri, 22 Jul 2022 13:20:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1658521220;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=H0jFzOu3noKQ3ekIyZuGMBqCNF/GGgqTiHfncc0d2IE=;
        b=SoBY39jioNNEQYrUkfsoCvLIxdnSc++ysOCHKwMMEsM1QnsczOEqtPoMtmj9yBp1jzRp9p
        BM+HhepqmJP8Ghxar04xIkapT0a9iH8a6iZjvotbDAY2HZe/tFYS0eD49OM3NC/U6Ixgcf
        jyeR3u2L6dPJQ2oWXJqnFZJ/aoNfJio=
Received: from mail-io1-f69.google.com (mail-io1-f69.google.com
 [209.85.166.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-454-Jb37tcJiOdCk7wtCdp-zDQ-1; Fri, 22 Jul 2022 16:20:13 -0400
X-MC-Unique: Jb37tcJiOdCk7wtCdp-zDQ-1
Received: by mail-io1-f69.google.com with SMTP id i16-20020a5d9350000000b0067bce490d06so2214106ioo.14
        for <linux-xfs@vger.kernel.org>; Fri, 22 Jul 2022 13:20:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=H0jFzOu3noKQ3ekIyZuGMBqCNF/GGgqTiHfncc0d2IE=;
        b=KU50WL7gXQrgLGRMTW1S9Di47XfsPITCGC390hL3MqJ6g8BJ5mzQ3/TpgITZaPD/VW
         IeFA9HbBfZEWe3S65OOf0IR5BlFAdGv4WJTS5ESSk7qwCLO5Qy5aAJB4ah58HCtSjujn
         XGBTOKM6Tkyzq1WJxjJs6qMZdscBE21njcpnw+9GVB0EdIfye8hbM9H4wa9t73SEYTn/
         j0j5vcTWiT4rlKiIIZ3Om8IUiKpZImY8Mpi74xSKAT43YzfBgrIgA2cteb0SK09S6jO3
         vY5/cmC2oBAoL3qUCIIjuztdvGZF0Tl+tGgkEdVzROCXi8bY2tXu0SaFgSbM+PBon1qF
         GuGQ==
X-Gm-Message-State: AJIora/ybeKHW/RIols0J3SpBgFp763NQJ/pBGrExQ7vYO0T/ofEKiqK
        jdOhrJ8VmagGq0hP14Jxyf7oMGU8LNHlf52WQBGV1X6tgHBp3gnpj1fPWD7dgZrWpgyio3DAFsX
        EuKpfvY1VDm+9UDyg4bxh
X-Received: by 2002:a05:6638:1643:b0:33f:7f6b:5e39 with SMTP id a3-20020a056638164300b0033f7f6b5e39mr763336jat.54.1658521212712;
        Fri, 22 Jul 2022 13:20:12 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1upOkUiAnvgRlyhd1ht9n2iE5lbMbPRpFTw/3s38eIjWF/HtEbLvCLsuMB1t/sncdC1jDJbYQ==
X-Received: by 2002:a05:6638:1643:b0:33f:7f6b:5e39 with SMTP id a3-20020a056638164300b0033f7f6b5e39mr763325jat.54.1658521212382;
        Fri, 22 Jul 2022 13:20:12 -0700 (PDT)
Received: from [10.0.0.146] (sandeen.net. [63.231.237.45])
        by smtp.gmail.com with ESMTPSA id k13-20020a02c76d000000b0033f21999e6csm2377807jao.90.2022.07.22.13.20.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 22 Jul 2022 13:20:11 -0700 (PDT)
Message-ID: <d8dfa68b-00d8-9853-e2ba-57c2bb54c05a@redhat.com>
Date:   Fri, 22 Jul 2022 15:20:10 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.11.0
Subject: Re: [PATCH] xfs: Fix comment typo
Content-Language: en-US
To:     Xin Gao <gaoxin@cdjrlc.com>, djwong@kernel.org
Cc:     dchinner@redhat.com, chandan.babu@oracle.com,
        linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20220722193624.18002-1-gaoxin@cdjrlc.com>
From:   Eric Sandeen <sandeen@redhat.com>
In-Reply-To: <20220722193624.18002-1-gaoxin@cdjrlc.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 7/22/22 2:36 PM, Xin Gao wrote:
> The double `for' is duplicated in line 3788, remove one.
> 
> Signed-off-by: Xin Gao <gaoxin@cdjrlc.com>
> ---
>  fs/xfs/libxfs/xfs_bmap.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index 6833110d1bd4..6f6d87ba29a3 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -3785,7 +3785,7 @@ xfs_bmapi_trim_map(
>  		mval->br_startblock = got->br_startblock +
>  					(*bno - got->br_startoff);
>  	/*
> -	 * Return the minimum of what we got and what we asked for for
> +	 * Return the minimum of what we got and what we asked for
>  	 * the length.  We can use the len variable here because it is
>  	 * modified below and we could have been there before coming
>  	 * here if the first part of the allocation didn't overlap what

NAK.

The comment is correct.

