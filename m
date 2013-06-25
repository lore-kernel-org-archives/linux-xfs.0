Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 67B227F37
	for <xfs@oss.sgi.com>; Tue, 25 Jun 2013 16:07:43 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 57ACC8F8037
	for <xfs@oss.sgi.com>; Tue, 25 Jun 2013 14:07:40 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id e1DrrH20Pmm6cDW0 for
	<xfs@oss.sgi.com>; Tue, 25 Jun 2013 14:07:36 -0700 (PDT)
Message-ID: <51CA05DE.1050201@redhat.com>
Date: Tue, 25 Jun 2013 17:04:30 -0400
From: Brian Foster <bfoster@redhat.com>
MIME-Version: 1.0
Subject: Re: [PATCH v2 RFC] userns: Convert xfs to use kuid/kgid where
	appropriate
References: <20130619110948.0bfafa2b@oracle.com>
	<20130620001341.GM29338@dastard>
	<20130620095410.1917d235@oracle.com>
	<20130620220311.GT29376@dastard>
	<20130621111420.5592707e@oracle.com>
	<20130624003316.GH29376@dastard>
	<20130624091035.6274800f@oracle.com> <51C9C95B.30909@redhat.com>
	<20130625160823.41e29fc8@oracle.com>
In-Reply-To: <20130625160823.41e29fc8@oracle.com>
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
To: Dwight Engen <dwight.engen@oracle.com>
Cc: "Eric W. Biederman" <ebiederm@gmail.com>, Serge Hallyn <serge.hallyn@ubuntu.com>, xfs@oss.sgi.com

On 06/25/2013 04:08 PM, Dwight Engen wrote:
> On Tue, 25 Jun 2013 12:46:19 -0400
> Brian Foster <bfoster@redhat.com> wrote:
> 
>> On 06/24/2013 09:10 AM, Dwight Engen wrote:
...
>>> diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
>>> index 96e344e..2c35b13 100644
>>> --- a/fs/xfs/xfs_icache.c
>>> +++ b/fs/xfs/xfs_icache.c
>>> @@ -617,7 +617,7 @@ restart:
>>>  
>>>  /*
>>>   * Background scanning to trim post-EOF preallocated space. This
>>> is queued
>>> - * based on the 'background_prealloc_discard_period' tunable (5m
>>> by default).
>>> + * based on the 'speculative_prealloc_lifetime' tunable (5m by
>>> default). */
>>>  STATIC void
>>>  xfs_queue_eofblocks(
>>> @@ -1202,11 +1202,11 @@ xfs_inode_match_id(
>>>  	struct xfs_eofblocks	*eofb)
>>>  {
>>>  	if (eofb->eof_flags & XFS_EOF_FLAGS_UID &&
>>> -	    ip->i_d.di_uid != eofb->eof_uid)
>>> +	    !uid_eq(VFS_I(ip)->i_uid, eofb->eof_uid))
>>>  		return 0;
>>>  
>>>  	if (eofb->eof_flags & XFS_EOF_FLAGS_GID &&
>>> -	    ip->i_d.di_gid != eofb->eof_gid)
>>> +	    !gid_eq(VFS_I(ip)->i_gid, eofb->eof_gid))
>>
>> More of a question... since we're originally comparing against the
>> on-disk values, is the separate internal structure strictly necessary
>> for making eofblocks userns aware?
> 
> Not sure I fully understand your question, we were comparing on-disk
> uid/gid values to unconverted eof values because xfs didn't support the
> eof ioctl callers passing in ids from a userns. I believe part
> of the idea of userns is that i_uid is an opaque type, hence the use of
> _eq() comparators and why we have to convert eof_[ug]id if we want to
> compare them to i_uid as opposed to di_uid.
> 

That latter point was my question, why does this code want/need to
compare to the i_uid as opposed to di_uid. It seems like technically you
could push the conversion up and not have to change much else.

It's not terribly important since this code is moving into the separate
xfs_eofblocks structure anyway. I'm not against it I guess, I just
wanted to be on the same page as to the intent of the change. I suppose
it makes sense if the idea is that core kernel code should be carrying
around kuid types in general.

...
>> This should probably go into xfs_icache.h along with the
>> aforementioned conversion helper.
>>
>> As I mentioned previously, I have some code around that creates an
>> internal version of the eofblocks structure. The main differences are
>> the name (xfs_eofblocks_internal) and I did the conversion down in
>> xfs_icache.c since I wasn't changing anything that affected the
>> ioctl().
>>
>> I can throw it up on the list for reference or if it's of any use as a
>> base for this work...
> 
> If you have time to put it up that'd be great, but no biggie if not I'll
> write a conversion routine. Thanks for looking at this.
> 

I'll forward it along momentarily...

Brian

>> Brian
>>
>>>  /*
>>>   * Various platform dependent calls that don't fit anywhere else
>>>   */
>>> diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
>>> index b75c9bb..57e2c18 100644
>>> --- a/fs/xfs/xfs_qm.c
>>> +++ b/fs/xfs/xfs_qm.c
>>> @@ -1651,8 +1651,8 @@ xfs_qm_write_sb_changes(
>>>  int
>>>  xfs_qm_vop_dqalloc(
>>>  	struct xfs_inode	*ip,
>>> -	uid_t			uid,
>>> -	gid_t			gid,
>>> +	xfs_dqid_t		uid,
>>> +	xfs_dqid_t		gid,
>>>  	prid_t			prid,
>>>  	uint			flags,
>>>  	struct xfs_dquot	**O_udqpp,
>>> @@ -1697,7 +1697,7 @@ xfs_qm_vop_dqalloc(
>>>  			 * holding ilock.
>>>  			 */
>>>  			xfs_iunlock(ip, lockflags);
>>> -			if ((error = xfs_qm_dqget(mp, NULL,
>>> (xfs_dqid_t) uid,
>>> +			if ((error = xfs_qm_dqget(mp, NULL, uid,
>>>  						 XFS_DQ_USER,
>>>  						 XFS_QMOPT_DQALLOC
>>> | XFS_QMOPT_DOWARN,
>>> @@ -1723,7 +1723,7 @@ xfs_qm_vop_dqalloc(
>>>  	if ((flags & XFS_QMOPT_GQUOTA) && XFS_IS_GQUOTA_ON(mp)) {
>>>  		if (ip->i_d.di_gid != gid) {
>>>  			xfs_iunlock(ip, lockflags);
>>> -			if ((error = xfs_qm_dqget(mp, NULL,
>>> (xfs_dqid_t)gid,
>>> +			if ((error = xfs_qm_dqget(mp, NULL, gid,
>>>  						 XFS_DQ_GROUP,
>>>  						 XFS_QMOPT_DQALLOC
>>> | XFS_QMOPT_DOWARN,
>>> @@ -1842,7 +1842,7 @@ xfs_qm_vop_chown_reserve(
>>>  			XFS_QMOPT_RES_RTBLKS :
>>> XFS_QMOPT_RES_REGBLKS; 
>>>  	if (XFS_IS_UQUOTA_ON(mp) && udqp &&
>>> -	    ip->i_d.di_uid !=
>>> (uid_t)be32_to_cpu(udqp->q_core.d_id)) {
>>> +	    ip->i_d.di_uid != be32_to_cpu(udqp->q_core.d_id)) {
>>>  		delblksudq = udqp;
>>>  		/*
>>>  		 * If there are delayed allocation blocks, then we
>>> have to diff --git a/fs/xfs/xfs_quota.h b/fs/xfs/xfs_quota.h
>>> index c38068f..5f0bfe8 100644
>>> --- a/fs/xfs/xfs_quota.h
>>> +++ b/fs/xfs/xfs_quota.h
>>> @@ -320,8 +320,8 @@ extern int
>>> xfs_trans_reserve_quota_bydquots(struct xfs_trans *, struct
>>> xfs_mount *, struct xfs_dquot *, struct xfs_dquot *, long, long,
>>> uint); 
>>> -extern int xfs_qm_vop_dqalloc(struct xfs_inode *, uid_t, gid_t,
>>> prid_t, uint,
>>> -		struct xfs_dquot **, struct xfs_dquot **);
>>> +extern int xfs_qm_vop_dqalloc(struct xfs_inode *, xfs_dqid_t,
>>> xfs_dqid_t,
>>> +		prid_t, uint, struct xfs_dquot **, struct
>>> xfs_dquot **); extern void xfs_qm_vop_create_dqattach(struct
>>> xfs_trans *, struct xfs_inode *, struct xfs_dquot *, struct
>>> xfs_dquot *); extern int xfs_qm_vop_rename_dqattach(struct
>>> xfs_inode **); @@ -341,8 +341,9 @@ extern void
>>> xfs_qm_unmount_quotas(struct xfs_mount *); 
>>>  #else
>>>  static inline int
>>> -xfs_qm_vop_dqalloc(struct xfs_inode *ip, uid_t uid, gid_t gid,
>>> prid_t prid,
>>> -		uint flags, struct xfs_dquot **udqp, struct
>>> xfs_dquot **gdqp) +xfs_qm_vop_dqalloc(struct xfs_inode *ip,
>>> xfs_dqid_t uid, xfs_dqid_t gid,
>>> +		prid_t prid, uint flags, struct xfs_dquot **udqp,
>>> +		struct xfs_dquot **gdqp)
>>>  {
>>>  	*udqp = NULL;
>>>  	*gdqp = NULL;
>>> diff --git a/fs/xfs/xfs_symlink.c b/fs/xfs/xfs_symlink.c
>>> index 195a403..c50306e 100644
>>> --- a/fs/xfs/xfs_symlink.c
>>> +++ b/fs/xfs/xfs_symlink.c
>>> @@ -384,7 +384,9 @@ xfs_symlink(
>>>  	/*
>>>  	 * Make sure that we have allocated dquot(s) on disk.
>>>  	 */
>>> -	error = xfs_qm_vop_dqalloc(dp, current_fsuid(),
>>> current_fsgid(), prid,
>>> +	error = xfs_qm_vop_dqalloc(dp,
>>> +			xfs_kuid_to_disk(current_fsuid()),
>>> +			xfs_kgid_to_disk(current_fsgid()), prid,
>>>  			XFS_QMOPT_QUOTALL | XFS_QMOPT_INHERIT,
>>> &udqp, &gdqp); if (error)
>>>  		goto std_return;
>>> diff --git a/fs/xfs/xfs_vnodeops.c b/fs/xfs/xfs_vnodeops.c
>>> index 0176bb2..94f4f9f6 100644
>>> --- a/fs/xfs/xfs_vnodeops.c
>>> +++ b/fs/xfs/xfs_vnodeops.c
>>> @@ -515,7 +515,9 @@ xfs_create(
>>>  	/*
>>>  	 * Make sure that we have allocated dquot(s) on disk.
>>>  	 */
>>> -	error = xfs_qm_vop_dqalloc(dp, current_fsuid(),
>>> current_fsgid(), prid,
>>> +	error = xfs_qm_vop_dqalloc(dp,
>>> +			xfs_kuid_to_disk(current_fsuid()),
>>> +			xfs_kgid_to_disk(current_fsgid()), prid,
>>>  			XFS_QMOPT_QUOTALL | XFS_QMOPT_INHERIT,
>>> &udqp, &gdqp); if (error)
>>>  		return error;
>>> diff --git a/init/Kconfig b/init/Kconfig
>>> index 9d3a788..8083ffd 100644
>>> --- a/init/Kconfig
>>> +++ b/init/Kconfig
>>> @@ -1065,7 +1065,6 @@ config IPC_NS
>>>  
>>>  config USER_NS
>>>  	bool "User namespace"
>>> -	depends on UIDGID_CONVERTED
>>>  	select UIDGID_STRICT_TYPE_CHECKS
>>>  
>>>  	default n
>>> @@ -1099,21 +1098,9 @@ config NET_NS
>>>  
>>>  endif # NAMESPACES
>>>  
>>> -config UIDGID_CONVERTED
>>> -	# True if all of the selected software conmponents are
>>> known
>>> -	# to have uid_t and gid_t converted to kuid_t and kgid_t
>>> -	# where appropriate and are otherwise safe to use with
>>> -	# the user namespace.
>>> -	bool
>>> -	default y
>>> -
>>> -	# Filesystems
>>> -	depends on XFS_FS = n
>>> -
>>>  config UIDGID_STRICT_TYPE_CHECKS
>>>  	bool "Require conversions between uid/gids and their
>>> internal representation"
>>> -	depends on UIDGID_CONVERTED
>>> -	default n
>>> +	default y
>>>  	help
>>>  	 While the nececessary conversions are being added to all
>>> subsystems this option allows the code to continue to build for
>>> unconverted subsystems.
>>>
>>
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
