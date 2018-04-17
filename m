Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:22404 "EHLO
        ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751113AbeDQW2O (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 17 Apr 2018 18:28:14 -0400
Received: from dave by dastard with local (Exim 4.80)
        (envelope-from <david@fromorbit.com>)
        id 1f8Z58-0008SN-P7
        for linux-xfs@vger.kernel.org; Wed, 18 Apr 2018 08:28:10 +1000
Date: Wed, 18 Apr 2018 08:28:10 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 0/3] xfs: detect corrupt inobt records better
Message-ID: <20180417222810.GK23861@dastard>
References: <20180417063916.13069-1-david@fromorbit.com>
 <20180417091341.vurzhrjfeds76xgh@odin.usersys.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180417091341.vurzhrjfeds76xgh@odin.usersys.redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

On Tue, Apr 17, 2018 at 11:13:41AM +0200, Carlos Maiolino wrote:
> > However, v5 is still not safe against is malicious corruption, where
> > a bad actor intentionally modifies the on-disk structures to mark
> > inodes free in both the inobt and the finobt and then recalculates
> > the CRCs and other metadata. We could check the rmapbt if it's
> > configured, but an attacker can also manipulate that structure to
> > say that region does contain inodes. They can also manipulate the
> > free space btrees to say it's used space and so once we've chased
> > everything we can cross-check down we still can't reliably detect
> > malicious corruption attacks on the v5 filesystem structure.
> > 
> > IOWs, even with all the extra on-disk verification the v5 format
> > has, the only thing we can do to protect against propagation of
> > malicious corruption is the same thing as for v4: check the inode is
> > free on disk before allowing the allocation to proceed.
> > 
> > I have not done this, because I think malicious corruption is not
> > something we can defend against. Hence it makes no sense to add
> > checks that reduce performance but don't provide any extra
> > benefit to device-based corruption detection or propagation
> > prevention. IOWs, I don't think we should try to mitigate
> > malicious corruption attack scenarios.
> > 
> > I think we need to keep improving our bounds checking and structure
> > corruption detection, but we should not worry about things that take
> > multiple, highly improbably structure corruptions that are hihgly
> > expensive to detect and/or mitigate. i.e.  unprivileged mounts of
> > untrusted XFS filesystem images should never, ever be allowed.
> > 
> 
> I agree with it, recently, I had a discussion with Eric about something similar,
> and well, this sort of attack requires some access to the filesystem image
> itself, or the device where it lays on. And well, IMHO, in a system, if
> somebody is ever allowed to do such modifications in the filesystem, the
> security problem is way above the filesystem itself, either by allowing
> unprivileged access to the FS image, or superuser being compromised.

*nod*

> Either way, I do not believe we will ever be able to 100% protect the superuser
> against himself, or bad administrative policies even so if such protection would
> be a performance trade-off.

It's not so much protecting the superuser from themselves, it's
laying out the case for the container environment as to why untrusted
user mounts of third party filesystem images won't be allowed for
XFS. i.e. we simply cannot verify the metadata is actually safe to
interpret in kernel space by parsing it in kernel space.

This goes for ext4 as well, and probably ever other Linux filesystem
that lacks a cryptographically verifiable on-disk structure.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
