Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from out1.mail.ruhr-uni-bochum.de ([134.147.53.149]:45447 "EHLO
        out1.mail.ruhr-uni-bochum.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752304AbeENXpi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 14 May 2018 19:45:38 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
Date: Tue, 15 May 2018 01:37:32 +0200
From: Tarik Ceylan <Tarik.Ceylan@ruhr-uni-bochum.de>
Subject: Re: How to reliably measure fs usage with reflinks enabled?
In-Reply-To: <20180514225751.GB10363@dastard>
References: <5398ddaf2b876c3563bc1c2927bfe1b9@ruhr-uni-bochum.de>
 <866a5e96-e900-d330-0efb-6413f85f86a3@sandeen.net>
 <20180514225751.GB10363@dastard>
Message-ID: <b2fe69d6216f165b2c84ca5a377d06ab@ruhr-uni-bochum.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org, sandeen@sandeen.net

Am 2018-05-15 00:57, schrieb Dave Chinner:
> On Mon, May 14, 2018 at 05:02:53PM -0500, Eric Sandeen wrote:
>> 
>> 
>> On 5/14/18 3:02 PM, Tarik Ceylan wrote:
>> > How can one reliably measure filesystem usage on partitions that were compiled with -m reflink=1 ?
>> > Here are some numbers i am measuring with df -h (on different partitions holding the same data):
>> > 7.7G of 36G  (-b size=512  -m crc=0 )
>> > 8.6G of 36G  (-b size=4096 -m crc=1 )
>> 
>> 8x larger inodes will take 8x more space, but you didn't say how many
>> inodes you have allocated.
>> 
>> > 11G  of 36G  (-b size=1024 -m crc=1,reflink=1,rmapbt=1 -i sparse=1 )
>> > 32G  of 864G (-b size=4096 -m crc=1,reflink=1 )
>> 
>> In that last case, you have a wildly different total fs size, so 
>> probably
>> no fair comparison here either.
>> 
>> The reverse mapping btree also takes up space.  You're turning too 
>> many
>> knobs at once.  ;)

Thanks,
here's a test in which i only compare reflink=0 to reflink=1, all other
variables being the same:

mkfs.xfs -f -m reflink=0 /dev/sdc4
meta-data=/dev/sdc4              isize=512    agcount=4, agsize=58687982 
blks
          =                       sectsz=512   attr=2, projid32bit=1
          =                       crc=1        finobt=1, sparse=0, 
rmapbt=0, reflink=0
data     =                       bsize=4096   blocks=234751926, 
imaxpct=25
          =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0 ftype=1
log      =internal log           bsize=4096   blocks=114624, version=2
          =                       sectsz=512   sunit=0 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0

"df -h" shows a usage of 8.8G of 896G

mkfs.xfs -f -m reflink=1 /dev/sdc4
[output same as before except the reflink parameter]
15G of 896G

> 
> Also, we reserve a lot of space for reflink/rmapbt metadata that
> isn't actually used, so you're not actually using any more space
> than the "-b size=4096 -m crc=1" case. I have plans for hiding that
> reservation from users so that we don't get questions like this....

That should resolve my confusion. Sorry to have bothered, but it's kind 
of
an obvious question.
To get back to my original question - can i assume  "df" to be a 
reliable
way of measuring fs usage going forward (after the change you mention),
or will specialized tools be necessary as is the case with btrfs?

Tarik

> 
> Cheers,
> 
> Dave.
