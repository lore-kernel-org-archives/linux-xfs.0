Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n5CFvoV3213006 for <xfs@oss.sgi.com>; Fri, 12 Jun 2009 10:57:50 -0500
Received: from estes.americas.sgi.com (estes.americas.sgi.com [128.162.236.10])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 84FB2AC052
	for <xfs@oss.sgi.com>; Fri, 12 Jun 2009 08:58:12 -0700 (PDT)
Message-Id: <D4FF9629-769D-494D-BECE-3585EDE6A22E@sgi.com>
From: Felix Blyakher <felixb@sgi.com>
In-Reply-To: <20090612153454.GA26477@infradead.org>
Mime-Version: 1.0 (Apple Message framework v926)
Subject: Re: [PATCH] xfs: fix warnings with CONFIG_XFS_QUOTA disabled
Date: Fri, 12 Jun 2009 10:58:12 -0500
References: <20090612153454.GA26477@infradead.org>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"; DelSp="yes"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com


On Jun 12, 2009, at 10:34 AM, Christoph Hellwig wrote:

> Fix warnings about unitialized dquot variables by making sure
> xfs_qm_vop_dqalloc touches it even when quotas are disabled.
>
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Felix Blyakher <felixb@sgi.com>

>
>
> Index: xfs/fs/xfs/xfs_quota.h
> ===================================================================
> --- xfs.orig/fs/xfs/xfs_quota.h	2009-06-12 17:22:24.925939716 +0200
> +++ xfs/fs/xfs/xfs_quota.h	2009-06-12 17:27:47.253814811 +0200
> @@ -335,6 +335,14 @@ extern void xfs_qm_unmount(struct xfs_mo
> extern void xfs_qm_unmount_quotas(struct xfs_mount *);
>
> #else
> +static inline int
> +xfs_qm_vop_dqalloc(struct xfs_inode *ip, uid_t uid, gid_t gid,  
> prid_t prid,
> +		uint flags, struct xfs_dquot **udqp, struct xfs_dquot **gdqp)
> +{
> +	*udqp = NULL;
> +	*gdqp = NULL;
> +	return 0;
> +}
> #define xfs_trans_dup_dqinfo(tp, tp2)
> #define xfs_trans_free_dqinfo(tp)
> #define xfs_trans_mod_dquot_byino(tp, ip, fields, delta)
> @@ -342,7 +350,6 @@ extern void xfs_qm_unmount_quotas(struct
> #define xfs_trans_unreserve_and_mod_dquots(tp)
> #define xfs_trans_reserve_quota_nblks(tp, ip, nblks, ninos, flags)	(0)
> #define xfs_trans_reserve_quota_bydquots(tp, mp, u, g, nb, ni, fl)	(0)
> -#define xfs_qm_vop_dqalloc(ip, uid, gid, prid, fl, ou, og)		(0)
> #define xfs_qm_vop_create_dqattach(tp, ip, u, g)
> #define xfs_qm_vop_rename_dqattach(it)					(0)
> #define xfs_qm_vop_chown(tp, ip, old, new)				(NULL)
>
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
