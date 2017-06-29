Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:60078 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750715AbdF2EBn (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 29 Jun 2017 00:01:43 -0400
Subject: Re: [PATCH] xfs_db: properly set inode type
References: <e6c83eea-af29-c01b-752e-e049e8fdc69f@redhat.com>
 <20170628004252.GB4492@birch.djwong.org>
 <ffd4ffc4-c4f0-4935-a785-c6af95c4d4b9@sandeen.net>
 <20170628235411.GA5874@birch.djwong.org>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <f7050d91-0bc5-ec0a-fc3f-59a25f8855ef@sandeen.net>
Date: Wed, 28 Jun 2017 23:01:42 -0500
MIME-Version: 1.0
In-Reply-To: <20170628235411.GA5874@birch.djwong.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Eric Sandeen <sandeen@redhat.com>, linux-xfs <linux-xfs@vger.kernel.org>

On 6/28/17 6:54 PM, Darrick J. Wong wrote:
> On Wed, Jun 28, 2017 at 05:45:55PM -0500, Eric Sandeen wrote:
>> On 6/27/17 7:42 PM, Darrick J. Wong wrote:
>>>> +		ino = XFS_AGINO_TO_INO(mp, xfs_daddr_to_agno(mp, b),
>>>> +			((b << BBSHIFT) >> mp->m_sb.sb_inodelog) %
>>>> +			(mp->m_sb.sb_agblocks << mp->m_sb.sb_inopblog));
>>
>>> XFS_OFFBNO_TO_AGINO(mp, xfs_daddr_to_agbno(mp, b), 0) instead of that
>>> long third argument?
>>
>> Hm, nope:
>>
>> xfs_db> inode 99
>> xfs_db> daddr
>> current daddr is 99
>>
>> xfs_db> daddr 99
>> xfs_db> type inode
>> xfs_db> inode
>> current inode number is 96
>>
>>
>> That ends up taking the first inode in the fsblock (12), not the sector
>> (99) I guess.
>>
>> The macro needs a non-zero offset into the fsblock... found by, um...
>> I'm not sure that's going to be much prettier.
>>
>> How much do you hate how I wrote it first? ;)  (I kind of hate it a
>> lot but dunno what else we have?)
> 
> I guess there's also the problem that if inodesize != 512 then what are
> we targeting, anyway?  If inodesize = 256 then we can only hit
> even-numbered inodes (not so bad) but if inodesize > 512 then do we jump
> back to wherever the inode starts?  Or just give the user what they
> asked for, even if it's garbage? 

Oh, hum. Right, big inodes.... 

So I'm trying to go from disk location to inode number, but the current
disk location may not even be the start of an inode.  Hell.  Well, I'm
sure I could craft a test to disallow "type inode" if the current location
cannot be on an inode boundary.  But is that too clever?  Should the
debug tool just do what the user asks?

> (FWIW I was fine with xfs_db being dumb and giving you exactly what you
> point it at, even if that makes no sense. :P)

yeah, if you do "daddr 0" "type agf" it'll squawk, too, so it's fine to
do the dumb user's bidding...

The difference here is that to set things up properly we need "an" inode
number.  Probably best to reject locations that cannot be the starts
of inodes, I guess, but that kind of violates the spirit of a debug tool.
Maybe we're /looking/ for misaligned inodes ...

Bleah.

-Eric



> --D
> 
>>
>> -Eric
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
