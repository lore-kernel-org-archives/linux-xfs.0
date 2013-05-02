Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 2975A7F55
	for <xfs@oss.sgi.com>; Thu,  2 May 2013 01:55:21 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 09B1F8F8037
	for <xfs@oss.sgi.com>; Wed,  1 May 2013 23:55:20 -0700 (PDT)
Message-ID: <51820DCC.4070606@oracle.com>
Date: Thu, 02 May 2013 14:55:08 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: Re: [PATCH 1/2] xfs: Remove XFS_MOUNT_RETERR
References: <518125C9.8000008@oracle.com> <20130502011211.GR10481@dastard>
In-Reply-To: <20130502011211.GR10481@dastard>
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
Cc: Mark Tinguely <tinguely@sgi.com>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On 05/02/2013 09:12 AM, Dave Chinner wrote:
> On Wed, May 01, 2013 at 10:25:13PM +0800, Jeff Liu wrote:
>> From: Jie Liu <jeff.liu@oracle.com>
>>
>> XFS_MOUNT_RETERR is going to be set at xfs_parseargs() if
>> mp->m_dalign is enabled, so any time we enter "if (mp->m_dalign)"
>> branch in xfs_update_alignment(), XFS_MOUNT_RETERR is set and
>> so we always be emitting a warning and returning an error.
>>
>> Hence, we can remove it and get rid of a couple of redundant
>> check up against it at xfs_upate_alignment(). 
>>
>> Thanks Dave Chinner for the confirmation.
>>
>> Signed-off-by: Jie Liu <jeff.liu@oracle.com>
>> Cc: Dave Chinner <dchinner@redhat.com>
>> Cc: Mark Tinguely <tinguely@sgi.com>
>> ---
>>  fs/xfs/xfs_mount.c |   39 ++++++++++++---------------------------
>>  fs/xfs/xfs_mount.h |    2 --
>>  fs/xfs/xfs_super.c |    5 +----
>>  3 files changed, 13 insertions(+), 33 deletions(-)
>>
>> diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
>> index 3806088..29e8de8 100644
>> --- a/fs/xfs/xfs_mount.c
>> +++ b/fs/xfs/xfs_mount.c
>> @@ -872,42 +872,27 @@ xfs_update_alignment(xfs_mount_t *mp)
>>  		 */
>>  		if ((BBTOB(mp->m_dalign) & mp->m_blockmask) ||
>>  		    (BBTOB(mp->m_swidth) & mp->m_blockmask)) {
>> -			if (mp->m_flags & XFS_MOUNT_RETERR) {
>> -				xfs_warn(mp, "alignment check failed: "
>> -					 "(sunit/swidth vs. blocksize)");
>> -				return XFS_ERROR(EINVAL);
>> -			}
>> -			mp->m_dalign = mp->m_swidth = 0;
>> +			xfs_warn(mp, "alignment check failed: "
>> +				 "(sunit/swidth vs. blocksize)");
> 
> Let's convert these format strings to a single line at the same
> time and be consistent with output. ie:
> 
> 			xfs_warn(mp,
> 	"alignment check failed: sunit/swidth vs. blocksize(%d)",
> 				sbp->sb_blocksize);
Ok.
> 
>> +			return XFS_ERROR(EINVAL);
>>  		} else {
>>  			/*
>>  			 * Convert the stripe unit and width to FSBs.
>>  			 */
>>  			mp->m_dalign = XFS_BB_TO_FSBT(mp, mp->m_dalign);
>>  			if (mp->m_dalign && (sbp->sb_agblocks % mp->m_dalign)) {
>> -				if (mp->m_flags & XFS_MOUNT_RETERR) {
>> -					xfs_warn(mp, "alignment check failed: "
>> -						 "(sunit/swidth vs. ag size)");
>> -					return XFS_ERROR(EINVAL);
>> -				}
>> -				xfs_warn(mp,
>> -		"stripe alignment turned off: sunit(%d)/swidth(%d) "
>> -		"incompatible with agsize(%d)",
>> -					mp->m_dalign, mp->m_swidth,
>> -					sbp->sb_agblocks);
>> -
>> -				mp->m_dalign = 0;
>> -				mp->m_swidth = 0;
>> +				xfs_warn(mp, "alignment check failed: "
>> +			"sunit(%d)/swidth(%d) incompatible with agsize(%d)",
> 
> 	"alignment check failed: sunit/swidth vs. agsize(%d)",
> 					sbp->sb_agblocks);
> 
>> +					 mp->m_dalign, mp->m_swidth,
>> +					 sbp->sb_agblocks);
>> +				return XFS_ERROR(EINVAL);
>>  			} else if (mp->m_dalign) {
>>  				mp->m_swidth = XFS_BB_TO_FSBT(mp, mp->m_swidth);
>>  			} else {
>> -				if (mp->m_flags & XFS_MOUNT_RETERR) {
>> -					xfs_warn(mp, "alignment check failed: "
>> -						"sunit(%d) less than bsize(%d)",
>> -						mp->m_dalign,
>> -						mp->m_blockmask +1);
>> -					return XFS_ERROR(EINVAL);
>> -				}
>> -				mp->m_swidth = 0;
>> +				xfs_warn(mp, "alignment check failed: "
>> +					 "sunit(%d) less than bsize(%d)",
>> +					 mp->m_dalign, mp->m_blockmask + 1);
> 
> 	"alignment check failed: sunit(%d) less than bsize(%d)",
> 					mp->m_dalign, sbp->sb_blocksize);
>> +				return XFS_ERROR(EINVAL);
>>  			}
>>  		}
>>  
>> diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
>> index bc90706..8145412 100644
>> --- a/fs/xfs/xfs_mount.h
>> +++ b/fs/xfs/xfs_mount.h
>> @@ -230,8 +230,6 @@ typedef struct xfs_mount {
>>  						   operations, typically for
>>  						   disk errors in metadata */
>>  #define XFS_MOUNT_DISCARD	(1ULL << 5)	/* discard unused blocks */
>> -#define XFS_MOUNT_RETERR	(1ULL << 6)     /* return alignment errors to
>> -						   user */
>>  #define XFS_MOUNT_NOALIGN	(1ULL << 7)	/* turn off stripe alignment
>>  						   allocations */
>>  #define XFS_MOUNT_ATTR2		(1ULL << 8)	/* allow use of attr2 format */
>> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
>> index ea341ce..51da4d2 100644
>> --- a/fs/xfs/xfs_super.c
>> +++ b/fs/xfs/xfs_super.c
>> @@ -446,11 +446,8 @@ done:
>>  		 * Before the mount call ends we will convert
>>  		 * these to FSBs.
>>  		 */
>> -		if (dsunit) {
>> +		if (dsunit)
>>  			mp->m_dalign = dsunit;
>> -			mp->m_flags |= XFS_MOUNT_RETERR;
>> -		}
>> -
>>  		if (dswidth)
>>  			mp->m_swidth = dswidth;
> 
> This code can be simplified, too. We've already done this check:
> 
> 	if ((dsunit && !dswidth) || (!dsunit && dswidth)) {
>                 xfs_warn(mp, "sunit and swidth must be specified together");
>                 return EINVAL;
>         }
> 
> So we know that dsunit/dswidth are either both zero or both set, so
> the above code could simply end up as:
> 
>         if (dsunit && !(mp->m_flags & XFS_MOUNT_NOALIGN)) {
>                 /*
>                  * At this point the superblock has not been read
>                  * in, therefore we do not know the block size.
>                  * Before the mount call ends we will convert
>                  * these to FSBs.
>                  */
> 		mp->m_dalign = dsunit;
> 		mp->m_swidth = dswidth;
>         }
Exactly, will take care of this in next round of post.

Thanks,
-Jeff

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
