Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:31187 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751399AbeBXWEb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 24 Feb 2018 17:04:31 -0500
Date: Sun, 25 Feb 2018 09:04:28 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfs_repair: add '-F' option to ignore writable mount checking
Message-ID: <20180224220428.GB30854@dastard>
References: <5A914B45.8080200@xtaotech.com>
 <5c0df437-0f09-129c-945f-0f917bfdaa7e@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5c0df437-0f09-129c-945f-0f917bfdaa7e@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Yang Joseph <joseph.yang@xtaotech.com>, sandeen@redhat.com, nathans@debian.org, linux-xfs@vger.kernel.org

On Sat, Feb 24, 2018 at 11:56:44AM -0600, Eric Sandeen wrote:
> On 2/24/18 5:23 AM, Yang Joseph wrote:
> > hello,
> > 
> > Before the repair process, xfs_repair will check if user specified device already
> > has a writable mountpoint. And it will stat all the mountpoints of the system. If there
> > is a dead mountpoint, this checking will be blocked and xfs_repair will enter 'D' state.

So why is the mount point dead?

That kinda means that the filesystem is still mounted, but something
has hung somewhere and the filesystem may still have active
references to the underlying device and be doing stuff that is
modifying the filesystem....

And if the device is still busy, then you aren't going to be able to
mount the repaired device, anyway, because the block device is still
busy...

> That sounds like a bug worth fixing, but I am much
> less excited about adding options which could do serious damage
> to a filesystem.

TO me it sounds like something that should be fixed by a reboot, not
by adding dangerous options to xfs_repair...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
