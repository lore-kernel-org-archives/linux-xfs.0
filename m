Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0F65C43334
	for <linux-xfs@archiver.kernel.org>; Wed, 29 Jun 2022 08:59:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232439AbiF2I7Z (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 29 Jun 2022 04:59:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232615AbiF2I7Y (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 29 Jun 2022 04:59:24 -0400
Received: from mail-lf1-x12e.google.com (mail-lf1-x12e.google.com [IPv6:2a00:1450:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52750248F9
        for <linux-xfs@vger.kernel.org>; Wed, 29 Jun 2022 01:59:22 -0700 (PDT)
Received: by mail-lf1-x12e.google.com with SMTP id f39so26865798lfv.3
        for <linux-xfs@vger.kernel.org>; Wed, 29 Jun 2022 01:59:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=lioexKbmzOh37YP8S89Uz5PZpE+ilcfMdalfPcxu7r0=;
        b=lLboIzRv56XOpfY9AQPIhgrCIpMiIz4SzNnDFOBAgqbfZ6OV22aEZ9r8/xeejU6d6H
         9Qx9xKrQ001fc5zcvH4VDk0Wb/iWUDS9SO1NAodJu7zs9W3l0JeNKjdS8wh8ZFIRjVcc
         r+mV0mglNcuF0MN+Kr/FtGsLEhjBYdNCGOlPFPz8hc8dQFhUcO5MKiGSeYObInkCCU7X
         BH0QGQi0BR+HvOpjtf4INxz9aXWENqAhSgXrPjD9Zq5MMElXoZ5bAstLY9i9wozDshPc
         2kCyQYEJ4a3uSw432fiD+CFCdEDQw0MwyT5gPPsCg3ZZS4O3mzGzUkin4IziebbYu2ea
         Binw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=lioexKbmzOh37YP8S89Uz5PZpE+ilcfMdalfPcxu7r0=;
        b=KilfEvp7Vgm2cba9wZ6efR0musGpR0/GutMrBD+nCKjBFbmBOwQhuACtlbiBY81n0p
         e1BZaiwhhmdnIwvmI69X8LXmnp2Ayiu/mVDgmhcSiQEuqtt4R2AW+yefTZqGrxjlMeuL
         9OV1o7ITeHSBUy5YIEN2o7NCBuhT0+j/oExDhHsAq5M+get8Po/u3V0tAPRwMdB+bLic
         e3jo4vUSTtykCxxEtWc86/NjAo32cl8DVR/CYPxMZJsW7X1zByP+hlsLKF1y7OP1fWXp
         dlxXZBFr48chyN90A/hIFgFHihiKY1/L3En4ujeTY7swx5FcXBlvV7Aa0ve4+/ts+90Y
         TcBA==
X-Gm-Message-State: AJIora8N3wdJEafXnwWVrPY3z++Z+oBuU11OG7jR6PGE+C/HlJ9obylM
        8yKuiDqrL0dGb/ODT4jumxE=
X-Google-Smtp-Source: AGRyM1tReBndEaI7jx+/Uj3qH0sHG8fXTiQ81KKD1hDfwG3bARar01h4Pywq1ewBtLNXuxc2qqG9TA==
X-Received: by 2002:a05:6512:6d4:b0:47f:74b4:4ec4 with SMTP id u20-20020a05651206d400b0047f74b44ec4mr1268552lff.654.1656493160485;
        Wed, 29 Jun 2022 01:59:20 -0700 (PDT)
Received: from [192.168.68.32] (cpc77339-stav19-2-0-cust1016.17-3.cable.virginm.net. [82.40.31.249])
        by smtp.gmail.com with ESMTPSA id g1-20020a2ea4a1000000b002555dd9c20fsm2094816ljm.20.2022.06.29.01.59.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 29 Jun 2022 01:59:20 -0700 (PDT)
Message-ID: <41917a84-2d95-aa83-4a06-00547842c246@gmail.com>
Date:   Wed, 29 Jun 2022 09:59:18 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [bug report] xfsdump fails to build against xfsprogs 5.18.0
Content-Language: en-US
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
References: <089bacd9-6213-d73f-f188-d4a31d91f447@gmail.com>
 <YruH1JKxgybem3jw@magnolia>
From:   Corin Hoad <corinhoad@gmail.com>
In-Reply-To: <YruH1JKxgybem3jw@magnolia>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Yes, xfsdump builds with that patch applied, and I don't see any 
immediate issue with basic functionality.

Thanks,
Corin Hoad

On 28/06/2022 23:59, Darrick J. Wong wrote:
> On Tue, Jun 28, 2022 at 11:32:48PM +0100, corinhoad@gmail.com wrote:
>> Hello,
>>
>> I package xfsdump for NixOS, and I have found that a recent upgrade from
>> xfsprogs 5.16.0 to 5.18.0 has caused a build failure for xfsprogs. See [1]
>> for an excerpt from the build logs. My novice investigation of the issue and
>> disccusion IRC indicates that the removal of DMAPI support is behind this.
> 
> Oops, we dropped the ball on this.  Does this patch[1] fix the problem?
> 
> --D
> 
> [1] https://lore.kernel.org/linux-xfs/20220203174540.GT8313@magnolia/
> 
>>
>> Best,
>> Corin Hoad
>>
>> [1]
>> content.c: In function 'restore_complete_reg':
>> content.c:7727:29: error: storage size of 'fssetdm' isn't known
>>   7727 |                 fsdmidata_t fssetdm;
>>        |                             ^~~~~~~
>> content.c:7734:34: error: 'XFS_IOC_FSSETDM' undeclared (first use in this
>> function); did you mean 'XFS_IOC_FSSETXATTR'?
>>   7734 |                 rval = ioctl(fd, XFS_IOC_FSSETDM, (void *)&fssetdm);
>>        |                                  ^~~~~~~~~~~~~~~
>>        |                                  XFS_IOC_FSSETXATTR
>> content.c:7734:34: note: each undeclared identifier is reported only once
>> for each function it appears in
>> content.c:7727:29: warning: unused variable 'fssetdm' [-Wunused-variable]
>>   7727 |                 fsdmidata_t fssetdm;
>>        |                             ^~~~~~~
>> content.c: In function 'restore_symlink':
>> content.c:8061:29: error: storage size of 'fssetdm' isn't known
>>   8061 |                 fsdmidata_t fssetdm;
>>        |                             ^~~~~~~
>> content.c:8061:29: warning: unused variable 'fssetdm' [-Wunused-variable]
>> content.c: In function 'setextattr':
>> content.c:8867:9: warning: 'attr_set' is deprecated: Use setxattr or
>> lsetxattr instead [-Wdeprecated-declarations]
>>   8867 |         rval = attr_set(path,
>>        |         ^~~~
>> In file included from content.c:27:
>> /nix/store/7b84p7877fl9p8aqx392drggj0jkqd0j-attr-2.5.1-dev/include/attr/attributes.h:139:12:
>> note: declared here
>>    139 | extern int attr_set (const char *__path, const char *__attrname,
>>        |            ^~~~~~~~
>> content.c: In function 'Media_mfile_next':
>> content.c:4797:33: warning: ignoring return value of 'system' declared with
>> attribute 'warn_unused_result' [-Wunused-result]
>>   4797 |                                 system(media_change_alert_program);
>>        |                                 ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>> content.c: In function 'restore_extent':
>> content.c:8625:49: warning: ignoring return value of 'ftruncate' declared
>> with attribute 'warn_unused_result' [-Wunused-result]
>>   8625 |                                                 ftruncate(fd,
>> bstatp->bs_size);
>>        | ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>> make[2]: *** [../include/buildrules:47: content.o] Error 1
>> make[1]: *** [include/buildrules:23: restore] Error 2
>> make: *** [Makefile:53: default] Error 2
