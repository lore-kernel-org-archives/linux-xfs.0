Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n4E0YJDl182857 for <xfs@oss.sgi.com>; Wed, 13 May 2009 19:34:19 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9932928511B
	for <xfs@oss.sgi.com>; Wed, 13 May 2009 17:34:25 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail17.adl2.internode.on.net
	[150.101.137.102]) by cuda.sgi.com with ESMTP id
	ZNWNhhrQp1WqG9Af for <xfs@oss.sgi.com>;
	Wed, 13 May 2009 17:34:25 -0700 (PDT)
Date: Thu, 14 May 2009 10:34:22 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: file preallocation without unwritten flag being set
Message-ID: <20090514003422.GM16929@discord.disaster>
References: <283244.29270.qm@web65608.mail.ac4.yahoo.com>
	<4A0A0E76.6000701@sandeen.net>
	<618437.93111.qm@web65601.mail.ac4.yahoo.com>
	<4A0A55E0.4010202@sandeen.net>
	<705795.15734.qm@web65604.mail.ac4.yahoo.com>
	<20090513222823.GL16929@discord.disaster>
	<502709.63746.qm@web65615.mail.ac4.yahoo.com>
	<4A0B6325.8000706@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4A0B6325.8000706@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs@oss.sgi.com

On Wed, May 13, 2009 at 07:17:41PM -0500, Eric Sandeen wrote:
> p v wrote:
> > with the default mkfs and mount options. I created the fs, cleared
> > extflg from the superblocks and run xfs_io to resvsp the space. Then
> > I run truncate and truncate decided to initialize the extents to zero
> > and since it's 10TB it's going to take a while (can't reset as it's a
> > remote machine and xfs_io is looping in the kernel ...). It didn't do
......
> 
> try truncate then resvsp; TBH not sure why it should matter though :)

Uninitialised extents beyond EOF get zeroed when EOF is moved.
if you set the set before preallocation, then there are no extents
to zero. FWIW, if they have the unwritten flag, this zeroing does not occur.

> > I am a little bit lost about the comment regarding the page caches. I
> > unmounted the filesystem before running xfs_db. Shouldn't that flush
> > pages, buffers, ...? I assume that xfs_db goes directly to the device
> > so if the fs was unmounted then the device should be up to date?
> 
> The device is uptodate but the bdev address space may not be.
> 
> Unmounting will flush the filesytem address space, but not the block
> device address space.

Not exactly the problem, though. XFS opens it's own device address space
when mounting - not the address space you get by opening /dev/sdX.
xfs_db uses the address space associated with /dev/sdX. hence
if you do:

# xfs_db /dev/sdc
....
# mount /dev/sdc
<do some changes>
# unmount /dev/sdc
# xfs_db /dev/sdc

The second invocation of xfs_db will not see any of the changes that
occured to the filesystem because it will read from the buffers
cached on /dev/sdc during the first invocation.

This is the same problem Grub has....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
