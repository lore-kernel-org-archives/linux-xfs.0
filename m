Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 2B1217F3F
	for <xfs@oss.sgi.com>; Tue, 22 Oct 2013 10:03:38 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id A09CBAC007
	for <xfs@oss.sgi.com>; Tue, 22 Oct 2013 08:03:34 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id JBWkAX7sZt6aGwT9 for <xfs@oss.sgi.com>;
	Tue, 22 Oct 2013 08:03:29 -0700 (PDT)
Message-ID: <526693C3.3030505@sandeen.net>
Date: Tue, 22 Oct 2013 10:03:31 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: 128 bits extent bmap for file format 2
References: <CAPU9cc3rV+E79HBE95=nsjgoC5=s85jBBZgcxL+d8KijVa0LyA@mail.gmail.com>
	<20131022001218.GH4446@dastard>
	<CAPU9cc2EsoeNE+mMQSwmLVXyyPoE9jLVhDRcQLJxvWYTNU-33w@mail.gmail.com>
	<CAPU9cc3JXedegmC3MgzjtOaRLTtMZoT5C=gkS0zwTCySBqQhew@mail.gmail.com>
In-Reply-To: <CAPU9cc3JXedegmC3MgzjtOaRLTtMZoT5C=gkS0zwTCySBqQhew@mail.gmail.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Pradeep Kumar <praks411@gmail.com>
Cc: xfs@oss.sgi.com

On 10/22/13 6:25 AM, Pradeep Kumar wrote:
> I was able to resolve the issue. This was indeed related to conversion between FSB to actual data block in image file. I would like to thanks Dave for showing the direction. 
> So to summarize the extent data (128 bits, format =2) gives absolute block number which is in term of XFS file system block this need to be converted into actual disk block.
> 
> I've used two macros for it.
> 1. #define XFS_FSB_TO_AGNO <http://lxr.free-electrons.com/ident?i=XFS_FSB_TO_AGNO>(mp,fsbno) 
> 2.#define XFS_FSB_TO_AGBNO <http://lxr.free-electrons.com/ident?i=XFS_FSB_TO_AGBNO>(mp,fsbno).
> 
> First one give the actual AG number and the second one gives the block number in that AG.
> 
> Now coming back to my previous example which I posted
> My extent data was.
>  00 00 00 00 00 00 00 00 00 00 00 04 99 80 00 01 (LSB)
> 
> After unpacking, absolute block number = 9420 (0x24cc).
> Converting to actual data block using above two macros gives me AG No. = 1, AG Block No = 1228. So final block (1*6400 + 1228 = 7628) which is correct.(I was able to get correct file contents)
> Please let me know if above computation is correct. It seems correct to me as I'm able to retrieve all the files.
> 
> Still I couldn't get two macros.
> 1. #define XFS_FSS_TO_BB <http://lxr.free-electrons.com/ident?i=XFS_FSS_TO_BB>(mp,sec <http://lxr.free-electrons.com/ident?i=sec>) ((sec <http://lxr.free-electrons.com/ident?i=sec>) << (mp)->m_sectbb_log).
> *2. *#define XFS_BB_TO_FSBT <http://lxr.free-electrons.com/ident?i=XFS_BB_TO_FSBT>(mp,bb <http://lxr.free-electrons.com/ident?i=bb>) ((bb <http://lxr.free-electrons.com/ident?i=bb>) >> (mp)->m_blkbb_log).
> 
> I couldn't find m_sectbb_log and m_blkbb_log fields. Please someone share more knowledge on above 
> macros like where they are used and also description of input and output field

Use the source, Luke:


[linux-2.6]$ grep m_blkbb_log fs/xfs/*.h
fs/xfs/xfs_mount.h:	__uint8_t		m_blkbb_log;	/* blocklog - BBSHIFT */

linux-2.6]$ grep m_sectbb_log fs/xfs/*.h
...
fs/xfs/xfs_mount.h:	__uint8_t		m_sectbb_log;	/* sectlog - BBSHIFT */

it's the log of the (block/sector) size, minus the basic block (512) shift (9)

/*
 * Block I/O parameterization.  A basic block (BB) is the lowest size of
 * filesystem allocation, and must equal 512.  Length units given to bio
 * routines are in BB's.
 */
#define BBSHIFT         9

-Eric

> Thanks and Regards,
> Pradeep
> 
> 
> 
> 
> 
> On 22 October 2013 10:08, Pradeep Kumar <praks411@gmail.com <mailto:praks411@gmail.com>> wrote:
> 
>     Hi Dave,
> 
>     Thanks for the reply. I think I may get my solution. Can you explain the difference between the two?
>     I've created sample xfs file using mkfs.xfs with mostly default parameter 
>     1. Sector Size = 512
>     2. Block size = 4096
>     3. AG Number = 2
>     4. Number of blocks per AG = 6400.
> 
>     So when I get absolute block 9420 from file extent data  I'm going to (6400 + 3020) , 3020 block of second AG which is wrong. The file start from 7628 absolute block or (6400 + 1228), 1228 block of second AG. 
>     Please describe in some detail above the conversion which you are talking about.
> 
>     Thanks and Regards,
>     Pradeep
> 
> 
> 
>     On 22 October 2013 02:12, Dave Chinner <david@fromorbit.com <mailto:david@fromorbit.com>> wrote:
> 
>         On Tue, Oct 22, 2013 at 01:32:22AM +0200, Pradeep Kumar wrote:
>         > Hi,
>         >
>         > I'm writing a small utility to parse XFS fs image on windows.
>         > I'm able to fetch the files in the first AG (0).
>         > However when it comes to the files which are in different AG I'm facing
>         > some problem in parsing extent bmap 128bits data of file inode (format ==
>         > 2).
> 
>         Extents use filesystem block encodings, not disk addresses. Look up
>         the macros XFS_DADDR_TO_FSB and XFS_FSB_TO_DADDR.
> 
>         Cheers,
> 
>         Dave.
>         --
>         Dave Chinner
>         david@fromorbit.com <mailto:david@fromorbit.com>
> 
> 
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
