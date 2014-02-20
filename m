Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id AD6297FB2
	for <xfs@oss.sgi.com>; Thu, 20 Feb 2014 12:49:20 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 2F140AC004
	for <xfs@oss.sgi.com>; Thu, 20 Feb 2014 10:49:16 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id hOfrFOzg26C3fQSR for
	<xfs@oss.sgi.com>; Thu, 20 Feb 2014 10:49:15 -0800 (PST)
Message-ID: <53064E26.2050607@redhat.com>
Date: Thu, 20 Feb 2014 13:49:10 -0500
From: Brian Foster <bfoster@redhat.com>
MIME-Version: 1.0
Subject: Re: [PATCH v3 04/11] xfs: update inode allocation/free transaction
	reservations for finobt
References: <1391536182-9048-1-git-send-email-bfoster@redhat.com>
	<1391536182-9048-5-git-send-email-bfoster@redhat.com>
	<20140211064609.GE13647@dastard> <530393F8.4070106@redhat.com>
	<20140220020101.GL4916@dastard>
In-Reply-To: <20140220020101.GL4916@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On 02/19/2014 09:01 PM, Dave Chinner wrote:
> [patched in the extra case from your subsequent reply]
> 
> On Tue, Feb 18, 2014 at 12:10:16PM -0500, Brian Foster wrote:
>> On 02/11/2014 01:46 AM, Dave Chinner wrote:
>>> On Tue, Feb 04, 2014 at 12:49:35PM -0500, Brian Foster wrote:
>>>> Create the xfs_calc_finobt_res() helper to calculate the finobt log
>>>> reservation for inode allocation and free. Update
>>>> XFS_IALLOC_SPACE_RES() to reserve blocks for the additional finobt
>>>> insertion on inode allocation. Create XFS_IFREE_SPACE_RES() to
>>>> reserve blocks for the potential finobt record insertion on inode
>>>> free (i.e., if an inode chunk was previously fully allocated).
>>>>
>>>> Signed-off-by: Brian Foster <bfoster@redhat.com>
>>>> ---
>>>>  fs/xfs/xfs_inode.c       |  4 +++-
>>>>  fs/xfs/xfs_trans_resv.c  | 47 +++++++++++++++++++++++++++++++++++++++++++----
>>>>  fs/xfs/xfs_trans_space.h |  7 ++++++-
>>>>  3 files changed, 52 insertions(+), 6 deletions(-)
>>>>
>>>> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
>>>> index 001aa89..57c77ed 100644
>>>> --- a/fs/xfs/xfs_inode.c
>>>> +++ b/fs/xfs/xfs_inode.c
>>>> @@ -1730,7 +1730,9 @@ xfs_inactive_ifree(
>>>>  	int			error;
>>>>  
>>>>  	tp = xfs_trans_alloc(mp, XFS_TRANS_INACTIVE);
>>>> -	error = xfs_trans_reserve(tp, &M_RES(mp)->tr_ifree, 0, 0);
>>>> +	tp->t_flags |= XFS_TRANS_RESERVE;
>>>> +	error = xfs_trans_reserve(tp, &M_RES(mp)->tr_ifree,
>>>> +				  XFS_IFREE_SPACE_RES(mp), 0);
>>>
>>> Can you add a comment explaining why the XFS_TRANS_RESERVE flag is
>>> used here, and why it's use won't lead to accelerated reserve pool
>>> depletion?
>>>
>>
>> So this aspect of things appears to be a bit more interesting than I
>> originally anticipated. I "reserve enabled" this transaction to
>> facilitate the ability to free up inodes under ENOSPC conditions.
>> Without this, the problem of failing out of xfs_inactive_ifree() (and
>> leaving an inode chained on the unlinked list) is easily reproducible
>> with generic/083.
> 
> *nod*
> 
>> The basic argument for why this is reasonable is that releasing an inode
>> releases used space (i.e., file blocks and potentially directory blocks
>> and inode chunks over time). That said, I can manufacture situations
>> where this is not the case. E.g., allocate a bunch of 0-sized files,
>> consume remaining free space in some separate file, start removing
>> inodes in a manner that removes a single inode per chunk or so. This
>> creates a scenario where the inobt can be very large and the finobt very
>> small (likely a single record). Removing the inodes in this manner
>> reduces the likelihood of freeing up any space and thus rapidly grows
>> the finobt towards the size of the inobt without any free space
>> available. This might or might not qualify as sane use of the fs, but I
>> don't think the failure scenario is acceptable as things currently stand.
> 
> Right, that can happen. But my question is this: how realistic is it
> that we have someone who has ENOSPC because of enough zero length
> files to trigger this? I've never seen an application or user try to
> store any significant number of zero length files, so I suspect this
> is a theoretical problem, not a practical one.
> 

Probably not very realistic. ;) The only thing I know that does rely on
some zero-length files is gluster distribution to represent "link files"
when one a file that hashes to one server ends up stored on another.
Even then, I don't see how we would ever have a situation where those
link files exist in such massive numbers and are removed in bulk. So
it's likely a pathological scenario.

> Indeed, the finobt only needs to grow a block for every 250-odd
> records for a 4k block size filesystem. Hence, IMO, the default
> reserve pool size of 8192 filesystem blocks is going be sufficient
> for most users. i.e. the case you are talking about requires
> (ignoring node block usage for simplicity) 250 * 8192 * 64 = 131
> million zero length inodes to be present in the filesystem to have
> this "1 inode per chunk" freeing pattern exhaust the default reserve
> pool with finobt tree allocations....
> 

Well, only ~2 million of the ~131 million you happen to free would have
to be 0-sized and per-chunk, right? ;) I guess sub aligned inode chunk
sized would be more accurate than 0-sized as well. But regardless, this
doesn't seem probable.

>> I think there are several ways this can go from here. A couple ideas
>> that have crossed my mind:
>>
>> - Find a way to variably reserve the number of blocks that would be
>> required to grow the finobt to the finobt, based on current state. This
> 
> Not sure what "grow the finobt to the finobt" means. There's a typo
> or a key word missing there ;)
> 

That should read "grow the finobt to the inobt," referring to the size
in terms of number of records in the tree.

>> would require the total number of blocks (not just enough for a split),
>> so this could get complex and somewhat overbearing (i.e., a lot of space
>> could be quietly reserved, current tracking might not be sufficient and
>> the allocation paths could get hairy).
> 
> Doesn't seem worth the complexity to me.
> 

Agreed.

>> - Work to push the ifree transaction allocation and reservation to the
>> unlink codepath rather than the eviction codepath. Under normal
>> circumstances, chain the tp to the xfs_inode such that the eviction code
>> path can grab it and run. This prevents us going into the state where an
>> inode is unlinked without having enough space to free up. On the flip
>> side, ENOSPC on unlink isn't very forgiving behavior to the user.
> 
> That's the long term plan anyway - to move to background freeing of
> the inodes once they are on the unlinked list and unreferenced by
> the VFS. But, really, once the inode is on the unlinked list we can
> probably ignore the ENOSPC problem because we know that it is
> unlinked.
> 
> Indeed, the long term plan (along with background freeing) is to
> allow inode allocation direct from the unlinked lists, and that
> means we could leave the inodes on the unlinked lists and not
> care about the ENOSPC problem at all ;)
> 

Ah, ok. I had a similar thought as well about having some kind of
background scanner for unlinked list inodes that kicks in when we know
we have evicted inodes on the list...

>> - Add some state or flags bits to the finobt and the associated
>>   ability to kill/invalidate it at runtime. Print a warning with
>>   regard to the situation that indicates performance might be
>>   affected and a repair is required to re-enable.
> 
> We've already got that state through the unlinked lists. Again,
> go back to the RFD series and look through the followup work....
> 

... and taking a quick look back through that, I see 14/17 refers to
precisely such a mechanism. I thought that sounded familiar. ;)

>>
>> I think the former approach is probably overkill for something that
>> might be a pathological situation. The latter approach is more simple,
>> but it feels like a bit of a hack. I've experimented with it a bit, but
>> I'm not quite sure yet if it introduces any transaction issues by
>> allocating the unlink and ifree transactions at the same time.
>>
>> Perhaps another argument could be made that it's rather unlikely we run
>> into an fs with as many 0-sized (or sub-inode chunk sized) files as
>> required to deplete the reserve pool without freeing any space, and we
>> should just touch up the failure handling. E.g.,
>>
>> 1.) Continue to reserve enable the ifree transaction. Consider expanding
>> the reserve pool on finobt-enabled fs' if appropriate. Note that this is
>> not guaranteed to provide enough resources to populate the finobt to the
>> level of the inobt without freeing up more space.
>> 2.) Attempt a !XFS_TRANS_RESERVE tp reservation in xfs_inactive_ifree().
>> If fails, xfs_warn()/notice() and enable XFS_TRANS_RESERVE.
>> 3.) Attempt XFS_TRANS_RESERVE reservation. If fails, xfs_notice() and
>> shutdown.
> 
> I don't think we ned to shut down. Indeed, there's no point in doing
> an !XFS_TRANS_RESERVE in the first place because a warning will just
> generate unnecessary noise in the logs.
> 
> Realistically, we can leave inodes on the unlinked list
> indefinitely without causing any significant problems except for
> there being used space that users can't account for from the
> namespace. Log recovery cleans them up when it runs, or blows away
> the unlinked list when it fails, and that results in leaked inodes.
> If we get to that point, xfs-repair will clean it up just fine
> unless there's still not enough space. At that point, it's not a
> problem we can solve with tools - the user has to free up some space
> in the filesystem....
> 

Ok, the current failure behavior (as unlikely as it seems to hit) seems
less hasty given the roadmap for improved unlinked list management.

I'm not sure how log recovery plays into things unless there is a crash.
In my experiments, the inodes are simply never freed and linger on the
unlinked list until repair. Repair moves everything to lost+found as
opposed to freeing (I presume since the inodes are still "allocated"
after all), but repairs the fs nonetheless.

>> And this could probably be made more intelligent to bail out sooner if
>> we repeat XFS_TRANS_RESERVE reservations without freeing up any space,
>> etc. Before going too far in one direction... thoughts?
> 
> Right now, I just don't think it is a case we need to be
> pariticularly concerned with. There are plenty of theoretical issues
> that can occur (including data loss) when the reserve pool is
> depleted because of prolonged ENOSPC issues, but the reality is
> that the only place we see this code being exercised is by the tests
> in xfstests that intentionally trigger reserve pool depletion....
> 

Fair enough, I'll leave things generally as is apart from the review
feedback. I might add a warning or ratelimited printk in the inactive
ENOSPC failure path, just so it's not completely silent if it does
trigger in the wild. Thanks for the feedback.

Brian

> Cheers,
> 
> Dave.
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
