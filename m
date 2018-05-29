Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:43816 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S936853AbeE2RAu (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 29 May 2018 13:00:50 -0400
Subject: Re: Temporary drive failure leads to massive data corruption?
References: <CAKGkouuK6Dz82JBx2s8cccC-ST_enhF3jyVCHr+w=O_-QeppRw@mail.gmail.com>
 <1b397e88-0e1f-5f33-7def-a38a4a1e484a@sandeen.net>
 <8636yav20g.fsf@self-evident.org>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <6169654a-7f46-5fb7-492a-56356c4d2fca@sandeen.net>
Date: Tue, 29 May 2018 12:00:49 -0500
MIME-Version: 1.0
In-Reply-To: <8636yav20g.fsf@self-evident.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Patrick J. LoPresti" <lopresti@gmail.com>
Cc: linux-xfs@vger.kernel.org

On 5/29/18 11:51 AM, Patrick J. LoPresti wrote:
>> On a more concrete note, it would be interestting to run xfs_bmap -vv
>> on some of those files with zeros and see what extents, if any, cover
>> the zeroed ranges.  i.e. are they holes, allocated, unwritten, etc.
> I tried this on a few of the damaged files. Here is a typical output:
> 
> # xfs_bmap -p -v xxx
>      xxx:
>     EXT: FILE-OFFSET      BLOCK-RANGE                 AG  AG-OFFSET  TOTAL FLAGS
>       0: [0..16255]:      195467240568..195467256823  91  (46229328..46245583)  16256 00000
>       1: [16256..715959]: 195477629880..195478329583  91  (56618640..57318343) 699704 00000
> 
> Looking at the "zeroed" data ranges (there are several), none of them
> are near the beginning nor end of either extent.
> 
> None of the files I looked at had FLAGS other than 00000.

Ok, so flags with 00000 mean "this is a normal, allocated, written extent"
and nothing fancy like preallocated/unwritten - and they aren't holes either.
  
> All of the zeroed ranges I checked are page-aligned (4K multiple).
> 
> It really feels like some small amount of damage in one area of the file
> system got amplified into corruption across many files' contents by
> xfs_repair.
> 
> I do not know much about XFS internals, so forgive me if the following
> is stupid... I imagine there are global data structures recording the
> free/in-use blocks, as well as local data structures recording the
> extents used by each file. Is it possible xfs_repair decided to "trust"
> some corrupted global data structure instead of the local extents
> associated with each file, and responded by wiping parts of the latter?
> 
> In general, could anything cause xfs_repair to zero out whole ranges of
> blocks allocated to many files?

Others may think of a scenario I'm missing, but xfs_repair simply does
not touch the contents of file data blocks.  It might truncate some away,
or remove entire extents from a file, or even junk an inode that looks
irredeemable, but it will never go in and zero out data in file blocks.
That's what leads me to think that there's something else happening on
the storage side of things.

Did you keep the xfs_repair output?  It would be interesting to correlate
the inodes w/ missing data to anything repair might have touched, I guess.

-Eric
