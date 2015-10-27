Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id D5D5E7F37
	for <xfs@oss.sgi.com>; Tue, 27 Oct 2015 17:51:45 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 5DBBEAC002
	for <xfs@oss.sgi.com>; Tue, 27 Oct 2015 15:51:41 -0700 (PDT)
Received: from firestarter.dermichi.com (firestarter.dermichi.com
	[194.177.153.153]) by cuda.sgi.com with ESMTP id
	nIaiyDOE0D7tOS5l (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 27 Oct 2015 15:51:39 -0700 (PDT)
Received: from 191-159-177-194.static.net4you.net ([194.177.159.191]
	helo=[192.168.17.108]) by firestarter.dermichi.com with esmtpsa
	(TLSv1.2:ECDHE-RSA-AES128-GCM-SHA256:128) (Exim)
	(envelope-from <mw@dermichi.com>) id 1ZrD5d-0004a9-PW
	for xfs@oss.sgi.com; Tue, 27 Oct 2015 23:51:37 +0100
Subject: Re: Speeding up xfs_repair on filesystem with millions of inodes
References: <562F699E.2050002@dermichi.com> <20151027193855.GM8773@dastard>
From: Michael Weissenbacher <mw@dermichi.com>
Message-ID: <562FFFF7.4010908@dermichi.com>
Date: Tue, 27 Oct 2015 23:51:35 +0100
MIME-Version: 1.0
In-Reply-To: <20151027193855.GM8773@dastard>
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
To: xfs@oss.sgi.com

Hi Dave!
First of all, today i cancelled the running xfs_repair (CTRL-C) and
upped the system RAM from 8GB to 16GB - the maximum possible with this
hardware.

Dave Chinner wrote:
> It's waiting on inode IO to complete in memory reclaim. I'd say you
> have a problem with lots of dirty inodes in memory and very slow
> writeback due to using something like RAID5/6 (this can be
> *seriously* slow as mentioned recently here:
> http://oss.sgi.com/archives/xfs/2015-10/msg00560.html).
Unfortunately, this is a rather slow RAID-6 setup with 7200RPM disks.
However, before the power loss occurred it performed quite OK for our
use case and without any hiccups. But some time after the power loss
some "rm" commands hung and didn't proceed at all. There was no CPU
usage and there was hardly any I/O on the file system. That's why I
suspected some sort of corruption.

Dave Chinner wrote:
> Was it (xfs_repair) making progress, just burning CPU, or was it just hung?
> Attaching the actual output of repair is also helpful, as are all
> the things here:
> ...
The xfs_repair seemed to be making progress, albeit very very slowly. In
iotop i saw about 99% I/O usage on kswapd0. Looking at the HDD LED's of
the array, i could see that there was hardly any access to it at all
(only once about every 10-15 seconds).
I didn't include xfs_repair output, since it showed nothing unusual.
---snip---
Phase 1 - find and verify superblock...
Phase 2 - using internal log
        - zero log...
        - scan filesystem freespace and inode maps...
        - found root inode chunk
Phase 3 - for each AG...
        - scan and clear agi unlinked lists...
        - process known inodes and perform inode discovery...
        - agno = 0
        ...
        - agno = 14
        - process newly discovered inodes...
Phase 4 - check for duplicate blocks...
        - setting up duplicate extent list...
        - check for inodes claiming duplicate blocks...
        - agno = 0
        ...
        - agno = 14
Phase 5 - rebuild AG headers and trees...
        - reset superblock...
Phase 6 - check inode connectivity...
        - resetting contents of realtime bitmap and summary inodes
        - traversing filesystem ...
---snip---
(and sitting there for about 72 hours)

Dave Chinner wrote:
> "-P" slows xfs_repair down greatly.
Ok, I removed the "-P" option now.

Dave Chinner wrote:
> If repair is swapping, then adding more RAM and/or faster swap space
> will help. There is nothing that you can tweak that changes the
> runtime or behaviour of phase 6 - it is single threaded and requires
> traversal of the entire filesystem directory heirarchy to find all
> the disconnected inodes so they can be moved to lost+found. And it
> does write inodes, so if you have a slow SATA RAID5/6...
Ok, so if i understand you correctly, none of the parameters will help
for phase 6? I know that RAID-6 has slow write characteristics. But in
fact I didn't see any writes at all with iotop and iostat.

Dave Chinner wrote:
> 
> See above. Those numbers don't include reclaimable memory like the
> buffer cache footprint, which is affected by bhash and concurrency....
> 
As said above, i did now double the RAM of the machine from 8GB to 16GB.
Now I started xfs_repair again with the following options. I hope that
the verbose output will help to understand better what's actually going on.
# xfs_repair -m 8192 -vv /dev/sdb1

Besides, is it wise to limit the memory with "-m" to keep the system
from swapping or should I be better using the defaults (which would use
75% of RAM)?

Thank you very much for your insight, I will keep the list posted about
any progress.

Michael

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
