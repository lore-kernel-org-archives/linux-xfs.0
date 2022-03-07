Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D974C433F5
	for <linux-xfs@archiver.kernel.org>; Mon,  7 Mar 2022 15:29:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243790AbiCGPao (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 7 Mar 2022 10:30:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232666AbiCGPan (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 7 Mar 2022 10:30:43 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B8F3149926
        for <linux-xfs@vger.kernel.org>; Mon,  7 Mar 2022 07:29:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646666987;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=YPlVwQGHT+79kMxvryIQMl/ej1m458tu1RTqCkXSSyY=;
        b=DVVS9eRCRKRK9IdBCOJROsgDNQ/WAHHAq9N0mTa/FO2+0L/adqoBJ92QfkFEZdAmestIjD
        JKh8oYzPVtxfIiCWpBy9AIXfK9AqXaMLkPtLI5yuXxD3lNhGXfTnygqoo2AC8U2YYZmWVx
        kiHejqLzns8DkRWKZ7CnHBBQYleEsEo=
Received: from mail-il1-f200.google.com (mail-il1-f200.google.com
 [209.85.166.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-628-LOhlcI8iN6eq7vUfuooWoQ-1; Mon, 07 Mar 2022 10:29:46 -0500
X-MC-Unique: LOhlcI8iN6eq7vUfuooWoQ-1
Received: by mail-il1-f200.google.com with SMTP id a2-20020a056e020e0200b002c6344a01c9so2982731ilk.13
        for <linux-xfs@vger.kernel.org>; Mon, 07 Mar 2022 07:29:46 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:message-id:date:mime-version:user-agent
         :subject:content-language:to:references:in-reply-to
         :content-transfer-encoding;
        bh=YPlVwQGHT+79kMxvryIQMl/ej1m458tu1RTqCkXSSyY=;
        b=TiT0VEg3cHU9YdhWnWIrZJ/GAkA2/1PAEfxX0lWstc2XPpYiROM4eSyY/xPSy80Iok
         fFx8drn8+HhCfOtaBQ0+hp14LJYpw2ti3FYqFi9oQfaXii8eslHjwL6Ve0tXOV4fp+o0
         XI812cRRp2/jG6zStFyjPAzZhl+QYugrSNrAhT0YgyXhI7Eo5Ppj9hJRpLawl8SqBb7d
         RKYKM7J08IqCNQ8o7Ebye2JRcMoDpTERRTR6VY9r4OcKK1r/g1rAgo8aO5THZdgfOQfa
         VILJRROFDfgqC9ueG5ER4Ky5ixRV3zrEfQLlxT2jjoyuGTCGIy0UkwpLQgW3NpZZD6Lu
         O80A==
X-Gm-Message-State: AOAM530G/r65vXvuF6efZoPpZcvQzfylqVimsZnsRjKx93SUeMRkignN
        vvd7VjkwYUHzkGQ5GUOoHhVz2LcE4OZ6L9lrwM8vMTSCEU0zpYdjdUSOBDCrai/zG66GXvKQrah
        9XqbyBVUa9Dx1PlAnCvnM
X-Received: by 2002:a05:6638:22c3:b0:314:519e:d990 with SMTP id j3-20020a05663822c300b00314519ed990mr11146007jat.209.1646666985799;
        Mon, 07 Mar 2022 07:29:45 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyI0p9VbIkM184+2/0uJp7qRGdppLqSkR4//W5f1yvMTbpapV63/aeYwZ3J0/cVmj9ifRKL7A==
X-Received: by 2002:a05:6638:22c3:b0:314:519e:d990 with SMTP id j3-20020a05663822c300b00314519ed990mr11145979jat.209.1646666985372;
        Mon, 07 Mar 2022 07:29:45 -0800 (PST)
Received: from [10.0.0.147] (sandeen.net. [63.231.237.45])
        by smtp.gmail.com with ESMTPSA id s8-20020a056e021a0800b002c607de5be7sm10415609ild.10.2022.03.07.07.29.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 07 Mar 2022 07:29:44 -0800 (PST)
From:   Eric Sandeen <esandeen@redhat.com>
X-Google-Original-From: Eric Sandeen <sandeen@redhat.com>
Message-ID: <9f957f7a-0f08-9cb4-d8ff-76440a488184@redhat.com>
Date:   Mon, 7 Mar 2022 09:29:44 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.6.1
Subject: Re: Inconsistent "EXPERIMENTAL online shrink feature in use. Use at
 your own risk" alert
Content-Language: en-US
To:     David Dal Ben <dalben@gmail.com>, linux-xfs@vger.kernel.org
References: <CALwRca2+UsEZMPwiCtecM87HVVMs27SdawdWXns+PU7+S-DFaQ@mail.gmail.com>
 <CALwRca3yS2q4XYr5aFaPWxNcGsYRFDWeU9je1q31KGguTeX6Rw@mail.gmail.com>
 <YiYIO2lJf123LA2c@B-P7TQMD6M-0146.local>
 <CALwRca2bZD5tXmL5kzCdL97LpqWGVhYXMNSWSvqn=FkMuMrbjQ@mail.gmail.com>
In-Reply-To: <CALwRca2bZD5tXmL5kzCdL97LpqWGVhYXMNSWSvqn=FkMuMrbjQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 3/7/22 9:16 AM, David Dal Ben wrote:
> xfs_repair version 5.13.0
> 
> Some background.  File system was 24Tb,  Expanded out to 52Tb then
> back down 40Tb where it is now after migration data to the new disks.
> Both 18Tb disks were added to the array at the same time.

So, xfs_growfs has historically been unable to shrink the filesystem at
all. Thanks to Gao's work, it can be shrunk but only in very unique cases,
i.e. the case where there is no data or metadata located in the space
that would be removed at the end of the filesystem.  More complete
functionality remains unimplemented.

So to be clear, did you did you actually shrink the underlying device size?

And/or did you issue an "xfs_growfs" command with a size smaller than the
current size?

If you shrunk the block device without successfully shrinking the filesystem
first, then you have a corrupted filesystem and lost data, I'm afraid.  

But AFAIK xfs_growfs should have failed gracefully, and your filesystem
should be the same size as before, and should still be consistent, as long
as the actual storage was not reduced.

The concern is re: whether you shrunk the storage.

What was the actual sequence of commands you issued?

-Eric


> Not sure how much more info I can give you as I'm relaying info
> between Unraid techs and you.  My main concern is whether I do have
> any real risk at the moment.




> On Mon, 7 Mar 2022 at 21:27, Gao Xiang <hsiangkao@linux.alibaba.com> wrote:
>>
>> Hi,
>>
>> On Mon, Mar 07, 2022 at 08:19:11PM +0800, David Dal Ben wrote:
>>> The "XFS (md1): EXPERIMENTAL online shrink feature in use. Use at your
>>> own risk!" alert is appearing in my syslog/on my console.  It started
>>> after I upgraded a couple of drives to Toshiba MG09ACA18TE 18Tb
>>> drives.
>>>
>>> Strangely the alert appears for one drive and not the other.  There
>>> was no configuring or setting anything up wrt the disks, just
>>> installed them straight out of the box.
>>>
>>> Is there a real risk?  If so, is there a way to disable the feature?
>>>
>>> Kernel used: Linux version 5.14.15-Unraid
>>>
>>> Syslog snippet:
>>>
>>> Mar  6 19:59:21 tdm emhttpd: shcmd (81): mkdir -p /mnt/disk1
>>> Mar  6 19:59:21 tdm emhttpd: shcmd (82): mount -t xfs -o noatime
>>> /dev/md1 /mnt/disk1
>>> Mar  6 19:59:21 tdm kernel: SGI XFS with ACLs, security attributes, no
>>> debug enabled
>>> Mar  6 19:59:21 tdm kernel: XFS (md1): Mounting V5 Filesystem
>>> Mar  6 19:59:21 tdm kernel: XFS (md1): Ending clean mount
>>> Mar  6 19:59:21 tdm emhttpd: shcmd (83): xfs_growfs /mnt/disk1
>>> Mar  6 19:59:21 tdm kernel: xfs filesystem being mounted at /mnt/disk1
>>> supports timestamps until 2038 (0x7fffffff)
>>> Mar  6 19:59:21 tdm root: xfs_growfs: XFS_IOC_FSGROWFSDATA xfsctl
>>> failed: No space left on device
>>
>> ...
>>
>> May I ask what is xfsprogs version used now?
>>
>> At the first glance, it seems that some old xfsprogs is used here,
>> otherwise, it will show "[EXPERIMENTAL] try to shrink unused space"
>> message together with the kernel message as well.
>>
>> I'm not sure what's sb_dblocks recorded in on-disk super block
>> compared with new disk sizes.
>>
>> I guess the problem may be that the one new disk is larger than
>> sb_dblocks and the other is smaller than sb_dblocks. But if some
>> old xfsprogs is used, I'm still confused why old version xfsprogs
>> didn't block it at the userspace in advance.
>>
>> Thanks,
>> Gao Xiang
>>
>>> Mar  6 19:59:21 tdm root: meta-data=/dev/md1               isize=512
>>>  agcount=32, agsize=137330687 blks
>>> Mar  6 19:59:21 tdm root:          =                       sectsz=512
>>>  attr=2, projid32bit=1
>>> Mar  6 19:59:21 tdm root:          =                       crc=1
>>>  finobt=1, sparse=1, rmapbt=0
>>> Mar  6 19:59:21 tdm root:          =                       reflink=1
>>>  bigtime=0 inobtcount=0
>>> Mar  6 19:59:21 tdm root: data     =                       bsize=4096
>>>  blocks=4394581984, imaxpct=5
>>> Mar  6 19:59:21 tdm root:          =                       sunit=1
>>>  swidth=32 blks
>>> Mar  6 19:59:21 tdm root: naming   =version 2              bsize=4096
>>>  ascii-ci=0, ftype=1
>>> Mar  6 19:59:21 tdm root: log      =internal log           bsize=4096
>>>  blocks=521728, version=2
>>> Mar  6 19:59:21 tdm root:          =                       sectsz=512
>>>  sunit=1 blks, lazy-count=1
>>> Mar  6 19:59:21 tdm root: realtime =none                   extsz=4096
>>>  blocks=0, rtextents=0
>>> Mar  6 19:59:21 tdm emhttpd: shcmd (83): exit status: 1
>>> Mar  6 19:59:21 tdm emhttpd: shcmd (84): mkdir -p /mnt/disk2
>>> Mar  6 19:59:21 tdm kernel: XFS (md1): EXPERIMENTAL online shrink
>>> feature in use. Use at your own risk!
>>> Mar  6 19:59:21 tdm emhttpd: shcmd (85): mount -t xfs -o noatime
>>> /dev/md2 /mnt/disk2
>>> Mar  6 19:59:21 tdm kernel: XFS (md2): Mounting V5 Filesystem
>>> Mar  6 19:59:22 tdm kernel: XFS (md2): Ending clean mount
>>> Mar  6 19:59:22 tdm kernel: xfs filesystem being mounted at /mnt/disk2
>>> supports timestamps until 2038 (0x7fffffff)
>>> Mar  6 19:59:22 tdm emhttpd: shcmd (86): xfs_growfs /mnt/disk2
>>> Mar  6 19:59:22 tdm root: xfs_growfs: XFS_IOC_FSGROWFSDATA xfsctl
>>> failed: No space left on device
>>
>>
>>> Mar  6 19:59:22 tdm root: meta-data=/dev/md2               isize=512
>>>  agcount=32, agsize=137330687 blks
>>> Mar  6 19:59:22 tdm root:          =                       sectsz=512
>>>  attr=2, projid32bit=1
>>> Mar  6 19:59:22 tdm root:          =                       crc=1
>>>  finobt=1, sparse=1, rmapbt=0
>>> Mar  6 19:59:22 tdm root:          =                       reflink=1
>>>  bigtime=0 inobtcount=0
>>> Mar  6 19:59:22 tdm root: data     =                       bsize=4096
>>>  blocks=4394581984, imaxpct=5
>>> Mar  6 19:59:22 tdm root:          =                       sunit=1
>>>  swidth=32 blks
>>> Mar  6 19:59:22 tdm root: naming   =version 2              bsize=4096
>>>  ascii-ci=0, ftype=1
>>> Mar  6 19:59:22 tdm root: log      =internal log           bsize=4096
>>>  blocks=521728, version=2
>>> Mar  6 19:59:22 tdm root:          =                       sectsz=512
>>>  sunit=1 blks, lazy-count=1
>>> Mar  6 19:59:22 tdm root: realtime =none                   extsz=4096
>>>  blocks=0, rtextents=0
>>> Mar  6 19:59:22 tdm emhttpd: shcmd (86): exit status: 1
> 
> 

