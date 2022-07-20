Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0FD1AC43334
	for <linux-xfs@archiver.kernel.org>; Wed, 20 Jul 2022 21:40:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229504AbiGTVki (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 20 Jul 2022 17:40:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229554AbiGTVkh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 20 Jul 2022 17:40:37 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D6043F313
        for <linux-xfs@vger.kernel.org>; Wed, 20 Jul 2022 14:40:36 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id t2-20020a17090a4e4200b001f21572f3a4so3523558pjl.0
        for <linux-xfs@vger.kernel.org>; Wed, 20 Jul 2022 14:40:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=t9wSWtz9UkvKRBz1ZiHt8m+ZMZej7l2jvIevI/L6nBI=;
        b=juB79hO6hMMwVibNCvW3xfvP5OdQ31Q/4q/hTuk2p3npkdEk7Z2KiUWvmw5HOLIMNd
         NPLB08dwKVZ46J7mWHuZ+gAq/QdNvZvctNgqE09K+aq5w9R38meTSZcT0pzCNuGAh1lb
         o9g51q5lIl2jgDAykemlvOPBDcKZ4eQEE6qCpcrnXalLrgqueHAXhkWfmv9l7bopWx2M
         5YnTrUP0No3cCrSVYGXVaJd73I1vZqcy1EblgXFPi4WxyYdgQDICmr8Yiz/KQoXLKXR4
         nH1c69J7CYnBZ5RjzaiVbWNzJ2ZEJgm2btX91+gzRSGcIi+gWvbSgy3B8sF1dRMhAuY9
         3xmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=t9wSWtz9UkvKRBz1ZiHt8m+ZMZej7l2jvIevI/L6nBI=;
        b=tAMx47IoibVZ5Il2JmUa46iyGD8ndJP9n4z9/S4RAOPnPQ3j8tJeIS/ZULECTXilnB
         GrmyxcpuDfnSNVajFu68/P67EmtR+FUtogennO6EvYYYSUAqfP+y+DOXKjwup6HqI2mp
         Dlu+bq9wp0Es3FCUoM2S69Jt6c52DsvYC1+k9ihgTJpLReSU8iSY19jjw4E6IoLm5ps9
         PwwuMZ3+WxcSFqGeqAjmWgrh9ogIVW/Mx8GC06qMlpqzm0CFqdprIvhZd8aucmUfzWcR
         9x55XV2gVWT/sv0Ai8Zy/EDcnCxGpRtbBQwr+bmPzR6oUgoWcU41A5iXY5YspJNldjc2
         a9jw==
X-Gm-Message-State: AJIora9WfUiT2p/pDGqQTyO9z37nyg9o5tGfJ3h9ELWeGAal1CRNQ2Og
        5I826Po++MJLDmAoPy9hsw8=
X-Google-Smtp-Source: AGRyM1s9MbzDqjlHtQ/8WopwWanGhyNxQt3yVahKMp6YfXh5IsS4CQPIs0UCNOa2d06DXcuMWgtASA==
X-Received: by 2002:a17:902:ce8c:b0:16c:4be6:2536 with SMTP id f12-20020a170902ce8c00b0016c4be62536mr41532005plg.41.1658353235362;
        Wed, 20 Jul 2022 14:40:35 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id l4-20020a170902f68400b0016bdf53b303sm27742plg.205.2022.07.20.14.40.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 20 Jul 2022 14:40:35 -0700 (PDT)
Message-ID: <b33b7a02-0780-feb9-ee83-9dab2cdf3361@gmail.com>
Date:   Wed, 20 Jul 2022 14:40:33 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH] xfs_io: Make HAVE_MAP_SYNC more robust
Content-Language: en-US
To:     "Darrick J. Wong" <djwong@kernel.org>,
        Fabrice Fontaine <fontaine.fabrice@gmail.com>,
        info@mobile-stream.com
Cc:     linux-xfs@vger.kernel.org, ross.zwisler@linux.intel.com,
        david@fromorbit.com, darrick.wong@oracle.com, sandeen@sandeen.net
References: <20220720205307.2345230-1-f.fainelli@gmail.com>
 <Yth0es3DkTQRAxJl@magnolia>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <Yth0es3DkTQRAxJl@magnolia>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 7/20/22 14:32, Darrick J. Wong wrote:
> On Wed, Jul 20, 2022 at 01:53:07PM -0700, Florian Fainelli wrote:
>> MIPS platforms building with recent kernel headers and the musl-libc toolchain
>> will expose the following build failure:
>>
>> mmap.c: In function 'mmap_f':
>> mmap.c:196:12: error: 'MAP_SYNC' undeclared (first use in this function); did you mean 'MS_SYNC'?
>>   196 |    flags = MAP_SYNC | MAP_SHARED_VALIDATE;
>>       |            ^~~~~~~~
>>       |            MS_SYNC
>> mmap.c:196:12: note: each undeclared identifier is reported only once for each function it appears in
>> make[4]: *** [../include/buildrules:81: mmap.o] Error 1
> 
> Didn't we already fix this?
> https://lore.kernel.org/linux-xfs/20220508193029.1277260-1-fontaine.fabrice@gmail.com/
> 
> Didn't we already fix this?
> https://lore.kernel.org/linux-xfs/20181116162346.456255382F@mx7.valuehost.ru/

First off, I was not aware of these two proposed solutions so apologies for submitting a third (are there more) one.

The common problem I see with both proposed patches is that they specifically tackle io/mmap.c when really any inclusion order of linux.h and sys/mman.h could and would lead to the the same problem to re-surface somewhere else in a different file. So sure enough there is only mmap.c now, but it has been identified that this specific include order is problematic so we ought to address it in a general way.

> 
> Oh, I guess the maintainer didn't apply either of these patches, so this
> has been broken for years.

Fabrice's patch is only a few months old, and but "info@mobile-stream.com"'s is nearly 4 years old...

> 
> Well... MAP_SYNC has been with us for a while now, perhaps it makes more
> sense to remove all the override cruft and make xfs_io not export -S if
> if neither kernel headers nor libc define it?

Sure that would work too, but we will still end up with some MAP_SYNC conditional code, so the original intent of always defining it seemed laudable.

> 
> --D
> 
>>
>> The reason for that is that the linux.h header file which intends to provide a fallback definition for MAP_SYNC and MAP_SHARED_VALIDATE is included too early through:
>>
>> input.h -> libfrog/projects.h -> xfs.h -> linux.h and this happens
>> *before* sys/mman.h is included.
>>
>> sys/mman.h -> bits/mman.h which has a:
>>   #undef MAP_SYNC
>>
>> see: https://git.musl-libc.org/cgit/musl/tree/arch/mips/bits/mman.h#n21
>>
>> The end result is that sys/mman.h being included for the first time
>> ends-up overriding the HAVE_MAP_SYNC fallbacks.
>>
>> To remedy that, make sure that linux.h is updated to include sys/mman.h
>> such that its fallbacks are independent of the inclusion order. As a
>> consequence this forces us to ensure that we do not re-define
>> accidentally MAP_SYNC or MAP_SHARED_VALIDATE so we protect against that.
>>
>> Fixes: dad796834cb9 ("xfs_io: add MAP_SYNC support to mmap()")
>> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
>> ---
>>  include/linux.h | 5 +++++
>>  1 file changed, 5 insertions(+)
>>
>> diff --git a/include/linux.h b/include/linux.h
>> index 3d9f4e3dca80..c3cc8e30c677 100644
>> --- a/include/linux.h
>> +++ b/include/linux.h
>> @@ -252,8 +252,13 @@ struct fsxattr {
>>  #endif
>>  
>>  #ifndef HAVE_MAP_SYNC
>> +#include <sys/mman.h>
>> +#ifndef MAP_SYNC
>>  #define MAP_SYNC 0
>> +#endif
>> +#ifndef MAP_SHARED_VALIDATE
>>  #define MAP_SHARED_VALIDATE 0
>> +#endif
>>  #else
>>  #include <asm-generic/mman.h>
>>  #include <asm-generic/mman-common.h>
>> -- 
>> 2.25.1
>>


-- 
Florian
