Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 6CD5D7F3F
	for <xfs@oss.sgi.com>; Wed,  4 Jun 2014 19:08:38 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 38D2E8F8039
	for <xfs@oss.sgi.com>; Wed,  4 Jun 2014 17:08:38 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	tjBMrJF4XhuiWv8a for <xfs@oss.sgi.com>;
	Wed, 04 Jun 2014 17:08:32 -0700 (PDT)
Date: Thu, 5 Jun 2014 10:08:03 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: XFS filesystem claims to be mounted after a disconnect
Message-ID: <20140605000803.GA4523@dastard>
References: <20140502233512.GE26353@dastard> <536432A0.6000405@gmail.com>
	<20140503030221.GJ26353@dastard> <538C5E67.6090005@gmail.com>
	<20140602234135.GO6677@dastard> <538D9412.3040009@gmail.com>
	<CAAxjCEzz5n85zAH5HuUQkfxKvzZt5_+cPCj3uzZR7U69H+2tDw@mail.gmail.com>
	<538DA7FF.4080002@gmail.com> <20140603212834.GG14410@dastard>
	<538E532E.7050008@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <538E532E.7050008@gmail.com>
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
Cc: Linux fs XFS <xfs@oss.sgi.com>

On Wed, Jun 04, 2014 at 01:58:54AM +0300, Martin Papik wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA512
> 
> 
> 
> >> [3096069.218830] XFS (sdf100): Log I/O Error Detected.  Shutting
> >> down filesystem [3096069.218833] XFS (sdf100): Please umount the
> >> filesystem and rectify the problem(s)
> > 
> > triggered a shutdown and told you what to do next.
> 
> Okay, here I'll pick nits. I hope you're not sick of me yet.
> 
> 1) I would LOVE to unmount the FS, but how? umount /dev/xxx ... device
> no longer there. umount /media/xxx ... mount point no longer there.

Oh, something is doing a lazy unmount automatically on device
unplug? I missed the implications of that - your system is behaviour
exactly as it has been told to behave.

That is, lazy unmount only detaches the mount namespace from the
mount - it doesn't actually tell the kernel to unmount the
filesystem internally, instead it just removes the reference count
it has on it. If there are other open references to the filesystem,
then it won't actually do the real unmount until those references go
away.  i.e. lazy unmount is designed to leave the kernel superblock
(i.e. the filesystem) mounted internally until the last reference to
it goes away.

And that leaves the user to find those references and clean them up
so the kernel can actually unmount it. Put simply, the system is
behaving exactly as it has been asked to act in response to your
actions. Whether the automounter is behaving correctly or not, that
is a different matter, but it is certainly not an XFS bug that a
lazy unmount is leaving you with a mess that you need to cleanup
manually.

> 2) I can't rectify the problems exactly because the FS is mounted
> (according to xfs_repair [ustat]), yet not mounted (according to
> /proc/mounts). .... unless rectifying the problem means reporting this
> as a bug. :-)

Not a bug, it's the desired behaviour of lazy unmounts. Fix userspace
not to hold references when unmounting the filesystem...

> 3) "Shutting down filesystem" ... isn't this when the new device
> should no longer be detected as mounted?

No. Filesystems get shut down for all sorts of reasons and the
correct action to take after unmounting the filesystem depends on
the reason for the shutdown. i.e. a shutdown filesystem requires
manual intervention to recover from, and so the filesystem remains
mounted until such manual intervention can take place.

> 4) come to think of it, if XFS is shutting down, why isn't it
> unmounting itself?

Because a filesystem cannot unmount itself - that has to be done
from userspace.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
