Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 10D547F52
	for <xfs@oss.sgi.com>; Wed, 23 Apr 2014 18:07:39 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id E9D6B8F804B
	for <xfs@oss.sgi.com>; Wed, 23 Apr 2014 16:07:35 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	gQd8ca2v0qZxw1JY for <xfs@oss.sgi.com>;
	Wed, 23 Apr 2014 16:07:34 -0700 (PDT)
Date: Thu, 24 Apr 2014 09:06:43 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v3 14/20] xfsprogs/repair: phase 2 finobt scan
Message-ID: <20140423230643.GU15995@dastard>
References: <1397146270-42993-1-git-send-email-bfoster@redhat.com>
	<1397146270-42993-15-git-send-email-bfoster@redhat.com>
	<20140423061945.GO15995@dastard>
	<20140423200151.GD5225@bfoster.bfoster>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140423200151.GD5225@bfoster.bfoster>
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

On Wed, Apr 23, 2014 at 04:01:52PM -0400, Brian Foster wrote:
> On Wed, Apr 23, 2014 at 04:19:45PM +1000, Dave Chinner wrote:
> > On Thu, Apr 10, 2014 at 12:11:04PM -0400, Brian Foster wrote:
> > > If one exists, scan the free inode btree in phase 2 of xfs_repair.
> > > We use the same general infrastructure as for the inobt scan, but
> > > trigger finobt chunk scan logic in in scan_inobt() via the magic
> > > value.
> > > 
> > > The new scan_single_finobt_chunk() function is similar to the inobt
> > > equivalent with some finobt specific logic. We can expect that
> > > underlying inode chunk blocks are already marked used due to the
> > > previous inobt scan. We can also expect to find every record
> > > tracked by the finobt already accounted for in the in-core tree
> > > with equivalent (and internally consistent) inobt record data.
> > > 
> > > Spit out a warning on any divergences from the above and add the
> > > inodes referenced by the current finobt record to the appropriate
> > > in-core tree.
> > > 
> > > Signed-off-by: Brian Foster <bfoster@redhat.com>
> > ....
> > > +
> > > +	if (!suspect) {
> > > +		/*
> > > +		 * inodes previously inserted into the uncertain tree should be
> > > +		 * superceded by these when the uncertain tree is processed
> > > +		 */
> > > +		nfree = 0;
> > > +		if (XFS_INOBT_IS_FREE_DISK(rp, 0)) {
> > > +			nfree++;
> > > +			ino_rec = set_inode_free_alloc(mp, agno, ino);
> > > +		} else  {
> > > +			ino_rec = set_inode_used_alloc(mp, agno, ino);
> > > +		}
> > > +		for (j = 1; j < XFS_INODES_PER_CHUNK; j++) {
> > > +			if (XFS_INOBT_IS_FREE_DISK(rp, j)) {
> > > +				nfree++;
> > > +				set_inode_free(ino_rec, j);
> > > +			} else  {
> > > +				set_inode_used(ino_rec, j);
> > > +			}
> > > +		}
> > > +	} else {
> > > +		/*
> > > +		 * this should handle the case where the inobt scan may have
> > > +		 * already added uncertain inodes
> > > +		 */
> > > +		nfree = 0;
> > > +		for (j = 0; j < XFS_INODES_PER_CHUNK; j++) {
> > > +			if (XFS_INOBT_IS_FREE_DISK(rp, j)) {
> > > +				add_aginode_uncertain(mp, agno, ino + j, 1);
> > > +				nfree++;
> > > +			} else {
> > > +				add_aginode_uncertain(mp, agno, ino + j, 0);
> > > +			}
> > > +		}
> > > +	}
> > > +
> > > +check_freecount:
> > > +
> > > +	if (nfree != be32_to_cpu(rp->ir_freecount)) {
> > > +		do_warn(
> > > +_("finobt ir_freecount/free mismatch, inode chunk %d/%u, freecount %d nfree %d\n"),
> > > +			agno, ino, be32_to_cpu(rp->ir_freecount), nfree);
> > > +	}
> > > +
> > > +	if (!nfree) {
> > > +		do_warn(
> > > +_("finobt record with no free inodes, inode chunk %d/%u\n"), agno, ino);
> > > +	}
> > 
> > Shouldn't both of these increment suspect?
> > 
> 
> So at this point of the scan, we're processing through finobt leaf
> blocks. Setting suspect has two side effects that I can see:
> 
> 1.) Suppressing the additional, more granular checks for the
> records/inodes that make up the remainder of the block.
> 
> 2.) Setting bad_ino_btree, which causes us to skip phases 6 and 7.
> 
> I think my thought process was that side effect #2 was generally too
> heavy handed for a scenario where the freecount doesn't happen to match
> or we've failed to remove a fully allocated record from the finobt.

Yes, that's true.

> Furthermore, we already increment suspect in this function if either the
> allocation state of the inode chunk blocks or the allocation state of
> any individual inode is unexpected based on the inobt state. The
> additional value of the freecount checks is to catch any kind of
> intra-record corruption or inter-freecount corruption across the trees,
> which IIUC would be fixed naturally provided nothing else is wrong
> (e.g., suspect remains 0) when the trees are regenerated.
> 
> In other words, if inode allocation state does differ between the trees,
> we already do set suspect. If these warnings fire without suspect being
> set, it means we just need to fix up the freecount and there is no
> broader tree corruption. Thoughts?

Seems reasonable. Perhaps a comment explaining this would be a good
idea - we dont have nearly enough comments in repair explaining how
it is cross-validating different pieces of metadata...

> NOTE:
> 
> When looking through this again, I think there is a hole in the
> allocation state logic in that we don't catch a case where the finobt
> inode could be allocated and the inobt inode marked as free:
> 
> 	if (first_rec) {
> 		...
> 
> 		nfree = 0;
> 		for (j = 0; j < XFS_INODES_PER_CHUNK; j++) {
> 			if (XFS_INOBT_IS_FREE_DISK(rp, j)) {
> 				nfree++;
> 				if (!suspect && !is_inode_free(first_rec, j))
> 					suspect++;
> 			}
> 			/*
> 			 * XXX: else if the finobt inode is allocated, confirm
> 			 * here that the inobt inode is allocated as well!
> 			 */
> 		}
> 		goto check_freecount;
> 	}
> 
> I think something like this might work:
> 
> 	if (first_rec) {
> 		...
> 
> 		nfree = 0;
> 		for (j = 0; j < XFS_INODES_PER_CHUNK; j++) {
> 			int isfree = XFS_INOBT_IS_FREE_DISK(rp, j);
> 
> 			if (isfree) 
> 				nfree++;
> 
> 			if (!suspect &&
> 			    isfree != is_inode_free(first_rec, j))
> 				suspect++;
> 		}
> 		goto check_freecount;
> 	}

Yes, that makes sense - we need to validate in both directions.
Again, a comment would be a useful reminder here. ;)

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
