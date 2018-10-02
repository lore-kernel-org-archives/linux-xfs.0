Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmailnode02.adl6.internode.on.net ([150.101.137.148]:58202
        "EHLO ipmailnode02.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726731AbeJCF2X (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 3 Oct 2018 01:28:23 -0400
Date: Wed, 3 Oct 2018 08:42:40 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Leaking Path in XFS's ioctl interface(missing LSM check)
Message-ID: <20181002224240.GP18567@dastard>
References: <20180926013329.GD31060@dastard>
 <20180926192426.472360ea@alans-desktop>
 <20180927013812.GF31060@dastard>
 <20180930151652.6975610c@alans-desktop>
 <20181001002521.GM31060@dastard>
 <20181001160442.47c798bc@alans-desktop>
 <20181001154459.GB5872@magnolia>
 <alpine.LRH.2.21.1810020608090.14406@namei.org>
 <20181001224528.GI18567@dastard>
 <alpine.LRH.2.21.1810030518240.17817@namei.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.21.1810030518240.17817@namei.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: James Morris <jmorris@namei.org>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, Alan Cox <gnomes@lxorguk.ukuu.org.uk>, TongZhang <ztong@vt.edu>, linux-xfs@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, linux-security-module@vger.kernel.org, Wenbo Shen <shenwenbosmile@gmail.com>, Stephen Smalley <sds@tycho.nsa.gov>, Paul Moore <paul@paul-moore.com>

On Wed, Oct 03, 2018 at 05:20:31AM +1000, James Morris wrote:
> On Tue, 2 Oct 2018, Dave Chinner wrote:
> 
> > On Tue, Oct 02, 2018 at 06:08:16AM +1000, James Morris wrote:
> > > On Mon, 1 Oct 2018, Darrick J. Wong wrote:
> > > 
> > > > If we /did/ replace CAP_SYS_ADMIN checking with a pile of LSM hooks,
> > > 
> > > Not sure we'd need a pile of hooks, what about just "read" and "write" 
> > > storage admin?
> > > 
> > > Or even two new capabilities along these lines, which we convert existing 
> > > CAP_SYS_ADMIN etc. to?
> > 
> > So instead of having hundreds of management ioctls under
> > CAP_SYS_ADMIN, we'd now have hundreds of non-storage ioctls under
> > CAP_SYS_ADMIN and hundreds of storage ioctls under
> > CAP_SYS_STORAGE_ADMIN?
> > 
> > Maybe I'm missing something, but I don't see how that improves the
> > situation w.r.t. locked down LSM configurations?
> 
> I'm not sure about capabilities, but having two specific LSM hooks for 
> storage admin would allow SELinux et al to explicitly control privileged 
> access to these interfaces.  Storage admin seems to be a special case of 
> its own which we want to be able to mediate as such.

Perhaps so - as a stepping stone it would allow isolation in
specific cases where no management should be allowed, but there are
cases with modern filesystems where users need access to storage
APIs.

e.g. It's entirely plausible that /home is set up as a subvolume per
user, and that subvols in a fileystem can be independently
snapshotted. Hence it would be completely acceptible to allow users
to have access to snapshot management APIs to be able to snapshot
their home directories for backup/rollback purposes.

Hence I'm not sure that black/white storage admin LSM hooks are a
solution that will end up being particularly useful to the wider
population...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
