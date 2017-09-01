Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:58497 "EHLO
        ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750896AbdIAEby (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 1 Sep 2017 00:31:54 -0400
Date: Fri, 1 Sep 2017 14:31:51 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 1/3] xfs: Add rtdefault mount option
Message-ID: <20170901043151.GZ10621@dastard>
References: <25856B28-A65C-4C5B-890D-159F8822393D@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <25856B28-A65C-4C5B-890D-159F8822393D@fb.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Richard Wareing <rwareing@fb.com>
Cc: linux-xfs@vger.kernel.org

Hi Richard,

On Thu, Aug 31, 2017 at 06:00:21PM -0700, Richard Wareing wrote:
> Hello all, 
> 
> It turns out, XFS real-time volumes are actually a very
> useful/cool feature, I am wondering if there is support in the
> community to make this feature a bit more user friendly, easier to
> operate and interact with. To kick things off I bring patches
> table :).
> 
> For those who aren't familiar with real-time XFS volumes, they are
> basically a method of storing the data blocks of some files on a
> separate device. In our specific application, are using real-time
> devices to store large files (>256KB) on HDDS, while all metadata
> & journal updates goto an SSD of suitable endurance & capacity.

Well that's interesting. How widely deployed is this? We don't do a
whole lot of upstream testing on the rt device, so I'm curious to
know about what problems you've had to fix to get it to wrok
reliably....

> We
> also see use-cases for this for distributed storage systems such
> as GlusterFS which are heavy in metadata operations (80%+ of
> IOPs). By using real-time devices to tier your XFS filesystem
> storage, you can dramatically reduce HDD IOPs (50% in our case)
> and dramatically improve metadata and small file latency (HDD->SSD
> like reductions).

IMO, this isn't really what I'd call "tiered" storage - it's just a
data/metadata separation. Same as putting your log on an external
device to separate the journal IO from user IO isn't tiering.... :)

FWIW, using an external log for fsync heavy workloads reduces data
device IOPS by roughly 50%, and that seems to match what you are
saying occurs in your workloads by moving data IO to a separate
device from the log.  So now I'm wondering - is the reduction in
IOPS on your HDDs reflecting the impact of separating journal
commits from data writes? If not, where is the 50% of the IOPS that
aren't data and aren't journal going in your workloads?

> Here are the features in the proposed patch set:
> 
> 1. rtdefault  - Defaulting block allocations to the real-time
> device via a mount flag rtdefault, vs using an inheritance flag or
> ioctl's. This options gives users tier'ing of their metadata out
> of the box with ease,

As you've stated, we already have per-inode flags for this, but from
what you've said I'm not sure you realise that we don't need a mount
option for "out of the box" data-on-rtdev support. i.e.  mkfs
already provides "out of the box" data-on-rtdev support:

# mkfs.xfs -r rtdev=/dev/rt -d rtinherit=1 /dev/data

> and in a manner more users are familiar with
> (mount flags), vs having to set inheritance bits or use ioctls
> (many distributed storage developers are resistant to including FS
> specific code into their stacks).

Even with a rtdefault mount option, admins would still have to use
'chattr -R -r' to turn off use of the rt device by default because
removing the mount option doesn't get rid of the on-disk inode flags
that control this behaviour.

Maybe I'm missing something, but I don't see what this mount option
makes simpler or easier for users....

> 2. rtstatfs  - Returning real-time block device free space instead
> of the non-realtime device via the "rtstatfs" flag. This creates
> an experience/semantics which is a bit more familiar to users if
> they use real-time in a tiering configuration. "df" reports the
> space on your HDDs, and the metadata space can be returned by a
> tool like xfs_info (I have patches for this too if there is
> interest) or xfs_io. I think this might be a bit more intuitive
> for the masses than the reverse (having to goto xfs_io for the HDD
> space, and df for the SSD metadata).

Yep, useful idea. We already have a mechanism for reporting
different information to statfs depending on what is passed to it.
We use that to report directory tree quota information instead of
filesystem wide information. See the project id inode flag hooks at
the end of xfs_fs_statfs().

Similar could be done here - if statfs is pointed at a RT
file/directory, report rt device usage. If it's pointed at a the
root directory, report data device information.

> 3. rtfallocmin - This option can be combined with either rtdefault
> or standalone. When combined with rtdefault, it uses fallocate as
> "signal" to *exempt* storage on the real-time device,
> automatically promoting small fallocations to the SSD, while
> directing larger ones (or fallocation-less creations) to the HDD.

Hmmmm. Abusing fallocate to control allocation policy is kinda
nasty. I'd much prefer we work towards a usable allocation policy
framework rather than encode one-off hacks like this into the
filesystem behaviour.

> This option also works really well with tools like "rsync" which
> support fallocate (--preallocate flag) so users can easily
> promote/demote files to/from the SSD.

That's a neat hack, but it's not a viable adminisitration policy
interface :/

> Ideally, I'd like to help build-out more tiering features into XFS
> if there is interest in the community, but figured I'd start with
> these patches first.  Other ideas/improvements: automatic eviction
> from SSD once file grows beyond rtfallocmin,

You could probably already do that right now with fanotify +
userspace-based atomic data mover (i.e. xfs_fsr).

Keep in mind any time you say "move data around when ..." I'll
probably reply "you can use xfs_fsr for that". "fsr" = "file system
reorganiser" and it's sole purpose in life is to transparently move
data around the filesystem....

> automatic fall-back
> to real-time device if non-RT device (SSD) is out of blocks,

If you run the data device out of blocks, you can't allocate blocks
for the new metadata that has to be allocated to track the data held
in the RT device.  i.e.  running the data device out of space is
a filesystem wide ENOSPC condition even if there's still space
in the rt device for the data.

> add
> support for the more sophisticated AG based block allocator to RT
> (bitmapped version works well for us, but multi-threaded use-cases
> might not do as well).

That's a great big can of worms - not sure we want to open it. The
simplicity of the rt allocator is one of it's major benefits to
workloads that require deterministic allocation behaviour...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
