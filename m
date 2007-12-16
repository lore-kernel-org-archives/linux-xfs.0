Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 16 Dec 2007 15:47:20 -0800 (PST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id lBGNlIY4028310
	for <xfs@oss.sgi.com>; Sun, 16 Dec 2007 15:47:18 -0800
Received: from lucidpixels.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2F52F48CAD4
	for <xfs@oss.sgi.com>; Sun, 16 Dec 2007 15:47:27 -0800 (PST)
Received: from lucidpixels.com (lucidpixels.com [75.144.35.66]) by cuda.sgi.com with ESMTP id LMZvgdMbhIc0fDYG for <xfs@oss.sgi.com>; Sun, 16 Dec 2007 15:47:27 -0800 (PST)
Date: Sun, 16 Dec 2007 18:47:26 -0500 (EST)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: Fedora 8.0.1 XFS Tune on HW RAID for Max Write Throughput?
In-Reply-To: <20071216233127.GY4612@sgi.com>
Message-ID: <Pine.LNX.4.64.0712161847110.5540@p34.internal.lan>
References: <1197653927.3841.1226620089@webmail.messagingengine.com>
 <4764AB08.7040608@sandeen.net> <20071216233127.GY4612@sgi.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: Eric Sandeen <sandeen@sandeen.net>, Alex Madarasz <List.XFS@madalexlists.nospammail.net>, xfs@oss.sgi.com



On Mon, 17 Dec 2007, David Chinner wrote:

> On Sat, Dec 15, 2007 at 10:35:20PM -0600, Eric Sandeen wrote:
>> Alex Madarasz wrote:
>>> We're building a new Fedora 8.0.1 Linux system to stream data from a
>>> 250Msps ADC to disk, and want to start tuning the system configuration
>>> for maximum XFS write performance.  To date, without any significant
>>> effort at tuning our Fedora 7 dev system, we're seeing 250MBps write
>>> with 8-bit samples and ~ 300MBps write with 16-bit samples. We want to
>>> push the tuning as far as we can go with this architecture before we
>>> start looking at other hardware options.  Looking at various other
>>> tuning pages on the Web finds few that are interested in maxing out
>>> sequential writes to very large arrays while using SAS HW RAID with big
>>> fast SAS drives too.
>>
>> ...
>>
>>> XFS Tuning Options?
>>>
>>> - HW RAID0:
>>>   - Array/logical disk HW RAID stripe size?
>>
>> At any rate you'll want to match xfs's geometry with the raid geometry.
>>
>>>   - Cache enabled (some reports that cache s/b turned off?)?
>>
>> If it's battery-backed cache, leave it on, and disable barriers in xfs
>> (it's a mount option)
>>
>>>   - xfs mkfs / mount options?
>>
>> David mentioned these before as a generic place to start:
>>
>> # mkfs.xfs -f -l lazy-count=1,version=2,size=128m -i attr=2 -d agcount=4
>> <dev>
>> # mount -o logbsize=256k <dev> <mtpt>
>>
>> and that those would be upcoming new defaults for mkfs.
>>
>> 4 ags may not be what you want for a ~2T filesystem.
>
> Right - the 4 AG tuning is effectively for single disk configurations to
> limit parallelism and therefore keep seeks between AGs down. When you
> have multiple disks, the [new] mkfs defaults should be just fine (i.e.
> just drop the agcount suggestion).
>
> Cheers,
>
> Dave.
> -- 
> Dave Chinner
> Principal Engineer
> SGI Australian Software Group
>
>

Dave,

The mkfs.xfs defaults will be just fine for a HW raid device?

Justin.
