Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:38678 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751351AbdGRCZ6 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 17 Jul 2017 22:25:58 -0400
Subject: Re: [PATCH] xfs_db: properly set inode type
References: <e6c83eea-af29-c01b-752e-e049e8fdc69f@redhat.com>
 <20170628004252.GB4492@birch.djwong.org>
 <ffd4ffc4-c4f0-4935-a785-c6af95c4d4b9@sandeen.net>
 <20170628235411.GA5874@birch.djwong.org>
 <f7050d91-0bc5-ec0a-fc3f-59a25f8855ef@sandeen.net>
 <67d06f4f-73fc-577c-a12f-132821386597@sandeen.net>
 <20170718022014.GM17762@dastard>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <e97c03e3-dd20-7b2b-3c6e-4b406150edbb@sandeen.net>
Date: Mon, 17 Jul 2017 21:25:57 -0500
MIME-Version: 1.0
In-Reply-To: <20170718022014.GM17762@dastard>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, Eric Sandeen <sandeen@redhat.com>, linux-xfs <linux-xfs@vger.kernel.org>



On 07/17/2017 09:20 PM, Dave Chinner wrote:
> On Mon, Jul 17, 2017 at 03:51:50PM -0500, Eric Sandeen wrote:
>>
>>
>> On 06/28/2017 11:01 PM, Eric Sandeen wrote:
>>>> I guess there's also the problem that if inodesize != 512 then what are
>>>> we targeting, anyway?  If inodesize = 256 then we can only hit
>>>> even-numbered inodes (not so bad) but if inodesize > 512 then do we jump
>>>> back to wherever the inode starts?  Or just give the user what they
>>>> asked for, even if it's garbage? 
>>> Oh, hum. Right, big inodes.... 
>>>
>>> So I'm trying to go from disk location to inode number, but the current
>>> disk location may not even be the start of an inode.  Hell.  Well, I'm
>>> sure I could craft a test to disallow "type inode" if the current location
>>> cannot be on an inode boundary.  But is that too clever?  Should the
>>> debug tool just do what the user asks?
>>>
>>>> (FWIW I was fine with xfs_db being dumb and giving you exactly what you
>>>> point it at, even if that makes no sense. :P)
>>> yeah, if you do "daddr 0" "type agf" it'll squawk, too, so it's fine to
>>> do the dumb user's bidding...
>>
>> So as I have it today, issuing "type inode" will actually re-align you
>> to an inode offset even if you're not on one:
>>
>> xfs_db> sb 0
>> xfs_db> addr rootino
>> xfs_db> daddr
>> current daddr is 128
>> xfs_db> daddr 129
>> xfs_db> type inode
>> xfs_db> daddr
>> current daddr is 128
>> xfs_db> 
>>
>> good? bad? indifferent? I'm thinking "bad" but we have no mechanism to
>> read a batch of inodes in xfs_db other than by passing in a legit inode number.
>>
>> And we have no mechanism to read only a /single/ inode...
>>
>> Maybe print a warning about the re-alignment and carry on?
> 
> xfs_db is meant to be a developer tool, not idiot-proof. :P
> 
> i.e. some knowledge of the layout of the metadata you are trying
> to examine is expected. I would not like xfs_db to change the daddr
> I've specified simply because I tried to parse it as the wrong
> object type....

That would be my first preference as well, but all the infrastructure
we have for gathering up an inode from a cluster is predicated on being
given an inode nr, not a daddr.  I could hack the heck out of it and refactor
it to allow clusters starting on arbitrary sectors, I guess, but I'm not
sure it's worth it.  For now it seems more useful than not to be able to
switch from a daddr to an inode (which possibly /contains/ rather than starts
at that daddr ...)

-Eric 

> Cheers,
> 
> Dave.
> 
