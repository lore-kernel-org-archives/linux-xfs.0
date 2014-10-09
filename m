Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 467207F3F
	for <xfs@oss.sgi.com>; Thu,  9 Oct 2014 16:20:40 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 32FA8304070
	for <xfs@oss.sgi.com>; Thu,  9 Oct 2014 14:20:40 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	Ncvnyb4dNc4nPABZ for <xfs@oss.sgi.com>;
	Thu, 09 Oct 2014 14:20:38 -0700 (PDT)
Date: Fri, 10 Oct 2014 08:20:10 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: XFS Filesystem is broken and cant repair and mount!
Message-ID: <20141009212010.GE4376@dastard>
References: <trinity-c6202f4d-95cc-42f9-a8f2-86e3b9b231a9-1412860507253@3capp-gmx-bs31>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <trinity-c6202f4d-95cc-42f9-a8f2-86e3b9b231a9-1412860507253@3capp-gmx-bs31>
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
To: Dragon <Sunghost@gmx.de>
Cc: xfs@oss.sgi.com

On Thu, Oct 09, 2014 at 03:15:07PM +0200, Dragon wrote:
> Hello, while i copy some files to my software raid device the xfs
> filesystem reports an uncorrectable error unmount and stops.
> Reboot didnt work, same failure. Answers to the FAQS:
> 
> 1.Linux 3.2.0-4-amd64 #1 SMP Debian 3.2.60-1+deb7u3 x86_64 GNU/Linux
> 2.xfsprogs 3.1.7+b1 amd64

I'd upgrade xfsprogs before doing anything else.

> 13. dmesg:
> [    7.541885] SGI XFS with ACLs, security attributes, realtime, large block/inode numbers, no debug enabled
> [    7.542692] SGI XFS Quota Management subsystem
> [    7.569679] XFS (md2): Mounting Filesystem
> [    7.799071] XFS (md2): Starting recovery (logdev: internal)
> [    8.992087] XFS (md2): xlog_recover_inode_pass2: Bad inode magic number, dip = 0xffff88031c344400, dino bp = 0xffff88032050d0c0, ino = 3469995060
> [    8.992354] XFS (md2): Internal error xlog_recover_inode_pass2(1) at line 2248 of file /build/linux-eKuxrT/linux-3.2.60/fs/xfs/xfs_log_recover.c.  Caller 0xffffffffa03fe677

Bad inode cluster on disk. You need to run xfs_repair on the
filesystem.

I'd suggest running "xfs_repair -n" to see whether that's the only
error and whether it's likely to be able to repair without making a
mess. If you don't have backups, you might want to mount -o
ro,norecovery and take a backup before trying to repair properly.
If you're really paranoid, take a metadump of the filesystem,
restore themetadump to a file and see if repair can fix the image
file first.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
