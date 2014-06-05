Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id C83127F3F
	for <xfs@oss.sgi.com>; Wed,  4 Jun 2014 19:55:55 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id AE5B28F8040
	for <xfs@oss.sgi.com>; Wed,  4 Jun 2014 17:55:55 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	Hd9fA4qtDg4STQQA for <xfs@oss.sgi.com>;
	Wed, 04 Jun 2014 17:55:53 -0700 (PDT)
Date: Thu, 5 Jun 2014 10:55:38 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: XFS filesystem claims to be mounted after a disconnect
Message-ID: <20140605005538.GB4523@dastard>
References: <20140502233512.GE26353@dastard> <536432A0.6000405@gmail.com>
	<20140503030221.GJ26353@dastard> <538C5E67.6090005@gmail.com>
	<20140602234135.GO6677@dastard> <538D9412.3040009@gmail.com>
	<CAAxjCEzz5n85zAH5HuUQkfxKvzZt5_+cPCj3uzZR7U69H+2tDw@mail.gmail.com>
	<538DA7FF.4080002@gmail.com> <20140603212834.GG14410@dastard>
	<538E4E1B.1020003@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <538E4E1B.1020003@gmail.com>
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

On Wed, Jun 04, 2014 at 01:37:15AM +0300, Martin Papik wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA512
> 
> 
> I think you're trying too hard to defend XFS which may be causing you
> to miss my point. Or it could be my bad communication.

Or it coul dbe you lack the knowledge base to understand what I
explained to you. That happens all the time because this stuff is
complex and very few people actually have the time to understand how
it is all supposed to work.

> When I yank and replug a device, I can only remount the device only if
> I kill certain processes. But this limitation exists only on the same
> box. I.e. it won't prevent me from mounting the same disk on a
> different machine, just the same one.
> 
> So here are a few questions.
> 
> (1) If the device vanished, why not just terminate the mount instance?

That's what the automounter is doing from userspace with the lazy
unmount on reception of a device unplug event. i.e. the policy of
what to do when a device unplug event occurs is handled in
userspace, and it has nothing to do with the filesystem on the block
device.

> (2) Following the methods of the prior experiments I did this,
> connected the disk to PC1, hexedit file, yank disk, plug disk, at this
> point PC1 won't touch the disk, moved the disk to PC2, it
> automatically, silently (Mounting Filesystem ++ Ending clean mount)
> mounts the FS, then move the disk back and the disk still doesn't
> mount, claiming it's mounted, never mind that since then the FS was
> mounted somewhere else and for all intents and purposes it a
> completely different disk, to which (question 1) the potentially
> unwritten data will never be written back. I apologize, but I really
> don't see what XFS is protecting me from or how and I doubt its
> success rate. Can you please explain?

It's not protecting you against doing this. You can subvert
/etc/shadow doing this for all I care, but the fact is that until
you clean up the original mess your cable yanking created, XFS won't
allow you to mount that filesystem again on that system.

As I've already explained, we do not allow multiple instances of the
same filesystem to be mounted because in XFS's primary target market
(i.e. servers and enterprise storage) this can occur because of
multi-pathing presenting the same devices multiple times. And in
those environments, mounting the same filesystem multiple times
through different block devices is *always* a mistake and will
result in filesystem corruption and data loss.

> (3) Isn't it possible that XFS just doesn't recognize that whatever
> error condition happened is permanent and the disk won't come back.

XFS can't determine correctly if it is a fatal permanent or
temporary error condition. Hence if we get an error from the storage
(regardless of the error) in a situation we can't recover
from, it is considered fatal regardless of whether the device is
replugged or not. You case is a failed log IO, which is always a
fatal, unrecoverable error....

> Isn't XFS just forcing me to take a manual action by accident?

No, by intent. Obvious, in-your-face intent. Filesystem corruption
events require manual intervention to analyse and take appropriate
action. You may not think it's necessary for your use case, but
years of use in mission critical data storage environments has
proven otherwise....

> Imagine, I have some files, just saved them, didn't call fsync, the
> data is still in some cache, the cable is yanked, and the data is
> lost. But in this case the XFS won't complain.

It does complain - it logs that it is discarding data unless a
shutdown has already occurred, and then it doesn't bother because
it's already indicated to the log that the filesystem is in big
trouble....

> Only if there's a process. Seems more like circumstance than design. Is it? Is this an
> actual intentional behavior.

Lazy unmount does this by intent and XFS has not control over this.
Lazy unmount is done by your userspace software, not the filesystem.
You're shooting the messenger.

> > Yup - XFS refuses to mount a filesystem with a duplicate UUID, 
> > preventing you from mounting the same filesystem from two
> > different logical block device instances that point to the same
> > physical disk. That's the only sane thing to do in enterprise
> > storage systems that use multi-pathing to present failure-tolerant
> > access to a physical device.
> 
> Actually, IMHO it would also be sane to forget you ever saw a UUID
> after the last underlying physical device is gone and you're not going
> to be ever writing to this.

And how does the referenced, mounted filesystem know this? It can't
- it actually holds a reference to the block device that got yanked,
and internally that block device doesn't go away until the
filesystem releases it's reference.

> Since if you're never touching the FS with
> UUID XYZ then it's not mounted enough to prevent use. IMHO. But yes,
> as long as you do have a functioning relationship with UUID XYZ
> through /dev/sda1, lock /dev/sdb1 if it has the same UUID. But not
> after you've lost all block devices. ........ Or attempting to put my
> understanding of the situation in humorous terms "the kernel is
> preventing access to /dev/sdg100 out of grief for the death of
> /dev/sdf100".

/dev/sdf still exists inside the kernel while the filesystem that
was using it is still mounted. You just can't see kernel-internal
references to block device. Sound familiar? It's just like processes
and lazy unmounts, yes? IOWs, what is happening is this:

Yank the device, the device hot-unplugs and nothing new can now use
it. It still has active references, so it isn't cleaned up. It sends
an unplug event to userspace, probably caught by udev, fed into
dbus, picked up by the automounter, which does a lazy unmount of the
filesystem on the device. Filesystem is removed from the namespace,
but open references to it still exist so it's not fully unmounted
and so still holds a block device reference.  Userspace references
to filesystem go away, filesystem completes unmount, releases
blockdev reference, blockdev cleans up and dissappears completely,
filesystem cleans up and disappears completely.

Userspace causes the mess because it's handling of the unplug event,
and there's nothing we can do in the kernel about that, because....

> Lame joke, yes, but think please, what is the actual
> benefit of me having to kill a process, after which I yank again, plug
> again, and the FS mounts silently. I really don't get this. How is
> this not a bug?

.... until the userspace references to the filesystem go away, the
kernel still has a huge amount of internally referenced state that
you can't see from userspace. So, the bug here is in userspace by
using lazy unmounts and not dropping active references in a timely
fashion after an unplug event has occurred.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
