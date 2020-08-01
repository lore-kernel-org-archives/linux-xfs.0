Return-Path: <SRS0=tAZO=BL=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.4 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14BBBC433E0
	for <linux-xfs@archiver.kernel.org>; Sat,  1 Aug 2020 18:10:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EEF6D2068F
	for <linux-xfs@archiver.kernel.org>; Sat,  1 Aug 2020 18:10:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727063AbgHASK1 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 1 Aug 2020 14:10:27 -0400
Received: from mx3.molgen.mpg.de ([141.14.17.11]:43661 "EHLO mx1.molgen.mpg.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726901AbgHASK1 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sat, 1 Aug 2020 14:10:27 -0400
Received: from [192.168.0.4] (ip5f5aeff1.dynamic.kabel-deutschland.de [95.90.239.241])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: buczek)
        by mx.molgen.mpg.de (Postfix) with ESMTPSA id 67A172064608E;
        Sat,  1 Aug 2020 20:10:23 +0200 (CEST)
Subject: Re: xfs_reclaim_inodes_ag taking several seconds
From:   Donald Buczek <buczek@molgen.mpg.de>
To:     Dave Chinner <david@fromorbit.com>
Cc:     darrick.wong@oracle.com, linux-xfs@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
References: <8284912e-b99a-31af-1901-a38ea03b8648@molgen.mpg.de>
 <20200731223255.GG2005@dread.disaster.area>
 <d515fa07-5198-fc3c-24ac-d35aa4e08668@molgen.mpg.de>
Message-ID: <0f0416a5-2af8-b4be-d53e-6af61082424a@molgen.mpg.de>
Date:   Sat, 1 Aug 2020 20:10:22 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <d515fa07-5198-fc3c-24ac-d35aa4e08668@molgen.mpg.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org


On 01.08.20 12:25, Donald Buczek wrote:

> So if I understand you correctly, this is expected behavior with this kind of load and conceptual changes are already scheduled for kernel 5.9. I don't understand most of it, but isn't it true that with that planned changes the impact might be better limited to the filesystem, so that the performance of other areas of the system might improve? I'd love to test that with our load, but I don't want to risk our backup data and it would be difficult to produce the same load on a toy system. The patch set is not yet ready to be tested on production data, is it?
> 
> So I guess I'll try to put the backup processes into one or more cgroups to limit the memory available for their fs caches and leave some room for unrelated (maintenance) processes. I hope, that makes sense.

Which it doesn't, because it totally ignores what was said before. The affected processes were not waiting for memory but for the shrinker to finish.

D.

> 
> Thank you both four your analysis!
> 
> Donald
> 
>> And if you have 30 million inodes in memory, and lots of them are
>> dirty, and the shrinkers are running, then they will be doing
>> dirty inode writeback to throttle memory reclaim to
>> ensure it makes progress and doesn't declare OOM and kill processes
>> permaturely.
>>
>> You have spinning disks, RAID6. I'm betting that it can only clean a
>> couple of hundred inodes a second because RAID6 is severely IOP
>> limited for small writes (like inode clusters). And when you many,
>> many thousands (maybe millions) of dirty inodes, anything that has
>> to wait on inode writeback is going to be waiting for some time...
>>
>>> root:done:/home/buczek/linux_problems/shrinker_semaphore/# xfs_info /amd/done/C/C8024
>>> meta-data=/dev/md0               isize=512    agcount=102, agsize=268435328 blks
>>>           =                       sectsz=4096  attr=2, projid32bit=1
>>>           =                       crc=1        finobt=1, sparse=1, rmapbt=0
>>>           =                       reflink=0
>>> data     =                       bsize=4096   blocks=27348629504, imaxpct=1
>>>           =                       sunit=128    swidth=1792 blks
>>> naming   =version 2              bsize=4096   ascii-ci=0, ftype=1
>>> log      =internal log           bsize=4096   blocks=521728, version=2
>>
>> And full size journals, so the filesystem can hold an awful lot of
>> active dirty inodes in memory before it starts throttling on a full
>> journal (think millions of dirty inodes per filesystem)...
>>
>> So, yeah, this is the classic "in memory operation is orders of
>> magnitude faster than disk operation" and it all comes crashing down
>> when something needs to wait for inodes to be written back. The
>> patchset Darrick pointed you at should fix the shrinker issue, but
>> it's likely that this will just push the problem to the next
>> throttling point, which is the journal filling up.
>>
>> IOWs, I suspect fixing your shrinker problem is only going to make
>> the overload of dirty inodes in the system behave worse, because
>> running out of journal space cause *all modifications* to the
>> filesystem to start taking significant delays while they wait for
>> inode writeback to free journal space, not just have things
>> trying to register/unregister shrinkers take delays...
>>
>> Cheers,
>>
>> Dave.
>>
> 

-- 
Donald Buczek
buczek@molgen.mpg.de
Tel: +49 30 8413 1433
