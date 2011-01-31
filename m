Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p0V3n9aL065052 for <xfs@oss.sgi.com>; Sun, 30 Jan 2011 21:49:09 -0600
Received: from ipmail04.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 7743429D216
	for <xfs@oss.sgi.com>; Sun, 30 Jan 2011 19:51:34 -0800 (PST)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	U021ZVZzo9vMNCAc for <xfs@oss.sgi.com>;
	Sun, 30 Jan 2011 19:51:34 -0800 (PST)
Date: Mon, 31 Jan 2011 14:51:31 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: how to decode metadump info produced by xfs_db, and superblock
	error
Message-ID: <20110131035131.GI21311@dastard>
References: <SNT130-w5507ED619ADEE5A0761FA4DAE30@phx.gbl>
	<20110130071630.GE21311@dastard>
	<SNT130-w23319C8BC652352929903ADAE30@phx.gbl>
	<20110130214026.GF21311@dastard>
	<SNT130-w32CA503F4940DD51CBE1A3DAE20@phx.gbl>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <SNT130-w32CA503F4940DD51CBE1A3DAE20@phx.gbl>
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
To: lord worm <cryptopsy@live.com>
Cc: xfs@oss.sgi.com

On Sun, Jan 30, 2011 at 08:21:19PM -0500, lord worm wrote:
> > Date: Mon, 31 Jan 2011 08:40:26 +1100
> > From: david@fromorbit.com
> > To: cryptopsy@live.com
> > Subject: Re: how to decode metadump info produced by xfs_db, and superblock error
> > 
> > On Sun, Jan 30, 2011 at 11:33:53AM -0500, lord worm wrote:
> > > > Date: Sun, 30 Jan 2011 18:16:30 +1100
> > > > From: david@fromorbit.com
> > > > To: cryptopsy@live.com
> > > > CC: xfs@oss.sgi.com
> > > > Subject: Re: how to decode metadump info produced by xfs_db, and superblock error
> > > > 
> > > > On Sat, Jan 29, 2011 at 07:25:10PM -0500, lord worm wrote:
> > > > > 
> > > > > What kind of information is in this file produced by metadump, is it worth reading it somehow?
> > > > > 
> > > > > I'm trying to first understand what's causing a 'superblock cannot
> > > > > be read' error in my XFS after a succesfully dd of the partition
> > > > > (dd succeeds in copying to a file, and also restoring, but after
> > > > > restoring it cannot mount).
> > > > 
> > > > dmesg output when the mount fails?
> > > 
> > > Could you email the mailing list next time as well, so that my
> > > forwards are directed towards everyone, please?
> > 
> > I did:
> > 
> > http://oss.sgi.com/archives/xfs/2011-01/msg00486.html
> > 
> > As for list ettiquette - please don't top post and wrap all you text
> > except for code and pasted log messages at 72 columns.....

Fixed that for you again.

> > > Here's dmesg from the backup file, but I don't have it from the original disk after restoring it:
> > > 
> > > [  362.685464] attempt to access beyond end of device
> > > [  362.685468] loop5: rw=0, want=15662872, limit=15661056
> > > [  362.685473] I/O error in filesystem ("loop5") meta-data dev loop5 block 0xeeff17       ("xfs_read_buf") error 5 buf count 512
> > > [  362.685478] XFS: size check 2 failed
> > 
> > Simple problem - you copied the filesystem back onto a device that
> > is too small for the filesystem.
> 
> When I reply to this email, it defaults to david@fromorbit.com, so
> how will the others see it?

Reply to all. It's common courtesy to reply to everyone on the
cc-list for mailing list traffic as it often contains people not
subscribed to the mailing list (e.g. a person reporting a bug).

I've added the xfs list back onto the cc-list.

> I can't mount the direct dd image of the drive as a loop device
> either by the same error.

Which means you probably didn't copy the entire drive in the first
place.

> The error persists even when its not
> the filesystem that was copied back onto the device. Additionally,
> its the exact same device with the exact same partition type
> created by the exact same version of disk.

partition type doesn't matter - the size does. The above error
indicates that the loop device is 1816 sectors (908kiB) shorter than
it needs to be, so maybe you aren't recreating the partition as
large as it needs to be, too....

As it is, the question I have at this point is why are you trying to
copy the filesystem via dd? if all you want is an image, xfs_copy is
probably what you want....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
