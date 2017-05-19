Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:52027 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751049AbdESQeh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 19 May 2017 12:34:37 -0400
Message-Id: <1495211669.1931975.982263184.0F641F32@webmail.messagingengine.com>
From: Colin Walters <walters@verbum.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
Date: Fri, 19 May 2017 12:34:29 -0400
In-Reply-To: <20170519152734.qd4lf32e7wst4jdh@thunk.org>
References: <20170519002032.GA21202@birch.djwong.org>
 <1495202431.1896310.982081664.066926F8@webmail.messagingengine.com>
 <20170519152734.qd4lf32e7wst4jdh@thunk.org>
Subject: Re: [PATCH] vfs: freeze filesystems just prior to reboot
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Theodore Ts'o <tytso@mit.edu>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, xfs <linux-xfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-ext4 <linux-ext4@vger.kernel.org>

On Fri, May 19, 2017, at 11:27 AM, Theodore Ts'o wrote:
> 
> One of the things that came up when Darrick and I discussed this on
> the weekly ext4 developer's conference call was our mutual wonderment
> that none of the userspace tools implemented a reboot by created a
> tmpfs chroot, pivoting into the chroot, and then unmounting all of the
> remaining file systems.

On general purpose systems we have a tmpfs chroot already: the initramfs.
Although IIRC, systemd will only switch back to it on shutdown I think only
if you have a root storage daemon enabled:
https://www.freedesktop.org/wiki/Software/systemd/RootStorageDaemons/

That said I'd like to focus on the harder case: supporting powerloss/system lockup on
single-partition systems.  IMO, the shutdown case is just a special variant
of that where the user asked nicely for the system to halt =)
(See also https://en.wikipedia.org/wiki/Crash-only_software)

I was thinking about this a bit, and I think if userspace tools (like ostree)
*delayed* their updates to /boot until shutdown, then we could ensure
that on powerloss, the system is unchanged.  (In a traditional dpkg/rpm
scenario where you only have one userspace root, you'd end up with
old kernel + new rootfs, but that's exactly the problem ostree solves)

That narrows the problem down to keeping `/boot` consistent at
shutdown time.  AIUI, a problem here is that XFS doesn't flush the
journal on `syncfs`, only on unmount?  And from what I can tell,
even the `XFS_IOC_FREEZE` ioctl won't do that either.

So as far as I can see, a userspace API to ensure the journal is
flushed on a mounted filesystem is going to be necessary for
the general case.  I don't have a strong opinion on whether or not
that's `syncfs()` - if it's e.g. a `XFS_IOC_FREEZE` `_THAW` pair
that seems OK to me too.
