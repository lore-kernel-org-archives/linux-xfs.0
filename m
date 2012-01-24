Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q0O54IJw192337 for <xfs@oss.sgi.com>; Mon, 23 Jan 2012 23:04:18 -0600
Received: from mail.sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com
	with ESMTP id Kl9al8O2x9YM85kw for <xfs@oss.sgi.com>;
	Mon, 23 Jan 2012 21:04:16 -0800 (PST)
Message-ID: <4F1E3BD0.7080604@sandeen.net>
Date: Mon, 23 Jan 2012 23:04:16 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: How to fix bad superblock or xfs_repair: error - read only 0
	of 512 bytes
References: <CALx8gnT9tdPRGfVR0puoSVYz_MDDs4FtWtodST5x29GDnL3A_w@mail.gmail.com>
	<20120123043117.GH15102@dastard>
	<92CDAC52-1BA1-43A8-8470-0E2DCD916610@unixhosts.org>
In-Reply-To: <92CDAC52-1BA1-43A8-8470-0E2DCD916610@unixhosts.org>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Christian Kildau <lists@unixhosts.org>
Cc: xfs@oss.sgi.com

On 1/23/12 3:23 AM, Christian Kildau wrote:
> On Jan 23, 2012, at 5:31 AM, Dave Chinner wrote:
> 
>> On Sat, Jan 21, 2012 at 11:29:15AM +0100, Christian Kildau wrote:
>>> Sorry if this message appears twice!
>>>

Argh.  ;)

>>>
>>> Hello,
>>>
>>> I'm having some very serious issues with XFS after upgrading from a
>>> Linux Distro running Ubuntu 2.6.32 to 3.2.
>>>
>>> It seems like my filesystems are damaged after attaching them to a
>>> Linux 3.2 server. I am also no longer able to mount the hdd on the old
>>> server that is still running 2.6.32!
>>
>> I take it that you are using external storage of some kind? Can you
>> describe it?
> 
> This hdd is connected via e-sata, but it doesn't make any difference if I directly connect it internally via sata.
> Also it doesn't make any difference if I connect it back to the 'old' server
> 
>>
>>> (I created the xfs filesystem on the entire hdd, not on a partition,
>>> so /dev/sdd is not a typo)

I wonder if your installer helpfully scribbled something on it since it
had no partitions (which should be safe, but there are dumb apps out there).

>>> $ sudo mount -t xfs /dev/sdd /media/
>>> mount: /dev/sdd: can't read superblock
>>> (dmesg)
>>> [236659.912663] attempt to access beyond end of device
>>> [236659.912667] sdd: rw=32, want=2930277168, limit=2930275055
>>> [236659.912670] XFS (sdd): last sector read failed
>>
>> So XFS has asked to read 2113 sectors beyond the size of the device
>> that the kernel is reporting. What is the output of
>> /proc/partitions?
> 
> $ grep sdd /proc/partitions 
>    8       64 1465137527 sdd

so 1465137527*1024 = 1500300827648 bytes

>From the strace repair is trying to read at:

pread(4, "", 512, 1500301909504)        = 0

which is about 1 meg past the end of the device.

>>
>>> $ sudo xfs_check /dev/sdd
>>> xfs_check: error - read only 0 of 512 bytes
>>>
>>> $ sudo xfs_repair /dev/sdd
>>> Phase 1 - find and verify superblock...
>>> xfs_repair: error - read only 0 of 512 bytes
>>
>> So both buffered and direct IO to the first block in the block
>> device are failing. I'd say your problems have nothing to do with
>> XFS. However, can you strace them and find out what the error that
>> is occuring actually is?
> 
> Strace is giving me:
> wait4(-1, xfs_check: /dev/sdd is not a valid XFS filesystem (unexpected SB magic number 0x00000000)

now that is something else...

> xfs_check: WARNING - filesystem uses v1 dirs,limited functionality provided.
> xfs_check: read failed: Invalid argument
> cache_node_purge: refcount was 1, not zero (node=0x21ecef0)
> xfs_check: cannot read root inode (22)
> bad superblock magic number 0, giving up

those are different failures than first reported....

xfs_db -c "sb 0" -c "p" /dev/sdd still might be interesting.

-Eric

> I attached the entire strace logs to this email.
> 
> 
> 
> 
> 
> Do you have any idea what has caused this or how to fix it?
> 
> Thanks in advance!
> Chris
> 
> 
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
