Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id C21997F62
	for <xfs@oss.sgi.com>; Mon, 27 Jan 2014 21:00:50 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 7F265304053
	for <xfs@oss.sgi.com>; Mon, 27 Jan 2014 19:00:47 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	RFXN0RYBubnjf00R for <xfs@oss.sgi.com>;
	Mon, 27 Jan 2014 19:00:45 -0800 (PST)
Date: Tue, 28 Jan 2014 14:00:40 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [RFC 00/17] RFC parent inode pointers.
Message-ID: <20140128030040.GG2212@dastard>
References: <20140115220012.624438534@sgi.com> <20140116055607.GR3431@dastard>
	<52D99FD2.6000601@sgi.com> <20140118031247.GE18112@dastard>
	<52E6B67B.6070001@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <52E6B67B.6070001@sgi.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Mark Tinguely <tinguely@sgi.com>
Cc: xfs@oss.sgi.com

On Mon, Jan 27, 2014 at 01:41:47PM -0600, Mark Tinguely wrote:
> On 01/17/14 21:12, Dave Chinner wrote:
> 
> <massive delete we can go over it point by point if necessary, but let
>  us start here>.
> 
> 1) Yep, the parent inode generation number is needed. I thought I said
>    it was, bad on me if I did not. It was an RFC and I was too lazy to
>    go back and add it in.
> 
> 2) Add the filename to EA. Not a fan, but I will ask but if DMF needs it
>    for performance then it has to be done. My point was this assumes
>    that we can keep all the links' EA entries inline in the inode. A
>    couple 255 character files or several links of modest sized filenames
>    would negate that assumption. I tried to minimize the EA entries to
>    keep them inline in the inode. I will talk to the DMF group.

Actually, I made the point about DMF needing them inline performance
because that's an argument SGI might find persuasive. What I didn't
say just then is that *I* need them inline, too, as online directory
tree scrubbing needs to be able to do bulks scans, as does
xfs_repair. However, I have idefinitely said this before in previous
parent poitner discussions, so it should be no surprise here...

> 3) There is a unlink/link race because the directory and EA changes
>    are done without a common lock. I hit this in testing.

Because your patch set didn't contain the necessary link
discrimination information in the parent EA and so serialisation was
required?

>      ln a filename1 (EA saved to inode)
>      rm filename1
>      ln a filename1 (EA not saved because it is a duplicate)

Why wasn't the parent EA removed in the 'rm filename1' syscall
context? You can't do a link operation while an unlink is in
progress because of the VFS directory mutex serialising namespace
operations. The only way I can see this happening is if you are
bypassing the VFS. i.e. this is a CXFS problem, yes?

>                     (rm EA operation happens and removes the only PIP
>                      entry)
>      rm filename1 (no EA entry error)
> 
> * My speculation from counters and my testing.
> 
>       i) Why not add the lock to keep the directory/EA changes in sync?

We don't need to add a lock - we already have one in the parent
inode lock.  We can tell xfs_trans_commit() not to unlock objects
during the commit. i.e. using xfs_trans_ijoin(... 0) rather than
xfs_trans_ijoin(... XFS_ILOCK_EXCL) ensures an inode is not unlocked
during a commit and so we can do multiple rolling transactions on
that inode without unlocking it.

This is used throughout the attribute code so that the multiple
transactions needed to modify attributes are done atomically, same
as we do in xfs_inactive(), xfs_itruncate_extents(), etc. The same
needs to be done for the parent EA code, regardless of how we do the
multiple transactions.

>      ii) 2009 code required duplicate EA entries to compensate.
>           A) Required a counter/inode to make every link unique.
>              Granted this counter could be in a inode field.
>           B) Required a EA walk to find one of the duplicates entries
>              for the remove.
>              i) Mark no likey, much bitching and moaning...
>           C) More below.

Yes, we know you don't like the implementation it used to provide
link discrimination. I've already proposed a way to fix the issues
you have with it, so let's move on....

> >Mark, don't get me wrong - the 2009 patchset is not perfect and it's
> >not finished and it simply reflects what we knew at the time. When I
> >refer to that patch, I'm comparing the architecture and design of
> >the different parent pointer approaches, not the implementation.
> >The design has to be sound before I care about the implementation
> >and quality of the code.  If we can't agree on basic architecture
> >and design points, then we are most definitely not going to agree on
> >the implementation.
> >
> >Right now, the design of the proposed patchset does not address
> >the critical problem of identifier uniqueness and ignores the
> >bulk-lookup performance requirements that we know about. Addressing
> >those are going to require a change of on-disk attribute format in
> >that patch set and that invalidates the in-inode-core optimisations
> >that have been made. IOWs, we need to solve the problem first, then
> >optimise.
> >
> >So, what do we need in the parent pointer attribute to solve all the
> >known problems? The implementation will flow cleanly from what we
> >can store on disk, and we know that we need at least these things to
> >solve all the known issues:
> >
> >	* parent inode number and generation (unique identifier)
> 
> agreed
> 
> >	* link disambiguation (unlink/link race detection)
> 
> why allow a unlink/link race?

I mentioned it as an example in the context of the discussion.  Even
if we can avoid the link/unlink races, we still need link
disambiguation - we have to be able to do this to be able to use
parent pointers for validating and repairing the directory
structure.

> >	* filename (for bulk lookup performance)

The filename is needed for directory structure validation and
repair, too.

Indeed, this is the primary reason I want parent pointers - for
xfs_repair and online filesystem scrubbing. If you don't have the
parent pointer giving all the information necessary to validate that
reverse and forward links match precisely, then you cannot use them
for validation and repair purposes.

For example, something went bad, and we then end up
with an inode with two parent pointers that point to the same
directory. The parent directory has one pointer to the inode, so
there's a dangling link on the child inode. Now, how do you tell if
we should connect the link back up to the parent, or whether we
should remove the EA from the child?

If we don't have the filename in the child's EA, then we can't
recover missing the parent dir entry at all - there's no redundant
information to work from. Hence we can only trash one of the child's
EAs and update it's link count. If the child has the filename and
the dir offset, then we can check if the dir_offset in the parent is
empty, and if it is we can reconnect the directory to the child.
Otherwise we trash the child's EA.

The killer repair feature, however, is that we can rebuild the
entire directory structure if inode parent EAs have filenames in
them.  With the name, unique parent identifier and directory offset,
we can find all the unique directory entries that made up the
missing parent directory and reconstruct it. IOWs, we can recover
the entire filesystem from a lost root inode without leaving large
amounts of work for users to reconstruct the directory structure
from lost_found. IOWs, we can mostly remove the need for lost+found
with correctly structured parent pointers...

> >So the question is how to implement the link disambiguation
> >efficiently. That is currently implemented in the 2009 patchset with
> >a the monotonic increasing counter that is appended to the attribute
> >name. Do we even need a generation count, or is there some other
> >info we can use that uniquely identifies a dirent?
> >
> >While the diroffset of a filename is not unique enough to identify
> >the child, I think the {diroffset,filename,child_inode} tuple is
> >sufficient. That is, if the diroffset gets reused and points to a
> >different filename, we can detect that from the contents of EA and
> >abort. If a link of the same name is created, then we can check
> >whether it points at the same inode. If it does, then we just don't
> >care that there was a race because our current pointer is still
> >valid. And we don't need to store the child inode number in the EA -
> >we already have that in the child struct xfs_inode structure. That
> >verification can even be done in userspace.
> >
> >Hence I think we've already got all the info we need if we make a
> >hybrid format from the two approaches:
> >
> >	name=parent_inode,gen,diroffset	value=filename
> >
> >The inode/gen gives all the information we need to reliably identify
> >the parent without requiring child->parent lock ordering, and allows
> >userspace to do pathname component level reconstruction without the
> >kernel ever needing to verify the parent itself as part of ioctl
> >calls.
> >
> >And finally, by using the diroffset in the EA name, we have a method of
> >knowing the exact parent pointer EA we need to modify/remove in
> >rename/unlink without an unbound searching.
> >
> >I think that solves all the architectural issues that we know
> >about with both implemenations.
> 
> Thinking out loud:
> 
> EA names have to be unique.

Yes, but they need to be unique in a way that we can calculate from
the context of operations on the child inode so we can avoid
searching the attr tree for a matching name/value pair.

> A link/unlink/link EA sequence would have to do a EA RENAME (overwrite
>  the duplicate EA with new name).

I'm afraid I don't follow you here - if EA names are unique, then
what exactly are we renaming? And if parent EA operations are atomic
with the directory name operations, then how can we ever get a
problem w.r.t. duplicate names as the directory operation will
prevent that from happening?

> Have to do either:
>  Do a EA lookup and compare before remove.

I assume you mean "compare value before remove", because an EA
remove already does a EA lookup first to find the attribute location
in the attr tree before doing a remove. If the attr name is not
found, the ENOATTR is returned.

> or
>  Add a new EA command that removes a name/value pair.

Which is trivial to add to the existing xfs_attr_remove() codepath.
I'm not sure it solves anything, though, if we use link
disambiguation to provide unique names and serialise EAs to
create/link/unlink/rename correctly.

> Not sure if this would work on more than one unlink/link race and seems
> like this would still not work if filename of the 2 links are
> the same.
> 
> Leaving a known race makes me a bit queezy.

I've never proposed that we leave a known race *unhandled*. Races
don't have to be handled by locks - locks are the easiest way to
handle them, but not necessarily the best way. There are plenty of
race conditions in the code that are handled at the sites where the
race condition can be *reliably detected*.

> My internal version uses
> locks, but I were clear that you did not like the locks and so they were
> not included in the RFC.

You should *never* make assumptions about what any reviewer might
say about code that they've never seen.  I expect developers to post
code that reflects the current state of their knowledge of a
problem. That's especially true for proposals and RFCs where holding
back information is frequently harmful to the discussion, and makes
people disinclined to engage with you in future.

Please don't make that mistake again.

Cheers,

Dave.

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
