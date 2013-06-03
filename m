Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id C7E477F55
	for <xfs@oss.sgi.com>; Mon,  3 Jun 2013 02:44:42 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 98F7C8F8039
	for <xfs@oss.sgi.com>; Mon,  3 Jun 2013 00:44:42 -0700 (PDT)
Received: from mx3-phx2.redhat.com (mx3-phx2.redhat.com [209.132.183.24]) by
	cuda.sgi.com with ESMTP id JcWubZeZnnSH1CF0 for
	<xfs@oss.sgi.com>; Mon, 03 Jun 2013 00:44:41 -0700 (PDT)
Date: Mon, 3 Jun 2013 03:44:38 -0400 (EDT)
From: CAI Qian <caiqian@redhat.com>
Message-ID: <154590181.10568924.1370245478015.JavaMail.root@redhat.com>
In-Reply-To: <20130522094648.GJ29466@dastard>
References: <1871204531.7584919.1367826613792.JavaMail.root@redhat.com>
	<5187BEA5.4040107@sandeen.net>
	<647316680.8155487.1367913231441.JavaMail.root@redhat.com>
	<51895115.90108@sandeen.net>
	<2132292786.4417784.1369195807747.JavaMail.root@redhat.com>
	<2013798179.4502334.1369212536770.JavaMail.root@redhat.com>
	<20130522094648.GJ29466@dastard>
Subject: Re: 3.9.0: XFS rootfs corruption
MIME-Version: 1.0
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
To: Dave Chinner <david@fromorbit.com>
Cc: Eric Sandeen <sandeen@sandeen.net>, xfs@oss.sgi.com



----- Original Message -----
> From: "Dave Chinner" <david@fromorbit.com>
> To: "CAI Qian" <caiqian@redhat.com>
> Cc: "Eric Sandeen" <sandeen@sandeen.net>, xfs@oss.sgi.com
> Sent: Wednesday, May 22, 2013 5:46:48 PM
> Subject: Re: 3.9.0: XFS rootfs corruption
> 
> On Wed, May 22, 2013 at 04:48:56AM -0400, CAI Qian wrote:
> > 
> > 
> > ----- Original Message -----
> > > From: "CAI Qian" <caiqian@redhat.com>
> > > To: "Eric Sandeen" <sandeen@sandeen.net>
> > > Cc: xfs@oss.sgi.com
> > > Sent: Wednesday, May 22, 2013 12:10:07 PM
> > > Subject: Re: 3.9.0: XFS rootfs corruption
> > > 
> > > OK, this has never been reproduced in 3.9-rc1 so far. It may because the
> > > rootfs became full after crash dump testing though.
> > > CAI Qian
> > Oops, it is still there,
> 
> Have you run xfs_repair -n  <dev>  to determine what is corrupted on
> disk? Can you post the output when you do?
Here you go.
CAI Qian

:/# xfs_repair -n  /dev/mapper/rhel_ibm--p720--01--lp4-root 
Phase 1 - find and verify superblock...
Phase 2 - using internal log
        - scan filesystem freespace and inode maps...
agi_freecount 10, counted 8 in ag 1
sb_icount 149248, counted 149312
sb_ifree 216, counted 27
sb_fdblocks 10788304, counted 10784210
        - found root inode chunk
Phase 3 - for each AG...
        - scan (but don't clear) agi unlinked lists...
        - process known inodes and perform inode discovery...
        - agno = 0
bad entry count in block 8388610 of directory inode 113571
bad entry count in block 8388610 of directory inode 1178385
bad entry count in block 8388610 of directory inode 1519037
        - agno = 1
bad entry count in block 8388610 of directory inode 67109016
bad entry count in block 8388610 of directory inode 67929825
bad entry count in block 8388610 of directory inode 69407749
bad entry count in block 8388610 of directory inode 69490381
bad entry count in block 8388610 of directory inode 69534546
bad entry count in block 8388610 of directory inode 69842112
        - agno = 2
bad entry count in block 8388610 of directory inode 134321722
bad entry count in block 8388610 of directory inode 134321726
bad entry count in block 8388610 of directory inode 136067648
bad entry count in block 8388610 of directory inode 144715871
        - agno = 3
bad entry count in block 8388610 of directory inode 201326727
bad entry count in block 8388610 of directory inode 201326754
bad entry count in block 8388610 of directory inode 201327172
bad entry count in block 8388610 of directory inode 201951914
bad entry count in block 8388610 of directory inode 202409289
bad entry count in block 8388610 of directory inode 206245507
bad entry count in block 8388610 of directory inode 206253502
bad entry count in block 8388610 of directory inode 206308010
bad entry count in block 8388610 of directory inode 206632072
bad entry count in block 8388610 of directory inode 212625436
        - process newly discovered inodes...
Phase 4 - check for duplicate blocks...
        - setting up duplicate extent list...
        - check for inodes claiming duplicate blocks...
        - agno = 0
        - agno = 3
        - agno = 2
        - agno = 1
entry "tmp.Iive34" at block 0 offset 2664 in directory inode 69369993 references free inode 69015237
	would clear inode number in entry at offset 2664...
No modify flag set, skipping phase 5
Phase 6 - check inode connectivity...
        - traversing filesystem ...
entry "tmp.Iive34" in directory inode 69369993 points to free inode 69015237, would junk entry
bad hash table for directory inode 69369993 (no data entry): would rebuild
        - traversal finished ...
        - moving disconnected inodes to lost+found ...
Phase 7 - verify link counts...
No modify flag set, skipping filesystem flush and exiting.
> 
> Cheers,
> 
> Dave.
> --
> Dave Chinner
> david@fromorbit.com
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
