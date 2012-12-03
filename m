Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qB32qJB3040985 for <xfs@oss.sgi.com>; Sun, 2 Dec 2012 20:52:19 -0600
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id 9x6TuR7jR3xIjPSA (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Sun, 02 Dec 2012 18:54:39 -0800 (PST)
Message-ID: <50BC1458.2000609@oracle.com>
Date: Mon, 03 Dec 2012 10:54:16 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: Re: [PATCH 01/15] xfs: Add a new transaction for changing ag state
References: <50A5E0E7.7010002@oracle.com> <20121203012453.GF29399@dastard>
In-Reply-To: <20121203012453.GF29399@dastard>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On 12/03/2012 09:24 AM, Dave Chinner wrote:
> On Fri, Nov 16, 2012 at 02:44:55PM +0800, Jeff Liu wrote:
>> This a new tranaction which would be use for Changing AG state via ioctl(2)
>>
>> Signed-off-by: Jie Liu <jeff.liu@oracle.com>
>> ---
>>  fs/xfs/xfs_mount.h |    1 +
>>  fs/xfs/xfs_trans.c |   12 ++++++++++++
>>  fs/xfs/xfs_trans.h |    8 +++++---
>>  3 files changed, 18 insertions(+), 3 deletions(-)
>>
>> diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
>> index deee09e..4fe2232 100644
>> --- a/fs/xfs/xfs_mount.h
>> +++ b/fs/xfs/xfs_mount.h
>> @@ -40,6 +40,7 @@ typedef struct xfs_trans_reservations {
>>  	uint	tr_growrtalloc;	/* grow realtime allocations */
>>  	uint	tr_growrtzero;	/* grow realtime zeroing */
>>  	uint	tr_growrtfree;	/* grow realtime freeing */
>> +	uint	tr_setagstate;	/* set a.g. state trans */
>>  } xfs_trans_reservations_t;
>>  
>>  #ifndef __KERNEL__
>> diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
>> index 06ed520..5a5c4d8 100644
>> --- a/fs/xfs/xfs_trans.c
>> +++ b/fs/xfs/xfs_trans.c
>> @@ -531,6 +531,17 @@ xfs_calc_clear_agi_bucket_reservation(
>>  }
>>  
>>  /*
>> + * Setting the state of an allocation group.
>> + *	agf of the ag: sector size
>> + */
>> +STATIC uint
>> +xfs_calc_set_agstate_reservation(
>> +	struct xfs_mount	*mp)
>> +{
>> +	return mp->m_sb.sb_sectsize + 128;
>> +}
> 
> I know you are just copying other code,
Yes, I read the comments of what's the meaning of 128 at xfs_trans.c,
then just copied over xfs_calc_clear_agi_bucket_reservation() to it.

> but what we really need to
> do here is get rid of all these magic "128" numbers in the
> transaction reservations. 
> 
> What the 128 is actually reserving is space for the
> struct xfs_buf_log_format that gets written into the log for every
> buffer. i.e. the space needed for this structure:
> 
> struct xfs_buf_log_format {
>         short unsigned int         blf_type;             /*     0     2 */
>         short unsigned int         blf_size;             /*     2     2 */
>         ushort                     blf_flags;            /*     4     2 */
>         ushort                     blf_len;              /*     6     2 */
>         __int64_t                  blf_blkno;            /*     8     8 */
>         unsigned int               blf_map_size;         /*    16     4 */
>         unsigned int               blf_data_map[16];     /*    20    64 */
>         /* --- cacheline 1 boundary (64 bytes) was 20 bytes ago --- */
> 
>         /* size: 88, cachelines: 2, members: 7 */
>         /* padding: 4 */
>         /* last cacheline: 24 bytes */
> };
> 
> It's rounded up to give a little bit of extra space because there's
> it also needs a log opheader:
> 
> struct xlog_op_header {
>         __be32                     oh_tid;               /*     0     4 */
>         __be32                     oh_len;               /*     4     4 */
>         __u8                       oh_clientid;          /*     8     1 */
>         __u8                       oh_flags;             /*     9     1 */
>         __u16                      oh_res2;              /*    10     2 */
> 
>         /* size: 12, cachelines: 1, members: 5 */
>         /* last cacheline: 12 bytes */
> };
> 
> So there's at least 100 bytes of extra information per buffer that
> needs to be recorded with the buffer itself. Rounding it up to 128
> bytes is probably just fine, though it should probably be done
> programatically rather than hand coded.
> 
> As such I'd like to see this sort of thing encoded in a macro or
> inline function so the above code becomes something like:
> 
> 	return mp->m_sb.sb_sectsize + xfs_buf_log_overhead(mp);
> 
> 
> and
> 
> /*
>  * A buffer has a format structure overhead in the log in addition
>  * to the data, so we need to take this into account when reserving
>  * space in a transaction for a buffer. Round the space required up
>  * to a multiple of 128 bytes so that we don't change the historical
>  * reservation that has ben used for this overhead.
>  */
> static inline int
> xfs_buf_log_overhead()
> {
> 	return round_up(sizeof(struct xlog_op_header) +
> 			sizeof(struct xfs_buf_log_format), 128);
> }
Thanks for your teaching!

We hard-coded '128' in almost all of those transaction reservations,
is it time to get rid of it according to your comments above?

I'd like to do it if you have no time to deal with such trivial things. 

Thanks,
-Jeff

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
