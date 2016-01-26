Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 547327CA2
	for <xfs@oss.sgi.com>; Tue, 26 Jan 2016 06:57:03 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 322AB304059
	for <xfs@oss.sgi.com>; Tue, 26 Jan 2016 04:57:03 -0800 (PST)
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15]) by cuda.sgi.com with
	ESMTP id 3HQiuBO9z51e2SJG (version=TLSv1
	cipher=ECDHE-RSA-AES256-SHA bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 26 Jan 2016 04:57:01 -0800 (PST)
Date: Tue, 26 Jan 2016 13:57:10 +0100
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 2/7] quota: add new quotactl Q_XGETNEXTQUOTA
Message-ID: <20160126125710.GA23820@quack.suse.cz>
References: <1453487136-12681-1-git-send-email-sandeen@redhat.com>
	<1453487136-12681-3-git-send-email-sandeen@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1453487136-12681-3-git-send-email-sandeen@redhat.com>
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
To: Eric Sandeen <sandeen@redhat.com>
Cc: linux-fsdevel@vger.kernel.org, jack@suse.cz, xfs@oss.sgi.com

On Fri 22-01-16 12:25:31, Eric Sandeen wrote:
> Q_XGETNEXTQUOTA is exactly like Q_XGETQUOTA, except that it
> will return quota information for the id equal to or greater
> than the id requested.  In other words, if the requested id has
> no quota, the command will return quota information for the
> next higher id which does have a quota set.  If no higher id
> has an active quota, -ESRCH is returned.

Actually, is -ESRCH the right return value? It seems XFS traditionally
returns -ENOENT when id doesn't exist. So that would look more logical to
me.

								Honza

> This allows filesystems to do efficient iteration in kernelspace,
> much like extN filesystems do in userspace when asked to report
> all active quotas.
> 
> The patch adds a d_id field to struct qc_dqblk so that we can
> pass back the id of the quota which was found, and return it
> to userspace.
> 
> Today, filesystems such as XFS require getpwent-style iterations,
> and for systems which have i.e. LDAP backends, this can be very
> slow, or even impossible if iteration is not allowed in the
> configuration.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
>  fs/quota/quota.c               |   31 +++++++++++++++++++++++++++++++
>  include/linux/quota.h          |    2 ++
>  include/uapi/linux/dqblk_xfs.h |    1 +
>  3 files changed, 34 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/quota/quota.c b/fs/quota/quota.c
> index ea66670..0a6dd71 100644
> --- a/fs/quota/quota.c
> +++ b/fs/quota/quota.c
> @@ -625,6 +625,34 @@ static int quota_getxquota(struct super_block *sb, int type, qid_t id,
>  	return ret;
>  }
>  
> +/*
> + * Return quota for next active quota >= this id, if any exists,
> + * otherwise return -ESRCH via ->get_nextdqblk.
> + */
> +static int quota_getnextxquota(struct super_block *sb, int type, qid_t id,
> +			    void __user *addr)
> +{
> +	struct fs_disk_quota fdq;
> +	struct qc_dqblk qdq;
> +	struct kqid qid;
> +	qid_t id_out;
> +	int ret;
> +
> +	if (!sb->s_qcop->get_nextdqblk)
> +		return -ENOSYS;
> +	qid = make_kqid(current_user_ns(), type, id);
> +	if (!qid_valid(qid))
> +		return -EINVAL;
> +	ret = sb->s_qcop->get_nextdqblk(sb, &qid, &qdq);
> +	if (ret)
> +		return ret;
> +	id_out = from_kqid(current_user_ns(), qid);
> +	copy_to_xfs_dqblk(&fdq, &qdq, type, id_out);
> +	if (copy_to_user(addr, &fdq, sizeof(fdq)))
> +		return -EFAULT;
> +	return ret;
> +}
> +
>  static int quota_rmxquota(struct super_block *sb, void __user *addr)
>  {
>  	__u32 flags;
> @@ -690,6 +718,8 @@ static int do_quotactl(struct super_block *sb, int type, int cmd, qid_t id,
>  		return quota_setxquota(sb, type, id, addr);
>  	case Q_XGETQUOTA:
>  		return quota_getxquota(sb, type, id, addr);
> +	case Q_XGETNEXTQUOTA:
> +		return quota_getnextxquota(sb, type, id, addr);
>  	case Q_XQUOTASYNC:
>  		if (sb->s_flags & MS_RDONLY)
>  			return -EROFS;
> @@ -712,6 +742,7 @@ static int quotactl_cmd_write(int cmd)
>  	case Q_XGETQSTAT:
>  	case Q_XGETQSTATV:
>  	case Q_XGETQUOTA:
> +	case Q_XGETNEXTQUOTA:
>  	case Q_XQUOTASYNC:
>  		return 0;
>  	}
> diff --git a/include/linux/quota.h b/include/linux/quota.h
> index b2505ac..fba92f5 100644
> --- a/include/linux/quota.h
> +++ b/include/linux/quota.h
> @@ -425,6 +425,8 @@ struct quotactl_ops {
>  	int (*quota_sync)(struct super_block *, int);
>  	int (*set_info)(struct super_block *, int, struct qc_info *);
>  	int (*get_dqblk)(struct super_block *, struct kqid, struct qc_dqblk *);
> +	int (*get_nextdqblk)(struct super_block *, struct kqid *,
> +			     struct qc_dqblk *);
>  	int (*set_dqblk)(struct super_block *, struct kqid, struct qc_dqblk *);
>  	int (*get_state)(struct super_block *, struct qc_state *);
>  	int (*rm_xquota)(struct super_block *, unsigned int);
> diff --git a/include/uapi/linux/dqblk_xfs.h b/include/uapi/linux/dqblk_xfs.h
> index dcd75cc..11b3b31 100644
> --- a/include/uapi/linux/dqblk_xfs.h
> +++ b/include/uapi/linux/dqblk_xfs.h
> @@ -39,6 +39,7 @@
>  #define Q_XQUOTARM	XQM_CMD(6)	/* free disk space used by dquots */
>  #define Q_XQUOTASYNC	XQM_CMD(7)	/* delalloc flush, updates dquots */
>  #define Q_XGETQSTATV	XQM_CMD(8)	/* newer version of get quota */
> +#define Q_XGETNEXTQUOTA	XQM_CMD(9)	/* get disk limits and usage >= ID */
>  
>  /*
>   * fs_disk_quota structure:
> -- 
> 1.7.1
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
