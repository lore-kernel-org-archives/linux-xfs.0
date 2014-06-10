Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 373647F51
	for <xfs@oss.sgi.com>; Tue, 10 Jun 2014 16:49:09 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id CAA10AC006
	for <xfs@oss.sgi.com>; Tue, 10 Jun 2014 14:49:08 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	UAe0p7kMSnSJXqry for <xfs@oss.sgi.com>;
	Tue, 10 Jun 2014 14:49:05 -0700 (PDT)
Date: Wed, 11 Jun 2014 07:48:50 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [DISCUSS] Planning for new dev cycle (3.17)
Message-ID: <20140610214850.GH9508@dastard>
References: <20140609223320.GE9508@dastard>
	<20140610115857.GC46344@bfoster.bfoster>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140610115857.GC46344@bfoster.bfoster>
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
To: Brian Foster <bfoster@redhat.com>
Cc: xfs@oss.sgi.com

On Tue, Jun 10, 2014 at 07:58:57AM -0400, Brian Foster wrote:
> On Tue, Jun 10, 2014 at 08:33:20AM +1000, Dave Chinner wrote:
> > Hi everyone,
> > 
> > Now that the 3.16 dev cycle has drawn to a close (one more
> > linux-next build and I'll tag for-next and send a pull request),
> > it's time to look ahead for the next couple of months. I think the
> > current major pieces of work that are currently outstanding are
> > these:
> > 
> > 	- Jeff's bulkstat rework
> > 	- Brian's EOF prealloc scanning
> > 	- Namjae's FALLOC_FL_INSERT_RANGE work
> > 	- Eric's XFS_ERROR() macro removal and return () cleanup.
> > 
> 
> I'm not tied to a particular kernel release by any means if there's
> already a lot in the pipeline, but I'd like to include the basic sysfs
> bits somewhere in the tail end of this.

Yes, I don't see a problem there - I simply forgot about that ;)

> > There's also two major pieces of infrastructure work I'd like to get
> > done:
> > 
> > 	- convert XFS to negative error returns
> > 	- restructure code to have a fs/xfs/libxfs structure similar
> > 	  to userspace
> > 
> > Because Eric's XFS_ERROR removal touches the entire codebase, as
> > does the negative error return and the libxfs restructuring, I'd
> > like to get these done first and base the rest of the dev cycle work
> > on top of that. Eric's patches just need a minor rebase and the
> > libxfs restructure needs some makefile rework and review and they
> > should be good to go.
> > 
> 
> Sounds reasonable to me.
> 
> > The issue is the negative error number patchset, and how to handle
> > review and testing. The patchset is already 62 patches long and it
> > converts roughly half the code base. It'll take me another couple of
> > days to convert the rest of the code, and that will probably take
> > another 60 patches.
> > 
> > I understand that reviewing 100+ patches is going to be a pain, but
> > each patch currently averages about +/- 10 lines. The current
> > diffstat is:
> > 
> > 	37 files changed, 723 insertions(+), 722 deletions(-)
> > 
> > And that will probably double, so it's still going to be a fair
> > amount of change.
> 
> Is there any sort of more coarse logical breakdown of this series, or do
> we want/need to convert the entire codebase all at once? The individual
> patches sound relatively small... is there a particular method at play
> there? E.g., a patch per function? file? call chain?

I'm doing it layer by layer, starting from the linux interface
layers and working my way down. e.g. fs/xfs/xfs_file.c first,
the fs/xfs/xfs_iops.c, and so on, and there are multiple patches per
file for each (roughly) logical change. e.g. converting xfs_iops.c:

[these are in reverse order because of git log listing]

1f80bd7 xfs: convert error sign for xfs_setattr
794c21d xfs: negate error from xfs_rename
032669b xfs: negate error for link/unlink/symlink
a12b6b1 xfs: negate error from xfs_lookup
a0f5650 xfs: push negative errno down through xfs_generic_create

pushes the conversion layer to fs/xfs/xfs_inode.c.  Then later the
quota bits stuff like xfs_create() call are converted:

350747a xfs: negate error retursn from dquot attach/detach functions

as the negative errors are driven inward in the dquot
infrastructure, slowly removing all the conversions from the
fs/xfs/xfs_inode.c layer, Similarly, the directory code is converted
in a similarly layered approach

....
f3086a1 xfs: convert shortform directories to negative errors
bbda37c xfs: negate dir inode grow/shrink return values
7f73c2b xfs: convert remaining directory name operations to negative error
bca2fa3 xfs: negate error values from directory create functions

And so on. Basically once all the high layer functions are
converted, I'll move onto the inner infrastructure such as the
xfs_bmap code, then the btree code, then the xfs_trans code, then
the xfs_buf, and so on until all the code is using negative errors
and the only conversions are in the ioctl code for userspace
presentation.

IMO, the only way to guarantee that we've got it right is to
convert everything - if we stop half way, then all we've done is
move the interface layer and made it extremely hard to validate that
the interface layer is correct. Hence I don't want to do that - I
just want to change it all in one go to make it easier to validate
the end result...

> > So the big question is how do we handle the review side of
> > things.  I think testing won't be a huge issue because of the
> > time we have in the cycle (a couple of months to the 3.17 merge,
> > and then a couple more months in the 3.17-rcX cycle) to find and
> > catch regressions, but I'd like to know what people think about
> > the best way to review this change will be.
> > 
> > I'm happy for people to say "no, we need to review it patch by
> > patch, so delay it for a cycle while we work through it", but
> > I'm also happy for a "apply it all and look at error sources and
> > inversion points for problems". The second is probably easier,
> > as there will be very few remaining inversion points (only
> > embedded errors in ioctl structures, I think) and all error
> > sources should be negated at their definition and hence any
> > error value (E* values) that are not defined as "-E*" is likely
> > to be an mistake....
> > 
> 
> Personally, I generally prefer going through individual patches.
> Even if we don't post the entire series and do a patch-by-patch
> reviewed-by (which sounds like overkill in this case), that helps
> me do bits a time, keep track of where I am, etc. I say that
> before I've seen any of these patches of course ;), so I could
> certainly see running through some kind of approach of doing it
> batches (i.e., "look at this sequence of patches, identify the
> affected segments of code, make a direct pass through that code,
> repeat"). I guess it's hard to say without just digging in and
> finding the most effective approach to get through it.
> 
> Perhaps if we just make a branch available with the patches, put a
> notification on the list, and we can use that as a review
> thread..?

I'll push the series to the git tree at the end of the day - I'm
hoping to have the conversion mostly done by then. I did most of the
rebase of the existing patchset on top of the libxfs addition last
night, so I should e able to knock off most of the rest of the
changes today. I wanted to see what people thought about the concept
without cluttering the issue with a huge code dump...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
