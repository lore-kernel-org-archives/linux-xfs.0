Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 711EFC433EF
	for <linux-xfs@archiver.kernel.org>; Fri, 10 Sep 2021 03:26:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5458B6105A
	for <linux-xfs@archiver.kernel.org>; Fri, 10 Sep 2021 03:26:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230018AbhIJD2F (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 9 Sep 2021 23:28:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229461AbhIJD2F (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 9 Sep 2021 23:28:05 -0400
Received: from mail-ot1-x331.google.com (mail-ot1-x331.google.com [IPv6:2607:f8b0:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E415C061574
        for <linux-xfs@vger.kernel.org>; Thu,  9 Sep 2021 20:26:55 -0700 (PDT)
Received: by mail-ot1-x331.google.com with SMTP id i3-20020a056830210300b0051af5666070so471517otc.4
        for <linux-xfs@vger.kernel.org>; Thu, 09 Sep 2021 20:26:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=yakkadesign-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=Jz9gqFCpRcf/zfQmIhfmAAe1jFnnroMomacajJKmnKU=;
        b=A17XSURv+ZyhjiEP2r64j1Zy8R/OaGT7hKrqnzIDYJ7Tj92T4oDxm6Y308wZz6zvVv
         +t/3mvi2QAT9G/tiFsVacvcfKe34fslXJ+AuDAmGRFYhkbr/QSZqXLQKGMTvTw300qg+
         vV65i6bPY3WOJEqF/o+bgBstvlwFNqd60m02yCjqZPOIjjay3kbSrUywtt2+27RuApXC
         VuhBISGFBT+MaY6azQ17UOz6RDgbbNXmussM04sz1a1HGinDsKBdGTJ5sn4Jult7JIT7
         zCD/8YbHbVq8gmaSgm4wTKZ68I2NURxJ4vPaZvNrRQSSoUIwQKZXrXx1nZGpJ8zg5CCD
         CeiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=Jz9gqFCpRcf/zfQmIhfmAAe1jFnnroMomacajJKmnKU=;
        b=BoupsvrGO1u3PApDH2xap5qDsHqv23L4o5ogNdZ/BBgcZUZrU9c1yOH9WNUSw7SZH0
         LEYFqdlOotkQBiPeRvfKNAOAqsoC5wKURGoxRyBnUHZtwZihV1CQFiC36PhSIkVPXugh
         lGEqCpxNjWKVuz2J+Vxw6mrmTzdcLj++2jMtwivpgjn4R6yLGHGYlPzg3qvI13WSL73l
         55u4KKCsomvlGXKtcKH1+AwdbOp/ZohS7ZtHlaQLo15p7xProHnxKezi7bdpcyMhpL7m
         HRIGvuTMgeSBd2AnGTvRR/Sc/AbSy255fOQJFnKK6f6jvJSH7iaGT19DgnoCcQjYQdMa
         Z1iQ==
X-Gm-Message-State: AOAM530/bEXHwx/kXNHcW6b9L+Xx1xcw28Mfi83ju5aqYZzYMYebOCXo
        aYR1q4TY77/8hqNoXSEkVwWqu3SNH8wRUCcl0Ts=
X-Google-Smtp-Source: ABdhPJxxBB+uGMhJxSKp+n+V0PpqdcefleD4zUUPE+IMcJzqNuDbVRTyNGA9Z0P3e/yh8bIY62Cx7g==
X-Received: by 2002:a9d:5d15:: with SMTP id b21mr2882102oti.356.1631244414204;
        Thu, 09 Sep 2021 20:26:54 -0700 (PDT)
Received: from ?IPv6:2602:306:bc57:e350:5a91:cfff:fe5a:fe83? ([2602:306:bc57:e350:5a91:cfff:fe5a:fe83])
        by smtp.googlemail.com with ESMTPSA id x198sm850797ooa.43.2021.09.09.20.26.53
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 09 Sep 2021 20:26:53 -0700 (PDT)
Subject: Re: Repair Metadata corruption detected at xfs_inode_buf_verify on
 CentOS 7 virtual machine
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
References: <055dbf6e-a9b5-08a1-43bc-59f93e77f67d@yakkadesign.com>
 <20210908213924.GB2361455@dread.disaster.area>
 <987fa28b-4928-8557-0f09-73839790e910@yakkadesign.com>
 <20210909025445.GC2361455@dread.disaster.area>
 <8a959313-b7ab-5434-7c8f-1cf8990ecb4d@yakkadesign.com>
 <20210909210951.GD2361455@dread.disaster.area>
From:   brian <a001@yakkadesign.com>
Message-ID: <41216bd1-a045-f9d5-3e42-967bffff3911@yakkadesign.com>
Date:   Thu, 9 Sep 2021 23:26:52 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <20210909210951.GD2361455@dread.disaster.area>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

I was able to get /home mounted and copy my data off.  Here is what I did
---------------------------------------------------------
sudo apt-get install qemu
sudo apt install qemu-utils
sudo apt-get install xfsprogs

sudo modprobe nbd max_part=8

sudo qemu-nbd --connect=/dev/nbd0 
/media/sf_virtual_machine_share/centoOS7Python3p9_tmp-disk1.vdi

sudo mkdir /mnt/dirNbd0p2

sudo mount -o ro,norecovery /dev/mapper/centos-home /mnt/dirNbd0p2
---------------------------------------------------------

I couldn't get the vdi corruption fixed but I did get my data.


@Dave

Thank you for your help.

Brian



On 09/09/2021 05:09 PM, Dave Chinner wrote:
> On Thu, Sep 09, 2021 at 03:11:45PM -0400, brian wrote:
>> I switched over to ubuntu and got the error "Device or resource busy".  How
>> do I get around this error?
>>
>> Here is what I did:
>> ---------------------------------------------------------
>> sudo apt-get install qemu
>> sudo apt install qemu-utils
>> sudo apt-get install xfsprogs
>>
>> sudo modprobe nbd max_part=8
>>
>> sudo qemu-nbd --connect=/dev/nbd0
>> /media/sf_virtual_machine_share/centoOS7Python3p9_tmp-disk1.vdi
>>
>> sudo xfs_repair /dev/nbd0p2
>> ---------------------------------------------------------
>>
>> I got the error:
>> ---------------------------------------------------------
>> xfs_repair: cannot open /dev/nbd0p2: Device or resource busy
>> ---------------------------------------------------------
> Because /dev/nbd0p2 is not the device the filesystem is on. The
> filesystem is on a lvm volume:
>
>> brian@brian-VirtualBox:~/Desktop$ sudo lvmdiskscan
>>    /dev/loop0  [     219.00 MiB]
>>    /dev/loop1  [     <55.44 MiB]
>>    /dev/sda1   [     512.00 MiB]
>>    /dev/nbd0p1 [       1.00 GiB]
>>    /dev/loop2  [     <65.10 MiB]
>>    /dev/nbd0p2 [    <101.71 GiB] LVM physical volume
> As noted here.
>
>> cmd:
>> ---------------------------------------------------------
>> sudo lvscan
>> ---------------------------------------------------------
>>
>> Result:
>> ---------------------------------------------------------
>>    ACTIVE            '/dev/centos/swap' [2.00 GiB] inherit
>>    ACTIVE            '/dev/centos/home' [<49.70 GiB] inherit
>>    ACTIVE            '/dev/centos/root' [50.00 GiB] inherit
>> ---------------------------------------------------------
> And these are the devices inside the LVM volume that contain
> filesystems/data.
>
> Likely the one you are having trouble with is /dev/centos/root,
> but there may be issues with /dev/centos/home, too.
>
> And to answer your other question, "<dev>" is just shorthand for
> "<insert whatever device your filesystem is on here>". i.e.
> /dev/centos/root in this case...
>
> Cheers,
>
> Dave.
>

