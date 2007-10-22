Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 22 Oct 2007 04:16:29 -0700 (PDT)
Received: from lucidpixels.com (lucidpixels.com [75.144.35.66])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with ESMTP id l9MBGKNE017535
	for <xfs@oss.sgi.com>; Mon, 22 Oct 2007 04:16:24 -0700
Date: Mon, 22 Oct 2007 07:16:23 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: mount: /dev/md0: can't read superblock
In-Reply-To: <6e0c99d0710212047r684d90d5wc6c0a009e0568edd@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0710220716040.7523@p34.internal.lan>
References: <6e0c99d0710201802v2f41577dv38281b936a2389bf@mail.gmail.com>
 <471BEDCD.3040104@sandeen.net> <20071022005258.GX995458@sgi.com>
 <6e0c99d0710212047r684d90d5wc6c0a009e0568edd@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Greg Martyn <greg.martyn@gmail.com>
Cc: David Chinner <dgc@sgi.com>, Eric Sandeen <sandeen@sandeen.net>, xfs@oss.sgi.com

I degragment many arrays (sw raid) and single disks without any problems, 
not sure what your issue was.

On Sun, 21 Oct 2007, Greg Martyn wrote:

> Thank you Eric and David. xfs_repair repaired the filesystem. I forgot
> to save the output of xfs_fsr (in case you were curious about what
> went wrong), but everything seems to be working fine again.
>
> I just won't be defragging again any time soon ;-)
>
> Thanks,
> greg
>
> On 10/21/07, David Chinner <dgc@sgi.com> wrote:
>> On Sun, Oct 21, 2007 at 07:24:45PM -0500, Eric Sandeen wrote:
>>> Greg Martyn wrote:
>>>> Hi all,
>>>> After running "xfs_fsr -v /home", I got a bunch of error messages
>>>> saying that certain files (/home/.[three letters that i forgot])
>>>> couldn't be removed. After that, my system stopped working properly,
>>>> so I restarted. Now:
>>>>
>>>> [root@localhost ~]# mount /dev/md0 /home/
>>>> mount: /dev/md0: can't read superblock
>>>>
>>>> uh oh.
>>>
>>> dmesg says it's corrupted.
>>>
>>> You should probably run repair on it.  But being raid, if something went
>>> wrong w/ the raid, that could make it worse... run xfs_repair -n and see
>>> what it *would* fix.
>>
>> xfs_repair does not check everything in the filesystem - some things it
>> simply rebuilds - like the free space btrees. you want to run xfs_check
>> to determine if the free space btrees are corrupt on disk or not.... ;)
>>
>> Cheers,
>>
>> Dave.
>> --
>> Dave Chinner
>> Principal Engineer
>> SGI Australian Software Group
>>
>
>
