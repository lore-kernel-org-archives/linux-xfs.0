Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:33591 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751453AbdHYFaH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 25 Aug 2017 01:30:07 -0400
Date: Thu, 24 Aug 2017 22:29:03 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: Filesystem configuration parsers - (was: Re: [RESEND][PATCH]
 xfs: add online uevent for mount operation)
Message-ID: <20170825052903.GE4800@magnolia>
References: <1503582115-37220-1-git-send-email-houtao1@huawei.com>
 <20170824171028.GF4796@magnolia>
 <20170824180441.GL27873@wotan.suse.de>
 <20170825010155.GK21024@dastard>
 <20170825012001.GY27873@wotan.suse.de>
 <20170825021830.GM21024@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170825021830.GM21024@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: "Luis R. Rodriguez" <mcgrof@kernel.org>, Hou Tao <houtao1@huawei.com>, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, Jeff Mahoney <jeffm@suse.com>, NeilBrown <neilb@suse.com>, Tso Ted <tytso@mit.edu>, Dmitri Pal <dpal@redhat.com>

On Fri, Aug 25, 2017 at 12:18:30PM +1000, Dave Chinner wrote:
> On Fri, Aug 25, 2017 at 03:20:01AM +0200, Luis R. Rodriguez wrote:
> > On Fri, Aug 25, 2017 at 11:01:55AM +1000, Dave Chinner wrote:
> > > On Thu, Aug 24, 2017 at 08:04:41PM +0200, Luis R. Rodriguez wrote:
> > > > While all this is nice, I'm sure we're all aware of the dangers of setting
> > > > things in stone through sysfs, its likely already decided for the above
> > > > tunables, but adding a uevent *is* yet another layer of user interface
> > > > which userspace can *expect* and we should be certain we want this so
> > > > we won't regress userspace later.
> > > > 
> > > > Just saying, we better damn be sure this is the way we want to go.
> > > 
> > > I'm not sure what you are trying to warn us about? :/
> > > 
> > > These are events on an XFS specific kobj, it's not a generic VFS
> > > filesystem event we are generating here. It's no different from a
> > > hardware device generating it's own uevents to tell userspace
> > > something changed in the device.
> > 
> > I meant that once its sent even if it is XFS specific, it will be
> > something that some userspace can expect and then we'd always have
> > to send it later.
> 
> Well, yes. Just like we have to support ioctls, /proc and /sysfs
> interfaces and the quota event interface essentially forever.
> There's nothing new or difficult about that.
> 
> > > A quick grep would have told you that GFS2 already has it's own
> > > online/offline uevents (e.g. gfs2_online_uevent()), as does the
> > > DLM code. Orangefs seems to use quite a few of uevent notifications,
> > > too. So it's not like we're doing something controversial or unique
> > > here, nor something that locks us out of a non-existent VFS event
> > > notification mechanism.
> > 
> > I don't think its controversial *at all*. Just that a mount uevent,
> > with uuid, sounds like something we could at least agree is pretty generic.

It's not a slam dunk -- look at all the rattling that went on when
overlayfs tried to use s_uuid.

> Yeah, right. Call me cynical, but every single time this has been
> brought up it devolves into a paint-fest where everyone wants
> something to be added before anything can be done because generic
> filesystem events is a deep, dark complex hole. e.g. think of bind
> mounts: go and develop arguments for and against whether we should
> send generic mount notifications for bind mounts. Generic doesn't
> mean simple.
>
> IOWs, what you describe as "pretty generic", I see as "a great big
> can of worms".

By my count there are 70 filesystems (in fs/ anyway) so the likelihood
of successfully coordinating the development of a common vfs uevent
anything is so low I wasn't even going to consider it.  I've proposed
patches that change things across all the filesystems before; it sucks,
and meh.

I don't see a problem with continuing to let individual filesystems
manage their own kobject attributes and events, but frankly I've found
it very useful to absorb a more diverse set of points of view by asking
other filesystem developers what they've done and what pain points they
might have hit.

What I'd really like to see is that XFS retains control of its per-fs
kobj.  We'll add FS UUID as an environment variable to the uevent patch
(XFS has uuids, no controversy there!) and run it by fsdevel to see if
anyone from the wider fsdevel audience can make a convincing argument to
add/remove/change the variables that get passed to the uevent, or even
to consider a different approach.  (This is what seems to be happening,
if in a somewhat incohesive manner.)  Then we do our usual rounds of
review and (presumably) merge it along with the appropriate xfsprogs
helper.

Since uevents can send freeform text to the uevent handler in the form
of environment variables, this means that any other fs project that
might be considering adding uevents can build on the keys we've created.
They can also do their own thing.  I've written udev rule files, it's
not difficult to adapt the ruleset to format shifts, at least not as
difficult as structure changes to an ABI.

IOWs, I'm looking for de facto coordination if/where desired, not a
heavy top down coordination process.  If your project doesn't like it,
you're not bound by it.

Maybe I should've been more explicit with what I was looking for, but
TBH in the email just prior to this thread being cc'd to fsdevel I
really was only asking the xfs list "should we take this to fsdevel or
just leave it here"?

--D

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
