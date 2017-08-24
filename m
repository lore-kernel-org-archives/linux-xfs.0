Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail04.adl6.internode.on.net ([150.101.137.141]:12871 "EHLO
        ipmail04.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751005AbdHXBA4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 23 Aug 2017 21:00:56 -0400
Date: Thu, 24 Aug 2017 11:00:52 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH RFC 0/3] xfs: add customizable default values for error
 configuration
Message-ID: <20170824010052.GD21024@dastard>
References: <1503316462-16553-1-git-send-email-houtao1@huawei.com>
 <20170821225003.GR10621@dastard>
 <6b4f210c-4ea3-4a9d-b7ea-e60480be76e2@huawei.com>
 <20170824001637.GB21024@dastard>
 <20170824004609.GD4796@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170824004609.GD4796@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Hou Tao <houtao1@huawei.com>, linux-xfs@vger.kernel.org, cmaiolino@redhat.com

On Wed, Aug 23, 2017 at 05:46:09PM -0700, Darrick J. Wong wrote:
> On Thu, Aug 24, 2017 at 10:16:37AM +1000, Dave Chinner wrote:
> > On Wed, Aug 23, 2017 at 05:26:36PM +0800, Hou Tao wrote:
> > > Hi Dave,
> > > 
> > > On 2017/8/22 6:50, Dave Chinner wrote:
> > > > On Mon, Aug 21, 2017 at 07:54:19PM +0800, Hou Tao wrote:
> > > >> Hi all,
> > > >>
> > > >> XFS has the configurable error handlers for each mounted device, but
> > > >> the default values of these configuration are static. It will be useful
> > > >> to make the default values customizable when there are many XFS filesystems
> > > >> and we need to shutdown the filesystem after getting any error.
> > > > 
> > > > Nice! I can see the usefulness of this functionality - it's a piece
> > > > of the puzzle we are missing. I've had a quick look over the code,
> > > > and have a few high level questions that I can't answer from looking
> > > > at the code.
> > > > Was there any reason you decided to put the default policy
> > > > management into the kernel rather than try to provide a mechanism to
> > > > allow userspace to manage it (e.g. via a udev event at mount time)?
> > > No special reason for the kernel-side default policy, just because I didn't
> > > find an uevent for the mount event. If the uevent is available or added (?),
> > > writing an udev rule to set the default error configuration seems simpler and
> > > works for our scenario.
> > 
> > I think we'd need to add one, but given we already have a kobj for
> > the filesystem being mounted, it seems to me like we should be able
> > to add a mount notification without too much trouble via
> > kobject_uevent(KOBJ_ONLINE)
> 
> <ENGAGE BIKESHED MODE>
> 
> It might be useful to think more broadly about modifying XFS to send
> uevents.  In addition to sending KOBJ_ONLINE to broadcast the mount to
> error configuration tools, we could (in the future say) schedule online
> fscks with a service manager.  Or we could send KOBJ_CHANGE notices when
> we hit IO errors, or someone remounts the fs with different options?
> 
> <END BIKESHED MODE>

Agreed, that's what I'd like to be able to do in the future. Let's
make the small step first of being able to emit an online event,
because that has no other information passed with it that can trap
us into a corner in future. Other events and custom events are
outside the scope of error config injection at mount time....

> > > Yes, I agree that the notifier method is over-weighted, and the proposed method
> > > is much better. However it has no way to reset the "use default flag" of a specific
> > > configuration when the modified default value is modified again to a new value when
> > > the old default value is equal with the current specific value. Maybe the reset is
> > > unnecessary ?
> > 
> > In that case I think the reset is unnecessary. The fact the default
> > was changed to match a specific filesystem config doesn't mean that
> > filesystem should start using the defaults. i.e. if you want to
> > reset the filesystem to default config, then you need to rewrite
> > it's config to match the current defaults.
> > 
> > It's a bit clunky, but it's a simple rule that's easy to understand
> > and it keeps the API and both the kernel and userspace code really
> > simple.
> 
> Or we just program the knobs to accept 'default', whatever the kernel
> thinks that is?

Same concept, really - userspace needs to rewrite the config to tell
the kernel to return to using the defaults - it's just a slightly
different API mechanism to do so. Using the "default" keyword for
this is fine by me....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
