Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94A40C0015E
	for <linux-xfs@archiver.kernel.org>; Sun,  6 Aug 2023 18:21:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230172AbjHFSVk (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 6 Aug 2023 14:21:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbjHFSVk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 6 Aug 2023 14:21:40 -0400
Received: from juniper.fatooh.org (juniper.fatooh.org [173.255.221.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 419C31716
        for <linux-xfs@vger.kernel.org>; Sun,  6 Aug 2023 11:21:39 -0700 (PDT)
Received: from juniper.fatooh.org (juniper.fatooh.org [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by juniper.fatooh.org (Postfix) with ESMTPS id BACF3403E5;
        Sun,  6 Aug 2023 11:21:38 -0700 (PDT)
Received: from juniper.fatooh.org (juniper.fatooh.org [127.0.0.1])
        by juniper.fatooh.org (Postfix) with ESMTP id 909A7403F3;
        Sun,  6 Aug 2023 11:21:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha1; c=simple; d=fatooh.org; h=message-id
        :date:mime-version:subject:to:cc:references:from:in-reply-to
        :content-type:content-transfer-encoding; s=dkim; bh=sGIQB+VOFDB9
        gGSvjccKQPEPzzg=; b=N3cPSAeaKO/0vsHN1H1P6OSQtBTXxd34gjqx+GA+xnxU
        9f5/p/ZVb1+/huTg5zOfYnQUes6X4Scb6y0OSXeOp8OMCUt6o0MiTIYXb+mgXSEO
        pfQ/XJHyl8YVkKgBxzqmGGsaTS/o2WvnlbFIwrxnCORrzjGKCLcfOjJ+GARdVaQ=
DomainKey-Signature: a=rsa-sha1; c=simple; d=fatooh.org; h=message-id
        :date:mime-version:subject:to:cc:references:from:in-reply-to
        :content-type:content-transfer-encoding; q=dns; s=dkim; b=We/pn7
        qlKc6tzqLMYf5Gs2/Kqn6r6od7L2emPE0LtpS3dHNgi81+5zA0dryL/L9/2PqgDU
        wrMmtKko0Y2gTVx3yV+2CB7+WVSRh7jJ0gvu/MNEWgDsKXarQIE2caOIz3DZpZ5g
        PF3th2WBKNjP1Y/Hdwwjc3t5wDpl0mW6MZfQ8=
Received: from [198.18.0.3] (unknown [104.184.153.121])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by juniper.fatooh.org (Postfix) with ESMTPSA id 834D6403E5;
        Sun,  6 Aug 2023 11:21:38 -0700 (PDT)
Message-ID: <6ac1f404-2cd2-42db-87b3-e1c7d5933a2d@fatooh.org>
Date:   Sun, 6 Aug 2023 11:21:38 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: read-modify-write occurring for direct I/O on RAID-5
Content-Language: en-US
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
References: <55225218-b866-d3db-d62b-7c075dd712de@fatooh.org>
 <ZMyxp/Udved6l9F/@dread.disaster.area>
 <db157228-3687-57bf-d090-10517847404d@fatooh.org>
 <ZM1zOFWVm9lD8pNc@dread.disaster.area>
 <0f21f5eb-803f-c8d1-503a-bb0addeef01f@fatooh.org>
 <ZM7PHRsOqfJ71fMN@dread.disaster.area>
From:   Corey Hickey <bugfood-ml@fatooh.org>
In-Reply-To: <ZM7PHRsOqfJ71fMN@dread.disaster.area>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 2023-08-05 15:37, Dave Chinner wrote:
> On Fri, Aug 04, 2023 at 06:44:47PM -0700, Corey Hickey wrote:
>> On 2023-08-04 14:52, Dave Chinner wrote:
>>> On Fri, Aug 04, 2023 at 12:26:22PM -0700, Corey Hickey wrote:
>>>> On 2023-08-04 01:07, Dave Chinner wrote:
>>>>> If you want to force XFS to do stripe width aligned allocation for
>>>>> large files to match with how MD exposes it's topology to
>>>>> filesytsems, use the 'swalloc' mount option. The down side is that
>>>>> you'll hotspot the first disk in the MD array....
>>>>
>>>> If I use 'swalloc' with the autodetected (wrong) swidth, I don't see any
>>>> unaligned writes.
>>>>
>>>> If I manually specify the (I think) correct values, I do still get writes
>>>> aligned to sunit but not swidth, as before.
>>>
>>> Hmmm, it should not be doing that - where is the misalignment
>>> happening in the file? swalloc isn't widely used/tested, so there's
>>> every chance there's something unexpected going on in the code...
>>
>> I don't know how to tell the file position, but I wrote a one-liner for
>> blktrace that may help. This should tell the position within the block
>> device of writes enqueued.
> 
> xfs_bmap will tell you the file extent layout (offset to lba relationship).
> (`xfs_bmap -vvp <file>` output is prefered if you are going to paste
> it into an email.)
Ah, nice; the flags even show the alignment.

Here are the results for a filesystem on a 2-data-disk RAID-5 with 128 KB
chunk size.

$ sudo mkfs.xfs -s size=4096 -d sunit=256,swidth=512 /dev/md5 -f
meta-data=/dev/md5               isize=512    agcount=16, agsize=983008 blks
          =                       sectsz=4096  attr=2, projid32bit=1
          =                       crc=1        finobt=1, sparse=1, rmapbt=0
          =                       reflink=1    bigtime=1 inobtcount=1 nrext64=0
data     =                       bsize=4096   blocks=15728128, imaxpct=25
          =                       sunit=32     swidth=64 blks
naming   =version 2              bsize=4096   ascii-ci=0, ftype=1
log      =internal log           bsize=4096   blocks=16384, version=2
          =                       sectsz=4096  sunit=1 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0

$ sudo mount -o noatime,swalloc /dev/md5 /mnt/tmp

$ sudo dd if=/dev/zero of=/mnt/tmp/test.bin iflag=fullblock oflag=direct bs=1M count=10240
10240+0 records in
10240+0 records out
10737418240 bytes (11 GB, 10 GiB) copied, 62.6102 s, 171 MB/s

$ sudo xfs_bmap -vvp /mnt/tmp/test.bin
/mnt/tmp/test.bin:
  EXT: FILE-OFFSET           BLOCK-RANGE        AG AG-OFFSET          TOTAL FLAGS
    0: [0..7806975]:         512..7807487        0 (512..7807487)   7806976 000000
    1: [7806976..15613951]:  7864576..15671551   1 (512..7807487)   7806976 000011
    2: [15613952..20971519]: 15728640..21086207  2 (512..5358079)   5357568 000000
  FLAG Values:
     0100000 Shared extent
     0010000 Unwritten preallocated extent
     0001000 Doesn't begin on stripe unit
     0000100 Doesn't end   on stripe unit
     0000010 Doesn't begin on stripe width
     0000001 Doesn't end   on stripe width

>>> One thing to try is to set extent size hints for the directories
>>> these large files are going to be written to. That takes a lot of
>>> the allocation decisions away from the size/shape of the individual
>>> IO and instead does large file offset aligned/sized allocations
>>> which are much more likely to be stripe width aligned. e.g. set a
>>> extent size hint of 16MB, and the first write into a hole will
>>> allocate a 16MB chunk around the write instead of just the size that
>>> covers the write IO.
>>
>> Can you please give me a documentation pointer for that? I wasn't able
>> to find the right thing via searching.
> 
[...]
> $ man xfs_io
> ....
>         extsize [ -R | -D ] [ value ]
[...]

Aha, thanks. That's what I was looking for.

-Corey
