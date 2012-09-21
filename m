Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q8LG5tgP228561 for <xfs@oss.sgi.com>; Fri, 21 Sep 2012 11:05:55 -0500
Received: from mail.sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com
	with ESMTP id jdC82A1872U2EeTk for <xfs@oss.sgi.com>;
	Fri, 21 Sep 2012 09:07:08 -0700 (PDT)
Message-ID: <505C90A6.90103@sandeen.net>
Date: Fri, 21 Sep 2012 11:07:02 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: xfs_repair deleting realtime files.
References: <CAHt31_9K_vrzoqwSVsz-6VNVmMUzMyGCFEZfviRV-xPcUqv8-w@mail.gmail.com>
	<505BF45D.5050909@sandeen.net>
	<CAHt31__x6VbmO-8GJvPesKEXXmRGEfYt-TeRk-9GFJt1HjPPvA@mail.gmail.com>
In-Reply-To: <CAHt31__x6VbmO-8GJvPesKEXXmRGEfYt-TeRk-9GFJt1HjPPvA@mail.gmail.com>
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
To: Anand Tiwari <tiwarikanand@gmail.com>
Cc: xfs@oss.sgi.com

On 9/21/12 10:51 AM, Anand Tiwari wrote:
> 
> 
> On Thu, Sep 20, 2012 at 11:00 PM, Eric Sandeen <sandeen@sandeen.net
> <mailto:sandeen@sandeen.net>> wrote:
> 
> On 9/20/12 7:40 PM, Anand Tiwari wrote:
>> Hi All,
>> 
>> I have been looking into an issue with xfs_repair with realtime sub
>> volume. some times while running xfs_repair I see following errors
>> 
>> ---------------------------- data fork in rt inode 134 claims used
>> rt block 19607 bad data fork in inode 134 would have cleared inode
>> 134 data fork in rt inode 135 claims used rt block 29607 bad data
>> fork in inode 135 would have cleared inode 135 - agno = 1 - agno =
>> 2 - agno = 3 - process newly discovered inodes... Phase 4 - check
>> for duplicate blocks... - setting up duplicate extent list... -
>> check for inodes claiming duplicate blocks... - agno = 0 - agno =
>> 1 - agno = 2 - agno = 3 entry "test-011" in shortform directory 128
>> references free inode 134 would have junked entry "test-011" in
>> directory inode 128 entry "test-0" in shortform directory 128
>> references free inode 135 would have junked entry "test-0" in
>> directory inode 128 data fork in rt ino 134 claims dup rt
>> extent,off - 0, start - 7942144, count 2097000 bad data fork in
>> inode 134 would have cleared inode 134 data fork in rt ino 135
>> claims dup rt extent,off - 0, start - 13062144, count 2097000 bad
>> data fork in inode 135 would have cleared inode 135 No modify flag
>> set, skipping phase 5 ------------------------
>> 
>> Here is the bmap for both inodes.
>> 
>> xfs_db> inode 135 xfs_db> bmap data offset 0 startblock 13062144
>> (12/479232) count 2097000 flag 0 data offset 2097000 startblock
>> 15159144 (14/479080) count 2097000 flag 0 data offset 4194000
>> startblock 17256144 (16/478928) count 2097000 flag 0 data offset
>> 6291000 startblock 19353144 (18/478776) count 2097000 flag 0 data
>> offset 8388000 startblock 21450144 (20/478624) count 2097000 flag
>> 0 data offset 10485000 startblock 23547144 (22/478472) count
>> 2097000 flag 0 data offset 12582000 startblock 25644144 (24/478320)
>> count 2097000 flag 0 data offset 14679000 startblock 27741144
>> (26/478168) count 2097000 flag 0 data offset 16776000 startblock
>> 29838144 (28/478016) count 2097000 flag 0 data offset 18873000
>> startblock 31935144 (30/477864) count 1607000 flag 0 xfs_db> inode
>> 134 xfs_db> bmap data offset 0 startblock 7942144 (7/602112) count
>> 2097000 flag 0 data offset 2097000 startblock 10039144 (9/601960)
>> count 2097000 flag 0 data offset 4194000 startblock 12136144
>> (11/601808) count 926000 flag 0
> 
> It's been a while since I thought about realtime, but -
> 
> That all seems fine, I don't see anything overlapping there, they
> are all perfectly adjacent, though of interesting size.
> 
>> 
>> by looking into xfs_repair code, it looks like repair does not
>> handle a case where we have more than one extent in a real-time
>> extent. following is code from repair/dinode.c: process_rt_rec
> 
> "more than one extent in a real-time extent?"  I'm not sure what that
> means.
> 
> Every extent above is length 2097000 blocks, and they are adjacent. 
> But you say your realtime extent size is 512 blocks ... which doesn't
> go into 2097000 evenly.   So that's odd, at least.
> 
> 
> well, lets look at first extent
>> data offset 0 startblock 13062144 (12/479232) count 2097000 flag 0 
>> data offset 2097000 startblock 15159144 (14/479080) count 2097000
>> flag 0
> startblock is aligned and rtext is 25512,  since the blockcount is
> not multiple of 512, last realtime extent ( 25512 + 4095) is
> partially used, 360 blks second extent start from realtime extent
> 29607 (ie 25512 + 4095).  so, yes, extents are not overlapping, but
> 29607 realtime extent is shared by two extents. Now once xfs_repair
> detects this case in phase 2, it bails out and clears that inode. I
> think  search for duplicate extent is done in phase 4, but inode is
> marked already.

... ok I realize I was misunderstanding some things about the realtime
volume.  (It's been a very long time since I thought about it).  Still,
I'd like to look at the metadump image if possible.

Thanks,
-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
