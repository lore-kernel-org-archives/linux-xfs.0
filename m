Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:16577 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750888AbdAQGZG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 17 Jan 2017 01:25:06 -0500
Date: Mon, 16 Jan 2017 22:24:53 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [LSF/MM TOPIC] online filesystem repair
Message-ID: <20170117062453.GJ14038@birch.djwong.org>
References: <20170114075452.GJ14033@birch.djwong.org>
 <1484524890.27533.16.camel@dubeyko.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1484524890.27533.16.camel@dubeyko.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Viacheslav Dubeyko <slava@dubeyko.com>
Cc: lsf-pc@lists.linux-foundation.org, linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org, Vyacheslav.Dubeyko@wdc.com

On Sun, Jan 15, 2017 at 04:01:30PM -0800, Viacheslav Dubeyko wrote:
> On Fri, 2017-01-13 at 23:54 -0800, Darrick J. Wong wrote:
> > Hi,
> > 
> > I've been working on implementing online metadata scrubbing and
> > repair
> > in XFS.  Most of the code is self contained inside XFS, but there's a
> > small amount of interaction with the VFS freezer code that has to
> > happen
> > in order to shut down the filesystem to rebuild the extent backref
> > records.  It might be interesting to discuss the (fairly slight)
> > requirements upon the VFS to support repairs, and/or have a BoF to
> > discuss how to build an online checker if any of the other
> > filesystems
> > are interested in this.
> > 
> 
> How do you imagine a generic way to support repairs for different file
> systems? From one point of view, to have generic way of the online file
> system repairing could be the really great subsystem.

I don't, sadly.  There's not even a way to /check/ all fs metadata in a
"generic" manner -- we can use the standard VFS interfaces to read
all metadata, but this is fraught.  Even if we assume the fs can spot
check obviously garbage values, that's still not the appropriate place
for a full scan.

> But, from another point of view, every file system has own
> architecture, own set of metadata and own way to do fsck
> check/recovering.

Yes, and this wouldn't change.  The particular mechanism of fixing a
piece of metadata will always be fs-dependent, but the thing that I'm
interested in discussing is how do we avoid having these kinds of things
interact badly with the VFS?

> As far as I can judge, there are significant amount of research
> efforts in this direction (Recon [1], [2], for example).

Yes, I remember Recon.  I appreciated the insight that while it's
impossible to block everything for a full scan, it /is/ possible to
check a single object and its relation to other metadata items.  The xfs
scrubber also takes an incremental approach to verifying a filesystem;
we'll lock each metadata object and verify that its relationships with
the other metadata make sense.  So long as we aren't bombarding the fs
with heavy metadata update workloads, of course.

On the repair side of things xfs added reverse-mapping records, which
the repair code uses to regenerate damaged primary metadata.  After we
land inode parent pointers we'll be able to do the same reconstructions
that we can now do for block allocations...

...but there are some sticky problems with repairing the reverse
mappings.  The normal locking order for that part of xfs is sb_writers
-> inode -> ag header -> rmap btree blocks, but to repair we have to
freeze the filesystem against writes so that we can scan all the inodes.

> But we still haven't any real general online file system repair
> subsystem in the Linux kernel.

I think the ocfs2 developers have encoded some ability to repair
metadata over the past year, though it seems limited to fixing some
parts of inodes.  btrfs stores duplicate copies and restores when
necessary, I think.  Unfortunately, fixing disk corruption is something
that's not easily genericized, which means that I don't think we'll ever
achieve a general subsystem.

But we could at least figure out what in the VFS has to change (if
anything) to support this type of usage.

> Do you have some new insight? What's difference of your
> vision? If we have online file system repair subsystem then how file
> system driver will need to interact with the goal to make internal
> repairing?

It's pretty much all private xfs userspace ioctls[1] with a driver
program[2].

--D

[1] https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=djwong-devel
[2] https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=djwong-devel

> 
> Thanks,
> Vyacheslav Dubeyko.
> 
> [1] http://www.eecg.toronto.edu/~ashvin/publications/recon-fs-consistency-runtime.pdf
> [2] https://www.researchgate.net/publication/269300836_Managing_the_file_system_from_the_kernel
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
