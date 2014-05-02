Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 3758F7F75
	for <xfs@oss.sgi.com>; Fri,  2 May 2014 18:35:28 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 242D58F8040
	for <xfs@oss.sgi.com>; Fri,  2 May 2014 16:35:28 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	e8f9FVM3qEJzkT9N for <xfs@oss.sgi.com>;
	Fri, 02 May 2014 16:35:26 -0700 (PDT)
Date: Sat, 3 May 2014 09:35:12 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: XFS filesystem claims to be mounted after a disconnect
Message-ID: <20140502233512.GE26353@dastard>
References: <5363A1D8.2020402@gmail.com> <5363B4C9.4000900@sandeen.net>
	<5363CB5E.3090008@gmail.com> <5363CD70.3000006@sandeen.net>
	<5363DBD7.4060002@gmail.com> <5363E65C.6010006@sandeen.net>
	<5363ECE8.6030706@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <5363ECE8.6030706@gmail.com>
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
Cc: Eric Sandeen <sandeen@sandeen.net>, xfs@oss.sgi.com

On Fri, May 02, 2014 at 10:07:20PM +0300, Martin Papik wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA512
> 
> > to be honest, I'm not certain; if it came back under the same
> > device name, things may have continued.  I'm not sure.

No, they won't. Because the disconnection breaks all references from
the filesystem to the original block device.

> Personally, I haven't seen it reconnect even once. I've seen disks
> fail to appear until the old references are removed, or even
> partitions not detecting until all is clean. Reconnecting, only on SW
> raid, and only when everything was just right.

Right, that's because sw raid probes the new drive, finds the MD/LVM
signature, and knows where it put. Nothing else does.

> > Somewhere in the vfs, the filesystem was still present in a way
> > that the ustat syscall reported that it was mounted. xfs_repair
> > uses this syscall to determine mounted state.  It called sys_ustat,
> > got an answer of "it's mounted" and refused to continue.
> > 
> > It refused to continue because running xfs_repair on a mounted
> > filesystem would lead to severe damage.
> 
> I understand that, and I'm okay with whatever I need to do in order to
> restore the FS after the failure, but it would be good to have xfs
> report the status correctly, i.e. show up in /proc/mounts UNTIL all
> resources are released. What do you think?

It's called a lazy unmount: "umount -l". It disconnects the
filesystem from the namespace, but it still lives on in the kernel
until all references to the filesystem go away. Given that the
hot-unplug proceedure can call back into the filesystem to
sync it (once it's been disconnected!) the hot unplug can deadlock
on filesystem locks that can't be released until the hot-unplug
errors everything out.

So you can end up with the system in an unrecoverable state when USB
unplugs.

> > If xfs encounters an insurmountable error, it will shut down, and
> > all operations will return EIO or EUCLEAN.  You are right that
> > there is no errors=* mount option; the behavior is not configurable
> > on xfs.
> 
> IMHO it should be, but since the last email I've glanced at some
> mailing lists and understand that there's some reluctance, in the name
> of not polluting the FS after an error. But at least a R/O remount
> should be possible, to prevent yanking libraries from under
> applications (root FS).

What you see here has nothing to do with XFS's shutdown behaviour.
The filesystem is already unmounted, it just can't be destroyed
because there are still kernel internal references to it.

> > documentation, that's probably something we should address.
> 
> Yup, any idea when? .... Also, I think it would be good to have a
> section on what to do when things go south and what to expect. E.g. I
> found out the hard way that xfs_check on a 2TB disk allocates 16G of
> memory, so now I'm running it with cgroup based limitations, otherwise

$ man xfs_check
....
Note that xfs_check is deprecated and scheduled for removal in June
2014. Please use xfs_repair -n instead.
....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
