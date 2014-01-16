Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id DBC9B7F3F
	for <xfs@oss.sgi.com>; Wed, 15 Jan 2014 23:56:18 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id CEE198F8037
	for <xfs@oss.sgi.com>; Wed, 15 Jan 2014 21:56:15 -0800 (PST)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	ScWVDelpGe394Q68 for <xfs@oss.sgi.com>;
	Wed, 15 Jan 2014 21:56:12 -0800 (PST)
Date: Thu, 16 Jan 2014 16:56:07 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [RFC 00/17] RFC parent inode pointers.
Message-ID: <20140116055607.GR3431@dastard>
References: <20140115220012.624438534@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140115220012.624438534@sgi.com>
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

On Wed, Jan 15, 2014 at 04:00:12PM -0600, Mark Tinguely wrote:
> Yeah, yeah, this has gotten buried several times and better get out on
> the list for discussion before it gets buried yet again.
> 
> Parent inode support allow XFS to quickly derive a file name and
> path from the mount point. This can aid in directory/path policies
> and can help relocate items during filesystem shrink.
> 
>  1) Representation of a parent inode entry:
> 
>  There are several ways to represent the parent inode entry.
>  A 2005 XFS meeting came up with the following ideas:
> 
>   1) Storing the parent inode# list inside the inode with a separate field
>      separate fork

Too complex, rejected in the first few minutes of discussion.

>   2) Storing the parent inode# list in EA names with null values
>      EA: <name=inode#, value=NULL>

Not uniquely identifying the filename of the inode in parent
directory, so can't tell if name that points to inode is current.
Hard links are impossible to handle.  never implemented. 

>   3) As in (2) but store the 1st parent inode# in a field in the inode
>      first-parent-ptr + <name=inode#, value=NULL>

Same problem, didn't handle hard links. Also not enough space in the
inode core to implement. 

>   4) As in (2) but store the hardlink names as EA values
>      EA: <name=inode#, value=fname>

Same problem as 2, but added complexity in requiring multiple code
paths to keep parent pointers up to date.  Never answered the
question of "when we remove the parent in the inode, who is the new
"primary" parent? Never implemented.

>   5) As in (2) but store the EAs on directories as well as leaf files
>      EAs on directories.

Tried to solve problems with 4) by adding more information to
directories. Even more complex, had problems with uniquely
identifying hard links, really convoluted transaction contexts and
locking.  Never implemented.

>   6) Storing the parent inode# + directory offset in EA names with null values
>      EA: <name=inode#diroffset, value=NULL>

Uniquely identifies the directory entry *slot*, but does not
necessarily identify correct filename.  Handled hard links if you
ignore the parent identity uniqueness issue, but demonstrated
unscalable name lookup behaviour.

>  The preferred method was #6.

As it was, this once looked like the solution. IIRC, this was the
design that was implemented for Irix and shipped in 6.5.28 but was
never used in production by anyone because of problems that became
apparent after it was shipped. It was fundamentally flawed, and
those flaws were uncovered when porting the Irix implementation to
Linux.

Using the directory offset was discovered to be problematic when
there were multiple hardlinks into the same directory for the same
inode. You can remove links and add links, and the only thing that
changes is the diroffset. Hence to do a safe reverse lookup, you
have to first lock the inode to stabilise the EA, then read the
parent pointer to get the parent directory, then get the parent
inode and lock it so that nobody is modifying it as we traverse it
during a offset->name lookup.

But this violated the VFS directory tree locking order, which is
parent->child.  Think about a racing unlink that has locked the
parent inode vs a parent pointer lookup that has lock the child and
is trying to lock the parent.  Once this problem was understood,
using directory offsets was considered a non-starter for the linux
port given how complex working around the inversion makes the
reverse path lookups.

I note that Mark's patch set will not trip over this,
because the XFS_IOC_GETPARENTS_BY_HANDLE code never actually locks
the child inode the handle points to. IOWs, it isn't safe against
concurrent modification of the inode, and hence would never deadlock
even if the problem was seen. It's more likely to have caused
filesystem corruption or crashed.

Further, not storing the filename in the attribute value has
scalability limitations. A reverse lookup requires reading the
directory entry to get the filename, and so if you have large
directories and/or a large number of reverse lookups to perform the
cost is huge. Every lookup has to walk the bmbt tree to find the
directory data block that contains the offset, then it needs to be
read from disk, and then it needs to be iterated to find the correct
entry. It's a huge amount of work, and it's unnecessary because we
have the name of the file at the time the parent pointer EA is
created...

>   7) (kind of (4) + (6))
>      EA: <name=inode#diroffset, value=filename>

This mostly solved the reverse lookup deadlock because it was no
longer necessary to read the parent directory to find the filename.
It didn't solve it entirely, though, because of the parent inode
uniqueness issue.  We still have to hold the child locked to
guarantee that when we look up the parent inode number it matches
what is in the EA, and so we still have to lock the path from
child->parent->root in volation of the VFs lock ordering.  First
Linux solution considered, never implemented.

	8) EA: <name=inode#,generation,diroffset>, value=<filename>

Solved the deadlock problems, the scalability problems, and
uniqueness. Early implementation showed up more flaws with using the
directory offset and multiple hard links into the same directory -
we could get races with unlink/link loads failing parent attribute
creation because there was already an attribute of that name on the
inode. This was because of the fact that inode locks are dropped
during transaction commits between directory and attribute
modifications. Hence we could lose parent pointers silently under
such workloads.

The solution that SGI then settled on was this:

	9) EA: <name=inode#,generation,count>, value=<filename>

It solved all the unique identifier problems, and the lookup
scalability issues and all the deadlocks, and that was what was
implemented in the patch posted here in 2009:

	http://thread.gmane.org/gmane.comp.file-systems.xfs.general/27772

With the addition of the inode generation number, we can look up the
parent inode without holding the child inode locked and know that we
got the right inode by verifying the inode/gen tuple match on the
inode we looked up.  However, we haven't got the child locked, so we
need to have some other method of knowing if the child is still in
the directory once it is locked. (e.g. unlink/link races).

That's where the "count" field of the EA name comes from.  Each
inode keeps a separate "parent counter" attribute so that hard links
to the same directory can be uniquely identified by the EA name. The
initial inode create always uses a value of "1", and when the first
hardlink is added the special attribute is created with a value of
2, and that is used (and incremented) on every subsequent hard link.
Hence every hardlink has a unique attribute name/value pair.

As a result, parent lookups (for path resolution or removal) can
match on ino/gen/value, knowing that if we race with an unlink and a
new hardlink of the *same name* there will be a second *unique*
parent pointer attribute (under a ino/gen/cnt+N name) that has the
same pointer information added to the tree for the new entry. Hence
it is safe to use whatever parent pointer attribute for a given
ino/gen/value we find because it is guaranteed to be valid for the
operation we are about to perform.

A potential optimisation to improve it is that parent counter does
not need to be in an EA. It's 32 bits, so can easily be added to the
spare space in the v2 inode and avoid unnecessary attribute reads
and writes on parent pointer creation.

Hence the parent pointer structure and implementation in 9) solves
all the known problems to do with hardlinks, scalability, locking
order, code complexity etc, and it has relatively little additional
runtime overhead. It also works for v4 filesystems - the proposed
patch set cannot be made to work on older filesystem structures as
there isn't room in the v2 inode for the fast-path fields.

So, there are several problems with approach 6) that the proposed
patchset is based on that were later discovered and solved. Mark,
most of this information was given to you (but in less detail) a
year ago. The patchset hasn't solved any of the flaws that were
pointed out back then, and I don't see how they can be with the
design that is being used.

I don't expect anyone to understand all the intricacies of the
problems that the 2009 parent pointer patchset solved. It's simple
code, but the problems it solves are subtle and complex and were
found the hard way - by shipping code for political/commercial
reasons before the entire problem space was understood.

That's the primary reason why SGI undertook to redesign parent
pointers for the Linux code base rather than port the Irix code -
the irix design was fundamentally flawed and a dead end. SGI might
have lost that historical XFS knowledge and perspective, but the
Linux XFS community hasn't.

Hence the problems with various parent pointer designs are still
well understood and, as such, the implementation needs to be done
properly and solve all the known design flaws we've found in the
past. To this day, the only parent pointer design that actually
avoids all the known problems is one we have from SGI from 2009....

>  On the other hand keeping the directory and extended attribute in one
>  transaction should keeping the changes atomic when the filesystem
>  is forced down between the directory and attribute changes. Despite
>  all the gore (see below) of doing the directory and attribute changes
>  in one transaction, I think it is the correct thing to do.

Yes, I said that it was necessary a year ago and pointed you at how
to do it:

http://xfs.org/index.php/Improving_Metadata_Performance_By_Reducing_Journal_Overhead#Atomic_Multi-Transaction_Operations

Mark, it saddens me that you've wasted your time on a dead end.  I wish
you had of spent your time implementing AMTs instead, and then just
forward ported the 2009 patch. If you'd done that a year ago, we'd
be just about ready to ship a working parent pointer implementation
instead having to go back to square one. :(

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
