Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id E17EB7F8D
	for <xfs@oss.sgi.com>; Wed, 18 Feb 2015 10:53:40 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id B9985304053
	for <xfs@oss.sgi.com>; Wed, 18 Feb 2015 08:53:40 -0800 (PST)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id OAFfXJaFcBdv54n1 (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 18 Feb 2015 08:53:38 -0800 (PST)
Date: Wed, 18 Feb 2015 08:53:34 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [Cluster-devel] [PATCH 6/8] quota: Make ->set_info use structure
	with neccesary info to VFS and XFS
Message-ID: <20150218165334.GB29465@infradead.org>
References: <1424267274-11836-1-git-send-email-jack@suse.cz>
	<1424267274-11836-7-git-send-email-jack@suse.cz>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1424267274-11836-7-git-send-email-jack@suse.cz>
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
To: Jan Kara <jack@suse.cz>
Cc: linux-fsdevel@vger.kernel.org, cluster-devel@redhat.com, xfs@oss.sgi.com

On Wed, Feb 18, 2015 at 02:47:52PM +0100, Jan Kara wrote:
> Change ->set_info to take new qc_info structure which contains all the
> necessary information both for XFS and VFS. Convert Q_SETINFO handler
> to use this structure.
> 
> Signed-off-by: Jan Kara <jack@suse.cz>
> ---
>  fs/quota/dquot.c         | 27 ++++++++++++++++-----------
>  fs/quota/quota.c         | 21 ++++++++++++++++++++-
>  include/linux/quota.h    | 21 +++++++++++++++++++--
>  include/linux/quotaops.h |  2 +-
>  4 files changed, 56 insertions(+), 15 deletions(-)
> 
> diff --git a/fs/quota/dquot.c b/fs/quota/dquot.c
> index cf4edd87e854..f37b74eab807 100644
> --- a/fs/quota/dquot.c
> +++ b/fs/quota/dquot.c
> @@ -2649,33 +2649,38 @@ int dquot_get_state(struct super_block *sb, struct qc_state *state)
>  EXPORT_SYMBOL(dquot_get_state);
>  
>  /* Generic routine for setting common part of quota file information */
> -int dquot_set_dqinfo(struct super_block *sb, int type, struct if_dqinfo *ii)
> +int dquot_set_dqinfo(struct super_block *sb, int type, struct qc_info *ii)
>  {
>  	struct mem_dqinfo *mi;
>  	int err = 0;
>  
> +	if ((ii->i_fieldmask & QC_WARNS_MASK) ||
> +	    (ii->i_fieldmask & QC_RT_SPC_TIMER))
> +		return -EINVAL;
>  	mutex_lock(&sb_dqopt(sb)->dqonoff_mutex);
>  	if (!sb_has_quota_active(sb, type)) {
>  		err = -ESRCH;
>  		goto out;
>  	}
>  	mi = sb_dqopt(sb)->info + type;
> -	if (ii->dqi_valid & IIF_FLAGS) {
> -		if (ii->dqi_flags & ~DQF_SETINFO_MASK ||
> -		    (ii->dqi_flags & DQF_ROOT_SQUASH &&
> +	if (ii->i_fieldmask & QC_FLAGS) {
> +		if ((ii->i_flags & QCI_ROOT_SQUASH &&
>  		     mi->dqi_format->qf_fmt_id != QFMT_VFS_OLD)) {
>  			err = -EINVAL;
>  			goto out;
>  		}
>  	}
>  	spin_lock(&dq_data_lock);
> -	if (ii->dqi_valid & IIF_BGRACE)
> -		mi->dqi_bgrace = ii->dqi_bgrace;
> -	if (ii->dqi_valid & IIF_IGRACE)
> -		mi->dqi_igrace = ii->dqi_igrace;
> -	if (ii->dqi_valid & IIF_FLAGS)
> -		mi->dqi_flags = (mi->dqi_flags & ~DQF_SETINFO_MASK) |
> -				(ii->dqi_flags & DQF_SETINFO_MASK);
> +	if (ii->i_fieldmask & QC_SPC_TIMER)
> +		mi->dqi_bgrace = ii->i_spc_timelimit;
> +	if (ii->i_fieldmask & QC_INO_TIMER)
> +		mi->dqi_igrace = ii->i_ino_timelimit;
> +	if (ii->i_fieldmask & QC_FLAGS) {
> +		if (ii->i_flags & QCI_ROOT_SQUASH)
> +			mi->dqi_flags |= DQF_ROOT_SQUASH;
> +		else
> +			mi->dqi_flags &= ~DQF_ROOT_SQUASH;
> +	}
>  	spin_unlock(&dq_data_lock);
>  	mark_info_dirty(sb, type);
>  	/* Force write to disk */
> diff --git a/fs/quota/quota.c b/fs/quota/quota.c
> index 20d11cd21247..741d5a178268 100644
> --- a/fs/quota/quota.c
> +++ b/fs/quota/quota.c
> @@ -149,12 +149,31 @@ static int quota_getinfo(struct super_block *sb, int type, void __user *addr)
>  static int quota_setinfo(struct super_block *sb, int type, void __user *addr)
>  {
>  	struct if_dqinfo info;
> +	struct qc_info qinfo;
>  
>  	if (copy_from_user(&info, addr, sizeof(info)))
>  		return -EFAULT;
>  	if (!sb->s_qcop->set_info)
>  		return -ENOSYS;
> -	return sb->s_qcop->set_info(sb, type, &info);
> +	if (info.dqi_valid & ~(IIF_FLAGS | IIF_BGRACE | IIF_IGRACE))
> +		return -EINVAL;
> +	memset(&qinfo, 0, sizeof(qinfo));
> +	if (info.dqi_valid & IIF_FLAGS) {
> +		if (info.dqi_flags & ~DQF_SETINFO_MASK)
> +			return -EINVAL;
> +		if (info.dqi_flags & DQF_ROOT_SQUASH)
> +			qinfo.i_flags |= QCI_ROOT_SQUASH;
> +		qinfo.i_fieldmask |= QC_FLAGS;
> +	}
> +	if (info.dqi_valid & IIF_BGRACE) {
> +		qinfo.i_spc_timelimit = info.dqi_bgrace;
> +		qinfo.i_fieldmask |= QC_SPC_TIMER;
> +	}
> +	if (info.dqi_valid & IIF_IGRACE) {
> +		qinfo.i_ino_timelimit = info.dqi_igrace;
> +		qinfo.i_fieldmask |= QC_INO_TIMER;
> +	}
> +	return sb->s_qcop->set_info(sb, type, &qinfo);
>  }
>  
>  static inline qsize_t qbtos(qsize_t blocks)
> diff --git a/include/linux/quota.h b/include/linux/quota.h
> index a07f2ed25284..3d521199a0bd 100644
> --- a/include/linux/quota.h
> +++ b/include/linux/quota.h
> @@ -344,7 +344,10 @@ struct qc_dqblk {
>  	int d_rt_spc_warns;	/* # warnings issued wrt RT space */
>  };
>  
> -/* Field specifiers for ->set_dqblk() in struct qc_dqblk */
> +/*
> + * Field specifiers for ->set_dqblk() in struct qc_dqblk and also for
> + * ->set_info() in struct qc_info
> + */
>  #define	QC_INO_SOFT	(1<<0)
>  #define	QC_INO_HARD	(1<<1)
>  #define	QC_SPC_SOFT	(1<<2)
> @@ -365,6 +368,7 @@ struct qc_dqblk {
>  #define	QC_INO_COUNT	(1<<13)
>  #define	QC_RT_SPACE	(1<<14)
>  #define QC_ACCT_MASK (QC_SPACE | QC_INO_COUNT | QC_RT_SPACE)
> +#define QC_FLAGS	(1<<15)
>  
>  #define QCI_SYSFILE		(1 << 0)	/* Quota file is hidden from userspace */
>  #define QCI_ROOT_SQUASH		(1 << 1)	/* Root squash turned on */
> @@ -397,6 +401,19 @@ struct qc_state {
>  	struct qc_type_state s_state[XQM_MAXQUOTAS];
>  };
>  
> +/* Structure for communicating via ->set_info */
> +struct qc_info {
> +	int i_fieldmask;	/* mask of fields to change in ->set_info() */
> +	unsigned int i_flags;		/* Flags QCI_* */
> +	unsigned int i_spc_timelimit;	/* Time after which space softlimit is
> +					 * enforced */
> +	unsigned int i_ino_timelimit;	/* Ditto for inode softlimit */
> +	unsigned int i_rt_spc_timelimit;/* Ditto for real-time space */
> +	unsigned int i_spc_warnlimit;	/* Limit for number of space warnings */
> +	unsigned int i_ino_warnlimit;	/* Limit for number of inode warnings */
> +	unsigned int i_rt_spc_warnlimit;	/* Ditto for real-time space */
> +};

What does the i_ prefix stand for?

Otherwise this looks fine to me.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
