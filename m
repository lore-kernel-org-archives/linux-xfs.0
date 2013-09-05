Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id BF5417F51
	for <xfs@oss.sgi.com>; Thu,  5 Sep 2013 11:21:42 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id AA2138F804C
	for <xfs@oss.sgi.com>; Thu,  5 Sep 2013 09:21:42 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id XEnBZhEoSQm7EVhH for
	<xfs@oss.sgi.com>; Thu, 05 Sep 2013 09:21:41 -0700 (PDT)
Message-ID: <5228AEBB.9040402@redhat.com>
Date: Thu, 05 Sep 2013 12:18:03 -0400
From: Brian Foster <bfoster@redhat.com>
MIME-Version: 1.0
Subject: Re: [RFC PATCH 06/11] xfs: use correct transaction reservations in
	xfs_inactive()
References: <1378232708-57156-1-git-send-email-bfoster@redhat.com>
	<1378232708-57156-7-git-send-email-bfoster@redhat.com>
	<20130905013519.GT23571@dastard>
In-Reply-To: <20130905013519.GT23571@dastard>
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

On 09/04/2013 09:35 PM, Dave Chinner wrote:
> On Tue, Sep 03, 2013 at 02:25:03PM -0400, Brian Foster wrote:
>> The transaction allocated in xfs_inactive() can be passed down into
>> xfs_inactive_symlink() or xfs_itruncate_extents(), both of which
>> can commit and reallocate a new transaction. This leads to
>> reservation issues if the transaction is subsequently passed into
>> xfs_ifree(), which requires a larger reservation to manage the
>> finobt.
>>
>> Reorganize xfs_inactive() to commit any transaction handed back
>> from symlink or truncate processing and unconditionally allocate
>> a new transaction for xfs_ifree() with the appropriate reservation.
> 
> Ok, I've had a bit of a look at this now, and I like how the code
> turns out. However, I don't think it goes far enough, or fix the
> problem that causes all the transaction nastiness in xfs_inactive().
> 
> Firstly, we are not doing rolling transactions here - there is no
> need for all the changes to be atomic because the inode is on the
> unlinked list if it is going to be freed. Hence we don't need to
> pass transaction pointers around.
> 

I was wondering about this when I was passing through the code. If I
recall, I ended up just trying to work around the lower level calls as
opposed to messing with them because xfs_truncate_extents() had other
callers (but the discussion below addresses that).

> xfs_inactive_symlink() can do a transaction completely internally,
> and, well, it doesn't even log the inode if the symlink is in-line
> and so may not even need a transaction. Hence really only
> xfs_inactive_symlink_rmt() needs to run a transaction, and it can do
> that internally just fine.
> 

Ok.

> For the xfs_itruncate_extents() data fork transaction, just add a
> new wrapper called xfs_inactive_truncate() that holds the
> transaction context internally - that moves the only other
> transaction context that you need to commit out of xfs_inactive()
> altogether, as the attr fork already uses a private transaction
> context.
> 

Sounds good.

> And, finally, you can then factor the xfs_ifree() and it's
> transaction context into a helper function as well, so there aren't
> any transaction contexts left in xfs_inactive() at all.
> 
> That would leave us with:
> 
> 	if (ISLNK) {
> 		error = xfs_inactive_symlink(ip);
> 	} else if (truncate)
> 		error = xfs_inactive_truncate(ip);
> 	}
> 	if (error)
> 		goto out;
> 	if (ip->i_d.di_anextents > 0)
> 		error = xfs_attr_inactive(ip);
> 	if (error)
> 		goto out;
> 
> 	error = xfs_inactive_ifree(ip);
> 
> 	xfs_qm_dqdetach(ip);
> out:
> 	return;
> 
> This gives us a natural separation of the different transaction
> reservations and contexts needed to perform the operations, and does
> result in any extraneous work being done because we don't know what
> the transaction context passed to us contains at all...
> 

Yeah, I agree. That cleans things up nicely.

> FWIW, there are other reasons for suggesting this structure - have a
> read of "[RFD 14/17] xfs: separate inode freeing from inactivation"
> and you'll see that what I've suggested above sets the code up for
> implementing the optimisations documented in the RFD.
> 
> http://oss.sgi.com/archives/xfs/2013-08/msg00345.html
> 
> It might be best to put this as 3-4 patches at the start of the
> series, rather than in the middle of it as it's really a separate
> piece of cleanup work....
> 

Ok, I've skimmed through most of the writeups in that set. If it turns
into a handful of patches, I might just test and post this as an
independent, prerequisite set for personal ease of management reasons if
nothing else. I'm more confident in the changes with the review feedback
and that I obviously now know what the finobt requirements are. Thanks.

Brian

> Cheers,
> 
> Dave.
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
