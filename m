Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 4A4507FB5
	for <xfs@oss.sgi.com>; Fri, 10 Oct 2014 10:27:35 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 35F68304067
	for <xfs@oss.sgi.com>; Fri, 10 Oct 2014 08:27:35 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id a6pwEFIwQWFItWnv (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 10 Oct 2014 08:27:33 -0700 (PDT)
Message-ID: <5437FAB1.1010005@oracle.com>
Date: Fri, 10 Oct 2014 10:26:41 -0500
From: Dave Kleikamp <dave.kleikamp@oracle.com>
MIME-Version: 1.0
Subject: Re: [PATCH 01/12] quota: Allow each filesystem to specify which quota
	types it supports
References: <1412952910-7142-1-git-send-email-jack@suse.cz>
	<1412952910-7142-2-git-send-email-jack@suse.cz>
In-Reply-To: <1412952910-7142-2-git-send-email-jack@suse.cz>
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
To: Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org
Cc: Dave Kleikamp <shaggy@kernel.org>, jfs-discussion@lists.sourceforge.net, tytso@mit.edu, Jeff Mahoney <jeffm@suse.de>, Mark Fasheh <mfasheh@suse.com>, reiserfs-devel@vger.kernel.org, xfs@oss.sgi.com, cluster-devel@redhat.com, Joel Becker <jlbec@evilplan.org>, linux-ext4@vger.kernel.org, Steven Whitehouse <swhiteho@redhat.com>, ocfs2-devel@oss.oracle.com, viro@zeniv.linux.org.uk

On 10/10/2014 09:54 AM, Jan Kara wrote:
> Currently all filesystems supporting VFS quota support user and group
> quotas. With introduction of project quotas this is going to change so
> make sure filesystem isn't called for quota type it doesn't support by
> introduction of a bitmask determining which quota types each filesystem
> supports.
> 
> Signed-off-by: Jan Kara <jack@suse.cz>
> ---
>  fs/quota/quota.c      | 13 +++++++++++--
>  fs/super.c            |  7 +++++++
>  include/linux/quota.h |  6 ++++++
>  3 files changed, 24 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/quota/quota.c b/fs/quota/quota.c
> index 75621649dbd7..0f28eac6e638 100644
> --- a/fs/quota/quota.c
> +++ b/fs/quota/quota.c
> @@ -47,8 +47,11 @@ static int check_quotactl_permission(struct super_block *sb, int type, int cmd,
>  
>  static void quota_sync_one(struct super_block *sb, void *arg)
>  {
> -	if (sb->s_qcop && sb->s_qcop->quota_sync)
> -		sb->s_qcop->quota_sync(sb, *(int *)arg);
> +	int type = *(int *)arg;
> +
> +	if (sb->s_qcop && sb->s_qcop->quota_sync &&
> +	    (sb->s_dquot.allowed_types & (1 << type)))
> +		sb->s_qcop->quota_sync(sb, type);
>  }
>  
>  static int quota_sync_all(int type)
> @@ -297,8 +300,14 @@ static int do_quotactl(struct super_block *sb, int type, int cmd, qid_t id,
>  
>  	if (type >= (XQM_COMMAND(cmd) ? XQM_MAXQUOTAS : MAXQUOTAS))
>  		return -EINVAL;
> +	/*
> +	 * Quota not supported on this fs? Check this before allowed_types
> +	 * since they needn't be set if quota is not supported.
> +	 */
>  	if (!sb->s_qcop)
>  		return -ENOSYS;
> +	if (!(sb->s_dquot.allowed_types & (1 << type)))
> +		return -EINVAL;
>  
>  	ret = check_quotactl_permission(sb, type, cmd, id);
>  	if (ret < 0)
> diff --git a/fs/super.c b/fs/super.c
> index b9a214d2fe98..c6c9b2de9e31 100644
> --- a/fs/super.c
> +++ b/fs/super.c
> @@ -215,6 +215,13 @@ static struct super_block *alloc_super(struct file_system_type *type, int flags)
>  	atomic_set(&s->s_active, 1);
>  	mutex_init(&s->s_vfs_rename_mutex);
>  	lockdep_set_class(&s->s_vfs_rename_mutex, &type->s_vfs_rename_key);
> +	/*
> +	 * For now MAXQUOTAS check in do_quotactl() will limit quota type
> +	 * appropriately. When each fs sets allowed_types, we can remove the
> +	 * line below
> +	 */
> +	s->s_dquot.allowed_types = QTYPE_MASK_USR | QTYPE_MASK_GRP |
> +				   QTYPE_MASK_PRJ;
>  	mutex_init(&s->s_dquot.dqio_mutex);
>  	mutex_init(&s->s_dquot.dqonoff_mutex);
>  	s->s_maxbytes = MAX_NON_LFS;
> diff --git a/include/linux/quota.h b/include/linux/quota.h
> index 80d345a3524c..b52539f42e19 100644
> --- a/include/linux/quota.h
> +++ b/include/linux/quota.h
> @@ -56,6 +56,11 @@ enum quota_type {
>  	PRJQUOTA = 2,		/* element used for project quotas */
>  };
>  
> +/* Masks for quota types when used as a bitmask */
> +#define QTYPE_MASK_USER (1 << USRQUOTA)
> +#define QTYPE_MASK_GROUP (1 << GRPQUOTA)
> +#define QTYPE_MASK_PROJECT (1 << PRJQUOTA)

The uses of these masks use the names QTYPE_MASK_USR, QTYPE_MASK_GRP,
and QTYPE_MASK_PRJ

> +
>  typedef __kernel_uid32_t qid_t; /* Type in which we store ids in memory */
>  typedef long long qsize_t;	/* Type in which we store sizes */
>  
> @@ -388,6 +393,7 @@ static inline void quota_send_warning(struct kqid qid, dev_t dev,
>  
>  struct quota_info {
>  	unsigned int flags;			/* Flags for diskquotas on this device */
> +	unsigned int allowed_types;		/* Bitmask of quota types this fs supports */
>  	struct mutex dqio_mutex;		/* lock device while I/O in progress */
>  	struct mutex dqonoff_mutex;		/* Serialize quotaon & quotaoff */
>  	struct inode *files[MAXQUOTAS];		/* inodes of quotafiles */
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
