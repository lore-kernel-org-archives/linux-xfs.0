Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail01.adl6.internode.on.net ([150.101.137.136]:11552 "EHLO
        ipmail01.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752761AbdIBW4N (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 2 Sep 2017 18:56:13 -0400
Date: Sun, 3 Sep 2017 08:56:09 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 1/3] xfs: Add rtdefault mount option
Message-ID: <20170902225609.GE10621@dastard>
References: <25856B28-A65C-4C5B-890D-159F8822393D@fb.com>
 <20170901043151.GZ10621@dastard>
 <C6F6823D-65D7-4B73-9AC7-CBA4125F2429@fb.com>
 <20170901193237.GF29225@bfoster.bfoster>
 <BF1D2F17-045E-4BF7-839D-FF7D0643329E@fb.com>
 <20170901225539.GC10621@dastard>
 <67F62657-D116-4B85-9452-5BAB52EC7041@fb.com>
 <20170902115545.GA36492@bfoster.bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170902115545.GA36492@bfoster.bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: Richard Wareing <rwareing@fb.com>, "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>

On Sat, Sep 02, 2017 at 07:55:45AM -0400, Brian Foster wrote:
> On Fri, Sep 01, 2017 at 11:37:37PM +0000, Richard Wareing wrote:
> > 
> > > On Sep 1, 2017, at 3:55 PM, Dave Chinner <david@fromorbit.com> wrote:
> > > 
> > > [satuday morning here, so just a quick comment]
> > > 
> > > On Fri, Sep 01, 2017 at 08:36:53PM +0000, Richard Wareing wrote:
> > >>> On Sep 1, 2017, at 12:32 PM, Brian Foster <bfoster@redhat.com> wrote:
> > >>> 
> > >>> On Fri, Sep 01, 2017 at 06:39:09PM +0000, Richard Wareing wrote:
> > >>>> Thanks for the quick feedback Dave!  My comments are in-line below.
> > >>>> 
> > >>>> 
> > >>>>> On Aug 31, 2017, at 9:31 PM, Dave Chinner <david@fromorbit.com> wrote:
> > >>>>> 
> > >>>>> Hi Richard,
> > >>>>> 
> > >>>>> On Thu, Aug 31, 2017 at 06:00:21PM -0700, Richard Wareing wrote:
> > >>> ...
> > >>>>>> add
> > >>>>>> support for the more sophisticated AG based block allocator to RT
> > >>>>>> (bitmapped version works well for us, but multi-threaded use-cases
> > >>>>>> might not do as well).
> > >>>>> 
> > >>>>> That's a great big can of worms - not sure we want to open it. The
> > >>>>> simplicity of the rt allocator is one of it's major benefits to
> > >>>>> workloads that require deterministic allocation behaviour...
> > >>>> 
> > >>>> Agreed, I took a quick look at what it might take and came to a similar conclusion, but I can dream :).
> > >>>> 
> > >>> 
> > >>> Just a side point based on the discussion so far... I kind of get the
> > >>> impression that the primary reason for using realtime support here is
> > >>> for the simple fact that it's a separate physical device. That provides
> > >>> a basic mechanism to split files across fast and slow physical storage
> > >>> based on some up-front heuristic. The fact that the realtime feature
> > >>> uses a separate allocation algorithm is actually irrelevant (and
> > >>> possibly a problem in the future).
> > >>> 
> > >>> Is that an accurate assessment? If so, it makes me wonder whether it's
> > >>> worth thinking about if there are ways to get the same behavior using
> > >>> traditional functionality. This ignores Dave's question about how much
> > >>> of the performance actually comes from simply separating out the log,
> > >>> but for example suppose we had a JBOD block device made up of a
> > >>> combination of spinning and solid state disks via device-mapper with the
> > >>> requirement that a boundary from fast -> slow and vice versa was always
> > >>> at something like a 100GB alignment. Then if you formatted that device
> > >>> with XFS using 100GB AGs (or whatever to make them line up), and could
> > >>> somehow tag each AG as "fast" or "slow" based on the known underlying
> > >>> device mapping,
> > > 
> > > Not a new idea. :)
> > > 
> 
> Yeah (what ever is? :P).. I know we've discussed having more controls or
> attributes of AGs for various things in the past. I'm not trying to
> propose a particular design here, but rather trying to step back from
> the focus on RT and understand what the general requirements are
> (multi-device, tiering, etc.).

Same here :P

> I've not seen the pluggable allocation
> stuff before, but it sounds like that could suit this use case perfectly.

Yup, there's plenty of use cases for it, but not enough resources to
go round...

> > > I've got old xfs_spaceman patches sitting around somewhere for
> > > ioctls to add such information to individual AGs. I think I called
> > > them "concat groups" to allow multiple AGs to sit inside a single
> > > concatenation, and they added a policy layer over the top of AGs
> > > to control things like metadata placement....
> > > 
> 
> Yeah, the alignment thing is just the first thing that popped in my head
> for a thought experiment. Programmatic knobs on AGs via ioctl() or sysfs
> is certainly a more legitimate solution.

Yeah, it matches nicely with the configurable error handling via
sysfs - mount the filesystem, get a uevent, read the config file,
punch in the customised allocation config via sysfs knobs...

> > >>> I'm just handwaving here to
> > >>> try and better understand the goal.
> > > 
> > > We've been down these paths many times - the problem has always been
> > > that the people who want complex, configurable allocation policies
> > > for their workload have never provided the resources needed to
> > > implement past "here's a mount option hack that works for us".....
> > > 
> 
> Yep. To be fair, I think what Richard is doing is an interesting and
> useful experiment. If one wants to determine whether there's value in
> directing files across separate devices via file size in a constrained
> workload, it makes sense to hack up things like RT and fallocate()
> because they provide the basic mechanisms you'd want to take advantage
> of without having to reimplement that stuff just to prove a concept.

Yes, that's how one prototypes and tests a hypothesis quickly... :)

> The challenge of course is then realizing when you're done that this is
> not a generic solution. It abuses features/interfaces in ways they were
> not designed for, disrupts traditional functionality, makes assumptions
> that may not be valid for all users (i.e., file size based filtering,
> number of devices, device to device ratios), etc. So we have to step
> back and try to piece together a more generic, upstream-worthy approach.

*nod*

> To your point, it would be nice if those exploring these kind of hacks
> would contribute more to that upstream process rather than settle on
> running the "custom fit" hack until upstream comes around with something
> better on its own. ;) (Though sending it out is still better than not,
> so thanks for that. :)

Yes, we do tend to set the bar quite high for new functionality.
Years of carrying around complex, one-off problem solutions that
don't quite work properly except in the original environment they
were designed for and are pretty much unused by anyone else (*cough*
filestreams *cough*) makes me want to avoid more one-off allocation
hacks and instead find a more generic solution...

> > >> The AG based could work, though it's going to be a very hard sell
> > >> to use dm mapper, this isn't code we have ever used in our storage
> > >> stack.  At our scale, there are important operational reasons we
> > >> need to keep the storage stack simple (less bugs to hit), so
> > >> keeping the solution contained within XFS is a necessary
> > >> requirement for us.
> > > 
> 
> I am obviously not at all familiar with your storage stack and the
> requirements of your environment and whatnoat. It's certainly possible
> that there's some technical reason you can't use dm, but I find it very
> hard to believe that reason is "there might be bugs" if you're instead
> willing to hack up and deploy a barely tested feature such as XFS RT.
> Using dm for basic linear mapping (i.e., partitioning) seems pretty much
> ubiquitous in the Linux world these days.

Yup, my thoughts exactly.

> > > Modifying the filesysetm on-disk format is far more complex than
> > > adding dm to your stack. Filesystem modifications are difficult and
> > > time consuming because if we screw up, users lose all their data.
> > > 
> > > If you can solve the problem with DM and a little bit of additional
> > > in-memory kernel code to categorise and select which AG to use for
> > > what (i.e. policy stuff that can be held in userspace), then that is
> > > the pretty much the only answer that makes sense from a filesystem
> > > developer's point of view....
> > > 
> 
> Yep, agreed.
> 
> > > Start by thinking about exposing AG behaviour controls through sysfs
> > > objects and configuring them at mount time through udev event
> > > notifications.
> > > 
> > 
> > Very cool idea.  A detail which I left out which might complicate this, is we only use 17GB of SSD for each ~8-10TB HDD (we share just a small 256G SSD for about 15 drives), and even then we don't even use 50% of the SSD for these partitions.  We also want to be very selective about what data we let touch the SSD, we don't want folks who write large files by doing small IO to touch the SSD, only IO to small files (which are immutable in our use-case).
> > 
> 
> I think Dave's more after the data point of how much basic metadata/data
> separation helps your workload. This is an experiment you can run to get
> that behavior without having to write any code (maybe a little for the
> stripe unit thing ;).

Yup - the "select AG based on initial allocation size" criteria
would need some extra code in xfs_bmap_btalloc() to handle properly.

> If there's a physical device size limitation,
> perhaps you can do something crazy like create a sparse 1TB file on the
> SSD, map that to a block device over loop or something and proceed from
> there.

That'd work, but probably wouldn't perform all that well given the
added latency of the loop device...

> Though I guess that since this is a performance experiment, a better
> idea may be to find a bigger SSD or concat 4 of the 256GB devices into
> 1TB and use that, assuming you're able to procure enough devices to run
> an informative test.

I think it would be simpler to just use xfs_db to remove all the
space beyond 17GB in the first AG by modifying the freespace record
that mkfs lays down. i.e.  just shorten it to 17GB from "all of AG",
and the first AG will only have 17GB of space to play with.  Some
AGF and SB free space accounting would need to be modified as well
(to account for the lost space), but the result would be 1TB AGs and
AG 0 only having the first 17GB available for use, which matches the
SSD partitions exactly. It would also need mkfs to place the log in
ag 0, too (mkfs -l agnum=0 ....).

Again, this is a hack you could use for testing - the moment you run
xfs_repair it'll return the "lost space" in AG 0 to the free pool,
and it won't work unless you modify the freesapce records/accounting
again. It would, however, largely tell us whether we can acheive the
same performance outcome without needing the RT device....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
