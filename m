Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 9A58A7F66
	for <xfs@oss.sgi.com>; Mon, 27 Jan 2014 13:41:49 -0600 (CST)
Message-ID: <52E6B67B.6070001@sgi.com>
Date: Mon, 27 Jan 2014 13:41:47 -0600
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [RFC 00/17] RFC parent inode pointers.
References: <20140115220012.624438534@sgi.com> <20140116055607.GR3431@dastard>
	<52D99FD2.6000601@sgi.com> <20140118031247.GE18112@dastard>
In-Reply-To: <20140118031247.GE18112@dastard>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On 01/17/14 21:12, Dave Chinner wrote:

<massive delete we can go over it point by point if necessary, but let
  us start here>.

1) Yep, the parent inode generation number is needed. I thought I said
    it was, bad on me if I did not. It was an RFC and I was too lazy to
    go back and add it in.

2) Add the filename to EA. Not a fan, but I will ask but if DMF needs it
    for performance then it has to be done. My point was this assumes
    that we can keep all the links' EA entries inline in the inode. A
    couple 255 character files or several links of modest sized filenames
    would negate that assumption. I tried to minimize the EA entries to
    keep them inline in the inode. I will talk to the DMF group.

3) There is a unlink/link race because the directory and EA changes
    are done without a common lock. I hit this in testing.

      Assume the sequence was something like *:
      ln a filename1 (EA saved to inode)
      rm filename1
      ln a filename1 (EA not saved because it is a duplicate)
                     (rm EA operation happens and removes the only PIP
                      entry)
      ....
      rm filename1 (no EA entry error)

* My speculation from counters and my testing.

       i) Why not add the lock to keep the directory/EA changes in sync?
      ii) 2009 code required duplicate EA entries to compensate.
           A) Required a counter/inode to make every link unique.
              Granted this counter could be in a inode field.
           B) Required a EA walk to find one of the duplicates entries
              for the remove.
              i) Mark no likey, much bitching and moaning...
           C) More below.

> Mark, don't get me wrong - the 2009 patchset is not perfect and it's
> not finished and it simply reflects what we knew at the time. When I
> refer to that patch, I'm comparing the architecture and design of
> the different parent pointer approaches, not the implementation.
> The design has to be sound before I care about the implementation
> and quality of the code.  If we can't agree on basic architecture
> and design points, then we are most definitely not going to agree on
> the implementation.
>
> Right now, the design of the proposed patchset does not address
> the critical problem of identifier uniqueness and ignores the
> bulk-lookup performance requirements that we know about. Addressing
> those are going to require a change of on-disk attribute format in
> that patch set and that invalidates the in-inode-core optimisations
> that have been made. IOWs, we need to solve the problem first, then
> optimise.
>
> So, what do we need in the parent pointer attribute to solve all the
> known problems? The implementation will flow cleanly from what we
> can store on disk, and we know that we need at least these things to
> solve all the known issues:
>
> 	* parent inode number and generation (unique identifier)

agreed

> 	* link disambiguation (unlink/link race detection)

why allow a unlink/link race?

> 	* filename (for bulk lookup performance)
>
> So the question is how to implement the link disambiguation
> efficiently. That is currently implemented in the 2009 patchset with
> a the monotonic increasing counter that is appended to the attribute
> name. Do we even need a generation count, or is there some other
> info we can use that uniquely identifies a dirent?
>
> While the diroffset of a filename is not unique enough to identify
> the child, I think the {diroffset,filename,child_inode} tuple is
> sufficient. That is, if the diroffset gets reused and points to a
> different filename, we can detect that from the contents of EA and
> abort. If a link of the same name is created, then we can check
> whether it points at the same inode. If it does, then we just don't
> care that there was a race because our current pointer is still
> valid. And we don't need to store the child inode number in the EA -
> we already have that in the child struct xfs_inode structure. That
> verification can even be done in userspace.
>
> Hence I think we've already got all the info we need if we make a
> hybrid format from the two approaches:
>
> 	name=parent_inode,gen,diroffset	value=filename
>
> The inode/gen gives all the information we need to reliably identify
> the parent without requiring child->parent lock ordering, and allows
> userspace to do pathname component level reconstruction without the
> kernel ever needing to verify the parent itself as part of ioctl
> calls.
>
> And finally, by using the diroffset in the EA name, we have a method of
> knowing the exact parent pointer EA we need to modify/remove in
> rename/unlink without an unbound searching.
>
> I think that solves all the architectural issues that we know
> about with both implemenations.
>
> Cheers,
>
> Dave.

Thinking out loud:

EA names have to be unique.
A link/unlink/link EA sequence would have to do a EA RENAME (overwrite
  the duplicate EA with new name).
Have to do either:
  Do a EA lookup and compare before remove.
or
  Add a new EA command that removes a name/value pair.

Not sure if this would work on more than one unlink/link race and seems
like this would still not work if filename of the 2 links are
the same.

Leaving a known race makes me a bit queezy. My internal version uses
locks, but I were clear that you did not like the locks and so they were
not included in the RFC.

   ---- small hypothetical digression ----

If we could use the inode fields for a PIP entry (no filename
in the EA requirement), Olaf Weber came up with a clever PIP entry
EA swizzle that would leave all the PIP inserts/deletes to be done to
the incore inode fields at the same time as the directory operation.
It requires the offset(s) be looked up before the directory
insert/deletes. Pretty much academic if we cannot use in the inode
fields.

--Mark.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
