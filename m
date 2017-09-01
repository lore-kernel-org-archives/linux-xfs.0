Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:63239 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752643AbdIAWzm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 1 Sep 2017 18:55:42 -0400
Date: Sat, 2 Sep 2017 08:55:39 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 1/3] xfs: Add rtdefault mount option
Message-ID: <20170901225539.GC10621@dastard>
References: <25856B28-A65C-4C5B-890D-159F8822393D@fb.com>
 <20170901043151.GZ10621@dastard>
 <C6F6823D-65D7-4B73-9AC7-CBA4125F2429@fb.com>
 <20170901193237.GF29225@bfoster.bfoster>
 <BF1D2F17-045E-4BF7-839D-FF7D0643329E@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BF1D2F17-045E-4BF7-839D-FF7D0643329E@fb.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Richard Wareing <rwareing@fb.com>
Cc: Brian Foster <bfoster@redhat.com>, "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>

[satuday morning here, so just a quick comment]

On Fri, Sep 01, 2017 at 08:36:53PM +0000, Richard Wareing wrote:
> > On Sep 1, 2017, at 12:32 PM, Brian Foster <bfoster@redhat.com> wrote:
> > 
> > On Fri, Sep 01, 2017 at 06:39:09PM +0000, Richard Wareing wrote:
> >> Thanks for the quick feedback Dave!  My comments are in-line below.
> >> 
> >> 
> >>> On Aug 31, 2017, at 9:31 PM, Dave Chinner <david@fromorbit.com> wrote:
> >>> 
> >>> Hi Richard,
> >>> 
> >>> On Thu, Aug 31, 2017 at 06:00:21PM -0700, Richard Wareing wrote:
> > ...
> >>>> add
> >>>> support for the more sophisticated AG based block allocator to RT
> >>>> (bitmapped version works well for us, but multi-threaded use-cases
> >>>> might not do as well).
> >>> 
> >>> That's a great big can of worms - not sure we want to open it. The
> >>> simplicity of the rt allocator is one of it's major benefits to
> >>> workloads that require deterministic allocation behaviour...
> >> 
> >> Agreed, I took a quick look at what it might take and came to a similar conclusion, but I can dream :).
> >> 
> > 
> > Just a side point based on the discussion so far... I kind of get the
> > impression that the primary reason for using realtime support here is
> > for the simple fact that it's a separate physical device. That provides
> > a basic mechanism to split files across fast and slow physical storage
> > based on some up-front heuristic. The fact that the realtime feature
> > uses a separate allocation algorithm is actually irrelevant (and
> > possibly a problem in the future).
> > 
> > Is that an accurate assessment? If so, it makes me wonder whether it's
> > worth thinking about if there are ways to get the same behavior using
> > traditional functionality. This ignores Dave's question about how much
> > of the performance actually comes from simply separating out the log,
> > but for example suppose we had a JBOD block device made up of a
> > combination of spinning and solid state disks via device-mapper with the
> > requirement that a boundary from fast -> slow and vice versa was always
> > at something like a 100GB alignment. Then if you formatted that device
> > with XFS using 100GB AGs (or whatever to make them line up), and could
> > somehow tag each AG as "fast" or "slow" based on the known underlying
> > device mapping,

Not a new idea. :)

I've got old xfs_spaceman patches sitting around somewhere for
ioctls to add such information to individual AGs. I think I called
them "concat groups" to allow multiple AGs to sit inside a single
concatenation, and they added a policy layer over the top of AGs
to control things like metadata placement....

> > could you potentially get the same results by using the
> > same heuristics to direct files to particular sets of AGs rather than
> > between two physical devices?

That's pretty much what I was working on back at SGI in 2007. i.e.
providing a method for configuring AGs with difference
characteristics and a userspace policy interface to configure and
make use of it....

http://oss.sgi.com/archives/xfs/2009-02/msg00250.html


> > Obviously there are some differences like
> > metadata being spread across the fast/slow devices (though I think we
> > had such a thing as metadata only AGs), etc.

We have "metadata preferred" AGs, and that is what the inode32
policy uses to place all the inodes and directory/atribute metadata
in the 32bit inode address space. It doesn't get used for data
unless the rest of the filesystem is ENOSPC.

> > I'm just handwaving here to
> > try and better understand the goal.

We've been down these paths many times - the problem has always been
that the people who want complex, configurable allocation policies
for their workload have never provided the resources needed to
implement past "here's a mount option hack that works for us".....

> Sorry I forgot to clarify the origins of the performance wins
> here.   This is obviously very workload dependent (e.g.
> write/flush/inode updatey workloads benefit the most) but for our
> use case about ~65% of the IOP savings (~1/3 journal + slightly
> less than 1/3 sync of metadata from journal, slightly less as some
> journal entries get canceled), the remainder 1/3 of the win comes
> from reading small files from the SSD vs. HDDs (about 25-30% of
> our file population is <=256k; depending on the cluster).  To be
> clear, we don't split files, we store all data blocks of the files
> either entirely on the SSD (e.g. small files <=256k) and the rest
> on the real-time HDD device.  The basic principal here being that,
> larger files MIGHT have small IOPs to them (in our use-case this
> happens to be rare, but not impossible), but small files always
> do, and when 25-30% of your population is small...that's a big
> chunk of your IOPs.

So here's a test for you. Make a device with a SSD as the first 1TB,
and you HDD as the rest (use dm to do this). Then use the inode32
allocator (mount option) to split metadata from data. The filesysetm
will keep inodes/directories on the SSD and file data on the HDD
automatically.

Better yet: have data allocations smaller than stripe units target
metadata prefferred AGs (i.e. the SSD region) and allocations larger
than stripe unit target the data-preferred AGs. Set the stripe unit
to match your SSD/HDD threshold....

[snip]

> The AG based could work, though it's going to be a very hard sell
> to use dm mapper, this isn't code we have ever used in our storage
> stack.  At our scale, there are important operational reasons we
> need to keep the storage stack simple (less bugs to hit), so
> keeping the solution contained within XFS is a necessary
> requirement for us.

Modifying the filesysetm on-disk format is far more complex than
adding dm to your stack. Filesystem modifications are difficult and
time consuming because if we screw up, users lose all their data.

If you can solve the problem with DM and a little bit of additional
in-memory kernel code to categorise and select which AG to use for
what (i.e. policy stuff that can be held in userspace), then that is
the pretty much the only answer that makes sense from a filesystem
developer's point of view....

Start by thinking about exposing AG behaviour controls through sysfs
objects and configuring them at mount time through udev event
notifications.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
