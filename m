Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68594C432BE
	for <linux-xfs@archiver.kernel.org>; Fri, 27 Aug 2021 06:53:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4D7B460F92
	for <linux-xfs@archiver.kernel.org>; Fri, 27 Aug 2021 06:53:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234736AbhH0Gyj (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 27 Aug 2021 02:54:39 -0400
Received: from smtp1.onthe.net.au ([203.22.196.249]:44631 "EHLO
        smtp1.onthe.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232463AbhH0Gyi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 27 Aug 2021 02:54:38 -0400
Received: from localhost (smtp2.private.onthe.net.au [10.200.63.13])
        by smtp1.onthe.net.au (Postfix) with ESMTP id 31CDB61C61;
        Fri, 27 Aug 2021 16:53:48 +1000 (EST)
Received: from smtp1.onthe.net.au ([10.200.63.11])
        by localhost (smtp.onthe.net.au [10.200.63.13]) (amavisd-new, port 10028)
        with ESMTP id q-n7vsyXxNpA; Fri, 27 Aug 2021 16:53:48 +1000 (AEST)
Received: from athena.private.onthe.net.au (chris-gw2-vpn.private.onthe.net.au [10.9.3.2])
        by smtp1.onthe.net.au (Postfix) with ESMTP id F31BF61BE7;
        Fri, 27 Aug 2021 16:53:47 +1000 (EST)
Received: by athena.private.onthe.net.au (Postfix, from userid 1026)
        id D4341680468; Fri, 27 Aug 2021 16:53:47 +1000 (AEST)
Date:   Fri, 27 Aug 2021 16:53:47 +1000
From:   Chris Dunlop <chris@onthe.net.au>
To:     Dave Chinner <david@fromorbit.com>
Cc:     Eric Sandeen <sandeen@sandeen.net>, linux-xfs@vger.kernel.org
Subject: Re: XFS fallocate implementation incorrectly reports ENOSPC
Message-ID: <20210827065347.GA3594069@onthe.net.au>
References: <20210826020637.GA2402680@onthe.net.au>
 <335ae292-cb09-6e6e-9673-68cfae666fc0@sandeen.net>
 <20210826205635.GA2453892@onthe.net.au>
 <20210827025539.GA3583175@onthe.net.au>
 <20210827054956.GP3657114@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20210827054956.GP3657114@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

G'day Dave,

On Fri, Aug 27, 2021 at 03:49:56PM +1000, Dave Chinner wrote:
> On Fri, Aug 27, 2021 at 12:55:39PM +1000, Chris Dunlop wrote:
>> On Fri, Aug 27, 2021 at 06:56:35AM +1000, Chris Dunlop wrote:
>>> On Thu, Aug 26, 2021 at 10:05:00AM -0500, Eric Sandeen wrote:
>>>> On 8/25/21 9:06 PM, Chris Dunlop wrote:
>>>>>
>>>>> fallocate -l 1GB image.img
>>>>> mkfs.xfs -f image.img
>>>>> mkdir mnt
>>>>> mount -o loop ./image.img mnt
>>>>> fallocate -o 0 -l 700mb mnt/image.img
>>>>> fallocate -o 0 -l 700mb mnt/image.img
>>>>>
>>>>> Why does the second fallocate fail with ENOSPC, and is that considered an XFS bug?
>>>>
>>>> Interesting.  Off the top of my head, I assume that xfs is not looking at
>>>> current file space usage when deciding how much is needed to satisfy the
>>>> fallocate request.  While filesystems can return ENOSPC at any time for
>>>> any reason, this does seem a bit suboptimal.
>>>
>>> Yes, I would have thought the second fallocate should be a noop.
>>
>> On further reflection, "filesystems can return ENOSPC at any time" is
>> certainly something apps need to be prepared for (and in this case, it's
>> doing the right thing, by logging the error and aborting), but it's not
>> really a "not a bug" excuse for the filesystem in all circumstances (or this
>> one?), is it? E.g. a write(fd, buf, 1) returning ENOSPC on an fresh
>> filesystem would be considered a bug, no?
>
> Sure, but the fallocate case here is different. You're asking to
> preallocate up to 700MB of space on a filesystem that only has 300MB
> of space free. Up front, without knowing anything about the layout
> of the file we might need to allocate 700MB of space into, there's a
> very good chance that we'll get ENOSPC partially through the
> operation.

But I'm not asking for more space - the space is already there:

$ filefrag -v mnt/image.img 
Filesystem type is: ef53
File size of mnt/image.img is 700000000 (170899 blocks of 4096 bytes)
  ext:     logical_offset:        physical_offset: length:   expected: flags:
    0:        0..   30719:      34816..     65535:  30720:             unwritten
    1:    30720..   59391:      69632..     98303:  28672:      65536: unwritten
    2:    59392..  122879:     100352..    163839:  63488:      98304: unwritten
    3:   122880..  170898:     165888..    213906:  48019:     163840: last,unwritten,eof
mnt/image.img: 4 extents found

I.e. the fallocate /could/ potentially look at the existing file and 
say "nothing for me do to here".

Of course, that should be pretty easy and quick in this case - but for 
a file with hundereds of thousands of extents and potential holes in 
the midst it would be somewhat less quick and easy. So that's probably 
a good reason for it to fail. Sigh. On the other hand that might be a 
case of "play stupid games, win stupid prizes". On the gripping hand I 
can imagine the emails to the mailing list from people like me asking 
why their "simple" fallocate is taking 20 minutes...

>>>>> Background: I'm chasing a mysterious ENOSPC error on an XFS
>>>>> filesystem with way more space than the app should be asking
>>>>> for. There are no quotas on the fs. Unfortunately it's a third
>>>>> party app and I can't tell what sequence is producing the error,
>>>>> but this fallocate issue is a possibility.
>
> More likely speculative preallocation is causing this than
> fallocate. However, we've had a background worker that cleans up
> speculative prealloc before reporting ENOSPC for a while now - what
> kernel version are seeing this on?

5.10.60. How long is "a while now"? I vaguely recall something about 
that going through.

> Also, it might not even be data allocation that is the issue - if
> the filesystem is full and free space is fragmented, you could be
> getting ENOSPC because inodes cannot be allocated. In which case,
> the output of xfs-info would be useful so we can see if sparse inode
> clusters are enabled or not....

$ xfs_info /chroot
meta-data=/dev/mapper/vg00-chroot isize=512    agcount=32, agsize=244184192 blks
          =                       sectsz=4096  attr=2, projid32bit=1
          =                       crc=1        finobt=1, sparse=1, rmapbt=1
          =                       reflink=1    bigtime=0 inobtcount=0
data     =                       bsize=4096   blocks=7813893120, imaxpct=5
          =                       sunit=128    swidth=512 blks
naming   =version 2              bsize=4096   ascii-ci=0, ftype=1
log      =internal log           bsize=4096   blocks=521728, version=2
          =                       sectsz=4096  sunit=1 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0

It's currently fuller than I like:

$ df /chroot
Filesystem                1K-blocks        Used  Available Use% Mounted on
/dev/mapper/vg00-chroot 31253485568 24541378460 6712107108  79% /chroot

...so that's 6.3T free, but this problem was happening with 71% (8.5T) 
free. The /maximum/ the app could conceivably be asking for is around 
1.1T (to entirely duplicate an existing file), but it really shouldn't 
be doing anywhere near that: I can see it doing write-in-place on the 
existing file and should be asking for modest amounts of extention 
(then again, userland developers, so who knows, right? ;-}).

Oh, another reference: this is extensive reflinking happening on this 
filesystem. I don't know if that's a factor. You may remember my 
previous email relating to that:

Extreme fragmentation ho!
https://www.spinics.net/lists/linux-xfs/msg47707.html

I'm excited by my new stracing script prompted by Eric - at least that 
should tell us what precisely is failing. Shame I'm going to have to 
wait a while for it to trigger.


Cheers,

Chris
