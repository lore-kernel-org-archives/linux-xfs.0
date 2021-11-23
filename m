Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F743C433EF
	for <linux-xfs@archiver.kernel.org>; Tue, 23 Nov 2021 23:32:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232641AbhKWXfl (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 23 Nov 2021 18:35:41 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:31996 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231322AbhKWXfl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 23 Nov 2021 18:35:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1637710352;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wF0TBLyIx4P3iqF3da6HkUP2TnH+SaUFOksOe9TinVU=;
        b=AR+ZCoBeIm2ZsuFVAuMtcZCOaujLOaw0jup2my80Nn/9w3rCKN6uWh+Ii2r+8ZYEupvDSX
        CB1bREtrF8FBzQq3KvdjJbvgvk7j8ZOLgCPxhhcaQbG1oRP6dvR0bE7H/yDvI9t3rU9Kju
        dXrw1Ga/S2fpZcJVKaWxb5kCr2rRmGs=
Received: from mail-io1-f70.google.com (mail-io1-f70.google.com
 [209.85.166.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-262-wh6WaRw1O5qdEZ-0eJkZSg-1; Tue, 23 Nov 2021 18:32:28 -0500
X-MC-Unique: wh6WaRw1O5qdEZ-0eJkZSg-1
Received: by mail-io1-f70.google.com with SMTP id 7-20020a6b0107000000b005ed196a2546so358744iob.11
        for <linux-xfs@vger.kernel.org>; Tue, 23 Nov 2021 15:32:28 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:in-reply-to
         :content-transfer-encoding;
        bh=wF0TBLyIx4P3iqF3da6HkUP2TnH+SaUFOksOe9TinVU=;
        b=kw99PPjt9dXBXfizC+mprb8OnLEI+R8yfnO8/oFPzoJC4ZybDuyTidn66Exqw9sCos
         gESb9gqM7f4GlzTbkqecYUGQBvbnf/6qiglJUaFgT/i8cJloPjtQPY/Ve/WlEjCFvijR
         Q37uTD9QHZ/VlRswC8WcVs/tVAwuJZeVXgv7hcYMWIxyoJsKjT2tOdefIqctAzo3oAsL
         7niVVHuXmk1M6sqqySgT/xW17OprIdEeITUem+qeJCNkdGhzc9XpnI5O2GRBEY4+pKNK
         De0BRlpv5tBlKHRhs5WL4V4fec4uEppLl5uWEvcSYIgGkcRTi/qXWfa5AOK72fQ7OvEE
         rP/Q==
X-Gm-Message-State: AOAM532ukEkvzayZDqIC/fJ/+ScTTvAm/eQVN4582Nze80XrP/i+u65n
        ts7toWvBubJU6Vk5LJVx5MTQTifiW15mFIWax8p03ZvRQiHG1vWBgRGKolL83Qs0wCeI7tci1vm
        lE4Da6P1ayCJGmo2Ho7L0
X-Received: by 2002:a05:6e02:1aa2:: with SMTP id l2mr8897640ilv.114.1637710348149;
        Tue, 23 Nov 2021 15:32:28 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwf4j0asoD3+DIKduMk9US0/PLje2sCmkqnUznxUO/aXYEx59xthwgCzwfzlogPCaGdOUCD7A==
X-Received: by 2002:a05:6e02:1aa2:: with SMTP id l2mr8897594ilv.114.1637710347609;
        Tue, 23 Nov 2021 15:32:27 -0800 (PST)
Received: from [10.157.4.161] ([97.64.79.179])
        by smtp.gmail.com with ESMTPSA id i1sm5489210ilm.5.2021.11.23.15.32.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 23 Nov 2021 15:32:27 -0800 (PST)
From:   Eric Sandeen <esandeen@redhat.com>
X-Google-Original-From: Eric Sandeen <sandeen@redhat.com>
Message-ID: <2e68b35a-3c83-dacc-e9fa-a3770675c0f8@redhat.com>
Date:   Tue, 23 Nov 2021 17:32:18 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.3.2
Subject: Re: [PATCH 1/2] libfrog: fix crc32c self test code on cross builds
Content-Language: en-US
To:     "Darrick J. Wong" <djwong@kernel.org>, sandeen@sandeen.net
Cc:     Helmut Grohne <helmut@subdivi.de>,
        Bastian Germann <bage@debian.org>,
        Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
References: <163769722838.871940.2491721496902879716.stgit@magnolia>
 <163769723396.871940.2874954467689580625.stgit@magnolia>
In-Reply-To: <163769723396.871940.2874954467689580625.stgit@magnolia>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 11/23/21 1:53 PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Helmut Grohne reported that the crc32c self test program fails to cross
> build on 5.14.0 if the build host doesn't have liburcu installed.  We
> don't need userspace RCU functionality to test crc32 on the build host,
> so twiddle the header files to include only the two header files that we
> actually need.
> 
> Note: Build-time testing of crc32c is useful for upstream developers so
> that we can check that we haven't broken the checksum code, but we
> really ought to be testing this in mkfs and repair on the user's system
> so that they don't end up with garbage filesystems.  A future patch will
> introduce that.
> 
> Reported-by: Helmut Grohne <helmut@subdivi.de>
> Cc: Bastian Germann <bage@debian.org>
> Suggested-by: Dave Chinner <david@fromorbit.com>
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>

LGTM, thanks.  Helmut, can you confirm that this solves all cross-build problems?
(It must, but confirmation that the cross build is completely functional now
would be nice.)

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

> ---
>   libfrog/crc32.c |    7 ++++++-
>   1 file changed, 6 insertions(+), 1 deletion(-)
> 
> 
> diff --git a/libfrog/crc32.c b/libfrog/crc32.c
> index 526ce950..6a273b71 100644
> --- a/libfrog/crc32.c
> +++ b/libfrog/crc32.c
> @@ -29,10 +29,15 @@
>    * match the hardware acceleration available on Intel CPUs.
>    */
>   
> +/*
> + * Do not include platform_defs.h here; this will break cross builds if the
> + * build host does not have liburcu-dev installed.
> + */
> +#include <stdio.h>
> +#include <sys/types.h>
>   #include <inttypes.h>
>   #include <asm/types.h>
>   #include <sys/time.h>
> -#include "platform_defs.h"
>   /* For endian conversion routines */
>   #include "xfs_arch.h"
>   #include "crc32defs.h"
> 
> 

