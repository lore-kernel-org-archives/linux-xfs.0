Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 24 Sep 2007 05:40:52 -0700 (PDT)
Received: from sandeen.net (sandeen.net [209.173.210.139])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l8OCehQ3004100
	for <xfs@oss.sgi.com>; Mon, 24 Sep 2007 05:40:48 -0700
Message-ID: <46F7B04D.70809@sandeen.net>
Date: Mon, 24 Sep 2007 07:40:45 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: something very strange w/ filestreams...
References: <46F49C80.60007@sandeen.net> <20070923092444.GQ995458@sgi.com> <op.ty4867zj3jf8g2@pc-bnaujok.melbourne.sgi.com>
In-Reply-To: <op.ty4867zj3jf8g2@pc-bnaujok.melbourne.sgi.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Barry Naujok <bnaujok@sgi.com>
Cc: David Chinner <dgc@sgi.com>, xfs-oss <xfs@oss.sgi.com>

Barry Naujok wrote:
> On Sun, 23 Sep 2007 19:24:44 +1000, David Chinner <dgc@sgi.com> wrote:
> 
>> Barry - I think xfs_repair might be finding the incorrect superblock
>> for the repair. Tests 172, 173 and 174 use less than the whole disk,
>> so there are going to be stale superblocks all over the place....
>>
>>> hm, no zone name, length of 0x22222274?
>>>
>>> I already provided a metadump image to Barry, but I wonder why the
>>> timing(?) seems to make a difference here... first sign of things going
>>> awry in repair is:
>>>
>>> Phase 2 - using internal log
>>>         - zero log...
>>>         - scan filesystem freespace and inode maps...
>>> bad length 131072 for agf 0, should be 4096
>>> bad length # 131072 for agi 0, should be 4096
>> Yes - test 173 uses 1GB filesystem with 64x16MB AGs - 4096 * 4k block
>> size = 16MB AG. definitely looks like a stale superblock being
>> found.
>>
>> Barry, I think that the secondary superblock needs better verification
>> (e.g. that there really are AG headers where the sb says there
>> are supposed to be and all the lengths match up).
>>
>> Eric - you can relax. Filestreams is not hosing your filesystem;  
>> xfs_reapir
>> is....
> 
> Test 178 is designed to test mkfs.xfs in
> http://oss.sgi.com/archives/xfs/2007-07/msg00139.html and
> will still make xfs_repair go bananas if there is other
> old AG headers.
> 
> So, before running this test, you should make sure your test
> partitions are completely zeroed from mkfs's that occurred
> before that recent version of mkfs.xfs was installed.

I dd'd over the whole test partition, ran the sequence, and hit the problem.

> I tried on my test box and sure enough, xfs_repair barfed.
> After zeroing the devices, 172, 174 & 178 sequence succeeded.
> 
> If you have failures after the zeroing and ONLY using the
> latest mkfs.xfs then something else is wrong. Also,
> xfs_copy/xfs_mdrestore of different images could still
> trigger the problem.
> 
> There is a TODO to improve xfs_repair's handling of this
> scenario.

I do have the patch installed that you mentioned, as long as it's in 2.9.3.

but if xfs_repair is double-freeing, then something else is still wrong

-Eric
