Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5035FC433F5
	for <linux-xfs@archiver.kernel.org>; Tue,  2 Nov 2021 01:37:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 373F860F6F
	for <linux-xfs@archiver.kernel.org>; Tue,  2 Nov 2021 01:37:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229491AbhKBBkR (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 1 Nov 2021 21:40:17 -0400
Received: from ishtar.tlinx.org ([173.164.175.65]:39464 "EHLO
        Ishtar.sc.tlinx.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229479AbhKBBkR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 1 Nov 2021 21:40:17 -0400
Received: from [192.168.3.12] (Athenae [192.168.3.12])
        by Ishtar.sc.tlinx.org (8.14.7/8.14.4/SuSE Linux 0.8) with ESMTP id 1A21bdtN073866;
        Mon, 1 Nov 2021 18:37:41 -0700
Message-ID: <618095E6.9050706@tlinx.org>
Date:   Mon, 01 Nov 2021 18:35:34 -0700
From:   L A Walsh <xfs@tlinx.org>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To:     Dave Chinner <david@fromorbit.com>
CC:     linux-xfs <linux-xfs@vger.kernel.org>
Subject: Re: cause of xfsdump msg: root ino 192 differs from mount dir ino
 256
References: <617721E0.5000009@tlinx.org> <20211026004814.GA5111@dread.disaster.area> <617F0A6D.6060506@tlinx.org> <61804CD4.8070103@tlinx.org> <20211101211244.GC449541@dread.disaster.area>
In-Reply-To: <20211101211244.GC449541@dread.disaster.area>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 2021/11/01 14:12, Dave Chinner wrote: 
> Can you attach the full output for the xfs_dump and xfsrestore
> commands 
---
I can as soon as I do ones that I can capture.

I can restore the backup taken this morning (a level 0) to
an alternate partition -- it is doing that now and generating 
the same messages about files being stored in the orphanage
as we "speak", it will take a while to xfsrestore 1.4T.

At the same time, I'm generating a new level 0 backup (something
that was done this morning) resulting in a 1574649321568 byte 
(~1.4T) output file.

So far, the process doing the xfsdump shows:
 xfsdump -b 268435456 -l 0 -L home -e - /home
xfsdump: using file dump (drive_simple) strategy
xfsdump: version 3.1.8 (dump format 3.0)
xfsdump: level 0 dump of Ishtar:/home
xfsdump: dump date: Mon Nov  1 18:15:07 2021
xfsdump: session id: 8f996280-21df-42c5-b0a0-3f1584ae1f54
xfsdump: session label: "home"
xfsdump: NOTE: root ino 192 differs from mount dir ino 256, bind mount?
xfsdump: ino map phase 1: constructing initial dump list
xfsdump: ino map phase 2: skipping (no pruning necessary)
xfsdump: ino map phase 3: skipping (only one dump stream)
xfsdump: ino map construction complete
xfsdump: estimated dump size: 1587242183552 bytes
xfsdump: creating dump session media file 0 (media 0, file 0)
xfsdump: dumping ino map
xfsdump: dumping directories

I'm using a 256M blocksize that is buffered via mbuffer
using 5 buffers of the same size (256M) to the output file.

xfsrestore uses a normal file read...hmm...I wonder
if a direct read might be faster, like using 'dd' to perform
an unbuffered read and pipe write to xfsrestore....  maybe something
for future exploring...



>> grepping for '/home\s' on output of mount:
>>
>> /bin/mount|grep -P '/home\s'
>>
>> shows only 1 entry -- nothing mounted on top of it:
>>
>> /dev/mapper/Space-Home2 on /home type xfs (...)
>>
>> I have bind-mounts of things like
>> /home/opt  on /opt, but that shouldn't affect the root node,
>> as far as I know.
>>
>> So what would cause the root node to differ from the mountdir
>> ino?
>>
>> I try mounting the same filesystem someplace new:
>>
>> # df .
>> Filesystem        Size  Used Avail Use% Mounted on
>> /dev/Space/Home2  2.0T  1.5T  569G  73% /home
>> mkdir /home2
>> Ishtar:home# mount /dev/Space/Home2 /home2
>> Ishtar:home# ll -di /home /home2
>> 256 drwxr-xr-x 40 4096 Nov  1 10:23 /home/
>> 256 drwxr-xr-x 40 4096 Nov  1 10:23 /home2/
>>
>> Shows 256 as the root inode.  So why is xfsdump claiming
>> 192 is root inode?
> 
> IIRC, it's because xfsdump thinks that the first inode in the
> filesystem is the root inode. Which is not always true - there are
> corner cases to do with stripe alignment, btree roots relocating and
> now sparse inodes that can result in new inodes being allocated at a
> lower number than the root inode.
> 
> Indeed, the "bind mount?" message is an indication that xfsdump
> found that the first inode was not the same as the root inode, and
> so that's likely what has happened here.
> 
> Now that I think about this, ISTR the above "inodes before root
> inode" situation being reported at some point in the past. Yeah:
> 
> https://lore.kernel.org/linux-xfs/f66f26f7-5e29-80fc-206c-9a53cf4640fa@redhat.com/
> 
> Eric, can you remember what came of those patches?
> 
> Cheers,
> 
> Dave.
