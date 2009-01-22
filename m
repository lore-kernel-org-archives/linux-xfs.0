Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n0M3Allr028865 for <xfs@oss.sgi.com>; Wed, 21 Jan 2009 21:10:47 -0600
Received: from ipmail01.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D38F9AA73F
	for <xfs@oss.sgi.com>; Wed, 21 Jan 2009 19:10:01 -0800 (PST)
Received: from ipmail01.adl6.internode.on.net (ipmail01.adl6.internode.on.net
	[203.16.214.146]) by cuda.sgi.com with ESMTP id
	61rtsn7pbbE00lJA for <xfs@oss.sgi.com>;
	Wed, 21 Jan 2009 19:10:01 -0800 (PST)
Date: Thu, 22 Jan 2009 14:09:55 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: No space left on device on xfs filesystem with 1.6TB free
Message-ID: <20090122030955.GT10158@disturbed>
References: <alpine.LSU.2.00.0901211007200.19898@hermes-2.csi.cam.ac.uk>
	<20090121225453.GN10158@disturbed>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20090121225453.GN10158@disturbed>
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
To: Owen Dunn <osd1000@cam.ac.uk>, xfs@oss.sgi.com

On Wed, Jan 21, 2009 at 10:33:10AM +0000, Owen Dunn wrote:
> I'm running SuSE Linux Enterprise Server 10 SP2, on a 32-bit i386 Linux 
> machine with kernel version 2.6.16.60-0.33-smp.  I appear to have version 
> 2.9.4 of xfsprogs.
> 
> I have a 6TB xfs filesystem which has been grown twice from 2TB, and which 
> appears to have 1.6TB and plenty of inodes free.  However, attempts to 
> create a new file fail with ENOSPC:

You've run out of inode space below 1TB or free space is
sufficiently fragmented below 1TB that new inode chunks cannot
be allocated.

> sf3:/EXPORT/space # touch splat
> touch: cannot touch `splat': No space left on device
> sf3:/EXPORT/space # df -h .
> Filesystem            Size  Used Avail Use% Mounted on
> /dev/mapper/bigvg-lv1
>                        6.0T  4.5T  1.6T  75% /EXPORT/space
> sf3:/EXPORT/space # df -ih .
> Filesystem            Inodes   IUsed   IFree IUse% Mounted on
> /dev/mapper/bigvg-lv1
>                          4.0G    887K    4.0G    1% /EXPORT/space

df -i really doesn't tell you anything useful on filesystems that
dynamically allocate inodes like XFS.

> Any idea what's going on and how to fix it? 

The only way to fix this is to move data around to free up space
below 1TB. Find your oldest data (i.e. that was around before even
the first grow) and move it off the filesystem (move, not copy).
Then if you copy it back on, the data blocks will end up above 1TB
and that should leave you with plenty of space for inodes below 1TB.

A complete dump and restore will also fix the problem ;)

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
