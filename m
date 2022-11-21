Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88F4FC43217
	for <linux-xfs@archiver.kernel.org>; Mon, 21 Nov 2022 16:25:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229456AbiKUQZG (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 21 Nov 2022 11:25:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229797AbiKUQZF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 21 Nov 2022 11:25:05 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14E85C72FB
        for <linux-xfs@vger.kernel.org>; Mon, 21 Nov 2022 08:24:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669047848;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7SMxWfiBzJeh0LV+vrK7Y9NVsD5DY+oiFqx+JtsS1Q0=;
        b=Mg0u60GWUphPqBl5n95SzTV7n30dutT96F4iR7uOO6RS3vrS4hjHKZyfAiRRrJu56e7ucq
        knffcqsCpygy8I7X198G7tVnOpXd954piY5VSaCyp1oFg8S0yfbb+MYTcAP2ISNIhsoay+
        lp1r2l/80VSUXn9LjQ4gzpjTqcWd4fk=
Received: from mail-io1-f70.google.com (mail-io1-f70.google.com
 [209.85.166.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-249-t3_24q6ENwiWc5uHRTHrmQ-1; Mon, 21 Nov 2022 11:24:06 -0500
X-MC-Unique: t3_24q6ENwiWc5uHRTHrmQ-1
Received: by mail-io1-f70.google.com with SMTP id o15-20020a6bf80f000000b006de313e5cfeso5632512ioh.6
        for <linux-xfs@vger.kernel.org>; Mon, 21 Nov 2022 08:24:06 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7SMxWfiBzJeh0LV+vrK7Y9NVsD5DY+oiFqx+JtsS1Q0=;
        b=sYnWOV5ptrVhpE3IYwR5drRzym2H0K3sWCUM85zo2CCdOrXUt6G2yVslvtIGlcVWL+
         zv3WhSbBqJrhDO0kDzaqxwBVMP2HmM2+qfAMEg37pFRF2/TB5ABAWXz5svqLo0exTDjo
         BtZzceztTzBh4ZYJOw9UA8ek2BSois0ahEaxXSjlpNbEZIqiCqkKR13KsMEgqZXrvQM2
         19uJEHJq3V9rKcEwPgGJ8DilTxy/aY14JtiFRXds6QeHIYVMg3CFI/G70MQ+Ai+AZa+z
         G5EVNaqRsIvv8c9REqKArYbn8JMPKKbfs/ZrggiqlyVuKldj702NHGcRMs6auGFFy8xR
         4umw==
X-Gm-Message-State: ANoB5pm67E66HLQz1xE4SkC2frIkDXvCuShR27EJXxoZHcztOWV2AeLK
        EAkf8gffdVLr3pA0JU23E3s0vdbbYgwNkMTNbfW5Znv4j/udhV0XW+32DuLSBtuAUqrcjhEPMJe
        JL7dZCNYVMvTwQeZl1f1y
X-Received: by 2002:a5d:88c3:0:b0:6d6:5fe4:8212 with SMTP id i3-20020a5d88c3000000b006d65fe48212mr8873626iol.180.1669047845399;
        Mon, 21 Nov 2022 08:24:05 -0800 (PST)
X-Google-Smtp-Source: AA0mqf4oG43hkcERsoGx1Xead+Y3+dPlHvA181hFZUO8y3X+Tek72DkqeBh0yhpQ8KDW5JwNwrSOoA==
X-Received: by 2002:a5d:88c3:0:b0:6d6:5fe4:8212 with SMTP id i3-20020a5d88c3000000b006d65fe48212mr8873613iol.180.1669047845066;
        Mon, 21 Nov 2022 08:24:05 -0800 (PST)
Received: from [10.0.0.146] (sandeen.net. [63.231.237.45])
        by smtp.gmail.com with ESMTPSA id b24-20020a5d8918000000b0069e1bcbddaesm4436984ion.16.2022.11.21.08.24.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 21 Nov 2022 08:24:04 -0800 (PST)
Message-ID: <084cd831-d64b-6add-f8c7-d82c076da818@redhat.com>
Date:   Mon, 21 Nov 2022 10:24:02 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.5.0
Subject: Re: xfs_repair hangs at "process newly discovered inodes..."
Content-Language: en-US
To:     Carlos Maiolino <cem@kernel.org>, iamdooser <iamdooser@gmail.com>
Cc:     linux-xfs@vger.kernel.org
References: <f7f94312-ad1b-36e4-94bf-1b7f47070c1e@gmail.com>
 <39028244-fec6-6717-d8a7-b9f89f5a1f3b@redhat.com>
 <iOca9P0A2zA99RMVQ0MVU2m_jc4mmNS3eLXM-c7gkAp5rCgJNxdoaX6xoCN3-ByUS-4whve0zMZucYirzgGw-A==@protonmail.internalid>
 <8ed7c0ee-dd04-8346-87cb-83c2222f3454@gmail.com>
 <20221121161400.tecpfwaawiy4kt3y@andromeda>
From:   Eric Sandeen <sandeen@redhat.com>
In-Reply-To: <20221121161400.tecpfwaawiy4kt3y@andromeda>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 11/21/22 10:14 AM, Carlos Maiolino wrote:
> Hi.
> 
> 
> On Sat, Nov 19, 2022 at 12:24:18PM -0500, iamdooser wrote:
>> Thank you for responding.
>>
>> Yes that found errors, although I'm not accustomed to interpreting the
>> output.
>>
>> xfs_repair version 5.18.0
>>
>> The output of xfs_repair -nv was quite large, as was the
>> xfs_metadump...not sure that's indicative of something, but I've
>> uploaded them here:
>> https://drive.google.com/drive/folders/1OyQOZNsTS1w1Utx1ZfQEH-bS_Cyj8-F2?usp=sharing
>>
>>
>> There doesn't seem to be much activity once it hangs at "process newly
>> discovered inodes..." so it doesn't seem like just a slow repair.
>> Desipte there being no sign of activity, I've let it run for 24+ hours
>> and saw no changes..
>>
> 
> Before anything else, could you please try to run the latest xfsprogs from:
> 
> https://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git/log/?h=master
> 
> A quick test in my laptop using the metadump you provided, finished the repair
> in about 5 mintues:
> 
> Maximum metadata LSN (2138201505:-135558109) is ahead of log (96:0).
> Format log to cycle 2138201508.
> 
>         XFS_REPAIR Summary    Mon Nov 21 17:04:44 2022
> 
> Phase		Start		End		Duration
> Phase 1:	11/21 16:59:36	11/21 16:59:36	
> Phase 2:	11/21 16:59:36	11/21 16:59:37	1 second
> Phase 3:	11/21 16:59:37	11/21 17:03:47	4 minutes, 10 seconds
> Phase 4:	11/21 17:03:47	11/21 17:04:06	19 seconds
> Phase 5:	11/21 17:04:06	11/21 17:04:07	1 second
> Phase 6:	11/21 17:04:07	11/21 17:04:38	31 seconds
> Phase 7:	11/21 17:04:38	11/21 17:04:38	
> 
> Total run time: 5 minutes, 2 seconds
> done
> 
> Also, feel free to compress any file you need to share with us :)

Yup. All those files should compress quite well.

So, the "-nv" output shows many, many errors.  While xfs_repair should eventually
make the filesystem metadata consistent again, that's not the same thing as data
recovery.

What happened to this filesystem and/or its storage that prompted the need for
repair?

-Eric

