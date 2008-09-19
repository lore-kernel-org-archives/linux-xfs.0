Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 18 Sep 2008 17:49:06 -0700 (PDT)
Received: from relay.sgi.com (relay2.corp.sgi.com [192.26.58.22])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m8J0n4fG004065
	for <xfs@oss.sgi.com>; Thu, 18 Sep 2008 17:49:04 -0700
Message-ID: <48D2F95F.8040006@sgi.com>
Date: Fri, 19 Sep 2008 10:59:11 +1000
From: Lachlan McIlroy <lachlan@sgi.com>
Reply-To: lachlan@sgi.com
MIME-Version: 1.0
Subject: Re: REVIEW: Fix for incore extent corruption.
References: <48D19A83.4040608@thebarn.com> <48D1CD46.4010104@sgi.com>    <48D1DCD5.7040502@thebarn.com> <48D218AE.9090400@sgi.com>    <59243.131.252.241.230.1221762601.squirrel@sandeen.net> <59751.131.252.241.230.1221766138.squirrel@sandeen.net>
In-Reply-To: <59751.131.252.241.230.1221766138.squirrel@sandeen.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Russell Cattelan <cattelan@thebarn.com>, xfs@oss.sgi.com

Eric Sandeen wrote:
> Eric Sandeen wrote:
>> Lachlan McIlroy wrote:
>>> Russell, this fixes xfs_iext_irec_compact_full().  If we don't move
>>> all the records from the next page into the current page then we need
>>> to update the er_extoff of the modified page as we move the remaining
>>> extents up.  Would you mind giving it a go?
>>>
>>> --- a/fs/xfs/xfs_inode.c	2008-09-18 18:48:46.000000000 +1000
>>> +++ b/fs/xfs/xfs_inode.c	2008-09-18 18:57:18.000000000 +1000
>>> @@ -4623,6 +4623,7 @@ xfs_iext_irec_compact_full(
>>>  					(XFS_LINEAR_EXTS -
>>>  						erp_next->er_extcount) *
>>>  					sizeof(xfs_bmbt_rec_t));
>>> +				erp_next->er_extoff += ext_diff;
>>>  			}
>>>  		}
>> Lachlan, I concur.  I spent way too long last night looking at this and
>> arrived at the same conclusion about the root cause of the problem, but
>> didn't hae *quite* the right solution.  I blame it on 2am ;)  Your fix
>> looks right.
> 
> FWIW; some supporting information from debugging etc.
> 
> xfs_iext_irec_compact_full:
> 
> Move 1 item from BUF2 into BUF1, and compact BUF2
> 
>                          copy                memmove/zero
>          BUF1    BUF2    --->   BUF1     BUF2    --->    BUF1    BUF2
>         +-----+ +-----+         +-----+ +-----+         +-----+ +-----+
>         |  0  | |  3  |         |  0  | |     |         |  0  | |  4  |
>         +-----+ +-----+         +-----+ +-----+         +-----+ +-----+
>         |  1  | |  4  |         |  1  | |  4  |         |  1  | |     |
>         +-----+ +-----+         +-----+ +-----+         +-----+ +-----+
>         |  2  | |     |         |  2  | |     |         |  2  | |     |
>         +-----+ +-----+         +-----+ +-----+         +-----+ +-----+
>         |     | |     |         |  3  | |     |         |  3  | |     |
>         +-----+ +-----+         +-----+ +-----+         +-----+ +-----+
> er_count   3       2                                       4       1
> er_offset  0       3                                       0       4
> 
> If we don't update er_offset properly in BUF2, then a lookup for extent
> index 3 may find the first one in BUF2, not the last one in BUF1 (both
> claim to be "extent index 3"
> 
>>From some tracing when I hit this path:
> 
> ...
> 250: ffff810065c61fa0 startoff 251 startblock 263 blockcount 1 flag 1
> 251: ffff810065c61fb0 startoff 252 startblock NULLSTARTBLOCK(5) blockcount
> 1 flag 0
> 252: ffff810065c61fc0 startoff 253 startblock 265 blockcount 1 flag 1
> 253: ffff810065c61fd0 startoff 254 startblock NULLSTARTBLOCK(5) blockcount
> 1 flag 0
> 254: ffff810065c90000 startoff 255 startblock 267 blockcount 1 flag 1
> 255: ffff810065c90010 startoff 256 startblock NULLSTARTBLOCK(5) blockcount
> 1 flag 0
> 256: ffff810065c90020 startoff 257 startblock 269 blockcount 1 flag 1
> 257: ffff810065c90030 startoff 258 startblock NULLSTARTBLOCK(5) blockcount
> 1 flag 0
> 258: ffff810065c90040 startoff 259 startblock 271 blockcount 1 flag 1
> 259: ffff810065c90050 startoff 260 startblock NULLSTARTBLOCK(5) blockcount
> 1 flag 0
> ...
> 
> move enough to fill the previous page:
> copy 2 (32) from ffff810065c90000 to ffff810065c61fe0
> 
> next page is not empty, so shift up:
> 
> move 254 (4064) from ffff810065c90020 to ffff810065c90000
> 
> But then I ran through the entire extent list for all indexes in order, and:
> 
> 250: ffff810065c61fa0 startoff 251 startblock 263 blockcount 1 flag 1
> 251: ffff810065c61fb0 startoff 252 startblock NULLSTARTBLOCK(5) blockcount
> 1 flag 0
> 252: ffff810065c61fc0 startoff 253 startblock 265 blockcount 1 flag 1
> 253: ffff810065c61fd0 startoff 254 startblock NULLSTARTBLOCK(5) blockcount
> 1 flag 0
> --- XXX where are starting offsets 255, 256 XXX ---
> 254: ffff810065c90000 startoff 257 startblock 269 blockcount 1 flag 1
> 255: ffff810065c90010 startoff 258 startblock NULLSTARTBLOCK(5) blockcount
> 1 flag 0
> 256: ffff810065c90020 startoff 259 startblock 271 blockcount 1 flag 1
> 
> starting *offsets* 255, 256 are lost because the next buffer was still
> claiming to start at extent index 254 so it essentially jumped there,
> missing the 2 extents we added to the previous buffer.
> 
> in addition, since the er_startoff for this last buffer was wrong, so was
> the last extent record - off by one, and looked at uninit'd memory:
> 
> 507: ffff810065c90fd0 startoff 510 startblock NULLSTARTBLOCK(5) blockcount
> 1 flag 0
> 508: ffff810065c92fc0 startoff 483406127300608 startblock 2014118168
> blockcount 196608 flag 0
> wtf, ext 509 out of order (1888313573376 < 483406127300608)?
> 
> hope that's more useful than confusing :)
It's very useful Eric, especially the diagram which is much easier to
understand than the squiggles on my notepad.

> 
> Anyway I really looked closely at this and I think Lachlan is spot-on.
> 
> I might even suggest proposing this and the previous fix for -stable....
Good suggestion.

> 
> -Eric
> 
> 
