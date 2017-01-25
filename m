Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:50789 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751260AbdAYIln (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 25 Jan 2017 03:41:43 -0500
Date: Wed, 25 Jan 2017 00:41:33 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [LSF/MM TOPIC] online filesystem repair
Message-ID: <20170125084133.GC5726@birch.djwong.org>
References: <20170114075452.GJ14033@birch.djwong.org>
 <1484524890.27533.16.camel@dubeyko.com>
 <20170117062453.GJ14038@birch.djwong.org>
 <SN2PR04MB2191A5D379B5C1A1BA0AB9A0887F0@SN2PR04MB2191.namprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <SN2PR04MB2191A5D379B5C1A1BA0AB9A0887F0@SN2PR04MB2191.namprd04.prod.outlook.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Slava Dubeyko <Vyacheslav.Dubeyko@wdc.com>
Cc: Viacheslav Dubeyko <slava@dubeyko.com>, "lsf-pc@lists.linux-foundation.org" <lsf-pc@lists.linux-foundation.org>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>

On Wed, Jan 18, 2017 at 12:37:02AM +0000, Slava Dubeyko wrote:
> 
> -----Original Message-----
> From: Darrick J. Wong [mailto:darrick.wong@oracle.com] 
> Sent: Monday, January 16, 2017 10:25 PM
> To: Viacheslav Dubeyko <slava@dubeyko.com>
> Cc: lsf-pc@lists.linux-foundation.org; linux-fsdevel@vger.kernel.org; linux-xfs@vger.kernel.org; Slava Dubeyko <Vyacheslav.Dubeyko@wdc.com>
> Subject: Re: [LSF/MM TOPIC] online filesystem repair
>  
> > > How do you imagine a generic way to support repairs for different file 
> > > systems? From one point of view, to have generic way of the online 
> > > file system repairing could be the really great subsystem.
> >
> > I don't, sadly.  There's not even a way to /check/ all fs metadata
> > in a "generic" manner -- we can use the standard VFS interfaces to read
> > all metadata, but this is fraught.  Even if we assume the fs can spot check obviously
> > garbage values, that's still not the appropriate place for a full scan.
> 
> Let's try to imagine a possible way of generalization. I can see such
> critical points:
> (1) mount operation;
> (2) unmount/fsync operation;
> (3) readpage;
> (4) writepage;
> (5) read metadata block/node;
> (6) write/flush metadata block/node.
> (7) metadata's item modification/access.
> 
> Let's imagine that file system will register every metadata structure
> in generic online file checking subsystem. Then the file system will

That sounds pretty harsh.  XFS (and ext4) hide quite a /lot/ of
metadata.  We don't expose the superblocks, the free space header, the
inode header, the free space btrees, the inode btrees, the reverse
mapping btrees, the refcount btrees, the journal, or the rtdev space
data.  I don't think we ought to expose any of that except to xfsprogs.
For another thing, there are dependencies between those pieces of
metadata, (e.g. the AGI has to work before we can check the inobt) and
one has to take those into account when scrubbing.

ext4 has a different set of internal metadata, but the same applies
there too.

> need to register some set of checking methods or checking events for
> every registered metadata structure. For example:
>
> (1) check_access_metadata();
> (2) check_metadata_modification();
> (3) check_metadata_node();
> (4) check_metadata_node_flush();
> (5) check_metadata_nodes_relation().

How does the VFS know to invoke these methods on a piece of internal
metadata that the FS owns and updates at its pleasure?  The only place
we encode all the relationships between pieces of metadata is in the fs
driver itself, and that's where scrubbing needs to take place.  The VFS
only serves to multiplex the subset of operations that are common across
all filesystems; everything else take the form of (semi-private) ioctls.

> I think that it is possible to consider several possible level of
> generic online file system checking subsystem's activity: (1) light
> check mode; (2) regular check mode; (3) strict check mode.
>
> The "light check mode" can  be resulted in "fast" metadata nodes'
> check on write operation with generation of error messages in the
> syslog with the request to check/recover file system volume by means
> of fsck tool.
> 
> The "regular check mode" can be resulted in: (1) the checking of any
> metadata modification with trying to correct the operation in the
> modification place; (2) metadata nodes' check on write operation with
> generation of error messages in the syslog. 
>
> The "strict check mode" can be resulted in: (1) check mount operation
> with trying to recover the affected metadata structures; (2) the
> checking of any metadata modification with trying to correct the
> operation in the modification place; (3) check and recover metadata
> nodes on flush operation; (4) check/recover during unmount operation.

I'm a little unclear about where you're going with all three of these
things; the XFS metadata verifiers already do limited spot-checking of
all metadata reads and writes without the VFS being directly involved.
The ioctl performs more intense checking and cross-checking of metadata
that would be too expensive to do on every access.

> What do you like to expose to VFS level as generalized methods for
> your implementation?

Nothing.  A theoretical ext4 interface could look similar to XFS's, but
the metadata-type codes would be different.  btrfs seems so much
different structurally there's little point in trying.

I also looked at ocfs2's online filecheck.  It's pretty clear they had
different goals and ended up with a much different interface.

> > > But, from another point of view, every file system has own 
> > > architecture, own set of metadata and own way to do fsck 
> > > check/recovering.
> >
> > Yes, and this wouldn't change.  The particular mechanism of fixing a piece of
> > metadata will always be fs-dependent, but the thing that I'm interested in
> > discussing is how do we avoid having these kinds of things interact badly with the VFS?
> 
> Let's start from the simplest case. You have the current
> implementation.  How do you see the way to delegate to VFS some
> activity in your implementation in the form of generalized methods?
> Let's imagine that VFS will have some callbacks from file system side.
> What could it be?
> 
> > > As far as I can judge, there are significant amount of research 
> > > efforts in this direction (Recon [1], [2], for example).
> >
> > Yes, I remember Recon.  I appreciated the insight that while it's impossible
> > to block everything for a full scan, it /is/ possible to check a single object and
> > its relation to other metadata items.  The xfs scrubber also takes an incremental
> > approach to verifying a filesystem; we'll lock each metadata object and verify that
> > its relationships with the other metadata make sense.  So long as we aren't bombarding
> > the fs with heavy metadata update workloads, of course.
> >
> > On the repair side of things xfs added reverse-mapping records, which the repair code
> > uses to regenerate damaged primary metadata.  After we land inode parent pointers
> > we'll be able to do the same reconstructions that we can now do for block allocations...
> >
> > ...but there are some sticky problems with repairing the reverse mappings.
> > The normal locking order for that part of xfs is sb_writers
> > -> inode -> ag header -> rmap btree blocks, but to repair we have to
> > freeze the filesystem against writes so that we can scan all the inodes.
> 
> Yes, the necessary freezing of file system is really tricky point.
> From one point of view, it is possible to use "light checking mode"
> that will simply check and complain about possible troubles at proper
> time (maybe with remount in RO mode).

Yes, scrub does this fairly lightweight checking -- no freezing, no
remounting, etc.  If checking something would mean violating locking
rules (which would require a quiesced fs) then we simply hope that the
scan process eventually checks it via the normative locking paths.
For example, the rmapbt scrubber doesn't cross reference inode extent
records with the inode block maps because we lock inode -> agf ->
rmapbt; it relies on the scrub program eventually locking the inode to
check the block map and then cross-referencing with the rmap data.

For repair (of only the rmap data) we have to be able to access
arbitrary files, so that requires a sync and then shutting down the
filesystem while we do it, so that nothing else can lock inodes.  I
don't know if this is 100% bulletproof; the fsync might take the fs down
before we even get to repairing.

Really what this comes down to is a discussion of how to suspend user
IOs temporarily and how to reinitialize the mm/vfs view of a part of the
world if the filesystem wants to do that.

> Otherwise, from another point of view, we need in special file system
> architecture or/and special way of VFS functioning. Let's imagine that
> file system volume will be split on some groups/aggregations/objects
> with dedicated metadata.  Then, theoretically, VFS is able to freeze
> such group/aggregation/object for check and recovering without
> affection the availability of the whole file system volume. It means
> that file system operations should be redirected into active (not
> frozen) groups/aggregations/objects.

One could in theory teach XFS how to shut down AGs, which would redirect
block/inode allocations elsewhere.  Freeing would be a mess though.  My
goal is to make scrub & repair fast enough that we don't need that.

--D

>  
> Thanks,
> Vyacheslav Dubeyko.
> 
> Western Digital Corporation (and its subsidiaries) E-mail Confidentiality Notice & Disclaimer:
> 
> This e-mail and any files transmitted with it may contain confidential or legally privileged information of WDC and/or its affiliates, and are intended solely for the use of the individual or entity to which they are addressed. If you are not the intended recipient, any disclosure, copying, distribution or any action taken or omitted to be taken in reliance on it, is prohibited. If you have received this e-mail in error, please notify the sender immediately and delete the e-mail in its entirety from your system.
> 
