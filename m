Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 18 Feb 2008 17:36:38 -0800 (PST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m1J1aVgW018552
	for <xfs@oss.sgi.com>; Mon, 18 Feb 2008 17:36:33 -0800
Message-ID: <47BA2AFD.2060409@tlinx.org>
Date: Mon, 18 Feb 2008 17:03:57 -0800
From: Linda Walsh <xfs@tlinx.org>
MIME-Version: 1.0
Subject: Re: tuning, many small files, small blocksize
References: <e03b90ae0802152101t2bfa4644kcca5d6329239f9ff@mail.gmail.com> <47BA10EC.3090004@tlinx.org> <20080218235103.GW155407@sgi.com>
In-Reply-To: <20080218235103.GW155407@sgi.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: Jeff Breidenbach <jeff@jab.org>, xfs@oss.sgi.com

David Chinner wrote:
> That makes no sense. Inodes are *unique* - they are not shared with
> any other inode at all. Could you explain why you think that 256
> byte inodes are any different to larger inodes in this respect?
---
	Sorry to be unclear, but it would seem to me that if the
minimum physical blocksize on disk is 512 bytes, then either a 256
byte inode will share that block with another inode, or you are
wasting 256 bytes on each inode.  The latter interpretation doesn't
make logical sense.

	If the minimum physical I/O size is larger than 512 bytes,
then I would assume even more, *unique*, inodes could be packed
in per block.

> 
>> Remember, in xfs, if the last bit of left-over data in an inode will fit
>> into the inode, it can save a block-allocation, though I don't know
>> how this will affect speed.
> 
> No, that's wrong. We never put data in inodes.
---
	You mean file data, no?  Doesn't directory and link data
get packed in?  It always gnawed at me, as to why inode's packing
in small bits of data was disallowed for file data, but not
other types of data.  How about extended attribute data?  Is
it always allocated in separate data blocks as well, or can it
be fit into an inode if it fits?  Why not include file data as
a type of data that could be packed into an inode?  I'm sure there's
a good reason, but it seems other types of file system data can
be packed into inodes -- just not file data...or am I really
disinformed? :-)


> 
>> Space-wise, a 2k block size and 1k-inode size might be good, but don't
>> know how that would affect performance.
> 
> Inode size vs block size is pretty much irrelevant w.r.t performance,
> except for the fact inode size can't be larger than the block size.
----
	If you have a small directory, can't it be stored in the inode?
Wouldn't that save some bit (or block) of I/O?

>> I'm sure you are familiar with mount options noatime,nodiratime -- same
>> concepts, but dir's are split out.
> 
> noatime implies nodiratime.
----
	Well dang...thanks!  Ever since the nodiratime option came out,
I thought I had to specify it in addition.  Now my fstabs can be
shorter!

>> Also, it depends on the situation, but sometimes flattening out the
>> directory structure can speed up lookup time.
> 
> Like using large directory block sizes to make large directory
> btrees wider and flatter and therefore use less seeks for any given
> random directory lookup? ;)
---
	Are you saying that directory entries are stored in a sorted
order in a B-Tree?  Hmmm...
Well, I did say it depended on the situation -- you are right
that time lost to seeks might overshadow time lost to #blocks read
in, I'd think it might depend on how the directories are laid out
on disk, but in benchmarks, I've noticed larger slowdowns when using
more files/dir, than distributing the same number of files among
more dirs, but it could have been something about my test setup,
but I did not test with varying size directory block sizes.
Either I overlooked the naming option size param or was
limited to version=1 for some reason (don't remember when version=2
was added...)

> 
>> Sometime back someone did some benchmarks involving log size and it seemed
>> that 32768b(4k) or ~128Meg seemed optimal if memory serves me correctly.
> 
> 128MB is the maximum size currently.
---
	Maybe that's why it's optimal?  :-)

	Thanks for the corrections...I appreciate it!

-l
