Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q7R8wrcv026083 for <xfs@oss.sgi.com>; Mon, 27 Aug 2012 03:58:53 -0500
Subject: Re: [REVIEW][PATCH 13/15] userns: Add basic quota support
From: Steven Whitehouse <swhiteho@redhat.com>
In-Reply-To: <87harqecvk.fsf@xmission.com>
References: <87lih2h6i4.fsf@xmission.com>  <87harqecvk.fsf@xmission.com>
Date: Mon, 27 Aug 2012 09:58:06 +0100
Message-ID: <1346057886.2703.5.camel@menhir>
Mime-Version: 1.0
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
To: "Eric W. Biederman" <ebiederm@xmission.com>, Abhijith Das <adas@redhat.com>
Cc: Alex Elder <elder@kernel.org>, Jan Kara <jack@suse.cz>, netdev@vger.kernel.org, linux-kernel@vger.kernel.org, David@oss.sgi.com, cluster-devel@redhat.com, Ben Myers <bpm@sgi.com>, Monakhov <dmonakhov@openvz.org>, Joel Becker <jlbec@evilplan.org>, Dmitry@oss.sgi.com, Mark Fasheh <mfasheh@suse.com>, linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com, Miller <davem@davemloft.net>, ocfs2-devel@oss.oracle.com, "Serge E. Hallyn" <serge@hallyn.com>

Hi,

On Sat, 2012-08-25 at 17:05 -0700, Eric W. Biederman wrote:
> Two helper are added dqgetusr and dqgetgrp to allow the quota
> infrastructure to be called with a kuid and a kgid respectively.  This
> creates type safe variants of dqget and leads to shorter more
> comprehensible code.
> 
> Place the USRQUOTA and GRPQUOTA defines into enum quota_type.  This
> brings with it the ability for the compiler to check that switch
> statements handle every quota type, and the ability to mark which
> values store the type of a quota entry.
> 
> Add the data type qown_t a union of kuid_t and kgid_t. qown_t is a
> replacement for the implicit union of uid and gid stored in an
> unsigned int that is was used in the quota data structures.  Making
> the data type explicit allows the kuid_t and kgid_t type safety to
> propogate more thoroughly through the code, revealing more places
> where uid/gid conversions need be made.
> 
> Allong with the data type qown_t comes the helper functions
> qown_eq, from_qown, from_qown_munged, qown_valid, and make_qown.
> 
> Update struct dquot dq_id to be a qown_t.
> 
> Update the signature of dqget, quota_send_warning, dquot_get_dqblk,
> and dquot_set_dqblk to use enum quota_type and qown_t.
> 
> Make minimal changes to gfs2, ocfs2, and xfs to deal with the change
> in quota structures and signatures.  The ocfs2 changes are larger than
> most because of the extensive tracing throughout the ocfs2 quota code
> that prints out dq_id.
> 

I think this is ok from the GFS2 perspective. Abhi, does it look ok to
you?

Steve.




> Cc: Steven Whitehouse <swhiteho@redhat.com>
> Cc: cluster-devel@redhat.com
> Cc: Mark Fasheh <mfasheh@suse.com>
> Cc: Joel Becker <jlbec@evilplan.org>
> Cc: ocfs2-devel@oss.oracle.com
> Cc: Ben Myers <bpm@sgi.com>
> Cc: Alex Elder <elder@kernel.org>
> Cc: xfs@oss.sgi.com
> Cc: Jan Kara <jack@suse.cz>
> Cc: Dmitry Monakhov <dmonakhov@openvz.org>
> Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
> ---
>  fs/gfs2/quota.c          |   44 ++++++++++++++---------
>  fs/ocfs2/file.c          |    6 +--
>  fs/ocfs2/quota_global.c  |   34 +++++++++++++-----
>  fs/ocfs2/quota_local.c   |   12 +++++--
>  fs/quota/dquot.c         |   43 ++++++++++++----------
>  fs/quota/netlink.c       |   11 ++++--
>  fs/quota/quota.c         |   44 +++++++++++++++-------
>  fs/quota/quota_tree.c    |   20 +++++++---
>  fs/quota/quota_v1.c      |    8 +++--
>  fs/quota/quota_v2.c      |   14 +++++--
>  fs/xfs/xfs_quotaops.c    |   18 ++++++----
>  fs/xfs/xfs_trans_dquot.c |    8 +++--
>  include/linux/quota.h    |   91 +++++++++++++++++++++++++++++++++++++++++++---
>  include/linux/quotaops.h |   18 +++++++--
>  init/Kconfig             |    2 -
>  15 files changed, 270 insertions(+), 103 deletions(-)
> 
> diff --git a/fs/gfs2/quota.c b/fs/gfs2/quota.c
> index a3bde91..858f052 100644
> --- a/fs/gfs2/quota.c
> +++ b/fs/gfs2/quota.c
> @@ -1057,6 +1057,8 @@ int gfs2_quota_check(struct gfs2_inode *ip, u32 uid, u32 gid)
>                  return 0;
>  
>  	for (x = 0; x < ip->i_res->rs_qa_qd_num; x++) {
> +		enum quota_type qtype;
> +		qown_t qown;
>  		qd = ip->i_res->rs_qa_qd[x];
>  
>  		if (!((qd->qd_id == uid && test_bit(QDF_USER, &qd->qd_flags)) ||
> @@ -1068,10 +1070,11 @@ int gfs2_quota_check(struct gfs2_inode *ip, u32 uid, u32 gid)
>  		value += qd->qd_change;
>  		spin_unlock(&qd_lru_lock);
>  
> +		qtype = test_bit(QDF_USER, &qd->qd_flags) ? USRQUOTA : GRPQUOTA;
> +		qown = make_qown(&init_user_ns, qtype, qd->qd_id);
>  		if (be64_to_cpu(qd->qd_qb.qb_limit) && (s64)be64_to_cpu(qd->qd_qb.qb_limit) < value) {
>  			print_message(qd, "exceeded");
> -			quota_send_warning(test_bit(QDF_USER, &qd->qd_flags) ?
> -					   USRQUOTA : GRPQUOTA, qd->qd_id,
> +			quota_send_warning(qtype, qown,
>  					   sdp->sd_vfs->s_dev, QUOTA_NL_BHARDWARN);
>  
>  			error = -EDQUOT;
> @@ -1081,8 +1084,7 @@ int gfs2_quota_check(struct gfs2_inode *ip, u32 uid, u32 gid)
>  			   time_after_eq(jiffies, qd->qd_last_warn +
>  					 gfs2_tune_get(sdp,
>  						gt_quota_warn_period) * HZ)) {
> -			quota_send_warning(test_bit(QDF_USER, &qd->qd_flags) ?
> -					   USRQUOTA : GRPQUOTA, qd->qd_id,
> +			quota_send_warning(qtype, qown,
>  					   sdp->sd_vfs->s_dev, QUOTA_NL_BSOFTWARN);
>  			error = print_message(qd, "warning");
>  			qd->qd_last_warn = jiffies;
> @@ -1469,28 +1471,32 @@ static int gfs2_quota_get_xstate(struct super_block *sb,
>  	return 0;
>  }
>  
> -static int gfs2_get_dqblk(struct super_block *sb, int type, qid_t id,
> -			  struct fs_disk_quota *fdq)
> +static int gfs2_get_dqblk(struct super_block *sb, enum quota_type type,
> +			  qown_t id, struct fs_disk_quota *fdq)
>  {
>  	struct gfs2_sbd *sdp = sb->s_fs_info;
>  	struct gfs2_quota_lvb *qlvb;
>  	struct gfs2_quota_data *qd;
>  	struct gfs2_holder q_gh;
>  	int error;
> +	int user;
> +	u32 gfs_id;
>  
>  	memset(fdq, 0, sizeof(struct fs_disk_quota));
>  
>  	if (sdp->sd_args.ar_quota == GFS2_QUOTA_OFF)
>  		return -ESRCH; /* Crazy XFS error code */
>  
> +	gfs_id = from_qown(&init_user_ns, type, id);
> +
>  	if (type == USRQUOTA)
> -		type = QUOTA_USER;
> +		user = QUOTA_USER;
>  	else if (type == GRPQUOTA)
> -		type = QUOTA_GROUP;
> +		user = QUOTA_GROUP;
>  	else
>  		return -EINVAL;
>  
> -	error = qd_get(sdp, type, id, &qd);
> +	error = qd_get(sdp, user, gfs_id, &qd);
>  	if (error)
>  		return error;
>  	error = do_glock(qd, FORCE, &q_gh);
> @@ -1499,8 +1505,8 @@ static int gfs2_get_dqblk(struct super_block *sb, int type, qid_t id,
>  
>  	qlvb = (struct gfs2_quota_lvb *)qd->qd_gl->gl_lvb;
>  	fdq->d_version = FS_DQUOT_VERSION;
> -	fdq->d_flags = (type == QUOTA_USER) ? FS_USER_QUOTA : FS_GROUP_QUOTA;
> -	fdq->d_id = id;
> +	fdq->d_flags = (user == QUOTA_USER) ? FS_USER_QUOTA : FS_GROUP_QUOTA;
> +	fdq->d_id = gfs_id;
>  	fdq->d_blk_hardlimit = be64_to_cpu(qlvb->qb_limit) << sdp->sd_fsb2bb_shift;
>  	fdq->d_blk_softlimit = be64_to_cpu(qlvb->qb_warn) << sdp->sd_fsb2bb_shift;
>  	fdq->d_bcount = be64_to_cpu(qlvb->qb_value) << sdp->sd_fsb2bb_shift;
> @@ -1514,8 +1520,8 @@ out:
>  /* GFS2 only supports a subset of the XFS fields */
>  #define GFS2_FIELDMASK (FS_DQ_BSOFT|FS_DQ_BHARD|FS_DQ_BCOUNT)
>  
> -static int gfs2_set_dqblk(struct super_block *sb, int type, qid_t id,
> -			  struct fs_disk_quota *fdq)
> +static int gfs2_set_dqblk(struct super_block *sb, enum quota_type type,
> +			  qown_t id, struct fs_disk_quota *fdq)
>  {
>  	struct gfs2_sbd *sdp = sb->s_fs_info;
>  	struct gfs2_inode *ip = GFS2_I(sdp->sd_quota_inode);
> @@ -1526,18 +1532,22 @@ static int gfs2_set_dqblk(struct super_block *sb, int type, qid_t id,
>  	int alloc_required;
>  	loff_t offset;
>  	int error;
> +	int user;
> +	u32 gfs_id;
>  
>  	if (sdp->sd_args.ar_quota == GFS2_QUOTA_OFF)
>  		return -ESRCH; /* Crazy XFS error code */
>  
> +	gfs_id = from_qown(&init_user_ns, type, id);
> +
>  	switch(type) {
>  	case USRQUOTA:
> -		type = QUOTA_USER;
> +		user = QUOTA_USER;
>  		if (fdq->d_flags != FS_USER_QUOTA)
>  			return -EINVAL;
>  		break;
>  	case GRPQUOTA:
> -		type = QUOTA_GROUP;
> +		user = QUOTA_GROUP;
>  		if (fdq->d_flags != FS_GROUP_QUOTA)
>  			return -EINVAL;
>  		break;
> @@ -1547,10 +1557,10 @@ static int gfs2_set_dqblk(struct super_block *sb, int type, qid_t id,
>  
>  	if (fdq->d_fieldmask & ~GFS2_FIELDMASK)
>  		return -EINVAL;
> -	if (fdq->d_id != id)
> +	if (fdq->d_id != gfs_id)
>  		return -EINVAL;
>  
> -	error = qd_get(sdp, type, id, &qd);
> +	error = qd_get(sdp, user, gfs_id, &qd);
>  	if (error)
>  		return error;
>  
> diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
> index 46a1f6d..063e889 100644
> --- a/fs/ocfs2/file.c
> +++ b/fs/ocfs2/file.c
> @@ -1184,8 +1184,7 @@ int ocfs2_setattr(struct dentry *dentry, struct iattr *attr)
>  		if (attr->ia_valid & ATTR_UID && attr->ia_uid != inode->i_uid
>  		    && OCFS2_HAS_RO_COMPAT_FEATURE(sb,
>  		    OCFS2_FEATURE_RO_COMPAT_USRQUOTA)) {
> -			transfer_to[USRQUOTA] = dqget(sb, attr->ia_uid,
> -						      USRQUOTA);
> +			transfer_to[USRQUOTA] = dqgetusr(sb, attr->ia_uid);
>  			if (!transfer_to[USRQUOTA]) {
>  				status = -ESRCH;
>  				goto bail_unlock;
> @@ -1194,8 +1193,7 @@ int ocfs2_setattr(struct dentry *dentry, struct iattr *attr)
>  		if (attr->ia_valid & ATTR_GID && attr->ia_gid != inode->i_gid
>  		    && OCFS2_HAS_RO_COMPAT_FEATURE(sb,
>  		    OCFS2_FEATURE_RO_COMPAT_GRPQUOTA)) {
> -			transfer_to[GRPQUOTA] = dqget(sb, attr->ia_gid,
> -						      GRPQUOTA);
> +			transfer_to[GRPQUOTA] = dqgetgrp(sb, attr->ia_gid);
>  			if (!transfer_to[GRPQUOTA]) {
>  				status = -ESRCH;
>  				goto bail_unlock;
> diff --git a/fs/ocfs2/quota_global.c b/fs/ocfs2/quota_global.c
> index 0a86e30..88360f1 100644
> --- a/fs/ocfs2/quota_global.c
> +++ b/fs/ocfs2/quota_global.c
> @@ -95,7 +95,8 @@ static void ocfs2_global_mem2diskdqb(void *dp, struct dquot *dquot)
>  	struct ocfs2_global_disk_dqblk *d = dp;
>  	struct mem_dqblk *m = &dquot->dq_dqb;
>  
> -	d->dqb_id = cpu_to_le32(dquot->dq_id);
> +	d->dqb_id = cpu_to_le32(from_qown(&init_user_ns, dquot->dq_type,
> +					  dquot->dq_id));
>  	d->dqb_use_count = cpu_to_le32(OCFS2_DQUOT(dquot)->dq_use_count);
>  	d->dqb_ihardlimit = cpu_to_le64(m->dqb_ihardlimit);
>  	d->dqb_isoftlimit = cpu_to_le64(m->dqb_isoftlimit);
> @@ -113,10 +114,13 @@ static int ocfs2_global_is_id(void *dp, struct dquot *dquot)
>  	struct ocfs2_global_disk_dqblk *d = dp;
>  	struct ocfs2_mem_dqinfo *oinfo =
>  			sb_dqinfo(dquot->dq_sb, dquot->dq_type)->dqi_priv;
> +	qown_t qown;
>  
>  	if (qtree_entry_unused(&oinfo->dqi_gi, dp))
>  		return 0;
> -	return le32_to_cpu(d->dqb_id) == dquot->dq_id;
> +
> +	qown = make_qown(&init_user_ns, dquot->dq_type, le32_to_cpu(d->dqb_id));
> +	return qown_eq(qown, dquot->dq_id, dquot->dq_type);
>  }
>  
>  struct qtree_fmt_operations ocfs2_global_ops = {
> @@ -504,7 +508,9 @@ int __ocfs2_sync_dquot(struct dquot *dquot, int freeing)
>  	olditime = dquot->dq_dqb.dqb_itime;
>  	oldbtime = dquot->dq_dqb.dqb_btime;
>  	ocfs2_global_disk2memdqb(dquot, &dqblk);
> -	trace_ocfs2_sync_dquot(dquot->dq_id, dquot->dq_dqb.dqb_curspace,
> +	trace_ocfs2_sync_dquot(from_qown(&init_user_ns, dquot->dq_type,
> +					 dquot->dq_id),
> +			       dquot->dq_dqb.dqb_curspace,
>  			       (long long)spacechange,
>  			       dquot->dq_dqb.dqb_curinodes,
>  			       (long long)inodechange);
> @@ -556,7 +562,8 @@ int __ocfs2_sync_dquot(struct dquot *dquot, int freeing)
>  	if (err < 0) {
>  		mlog(ML_ERROR, "Failed to lock quota info, losing quota write"
>  			       " (type=%d, id=%u)\n", dquot->dq_type,
> -			       (unsigned)dquot->dq_id);
> +			       (unsigned)from_qown(&init_user_ns, dquot->dq_type,
> +						   dquot->dq_id));
>  		goto out;
>  	}
>  	if (freeing)
> @@ -591,7 +598,9 @@ static int ocfs2_sync_dquot_helper(struct dquot *dquot, unsigned long type)
>  	struct ocfs2_super *osb = OCFS2_SB(sb);
>  	int status = 0;
>  
> -	trace_ocfs2_sync_dquot_helper(dquot->dq_id, dquot->dq_type,
> +	trace_ocfs2_sync_dquot_helper(from_qown(&init_user_ns, dquot->dq_type,
> +						dquot->dq_id),
> +				      dquot->dq_type,
>  				      type, sb->s_id);
>  	if (type != dquot->dq_type)
>  		goto out;
> @@ -643,7 +652,9 @@ static int ocfs2_write_dquot(struct dquot *dquot)
>  	struct ocfs2_super *osb = OCFS2_SB(dquot->dq_sb);
>  	int status = 0;
>  
> -	trace_ocfs2_write_dquot(dquot->dq_id, dquot->dq_type);
> +	trace_ocfs2_write_dquot(from_qown(&init_user_ns, dquot->dq_type,
> +					   dquot->dq_id),
> +				dquot->dq_type);
>  
>  	handle = ocfs2_start_trans(osb, OCFS2_QWRITE_CREDITS);
>  	if (IS_ERR(handle)) {
> @@ -681,7 +692,9 @@ static int ocfs2_release_dquot(struct dquot *dquot)
>  	struct ocfs2_super *osb = OCFS2_SB(dquot->dq_sb);
>  	int status = 0;
>  
> -	trace_ocfs2_release_dquot(dquot->dq_id, dquot->dq_type);
> +	trace_ocfs2_release_dquot(from_qown(&init_user_ns, dquot->dq_type,
> +					    dquot->dq_id),
> +				  dquot->dq_type);
>  
>  	mutex_lock(&dquot->dq_lock);
>  	/* Check whether we are not racing with some other dqget() */
> @@ -739,7 +752,8 @@ static int ocfs2_acquire_dquot(struct dquot *dquot)
>  	int need_alloc = ocfs2_global_qinit_alloc(sb, type);
>  	handle_t *handle;
>  
> -	trace_ocfs2_acquire_dquot(dquot->dq_id, type);
> +	trace_ocfs2_acquire_dquot(from_qown(&init_user_ns, type, dquot->dq_id),
> +				  type);
>  	mutex_lock(&dquot->dq_lock);
>  	/*
>  	 * We need an exclusive lock, because we're going to update use count
> @@ -826,7 +840,9 @@ static int ocfs2_mark_dquot_dirty(struct dquot *dquot)
>  	handle_t *handle;
>  	struct ocfs2_super *osb = OCFS2_SB(sb);
>  
> -	trace_ocfs2_mark_dquot_dirty(dquot->dq_id, type);
> +	trace_ocfs2_mark_dquot_dirty(from_qown(&init_user_ns, type,
> +					       dquot->dq_id),
> +				     type);
>  
>  	/* In case user set some limits, sync dquot immediately to global
>  	 * quota file so that information propagates quicker */
> diff --git a/fs/ocfs2/quota_local.c b/fs/ocfs2/quota_local.c
> index f100bf7..a80936e 100644
> --- a/fs/ocfs2/quota_local.c
> +++ b/fs/ocfs2/quota_local.c
> @@ -501,7 +501,10 @@ static int ocfs2_recover_local_quota_file(struct inode *lqinode,
>  			}
>  			dqblk = (struct ocfs2_local_disk_dqblk *)(qbh->b_data +
>  				ol_dqblk_block_off(sb, chunk, bit));
> -			dquot = dqget(sb, le64_to_cpu(dqblk->dqb_id), type);
> +			dquot = dqget(sb,
> +				      make_qown(&init_user_ns, type,
> +						le64_to_cpu(dqblk->dqb_id)),
> +				      type);
>  			if (!dquot) {
>  				status = -EIO;
>  				mlog(ML_ERROR, "Failed to get quota structure "
> @@ -881,7 +884,9 @@ static void olq_set_dquot(struct buffer_head *bh, void *private)
>  	dqblk = (struct ocfs2_local_disk_dqblk *)(bh->b_data
>  		+ ol_dqblk_block_offset(sb, od->dq_local_off));
>  
> -	dqblk->dqb_id = cpu_to_le64(od->dq_dquot.dq_id);
> +	dqblk->dqb_id = cpu_to_le64(from_qown(&init_user_ns,
> +					      od->dq_dquot.dq_type,
> +					      od->dq_dquot.dq_id));
>  	spin_lock(&dq_data_lock);
>  	dqblk->dqb_spacemod = cpu_to_le64(od->dq_dquot.dq_dqb.dqb_curspace -
>  					  od->dq_origspace);
> @@ -891,7 +896,8 @@ static void olq_set_dquot(struct buffer_head *bh, void *private)
>  	trace_olq_set_dquot(
>  		(unsigned long long)le64_to_cpu(dqblk->dqb_spacemod),
>  		(unsigned long long)le64_to_cpu(dqblk->dqb_inodemod),
> -		od->dq_dquot.dq_id);
> +		from_qown(&init_user_ns, od->dq_dquot.dq_type,
> +			  od->dq_dquot.dq_id));
>  }
>  
>  /* Write dquot to local quota file */
> diff --git a/fs/quota/dquot.c b/fs/quota/dquot.c
> index 36a29b7..5fbd1d9a 100644
> --- a/fs/quota/dquot.c
> +++ b/fs/quota/dquot.c
> @@ -253,10 +253,12 @@ static qsize_t inode_get_rsv_space(struct inode *inode);
>  static void __dquot_initialize(struct inode *inode, int type);
>  
>  static inline unsigned int
> -hashfn(const struct super_block *sb, unsigned int id, int type)
> +hashfn(const struct super_block *sb, qown_t qown, enum quota_type type)
>  {
> +	unsigned int id;
>  	unsigned long tmp;
>  
> +	id = from_qown(&init_user_ns, type, qown);
>  	tmp = (((unsigned long)sb>>L1_CACHE_SHIFT) ^ id) * (MAXQUOTAS - type);
>  	return (tmp + (tmp >> dq_hash_bits)) & dq_hash_mask;
>  }
> @@ -277,15 +279,15 @@ static inline void remove_dquot_hash(struct dquot *dquot)
>  }
>  
>  static struct dquot *find_dquot(unsigned int hashent, struct super_block *sb,
> -				unsigned int id, int type)
> +				qown_t id, enum quota_type type)
>  {
>  	struct hlist_node *node;
>  	struct dquot *dquot;
>  
>  	hlist_for_each (node, dquot_hash+hashent) {
>  		dquot = hlist_entry(node, struct dquot, dq_hash);
> -		if (dquot->dq_sb == sb && dquot->dq_id == id &&
> -		    dquot->dq_type == type)
> +		if (dquot->dq_sb == sb && dquot->dq_type == type &&
> +		    qown_eq(dquot->dq_id, id, type))
>  			return dquot;
>  	}
>  	return NULL;
> @@ -741,7 +743,9 @@ void dqput(struct dquot *dquot)
>  #ifdef CONFIG_QUOTA_DEBUG
>  	if (!atomic_read(&dquot->dq_count)) {
>  		quota_error(dquot->dq_sb, "trying to free free dquot of %s %d",
> -			    quotatypes[dquot->dq_type], dquot->dq_id);
> +			    quotatypes[dquot->dq_type],
> +			    from_qown(&init_user_ns, dquot->dq_type,
> +				      dquot->dq_id));
>  		BUG();
>  	}
>  #endif
> @@ -829,7 +833,7 @@ static struct dquot *get_empty_dquot(struct super_block *sb, int type)
>   *   a) checking for quota flags under dq_list_lock and
>   *   b) getting a reference to dquot before we release dq_list_lock
>   */
> -struct dquot *dqget(struct super_block *sb, unsigned int id, int type)
> +struct dquot *dqget(struct super_block *sb, qown_t id, enum quota_type type)
>  {
>  	unsigned int hashent = hashfn(sb, id, type);
>  	struct dquot *dquot = NULL, *empty = NULL;
> @@ -1129,7 +1133,7 @@ static void dquot_decr_space(struct dquot *dquot, qsize_t number)
>  
>  struct dquot_warn {
>  	struct super_block *w_sb;
> -	qid_t w_dq_id;
> +	qown_t w_dq_id;
>  	short w_dq_type;
>  	short w_type;
>  };
> @@ -1156,9 +1160,9 @@ static int need_print_warning(struct dquot_warn *warn)
>  
>  	switch (warn->w_dq_type) {
>  		case USRQUOTA:
> -			return current_fsuid() == warn->w_dq_id;
> +			return uid_eq(current_fsuid(), warn->w_dq_id.uid);
>  		case GRPQUOTA:
> -			return in_group_p(warn->w_dq_id);
> +			return in_group_p(warn->w_dq_id.gid);
>  	}
>  	return 0;
>  }
> @@ -1390,7 +1394,6 @@ static int dquot_active(const struct inode *inode)
>   */
>  static void __dquot_initialize(struct inode *inode, int type)
>  {
> -	unsigned int id = 0;
>  	int cnt;
>  	struct dquot *got[MAXQUOTAS];
>  	struct super_block *sb = inode->i_sb;
> @@ -1403,15 +1406,16 @@ static void __dquot_initialize(struct inode *inode, int type)
>  
>  	/* First get references to structures we might need. */
>  	for (cnt = 0; cnt < MAXQUOTAS; cnt++) {
> +		qown_t id;
>  		got[cnt] = NULL;
>  		if (type != -1 && cnt != type)
>  			continue;
>  		switch (cnt) {
>  		case USRQUOTA:
> -			id = inode->i_uid;
> +			id.uid = inode->i_uid;
>  			break;
>  		case GRPQUOTA:
> -			id = inode->i_gid;
> +			id.gid = inode->i_gid;
>  			break;
>  		}
>  		got[cnt] = dqget(sb, id, cnt);
> @@ -1897,10 +1901,10 @@ int dquot_transfer(struct inode *inode, struct iattr *iattr)
>  	if (!dquot_active(inode))
>  		return 0;
>  
> -	if (iattr->ia_valid & ATTR_UID && iattr->ia_uid != inode->i_uid)
> -		transfer_to[USRQUOTA] = dqget(sb, iattr->ia_uid, USRQUOTA);
> -	if (iattr->ia_valid & ATTR_GID && iattr->ia_gid != inode->i_gid)
> -		transfer_to[GRPQUOTA] = dqget(sb, iattr->ia_gid, GRPQUOTA);
> +	if (iattr->ia_valid & ATTR_UID && !uid_eq(iattr->ia_uid, inode->i_uid))
> +		transfer_to[USRQUOTA] = dqgetusr(sb, iattr->ia_uid);
> +	if (iattr->ia_valid & ATTR_GID && !gid_eq(iattr->ia_gid, inode->i_gid))
> +		transfer_to[GRPQUOTA] = dqgetgrp(sb, iattr->ia_gid);
>  
>  	ret = __dquot_transfer(inode, transfer_to);
>  	dqput_all(transfer_to);
> @@ -2362,7 +2366,8 @@ static void do_get_dqblk(struct dquot *dquot, struct fs_disk_quota *di)
>  	di->d_version = FS_DQUOT_VERSION;
>  	di->d_flags = dquot->dq_type == USRQUOTA ?
>  			FS_USER_QUOTA : FS_GROUP_QUOTA;
> -	di->d_id = dquot->dq_id;
> +	di->d_id = from_qown_munged(current_user_ns(), dquot->dq_type,
> +				    dquot->dq_id);
>  
>  	spin_lock(&dq_data_lock);
>  	di->d_blk_hardlimit = stoqb(dm->dqb_bhardlimit);
> @@ -2376,7 +2381,7 @@ static void do_get_dqblk(struct dquot *dquot, struct fs_disk_quota *di)
>  	spin_unlock(&dq_data_lock);
>  }
>  
> -int dquot_get_dqblk(struct super_block *sb, int type, qid_t id,
> +int dquot_get_dqblk(struct super_block *sb, enum quota_type type, qown_t id,
>  		    struct fs_disk_quota *di)
>  {
>  	struct dquot *dquot;
> @@ -2488,7 +2493,7 @@ static int do_set_dqblk(struct dquot *dquot, struct fs_disk_quota *di)
>  	return 0;
>  }
>  
> -int dquot_set_dqblk(struct super_block *sb, int type, qid_t id,
> +int dquot_set_dqblk(struct super_block *sb, enum quota_type type, qown_t id,
>  		  struct fs_disk_quota *di)
>  {
>  	struct dquot *dquot;
> diff --git a/fs/quota/netlink.c b/fs/quota/netlink.c
> index d67908b..b2678da 100644
> --- a/fs/quota/netlink.c
> +++ b/fs/quota/netlink.c
> @@ -30,7 +30,7 @@ static struct genl_family quota_genl_family = {
>   *
>   */
>  
> -void quota_send_warning(short type, unsigned int id, dev_t dev,
> +void quota_send_warning(enum quota_type type, qown_t id, dev_t dev,
>  			const char warntype)
>  {
>  	static atomic_t seq;
> @@ -59,7 +59,8 @@ void quota_send_warning(short type, unsigned int id, dev_t dev,
>  	ret = nla_put_u32(skb, QUOTA_NL_A_QTYPE, type);
>  	if (ret)
>  		goto attr_err_out;
> -	ret = nla_put_u64(skb, QUOTA_NL_A_EXCESS_ID, id);
> +	ret = nla_put_u64(skb, QUOTA_NL_A_EXCESS_ID,
> +			  from_qown_munged(&init_user_ns, type, id));
>  	if (ret)
>  		goto attr_err_out;
>  	ret = nla_put_u32(skb, QUOTA_NL_A_WARNING, warntype);
> @@ -71,7 +72,11 @@ void quota_send_warning(short type, unsigned int id, dev_t dev,
>  	ret = nla_put_u32(skb, QUOTA_NL_A_DEV_MINOR, MINOR(dev));
>  	if (ret)
>  		goto attr_err_out;
> -	ret = nla_put_u64(skb, QUOTA_NL_A_CAUSED_ID, current_uid());
> +	/* Report the current user as seen by the filesystem that issues
> +	 * quota warning.
> +	 */
> +	ret = nla_put_u64(skb, QUOTA_NL_A_CAUSED_ID,
> +			  from_kuid_munged(&init_user_ns, current_uid()));
>  	if (ret)
>  		goto attr_err_out;
>  	genlmsg_end(skb, msg_head);
> diff --git a/fs/quota/quota.c b/fs/quota/quota.c
> index 6f15578..b9f44b7 100644
> --- a/fs/quota/quota.c
> +++ b/fs/quota/quota.c
> @@ -32,8 +32,8 @@ static int check_quotactl_permission(struct super_block *sb, int type, int cmd,
>  	/* allow to query information for dquots we "own" */
>  	case Q_GETQUOTA:
>  	case Q_XGETQUOTA:
> -		if ((type == USRQUOTA && current_euid() == id) ||
> -		    (type == GRPQUOTA && in_egroup_p(id)))
> +		if ((type == USRQUOTA && uid_eq(current_euid(), make_kuid(current_user_ns(), id))) ||
> +		    (type == GRPQUOTA && in_egroup_p(make_kgid(current_user_ns(), id))))
>  			break;
>  		/*FALLTHROUGH*/
>  	default:
> @@ -62,7 +62,7 @@ static int quota_sync_all(int type)
>  	return ret;
>  }
>  
> -static int quota_quotaon(struct super_block *sb, int type, int cmd, qid_t id,
> +static int quota_quotaon(struct super_block *sb, enum quota_type type, int cmd, qid_t id,
>  		         struct path *path)
>  {
>  	if (!sb->s_qcop->quota_on && !sb->s_qcop->quota_on_meta)
> @@ -127,16 +127,20 @@ static void copy_to_if_dqblk(struct if_dqblk *dst, struct fs_disk_quota *src)
>  	dst->dqb_valid = QIF_ALL;
>  }
>  
> -static int quota_getquota(struct super_block *sb, int type, qid_t id,
> -			  void __user *addr)
> +static int quota_getquota(struct super_block *sb, enum quota_type type,
> +			  qid_t id, void __user *addr)
>  {
> +	qown_t qown;
>  	struct fs_disk_quota fdq;
>  	struct if_dqblk idq;
>  	int ret;
>  
>  	if (!sb->s_qcop->get_dqblk)
>  		return -ENOSYS;
> -	ret = sb->s_qcop->get_dqblk(sb, type, id, &fdq);
> +	qown = make_qown(current_user_ns(), type, id);
> +	if (qown_valid(type, qown))
> +		return -EINVAL;
> +	ret = sb->s_qcop->get_dqblk(sb, type, qown, &fdq);
>  	if (ret)
>  		return ret;
>  	copy_to_if_dqblk(&idq, &fdq);
> @@ -171,18 +175,22 @@ static void copy_from_if_dqblk(struct fs_disk_quota *dst, struct if_dqblk *src)
>  		dst->d_fieldmask |= FS_DQ_ITIMER;
>  }
>  
> -static int quota_setquota(struct super_block *sb, int type, qid_t id,
> -			  void __user *addr)
> +static int quota_setquota(struct super_block *sb, enum quota_type type,
> +			  qid_t id,  void __user *addr)
>  {
>  	struct fs_disk_quota fdq;
>  	struct if_dqblk idq;
> +	qown_t qown;
>  
>  	if (copy_from_user(&idq, addr, sizeof(idq)))
>  		return -EFAULT;
>  	if (!sb->s_qcop->set_dqblk)
>  		return -ENOSYS;
> +	qown = make_qown(current_user_ns(), type, id);
> +	if (!qown_valid(type, qown))
> +		return -EINVAL;
>  	copy_from_if_dqblk(&fdq, &idq);
> -	return sb->s_qcop->set_dqblk(sb, type, id, &fdq);
> +	return sb->s_qcop->set_dqblk(sb, type, qown, &fdq);
>  }
>  
>  static int quota_setxstate(struct super_block *sb, int cmd, void __user *addr)
> @@ -209,27 +217,35 @@ static int quota_getxstate(struct super_block *sb, void __user *addr)
>  	return ret;
>  }
>  
> -static int quota_setxquota(struct super_block *sb, int type, qid_t id,
> +static int quota_setxquota(struct super_block *sb, enum quota_type type, qid_t id,
>  			   void __user *addr)
>  {
>  	struct fs_disk_quota fdq;
> +	qown_t qown;
>  
>  	if (copy_from_user(&fdq, addr, sizeof(fdq)))
>  		return -EFAULT;
>  	if (!sb->s_qcop->set_dqblk)
>  		return -ENOSYS;
> -	return sb->s_qcop->set_dqblk(sb, type, id, &fdq);
> +	qown = make_qown(current_user_ns(), type, id);
> +	if (!qown_valid(type, qown))
> +		return -EINVAL;
> +	return sb->s_qcop->set_dqblk(sb, type, qown, &fdq);
>  }
>  
> -static int quota_getxquota(struct super_block *sb, int type, qid_t id,
> -			   void __user *addr)
> +static int quota_getxquota(struct super_block *sb, enum quota_type type,
> +			   qid_t id, void __user *addr)
>  {
>  	struct fs_disk_quota fdq;
> +	qown_t qown;
>  	int ret;
>  
>  	if (!sb->s_qcop->get_dqblk)
>  		return -ENOSYS;
> -	ret = sb->s_qcop->get_dqblk(sb, type, id, &fdq);
> +	qown = make_qown(current_user_ns(), type, id);
> +	if (!qown_valid(type, qown))
> +		return -EINVAL;
> +	ret = sb->s_qcop->get_dqblk(sb, type, qown, &fdq);
>  	if (!ret && copy_to_user(addr, &fdq, sizeof(fdq)))
>  		return -EFAULT;
>  	return ret;
> diff --git a/fs/quota/quota_tree.c b/fs/quota/quota_tree.c
> index e41c1becf..4704619 100644
> --- a/fs/quota/quota_tree.c
> +++ b/fs/quota/quota_tree.c
> @@ -22,10 +22,12 @@ MODULE_LICENSE("GPL");
>  
>  #define __QUOTA_QT_PARANOIA
>  
> -static int get_index(struct qtree_mem_dqinfo *info, qid_t id, int depth)
> +static int get_index(struct qtree_mem_dqinfo *info, qown_t qown, int depth)
>  {
>  	unsigned int epb = info->dqi_usable_bs >> 2;
> +	qid_t id;
>  
> +	id = from_qown(&init_user_ns, info->dqi_type, qown);
>  	depth = info->dqi_qtree_depth - depth - 1;
>  	while (depth--)
>  		id /= epb;
> @@ -538,8 +540,10 @@ static loff_t find_block_dqentry(struct qtree_mem_dqinfo *info,
>  		ddquot += info->dqi_entry_size;
>  	}
>  	if (i == qtree_dqstr_in_blk(info)) {
> -		quota_error(dquot->dq_sb, "Quota for id %u referenced "
> -			    "but not present", dquot->dq_id);
> +		quota_error(dquot->dq_sb,
> +			    "Quota for id %u referenced but not present",
> +			    from_qown(&init_user_ns, dquot->dq_type,
> +				      dquot->dq_id));
>  		ret = -EIO;
>  		goto out_buf;
>  	} else {
> @@ -607,8 +611,11 @@ int qtree_read_dquot(struct qtree_mem_dqinfo *info, struct dquot *dquot)
>  		offset = find_dqentry(info, dquot);
>  		if (offset <= 0) {	/* Entry not present? */
>  			if (offset < 0)
> -				quota_error(sb, "Can't read quota structure "
> -					    "for id %u", dquot->dq_id);
> +				quota_error(sb,"Can't read quota structure "
> +					    "for id %u",
> +					    from_qown(&init_user_ns,
> +						      dquot->dq_type,
> +						      dquot->dq_id));
>  			dquot->dq_off = 0;
>  			set_bit(DQ_FAKE_B, &dquot->dq_flags);
>  			memset(&dquot->dq_dqb, 0, sizeof(struct mem_dqblk));
> @@ -626,7 +633,8 @@ int qtree_read_dquot(struct qtree_mem_dqinfo *info, struct dquot *dquot)
>  		if (ret >= 0)
>  			ret = -EIO;
>  		quota_error(sb, "Error while reading quota structure for id %u",
> -			    dquot->dq_id);
> +			    from_qown(&init_user_ns, dquot->dq_type,
> +				      dquot->dq_id));
>  		set_bit(DQ_FAKE_B, &dquot->dq_flags);
>  		memset(&dquot->dq_dqb, 0, sizeof(struct mem_dqblk));
>  		kfree(ddquot);
> diff --git a/fs/quota/quota_v1.c b/fs/quota/quota_v1.c
> index 34b37a6..7c028f9 100644
> --- a/fs/quota/quota_v1.c
> +++ b/fs/quota/quota_v1.c
> @@ -63,7 +63,8 @@ static int v1_read_dqblk(struct dquot *dquot)
>  	/* Set structure to 0s in case read fails/is after end of file */
>  	memset(&dqblk, 0, sizeof(struct v1_disk_dqblk));
>  	dquot->dq_sb->s_op->quota_read(dquot->dq_sb, type, (char *)&dqblk,
> -			sizeof(struct v1_disk_dqblk), v1_dqoff(dquot->dq_id));
> +			sizeof(struct v1_disk_dqblk),
> +			v1_dqoff(from_qown(&init_user_ns, type, dquot->dq_id)));
>  
>  	v1_disk2mem_dqblk(&dquot->dq_dqb, &dqblk);
>  	if (dquot->dq_dqb.dqb_bhardlimit == 0 &&
> @@ -83,7 +84,8 @@ static int v1_commit_dqblk(struct dquot *dquot)
>  	struct v1_disk_dqblk dqblk;
>  
>  	v1_mem2disk_dqblk(&dqblk, &dquot->dq_dqb);
> -	if (dquot->dq_id == 0) {
> +	if (((type == USRQUOTA) && uid_eq(dquot->dq_id.uid, GLOBAL_ROOT_UID)) ||
> +	    ((type == GRPQUOTA) && gid_eq(dquot->dq_id.gid, GLOBAL_ROOT_GID))) {
>  		dqblk.dqb_btime =
>  			sb_dqopt(dquot->dq_sb)->info[type].dqi_bgrace;
>  		dqblk.dqb_itime =
> @@ -93,7 +95,7 @@ static int v1_commit_dqblk(struct dquot *dquot)
>  	if (sb_dqopt(dquot->dq_sb)->files[type])
>  		ret = dquot->dq_sb->s_op->quota_write(dquot->dq_sb, type,
>  			(char *)&dqblk, sizeof(struct v1_disk_dqblk),
> -			v1_dqoff(dquot->dq_id));
> +			v1_dqoff(from_qown(&init_user_ns, type, dquot->dq_id)));
>  	if (ret != sizeof(struct v1_disk_dqblk)) {
>  		quota_error(dquot->dq_sb, "dquota write failed");
>  		if (ret >= 0)
> diff --git a/fs/quota/quota_v2.c b/fs/quota/quota_v2.c
> index f1ab360..b9068b7 100644
> --- a/fs/quota/quota_v2.c
> +++ b/fs/quota/quota_v2.c
> @@ -206,7 +206,8 @@ static void v2r0_mem2diskdqb(void *dp, struct dquot *dquot)
>  	d->dqb_bsoftlimit = cpu_to_le32(v2_stoqb(m->dqb_bsoftlimit));
>  	d->dqb_curspace = cpu_to_le64(m->dqb_curspace);
>  	d->dqb_btime = cpu_to_le64(m->dqb_btime);
> -	d->dqb_id = cpu_to_le32(dquot->dq_id);
> +	d->dqb_id = cpu_to_le32(from_qown(&init_user_ns,
> +					  dquot->dq_type, dquot->dq_id));
>  	if (qtree_entry_unused(info, dp))
>  		d->dqb_itime = cpu_to_le64(1);
>  }
> @@ -216,10 +217,12 @@ static int v2r0_is_id(void *dp, struct dquot *dquot)
>  	struct v2r0_disk_dqblk *d = dp;
>  	struct qtree_mem_dqinfo *info =
>  			sb_dqinfo(dquot->dq_sb, dquot->dq_type)->dqi_priv;
> +	qown_t qown;
>  
>  	if (qtree_entry_unused(info, dp))
>  		return 0;
> -	return le32_to_cpu(d->dqb_id) == dquot->dq_id;
> +	qown = make_qown(&init_user_ns, dquot->dq_type, le32_to_cpu(d->dqb_id));
> +	return qown_eq(qown, dquot->dq_id, dquot->dq_type);
>  }
>  
>  static void v2r1_disk2memdqb(struct dquot *dquot, void *dp)
> @@ -257,7 +260,8 @@ static void v2r1_mem2diskdqb(void *dp, struct dquot *dquot)
>  	d->dqb_bsoftlimit = cpu_to_le64(v2_stoqb(m->dqb_bsoftlimit));
>  	d->dqb_curspace = cpu_to_le64(m->dqb_curspace);
>  	d->dqb_btime = cpu_to_le64(m->dqb_btime);
> -	d->dqb_id = cpu_to_le32(dquot->dq_id);
> +	d->dqb_id = cpu_to_le32(from_qown(&init_user_ns,
> +					  dquot->dq_type, dquot->dq_id));
>  	if (qtree_entry_unused(info, dp))
>  		d->dqb_itime = cpu_to_le64(1);
>  }
> @@ -267,10 +271,12 @@ static int v2r1_is_id(void *dp, struct dquot *dquot)
>  	struct v2r1_disk_dqblk *d = dp;
>  	struct qtree_mem_dqinfo *info =
>  			sb_dqinfo(dquot->dq_sb, dquot->dq_type)->dqi_priv;
> +	qown_t qown;
>  
>  	if (qtree_entry_unused(info, dp))
>  		return 0;
> -	return le32_to_cpu(d->dqb_id) == dquot->dq_id;
> +	qown = make_qown(&init_user_ns, dquot->dq_type, le32_to_cpu(d->dqb_id));
> +	return qown_eq(qown, dquot->dq_id, dquot->dq_type);
>  }
>  
>  static int v2_read_dquot(struct dquot *dquot)
> diff --git a/fs/xfs/xfs_quotaops.c b/fs/xfs/xfs_quotaops.c
> index fed504f..9ee2d6d 100644
> --- a/fs/xfs/xfs_quotaops.c
> +++ b/fs/xfs/xfs_quotaops.c
> @@ -29,7 +29,7 @@
>  
> 
>  STATIC int
> -xfs_quota_type(int type)
> +xfs_quota_type(enum quota_type type)
>  {
>  	switch (type) {
>  	case USRQUOTA:
> @@ -97,28 +97,31 @@ xfs_fs_set_xstate(
>  STATIC int
>  xfs_fs_get_dqblk(
>  	struct super_block	*sb,
> -	int			type,
> -	qid_t			id,
> +	enum quota_type		type,
> +	qown_t			id,
>  	struct fs_disk_quota	*fdq)
>  {
>  	struct xfs_mount	*mp = XFS_M(sb);
> +	xfs_dqid_t		xfs_id;
>  
>  	if (!XFS_IS_QUOTA_RUNNING(mp))
>  		return -ENOSYS;
>  	if (!XFS_IS_QUOTA_ON(mp))
>  		return -ESRCH;
>  
> -	return -xfs_qm_scall_getquota(mp, id, xfs_quota_type(type), fdq);
> +	xfs_id = from_qown(&init_user_ns, type, id);
> +	return -xfs_qm_scall_getquota(mp, xfs_id, xfs_quota_type(type), fdq);
>  }
>  
>  STATIC int
>  xfs_fs_set_dqblk(
>  	struct super_block	*sb,
> -	int			type,
> -	qid_t			id,
> +	enum quota_type		type,
> +	qown_t			id,
>  	struct fs_disk_quota	*fdq)
>  {
>  	struct xfs_mount	*mp = XFS_M(sb);
> +	xfs_dqid_t		xfs_id;
>  
>  	if (sb->s_flags & MS_RDONLY)
>  		return -EROFS;
> @@ -127,7 +130,8 @@ xfs_fs_set_dqblk(
>  	if (!XFS_IS_QUOTA_ON(mp))
>  		return -ESRCH;
>  
> -	return -xfs_qm_scall_setqlim(mp, id, xfs_quota_type(type), fdq);
> +	xfs_id = from_qown(&init_user_ns, type, id);
> +	return -xfs_qm_scall_setqlim(mp, xfs_id, xfs_quota_type(type), fdq);
>  }
>  
>  const struct quotactl_ops xfs_quotactl_operations = {
> diff --git a/fs/xfs/xfs_trans_dquot.c b/fs/xfs/xfs_trans_dquot.c
> index bcb6054..0c7ab32 100644
> --- a/fs/xfs/xfs_trans_dquot.c
> +++ b/fs/xfs/xfs_trans_dquot.c
> @@ -575,12 +575,14 @@ xfs_quota_warn(
>  	struct xfs_dquot	*dqp,
>  	int			type)
>  {
> +	enum quota_type qtype;
> +	qown_t qown;
>  	/* no warnings for project quotas - we just return ENOSPC later */
>  	if (dqp->dq_flags & XFS_DQ_PROJ)
>  		return;
> -	quota_send_warning((dqp->dq_flags & XFS_DQ_USER) ? USRQUOTA : GRPQUOTA,
> -			   be32_to_cpu(dqp->q_core.d_id), mp->m_super->s_dev,
> -			   type);
> +	qtype = (dqp->dq_flags & XFS_DQ_USER) ? USRQUOTA : GRPQUOTA;
> +	qown = make_qown(&init_user_ns, qtype, be32_to_cpu(dqp->q_core.d_id));
> +	quota_send_warning(qtype, qown, mp->m_super->s_dev, type);
>  }
>  
>  /*
> diff --git a/include/linux/quota.h b/include/linux/quota.h
> index 524ede8..67921d5 100644
> --- a/include/linux/quota.h
> +++ b/include/linux/quota.h
> @@ -181,10 +181,91 @@ enum {
>  #include <linux/dqblk_v2.h>
>  
>  #include <linux/atomic.h>
> +#include <linux/uidgid.h>
>  
>  typedef __kernel_uid32_t qid_t; /* Type in which we store ids in memory */
>  typedef long long qsize_t;	/* Type in which we store sizes */
>  
> +#undef USRQUOTA
> +#undef GRPQUOTA
> +enum quota_type {
> +	USRQUOTA = 0,
> +	GRPQUOTA = 1,
> +};
> +
> +typedef union quota_id {
> +	kuid_t uid;
> +	kgid_t gid;
> +} qown_t;			/* Type in which we store the quota owner */
> +
> +static inline bool qown_eq(qown_t left, qown_t right, enum quota_type type)
> +{
> +	switch(type) {
> +	case USRQUOTA:
> +		return uid_eq(left.uid, right.uid);
> +	case GRPQUOTA:
> +		return gid_eq(left.gid, right.gid);
> +	default:
> +		BUG();
> +	}
> +}
> +
> +static inline u32 from_qown(struct user_namespace *user_ns,
> +			    enum quota_type type, qown_t qown)
> +{
> +	switch (type) {
> +	case USRQUOTA:
> +		return from_kuid(user_ns, qown.uid);
> +	case GRPQUOTA:
> +		return from_kgid(user_ns, qown.gid);
> +	default:
> +		BUG();
> +	}
> +}
> +
> +static inline u32 from_qown_munged(struct user_namespace *user_ns,
> +				   enum quota_type type, qown_t qown)
> +{
> +	switch (type) {
> +	case USRQUOTA:
> +		return from_kuid_munged(user_ns, qown.uid);
> +	case GRPQUOTA:
> +		return from_kgid_munged(user_ns, qown.gid);
> +	default:
> +		BUG();
> +	}
> +}
> +
> +static inline qown_t make_qown(struct user_namespace *user_ns,
> +			      enum quota_type type, qid_t id)
> +{
> +	qown_t qown;
> +
> +	switch (type) {
> +	case USRQUOTA:
> +		qown.uid = make_kuid(user_ns, id);
> +		break;
> +	case GRPQUOTA:
> +		qown.gid = make_kgid(user_ns, id);
> +		break;
> +	default:
> +		BUG();
> +	}
> +	return qown;
> +}
> +
> +static inline bool qown_valid(enum quota_type type, qown_t qown)
> +{
> +	switch (type) {
> +	case USRQUOTA:
> +		return uid_valid(qown.uid);
> +	case GRPQUOTA:
> +		return gid_valid(qown.gid);
> +	default:
> +		BUG();
> +	}
> +}
> +
>  extern spinlock_t dq_data_lock;
>  
>  /* Maximal numbers of writes for quota operation (insert/delete/update)
> @@ -294,7 +375,7 @@ struct dquot {
>  	atomic_t dq_count;		/* Use count */
>  	wait_queue_head_t dq_wait_unused;	/* Wait queue for dquot to become unused */
>  	struct super_block *dq_sb;	/* superblock this applies to */
> -	unsigned int dq_id;		/* ID this applies to (uid, gid) */
> +	qown_t dq_id;			/* ID this applies to (uid, gid) */
>  	loff_t dq_off;			/* Offset of dquot on disk */
>  	unsigned long dq_flags;		/* See DQ_* */
>  	short dq_type;			/* Type of quota */
> @@ -336,8 +417,8 @@ struct quotactl_ops {
>  	int (*quota_sync)(struct super_block *, int);
>  	int (*get_info)(struct super_block *, int, struct if_dqinfo *);
>  	int (*set_info)(struct super_block *, int, struct if_dqinfo *);
> -	int (*get_dqblk)(struct super_block *, int, qid_t, struct fs_disk_quota *);
> -	int (*set_dqblk)(struct super_block *, int, qid_t, struct fs_disk_quota *);
> +	int (*get_dqblk)(struct super_block *, enum quota_type, qown_t, struct fs_disk_quota *);
> +	int (*set_dqblk)(struct super_block *, enum quota_type, qown_t, struct fs_disk_quota *);
>  	int (*get_xstate)(struct super_block *, struct fs_quota_stat *);
>  	int (*set_xstate)(struct super_block *, unsigned int, int);
>  };
> @@ -386,10 +467,10 @@ static inline unsigned int dquot_generic_flag(unsigned int flags, int type)
>  }
>  
>  #ifdef CONFIG_QUOTA_NETLINK_INTERFACE
> -extern void quota_send_warning(short type, unsigned int id, dev_t dev,
> +extern void quota_send_warning(enum quota_type type, qown_t id, dev_t dev,
>  			       const char warntype);
>  #else
> -static inline void quota_send_warning(short type, unsigned int id, dev_t dev,
> +static inline void quota_send_warning(enum quota_type type, qown_t id, dev_t dev,
>  				      const char warntype)
>  {
>  	return;
> diff --git a/include/linux/quotaops.h b/include/linux/quotaops.h
> index ec6b65f..d988b11 100644
> --- a/include/linux/quotaops.h
> +++ b/include/linux/quotaops.h
> @@ -44,13 +44,23 @@ void inode_sub_rsv_space(struct inode *inode, qsize_t number);
>  
>  void dquot_initialize(struct inode *inode);
>  void dquot_drop(struct inode *inode);
> -struct dquot *dqget(struct super_block *sb, unsigned int id, int type);
> +struct dquot *dqget(struct super_block *sb, qown_t id, enum quota_type type);
>  void dqput(struct dquot *dquot);
>  int dquot_scan_active(struct super_block *sb,
>  		      int (*fn)(struct dquot *dquot, unsigned long priv),
>  		      unsigned long priv);
>  struct dquot *dquot_alloc(struct super_block *sb, int type);
>  void dquot_destroy(struct dquot *dquot);
> +static inline struct dquot *dqgetusr(struct super_block *sb, kuid_t uid)
> +{
> +	qown_t id = { .uid = uid };
> +	return dqget(sb, id, USRQUOTA);
> +}
> +static inline struct dquot *dqgetgrp(struct super_block *sb, kgid_t gid)
> +{
> +	qown_t id = { .gid = gid };
> +	return dqget(sb, id, GRPQUOTA);
> +}
>  
>  int __dquot_alloc_space(struct inode *inode, qsize_t number, int flags);
>  void __dquot_free_space(struct inode *inode, qsize_t number, int flags);
> @@ -87,15 +97,15 @@ int dquot_writeback_dquots(struct super_block *sb, int type);
>  int dquot_quota_sync(struct super_block *sb, int type);
>  int dquot_get_dqinfo(struct super_block *sb, int type, struct if_dqinfo *ii);
>  int dquot_set_dqinfo(struct super_block *sb, int type, struct if_dqinfo *ii);
> -int dquot_get_dqblk(struct super_block *sb, int type, qid_t id,
> +int dquot_get_dqblk(struct super_block *sb, enum quota_type type, qown_t id,
>  		struct fs_disk_quota *di);
> -int dquot_set_dqblk(struct super_block *sb, int type, qid_t id,
> +int dquot_set_dqblk(struct super_block *sb, enum quota_type type, qown_t id,
>  		struct fs_disk_quota *di);
>  
>  int __dquot_transfer(struct inode *inode, struct dquot **transfer_to);
>  int dquot_transfer(struct inode *inode, struct iattr *iattr);
>  
> -static inline struct mem_dqinfo *sb_dqinfo(struct super_block *sb, int type)
> +static inline struct mem_dqinfo *sb_dqinfo(struct super_block *sb, enum quota_type type)
>  {
>  	return sb_dqopt(sb)->info + type;
>  }
> diff --git a/init/Kconfig b/init/Kconfig
> index 2a388e5..a0bccce 100644
> --- a/init/Kconfig
> +++ b/init/Kconfig
> @@ -928,8 +928,6 @@ config UIDGID_CONVERTED
>  	depends on IMA = n
>  	depends on EVM = n
>  	depends on FS_POSIX_ACL = n
> -	depends on QUOTA = n
> -	depends on QUOTACTL = n
>  
>  	# Networking
>  	depends on NET_9P = n


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
