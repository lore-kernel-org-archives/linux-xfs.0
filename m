Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 04A017F3F
	for <xfs@oss.sgi.com>; Thu,  5 Sep 2013 11:20:49 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id CAA2630408B
	for <xfs@oss.sgi.com>; Thu,  5 Sep 2013 09:20:45 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id mE7qeJk0S5kiZqr0 for
	<xfs@oss.sgi.com>; Thu, 05 Sep 2013 09:20:44 -0700 (PDT)
Message-ID: <5228AE80.5050908@redhat.com>
Date: Thu, 05 Sep 2013 12:17:04 -0400
From: Brian Foster <bfoster@redhat.com>
MIME-Version: 1.0
Subject: Re: [RFC PATCH 03/11] xfs: support the XFS_BTNUM_FINOBT free inode
	btree type
References: <1378232708-57156-1-git-send-email-bfoster@redhat.com>
	<1378232708-57156-4-git-send-email-bfoster@redhat.com>
	<20130905005428.GQ23571@dastard>
In-Reply-To: <20130905005428.GQ23571@dastard>
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

On 09/04/2013 08:54 PM, Dave Chinner wrote:
> On Tue, Sep 03, 2013 at 02:25:00PM -0400, Brian Foster wrote:
>> Define the AGI fields for the finobt root/level and add magic
>> numbers. Update the btree code to add support for the new
>> XFS_BTNUM_FINOBT inode btree.
>>
>> The finobt root block is reserved immediately following the inobt
>> root block in the AG. Update XFS_PREALLOC_BLOCKS() to determine the
>> starting AG data block based on whether finobt support is enabled.
> 
> A few minor things...
> 
>>
>> Signed-off-by: Brian Foster <bfoster@redhat.com>
>> ---
>>  fs/xfs/xfs_ag.h           |  7 ++++++-
>>  fs/xfs/xfs_btree.c        |  6 ++++--
>>  fs/xfs/xfs_btree.h        |  3 +++
>>  fs/xfs/xfs_ialloc.c       |  2 ++
>>  fs/xfs/xfs_ialloc_btree.c | 29 +++++++++++++++++++++++------
>>  fs/xfs/xfs_ialloc_btree.h | 14 +++++++++++++-
>>  fs/xfs/xfs_log_recover.c  |  2 ++
>>  fs/xfs/xfs_stats.h        | 18 +++++++++++++++++-
>>  fs/xfs/xfs_types.h        |  2 +-
>>  9 files changed, 71 insertions(+), 12 deletions(-)
>>
>> diff --git a/fs/xfs/xfs_ag.h b/fs/xfs/xfs_ag.h
>> index 1cb740a..b85585d 100644
>> --- a/fs/xfs/xfs_ag.h
>> +++ b/fs/xfs/xfs_ag.h
>> @@ -166,6 +166,9 @@ typedef struct xfs_agi {
>>  	__be32		agi_pad32;
>>  	__be64		agi_lsn;	/* last write sequence */
>>  
>> +	__be32		agi_free_root; /* root of the free inode btree */
>> +	__be32		agi_free_level;/* levels in free inode btree */
>> +
>>  	/* structure must be padded to 64 bit alignment */
>>  } xfs_agi_t;
> 
> That's fine, but...
>>  
>> @@ -180,7 +183,9 @@ typedef struct xfs_agi {
>>  #define	XFS_AGI_NEWINO		0x00000100
>>  #define	XFS_AGI_DIRINO		0x00000200
>>  #define	XFS_AGI_UNLINKED	0x00000400
>> -#define	XFS_AGI_NUM_BITS	11
>> +#define	XFS_AGI_FREE_ROOT	0x00000800
>> +#define	XFS_AGI_FREE_LEVEL	0x00001000
>> +#define	XFS_AGI_NUM_BITS	13
>>  #define	XFS_AGI_ALL_BITS	((1 << XFS_AGI_NUM_BITS) - 1)
> 
> This is a bit of a problem, because the range logging bits will now
> cause the entire AGI to be logged (including all the unlinked list
> hash) because these only define the first/last offsets to be
> logged...
> 

Ok, I see what you mean here...

>> diff --git a/fs/xfs/xfs_ialloc.c b/fs/xfs/xfs_ialloc.c
>> index 524aa88..5ced506 100644
>> --- a/fs/xfs/xfs_ialloc.c
>> +++ b/fs/xfs/xfs_ialloc.c
>> @@ -1505,6 +1505,8 @@ xfs_ialloc_log_agi(
>>  		offsetof(xfs_agi_t, agi_newino),
>>  		offsetof(xfs_agi_t, agi_dirino),
>>  		offsetof(xfs_agi_t, agi_unlinked),
>> +		offsetof(xfs_agi_t, agi_free_root),
>> +		offsetof(xfs_agi_t, agi_free_level),
>>  		sizeof(xfs_agi_t)
>>  	};
> 
> Because of how this table works.
> 
> What we really need here is for xfs_ialloc_log_agi to consider that
> there are two distinct regions for range logging - the first spaces
> from offset 0 to offset of agi_unlinked, and the second is from the
> the offset of agi_free_root to the end of the xfs_agi_t....
> 
> It's abit messy, I know, but we couldn't easily add new padding to
> the AGI in the existing range logging area like was done for the AGF
> because of the unlinked list hash table already defining the end of
> the range logging region....
> 

... but where would that ever happen? The existing invocations of
xfs_ialloc_log_agi() seem to log either the agi inode count values or
the btree root/level values (i.e., never the range across both). I think
I've introduced at least a couple new invocations throughout this set,
but I've not changed that model (i.e., an XFS_AGI_FREECOUNT instance in
the new lookup code and an XFS_AGI_FREE_ROOT|*_LEVEL instance in the new
btree code).

My understanding of this code is that the range to log is defined at
invocation time to xfs_iallog_log_agi(), so if the callers never specify
a range that includes the unlinked bits in a single call, we won't set
that range in the buffer log item code. In other words, even if we
ultimately happen to log both ranges in the agi, the lower level code
will never expand the logged region. Therefore, this shouldn't happen
unless a single invocation that specifies one of the
XFS_AGI_FREE_ROOT/LEVEL bits also specifies one of the existing agi bits.

I could see breaking this up as a matter of preparation for future
fields or calls that would introduce logging that kind of range, but at
the same time (and assuming my interpretation of above is correct),
that's a bit of code that serves no purpose for the foreseeable future.
Perhaps a comment in xfs_ialloc_log_agi() and the one caller that uses
the AGI_FREE_* bits to document this restriction is sufficient?

>>  #ifdef DEBUG
>> diff --git a/fs/xfs/xfs_ialloc_btree.c b/fs/xfs/xfs_ialloc_btree.c
>> index 0cdb88b..7923292 100644
>> --- a/fs/xfs/xfs_ialloc_btree.c
>> +++ b/fs/xfs/xfs_ialloc_btree.c
>> @@ -62,10 +62,18 @@ xfs_inobt_set_root(
>>  {
>>  	struct xfs_buf		*agbp = cur->bc_private.a.agbp;
>>  	struct xfs_agi		*agi = XFS_BUF_TO_AGI(agbp);
>> -
>> -	agi->agi_root = nptr->s;
>> -	be32_add_cpu(&agi->agi_level, inc);
>> -	xfs_ialloc_log_agi(cur->bc_tp, agbp, XFS_AGI_ROOT | XFS_AGI_LEVEL);
>> +	int			fields;
>> +
>> +	if (cur->bc_btnum == XFS_BTNUM_INO) {
>> +		agi->agi_root = nptr->s;
>> +		be32_add_cpu(&agi->agi_level, inc);
>> +		fields = XFS_AGI_ROOT | XFS_AGI_LEVEL;
>> +	} else {
>> +		agi->agi_free_root = nptr->s;
>> +		be32_add_cpu(&agi->agi_free_level, inc);
>> +		fields = XFS_AGI_FREE_ROOT | XFS_AGI_FREE_LEVEL;
>> +	}
>> +	xfs_ialloc_log_agi(cur->bc_tp, agbp, fields);
>>  }
> 
> I suspect that it would be better to have separate functions for
> these differences i.e. xfs_inobt_set_root() and
> xfs_finobt_set_root(), and set up separate btree ops structure
> forthe two different trees. Most of the code is still identical,
> but the differences in root structures can easily be handled without
> putting switches in the code everywhere.
> 

Ok, I'm assuming the suggestion is to only create new functions for the
implementations that differ.

>>  
>>  STATIC int
>> @@ -172,7 +180,10 @@ xfs_inobt_init_ptr_from_cur(
>>  
>>  	ASSERT(cur->bc_private.a.agno == be32_to_cpu(agi->agi_seqno));
>>  
>> -	ptr->s = agi->agi_root;
>> +	if (cur->bc_btnum == XFS_BTNUM_INO)
>> +		ptr->s = agi->agi_root;
>> +	else
>> +		ptr->s = agi->agi_free_root;
>>  }
> 
> Like this...
> 
>>  
>>  STATIC __int64_t
>> @@ -205,6 +216,7 @@ xfs_inobt_verify(
>>  	 */
>>  	switch (block->bb_magic) {
>>  	case cpu_to_be32(XFS_IBT_CRC_MAGIC):
>> +	case cpu_to_be32(XFS_FIBT_CRC_MAGIC):
>>  		if (!xfs_sb_version_hascrc(&mp->m_sb))
>>  			return false;
>>  		if (!uuid_equal(&block->bb_u.s.bb_uuid, &mp->m_sb.sb_uuid))
>> @@ -216,6 +228,7 @@ xfs_inobt_verify(
>>  			return false;
>>  		/* fall through */
>>  	case cpu_to_be32(XFS_IBT_MAGIC):
>> +	case cpu_to_be32(XFS_FIBT_MAGIC):
>>  		break;
>>  	default:
>>  		return 0;
>> @@ -335,8 +348,12 @@ xfs_inobt_init_cursor(
>>  
>>  	cur->bc_tp = tp;
>>  	cur->bc_mp = mp;
>> -	cur->bc_nlevels = be32_to_cpu(agi->agi_level);
>>  	cur->bc_btnum = btnum;
>> +	if (btnum == XFS_BTNUM_INO)
>> +		cur->bc_nlevels = be32_to_cpu(agi->agi_level);
>> +	else
>> +		cur->bc_nlevels = be32_to_cpu(agi->agi_free_level);
>> +
>>  	cur->bc_blocklog = mp->m_sb.sb_blocklog;
>>  
>>  	cur->bc_ops = &xfs_inobt_ops;
> 
> And this is where you do the check on the btnum and set the
> appropriate ops structure....
> 

Ok.

>>  #define	XFS_INODES_PER_CHUNK		(NBBY * sizeof(xfs_inofree_t))
>> @@ -73,7 +75,17 @@ typedef __be32 xfs_inobt_ptr_t;
>>   * block numbers in the AG.
>>   */
>>  #define	XFS_IBT_BLOCK(mp)		((xfs_agblock_t)(XFS_CNT_BLOCK(mp) + 1))
>> -#define	XFS_PREALLOC_BLOCKS(mp)		((xfs_agblock_t)(XFS_IBT_BLOCK(mp) + 1))
>> +#define	XFS_FIBT_BLOCK(mp)		((xfs_agblock_t)(XFS_IBT_BLOCK(mp) + 1))
>> +
>> +/*
>> + * The first data block of an AG depends on whether the filesystem was formatted
>> + * with the finobt feature. If so, account for the finobt reserved root btree
>> + * block.
>> + */
>> +#define XFS_PREALLOC_BLOCKS(mp) \
>> +	(xfs_sb_version_hasfinobt(&((mp)->m_sb)) ? \
>> +	 XFS_FIBT_BLOCK(mp) + 1 : \
>> +	 XFS_IBT_BLOCK(mp) + 1)
> 
> Yup, that looks sensible, with a nice comment to explain it :)
> 
>> diff --git a/fs/xfs/xfs_stats.h b/fs/xfs/xfs_stats.h
>> index c03ad38..c8f238b 100644
>> --- a/fs/xfs/xfs_stats.h
>> +++ b/fs/xfs/xfs_stats.h
>> @@ -183,7 +183,23 @@ struct xfsstats {
>>  	__uint32_t		xs_ibt_2_alloc;
>>  	__uint32_t		xs_ibt_2_free;
>>  	__uint32_t		xs_ibt_2_moves;
>> -#define XFSSTAT_END_XQMSTAT		(XFSSTAT_END_IBT_V2+6)
>> +#define XFSSTAT_END_FIBT_V2		(XFSSTAT_END_IBT_V2+15)
>> +	__uint32_t		xs_fibt_2_lookup;
>> +	__uint32_t		xs_fibt_2_compare;
>> +	__uint32_t		xs_fibt_2_insrec;
>> +	__uint32_t		xs_fibt_2_delrec;
>> +	__uint32_t		xs_fibt_2_newroot;
>> +	__uint32_t		xs_fibt_2_killroot;
>> +	__uint32_t		xs_fibt_2_increment;
>> +	__uint32_t		xs_fibt_2_decrement;
>> +	__uint32_t		xs_fibt_2_lshift;
>> +	__uint32_t		xs_fibt_2_rshift;
>> +	__uint32_t		xs_fibt_2_split;
>> +	__uint32_t		xs_fibt_2_join;
>> +	__uint32_t		xs_fibt_2_alloc;
>> +	__uint32_t		xs_fibt_2_free;
>> +	__uint32_t		xs_fibt_2_moves;
>> +#define XFSSTAT_END_XQMSTAT		(XFSSTAT_END_FIBT_V2+6)
>>  	__uint32_t		xs_qm_dqreclaims;
>>  	__uint32_t		xs_qm_dqreclaim_misses;
>>  	__uint32_t		xs_qm_dquot_dups;
> 
> I didn't see an equivalent change to add these new stats to the proc
> file output (ie. in xfs_stat_proc_show()). maybe I just missed it,
> but if I didn't, can you add it?
> 

Yeah, that's missing. Good catch. I think I added these bits on some
kind of compilation failure or warning and I hadn't gone back to check
that they were used anywhere. :P

Brian

> Cheers,
> 
> Dave.
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
