Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00DDBC2B9F4
	for <linux-xfs@archiver.kernel.org>; Fri, 25 Jun 2021 14:55:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D272561965
	for <linux-xfs@archiver.kernel.org>; Fri, 25 Jun 2021 14:55:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229653AbhFYO5o (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 25 Jun 2021 10:57:44 -0400
Received: from sandeen.net ([63.231.237.45]:43108 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230235AbhFYO5o (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 25 Jun 2021 10:57:44 -0400
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.146])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 14DB84CDD56;
        Fri, 25 Jun 2021 09:55:01 -0500 (CDT)
To:     Ml Ml <mliebherr99@googlemail.com>, linux-xfs@vger.kernel.org
References: <CANFxOjCAYYs7ck0wrnM1AD0pBKE74=4PcDj_k+gHGjDmmvZBzg@mail.gmail.com>
 <CANFxOjATBAnEJ=pZEjsdsbaY=ziGOo8b3fXL_otYRmDPQOi=_w@mail.gmail.com>
From:   Eric Sandeen <sandeen@sandeen.net>
Subject: Re: XFS Mount need ages
Message-ID: <9a2da15c-b42e-98b1-a2c4-b1bd6474888b@sandeen.net>
Date:   Fri, 25 Jun 2021 09:55:21 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <CANFxOjATBAnEJ=pZEjsdsbaY=ziGOo8b3fXL_otYRmDPQOi=_w@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

What's in dmesg now? Was it doing log recovery? Which kernel version is this?
More info please.

Also for your dd speed test, please use iflag=direct to ensure you aren't
reading cached data.

-Eric

On 6/25/21 7:05 AM, Ml Ml wrote:
> After a loong time it mounted now. Here is some more info:
> 
> xfs_info /mnt/backup-cluster5
> meta-data=/dev/rbd6              isize=512    agcount=65536, agsize=32768 blks
>          =                       sectsz=512   attr=2, projid32bit=1
>          =                       crc=1        finobt=1, sparse=1, rmapbt=0
>          =                       reflink=0
> data     =                       bsize=4096   blocks=2147483648, imaxpct=25
>          =                       sunit=16     swidth=16 blks
> naming   =version 2              bsize=4096   ascii-ci=0, ftype=1
> log      =internal log           bsize=4096   blocks=2560, version=2
>          =                       sectsz=512   sunit=0 blks, lazy-count=1
> realtime =none                   extsz=4096   blocks=0, rtextents=0
> 
> On Fri, Jun 25, 2021 at 12:49 PM Ml Ml <mliebherr99@googlemail.com> wrote:
>>
>> Hello List,
>>
>> i have a rbd block device with xfs on it. After resizing it (from 6TB
>> to 8TB i think) the mount need hours to complete:
>>
>> I started the mount 15mins ago.:
>>   mount -nv /dev/rbd6 /mnt/backup-cluster5
>>
>> ps:
>> root      1143  0.2  0.0   8904  3088 pts/0    D+   12:17   0:03  |
>>    \_ mount -nv /dev/rbd6 /mnt/backup-cluster5
>>
>>
>> There is no timeout or ANY msg in dmesg until now.
>>
>> strace -p 1143  :  seems to do nothing.
>> iotop --pid=1143: uses about 50KB/sec
>>
>> dd bs=1M count=2048 if=/dev/rbd6 of=/dev/null => gives me 50MB/sec
>>
>>
>> Any idea what´s the problem here?
>>
>> Cheers,
>> Michael
> 
