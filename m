Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F11D9C433EF
	for <linux-xfs@archiver.kernel.org>; Thu,  4 Nov 2021 16:20:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D9A8D61212
	for <linux-xfs@archiver.kernel.org>; Thu,  4 Nov 2021 16:20:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231750AbhKDQWz (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 4 Nov 2021 12:22:55 -0400
Received: from sandeen.net ([63.231.237.45]:40494 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231642AbhKDQWw (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 4 Nov 2021 12:22:52 -0400
Received: from [10.0.0.146] (liberator.sandeen.net [10.0.0.146])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 8903614627D;
        Thu,  4 Nov 2021 11:18:33 -0500 (CDT)
Message-ID: <39784566-4696-2391-a6f5-6891c2c7802b@sandeen.net>
Date:   Thu, 4 Nov 2021 11:20:12 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.2.1
Content-Language: en-US
To:     Nikola Ciprich <nikola.ciprich@linuxbox.cz>,
        linux-xfs@vger.kernel.org
References: <20211104090915.GW32555@pcnci.linuxbox.cz>
From:   Eric Sandeen <sandeen@sandeen.net>
Subject: Re: XFS / xfs_repair - problem reading very large sparse files on
 very large filesystem
In-Reply-To: <20211104090915.GW32555@pcnci.linuxbox.cz>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 11/4/21 4:09 AM, Nikola Ciprich wrote:
> Hello fellow XFS users and developers,
> 
> we've stumbled upon strange problem which I think might be somewhere
> in XFS code.
> 
> we have very large ceph-based storage on top which there is 1.5PiB volume
> with XFS filesystem. This contains very large (ie 500TB) sparse files,
> partially filled with data.
> 
> problem is, trying to read those files leads to processes blocked in D
> state showing very very bad performance - ~200KiB/s, 50IOPS.

I'm guessing they are horrifically fragmented? What does xfs_bmap tell you
about the number of extents in one of these files?

When it is blocked, where is it blocked?  (try sysrq-w)

> I tried running xfs_repair on the volume, but this seems to behave in
> very similar way - very quickly it gets into almost stalled state, without
> almost any progress..

Perceived performance won't be fixed by repair, but...

> [root@spbstdnas ~]# xfs_repair -P -t 60 -v -v -v -v /dev/sdk
> Phase 1 - find and verify superblock...
>          - max_mem = 154604838, icount = 9664, imem = 37, dblock = 382464425984, dmem = 186750208
> Memory available for repair (150981MB) may not be sufficient.
> At least 182422MB is needed to repair this filesystem efficiently
> If repair fails due to lack of memory, please
> increase system RAM and/or swap space to at least 364844MB.

... it /is/ telling you that it would like a lot more memory to do
its job.

> Phase 2 - using internal log
>          - zero log...
> zero_log: head block 1454674 tail block 1454674
>          - scan filesystem freespace and inode maps...
>          - found root inode chunk
...
> Phase 3 - for each AG...
>          - scan and clear agi unlinked lists...
>          - process known inodes and perform inode discovery...
>          - agno = 0
>          - agno = 1
>          - agno = 2
> 
> 
>          - agno = 3
>    
> 
> VM has 200GB of RAM, but the xfs_repair does not use more then 1GB,
> CPU is idle. it just only reads the same slow speed, ~200K/s, 50IOPS.

Rather than diagnosing repair at this point, let's first see where you're
blocked when you're reading the sparse files on the filesystem as suggested
above.

-Eric

> I've carefully checked, and the storage speed is much much faster, checked
> with blktrace which areas of the volume it is currently reading, and trying
> fio / dd on them shows it can perform much faster (as well as randomly reading
> any area of the volume or trying randomread or seq read fio benchmarks)
> 
> I've found one, very old report pretty much resembling my problem:
> 
> https://www.spinics.net/lists/xfs/msg06585.html
> 
> but it is 10 years old and didn't lead to any conclusion.
> 
> Is it possible there is still some bug common for XFS kernel module and xfs_repair?
> 
> I tried 5.4.135 and 5.10.31 kernels, xfs_progs 4.5.0 and 5.13.0
> (OS is x86_64 centos 7)
> 
> any hints on how could I further debug that?
> 
> I'd be very gratefull for any help
> 
> with best regards
> 
> nikola ciprich
> 
> 
