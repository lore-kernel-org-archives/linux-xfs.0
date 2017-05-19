Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:27378 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752294AbdESTmG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 19 May 2017 15:42:06 -0400
Date: Fri, 19 May 2017 12:41:57 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] vfs: freeze filesystems just prior to reboot
Message-ID: <20170519194157.GK4519@birch.djwong.org>
References: <20170519002032.GA21202@birch.djwong.org>
 <1495202431.1896310.982081664.066926F8@webmail.messagingengine.com>
 <20170519152734.qd4lf32e7wst4jdh@thunk.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170519152734.qd4lf32e7wst4jdh@thunk.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Theodore Ts'o <tytso@mit.edu>
Cc: Colin Walters <walters@verbum.org>, xfs <linux-xfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-ext4 <linux-ext4@vger.kernel.org>

On Fri, May 19, 2017 at 11:27:34AM -0400, Theodore Ts'o wrote:
> On Fri, May 19, 2017 at 10:00:31AM -0400, Colin Walters wrote:
> > As a maintainer of one of those userspace tools (https://github.com/ostreedev/ostree),
> > which I don't think is the one in question here, but likely has the same
> > issue - I'd like to have some sort of API to fix this - maybe flush the journal *without*
> > remounting r/o?
> > 
> > Unlike the case you're talking about with rebooting into a special
> > update mode, libostree constructs a new root with hardlinks while
> > the system is running.  Hence, system downtime is just reboot, like
> > dual-partition update systems, except we're more flexible.
> > 
> > Although hm...I guess an API to flush the journal would only narrow
> > the race.
> > 
> > Is the single partition case really just doomed?
> 
> One of the things that came up when Darrick and I discussed this on
> the weekly ext4 developer's conference call was our mutual wonderment
> that none of the userspace tools implemented a reboot by created a
> tmpfs chroot, pivoting into the chroot, and then unmounting all of the
> remaining file systems.

systemd seems to have the ability to do this -- if something dumps an
executable into /run/initramfs/shutdown (and remounts /run with 'exec')
then systemd will pivot to this script which can then kill everything it
needs and then unmount the filesystems.  Or upgrade the fs.  Seeing as
the rootfs is still mounted ro at the point that the shutdown script is
run, it could pull in whatever tools it wants.

Or inject malware, I guess. :P

In any case, I don't think it's unreasonable to want a system updater to
be able to detect that the fs containing with vmlinuz and initrd hasn't
unmounted at the end of the upgrade, and therefore it needs to resort to
stronger tactics to forcibly unmount it before systemd reboots.

> This would also allow update schemes who want to enable various new
> file system features, or upgrade the root file system somehow, to be
> able to do so while the root file system is completely and cleanly
> unmounted.
> 
> The other thing that would be useful is if grub2 would actually be
> able to replay the file system journal --- but given that grub2 is

Gross! :)

I don't think the XFS community will be enthusiastic about supporting
whatever wreckage may come out of that.

> GPLv3, and both ext4 and xfs are GPLv2-only, and given that past
> attempts of teams attempting to do clean room reimplementations of
> complex code bases for licensing reasons only (cough, make_ext4fs,
> *cough*) have not necessarily turned out well, I'm at least not going
> to hold my breath.

Err... yes, but that's a different thread altogether.

--D

> 
>    	   			- Ted
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
