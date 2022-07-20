Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 409C5C43334
	for <linux-xfs@archiver.kernel.org>; Wed, 20 Jul 2022 20:01:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229588AbiGTUBL (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 20 Jul 2022 16:01:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229456AbiGTUBK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 20 Jul 2022 16:01:10 -0400
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F7F430F73
        for <linux-xfs@vger.kernel.org>; Wed, 20 Jul 2022 13:01:09 -0700 (PDT)
Received: by mail-pf1-x42c.google.com with SMTP id d10so17400609pfd.9
        for <linux-xfs@vger.kernel.org>; Wed, 20 Jul 2022 13:01:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language
         :from:to:references:in-reply-to:content-transfer-encoding;
        bh=5/al5hJw9FspZfU83QVUbB6dN15YuzeZ6S/xAwbJL60=;
        b=Go9zrVB43ljmypj/l1QGqcCdNTA+fA1TJ6tmX11A0x4C8o+/+u0yvX0ZP6paeyownR
         CG/lDsGhFc78fZ2mAOuM1eVW2TnczGPpNlceIX9zMCMOdue9aeBQIKSd9xlgCf1PKP+s
         tNuqoN49QR0ZCcXns88bSrWf8YbONrk5x99RO26W4cwToau95Zr0f6XzaWliCQ5QwmgV
         5JvYZ0BIjTNegVL1zplMiwxbEL2CiethpIRo5Zb6pcbFt3Bm9B2G6Tjjlv5rI4c+WGC8
         ffPIKLcqhFUzXW6px9zZVxilRMlqZlmakzUUuXiuDu0McR7hkqnqaKx9K1qSPWJYe0sw
         lWhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:from:to:references:in-reply-to
         :content-transfer-encoding;
        bh=5/al5hJw9FspZfU83QVUbB6dN15YuzeZ6S/xAwbJL60=;
        b=tpfuh1PJ56k+jw3IoZrWrBwCbOTxFIvSMZ71gK67FZbqwVb03uiEMFzmO9LuVZc0i0
         OFQNdjYcdLbXvFim6KyEG6LxE9k7Qy5fVadIvG+UoRfdm6H5C3ydZ7JYvhFELH2gBRZh
         dCWfEJApFCaF/B8zCRgsvdVU4F56KkN5YN87/fdKGBCEzV9EcmqsM1UAqPiQTdWAFx23
         8pJ8nbBbESRLx8BM9oz/YWReoSiYghPxy0UtirqnwlXYzm+EMa8cALrDfMiObLB0HXpI
         iGVzqlpqA4froPL00L5Ge0KCXZv8iPHGUMX3FCQBYlARJIcHQL7hBi/eQsYriu41BsmX
         IApA==
X-Gm-Message-State: AJIora9P5SokUZoVYmuaSyKYrjchjJA/SRLUX31cW3fJ1FteRuZZe/nJ
        aU5Y7ed8u/yAgxP80X/Ktaus5uBwytg=
X-Google-Smtp-Source: AGRyM1uxU6ONMhuTXsC4XEkB1+GR7C0Safc6kh5NGqg/eoNRbsgS6tP9HPcMX+ZKFYHf5SUxfwZ6QA==
X-Received: by 2002:a63:164d:0:b0:416:4bc:1c28 with SMTP id 13-20020a63164d000000b0041604bc1c28mr34652024pgw.302.1658347268256;
        Wed, 20 Jul 2022 13:01:08 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id j66-20020a625545000000b005289cade5b0sm25209pfb.124.2022.07.20.13.01.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 20 Jul 2022 13:01:07 -0700 (PDT)
Message-ID: <479513aa-2f83-6add-1272-8d634f534046@gmail.com>
Date:   Wed, 20 Jul 2022 13:01:05 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: MAP_SYNC troubles on MIPS platforms
Content-Language: en-US
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     linux-xfs@vger.kernel.org,
        Ross Zwisler <ross.zwisler@linux.intel.com>,
        Dave Chinner <david@fromorbit.com>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Eric Sandeen <sandeen@sandeen.net>
References: <20417b06-3571-4830-9a4f-2345dfd7c777@gmail.com>
In-Reply-To: <20417b06-3571-4830-9a4f-2345dfd7c777@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Sorry for responding to myself here, of course right after sending this email I found again the CPP debugging options that I was looking for only to realize that the following happened:

io/mmap.c does include input.h which includes libfrog/projectsh which includes xfs.h which includes linux.h. Because linux.h has a header guard, the second inclusion *after* sys/mman.h had no chance of re-defining MAP_SYNC, I should be able to submit a patch addressing that.

On 7/20/22 12:49, Florian Fainelli wrote:
> Hi,
> 
> While testing musl-libc builds with MIPS-based platforms, I ran into the following build failure affecting the mmap.c file only:
> 
>     mmap.c: In function 'mmap_f':
>     mmap.c:196:12: error: 'MAP_SYNC' undeclared (first use in this function); did you mean 'MS_SYNC'?
>       196 |    flags = MAP_SYNC | MAP_SHARED_VALIDATE;
>           |            ^~~~~~~~
>           |            MS_SYNC
>     mmap.c:196:12: note: each undeclared identifier is reported only once for each function it appears in
>     make[4]: *** [../include/buildrules:81: mmap.o] Error 1
> 
> musl-libc does explicitly un-define MAP_SYNC since MIPS does not support it:
> 
> https://git.musl-libc.org/cgit/musl/tree/arch/mips/bits/mman.h#n21
> 
> however the include chain for io/mmap.c should still have the linux.h compatibility shim provide a suitable definition for MAP_SYNC so this did not really make sense to me:
> 
> #include <sys/mman.h>
> 	-> bits/mman.h	(where the undefined happens)
> #include "io.h"
> 	-> include/xfs.h
> 		-> include/linux.h
> 
> I have confirmed that at every stage of the inclusion chain the MAP_SYNC and HAVE_MAP_SYNC are defined or undefined as intended, up until the top-level inclusion of include/xfs.h in io/io.h where MAP_SYNC is not defined after we included xfs.h which does not quite make sense to me at all. The build command line for that file is:
> 
> mipsel-buildroot-linux-musl-gcc -D_LARGEFILE_SOURCE -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64 -Os -g0 -DDANGEROUS_COMMANDS_ENABLED -D_FILE_OFFSET_BITS=64 -Wno-address-of-packed-member -g -O2 -DDEBUG -DVERSION=\"5.14.2\" -DLOCALEDIR=\"/usr/share/locale\" -DPACKAGE=\"xfsprogs\" -I../include -I../libxfs -I.. -D_LGPL_SOURCE -D_GNU_SOURCE -funsigned-char -fno-strict-aliasing -Wall -DHAVE_MNTENT -DHAVE_FSETXATTR -DENABLE_BLKID -DHAVE_GETFSMAP -DHAVE_FALLOCATE -DHAVE_FADVISE -DHAVE_MADVISE -DHAVE_MINCORE -DHAVE_SENDFILE -DHAVE_FIEMAP -DHAVE_COPY_FILE_RANGE -DHAVE_SYNC_FILE_RANGE -DHAVE_SYNCFS -DHAVE_FALLOCATE -DHAVE_PREADV -DHAVE_PWRITEV -DHAVE_READDIR -DHAVE_MREMAP -DHAVE_STATFS_FLAGS -c mmap.c
> 
> People in other projects have attempted to fix it
> 
> https://github.com/openwrt/packages/blob/master/utils/xfsprogs/patches/140-mman.patch
> 
> but this feels just plain wrong. The only way that I could get it to build was to do the following, but this does not really work on my x86_64 glibc host:
> 
> diff --git a/include/linux.h b/include/linux.h
> index 3d9f4e3dca80..7ca9fab16705 100644
> --- a/include/linux.h
> +++ b/include/linux.h
> @@ -252,8 +252,11 @@ struct fsxattr {
>  #endif
> 
>  #ifndef HAVE_MAP_SYNC
> +#include <sys/mman.h>
>  #define MAP_SYNC 0
> +#ifndef MAP_SHARED_VALIDATE
>  #define MAP_SHARED_VALIDATE 0
> +#endif
>  #else
>  #include <asm-generic/mman.h>
>  #include <asm-generic/mman-common.h>
> 
> Any clues from the mmap.i attached filed what could be going wrong?
> 
> Thank you for reading me!


-- 
Florian
