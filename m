Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 06F877F37
	for <xfs@oss.sgi.com>; Mon, 20 Jan 2014 07:54:15 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id CC5738F806F
	for <xfs@oss.sgi.com>; Mon, 20 Jan 2014 05:54:11 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id aKsNcJ2BEt0SAIzv for
	<xfs@oss.sgi.com>; Mon, 20 Jan 2014 05:54:10 -0800 (PST)
Message-ID: <52DD2A7F.801@redhat.com>
Date: Mon, 20 Jan 2014 08:54:07 -0500
From: Brian Foster <bfoster@redhat.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfs: use tr_qm_dqalloc log reservation for dquot alloc
References: <1389981723-54311-1-git-send-email-bfoster@redhat.com>
	<52DA8D09.4000408@oracle.com>
In-Reply-To: <52DA8D09.4000408@oracle.com>
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
To: Jeff Liu <jeff.liu@oracle.com>, xfs@oss.sgi.com

On 01/18/2014 09:17 AM, Jeff Liu wrote:
> On 01/18 2014 02:02 AM, Brian Foster wrote:
>> The dquot allocation path in xfs_qm_dqread() currently uses the
>> attribute set log reservation, which appears to be incorrect. We
>> have reports of transaction reservation overruns with the current
>> code. E.g., a repeated run of xfstests test generic/270 on a 512b
>> block size fs occassionally produces the following in dmesg:
>>
>> 	XFS (sdN): xlog_write: reservation summary:
>> 	  trans type  = QM_DQALLOC (30)
>> 	  unit res    = 7080 bytes
>> 	  current res = -632 bytes
>> 	  total reg   = 0 bytes (o/flow = 0 bytes)
>> 	  ophdrs      = 0 (ophdr space = 0 bytes)
>> 	  ophdr + reg = 0 bytes
>> 	  num regions = 0
>>
>> 	XFS (sdN): xlog_write: reservation ran out. Need to up reservation
>>
>> The dquot allocation case should consist of a write reservation
>> (i.e., we are allocating a range of the internal quota file) plus
>> the size of the actual dquots. We already have a log reservation
>> definition for this operation (tr_qm_dqalloc). Use it in
>> xfs_qm_dqread() and update the log reservation calculation function
>> to use the write res. calculation function rather than reading the
>> assumed to be pre-calculated value directly.
>>
>> Signed-off-by: Brian Foster <bfoster@redhat.com>
>> ---
>> Hi all,
>>
>> This issue was reported here:
>>
>> https://bugzilla.redhat.com/show_bug.cgi?id=1052787
>>
>> ... and the patch seems to address the reservation overrun from my testing.
>> It also runs through an xfstests regression. Thanks.
>>
>> Brian
>>
>>  fs/xfs/xfs_dquot.c      | 2 +-
>>  fs/xfs/xfs_trans_resv.c | 3 +--
>>  2 files changed, 2 insertions(+), 3 deletions(-)
>>
>> diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
>> index 6b1e695..06280c6 100644
>> --- a/fs/xfs/xfs_dquot.c
>> +++ b/fs/xfs/xfs_dquot.c
>> @@ -614,7 +614,7 @@ xfs_qm_dqread(
>>  
>>  	if (flags & XFS_QMOPT_DQALLOC) {
>>  		tp = xfs_trans_alloc(mp, XFS_TRANS_QM_DQALLOC);
>> -		error = xfs_trans_reserve(tp, &M_RES(mp)->tr_attrsetm,
>> +		error = xfs_trans_reserve(tp, &M_RES(mp)->tr_qm_dqalloc,
>>  					  XFS_QM_DQALLOC_SPACE_RES(mp), 0);
> 
> Ah, another issue I introduced for refactoring xfs_trans_reserve() interface.
>>  		if (error)
>>  			goto error1;
>> diff --git a/fs/xfs/xfs_trans_resv.c b/fs/xfs/xfs_trans_resv.c
>> index 2fd59c0..60b7d40 100644
>> --- a/fs/xfs/xfs_trans_resv.c
>> +++ b/fs/xfs/xfs_trans_resv.c
>> @@ -651,8 +651,7 @@ STATIC uint
>>  xfs_calc_qm_dqalloc_reservation(
>>  	struct xfs_mount	*mp)
>>  {
>> -	ASSERT(M_RES(mp)->tr_write.tr_logres);
>> -	return M_RES(mp)->tr_write.tr_logres +
>> +	return xfs_calc_write_reservation(mp) +
>>  		xfs_calc_buf_res(1,
>>  			XFS_FSB_TO_B(mp, XFS_DQUOT_CLUSTER_SIZE_FSB) - 1);
>>  }
> 
> I'm fine to call xfs_calc_write_reservation() rather than the current hard-code,
> especially we can get rid of the ASSERT() though tr_write.tr_logres should not
> be zero as it is initialized in advance at xfs_trans_resv_calc().
> 

Right... I just decided to call the write calc size function because
that seems to be the standard operating procedure with the new code and
it eliminates the fact that this is subject to initialization order,
even if not a bug at the moment. :)

> Just a little nit pick :), that would be better to consolidate the comments in
> this fix as well, i.e, 
> *	the write transaction log space: M_RES(mp)->tr_write.tr_logres.
> 

Ok, I'll send a new patch that cleans up the comment. Thanks for review.

Brian

> 
> Thanks,
> -Jeff
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
