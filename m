Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 24 Sep 2007 21:41:21 -0700 (PDT)
Received: from sandeen.net (sandeen.net [209.173.210.139])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l8P4fDQ3019986
	for <xfs@oss.sgi.com>; Mon, 24 Sep 2007 21:41:18 -0700
Message-ID: <46F8916D.7000900@sandeen.net>
Date: Mon, 24 Sep 2007 23:41:17 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: something very strange w/ filestreams...
References: <46F49C80.60007@sandeen.net> <20070923092444.GQ995458@sgi.com> <op.ty4867zj3jf8g2@pc-bnaujok.melbourne.sgi.com> <46F7B04D.70809@sandeen.net> <op.ty6ofbsm3jf8g2@pc-bnaujok.melbourne.sgi.com> <46F8654B.9010203@sandeen.net>
In-Reply-To: <46F8654B.9010203@sandeen.net>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Barry Naujok <bnaujok@sgi.com>
Cc: David Chinner <dgc@sgi.com>, xfs-oss <xfs@oss.sgi.com>

Eric Sandeen wrote:
> Barry Naujok wrote:
> 
>>>> So, before running this test, you should make sure your test
>>>> partitions are completely zeroed from mkfs's that occurred
>>>> before that recent version of mkfs.xfs was installed.
>>> I dd'd over the whole test partition, ran the sequence, and hit the  
>>> problem.
>> Yeah, worked it out yesterday but never got around to doing another
>> email. It's a combination of the two filestreams tests which do
>> small filesystems and mkfs.xfs doesn't wipe beyond the new
>> filesystem size. Zero the disk, try the attached patch and see
>> if that fixes the problem.
>>
>> Barry.
> 
> Ok, but what about that double free?
> 
> -Eric
> 
> 
I have a bit of a clue about what's going wrong.

first we get the buffer zone allocated:

new zone 0x80efd68 for "xfs_buffer", size=116

set a watchpoint on that, also break on setup_bmap:

(gdb) watch *((int *)0x80efd68)
Hardware watchpoint 1: *(int *) 135200104
(gdb) break setup_bmap
(gdb) cont

ba_bmap gets allocated, based on some particular sb_agblocks count at
the time:

	setup_bmap(agcount, mp->m_sb.sb_agblocks, mp->m_sb.sb_rextents);

on this filesystem it's 4096 at this point, like so:

Breakpoint 3, setup_bmap (agno=64, numblocks=4096, rtblocks=0) at
incore.c:59

and from some debugging the size of ba_bmap[i] ends up as 2048:

...
ba_bmap[31] at 0x80edc58 size 2048
ba_bmap[32] at 0x80ee460 size 2048
ba_bmap[33] at 0x80eec68 size 2048
...

so I set a watch on the zone that ends up corrupted, and:

Hardware watchpoint 4: *(int *) 135200104

Old value = 116
New value = 372
0x08063a2f in set_agbno_state (mp=0xbf999188, agno=32, ag_blockno=12818,
state=1) at incore.c:278
278             *addr = (((*addr) &
(gdb) bt
#0  0x08063a2f in set_agbno_state (mp=0xbf999188, agno=32,
ag_blockno=12818, state=1) at incore.c:278
#1  0x0807d752 in scanfunc_bno (ablock=0x8187200, level=0, bno=1,
agno=32, suspect=0, isroot=1)
    at scan.c:548
#2  0x0807c017 in scan_sbtree (root=1, nlevels=1, agno=32, suspect=0,
func=0x807d430 <scanfunc_bno>,
    isroot=1) at scan.c:66
#3  0x0807d19a in scan_ag (agno=32) at ../include/xfs/swab.h:126
#4  0x0806751b in phase2 (mp=0xbf999188) at phase2.c:148
#5  0x08080d77 in main (argc=Cannot access memory at address 0x8
) at xfs_repair.c:619

so at this point it looks like we're trying to use an ag_blockno of
12818, when we only allocated based on expecting 4096 blocks per ag?  So
I guess we've stumbled across another piece of the older, larger
filesystem and those values cause us to walk off the end of the ba_map
array?

Not sure where it goes from here, but bedtime for me. :)

-Eric
