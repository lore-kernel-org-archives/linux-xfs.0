Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q8L4x0MN173752 for <xfs@oss.sgi.com>; Thu, 20 Sep 2012 23:59:01 -0500
Received: from mail.sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com
	with ESMTP id oKJ1D3u6JIoIFnWO for <xfs@oss.sgi.com>;
	Thu, 20 Sep 2012 22:00:13 -0700 (PDT)
Message-ID: <505BF45D.5050909@sandeen.net>
Date: Fri, 21 Sep 2012 00:00:13 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: xfs_repair deleting realtime files.
References: <CAHt31_9K_vrzoqwSVsz-6VNVmMUzMyGCFEZfviRV-xPcUqv8-w@mail.gmail.com>
In-Reply-To: <CAHt31_9K_vrzoqwSVsz-6VNVmMUzMyGCFEZfviRV-xPcUqv8-w@mail.gmail.com>
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

On 9/20/12 7:40 PM, Anand Tiwari wrote:
> Hi All,
> 
> I have been looking into an issue with xfs_repair with realtime sub volume. some times while running xfs_repair I see following errors
> 
> ----------------------------
> data fork in rt inode 134 claims used rt block 19607
> bad data fork in inode 134
> would have cleared inode 134
> data fork in rt inode 135 claims used rt block 29607
> bad data fork in inode 135
> would have cleared inode 135
>         - agno = 1
>         - agno = 2
>         - agno = 3
>         - process newly discovered inodes...
> Phase 4 - check for duplicate blocks...
>         - setting up duplicate extent list...
>         - check for inodes claiming duplicate blocks...
>         - agno = 0
>         - agno = 1
>         - agno = 2
>         - agno = 3
> entry "test-011" in shortform directory 128 references free inode 134
> would have junked entry "test-011" in directory inode 128
> entry "test-0" in shortform directory 128 references free inode 135
> would have junked entry "test-0" in directory inode 128
> data fork in rt ino 134 claims dup rt extent,off - 0, start - 7942144, count 2097000
> bad data fork in inode 134
> would have cleared inode 134
> data fork in rt ino 135 claims dup rt extent,off - 0, start - 13062144, count 2097000
> bad data fork in inode 135
> would have cleared inode 135
> No modify flag set, skipping phase 5
> ------------------------
> 
> Here is the bmap for both inodes.
> 
> xfs_db> inode 135
> xfs_db> bmap
> data offset 0 startblock 13062144 (12/479232) count 2097000 flag 0
> data offset 2097000 startblock 15159144 (14/479080) count 2097000 flag 0
> data offset 4194000 startblock 17256144 (16/478928) count 2097000 flag 0
> data offset 6291000 startblock 19353144 (18/478776) count 2097000 flag 0
> data offset 8388000 startblock 21450144 (20/478624) count 2097000 flag 0
> data offset 10485000 startblock 23547144 (22/478472) count 2097000 flag 0
> data offset 12582000 startblock 25644144 (24/478320) count 2097000 flag 0
> data offset 14679000 startblock 27741144 (26/478168) count 2097000 flag 0
> data offset 16776000 startblock 29838144 (28/478016) count 2097000 flag 0
> data offset 18873000 startblock 31935144 (30/477864) count 1607000 flag 0
> xfs_db> inode 134
> xfs_db> bmap
> data offset 0 startblock 7942144 (7/602112) count 2097000 flag 0
> data offset 2097000 startblock 10039144 (9/601960) count 2097000 flag 0
> data offset 4194000 startblock 12136144 (11/601808) count 926000 flag 0

It's been a while since I thought about realtime, but -

That all seems fine, I don't see anything overlapping there, they are
all perfectly adjacent, though of interesting size.

> 
> by looking into xfs_repair code, it looks like repair does not handle
> a case where we have more than one extent in a real-time extent. 
> following is code from repair/dinode.c: process_rt_rec

"more than one extent in a real-time extent?"  I'm not sure what that means.

Every extent above is length 2097000 blocks, and they are adjacent.
But you say your realtime extent size is 512 blocks ... which doesn't go
into 2097000 evenly.   So that's odd, at least.

Can you provide your xfs_info output for this fs?
Or maybe better yet an xfs_metadump image.

> -----
>      for (b = irec->br_startblock; b < irec->br_startblock +                                                                                                                
>                         irec->br_blockcount; b += mp->m_sb.sb_rextsize)  {                                                                                                     
>                 ext = (xfs_drtbno_t) b / mp->m_sb.sb_rextsize;                                                                                                                 
>                 pwe = xfs_sb_version_hasextflgbit(&mp->m_sb) &&                                                                                                                
>                                 irec->br_state == XFS_EXT_UNWRITTEN &&                                                                                                         
>                                 (b % mp->m_sb.sb_rextsize != 0);               
> -----
> 
> In my case rextsize is 512 (512 * 4096 = 2mb). So we have multiple
> extents (written extents to be precise, thanks dchinner for that),
> value of "ext" will be same for all of them and xfs_repair does not
> like it. thus the error message ""data fork in rt inode XX claims
> used rt block XX".

"ext" should not be the same for all of them; ext is the realtime extent
number in the fs, based on the physical start, br_startblock,
divided by the rt extent size.  There shouldn't be duplicate values
of "ext" based on the bmaps above.

The error comes from search_rt_dup_extent() which looks for overlaps
elsewhere in the fs...

If you can provide a metadump of the fs it might be easier to see what's going on.

-Eric

> If I ignore this failure condition, xfs_repairs seems to be happy.
> (FYI: this file-system is cleanly umounted) But in my opinion, its
> not good as these multiple extents can overlap too.

> Should we be using XR_E_MULT to flag and keep track of duplicated
> real-time extents. (maybe use the present API for adding/detecting
> duplicate extents)
> 
> I am open of suggestion or comments on how to fix this.
> 
> xfs_repair version is 3.1.8 and kernel 2.6.37.
> 
> thanks,
> Anand
> 
> 
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
