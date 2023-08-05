Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51EA9C001DB
	for <linux-xfs@archiver.kernel.org>; Sat,  5 Aug 2023 01:44:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229521AbjHEBou (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 4 Aug 2023 21:44:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229487AbjHEBot (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 4 Aug 2023 21:44:49 -0400
Received: from juniper.fatooh.org (juniper.fatooh.org [173.255.221.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53A45E72
        for <linux-xfs@vger.kernel.org>; Fri,  4 Aug 2023 18:44:48 -0700 (PDT)
Received: from juniper.fatooh.org (juniper.fatooh.org [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by juniper.fatooh.org (Postfix) with ESMTPS id 28B3A402C9;
        Fri,  4 Aug 2023 18:44:48 -0700 (PDT)
Received: from juniper.fatooh.org (juniper.fatooh.org [127.0.0.1])
        by juniper.fatooh.org (Postfix) with ESMTP id 0157040369;
        Fri,  4 Aug 2023 18:44:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha1; c=simple; d=fatooh.org; h=message-id
        :date:mime-version:subject:to:cc:references:from:in-reply-to
        :content-type:content-transfer-encoding; s=dkim; bh=JRggB8lq7AEC
        P6rW3IY/NzmbSN0=; b=gTQELAQGbyqUgQeAE5BOid4mrsK7z5fGonhEh+HJDMkC
        5nUCAYnbsvKM1jK3vFVvWGpZtwZqoP+K0x8LOjqT1s4CKnwgUx+2ThdoMVn1QjI0
        RTd54i9JeMa7DISKXmYckX/aLtKXgQsjWfygkI+QME2UYgHURyQ4tsDwr2Zl5vg=
DomainKey-Signature: a=rsa-sha1; c=simple; d=fatooh.org; h=message-id
        :date:mime-version:subject:to:cc:references:from:in-reply-to
        :content-type:content-transfer-encoding; q=dns; s=dkim; b=RAUx/P
        AmsgCdReQwNsHmYaX9lrLoEOM00XH8Q+c2L1n1YR98FUnGHsB7qXfOWZnHJZY2ix
        7UD0BoceHLnOS/MG+QCwaKYJEIgZUizdfYopwLoWB6yEmGAM0DjQ5SK+Pw6hmB3C
        BErWs6ZKMMcrCsqtDeEmDiRuD7gEAGHx2UNAc=
Received: from [198.18.0.3] (unknown [104.184.153.121])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by juniper.fatooh.org (Postfix) with ESMTPSA id E891B402C9;
        Fri,  4 Aug 2023 18:44:47 -0700 (PDT)
Message-ID: <0f21f5eb-803f-c8d1-503a-bb0addeef01f@fatooh.org>
Date:   Fri, 4 Aug 2023 18:44:47 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: read-modify-write occurring for direct I/O on RAID-5
Content-Language: en-US
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
References: <55225218-b866-d3db-d62b-7c075dd712de@fatooh.org>
 <ZMyxp/Udved6l9F/@dread.disaster.area>
 <db157228-3687-57bf-d090-10517847404d@fatooh.org>
 <ZM1zOFWVm9lD8pNc@dread.disaster.area>
From:   Corey Hickey <bugfood-ml@fatooh.org>
In-Reply-To: <ZM1zOFWVm9lD8pNc@dread.disaster.area>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 2023-08-04 14:52, Dave Chinner wrote:
> On Fri, Aug 04, 2023 at 12:26:22PM -0700, Corey Hickey wrote:
>> On 2023-08-04 01:07, Dave Chinner wrote:
>>> If you want to force XFS to do stripe width aligned allocation for
>>> large files to match with how MD exposes it's topology to
>>> filesytsems, use the 'swalloc' mount option. The down side is that
>>> you'll hotspot the first disk in the MD array....
>>
>> If I use 'swalloc' with the autodetected (wrong) swidth, I don't see any
>> unaligned writes.
>>
>> If I manually specify the (I think) correct values, I do still get writes
>> aligned to sunit but not swidth, as before.
> 
> Hmmm, it should not be doing that - where is the misalignment
> happening in the file? swalloc isn't widely used/tested, so there's
> every chance there's something unexpected going on in the code...

I don't know how to tell the file position, but I wrote a one-liner for
blktrace that may help. This should tell the position within the block
device of writes enqueued.

For every time the alignment _changes_, the awk program prints:
* the previous line (if it exists and was not already printed)
* the current line

Lines from blktrace are prefixed by:
* a 'c' or 'p' for debugging the awk program
* the offset from a 2048-sector alignment
* a '--' as a separator

I have manually inserted blank lines into the output in order to
visually separate into three sections:
1. writes predominantly stripe-aligned
2. writes predominantly offset by one chunk
3. writes predominantly stripe-aligned again

-----------------------------------------------------------------------
$ sudo blktrace -d /dev/md10 -o - | blkparse -i - | awk 'BEGIN { prev=""; prev_offset=-1; } / Q / { offset=$8 % 2048; if (offset != prev_offset) { if (prev) { printf("p %4d -- %s\n", prev_offset, prev); prev="" }; printf("c %4d -- %s\n", offset, $0); prev_offset=offset; fflush(); } else { prev=$0 }} '
c   32 --   9,10  11        1     0.000000000 213852  Q  RM 32 + 8 [dd]
c   24 --   9,10  11        2     0.000253462 213852  Q  RM 24 + 8 [dd]
c 1024 --   9,10  11        3     0.000434115 213852  Q  RM 1024 + 32 [dd]
c    3 --   9,10  11        4     0.001008057 213852  Q  RM 3 + 1 [dd]
c   16 --   9,10  11        5     0.001165978 213852  Q  RM 16 + 8 [dd]
c    8 --   9,10  11        6     0.001328206 213852  Q  RM 8 + 8 [dd]
c    0 --   9,10  11        7     0.001496647 213852  Q  WS 2048 + 2048 [dd]
p    0 --   9,10   1      469    10.544416303 213852  Q  WS 6301696 + 2048 [dd]
c  128 --   9,10   1      471    10.545831615 213789  Q FWFSM 62906496 + 64 [kworker/1:3]
c    0 --   9,10   1      472    10.548127201 213852  Q  WS 6303744 + 2048 [dd]
p    0 --   9,10   0     5791    13.109985396 213852  Q  WS 7804928 + 2048 [dd]

c 1027 --   9,10   0     5793    13.113192558 213852  Q  RM 7863299 + 1 [dd]
c 1040 --   9,10   0     5794    13.136165405 213852  Q  RM 7863312 + 8 [dd]
c 1032 --   9,10   0     5795    13.136458182 213852  Q  RM 7863304 + 8 [dd]
c 1024 --   9,10   0     5796    13.136568992 213852  Q  WS 7865344 + 2048 [dd]
p 1024 --   9,10   1     2818    41.250430374 213852  Q  WS 12133376 + 2048 [dd]
c  192 --   9,10   1     2820    41.266187726 213789  Q FWFSM 62906560 + 64 [kworker/1:3]
c 1024 --   9,10   1     2821    41.275578120 213852  Q  WS 12135424 + 2048 [dd]
c    2 --   9,10   5        1    41.266226029 213819  Q  WM 2 + 1 [xfsaild/md10]
c   24 --   9,10   5        2    41.266236639 213819  Q  WM 24 + 8 [xfsaild/md10]
c   32 --   9,10   5        3    41.266242160 213819  Q  WM 32 + 8 [xfsaild/md10]
c 1024 --   9,10   5        4    41.266246318 213819  Q  WM 1024 + 32 [xfsaild/md10]
p 1024 --   9,10   1     2823    41.308444405 213852  Q  WS 12137472 + 2048 [dd]
c  256 --   9,10  10      706    41.322338854 207685  Q FWFSM 62906624 + 64 [kworker/u64:11]
c 1024 --   9,10   1     2825    41.334778677 213852  Q  WS 12139520 + 2048 [dd]
p 1024 --   9,10   3     3739    64.424114908 213852  Q  WS 15668224 + 2048 [dd]
c    3 --   9,10   3     3741    64.445830212 213852  Q  RM 15726595 + 1 [dd]
c   16 --   9,10   3     3742    64.455104423 213852  Q  RM 15726608 + 8 [dd]
c    8 --   9,10   3     3743    64.463494822 213852  Q  RM 15726600 + 8 [dd]
c    0 --   9,10   3     3744    64.470414156 213852  Q  WS 15728640 + 2048 [dd]

p    0 --   9,10   1     6911    71.983449607 213852  Q  WS 20101120 + 2048 [dd]
c  320 --   9,10   1     6913    71.985823522 213789  Q FWFSM 62906688 + 64 [kworker/1:3]
c    0 --   9,10   1     6914    71.987115410 213852  Q  WS 20103168 + 2048 [dd]
c    1 --   9,10   5        6    71.985857777 213819  Q  WM 1 + 1 [xfsaild/md10]
c    8 --   9,10   5        7    71.985869209 213819  Q  WM 8 + 8 [xfsaild/md10]
c   16 --   9,10   5        8    71.985874249 213819  Q  WM 16 + 8 [xfsaild/md10]
c    0 --   9,10   1     6916    72.002414341 213852  Q  WS 20105216 + 2048 [dd]
p    0 --   9,10   1     6924    72.041196270 213852  Q  WS 20113408 + 2048 [dd]
c  384 --   9,10   4        1    72.041820949 211757  Q FWFSM 62906752 + 64 [kworker/u64:1]
c    0 --   9,10   1     6926    72.043596586 213852  Q  WS 20115456 + 2048 [dd]
-----------------------------------------------------------------------

I don't know if that's quite what you wanted, but hopefully it helps for
something.

> One thing to try is to set extent size hints for the directories
> these large files are going to be written to. That takes a lot of
> the allocation decisions away from the size/shape of the individual
> IO and instead does large file offset aligned/sized allocations
> which are much more likely to be stripe width aligned. e.g. set a
> extent size hint of 16MB, and the first write into a hole will
> allocate a 16MB chunk around the write instead of just the size that
> covers the write IO.

Can you please give me a documentation pointer for that? I wasn't able
to find the right thing via searching.

I see some references to size hints in mkfs.xfs, but it seems like you
refer to something to be set for specific directories at run-time.

>> Still, I'll heed your advice about not making a hotspot disk and allow XFS
>> to allocate as default.
>>
>> Now that I understand that XFS is behaving as intended and I can't/shouldn't
>> necessarily aim for further alignment, I'll try recreating my real RAID,
>> trust in buffered writes and the MD stripe cache, and see how that goes.
> 
> Buffered writes won't guarantee you alignment, either, In fact, it's
> much more likely to do weird stuff than direct IO. If your
> filesystem is empty, then buffered writes can look *really good*,
> but once the filesystem starts being used and has lots of
> discontiguous free space or the system is busy enough that writeback
> can't lock contiguous ranges of pages, writeback IO will look a
> whole lot less pretty and you have little control over what
> it does....

I'll keep that in mind. This filesystem doesn't get extensive writes
except when restoring from backup. That is why I started looking at
alignment, though--restoring from backup onto a new array with new
disks was incurring lots of RMW, reads were very delayed, and the
kernel was warning about hung tasks.

It probably didn't help that my RAID-5 was degraded due to a failed
disk I had to return. I audited my alignment choices anyway and found
some things I could do better, but I got stuck on XFS, hence this
thread.

My intended full stack is:
* RAID-5
* bcache (default settings--writethrough)
* dm-crypt
* XFS

..and I've operated that before without noticing anything so bad.

The alignment gets tricky, especially because bcache has a fixed
default data offset and doesn't quite propagate the topology of the
underlying backing device.

$ sudo blkid -i /dev/md5
/dev/md5: MINIMUM_IO_SIZE="131072" OPTIMAL_IO_SIZE="262144" PHYSICAL_SECTOR_SIZE="4096" LOGICAL_SECTOR_SIZE="512"
$ sudo blkid -i /dev/bcache0
/dev/bcache0: MINIMUM_IO_SIZE="512" OPTIMAL_IO_SIZE="262144" PHYSICAL_SECTOR_SIZE="512" LOGICAL_SECTOR_SIZE="512"

Some of that makes sense for a writeback scenario, but I think for
writethrough I want to align to the topology of the underlying
backing device.

Thanks again for all your time.

-Corey
