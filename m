Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B7B6EB64D7
	for <linux-xfs@archiver.kernel.org>; Fri, 23 Jun 2023 14:05:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229712AbjFWOFo (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 23 Jun 2023 10:05:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230516AbjFWOFk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 23 Jun 2023 10:05:40 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 348B126A1
        for <linux-xfs@vger.kernel.org>; Fri, 23 Jun 2023 07:04:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1687529089;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ZP0IWYqeFzBoqE7uL5sxbIvqLQiDloXBF4Ry3osbSRw=;
        b=S1zXODWieCFSKmWGifW253EjSjMQEGcPhybHHOmB68LV3KLXKqQ6F6sDAful5KAEg0CxSp
        rVZyP9UlIJ9Hyel6RFpPnTXORAkbUjPuhcQdBmJ/17alGQNaoWwhfgwKOAWN6kSiXFwTZz
        uB8V2yuam+DMJ+HsfGjAKotp5CcJQKM=
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
 [209.85.160.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-9-D-VSqi5qM1uh8xO8v2Xukg-1; Fri, 23 Jun 2023 10:04:47 -0400
X-MC-Unique: D-VSqi5qM1uh8xO8v2Xukg-1
Received: by mail-qt1-f197.google.com with SMTP id d75a77b69052e-3ff2a12961dso9968561cf.0
        for <linux-xfs@vger.kernel.org>; Fri, 23 Jun 2023 07:04:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687529085; x=1690121085;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ZP0IWYqeFzBoqE7uL5sxbIvqLQiDloXBF4Ry3osbSRw=;
        b=I+GSB4B5tF5OY7WEOJar4cFDTYOGs83UnKyeMJhHaFEbPrOgUNNotsrIp8eLIe+Ph3
         V0zj6GbThnX77lBtKxdYvnKk16kvl/5lOwXLMZmE+dMFCjlVeTK/c3q76xdCvV93TbA7
         R3QXwrYfiIw7RNzBbeMa3UIybd/1uBJReq5yMNph85n7oxb+rNJ6+7W5xFbk8J9/VYPG
         AVQsPk65ZFm8fgcLQSzEBZ4aYFo+XHMYvriMVYLnC3VOp2afcVaMwkYCRpug67rJkEyf
         ta3i9nRJhRxzGLiyM14eEX6lRpbD3xKJ1mHp2pbZw29/svq3i6Y2Q9lNpJ+FI+kpGWjq
         xzxg==
X-Gm-Message-State: AC+VfDwjnByShGAYq/Z4pqnJPgRnAF6xC8EYYEj/WT63oGNRU2yD+XUS
        LlG0iffadw8muQ5CCIdUg1PKT7cH9mM8/70XeV0OebCpSkrTJr0sprxYSL4YwYqcEbT39inFYBJ
        /gyZrDmBRQ3jvTvYunWdedWa8GriF
X-Received: by 2002:ac8:5753:0:b0:3f6:9a18:e67c with SMTP id 19-20020ac85753000000b003f69a18e67cmr26253071qtx.66.1687529085190;
        Fri, 23 Jun 2023 07:04:45 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ48mn2/k5H++EFxCq2pvCOlJFlun5V6uoqoRnwchpXIADsUrWp9MrOcOQ5V4zS5Af3LHi50tA==
X-Received: by 2002:ac8:5753:0:b0:3f6:9a18:e67c with SMTP id 19-20020ac85753000000b003f69a18e67cmr26253041qtx.66.1687529084828;
        Fri, 23 Jun 2023 07:04:44 -0700 (PDT)
Received: from [192.168.1.104] (gw19-pha-stl-mmo-2.avonet.cz. [131.117.213.218])
        by smtp.gmail.com with ESMTPSA id r26-20020ac867da000000b003ff654694b6sm2492464qtp.46.2023.06.23.07.04.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 23 Jun 2023 07:04:44 -0700 (PDT)
Message-ID: <568b2a82-7ca3-af09-f74b-1ad9c0d85946@redhat.com>
Date:   Fri, 23 Jun 2023 16:04:41 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Subject: Re: [PATCH] xfsrestore: suggest -x rather than assert for false roots
Content-Language: en-US
To:     Donald Douwsma <ddouwsma@redhat.com>, linux-xfs@vger.kernel.org
References: <20230623062918.636014-1-ddouwsma@redhat.com>
From:   Pavel Reichl <preichl@redhat.com>
In-Reply-To: <20230623062918.636014-1-ddouwsma@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org


On 6/23/23 08:29, Donald Douwsma wrote:
> If we're going to have a fix for false root problems its a good idea to
> let people know that there's a way to recover, error out with a useful
> message that mentions the `-x` option rather than just assert.
>
> Before
>
>    xfsrestore: searching media for directory dump
>    xfsrestore: reading directories
>    xfsrestore: tree.c:757: tree_begindir: Assertion `ino != persp->p_rootino || hardh == persp->p_rooth' failed.
>    Aborted
>
> After
>
>    xfsrestore: ERROR: tree.c:791: tree_begindir: Assertion `ino != persp->p_rootino || hardh == persp->p_rooth` failed.
>    xfsrestore: ERROR: False root detected. Recovery may be possible using the `-x` option
>    Aborted
>
> Fixes: d7cba74 ("xfsrestore: fix rootdir due to xfsdump bulkstat misuse")
> Signed-off-by: Donald Douwsma <ddouwsma@redhat.com>
> ---
>   restore/tree.c | 13 +++++++++++--
>   1 file changed, 11 insertions(+), 2 deletions(-)
>
> diff --git a/restore/tree.c b/restore/tree.c
> index bfa07fe..0b65d0f 100644
> --- a/restore/tree.c
> +++ b/restore/tree.c
> @@ -783,8 +783,17 @@ tree_begindir(filehdr_t *fhdrp, dah_t *dahp)
>   	/* lookup head of hardlink list
>   	 */
>   	hardh = link_hardh(ino, gen);
> -	if (need_fixrootdir == BOOL_FALSE)
> -		assert(ino != persp->p_rootino || hardh == persp->p_rooth);
> +	if (need_fixrootdir == BOOL_FALSE
> +		&& !(ino != persp->p_rootino || hardh == persp->p_rooth)) {
> +		mlog(MLOG_ERROR | MLOG_TREE,
Trailing white space
> +			"%s:%d: %s: Assertion "
> +			"`ino != persp->p_rootino || hardh == persp->p_rooth` failed.\n",
> +			__FILE__, __LINE__, __FUNCTION__);
> +		mlog(MLOG_ERROR | MLOG_TREE, _(
> +			"False root detected. "
> +			"Recovery may be possible using the `-x` option\n"));
> +		return NH_NULL;
> +	};
Extra semicolon
>   	/* already present
>   	 */
Otherwise looks good to me, applies and builds.

