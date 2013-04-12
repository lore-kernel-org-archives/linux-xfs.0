Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 33AE77F37
	for <xfs@oss.sgi.com>; Thu, 11 Apr 2013 19:25:21 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 1E46D8F8094
	for <xfs@oss.sgi.com>; Thu, 11 Apr 2013 17:25:17 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	Gx1GSPAtGzBe6GMp for <xfs@oss.sgi.com>;
	Thu, 11 Apr 2013 17:25:12 -0700 (PDT)
Date: Fri, 12 Apr 2013 10:24:38 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: reserve fields in inode for parent ptr and alloc
	policy
Message-ID: <20130412002438.GC31207@dastard>
References: <20130410182438.268267840@sgi.com> <20130411030057.GF10481@dastard>
	<5166C08C.8000200@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <5166C08C.8000200@sgi.com>
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

On Thu, Apr 11, 2013 at 08:54:20AM -0500, Mark Tinguely wrote:
> On 04/10/13 22:00, Dave Chinner wrote:
> >On Wed, Apr 10, 2013 at 01:24:24PM -0500, Mark Tinguely wrote:
> >>Reserve fields in new inode layout for parent pointer and
> >>allocation policy.
> >
> >Not without a design review - there is no way we are going to
> >blindly reserve space in any on-disk structure without first having
> >a solid design, published proof-of-concept code and agreement that
> >the format changes being proposed are the right way to proceed.
> >
> >Where are the design docs/code for these features?
> 
> Then you might want to bump the pad size.

Not without good reason. Padding is not designed to accomodate new
features that require 16 bytes of core inode space. If you need that
amount of space in the inode, we have EAs for that....

The plan of record for the past 5-6 years has been that parent
pointers require an arbitrary amount of space in the inode so they
need to be entirely EA based. Hence I'm not prepared to agree to an
inode core change for a shiny new parent pointer implementation I
first heard about 2 days ago and know absolutely nothing about.

You need to show everyone the code so we can get some idea of what
benefit putting this information in the inode core will bring us
over a purely EA based implementation.

FWIW, inodes are versioned and it's trivial to bump the inode
version and add feature bit if an inode core format change is
absolutely necessary. From that perspective, I don't see any need to
rush a change at this point in time.

> >>		----
> >>The inode will hold the parent information for the first
> >>link to a file. Information for the other links will be
> >>held in extended attribute entries.
> >>
> >>The "di_parino" is the inode of the parent directory. The
> >>directory information for this entry is located the parent
> >>directory with "di_paroff" offset.
> >>
> >>The di_parino/di_paroff concept code is running.
> >
> >How does it handle hard links? (i.e. multiple parents)
> 
> As I stated, the hard links will use extended attribute entries.

That will add significant complexity of the implementation.

> >Also, inode number is not enough for unique identification of the
> >parent - generation number is also required.
> 
> Per the 2005 XFS features meeting,

I was at those meetings and wasn't allowed to keep a copy of those
notes when I left SGI. If you want to refer to them, you'll need to
post the notes so everyone knows what was discussed. ;)

> the inode and directory offset
> will uniquely describe a link

It doesn't, though. An inode can only be uniquely identified by
the combination of the inode+generation number. The inode number
identifies an inode, but it doesn't identify the lifecycle instance
of the inode that the reference is valid for.

If this parent pointer link is going to be in any way useful for
metadata scrubbing and repair, then it has to identify the instance
of the parent inode that it points to.

Note that I'm not saying that the EA format in the 2009 patch set is
perfect - I think it needs a couple of significant tweaks. What I am
saying is that there is good reasons for the format of information
in that EA.

> - (thank-you to Glen Overby for that
> observation). The concept code just using one link verifies this
> fact. Using the inode/offset as the identifier is compact and also
> gives information to the file name.

Yup, using d_off was also considered, but has problems, too.  The
problem with pointing to the directory offset is that if the
directory is rebuilt for any reason (e.g. by xfs_repair), then the
directory offset in the child inodes is now invalid and needs to
also be fixed.

And then you have the problem of needing multiple parent links for a
single parent directory as you have to instantiate every single hard
link to the same directory. In the current EA patchset, this does
not occur as the parent structure simply counts the number of
references to a given parent directory.

The EA approach just points to the parent directory and keeps a
count of the number of links back to the directory. Hence as long as
repair doesn't reallocate the directory inode, the parent pointer
information remains intact. i.e. There is less dependency between
the objects and so the format is much more robust against unexpected
changes to directory structures.

This concedes the fact that inode number to name resolution needs to
be a userspace problem. This is something we have to conceed because
the presence of namespaces, security models, bind mounts and chroot
environments use top-down path traversal to limit what part of the
filesystem a userspace process can actually see. In-kernel
resolution of reverse path names is a potential vector for
information leakage between namespaces and at it's worst, a provide
a method for escape. Hence there are security concerns about parent
pointers that we have to take into account as well.

The EA approach is also allows more flexibility for potential future
directory features. For example: online defragmentation. If we want defrag
to be able to compact directories into a contiguous address space,
we need to be able to change the offsets of the data entries. We can
do this if there are no open references to the directory at the time
of the defrag. However, if we fix the offsets of directory entries
in the child inode parent pointers, then this form of defrag becomes
impossible to implement as we cannot update the directory and all
the child inodes atomically from a userspace or transactional
POV. IOWs, the parent pointer format containing an exact directory
offset also limits what we can do with directories in future....

> >That uses xattrs to store parent information - inode #, generation
> >#, and a counter - for each parent. It requires a counter because
> >you can have the same inode hard linked into the same parent
> >directory multiple times:
> >
> >typedef struct xfs_parent_eaname_rec {
> >        __be64  p_ino;
> >        __be32  p_gen;
> >        __be32  p_cnt;
> >} xfs_parent_eaname_rec_t;
> >
> >And a transaction appended to the the inode create, link, rename and
> >remove operations to manage the xattrs so all cases involving hard
> >links work just fine.
> >
> >Indeed, the single di_parino/di_paroff concept was one of the
> >original designs considered because of it's simplicity, but it was
> >rejected because of that very simplicity - it cannot handle common
> >use cases involving hardlinks.
> 
> According to Geoffrey's notes, the hybrid approach was discussed
> too. The single link case will save all the EA operations for the
> majority of the inodes.

Sure, those meetings were brain storming about how we *might* solve
a problem, but keep in mind the context of those meetings was that
all the first and second generation XFS gurus had left SGI and in
that vaccuum nobody left at SGI fully understood the problem domains
being discussed.

As such, there were some really crazy ideas discussed and
documented, but that doesn't mean they were the best solution or
even a good idea.  We came up with several possible ways to
implement parent pointers, but the real world sorted them out pretty
quickly after the brain storming sessions.

Indeed, the real world broke the initial implementation of parent
pointers pretty quickly. You may not know the entire history, but
XFS on Irix effectively ended up with a useless, broken parent
pointer implementation because it was implemented quickly based on
assumptions made in those brainstorming seesions meeting.  i.e.
still without fully understanding the problem space. The limitations
the Irix implementation exposed resulted in it being thrown away
completely and redesigned for Linux. IOWs, the EA based patchset is
what evolved from the hard lessons that Irix taught us....

> >Release early, release often?
> 
> No, trust but verify.

Verification can't be done if you don't tell us anything about what
you are doing.  Verification needs to be done at the design/POC
phase just as much as at the final patch review stage, because there
are many parties that have different requirements for the same
feature.

Open source development is supposed to be, well, open. Public. Not
behind closed doors. Design is open, implementation is open,
flamewars aout stuff are out there in public. Nothing is done behind
closed doors.

Saying "we're doing X" and then not telling anyone about it is the
antithesis of OSS. It -excludes- the community from the process of
developing the new features, and prevents them from verifying what
you are doing is suitable for their needs.

IOWs, there is no possibility of "trust, but verify" in OSS without
"release early, release often". You develop trust by being open and
allowing people to review and verify what you are doing at every
stage of development - from POC through to production code.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
