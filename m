Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 89E697F3F
	for <xfs@oss.sgi.com>; Fri, 17 Oct 2014 14:24:41 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 27855AC007
	for <xfs@oss.sgi.com>; Fri, 17 Oct 2014 12:24:37 -0700 (PDT)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id tHcicF8tVIdWcJcG (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 17 Oct 2014 12:24:34 -0700 (PDT)
Date: Fri, 17 Oct 2014 21:24:28 +0200
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 0/12 v2] Moving i_dquot out of struct inode
Message-ID: <20141017192428.GA19788@quack.suse.cz>
References: <1412952910-7142-1-git-send-email-jack@suse.cz>
	<20141011133452.GA29004@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20141011133452.GA29004@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: Dave Kleikamp <shaggy@kernel.org>, jfs-discussion@lists.sourceforge.net, Jan Kara <jack@suse.cz>, Jeff Mahoney <jeffm@suse.de>, Mark Fasheh <mfasheh@suse.com>, reiserfs-devel@vger.kernel.org, xfs@oss.sgi.com, cluster-devel@redhat.com, Joel Becker <jlbec@evilplan.org>, linux-fsdevel@vger.kernel.org, tytso@mit.edu, linux-ext4@vger.kernel.org, Steven Whitehouse <swhiteho@redhat.com>, ocfs2-devel@oss.oracle.com, viro@zeniv.linux.org.uk

On Sat 11-10-14 06:34:52, Christoph Hellwig wrote:
> I still very much disagree with the s_inode_fields indirection.  Please
> find a patch below to remove it, and use a get_dquots super_block
> operation instead.  This leads to less and better readable code,
> and serves 4 bytes in every inode in the system.  Additionally the
  I don't see the 4-bytes per inode saving, what am I missing? Frankly, I
don't see a difference in readability but since you and Al agree on that I
concede to your taste :)

> indirection could easily be optimized away by directly passing the
> dquot array in various functions, but for now I'd like to keep it
> simple.
  So after I wrote a patch to avoid the indirection in most places (we
cannot avoid it during quotaon and quotaoff but those are corner cases) I
also think it's better to leave it for a separate patch series. It's mostly
trivial but there's lot of churn when functions prototypes change, names
need to change, etc. and with that I'd probably do other cleanups of the
quota API towards filesystems (to somewhat reduce number of functions).

So I'll just change the patches to use the function call instead of
indirection table as you suggest.

								Honza
> 
> diff --git a/fs/ext2/super.c b/fs/ext2/super.c
> index 47d97af..c330e90 100644
> --- a/fs/ext2/super.c
> +++ b/fs/ext2/super.c
> @@ -307,6 +307,11 @@ static int ext2_show_options(struct seq_file *seq, struct dentry *root)
>  #ifdef CONFIG_QUOTA
>  static ssize_t ext2_quota_read(struct super_block *sb, int type, char *data, size_t len, loff_t off);
>  static ssize_t ext2_quota_write(struct super_block *sb, int type, const char *data, size_t len, loff_t off);
> +
> +static struct dquot **ext2_get_dquots(struct inode *inode)
> +{
> +	return EXT2_I(inode)->i_dquot;
> +}
>  #endif
>  
>  static const struct super_operations ext2_sops = {
> @@ -324,13 +329,7 @@ static const struct super_operations ext2_sops = {
>  #ifdef CONFIG_QUOTA
>  	.quota_read	= ext2_quota_read,
>  	.quota_write	= ext2_quota_write,
> -#endif
> -};
> -
> -static const int ext2_inode_fields[IF_FIELD_NR] = {
> -#ifdef CONFIG_QUOTA
> -	[IF_DQUOTS] = offsetof(struct ext2_inode_info, i_dquot) -
> -		      offsetof(struct ext2_inode_info, vfs_inode),
> +	.get_dquots	= ext2_get_dquots,
>  #endif
>  };
>  
> @@ -1103,7 +1102,6 @@ static int ext2_fill_super(struct super_block *sb, void *data, int silent)
>  	sb->s_qcop = &dquot_quotactl_ops;
>  	sb_dqopt(sb)->allowed_types = QTYPE_MASK_USR | QTYPE_MASK_GRP;
>  #endif
> -	sb_init_inode_fields(sb, ext2_inode_fields);
>  
>  	root = ext2_iget(sb, EXT2_ROOT_INO);
>  	if (IS_ERR(root)) {
> diff --git a/fs/ext3/super.c b/fs/ext3/super.c
> index 9e15262..9ca145d 100644
> --- a/fs/ext3/super.c
> +++ b/fs/ext3/super.c
> @@ -769,6 +769,11 @@ static ssize_t ext3_quota_read(struct super_block *sb, int type, char *data,
>  static ssize_t ext3_quota_write(struct super_block *sb, int type,
>  				const char *data, size_t len, loff_t off);
>  
> +static struct dquot **ext3_get_dquots(struct inode *inode)
> +{
> +	return EXT3_I(inode)->i_dquot;
> +}
> +
>  static const struct dquot_operations ext3_quota_operations = {
>  	.write_dquot	= ext3_write_dquot,
>  	.acquire_dquot	= ext3_acquire_dquot,
> @@ -807,17 +812,11 @@ static const struct super_operations ext3_sops = {
>  #ifdef CONFIG_QUOTA
>  	.quota_read	= ext3_quota_read,
>  	.quota_write	= ext3_quota_write,
> +	.get_dquots	= ext3_get_dquots,
>  #endif
>  	.bdev_try_to_free_page = bdev_try_to_free_page,
>  };
>  
> -static const int ext3_inode_fields[IF_FIELD_NR] = {
> -#ifdef CONFIG_QUOTA
> -	[IF_DQUOTS] = (int)offsetof(struct ext3_inode_info, i_dquot) -
> -		      (int)offsetof(struct ext3_inode_info, vfs_inode),
> -#endif
> -};
> -
>  static const struct export_operations ext3_export_ops = {
>  	.fh_to_dentry = ext3_fh_to_dentry,
>  	.fh_to_parent = ext3_fh_to_parent,
> @@ -2021,7 +2020,6 @@ static int ext3_fill_super (struct super_block *sb, void *data, int silent)
>  	sb->dq_op = &ext3_quota_operations;
>  	sb_dqopt(sb)->allowed_types = QTYPE_MASK_USR | QTYPE_MASK_GRP;
>  #endif
> -	sb_init_inode_fields(sb, ext3_inode_fields);
>  	memcpy(sb->s_uuid, es->s_uuid, sizeof(es->s_uuid));
>  	INIT_LIST_HEAD(&sbi->s_orphan); /* unlinked but open files */
>  	mutex_init(&sbi->s_orphan_lock);
> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> index ceac3c1..f7d4332 100644
> --- a/fs/ext4/super.c
> +++ b/fs/ext4/super.c
> @@ -1072,6 +1072,11 @@ static int ext4_quota_enable(struct super_block *sb, int type, int format_id,
>  			     unsigned int flags);
>  static int ext4_enable_quotas(struct super_block *sb);
>  
> +static struct dquot **ext4_get_dquots(struct inode *inode)
> +{
> +	return EXT4_I(inode)->i_dquot;
> +}
> +
>  static const struct dquot_operations ext4_quota_operations = {
>  	.get_reserved_space = ext4_get_reserved_space,
>  	.write_dquot	= ext4_write_dquot,
> @@ -1140,17 +1145,11 @@ static const struct super_operations ext4_nojournal_sops = {
>  #ifdef CONFIG_QUOTA
>  	.quota_read	= ext4_quota_read,
>  	.quota_write	= ext4_quota_write,
> +	.get_dquots	= ext4_get_dquots,
>  #endif
>  	.bdev_try_to_free_page = bdev_try_to_free_page,
>  };
>  
> -static const int ext4_inode_fields[IF_FIELD_NR] = {
> -#ifdef CONFIG_QUOTA
> -	[IF_DQUOTS] = offsetof(struct ext4_inode_info, i_dquot) -
> -		      offsetof(struct ext4_inode_info, vfs_inode),
> -#endif
> -};
> -
>  static const struct export_operations ext4_export_ops = {
>  	.fh_to_dentry = ext4_fh_to_dentry,
>  	.fh_to_parent = ext4_fh_to_parent,
> @@ -3926,7 +3925,6 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
>  		sb->s_qcop = &ext4_qctl_operations;
>  	sb_dqopt(sb)->allowed_types = QTYPE_MASK_USR | QTYPE_MASK_GRP;
>  #endif
> -	sb_init_inode_fields(sb, ext4_inode_fields);
>  	memcpy(sb->s_uuid, es->s_uuid, sizeof(es->s_uuid));
>  
>  	INIT_LIST_HEAD(&sbi->s_orphan); /* unlinked but open files */
> diff --git a/fs/jfs/super.c b/fs/jfs/super.c
> index a13727d..a7b0447 100644
> --- a/fs/jfs/super.c
> +++ b/fs/jfs/super.c
> @@ -54,7 +54,6 @@ static struct kmem_cache *jfs_inode_cachep;
>  
>  static const struct super_operations jfs_super_operations;
>  static const struct export_operations jfs_export_operations;
> -static const int jfs_inode_fields[IF_FIELD_NR];
>  static struct file_system_type jfs_fs_type;
>  
>  #define MAX_COMMIT_THREADS 64
> @@ -543,7 +542,6 @@ static int jfs_fill_super(struct super_block *sb, void *data, int silent)
>  	sb->s_qcop = &dquot_quotactl_ops;
>  	sb_dqopt(sb)->allowed_types = QTYPE_MASK_USR | QTYPE_MASK_GRP;
>  #endif
> -	sb_init_inode_fields(sb, jfs_inode_fields);
>  
>  	/*
>  	 * Initialize direct-mapping inode/address-space
> @@ -842,6 +840,10 @@ out:
>  	return len - towrite;
>  }
>  
> +static struct dquot **jfs_get_dquots(struct inode *inode)
> +{
> +	return JFS_IP(inode)->i_dquot;
> +}
>  #endif
>  
>  static const struct super_operations jfs_super_operations = {
> @@ -860,13 +862,7 @@ static const struct super_operations jfs_super_operations = {
>  #ifdef CONFIG_QUOTA
>  	.quota_read	= jfs_quota_read,
>  	.quota_write	= jfs_quota_write,
> -#endif
> -};
> -
> -static const int jfs_inode_fields[IF_FIELD_NR] = {
> -#ifdef CONFIG_QUOTA
> -	[IF_DQUOTS] = (int)offsetof(struct jfs_inode_info, i_dquot) -
> -		      (int)offsetof(struct jfs_inode_info, vfs_inode),
> +	.get_dquots	= jfs_get_dquots,
>  #endif
>  };
>  
> diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
> index 5d94b9a..c575bab 100644
> --- a/fs/ocfs2/super.c
> +++ b/fs/ocfs2/super.c
> @@ -143,6 +143,11 @@ static int ocfs2_susp_quotas(struct ocfs2_super *osb, int unsuspend);
>  static int ocfs2_enable_quotas(struct ocfs2_super *osb);
>  static void ocfs2_disable_quotas(struct ocfs2_super *osb);
>  
> +static struct dquot **ocfs2_get_dquots(struct inode *inode)
> +{
> +	return OCFS2_I(inode)->i_dquot;
> +}
> +
>  static const struct super_operations ocfs2_sops = {
>  	.statfs		= ocfs2_statfs,
>  	.alloc_inode	= ocfs2_alloc_inode,
> @@ -155,13 +160,7 @@ static const struct super_operations ocfs2_sops = {
>  	.show_options   = ocfs2_show_options,
>  	.quota_read	= ocfs2_quota_read,
>  	.quota_write	= ocfs2_quota_write,
> -};
> -
> -static const int ocfs2_inode_fields[IF_FIELD_NR] = {
> -#ifdef CONFIG_QUOTA
> -	[IF_DQUOTS] = offsetof(struct ocfs2_inode_info, i_dquot) -
> -		      offsetof(struct ocfs2_inode_info, vfs_inode),
> -#endif
> +	.get_dquots	= ocfs2_get_dquots,
>  };
>  
>  enum {
> @@ -2081,7 +2080,6 @@ static int ocfs2_initialize_super(struct super_block *sb,
>  	sb->dq_op = &ocfs2_quota_operations;
>  	sb_dqopt(sb)->allowed_types = QTYPE_MASK_USR | QTYPE_MASK_GRP;
>  	sb->s_xattr = ocfs2_xattr_handlers;
> -	sb_init_inode_fields(sb, ocfs2_inode_fields);
>  	sb->s_time_gran = 1;
>  	sb->s_flags |= MS_NOATIME;
>  	/* this is needed to support O_LARGEFILE */
> diff --git a/fs/quota/dquot.c b/fs/quota/dquot.c
> index ecb8732..b3af224 100644
> --- a/fs/quota/dquot.c
> +++ b/fs/quota/dquot.c
> @@ -893,9 +893,9 @@ out:
>  }
>  EXPORT_SYMBOL(dqget);
>  
> -static inline struct dquot **i_dquot(const struct inode *inode)
> +static inline struct dquot **i_dquot(struct inode *inode)
>  {
> -	return ((struct dquot **)inode_field(inode, IF_DQUOTS));
> +	return inode->i_sb->s_op->get_dquots(inode);
>  }
>  
>  static int dqinit_needed(struct inode *inode, int type)
> @@ -1648,7 +1648,7 @@ EXPORT_SYMBOL(__dquot_alloc_space);
>  /*
>   * This operation can block, but only after everything is updated
>   */
> -int dquot_alloc_inode(const struct inode *inode)
> +int dquot_alloc_inode(struct inode *inode)
>  {
>  	int cnt, ret = 0, index;
>  	struct dquot_warn warn[MAXQUOTAS];
> @@ -1789,7 +1789,7 @@ EXPORT_SYMBOL(__dquot_free_space);
>  /*
>   * This operation can block, but only after everything is updated
>   */
> -void dquot_free_inode(const struct inode *inode)
> +void dquot_free_inode(struct inode *inode)
>  {
>  	unsigned int cnt;
>  	struct dquot_warn warn[MAXQUOTAS];
> diff --git a/fs/reiserfs/super.c b/fs/reiserfs/super.c
> index 04babe5..72bdcc8 100644
> --- a/fs/reiserfs/super.c
> +++ b/fs/reiserfs/super.c
> @@ -754,6 +754,11 @@ static ssize_t reiserfs_quota_write(struct super_block *, int, const char *,
>  				    size_t, loff_t);
>  static ssize_t reiserfs_quota_read(struct super_block *, int, char *, size_t,
>  				   loff_t);
> +
> +static struct dquot **reiserfs_get_dquots(struct inode *inode)
> +{
> +	return REISERFS_I(inode)->i_dquot;
> +}
>  #endif
>  
>  static const struct super_operations reiserfs_sops = {
> @@ -772,13 +777,7 @@ static const struct super_operations reiserfs_sops = {
>  #ifdef CONFIG_QUOTA
>  	.quota_read = reiserfs_quota_read,
>  	.quota_write = reiserfs_quota_write,
> -#endif
> -};
> -
> -static const int reiserfs_inode_fields[IF_FIELD_NR] = {
> -#ifdef CONFIG_QUOTA
> -	[IF_DQUOTS] = (int)offsetof(struct reiserfs_inode_info, i_dquot) -
> -		      (int)offsetof(struct reiserfs_inode_info, vfs_inode),
> +	.get_dquots = reiserfs_get_dquots,
>  #endif
>  };
>  
> @@ -1646,7 +1645,6 @@ static int read_super_block(struct super_block *s, int offset)
>  	s->dq_op = &reiserfs_quota_operations;
>  	sb_dqopt(s)->allowed_types = QTYPE_MASK_USR | QTYPE_MASK_GRP;
>  #endif
> -	sb_init_inode_fields(s, reiserfs_inode_fields);
>  
>  	/*
>  	 * new format is limited by the 32 bit wide i_blocks field, want to
> diff --git a/include/linux/fs.h b/include/linux/fs.h
> index 6a801ca..3e1c596 100644
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -612,12 +612,6 @@ struct inode {
>  	void			*i_private; /* fs or device private pointer */
>  };
>  
> -/* Optional inode fields (stored in filesystems inode if the fs needs them) */
> -enum inode_fields {
> -	IF_DQUOTS,	/* Quota pointers: struct dquot *foo[MAXQUOTAS] */
> -	IF_FIELD_NR	/* Number of optional inode fields */
> -};
> -
>  static inline int inode_unhashed(struct inode *inode)
>  {
>  	return hlist_unhashed(&inode->i_hash);
> @@ -1239,11 +1233,6 @@ struct super_block {
>  	void 			*s_fs_info;	/* Filesystem private info */
>  	unsigned int		s_max_links;
>  	fmode_t			s_mode;
> -	/*
> -	 * We could have here just a pointer to the offsets array but this
> -	 * way we save one dereference when looking up field offsets
> -	 */
> -	int			s_inode_fields[IF_FIELD_NR];
>  
>  	/* Granularity of c/m/atime in ns.
>  	   Cannot be worse than a second */
> @@ -1294,24 +1283,6 @@ struct super_block {
>  	struct rcu_head		rcu;
>  };
>  
> -static inline void *inode_field(const struct inode *inode,
> -				enum inode_fields field)
> -{
> -	int offset;
> -
> -	BUG_ON(field >= IF_FIELD_NR);
> -	offset = inode->i_sb->s_inode_fields[field];
> -	if (!offset)	/* Field not present? */
> -		return NULL;
> -	return ((char *)inode) + offset;
> -}
> -
> -static inline void sb_init_inode_fields(struct super_block *sb,
> -					const int *fields)
> -{
> -	memcpy(sb->s_inode_fields, fields, sizeof(int) * IF_FIELD_NR);
> -}
> -
>  extern struct timespec current_fs_time(struct super_block *sb);
>  
>  /*
> @@ -1609,6 +1580,7 @@ struct super_operations {
>  #ifdef CONFIG_QUOTA
>  	ssize_t (*quota_read)(struct super_block *, int, char *, size_t, loff_t);
>  	ssize_t (*quota_write)(struct super_block *, int, const char *, size_t, loff_t);
> +	struct dquot **(*get_dquots)(struct inode *);
>  #endif
>  	int (*bdev_try_to_free_page)(struct super_block*, struct page*, gfp_t);
>  	long (*nr_cached_objects)(struct super_block *, int);
> diff --git a/include/linux/quotaops.h b/include/linux/quotaops.h
> index 1d3eee5..f23538a 100644
> --- a/include/linux/quotaops.h
> +++ b/include/linux/quotaops.h
> @@ -64,10 +64,10 @@ void dquot_destroy(struct dquot *dquot);
>  int __dquot_alloc_space(struct inode *inode, qsize_t number, int flags);
>  void __dquot_free_space(struct inode *inode, qsize_t number, int flags);
>  
> -int dquot_alloc_inode(const struct inode *inode);
> +int dquot_alloc_inode(struct inode *inode);
>  
>  int dquot_claim_space_nodirty(struct inode *inode, qsize_t number);
> -void dquot_free_inode(const struct inode *inode);
> +void dquot_free_inode(struct inode *inode);
>  void dquot_reclaim_space_nodirty(struct inode *inode, qsize_t number);
>  
>  int dquot_disable(struct super_block *sb, int type, unsigned int flags);
> @@ -213,12 +213,12 @@ static inline void dquot_drop(struct inode *inode)
>  {
>  }
>  
> -static inline int dquot_alloc_inode(const struct inode *inode)
> +static inline int dquot_alloc_inode(struct inode *inode)
>  {
>  	return 0;
>  }
>  
> -static inline void dquot_free_inode(const struct inode *inode)
> +static inline void dquot_free_inode(struct inode *inode)
>  {
>  }
>  
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
