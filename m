Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 05FC47FC5
	for <xfs@oss.sgi.com>; Wed, 13 Feb 2013 04:41:18 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id E2F89304039
	for <xfs@oss.sgi.com>; Wed, 13 Feb 2013 02:41:17 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id cMjMBADsrsSYmOwP for
	<xfs@oss.sgi.com>; Wed, 13 Feb 2013 02:41:17 -0800 (PST)
Date: Wed, 13 Feb 2013 11:41:08 +0100 (CET)
From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: Re: [PATCH] xfs_mkfs: wipe old signatures from the device
In-Reply-To: <20130213080154.GC18597@x2.net.home>
Message-ID: <alpine.LFD.2.00.1302131127070.2315@(none)>
References: <1360667215-14701-1-git-send-email-lczerner@redhat.com>
	<20130212202753.GC26694@dastard>
	<20130213080154.GC18597@x2.net.home>
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
To: Karel Zak <kzak@redhat.com>
Cc: sandeen@redhat.com, xfs@oss.sgi.com, Zach Brown <zabrown@redhat.com>, Lukas Czerner <lczerner@redhat.com>, linux-btrfs@vger.kernel.org

On Wed, 13 Feb 2013, Karel Zak wrote:

> Date: Wed, 13 Feb 2013 09:01:54 +0100
> From: Karel Zak <kzak@redhat.com>
> To: Dave Chinner <david@fromorbit.com>
> Cc: Lukas Czerner <lczerner@redhat.com>, xfs@oss.sgi.com, sandeen@redhat.com
> Subject: Re: [PATCH] xfs_mkfs: wipe old signatures from the device
> 
> On Wed, Feb 13, 2013 at 07:27:53AM +1100, Dave Chinner wrote:
> > Isn't 128k of zeroing enough to kill existing filesystem signatures?
> 
> Really no.
> 
> > If not how much is, and why can't we just change WHACK_SIZE to
> > reflect the size that will kill those signatures that are further
> > offset into the device?
> 
> btrfs: first superblock at 64KB, second at 64MB, third at 256GB.

We've been discussing this with Dave and others and it seems really
odd that blkid would detect file system signature from backup
superblock. It seems that it's doing this only for btrfs, ignoring
backup superblocks for any other file system.

I know that btrfs user space is broken in a way that it would
unconditionally use backup superblock, but it has to be fixed!

Also I think that the bug in btrfs is not a reason for blkid to
treat btrfs backup superblocks as primary (which is what you're
essentially doing). We should fix that first and then we can discuss
whether fs utilities should be using blkid to wipe all the
signatures from the device I think.

It seem to me that this is real problem and also nasty regression
because:

mkfs.btrfs /dev/sda
mkfs.xfs -f /dev/sda

and the device is unmountable, even though it contains valid xfs
file system.

However

mkfs.btrfs /dev/sda
mkfs.ext4 -F /dev/sda

works well, however I am not sure why that is. Is that some kind of
mount(8) magic ?

So I think that liblkid _and_ btrfs tools has to be fixed not to treat
backup superblocks as primary!

Thanks!
-Lukas


> 
> zfs has at least 4 blocks at the begin and end of the device.
> 
> GPT has the backup table at the end of the device.
> 
> RAIDs have signatures also at the end of the device, etc.
> 
> 
>     Karel
> 
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
