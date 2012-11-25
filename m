Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qAPIvAPl079972 for <xfs@oss.sgi.com>; Sun, 25 Nov 2012 12:57:10 -0600
Message-ID: <50B26A8B.8040207@sgi.com>
Date: Sun, 25 Nov 2012 12:59:23 -0600
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 2/2] xfs: fix the buffer log format for contiguous buffers
References: <20121120224120.224166649@sgi.com>
	<20121120224146.479983109@sgi.com> <20121123014714.GB32450@dastard>
In-Reply-To: <20121123014714.GB32450@dastard>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On 11/22/12 19:47, Dave Chinner wrote:
> On Tue, Nov 20, 2012 at 04:41:22PM -0600, Mark Tinguely wrote:
>> A few buffer log format clean-ups for contiguous buffers.
>>
>> In xfs_buf_item_format_segment(), when a segment is not dirty in
>> the transaction, do not increment format vector pointer.
>>
>> In xfs_buf_item_unlock(), every segment must be empty before
>> considering the buf item empty.
>>
>> In xfs_trans_binval(), clear the correct buffer log format structure.
>>
>> Signed-off-by: Mark Tinguely<tinguely@sgi.com>
>>
>> ---
>>   fs/xfs/xfs_buf_item.c  |   32 +++++++++++++++++++++++---------
>>   fs/xfs/xfs_trans_buf.c |    4 ++--
>>   2 files changed, 25 insertions(+), 11 deletions(-)
>>
>> Index: b/fs/xfs/xfs_buf_item.c
>> ===================================================================
>> --- a/fs/xfs/xfs_buf_item.c
>> +++ b/fs/xfs/xfs_buf_item.c
>> @@ -71,7 +71,7 @@ xfs_buf_item_log_debug(
>>   		chunk_num = byte>>  XFS_BLF_SHIFT;
>>   		word_num = chunk_num>>  BIT_TO_WORD_SHIFT;
>>   		bit_num = chunk_num&  (NBWORD - 1);
>> -		wordp =&(bip->bli_format.blf_data_map[word_num]);
>> +		wordp =&(bip->bli_formats[0].blf_data_map[word_num]);
>>   		bit_set = *wordp&  (1<<  bit_num);
>>   		ASSERT(bit_set);
>>   		byte++;
>
> This debug code is a lot more broken than just this. It's completely
> unaware of discontiguous buffers....
>
> I'm wondering if we should just remove the XFS_TRANS_DEBUG code
> because it doesn't ever get used....
>

Okay. I will do that separately. Want to leave the XFS_TRANS_DEBUG for 
the inode, inode_item and AIL or remove it completely?

>> @@ -290,8 +290,6 @@ xfs_buf_item_format_segment(
>>   	vecp->i_addr = blfp;
>>   	vecp->i_len = base_size;
>>   	vecp->i_type = XLOG_REG_TYPE_BFORMAT;
>> -	vecp++;
>> -	nvecs = 1;
>>
>>   	if (bip->bli_flags&  XFS_BLI_STALE) {
>>   		/*
>> @@ -301,7 +299,8 @@ xfs_buf_item_format_segment(
>>   		 */
>>   		trace_xfs_buf_item_format_stale(bip);
>>   		ASSERT(blfp->blf_flags&  XFS_BLF_CANCEL);
>> -		blfp->blf_size = nvecs;
>> +		vecp++;
>> +		blfp->blf_size = 1;
>>   		return vecp;
>>   	}
>
> I don't really like this separation of the blf vector initialisation
> and the decision to use the vector. If we are not going to use it,
> then we should really be initialising it.....
>
>>
>> @@ -309,7 +308,16 @@ xfs_buf_item_format_segment(
>>   	 * Fill in an iovec for each set of contiguous chunks.
>>   	 */
>>   	first_bit = xfs_next_bit(blfp->blf_data_map, blfp->blf_map_size, 0);
>> -	ASSERT(first_bit != -1);
>> +	if (first_bit == -1) {
>> +		/* If the map is not be dirty in the transaction, mark
>> +		 * the size as zero and do not advance the vector pointer.
>> +		 */
>> +		blfp->blf_size = 0;
>> +		return(vecp);
>> +	}
>
> Indeed, if this is the last segment in the discontiguous buffer,
> the above vecp initialisation could be writing beyond then end of
> the vector space that has been allocated. i.e. we should only
> initialise it if we are going to consume the vector.
>

I see your point. I will change that.

>
>> @@ -601,7 +609,7 @@ xfs_buf_item_unlock(
>>   {
>>   	struct xfs_buf_log_item	*bip = BUF_ITEM(lip);
>>   	struct xfs_buf		*bp = bip->bli_buf;
>> -	int			aborted;
>> +	int			aborted, empty, i;
>>   	uint			hold;
>>
>>   	/* Clear the buffer's association with this transaction. */
>> @@ -644,8 +652,14 @@ xfs_buf_item_unlock(
>>   	 * If the buf item isn't tracking any data, free it, otherwise drop the
>>   	 * reference we hold to it.
>>   	 */
>> -	if (xfs_bitmap_empty(bip->bli_format.blf_data_map,
>> -			     bip->bli_format.blf_map_size))
>> +	empty = 1;
>> +	for (i = 0; i<  bip->bli_format_count; i++)
>> +		if (!xfs_bitmap_empty(bip->bli_formats[i].blf_data_map,
>> +			     bip->bli_formats[i].blf_map_size)) {
>> +			empty = 0;
>> +			break;
>> +		}
>
> Landmine warning!
>
> Please put {} around the body of the for loop.
>
> FWIW this is a separate problem so it should be in it's own patch.
>

okay.

>> +	if (empty)
>>   		xfs_buf_item_relse(bp);
>>   	else
>>   		atomic_dec(&bip->bli_refcount);
>> Index: b/fs/xfs/xfs_trans_buf.c
>> ===================================================================
>> --- a/fs/xfs/xfs_trans_buf.c
>> +++ b/fs/xfs/xfs_trans_buf.c
>> @@ -670,8 +670,8 @@ xfs_trans_binval(
>>   	bip->bli_flags&= ~(XFS_BLI_INODE_BUF | XFS_BLI_LOGGED | XFS_BLI_DIRTY);
>>   	bip->bli_format.blf_flags&= ~XFS_BLF_INODE_BUF;
>>   	bip->bli_format.blf_flags |= XFS_BLF_CANCEL;
>> -	memset((char *)(bip->bli_format.blf_data_map), 0,
>> -	      (bip->bli_format.blf_map_size * sizeof(uint)));
>> +	memset((char *)(bip->bli_formats[0].blf_data_map), 0,
>> +	      (bip->bli_formats[0].blf_map_size * sizeof(uint)));
>
> This is also wrong. i.e. Why is the code only zeroing a single map
> and not all maps? If the above xfs_bitmap_empty() check is checking
> all the segments, then we have to ensure that we zero all the
> segments here.  This is why the current code works and doesn't cause
> problems - matching bugs that cancel each other out - but only
> fixing one of the bugs will cause regressions. This should also be
> in the patch that fixes the xfs_bitmap_empty() problem.
>

Thank-you for the feed back.

--Mark.
> Cheers,
>
> Dave.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
