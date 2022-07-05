Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA719C433EF
	for <linux-xfs@archiver.kernel.org>; Tue,  5 Jul 2022 15:14:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229452AbiGEPOR (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 5 Jul 2022 11:14:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229489AbiGEPOQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 5 Jul 2022 11:14:16 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id AC9FD1658C
        for <linux-xfs@vger.kernel.org>; Tue,  5 Jul 2022 08:14:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1657034053;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=MygaL1pdlG3Sr890MD+swi1/hJdf/wsGoygZcOOci5Q=;
        b=TsqPQl0yt++Yagk991GBfIH+PPJeDlRVlD0Yjfw8iIdndHB/0/XYLT3x39ynNlMG9hhhoW
        +2C8LKQ7ykT4ZfcjzcGk9l38mjqhtH2WUp0PShjHES0dOxV01dwqC9QBUZ13CiW4woQwwp
        aEgmwPqchekoDBDOLODr8AQpVaZ81ak=
Received: from mail-il1-f199.google.com (mail-il1-f199.google.com
 [209.85.166.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-187-jaUOIrRNO5O7TnfP9r3iFg-1; Tue, 05 Jul 2022 11:14:12 -0400
X-MC-Unique: jaUOIrRNO5O7TnfP9r3iFg-1
Received: by mail-il1-f199.google.com with SMTP id b11-20020a92340b000000b002d3dbbc7b15so5893939ila.5
        for <linux-xfs@vger.kernel.org>; Tue, 05 Jul 2022 08:14:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=MygaL1pdlG3Sr890MD+swi1/hJdf/wsGoygZcOOci5Q=;
        b=OqPLETZvJBo7HT5jVrSG0J2COBh7eorZzUAiROssiBJ2DCF4IG3V8AAa/FI1u6Yc9v
         lSU0b4zN+HfbZvPVhcrMYHtbE5NFiy5j1nX+dSU3oLIRbDkB6UVwbECbUwAjhc7gkW/Y
         cWpgtOOPqurp20cFIEiRDotlTIbgLnWsbJvsfWL+/BqBItHicVnm24VjaMl136WVmo7z
         aoSNrXHMwm04tZWWc29ah1mrL3CVgzCl0ovR1Axm+mnK4k6/r07W1NH9lJ6bYd0HwjZa
         xW3p9/OXMljVAHjtWonTfhL3r1TzdJpoNkO7+ZjZ6RCD5DKesMlbWBYp5D2E79d22uM5
         f0RQ==
X-Gm-Message-State: AJIora9eiTyYR1UoM7tbt/5DcARp8Hmn556su7jlSdBO2ye0TidXIxD6
        EOPJqCpXScAkCkXI4Hmu62lTrAuKxXuJKRBlaxmMeRFWc4x8kQpfYh5FtQ/BW2+STvL63BotA3f
        nFp/vdov2KVHfT7/f2/bG
X-Received: by 2002:a6b:cd4e:0:b0:678:5453:eb88 with SMTP id d75-20020a6bcd4e000000b006785453eb88mr11699095iog.13.1657034051958;
        Tue, 05 Jul 2022 08:14:11 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1vFoWucJY6aJr7v6KoFjeXvwMgQ6eJMGGESv5hljYNF/CjOS/h3zaNbPnwaqDrP0w3drNibdA==
X-Received: by 2002:a6b:cd4e:0:b0:678:5453:eb88 with SMTP id d75-20020a6bcd4e000000b006785453eb88mr11699085iog.13.1657034051756;
        Tue, 05 Jul 2022 08:14:11 -0700 (PDT)
Received: from [10.0.0.146] (sandeen.net. [63.231.237.45])
        by smtp.gmail.com with ESMTPSA id z19-20020a05663822b300b00331f1f828adsm14904049jas.16.2022.07.05.08.14.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 Jul 2022 08:14:11 -0700 (PDT)
Message-ID: <b5ee25e6-a1ed-0aeb-7d8a-b0000af909f8@redhat.com>
Date:   Tue, 5 Jul 2022 10:14:10 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.11.0
Subject: Re: [PATCH] mkfs: update manpage of bigtime and inobtcount
Content-Language: en-US
To:     Zhang Boyang <zhangboyang.id@gmail.com>, linux-xfs@vger.kernel.org
Cc:     sandeen@sandeen.net
References: <20220705073919.37251-1-zhangboyang.id@gmail.com>
From:   Eric Sandeen <sandeen@redhat.com>
In-Reply-To: <20220705073919.37251-1-zhangboyang.id@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 7/5/22 2:39 AM, Zhang Boyang wrote:
> The bigtime and inobtcount feature is enabled by default by
> 1c08f0ae28b34d97b0a89c8483ef3c743914e85e (mkfs: enable inobtcount and
> bigtime by default). This patch updates the manpage of mkfs to mention
> this change.
> 
> Signed-off-by: Zhang Boyang <zhangboyang.id@gmail.com>

Thanks!

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

> ---
>  man/man8/mkfs.xfs.8.in | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/man/man8/mkfs.xfs.8.in b/man/man8/mkfs.xfs.8.in
> index 7b7e4f48..cd69ee0a 100644
> --- a/man/man8/mkfs.xfs.8.in
> +++ b/man/man8/mkfs.xfs.8.in
> @@ -211,7 +211,7 @@ December 1901 to January 2038, and quota timers from January 1970 to February
>  .IP
>  By default,
>  .B mkfs.xfs
> -will not enable this feature.
> +will enable this feature.
>  If the option
>  .B \-m crc=0
>  is used, the large timestamp feature is not supported and is disabled.
> @@ -264,7 +264,7 @@ This can be used to reduce mount times when the free inode btree is enabled.
>  .IP
>  By default,
>  .B mkfs.xfs
> -will not enable this option.
> +will enable this option.
>  This feature is only available for filesystems created with the (default)
>  .B \-m finobt=1
>  option set.

