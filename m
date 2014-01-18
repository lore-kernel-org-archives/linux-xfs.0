Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id E252629E0F
	for <xfs@oss.sgi.com>; Fri, 17 Jan 2014 21:13:02 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 690CEAC001
	for <xfs@oss.sgi.com>; Fri, 17 Jan 2014 19:12:59 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	09yWgrxqDBaHBwYE for <xfs@oss.sgi.com>;
	Fri, 17 Jan 2014 19:12:54 -0800 (PST)
Date: Sat, 18 Jan 2014 14:12:47 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [RFC 00/17] RFC parent inode pointers.
Message-ID: <20140118031247.GE18112@dastard>
References: <20140115220012.624438534@sgi.com> <20140116055607.GR3431@dastard>
	<52D99FD2.6000601@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <52D99FD2.6000601@sgi.com>
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

On Fri, Jan 17, 2014 at 03:25:38PM -0600, Mark Tinguely wrote:
> On 01/15/14 23:56, Dave Chinner wrote:
> >On Wed, Jan 15, 2014 at 04:00:12PM -0600, Mark Tinguely wrote:
> >>Yeah, yeah, this has gotten buried several times and better get out on
> >>the list for discussion before it gets buried yet again.
> >>
> >>Parent inode support allow XFS to quickly derive a file name and
> >>path from the mount point. This can aid in directory/path policies
> >>and can help relocate items during filesystem shrink.
> >>
> >>  1) Representation of a parent inode entry:
> >>
> >>  There are several ways to represent the parent inode entry.
> >>  A 2005 XFS meeting came up with the following ideas:
> >>
> >>   1) Storing the parent inode# list inside the inode with a separate field
> >>      separate fork
> >
> >Too complex, rejected in the first few minutes of discussion.
> >
> >>   2) Storing the parent inode# list in EA names with null values
> >>      EA:<name=inode#, value=NULL>
> >
> >Not uniquely identifying the filename of the inode in parent
> >directory, so can't tell if name that points to inode is current.
> >Hard links are impossible to handle.  never implemented.
> >
> >>   3) As in (2) but store the 1st parent inode# in a field in the inode
> >>      first-parent-ptr +<name=inode#, value=NULL>
> >
> >Same problem, didn't handle hard links. Also not enough space in the
> >inode core to implement.
> >
> >>   4) As in (2) but store the hardlink names as EA values
> >>      EA:<name=inode#, value=fname>
> >
> >Same problem as 2, but added complexity in requiring multiple code
> >paths to keep parent pointers up to date.  Never answered the
> >question of "when we remove the parent in the inode, who is the new
> >"primary" parent? Never implemented.
> >
> >>   5) As in (2) but store the EAs on directories as well as leaf files
> >>      EAs on directories.
> >
> >Tried to solve problems with 4) by adding more information to
> >directories. Even more complex, had problems with uniquely
> >identifying hard links, really convoluted transaction contexts and
> >locking.  Never implemented.
> >
> >>   6) Storing the parent inode# + directory offset in EA names with null values
> >>      EA:<name=inode#diroffset, value=NULL>
> >
> >Uniquely identifies the directory entry *slot*, but does not
> >necessarily identify correct filename.  Handled hard links if you
> >ignore the parent identity uniqueness issue, but demonstrated
> >unscalable name lookup behaviour.
> 
> how is this the wrong file name?

Because you can have a lookup/unlink/link race occur that puts a
different dirent at the directory offset between the EA lookup and
the locking of the parent directory. I suspect a lookup/rename race
could result in the same problem.

> How is a directory xfs_readname() in a ioctl unscalable?

So you do a million reverse lookups. That requires a million ioctl
calls to look up the reverse name attribute, plus a million times
the directory depth of the child calls to read directory entries.
i.e. the operation itself is fine, but it's the fact that it's
required at all that is the scalability problem. i.e. random reverse name
lookups will cause random directory IO to be done, and that does not
scale to doing millions of lookups in a short period of time.

> Adding file names to a EA, that limits scalability. Having to do a
> EA sequential lookup in the remove/rename data paths to find a EA to
> remove, that is unscalable.

Yup, it does that, but that's just a basic, brute force wildcard
search algorithm.  I never said the 2009 patchset was perfect, just
that it solves all the known problems and fulfils all the requires
I've ever heard for parent pointer use cases and scalability.
ie. for the majority of use cases, this behaviour is never going to
be noticed as the attributes will be in line or in a single external
leaf and iterated extremely quickly. 

Perhaps there's another tweak we can do to the attribute format that
makes this search on removal behaviour go away. Perhaps all we need
is an optimised attribute tree search-and-destroy operation....

> >>  The preferred method was #6.
> >
> >As it was, this once looked like the solution. IIRC, this was the
> >design that was implemented for Irix and shipped in 6.5.28 but was
> >never used in production by anyone because of problems that became
> >apparent after it was shipped. It was fundamentally flawed, and
> >those flaws were uncovered when porting the Irix implementation to
> >Linux.
> >
> 
> The Irix 6.5.X does not use this method. It uses stripped down
> version of 2009 code. A <inode:generation> combination.

Ah, so it did keep the generation number. My mistake, I haven't been
able to look at that code for more than 5 years, and I don't have
any of the documentation that you have and keep referring to. :/

> >Using the directory offset was discovered to be problematic when
> >there were multiple hardlinks into the same directory for the same
> >inode. You can remove links and add links, and the only thing that
> >changes is the diroffset. Hence to do a safe reverse lookup, you
> >have to first lock the inode to stabilise the EA, then read the
> >parent pointer to get the parent directory, then get the parent
> >inode and lock it so that nobody is modifying it as we traverse it
> >during a offset->name lookup.
> 
> um, you are wrong, it is not this version of the code. It uses some
> inode/generation combination.

Sure, but your code doesn't use the inode/generation combination to
identify the parent, and so it has this problem. The fact I
misidentified what Irix implemented doesn't mean the problem I
described does not exist....

> >But this violated the VFS directory tree locking order, which is
> >parent->child.  Think about a racing unlink that has locked the
> >parent inode vs a parent pointer lookup that has lock the child and
> >is trying to lock the parent.  Once this problem was understood,
> >using directory offsets was considered a non-starter for the linux
> >port given how complex working around the inversion makes the
> >reverse path lookups.
> >
> >I note that Mark's patch set will not trip over this,
> >because the XFS_IOC_GETPARENTS_BY_HANDLE code never actually locks
> >the child inode the handle points to. IOWs, it isn't safe against
> >concurrent modification of the inode, and hence would never deadlock
> >even if the problem was seen. It's more likely to have caused
> >filesystem corruption or crashed.
> 
> It has locked in the attribute iteration code.

Only to read the attribute. Then the lock is dropped, and so the
inode and attribute can be modified concurrently. You then use that
parent inode number to look up the parent directory, but there is no
validation that the parent directory obtained is still the same
generation of the inode that the parent pointer attribute pointed
at.

IOWs, there's no locking at the child to stabilise the parent
pointer at parent lookup time, nor is there any checks that the
parent inode that is found is the version of the inode that the
parent pointer attribute was pointing at.

This code *needs* the parent inode generation number because of the
locking model it uses.

> I see your point on
> the locking order and we cannot use a callback to get the name.
> There are very simple solutions for that.

Such as?

> >Further, not storing the filename in the attribute value has
> >scalability limitations. A reverse lookup requires reading the
> >directory entry to get the filename, and so if you have large
> >directories and/or a large number of reverse lookups to perform the
> >cost is huge. Every lookup has to walk the bmbt tree to find the
> >directory data block that contains the offset, then it needs to be
> >read from disk, and then it needs to be iterated to find the correct
> >entry. It's a huge amount of work, and it's unnecessary because we
> >have the name of the file at the time the parent pointer EA is
> >created...
> 
> Happens only during the ioctl. The 2009 does far worse things in the
> data path.

Funnily enough, years ago we were always told that the reverse name
lookup was the performance critical path for DMF. i.e. we weren't
allowed to affect ongoing IO operations adversely when doing large
numbers of reverse lookups, and so we optimised for that. Indeed,
doing a single IO per reverse lookup was considered too much
overhead.

As such, you're missing a very important reason for putting the name
in the attribute - DMAPI has a special bulkstat implementation that
extracts in-line attributes along with the inode stat information.
The parent attribute hence could be read via a bulkstat scan, and
hence piggy-backed onto the DMF code that already did periodic scans
of the fileystem.

I have no idea whether DMF ever implemented this, but you should
begin to see why doing per-inode recursive readdir walks to
regenerate parent paths is about the least optimal method that can
be used - it simply can't be optimised into efficient bulk
operations that applications need to handle hundreds of millions of
inodes in a filesystem....

> >The solution that SGI then settled on was this:
> >
> >	9) EA:<name=inode#,generation,count>, value=<filename>
> >
> >It solved all the unique identifier problems, and the lookup
> >scalability issues and all the deadlocks, and that was what was
> >implemented in the patch posted here in 2009:
> >
> >	http://thread.gmane.org/gmane.comp.file-systems.xfs.general/27772
> >
> >With the addition of the inode generation number, we can look up the
> >parent inode without holding the child inode locked and know that we
> >got the right inode by verifying the inode/gen tuple match on the
> >inode we looked up.  However, we haven't got the child locked, so we
> >need to have some other method of knowing if the child is still in
> >the directory once it is locked. (e.g. unlink/link races).
> 
> The gen number changes only if the inode has been reallocated. You
> have a parent inode and a filename, but you would have to do a
> xfs_lookup to make sure that the parent is still the parent.

xfs_lookup() doesn't tell you that the parent is still the parent.
It only tells you that a pathname still exists. It could be a different
inode that this pathname points to. If the directory is removed and
the recreated immediately, it's different directory, but it might
have the same inode number, and the only difference is the
generation number.

Further, races with rename can change the parent directory path
without changing anything else - it doesn't change the child's
parent pointer information at all, and so using lookup to confirm
the path of the parent inode is correct is also racy and not
sufficient to validate the fact you have the correct parent inode.

Again, the only way to identify an inode uniquely when you do not
holds the necesary locks to stabilise the pointer and the pointee
is via the {inode, generation} pair. There is no other way this can
be done.

> >That's where the "count" field of the EA name comes from.  Each
> >inode keeps a separate "parent counter" attribute so that hard links
> >to the same directory can be uniquely identified by the EA name. The
> >initial inode create always uses a value of "1", and when the first
> >hardlink is added the special attribute is created with a value of
> >2, and that is used (and incremented) on every subsequent hard link.
> >Hence every hardlink has a unique attribute name/value pair.
> 
> This code has never be proven.

Which means what? It was proven to solve the problems that we knew
about at the time....

> It appears to me that this will
> prevent one kind of link/unlink race but to prevent the other, you
> need to hold the lock over the directory code and the EA code.
>
> >As a result, parent lookups (for path resolution or removal) can
> >match on ino/gen/value, knowing that if we race with an unlink and a
> >new hardlink of the *same name* there will be a second *unique*
> >parent pointer attribute (under a ino/gen/cnt+N name) that has the
> >same pointer information added to the tree for the new entry. Hence
> >it is safe to use whatever parent pointer attribute for a given
> >ino/gen/value we find because it is guaranteed to be valid for the
> >operation we are about to perform.
> 
> The other race is not getting the EA into the inode before trying to
> remove it.

Can't happen.

I'm not sure that you noticed that the 2009 patchset added
the parent EA in the same transaction that committed the directory
modifications (for create, mkdir and symlink). Hence wasn't in a
separate transaction and so the parent EA was created atomically
with the inode/dirent entry, so the race condition you are worried
about simple does not exist.

Further, even if we ignore the above and assume that the attribute
is added after the create transaction is committed and the inodes
are unlocked, there is no race on the child inode introduced here.
A link can't be unlinked until userspace can see the link,
and that happens when the dentry cache is updated to point at the
new link. That happens after the parent attribute is created, and so
we are guaranteed that there is always a parent EA to remove when
unlink is called.

i.e, all the races are on parent inode operations which invalidate
the child parent pointer. As such, the parent pointer object in the
child needs sufficient information to detect that the parent is
invalid....

> >A potential optimisation to improve it is that parent counter does
> >not need to be in an EA. It's 32 bits, so can easily be added to the
> >spare space in the v2 inode and avoid unnecessary attribute reads
> >and writes on parent pointer creation.
> >
> >Hence the parent pointer structure and implementation in 9) solves
> >all the known problems to do with hardlinks, scalability, locking
> >order, code complexity etc, and it has relatively little additional
> >runtime overhead. It also works for v4 filesystems - the proposed
> >patch set cannot be made to work on older filesystem structures as
> >there isn't room in the v2 inode for the fast-path fields.
> 
> I know you love 2009, but lets talk about it scalability:
>  1) larger EA will make xfs_rename/xfs_link slower, and limit the link
>     we can support.

Yes, it will be slightly slower, but it doesn't introduce any new
limitations on anything. Indeed, an EA was considered acceptible
per-operation overhead before we had delayed logging - it's no more
overhead than having a default ACL configured. And now all that an
additional EA costs really is CPU overhead. Given that CPU is rarely
the limiting factor for server workloads these days.....

>   why did they do this = to make an ioctl a bit faster?

Minimising the IO and cpu overhead of individual lookups was
considered extremely important for cases where large numbers of
random lookups were required - DMF reporting/auditing tools needed
to be able to do this for large number of individual filehandles at
random times and had bound runtime limits. The scale we were given
at the time (remember, this was 2005) was that it had to work well
for filesystems containing hundreds of millions of inodes and having
to do reverse lookups on a significant fraction of those inodes
*every few hours*.

Hence being able to use bulkstat to optimise large-scale reverse
lookups is a killer feature that only the "name in attribute" method
enables....

>   still need to do xfs_lookups to make sure the names are still valid.

Not necessarily - DMF listens to all the changes going on, so it can
track which pathname *components* have been moved, unlinked, etc and
so didn't need to revalidate the pathnames of every inode once it
had rebuilt them from filehandles - only those whose pathname
components where known to have changed.

>  2) in remove and rename data paths, it iterates over all the EAs
>     looking for the EA it must remove. That is a non-starter for me.

See my comments above about that.

> >>  On the other hand keeping the directory and extended attribute in one
> >>  transaction should keeping the changes atomic when the filesystem
> >>  is forced down between the directory and attribute changes. Despite
> >>  all the gore (see below) of doing the directory and attribute changes
> >>  in one transaction, I think it is the correct thing to do.
> >
> >Yes, I said that it was necessary a year ago and pointed you at how
> >to do it:
> >
> >http://xfs.org/index.php/Improving_Metadata_Performance_By_Reducing_Journal_Overhead#Atomic_Multi-Transaction_Operations
> >
> 
> That would limit the log space, but would not help in holding locks
> over the  directory and EA code. You think the counts solve that
> problem. It solves one problem but not all.

The problem you think is there doesn't actually exist in the
2009 patchset because it does hold the inode locks over dirent
and EA creation.

> The lock order problem in the getparents/getparentpaths is simple.

You've said that twice without describing the simple solution. Can
you describe your solution, please?

> But in any version, we cannot make sure the getparentpath paths are
> correct because of lock ordering at least with the .

Right, which is why the path reconstruction shouldn't be in the
kernel - they can be invalid even before we've finishe dthe path
walk, let alone retuned to userspace. With inode/gen being pushed to
userspace with the filename, userspace can reconstruct and validate
the pathname components individually and optimally....

Mark, don't get me wrong - the 2009 patchset is not perfect and it's
not finished and it simply reflects what we knew at the time. When I
refer to that patch, I'm comparing the architecture and design of
the different parent pointer approaches, not the implementation.
The design has to be sound before I care about the implementation
and quality of the code.  If we can't agree on basic architecture
and design points, then we are most definitely not going to agree on
the implementation. 

Right now, the design of thxp eproposed patchset does not address
the critical problem of identifier uniqueness and ignores the
bulk-lookup performance requirements that we know about. Addressing
those are going to require a change of on-disk attribute format in
that patch set and that invalidates the in-inode-core optimisations
that have been made. IOWs, we need to solve the problem first, then
optimise.

So, what do we need in the parent pointer attribute to solve all the
known problems? The implementation will flow cleanly from what we
can store on disk, and we know that we need at least these things to
solve all the known issues:

	* parent inode number and generation (unique identifier)
	* link disambiguation (unlink/link race detection)
	* filename (for bulk lookup performance)

So the question is how to implement the link disambiguation
efficiently. That is currently implemented in the 2009 patchset with
a the monotonic increasing counter that is appended to the attribute
name. Do we even need a generation count, or is there some other
info we can use that uniquely identifies a dirent?

While the diroffset of a filename is not unique enough to identify
the child, I think the {diroffset,filename,child_inode} tuple is
sufficient. That is, if the diroffset gets reused and points to a
different filename, we can detect that from the contents of EA and
abort. If a link of the same name is created, then we can check
whether it points at the same inode. If it does, then we just don't
care that there was a race because our current pointer is still
valid. And we don't need to store the child inode number in the EA -
we already have that in the child struct xfs_inode structure. That
verification can even be done in userspace.

Hence I think we've already got all the info we need if we make a
hybrid format from the two approaches:

	name=parent_inode,gen,diroffset	value=filename

The inode/gen gives all the information we need to reliably identify
the parent without requiring child->parent lock ordering, and allows
userspace to do pathname component level reconstruction without the
kernel ever needing to verify the parent itself as part of ioctl
calls.

And finally, by using the diroffset in the EA name, we have a method of
knowing the exact parent pointer EA we need to modify/remove in
rename/unlink without an unbound searching.

I think that solves all the architectural issues that we know
about with both implemenations.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
