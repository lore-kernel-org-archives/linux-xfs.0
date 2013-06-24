Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 1CFBF7F37
	for <xfs@oss.sgi.com>; Mon, 24 Jun 2013 00:32:04 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 0A5778F8037
	for <xfs@oss.sgi.com>; Sun, 23 Jun 2013 22:32:03 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	A2qOKNeyEKb60VhD for <xfs@oss.sgi.com>;
	Sun, 23 Jun 2013 22:31:59 -0700 (PDT)
Date: Mon, 24 Jun 2013 15:31:54 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v9 1/6] xfs: Move code around and remove typedefs
Message-ID: <20130624053154.GL29376@dastard>
References: <1372042107-27332-1-git-send-email-sekharan@us.ibm.com>
	<1372042107-27332-2-git-send-email-sekharan@us.ibm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1372042107-27332-2-git-send-email-sekharan@us.ibm.com>
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
To: Chandra Seetharaman <sekharan@us.ibm.com>
Cc: xfs@oss.sgi.com

On Sun, Jun 23, 2013 at 09:48:22PM -0500, Chandra Seetharaman wrote:
> Removed some typedefs, defined new functions, made some code clean up all in
> preparation of the series.
> 
> No functional changes.

This does a lot of different stuff. Can you separate out the actual
factoring changes (e.g. xfs_is_quota_inode() and xfs_dquot_tree())
into separate patches, and the same with the struct xfs_dquot_acct
as it changes both logic and structure...

> diff --git a/fs/xfs/xfs_qm.h b/fs/xfs/xfs_qm.h
> index 5d16a6e..4b330f2 100644
> --- a/fs/xfs/xfs_qm.h
> +++ b/fs/xfs/xfs_qm.h
> @@ -42,57 +42,89 @@ extern struct kmem_zone	*xfs_qm_dqtrxzone;
>   * The mount structure keeps a pointer to this.
>   */
>  typedef struct xfs_quotainfo {
> -	struct radix_tree_root qi_uquota_tree;
> -	struct radix_tree_root qi_gquota_tree;
> -	struct mutex qi_tree_lock;
> -	xfs_inode_t	*qi_uquotaip;	 /* user quota inode */
> -	xfs_inode_t	*qi_gquotaip;	 /* group quota inode */
> -	struct list_head qi_lru_list;
> -	struct mutex	 qi_lru_lock;
> -	int		 qi_lru_count;
> -	int		 qi_dquots;
> -	time_t		 qi_btimelimit;	 /* limit for blks timer */
> -	time_t		 qi_itimelimit;	 /* limit for inodes timer */
> -	time_t		 qi_rtbtimelimit;/* limit for rt blks timer */
> -	xfs_qwarncnt_t	 qi_bwarnlimit;	 /* limit for blks warnings */
> -	xfs_qwarncnt_t	 qi_iwarnlimit;	 /* limit for inodes warnings */
> -	xfs_qwarncnt_t	 qi_rtbwarnlimit;/* limit for rt blks warnings */
> -	struct mutex	 qi_quotaofflock;/* to serialize quotaoff */
> -	xfs_filblks_t	 qi_dqchunklen;	 /* # BBs in a chunk of dqs */
> -	uint		 qi_dqperchunk;	 /* # ondisk dqs in above chunk */
> -	xfs_qcnt_t	 qi_bhardlimit;	 /* default data blk hard limit */
> -	xfs_qcnt_t	 qi_bsoftlimit;	 /* default data blk soft limit */
> -	xfs_qcnt_t	 qi_ihardlimit;	 /* default inode count hard limit */
> -	xfs_qcnt_t	 qi_isoftlimit;	 /* default inode count soft limit */
> -	xfs_qcnt_t	 qi_rtbhardlimit;/* default realtime blk hard limit */
> -	xfs_qcnt_t	 qi_rtbsoftlimit;/* default realtime blk soft limit */
> -	struct shrinker  qi_shrinker;
> +	struct radix_tree_root	qi_uquota_tree;
> +	struct radix_tree_root	qi_gquota_tree;
> +	struct mutex		qi_tree_lock;
> +	struct xfs_inode	*qi_uquotaip;	 /* user quota inode */
> +	struct xfs_inode	*qi_gquotaip;	 /* group quota inode */
> +	struct list_head	qi_lru_list;
> +	struct mutex		qi_lru_lock;
> +	int		qi_lru_count;
> +	int		qi_dquots;
> +	time_t		qi_btimelimit;	 /* limit for blks timer */
> +	time_t		qi_itimelimit;	 /* limit for inodes timer */
> +	time_t		qi_rtbtimelimit;/* limit for rt blks timer */
> +	xfs_qwarncnt_t	qi_bwarnlimit;	 /* limit for blks warnings */
> +	xfs_qwarncnt_t	qi_iwarnlimit;	 /* limit for inodes warnings */
> +	xfs_qwarncnt_t	qi_rtbwarnlimit;/* limit for rt blks warnings */
> +	struct mutex	qi_quotaofflock;/* to serialize quotaoff */
> +	xfs_filblks_t	qi_dqchunklen;	 /* # BBs in a chunk of dqs */
> +	uint		qi_dqperchunk;	 /* # ondisk dqs in above chunk */
> +	xfs_qcnt_t	qi_bhardlimit;	 /* default data blk hard limit */
> +	xfs_qcnt_t	qi_bsoftlimit;	 /* default data blk soft limit */
> +	xfs_qcnt_t	qi_ihardlimit;	 /* default inode count hard limit */
> +	xfs_qcnt_t	qi_isoftlimit;	 /* default inode count soft limit */
> +	xfs_qcnt_t	qi_rtbhardlimit;/* default realtime blk hard limit */
> +	xfs_qcnt_t	qi_rtbsoftlimit;/* default realtime blk soft limit */
> +	struct shrinker	qi_shrinker;
>  } xfs_quotainfo_t;

I don't see much point in random whitespace cleanups like this. If
you are going to change them, at least clean it up properly, so all
variables are aligned, and all the comments are aligned as well. In
most cases, the comments are redundant because the variable names
are very descriptive and so probably could be removed....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
