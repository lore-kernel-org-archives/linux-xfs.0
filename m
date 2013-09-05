Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 36ECA7F4E
	for <xfs@oss.sgi.com>; Thu,  5 Sep 2013 11:22:11 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id EB30130408B
	for <xfs@oss.sgi.com>; Thu,  5 Sep 2013 09:22:10 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id m7tI5cWxr0R9AwjF for
	<xfs@oss.sgi.com>; Thu, 05 Sep 2013 09:22:09 -0700 (PDT)
Message-ID: <5228AED7.1010700@redhat.com>
Date: Thu, 05 Sep 2013 12:18:31 -0400
From: Brian Foster <bfoster@redhat.com>
MIME-Version: 1.0
Subject: Re: [RFC PATCH 07/11] xfs: retry trans reservation on ENOSPC in
	xfs_inactive()
References: <1378232708-57156-1-git-send-email-bfoster@redhat.com>
	<1378232708-57156-8-git-send-email-bfoster@redhat.com>
	<20130905014016.GU23571@dastard>
In-Reply-To: <20130905014016.GU23571@dastard>
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

On 09/04/2013 09:40 PM, Dave Chinner wrote:
> On Tue, Sep 03, 2013 at 02:25:04PM -0400, Brian Foster wrote:
>> An ifree data block reservation can fail with ENOSPC. Flush inodes
>> to try and free up space or attempt without a data block
>> reservation to avoid failing out of xfs_inactive().
>>
>> Signed-off-by: Brian Foster <bfoster@redhat.com>
>> ---
>>  fs/xfs/xfs_inode.c | 11 +++++++++++
>>  1 file changed, 11 insertions(+)
>>
>> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
>> index 56cbf63..92de4b7 100644
>> --- a/fs/xfs/xfs_inode.c
>> +++ b/fs/xfs/xfs_inode.c
>> @@ -1779,7 +1779,18 @@ xfs_inactive(
>>  	tp = xfs_trans_alloc(mp, XFS_TRANS_INACTIVE);
>>  	error = xfs_trans_reserve(tp, &M_RES(mp)->tr_ifree,
>>  				  XFS_IFREE_SPACE_RES(mp), 0);
>> +	if (error == ENOSPC) {
>> +		/* flush outstanding delalloc blocks and retry */
>> +		xfs_flush_inodes(mp);
>> +		error = xfs_trans_reserve(tp, &M_RES(mp)->tr_ifree,
>> +					  XFS_IFREE_SPACE_RES(mp), 0);
>> +	}
> 
> We don't want to be blocking for inode flushes here. We might be in
> a shrinker context, for example, and blocking those for a filesystem
> sync is going to be unfriendly.
> 

Ok.

> If this really is a problem, then the right thing to do is to allow
> this transaction to dip into the reserve block pool so the
> transaction can complete and make progress - other write operations
> will trigger the flushing of the filesystem, and freeing of whole
> inode chunks should return more free space than we need for the
> finobt modifications in the removing lots of zero length inodes
> at ENOSPC case....
> 

I did have one of the enospc xfstests lead to this situation, though I
don't have the particular test in my notes. It initially manifested as
an assert failure due to the fs not being shutdown after an
xfs_trans_reserve() ENOSPC failure. Subsequent to avoiding that, I
believe there were inconsistent fs issues called out due to the unlinked
lists being populated after umount.

Taking a further look, I missed the XFS_TRANS_RESERVE flag and whole
m_resblks mechanism. I'll take a closer look at that and see if that
works to resolve the problem instead of the flush.

Brian

> Cheers,
> 
> Dave.
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
