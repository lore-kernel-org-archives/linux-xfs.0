Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-yw0-f179.google.com ([209.85.161.179]:56360 "EHLO
        mail-yw0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751518AbdKEIzl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 5 Nov 2017 03:55:41 -0500
MIME-Version: 1.0
In-Reply-To: <59FEC912.4000005@tlinx.org>
References: <59FA4499.2030502@tlinx.org> <CAOQ4uxg-bkYnpV146kBgdbgCK9On+=jM1gCe1975J8HKkWxcNg@mail.gmail.com>
 <59FEC912.4000005@tlinx.org>
From: Amir Goldstein <amir73il@gmail.com>
Date: Sun, 5 Nov 2017 10:55:40 +0200
Message-ID: <CAOQ4uxjDbNiZiUUzNZEHTt8SQW-1trC6dSF=c28bD8EuWLWFrw@mail.gmail.com>
Subject: Re: Bug? or normal behavior? if bug, then where? overlay, vfs, xfs,
 or ????
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: L A Walsh <lkml@tlinx.org>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, linux-xfs <linux-xfs@vger.kernel.org>, Dave Chinner <david@fromorbit.com>, "Darrick J. Wong" <darrick.wong@oracle.com>

[adding cc: linux-xfs]

On Sun, Nov 5, 2017 at 10:17 AM, L A Walsh <lkml@tlinx.org> wrote:
> Amir Goldstein wrote:
>>
>>
>>
>>>
>>> I then created a new xfs file system and mounted it on '/edge';
>>>
>>>    Ishtar:/edge> xfs_info .
>>>    meta-data=/dev/Data/Edge     isize=256    agcount=32,
>>>    agsize=16777200 blks     =                   sectsz=4096  attr=2
>>>    data     =                   bsize=4096   blocks=536870400, imaxpct=5
>>>             =                   sunit=16     swidth=64 blks
>>>    naming   =version 2          bsize=4096   ascii-ci=0
>>>    log      =internal           bsize=4096   blocks=262143, version=2
>>>             =                   sectsz=4096  sunit=1 blks, lazy-count=1
>>>    realtime =none               extsz=4096   blocks=0, rtextents=0
>>>
>>>
>>
>>
>> Your problem is that you do not have "ftype" feature in directory
>> name format, like this:
>>
>> naming   =version 2              bsize=4096   ascii-ci=0 ftype=1
>>
>> Perhaps you have an old version of mkfs.xfs, not sure when
>> ftype=1 became the default format, but you can try to
>>   mkfs.xfs -n ftype=1
>>
>
> ----  Ah... no .. last I was told, if you turned on ftype=1,
> you had to also pull in crc'ing of all the meta-info.
> That has problems -- causes errors where there would be no
> problem, and was never tested on mature file systems that were
> already fragmented.
>
>
> Do you know if it was separated from crc32 -- for some inexplicable reason,
> if you wanted ftype, then the crc option would be forced on for you.
>

I don't know if there was a specific reason, but that's the way it is.

> I didn't want it as I didn't want it to flag errors in metadata that
> wasn't crucial and didn't want the speed slowdown.  Sigh.
>
> The problem on crc'ing the meta data, is that there is ALOT more meta
> data where detecting it will do more harm than good (like what nanosecond
> the file was last changed, for example).  I first ran into it
> taking the disk offline when I changed the guid on a newly formatted disk.
> That was fixed, but that was a warning shot...   How annoying.
>

I have never heard about those issues that you raise.
It sounds like a myth about XFS metadata CRC that should be debunked
so forwarding your message on to XFS list.
See also https://www.spinics.net/lists/xfs/msg19079.html

>
> From what you say, though only the upper layer needs to have the ftype=1.
> That's a new filesystem, so shouldn't make that much difference, but the
> lower fs's I'd want to use overlays with are older file systems.  But
> it sounds like those can remain as they are?
>
> (assuming they don't become upper layers in some multi-layer
> scenario)...
>

That is correct.

Amir.
