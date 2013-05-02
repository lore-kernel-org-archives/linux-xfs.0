Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 744E77F53
	for <xfs@oss.sgi.com>; Thu,  2 May 2013 10:26:36 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 324DC8F8049
	for <xfs@oss.sgi.com>; Thu,  2 May 2013 08:26:36 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id pAgHTnhPUHH4v5mJ (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 02 May 2013 08:26:34 -0700 (PDT)
Message-ID: <5182859B.4080207@oracle.com>
Date: Thu, 02 May 2013 23:26:19 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfs: fix log space reservation calculation if log stripe
	unit is specified
References: <51813BA5.3070306@oracle.com> <20130502024158.GW10481@dastard>
In-Reply-To: <20130502024158.GW10481@dastard>
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
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On 05/02/2013 10:41 AM, Dave Chinner wrote:
> On Wed, May 01, 2013 at 11:58:29PM +0800, Jeff Liu wrote:
>> Hello,
>>
>> About two weeks ago, Dave has found an issue by running xfstests/297.
>> http://oss.sgi.com/archives/xfs/2013-03/msg00273.html
> ...
>>
>> ---
>>  fs/xfs/xfs_log.c   |  130 ++++++++++++++++++++++++++++++++++-------
>>  fs/xfs/xfs_log.h   |    3 +
>>  fs/xfs/xfs_mount.c |    1 +
>>  fs/xfs/xfs_mount.h |   61 +++++++++++---------
>>  fs/xfs/xfs_trans.c |  163 +++++++++++++++++++++++++++++++++++++++++++---------
>>  fs/xfs/xfs_trans.h |   61 ++++++++++----------
>>  6 files changed, 314 insertions(+), 105 deletions(-)
> 
> Hmmmm. That's a lot more change that I expected.....
I don't want to make more changes as well, but....
> 
>> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
>> index eec226f..3efd1d2 100644
>> --- a/fs/xfs/xfs_log.c
>> +++ b/fs/xfs/xfs_log.c
>> @@ -598,6 +598,64 @@ xfs_log_release_iclog(
>>  }
>>   /*
>> + * Check if the specified log space is sufficient for a file system
>> + * with a given log strip unit.
>> + */
>> +STATIC int
>> +xfs_mount_validate_log_size(
>> +	struct xfs_mount	*mp)
>> +{
>> +	struct xlog		*log = mp->m_log;
>> +	struct xfs_trans_res	tres;
>> +	int			unit_bytes;
>> +	int			min_lblks, lsu = 0;
>> +
>> +	xfs_max_trans_res_by_mount(mp, &tres);
> 
> Ok, that's been copied from mkfs, right?
Right.
> 
> What I'd suggest we need to do here is separate out all this
> reservation/validation code into it's own file so we can easily
> share it with libxfs in userspace.
I think so.
> 
>> +
>> +	/*
>> +	 * Figure out the total space needed for the maximum transaction
>> +	 * log space reservation by adding some extra spaces which should
>> +	 * be taken into account.
>> +	 */
>> +	unit_bytes = xlog_ticket_unit_res(log, &tres);
>> +	if (tres.tr_cnt > 1)
>> +		unit_bytes = unit_bytes * tres.tr_cnt;
> 
> Hmmmm - it's a bit different to userspace - there's no count in the
> userspace code. But yes, we do need to take into account the
> permanent log reservations...
> 
>> +
>> +	min_lblks = BTOBB(unit_bytes);
>> +	/*
>> +	 * FIXME: why we should add another 2 log strip units if it
>> +	 * is specified?  As per my tryout, creat a dozens dirs/files
>> +	 * on a partition without another 2 log strip units will
>> +	 * cause DEAD LOOP, it's fine if taken this into account.
>> +	 *
>> +	 * As per Dave's comments:
>> +	 * I'm thinking a minimum of 4*lsu - 2*lsu for the existing
>> +	 * CIL context, and another 2*lsu for any queued ticket
>> +	 * waiting for space to come available.
>> +	 */
>> +	if (xfs_sb_version_haslogv2(&log->l_mp->m_sb) &&
>> +	    log->l_mp->m_sb.sb_logsunit > 1)
>> +		lsu = BTOBB(log->l_mp->m_sb.sb_logsunit);
>> +
>> +	/*
>> +	 * The fundamental limit is that no single transaction can be
>> +	 * larger than half the size of the log space, take another
>> +	 * two log strip unit account as well.
>> +	 */
>> +	if ((log->l_logBBsize >> 1) < (min_lblks + lsu)) {
> 
> A transaction requires 2 LSU for the reservation because there are
> two log writes that can require padding - the transaction data and
> the commit record are written separately and both can require
> padding to the LSU.
> 
> And as per my comments above, we can have an active CIL reservation
> (holding 2*LSU), but the CIL is not over a push threshold. If we
> don't have space for at one new transaction, which includes
> *another* 2*LSU in the reservation, that's when we have problems.
> So, the log size needs to be able to contain two maximally sized and
> padded transactions, which is (2 * (2 * LSU + maxtrres)). Hence if
> you are comparing this against half the log size (i.e. maximum
> transaction size), it needs to be (2 * (2 * LSU + maxtrres)) / 2.
> i.e. (minlblks + 2 * lsu)
Thanks for pointing me out, this question puzzled me for a long time.
> 
> 
>> +		xfs_warn(mp,
>> +	"log space of %d blocks too small, minimum request %d",
>> +			 log->l_logBBsize,
>> +			 roundup((int)min_lblks << 1, (int)lsu) +
>> +			 2 * lsu);
>> +
>> +		return XFS_ERROR(EINVAL);
> 
> But, we can't just reject the mount if this fails. This would mean
> that people would have to downgrade their kernel just to remedy the
> situation as there is no way to grow the log (short of black magic
> surgery with xfs_db).
> 
> So this should just remain a warning message, though I'd make it of
> "xfs_crit" level (i.e. critical) so people notice it as well as
> making the message a little more informative.
Yes, fair enough.
> 
>> @@ -3377,24 +3441,23 @@ xfs_log_ticket_get(
>>  }
>>   /*
>> - * Allocate and initialise a new log ticket.
>> + * Figure out how many bytes would be reserved totally per ticket.
>> + * Especially, take log strip unit into account if it is specified.
>> + *
>> + * FIXME: this is totally copied from xlog_ticket_alloc(), it's better
>> + * to introduce a new helper to calculate the extra space reservation
>> + * that can be shared with xlog_ticket_alloc() if the current though
>> + * is reasonable.
> 
> That FIXME looks like you've already fixed it ;)
... forgot removing it. :(
> 
>>   */
>> -struct xlog_ticket *
>> -xlog_ticket_alloc(
>> -	struct xlog	*log,
>> -	int		unit_bytes,
>> -	int		cnt,
>> -	char		client,
>> -	bool		permanent,
>> -	xfs_km_flags_t	alloc_flags)
>> +int
>> +xlog_ticket_unit_res(
>> +	struct xlog		*log,
>> +	struct xfs_trans_res	*tres)
>>  {
>> -	struct xlog_ticket *tic;
>> -	uint		num_headers;
>> -	int		iclog_space;
>> -
>> -	tic = kmem_zone_zalloc(xfs_log_ticket_zone, alloc_flags);
>> -	if (!tic)
>> -		return NULL;
>> +	uint			unit_bytes = tres->tr_res;
>> +	int			total_bytes = unit_bytes;
>> +	int			iclog_space;
>> +	uint			num_headers;
>>   	/*
>>  	 * Permanent reservations have up to 'cnt'-1 active log operations
>> @@ -3459,8 +3522,8 @@ xlog_ticket_alloc(
>>   	/* add extra header reservations if we overrun */
>>  	while (!num_headers ||
>> -	       howmany(unit_bytes, iclog_space) > num_headers) {
>> -		unit_bytes += sizeof(xlog_op_header_t);
>> +	       howmany(total_bytes, iclog_space) > num_headers) {
>> +		total_bytes += sizeof(xlog_op_header_t);
>>  		num_headers++;
>>  	}
>>  	unit_bytes += log->l_iclog_hsize * num_headers;
> 
> What is the reason for using total_bytes here? We've got to take
> into account the size of the xlog_op_header_t headers in the ticket
> reservation, so adding them to unit_bytes is correct AFAICT....
You are right, this is a typo when I refine this procedure out of xfs_ticket_alloc().
> 
>> @@ -3478,11 +3541,38 @@ xlog_ticket_alloc(
>>  		unit_bytes += 2*BBSIZE;
>>          }
>>  +	return unit_bytes;
>> +}
> 
> This patch hunk is broken.
This will be fixed.
> 
>> +
>> +/*
>> + * Allocate and initialise a new log ticket.
>> + */
>> +struct xlog_ticket *
>> +xlog_ticket_alloc(
>> +	struct xlog	*log,
>> +	int		unit_bytes,
>> +	int		cnt,
>> +	char		client,
>> +	bool		permanent,
>> +	xfs_km_flags_t	alloc_flags)
>> +{
>> +	struct xlog_ticket *tic;
>> +	struct xfs_trans_res tres;
>> +	int		unit_res;
>> +
>> +	tic = kmem_zone_zalloc(xfs_log_ticket_zone, alloc_flags);
>> +	if (!tic)
>> +		return NULL;
>> +
>> +	tres.tr_res = unit_bytes;
>> +	tres.tr_cnt = cnt;
>> +	unit_res = xlog_ticket_unit_res(log, &tres);
> 
> Ok, I'm starting to see where this tres stuff is going. More on that
> later....
> 
>> +
>>  	atomic_set(&tic->t_ref, 1);
>>  	tic->t_task		= current;
>>  	INIT_LIST_HEAD(&tic->t_queue);
>> -	tic->t_unit_res		= unit_bytes;
>> -	tic->t_curr_res		= unit_bytes;
>> +	tic->t_unit_res		= unit_res;
>> +	tic->t_curr_res		= unit_res;
>>  	tic->t_cnt		= cnt;
>>  	tic->t_ocnt		= cnt;
>>  	tic->t_tid		= random32();
>> diff --git a/fs/xfs/xfs_log.h b/fs/xfs/xfs_log.h
>> index 5caee96..d3f7187 100644
>> --- a/fs/xfs/xfs_log.h
>> +++ b/fs/xfs/xfs_log.h
>> @@ -119,11 +119,13 @@ typedef struct xfs_log_callback {
>>  #ifdef __KERNEL__
>>  /* Log manager interfaces */
>>  struct xfs_mount;
>> +struct xlog;
>>  struct xlog_in_core;
>>  struct xlog_ticket;
>>  struct xfs_log_item;
>>  struct xfs_item_ops;
>>  struct xfs_trans;
>> +struct xfs_trans_res;
>>   void	xfs_log_item_init(struct xfs_mount	*mp,
>>  			struct xfs_log_item	*item,
>> @@ -184,6 +186,7 @@ bool	xfs_log_item_in_current_chkpt(struct xfs_log_item *lip);
>>  void	xfs_log_work_queue(struct xfs_mount *mp);
>>  void	xfs_log_worker(struct work_struct *work);
>>  void	xfs_log_quiesce(struct xfs_mount *mp);
>> +int	xlog_ticket_unit_res(struct xlog *log, struct xfs_trans_res *tres);
> 
> We generally name the log external functions as "xfs_log_..." and
> pass a struct xfs_mount around with them. i.e.:
> 
> int xfs_log_ticket_unit_res(struct xfs_mount *mp, struct xfs_trans_res *tres);
> 
> As it is, I'm not sure what that means from the name of the
> function. It has nothing to do with log tickets, but it's
> calculating the unit reservation for the ticket.  Perhaps a better
> name is something like xfs_log_calc_unit_res()?
The suggested name is nice to me as we already have xfs_calc_buf_res(), therefore we
can follow up this naming convention for such kind of routines.
> 
>>   #endif
>>  #endif	/* __XFS_LOG_H__ */
>> diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
>> index 2836ef6..cb67f96 100644
>> --- a/fs/xfs/xfs_mount.c
>> +++ b/fs/xfs/xfs_mount.c
>> @@ -20,6 +20,7 @@
>>  #include "xfs_types.h"
>>  #include "xfs_bit.h"
>>  #include "xfs_log.h"
>> +#include "xfs_log_priv.h"
> 
> stray include?
Yes.
> 
>>  #include "xfs_inum.h"
>>  #include "xfs_trans.h"
>>  #include "xfs_trans_priv.h"
>> diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
>> index 8145412..3f9a73c 100644
>> --- a/fs/xfs/xfs_mount.h
>> +++ b/fs/xfs/xfs_mount.h
>> @@ -18,35 +18,40 @@
>>  #ifndef __XFS_MOUNT_H__
>>  #define	__XFS_MOUNT_H__
>>  +typedef struct xfs_trans_res {
>> +	uint	tr_res;
>> +	int	tr_cnt;
>> +} xfs_tr_t;
> 
> No new typedefs, please.
Ok.
> 
>> diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
>> index 2fd7c1f..f2b18a5 100644
>> --- a/fs/xfs/xfs_trans.c
>> +++ b/fs/xfs/xfs_trans.c
>> @@ -43,6 +43,7 @@
>>  #include "xfs_inode_item.h"
>>  #include "xfs_log_priv.h"
>>  #include "xfs_buf_item.h"
>> +#include "xfs_attr_leaf.h"
> 
> Another stray include?
No, this is required for xfs_attr_leaf_newentsize().
> 
>>  #include "xfs_trace.h"
>>   kmem_zone_t	*xfs_trans_zone;
>> @@ -645,34 +646,140 @@ xfs_trans_init(
>>  {
>>  	struct xfs_trans_reservations *resp = &mp->m_reservations;
>>  -	resp->tr_write = xfs_calc_write_reservation(mp);
>> -	resp->tr_itruncate = xfs_calc_itruncate_reservation(mp);
>> -	resp->tr_rename = xfs_calc_rename_reservation(mp);
>> -	resp->tr_link = xfs_calc_link_reservation(mp);
>> -	resp->tr_remove = xfs_calc_remove_reservation(mp);
>> -	resp->tr_symlink = xfs_calc_symlink_reservation(mp);
>> -	resp->tr_create = xfs_calc_create_reservation(mp);
>> -	resp->tr_mkdir = xfs_calc_mkdir_reservation(mp);
>> -	resp->tr_ifree = xfs_calc_ifree_reservation(mp);
>> -	resp->tr_ichange = xfs_calc_ichange_reservation(mp);
>> -	resp->tr_growdata = xfs_calc_growdata_reservation(mp);
>> -	resp->tr_swrite = xfs_calc_swrite_reservation(mp);
>> -	resp->tr_writeid = xfs_calc_writeid_reservation(mp);
>> -	resp->tr_addafork = xfs_calc_addafork_reservation(mp);
>> -	resp->tr_attrinval = xfs_calc_attrinval_reservation(mp);
>> -	resp->tr_attrsetm = xfs_calc_attrsetm_reservation(mp);
>> -	resp->tr_attrsetrt = xfs_calc_attrsetrt_reservation(mp);
>> -	resp->tr_attrrm = xfs_calc_attrrm_reservation(mp);
>> -	resp->tr_clearagi = xfs_calc_clear_agi_bucket_reservation(mp);
>> -	resp->tr_growrtalloc = xfs_calc_growrtalloc_reservation(mp);
>> -	resp->tr_growrtzero = xfs_calc_growrtzero_reservation(mp);
>> -	resp->tr_growrtfree = xfs_calc_growrtfree_reservation(mp);
>> -	resp->tr_qm_sbchange = xfs_calc_qm_sbchange_reservation(mp);
>> -	resp->tr_qm_setqlim = xfs_calc_qm_setqlim_reservation(mp);
>> -	resp->tr_qm_dqalloc = xfs_calc_qm_dqalloc_reservation(mp);
>> -	resp->tr_qm_quotaoff = xfs_calc_qm_quotaoff_reservation(mp);
>> -	resp->tr_qm_equotaoff = xfs_calc_qm_quotaoff_end_reservation(mp);
>> -	resp->tr_sb = xfs_calc_sb_reservation(mp);
>> +	resp->tr_write.tr_res = xfs_calc_write_reservation(mp);
>> +	resp->tr_write.tr_cnt = XFS_WRITE_LOG_COUNT;
>> +
>> +	resp->tr_itruncate.tr_res = xfs_calc_itruncate_reservation(mp);
>> +	resp->tr_itruncate.tr_cnt = XFS_ITRUNCATE_LOG_COUNT;
>> +
>> +	resp->tr_rename.tr_res = xfs_calc_rename_reservation(mp);
>> +	resp->tr_rename.tr_cnt = XFS_RENAME_LOG_COUNT;
> .....
> 
> I like the idea, but I don't think you've carried it through far
> enough. :)
> 
> i.e. This patch leaves us with having multiple places where this
> information has to be maintained (here and the xfs_trans_reserve()
> calls).  What I think is the best way to approach this is to
> separate out this table change into a separate patch (i.e. without
> all the other code that uses it), and then change the
> xfs_trans_reserve() interface to take a struct xfs_trans_res *.
Exactly.
> 
> At that point, we can then do:
> 
> 	xfs_trans_reserve(tp, &mp->m_reservations.tr_rename,
> 			  blockres, rtblockres, flags);
> 
> and now we can propagate the logspace/logcount through
> xfs_log_reserve(), xlog_ticket_alloc() and so on via the reservation
> structure.
> 
> That leaves us with a single place that we set up and maintain log
> space reservations, makes the transaction reservation calls cleaner
> (no more messy macros everywhere), and if we rename
> mp->m_reservations to mp->m_resv there's a whole lot less typing,
> too.
> 
> We could potentially also add the XFS_TRANS_PERM_LOG_RES flag to
> the struct xfs_trans_res, so most xfs_trans_reserve() calls don't
> need to pass a flag in at all (even cleaner!).
Well, that'll be very nice! By this means we can make the transaction log res
info well encapsulated and reduce the stack push by two arguments on each call.
> 
>> +STATIC void
>> +xfs_max_attrsetm_trans_res_adjust(
>> +	struct xfs_mount	*mp)
>> +{
>> +	int			local;
>> +	int			size;
>> +	int			nblks;
>> +	int			res;
>> +
>> +	/*
>> +	 * Determine space the maximal sized attribute will use,
>> +	 * to calculate the largest reservatoin size needed.
>> +	 */
>> +	size = xfs_attr_leaf_newentsize(MAXNAMELEN, 64 * 1024,
>> +					mp->m_sb.sb_blocksize, &local);
>> +	ASSERT(!local);
>> +	nblks = XFS_DAENTER_SPACE_RES(mp, XFS_ATTR_FORK);
>> +	nblks += XFS_B_TO_FSB(mp, size);
>> +	nblks += XFS_NEXTENTADD_SPACE_RES(mp, size, XFS_ATTR_FORK);
>> +	res = XFS_ATTRSETM_LOG_RES(mp) + XFS_ATTRSETRT_LOG_RES(mp) * nblks;
>> +	mp->m_reservations.tr_attrsetm.tr_res = res;
> 
> That's copied from mkfs, right? I need to look a bit closer, but I
> don't think this is correct - large attributes end up out of line
> and not logged, while this assumes that the full 64k of the
> remote attribute is logged. Over estimating is fine, though, for the
> moment.
Right.  So for me, the next step is to verify whether the default attr transaction
would affect the minimum log space calculation or not.
> 
>> +}
>> +
>> +/*
>> + * Figure out the total log space a transaction would required in terms
>> + * of the pre-calculated values which are done at mount time, then find
>> + * out and return the maximum reservation among them.
>> + */
>> +void
>> +xfs_max_trans_res_by_mount(
>> +	struct xfs_mount		*mp,
>> +	struct xfs_trans_res		*mres)
>> +{
>> +	struct xfs_trans_reservations	*resp = &mp->m_reservations;
>> +	struct xfs_trans_res		*p, *tres = NULL;
>> +	int				res;
>> +
>> +	for (res = 0, p = (struct xfs_trans_res *)resp;
>> +	     p < (struct xfs_trans_res *)(resp + 1); p++) {
> 
> I don't really like the pointer arithmetic here. Something like
> 
> 	res = 0;
> 	for (i = 0; i < ARRAY_SIZE(mp->m_reservations); i++) {
> 		p = &mp->m_reservations[i];
> 
> is a much neater way of iterating an array....
This is basically copied from mkfs/maxtrres.c, but yes, the above is the
best approach.
> 
> 
>> +		int	tmp = p->tr_cnt > 1 ? p->tr_res * p->tr_cnt :
>> +					      p->tr_res;
>> +		if (res < tmp) {
>> +			res = tmp;
>> +			tres = p;
>> +		}
>> +	}
>> +
>> +	ASSERT(tres != NULL);
>> +	*mres = *tres;
>>  }
> 
> All these changes look to me like something we shoul dbe sharing
> with libxfs in userspace so that mkfs can re-use the code without
> modifications....
So maybe it's better to fix the method of iterating array in user space as well.
> 
>>   /*
>> diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
>> index cd29f61..b304bb8 100644
>> --- a/fs/xfs/xfs_trans.h
>> +++ b/fs/xfs/xfs_trans.h
>> @@ -19,6 +19,7 @@
>>  #define	__XFS_TRANS_H__
>>   struct xfs_log_item;
>> +struct xfs_trans_res;
>>   /*
>>   * This is the structure written in the log at the head of
>> @@ -232,39 +233,39 @@ struct xfs_log_item_desc {
>>  	 XFS_DAENTER_BMAPS(mp, XFS_DATA_FORK) + 1)
>>   -#define	XFS_WRITE_LOG_RES(mp)	((mp)->m_reservations.tr_write)
>> -#define	XFS_ITRUNCATE_LOG_RES(mp)   ((mp)->m_reservations.tr_itruncate)
>> -#define	XFS_RENAME_LOG_RES(mp)	((mp)->m_reservations.tr_rename)
>> -#define	XFS_LINK_LOG_RES(mp)	((mp)->m_reservations.tr_link)
>> -#define	XFS_REMOVE_LOG_RES(mp)	((mp)->m_reservations.tr_remove)
>> -#define	XFS_SYMLINK_LOG_RES(mp)	((mp)->m_reservations.tr_symlink)
>> -#define	XFS_CREATE_LOG_RES(mp)	((mp)->m_reservations.tr_create)
>> -#define	XFS_MKDIR_LOG_RES(mp)	((mp)->m_reservations.tr_mkdir)
>> -#define	XFS_IFREE_LOG_RES(mp)	((mp)->m_reservations.tr_ifree)
>> -#define	XFS_ICHANGE_LOG_RES(mp)	((mp)->m_reservations.tr_ichange)
>> -#define	XFS_GROWDATA_LOG_RES(mp)    ((mp)->m_reservations.tr_growdata)
>> -#define	XFS_GROWRTALLOC_LOG_RES(mp)	((mp)->m_reservations.tr_growrtalloc)
>> -#define	XFS_GROWRTZERO_LOG_RES(mp)	((mp)->m_reservations.tr_growrtzero)
>> -#define	XFS_GROWRTFREE_LOG_RES(mp)	((mp)->m_reservations.tr_growrtfree)
>> -#define	XFS_SWRITE_LOG_RES(mp)	((mp)->m_reservations.tr_swrite)
>> +#define	XFS_WRITE_LOG_RES(mp)	((mp)->m_reservations.tr_write.tr_res)
>> +#define	XFS_ITRUNCATE_LOG_RES(mp)   ((mp)->m_reservations.tr_itruncate.tr_res)
>> +#define	XFS_RENAME_LOG_RES(mp)	((mp)->m_reservations.tr_rename.tr_res)
>> +#define	XFS_LINK_LOG_RES(mp)	((mp)->m_reservations.tr_link.tr_res)
>> +#define	XFS_REMOVE_LOG_RES(mp)	((mp)->m_reservations.tr_remove.tr_res)
>> +#define	XFS_SYMLINK_LOG_RES(mp)	((mp)->m_reservations.tr_symlink.tr_res)
>> +#define	XFS_CREATE_LOG_RES(mp)	((mp)->m_reservations.tr_create.tr_res)
>> +#define	XFS_MKDIR_LOG_RES(mp)	((mp)->m_reservations.tr_mkdir.tr_res)
>> +#define	XFS_IFREE_LOG_RES(mp)	((mp)->m_reservations.tr_ifree.tr_res)
>> +#define	XFS_ICHANGE_LOG_RES(mp)	((mp)->m_reservations.tr_ichange.tr_res)
>> +#define	XFS_GROWDATA_LOG_RES(mp)    ((mp)->m_reservations.tr_growdata.tr_res)
>> +#define	XFS_GROWRTALLOC_LOG_RES(mp)	((mp)->m_reservations.tr_growrtalloc.tr_res)
>> +#define	XFS_GROWRTZERO_LOG_RES(mp)	((mp)->m_reservations.tr_growrtzero.tr_res)
>> +#define	XFS_GROWRTFREE_LOG_RES(mp)	((mp)->m_reservations.tr_growrtfree.tr_res)
>> +#define	XFS_SWRITE_LOG_RES(mp)	((mp)->m_reservations.tr_swrite.tr_res)
> 
> If we do the "pass xfs_trans_res to xfs_trans_reserve(), all these
> macros could go away....
Absoultely. :)

Thanks,
-Jeff

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
