Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 17FB47FC0
	for <xfs@oss.sgi.com>; Thu, 20 Feb 2014 14:50:27 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id D424F304089
	for <xfs@oss.sgi.com>; Thu, 20 Feb 2014 12:50:23 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	rMq6vWcglbv08a7H for <xfs@oss.sgi.com>;
	Thu, 20 Feb 2014 12:50:20 -0800 (PST)
Date: Fri, 21 Feb 2014 07:50:16 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v3 04/11] xfs: update inode allocation/free transaction
	reservations for finobt
Message-ID: <20140220205016.GN4916@dastard>
References: <1391536182-9048-1-git-send-email-bfoster@redhat.com>
	<1391536182-9048-5-git-send-email-bfoster@redhat.com>
	<20140211064609.GE13647@dastard> <530393F8.4070106@redhat.com>
	<20140220020101.GL4916@dastard> <53064E26.2050607@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <53064E26.2050607@redhat.com>
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

On Thu, Feb 20, 2014 at 01:49:10PM -0500, Brian Foster wrote:
> On 02/19/2014 09:01 PM, Dave Chinner wrote:
> > [patched in the extra case from your subsequent reply]
> > 
> > On Tue, Feb 18, 2014 at 12:10:16PM -0500, Brian Foster wrote:
> >> On 02/11/2014 01:46 AM, Dave Chinner wrote:
> >>> On Tue, Feb 04, 2014 at 12:49:35PM -0500, Brian Foster wrote:
> >>>> Create the xfs_calc_finobt_res() helper to calculate the finobt log
> >>>> reservation for inode allocation and free. Update
> >>>> XFS_IALLOC_SPACE_RES() to reserve blocks for the additional finobt
> >>>> insertion on inode allocation. Create XFS_IFREE_SPACE_RES() to
> >>>> reserve blocks for the potential finobt record insertion on inode
> >>>> free (i.e., if an inode chunk was previously fully allocated).
> >>>>
> >>>> Signed-off-by: Brian Foster <bfoster@redhat.com>
> >>>> ---
> >>>>  fs/xfs/xfs_inode.c       |  4 +++-
> >>>>  fs/xfs/xfs_trans_resv.c  | 47 +++++++++++++++++++++++++++++++++++++++++++----
> >>>>  fs/xfs/xfs_trans_space.h |  7 ++++++-
> >>>>  3 files changed, 52 insertions(+), 6 deletions(-)
> >>>>
> >>>> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> >>>> index 001aa89..57c77ed 100644
> >>>> --- a/fs/xfs/xfs_inode.c
> >>>> +++ b/fs/xfs/xfs_inode.c
> >>>> @@ -1730,7 +1730,9 @@ xfs_inactive_ifree(
> >>>>  	int			error;
> >>>>  
> >>>>  	tp = xfs_trans_alloc(mp, XFS_TRANS_INACTIVE);
> >>>> -	error = xfs_trans_reserve(tp, &M_RES(mp)->tr_ifree, 0, 0);
> >>>> +	tp->t_flags |= XFS_TRANS_RESERVE;
> >>>> +	error = xfs_trans_reserve(tp, &M_RES(mp)->tr_ifree,
> >>>> +				  XFS_IFREE_SPACE_RES(mp), 0);
> >>>
> >>> Can you add a comment explaining why the XFS_TRANS_RESERVE flag is
> >>> used here, and why it's use won't lead to accelerated reserve pool
> >>> depletion?
.....
> >> Perhaps another argument could be made that it's rather unlikely we run
> >> into an fs with as many 0-sized (or sub-inode chunk sized) files as
> >> required to deplete the reserve pool without freeing any space, and we
> >> should just touch up the failure handling. E.g.,
> >>
> >> 1.) Continue to reserve enable the ifree transaction. Consider expanding
> >> the reserve pool on finobt-enabled fs' if appropriate. Note that this is
> >> not guaranteed to provide enough resources to populate the finobt to the
> >> level of the inobt without freeing up more space.
> >> 2.) Attempt a !XFS_TRANS_RESERVE tp reservation in xfs_inactive_ifree().
> >> If fails, xfs_warn()/notice() and enable XFS_TRANS_RESERVE.
> >> 3.) Attempt XFS_TRANS_RESERVE reservation. If fails, xfs_notice() and
> >> shutdown.
> > 
> > I don't think we ned to shut down. Indeed, there's no point in doing
> > an !XFS_TRANS_RESERVE in the first place because a warning will just
> > generate unnecessary noise in the logs.
> > 
> > Realistically, we can leave inodes on the unlinked list
> > indefinitely without causing any significant problems except for
> > there being used space that users can't account for from the
> > namespace. Log recovery cleans them up when it runs, or blows away
> > the unlinked list when it fails, and that results in leaked inodes.
> > If we get to that point, xfs-repair will clean it up just fine
> > unless there's still not enough space. At that point, it's not a
> > problem we can solve with tools - the user has to free up some space
> > in the filesystem....
> 
> Ok, the current failure behavior (as unlikely as it seems to hit) seems
> less hasty given the roadmap for improved unlinked list management.
> 
> I'm not sure how log recovery plays into things unless there is a crash.
> In my experiments, the inodes are simply never freed and linger on the
> unlinked list until repair. Repair moves everything to lost+found as
> opposed to freeing (I presume since the inodes are still "allocated"
> after all), but repairs the fs nonetheless.

With the recovery-without-a-crash case, the recovery of unlinked
inodes happens in the second phase of recovery (i.e via
xlog_recover_process_iunlinks() in xlog_recover_finish()). This is
after we've done the actual log recovery (so that unlinked list
changes have been recovered), and so effectively in not so much a
part of "log recovery" but a part of "unclean shutdown cleanup".
That currently is associates with log recovery, but there's not
reason why we couldn't just do it unconditionally on a mount. If we
are going to leave inodes on the unlinked lists and allocate
directly from there, then it kind of makes sense to have the
unlinked lists cleaned up at mount time, even if it is only by
kicking a background cleaner thread...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
