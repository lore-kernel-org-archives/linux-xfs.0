Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9BDA2C4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 19 Nov 2022 17:24:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234060AbiKSRYX (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 19 Nov 2022 12:24:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233462AbiKSRYW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 19 Nov 2022 12:24:22 -0500
Received: from mail-qk1-x72a.google.com (mail-qk1-x72a.google.com [IPv6:2607:f8b0:4864:20::72a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A7871007F
        for <linux-xfs@vger.kernel.org>; Sat, 19 Nov 2022 09:24:22 -0800 (PST)
Received: by mail-qk1-x72a.google.com with SMTP id g10so5524879qkl.6
        for <linux-xfs@vger.kernel.org>; Sat, 19 Nov 2022 09:24:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=4wyOc7ivP6OXCvGDpOwBxK8LhOFDnQOY0A20rH6AazY=;
        b=QuWlVQjfjZQWRhmWY64lFekl4UPG1EVzZfdjIgzrSnwsTElOjZ9wQZO3brxDF3YxnV
         DC2YpJABsBZKxZCDWS4X1h6JJ2+4nsXvujzQCVMIgaLAFpgD0hbcqgXviW6x4ManSTPK
         Jukvz/NM+4aAPVnF484n6S7Ws6T72DAknBfuh5bnGq44PCLEYPUUqZMYk/jSsSBvw/VR
         tEp7sFsajpZFqV6fZefMjTtsyv/UYHeonGcwAjWEUUb2dK4ZLxcRbpSZRG8rvrnySmn9
         Owb/l1AE9FnULr2bUixOB9j55BJHygyO/8T+UByCxKuTNFMxQoqqG7mE/9Psw1j92UpJ
         IUiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4wyOc7ivP6OXCvGDpOwBxK8LhOFDnQOY0A20rH6AazY=;
        b=aBgsc7e+8x+gxO7TgnzyG2Ae3GZ/cAXE3fP6vTDy85fYVXD06TvuQT68f7kpHZ+u2O
         +9h4KBJX9X4zlLooe9jI6HQyOLQwe3X1egY22waIqapisvolX/UwYvq3tfzOb+hMN24H
         pi2IAD/DpNVL7OQprMF9L51zRJwMg0UBnJRa5nCTLCE7fIKaEVWAxpVpapsUip2/2+vF
         HyAOeLsMUK8t5uHSs89NCD+5GChY+qpNhe0tHvG9r0DasX9iQNAB+oUAu/eBuOT3MCRp
         vbwZf5wmHXCf1+DViuKhacBY1wbA243kp/l1/7+o9/xHjqy5q9WnKMAZ2xlTuZ/bQONq
         gtmw==
X-Gm-Message-State: ANoB5pn8PTS1t1BcHmCrifaEYaV54tg770h+A3HZgODjA5ihcY8ZmfHp
        r2pdjywbjBPuPJ3xJ53eWFHXlxfykQjs6g==
X-Google-Smtp-Source: AA0mqf538MRpG0nVRYGdcCzv8jKmvJJJPWz0NY7KvIWzVNisrXEI15yD3AC0xkit4WRIiuFa092VyA==
X-Received: by 2002:a37:6557:0:b0:6fa:16f2:7f58 with SMTP id z84-20020a376557000000b006fa16f27f58mr10108348qkb.204.1668878661045;
        Sat, 19 Nov 2022 09:24:21 -0800 (PST)
Received: from [192.168.1.16] (cpe-24-194-122-22.nycap.res.rr.com. [24.194.122.22])
        by smtp.gmail.com with ESMTPSA id w12-20020ac84d0c000000b00398313f286dsm4032383qtv.40.2022.11.19.09.24.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 19 Nov 2022 09:24:20 -0800 (PST)
Message-ID: <8ed7c0ee-dd04-8346-87cb-83c2222f3454@gmail.com>
Date:   Sat, 19 Nov 2022 12:24:18 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.5.0
Subject: Re: xfs_repair hangs at "process newly discovered inodes..."
Content-Language: en-US
To:     Eric Sandeen <sandeen@redhat.com>, linux-xfs@vger.kernel.org
References: <f7f94312-ad1b-36e4-94bf-1b7f47070c1e@gmail.com>
 <39028244-fec6-6717-d8a7-b9f89f5a1f3b@redhat.com>
From:   iamdooser <iamdooser@gmail.com>
In-Reply-To: <39028244-fec6-6717-d8a7-b9f89f5a1f3b@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Thank you for responding.

Yes that found errors, although I'm not accustomed to interpreting the 
output.

xfs_repair version 5.18.0

The output of xfs_repair -nv was quite large, as was the 
xfs_metadump...not sure that's indicative of something, but I've 
uploaded them here:
https://drive.google.com/drive/folders/1OyQOZNsTS1w1Utx1ZfQEH-bS_Cyj8-F2?usp=sharing


There doesn't seem to be much activity once it hangs at "process newly 
discovered inodes..." so it doesn't seem like just a slow repair. 
Desipte there being no sign of activity, I've let it run for 24+ hours 
and saw no changes..


On 11/17/22 13:48, Eric Sandeen wrote:
> On 11/17/22 12:40 PM, iamdooser wrote:
>> Hello,
>>
>> I'm not sure this is the correct forum; if not I'd appreciate guidance.
>>
>> I have a Unraid machine that experienced an unmountable file system on an array disc. Running:
>>
>> xfs_repair -nv /dev/md3
> 
> Did that find errors?
> 
>> works, however when running
>>
>> xfs_repair -v /dev/md3
>>
>> it stops at "process newly discovered inodes..." and doesn't seem to be doing anything.
>>
>> I've asked in the unraid forum and they've directed me to the xfs mailing list.
>>
>> Appreciate any help.
> 
> Please tell us the version of xfsprogs you're using, and provide the full xfs_repair
> output (with and without -n).
> 
> If it really looks like a bug, and not simply a slow repair, providing an xfs_metadump
> may help us evaluate the problem further.
> 
> -Eric
> 
