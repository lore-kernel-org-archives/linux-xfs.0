Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 76D7F7F51
	for <xfs@oss.sgi.com>; Thu,  5 Sep 2013 11:22:51 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 61FE98F8039
	for <xfs@oss.sgi.com>; Thu,  5 Sep 2013 09:22:51 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id xOtK5NJg8klvayVz for
	<xfs@oss.sgi.com>; Thu, 05 Sep 2013 09:22:50 -0700 (PDT)
Message-ID: <5228AF00.7080700@redhat.com>
Date: Thu, 05 Sep 2013 12:19:12 -0400
From: Brian Foster <bfoster@redhat.com>
MIME-Version: 1.0
Subject: Re: [RFC PATCH 10/11] xfs: update the finobt on inode free
References: <1378232708-57156-1-git-send-email-bfoster@redhat.com>
	<1378232708-57156-11-git-send-email-bfoster@redhat.com>
	<20130905025421.GX23571@dastard>
In-Reply-To: <20130905025421.GX23571@dastard>
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

On 09/04/2013 10:54 PM, Dave Chinner wrote:
> On Tue, Sep 03, 2013 at 02:25:07PM -0400, Brian Foster wrote:
>> An inode free operation can have several effects on the finobt. If
>> all inodes have been freed and the chunk deallocated, we remove the
>> finobt record. If the inode chunk was previously full, we must
>> insert a new record based on the existing inobt record. Otherwise,
>> we modify the record in place.
>>
>> Create the xfs_ifree_finobt() function to identify the potential
>> scenarios and update the finobt appropriately.
> 
> The first thing I'd do is factor all the inobt manipulation
> code xfs_difree() into a xfs_difree_inobt() helper function. have it
> return the record and offset that is then passed to your new helper
> xfs_difree_finobt(). That way xfs_difree() really becomes the setup
> function for the two btree operations rather than containing one set
> of modifications and calling a function to do the other...
> 

Sounds logical.

>> Signed-off-by: Brian Foster <bfoster@redhat.com>
>> ---
>>  fs/xfs/xfs_ialloc.c | 120 ++++++++++++++++++++++++++++++++++++++++++++++++++++
>>  1 file changed, 120 insertions(+)
>>
>> diff --git a/fs/xfs/xfs_ialloc.c b/fs/xfs/xfs_ialloc.c
>> index 516f4af..96f71b5 100644
>> --- a/fs/xfs/xfs_ialloc.c
>> +++ b/fs/xfs/xfs_ialloc.c
>> @@ -198,6 +198,117 @@ xfs_inobt_insert(
>>  }
>>  
>>  /*
>> + * Free an inode in the free inode btree.
>> + */
>> +STATIC int
>> +xfs_ifree_finobt(
...
> 
> I can't say I'm a great fan of the layout of the logic. Yes, there's
> lots of cases to handle. It looks like:
> 

Yeah, I've shuffled this code around quite a bit myself.

> 	lookup()
> 	if (found)
> 		modify in place
> 	if (found && full && deleting chunks)
> 		delete record
> 	else if (!found && no record)
> 		insert record
> 	else if (found)
> 		update record
> 	else
> 		corruption!
> 
> I think it woul dbe better to get then "!found" case out of the way
> at the start. ie
> 
> 	if (i == 0) {
> 		if (ibtrec->ir_freecount == 1)
> 			insert record
> 		else
> 			CORRUPTION
> 		goto out;
> 	}
> 
> 	/* found a record, no need to check i == 1 anymore */
> 	ASSERT(i == 1);
> 
> 	/* read and update */
> 
> 	if (full && deleting chunks)
> 		delete record
> 	else
> 		update record
> 

Ok, I'll try to pull that logic up and see what falls out.

...
>> +	} else if ((i == 0) && (ibtrec->ir_freecount == 1)) {
>> +		/*
>> +		 * No existing finobt record and the inobt record has a single
>> +		 * free inode. This means we've freed an inode in a previously
>> +		 * fully allocated chunk. Insert a new record into the finobt
>> +		 * based on the current inobt record.
>> +		 */
>> +		cur->bc_rec.i.ir_startino = ibtrec->ir_startino;
>> +		cur->bc_rec.i.ir_free = ibtrec->ir_free;
>> +		cur->bc_rec.i.ir_freecount = ibtrec->ir_freecount;
>> +		error = xfs_btree_insert(cur, &i);
>> +		if (error)
>> +			goto error;
>> +		ASSERT(i == 1);
> 
> That's rather similar to the code in xfs_inobt_insert(). Indeed,
> is you write a helper - xfs_inobt_insert_rec() - for this, then rather than modifying
> xfs_inobt_lookup() to take extra parameters like I wondered for the
> previous patch, leave it alonge and pass the parameters to
> xfs_inobt_insert_rec() instead.
> 
> Then this code is functionally identical to xfs_inobt_insert() done
> during allocation....
> 

I think I'm parsing you after having another look at the code.
xfs_inobt_lookup() remains as is and is potentially used from
xfs_inobt_insert(). xfs_inobt_insert_rec() is introduced to set the
cursor fields and do the insert and is used here and from
xfs_inobt_insert().

At that point, this looks close to xfs_inobt_insert(), but I think using
that here would introduce a duplicate lookup. Regardless, we'll see what
the whole thing looks like at that point. Thanks for the reviews. :)

Brian

> Cheers,
> 
> Dave.
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
