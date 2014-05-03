Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 055137F53
	for <xfs@oss.sgi.com>; Fri,  2 May 2014 22:02:41 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id E09728F8039
	for <xfs@oss.sgi.com>; Fri,  2 May 2014 20:02:37 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	w3YqC2bVPWElWFkz for <xfs@oss.sgi.com>;
	Fri, 02 May 2014 20:02:35 -0700 (PDT)
Date: Sat, 3 May 2014 13:02:22 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: XFS filesystem claims to be mounted after a disconnect
Message-ID: <20140503030221.GJ26353@dastard>
References: <5363A1D8.2020402@gmail.com> <5363B4C9.4000900@sandeen.net>
	<5363CB5E.3090008@gmail.com> <5363CD70.3000006@sandeen.net>
	<5363DBD7.4060002@gmail.com> <5363E65C.6010006@sandeen.net>
	<5363ECE8.6030706@gmail.com> <20140502233512.GE26353@dastard>
	<536432A0.6000405@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <536432A0.6000405@gmail.com>
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
To: Martin Papik <mp6058@gmail.com>
Cc: xfs@oss.sgi.com

On Sat, May 03, 2014 at 03:04:48AM +0300, Martin Papik wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA512
> 
> 
> > It's called a lazy unmount: "umount -l". It disconnects the 
> > filesystem from the namespace, but it still lives on in the kernel 
> > until all references to the filesystem go away. Given that the 
> > hot-unplug proceedure can call back into the filesystem to sync it
> > (once it's been disconnected!) the hot unplug can deadlock on
> > filesystem locks that can't be released until the hot-unplug errors
> > everything out.
> > 
> > So you can end up with the system in an unrecoverable state when
> > USB unplugs.
> 
> And the disconnect from the namespace is what removes it from
> /proc/mounts?

I believe so.

> By hot unplug, do you mean a user initiated "remove device" or a pull
> out of the USB cable? I'm sorry, I don't understand your example.
> Would you be kind enough to elaborate?

Anything that causes a hot-unplug to occur. There's no real
difference between echoing a value to the relevant sysfs file to
trigger the hot-unplug or simply pull the plug on the active device.
Or could even occur because something went wrong in the USB
subsystem (e.g. a hub stopped communicating) and so the end devices
disappeared, even though nothing is wrong with them.

> >>> If xfs encounters an insurmountable error, it will shut down,
> >>> and all operations will return EIO or EUCLEAN.  You are right
> >>> that there is no errors=* mount option; the behavior is not
> >>> configurable on xfs.
> >> 
> >> IMHO it should be, but since the last email I've glanced at some 
> >> mailing lists and understand that there's some reluctance, in the
> >> name of not polluting the FS after an error. But at least a R/O
> >> remount should be possible, to prevent yanking libraries from
> >> under applications (root FS).
> > 
> > What you see here has nothing to do with XFS's shutdown behaviour. 
> > The filesystem is already unmounted, it just can't be destroyed 
> > because there are still kernel internal references to it.
> 
> How can I detect this situation? I mean I didn't see anything in
> /proc/mounts or references to the mount point from /proc/<pid>/*, so I
> only managed to correct it (chdir elsewhere) by chance on a hunch.
> Would it not be desirable to know that there's a phantom FS referenced
> by a number of processes?

lsof.

> Also, do you know if this affects other filesystems? I never saw this
> with ext3/4 or reiser, I don't have much practical experience with
> other filesystems. I ask because your explanation sounds like it's vfs
> rather than xfs, but as I said, I never saw this before.

Yes, it affects all filesystems - the same behaviour occurs
regardless of the filesystem that is active on the block device.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
