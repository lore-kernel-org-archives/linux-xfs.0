Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p5R0WERO013650 for <xfs@oss.sgi.com>; Sun, 26 Jun 2011 19:32:14 -0500
Received: from ipmail04.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 3CA961670D45
	for <xfs@oss.sgi.com>; Sun, 26 Jun 2011 17:32:12 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	CKXXgx33EfH61fgU for <xfs@oss.sgi.com>;
	Sun, 26 Jun 2011 17:32:12 -0700 (PDT)
Date: Mon, 27 Jun 2011 10:32:09 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: question on new feature complexity/possibility/sensibility? (^
	Alternate)
Message-ID: <20110627003209.GD32466@dastard>
References: <4E067D81.4070605@tlinx.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4E067D81.4070605@tlinx.org>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: "Linda A. Walsh" <xfs@tlinx.org>
Cc: xfs-oss <xfs@oss.sgi.com>

On Sat, Jun 25, 2011 at 05:29:53PM -0700, Linda A. Walsh wrote:
> I noticed in the 'cp' (coretuils 8.9-4.1) command on suse, there is
> a a "--reflink" that controls "clone/CoW" copies -- which says
> it performs a 'lightweight' copy where the data blocks are copied
> only when modified.  Now it is vague the 'when modified', (i.e.
> does it mean ones that are different between the two copies) (src
> and dst), or does it mean only to copy blocks that were modified
> since 'some point' -- Doesn't say, but would guess it's src/dst diffs
> (I wonder if it is restricted to the same physical filesystem).
> 
> Anyway, turns out, it's only for BTRFS (which I haven't yet used,
> and therefore know only that it supports operations like the above).

Yup, it requires a refcounted, shared, copy-on-write extent index to
do efficiently.

> Would it be practice to implement, some similar, feature in XFS?

It could be done, but it's a fairly large chunk of work....

> It wouldn't be practice or useful to do it on an 'extent' basis due
> to their large size...So to do something similar on XFS, I was
> thinking,  with "some amount of effort", some number of "updated
> extents" could be kept, in addition to the original data.

Kept where, exactly? And how do you share the original extent tree
between multiple inodes? And if all the inodes that share the
original tree get truncated, how do you know that you can break the
ref-link state and remove the original, now unreferenced tree?

Once you have solved those problems, you have effectively designed a
refcounted, shared, copy-on-write extent index....

> Any future modifications to the file would also have the extents
> modified, but any extents that overlap previous mods will be merged,
> and only the newest data would be kept (meaning that
> new sections that are written, that skip over parts of the file,
> wouldn't overwrite a pending change to that section -- only
> the bytes (granularity?)  that were changed.
> 
> I.e. file is 1Mb.
> User1 updates bytes 1k-200k.
> User2, later updates bytes 100k-300k, New modification 'extent' is
> created with 1k-300k, with bytes
> 1k-(100k-1) from user1 be saved, and 100k-300k from user2.
> 
> Changes to the 'base' copy would be made upon some ioctl 'sync'
> command (file-by-file)...
> 
> It would require up to double the amount of file space.

For a single reflink copy, yes. But there's nothing stopping you
from having multiple ref-link copies of the one file. And so the
problem is far more complex than you are considering.

I've looked at what it would require to implemnt reflinks
transparently in XFS, and it's not pretty.  Major surgery to the
bmap code, a new btree type that includes back pointers to all the
owner inodes, a new shadow inode type that holds the original tree,
a new reflink inode type that contains the overwrite extent tree
instead of a normal extent tree, a bunch of new transactions, new
extent lookup/seek code, etc.

I'd estimate it to be a 6 month project for someone who knew what
they were doing. It's not just kernel code, but all the userspace
tools need to be updated to understand reflinks and the COW based
format (repair, check, db, bmap, etc)

FWIW, I haven't even looked at how extended attributes are
supposed to be handled on reflinked files, so that could increase
the complexity significantly.

> ----
> Another possibility would simply be to create a record of byte
> ranges that have been updated in the extent and the extent's last
> modification time.  Then one could compare the mod times and apply
> the changes.   The problem there would be having to keep a
> possibly 'large' log of changes (what if it's not sync/purged...
> couldn't be circular as that would allow events to be lost -- though
> the file system could be forced 'offline' if the event log became full
> ...a major pain...)..., but if it was created with a few G of space,
> might take a while...and if synced in time, no prob.
> 
> Still, may be no great desire or benefit, but DAMN if I haven't
> wanted copy-on-write files for a LONG time.

So use a filesystem that supports them natively ;)

> I.e. being able to hardlink files, but have an option to mark it as
> copy on write -- allowing space to be save when copying directory trees,
> but then dynamically making new copies when someone updates one of the
> linked copies.

The problem is that a reflink sort of looks like a hard link, but in
many cases behaves like a soft link (e.g. different owners,
permissions, etc are possible) and hence - combined with the
copy-on-write behaviour - they need to be treated more like a
soft-link in terms of implementation. Soft links have their own
inode so can hold state separate to the inode they are pointing to,
and for reflinked files it is simply not practical to retroactively
modify the directory structure to point at a different inode when
the first COW operation occurs.

Like I said, it can be done, but it's not a small project. If you
want to sink a significant amount of development time to the
project, we will help you in any way we can. However, I don't think
anyone has the time to do something like this for you....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
