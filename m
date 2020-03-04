Return-Path: <SRS0=37eZ=4V=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4732AC3F2D1
	for <linux-xfs@archiver.kernel.org>; Wed,  4 Mar 2020 23:40:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 077932084E
	for <linux-xfs@archiver.kernel.org>; Wed,  4 Mar 2020 23:40:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="qgeCZCTo"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388513AbgCDXkj (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 4 Mar 2020 18:40:39 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:47668 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388484AbgCDXkj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 4 Mar 2020 18:40:39 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 024NbxQI158166;
        Wed, 4 Mar 2020 23:40:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=tLihp0DOnoWYSdPuV/iZndtBQT/+loZk/O74YHDqm/w=;
 b=qgeCZCToOvbGA7kmCfhWhJGWzlUi28qtPSiPgWzqeaSNOuhRyjWD5vSK0y5qDyB8V/7f
 OaiJyx1o5smWN6MNp6rUN4iOZK63Jr7nK92u5q7fYW+aWNMV1/idyirEWDKuQNzE8qls
 yo58f86JOLswMAWVUlGqgzUMYdmgHQobkxIvJuRbf+capwMosTzbZyu++Bmy74zzgcKj
 fPUBRx376EWVMjNlNoCus3LldiYLmc52QswwchJROCZBA7NSYBuYbh3SRfCEGdzfybdq
 a6RPF17Gsh738eK/rAv0rppjCtyG4lrcdRYy3MPHEl2z6v764xPb+khP8+kUgHami2rl YA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 2yffcuspbn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 04 Mar 2020 23:40:35 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 024NbHDX075676;
        Wed, 4 Mar 2020 23:40:34 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 2yg1h1yabn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 04 Mar 2020 23:40:34 +0000
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 024NeXGD017087;
        Wed, 4 Mar 2020 23:40:33 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 04 Mar 2020 15:40:33 -0800
Date:   Wed, 4 Mar 2020 15:40:32 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     linux-xfs@vger.kernel.org, bfoster@redhat.com
Subject: Re: [PATCH 2/4] xfs: introduce fake roots for inode-rooted btrees
Message-ID: <20200304234032.GK8045@magnolia>
References: <158329250190.2423432.16958662769192587982.stgit@magnolia>
 <158329251457.2423432.3645127418803903567.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <158329251457.2423432.3645127418803903567.stgit@magnolia>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9550 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0
 suspectscore=2 malwarescore=0 mlxlogscore=999 mlxscore=0 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2003040150
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9550 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxscore=0 bulkscore=0
 adultscore=0 suspectscore=2 spamscore=0 malwarescore=0 impostorscore=0
 priorityscore=1501 mlxlogscore=999 lowpriorityscore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2003040150
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Mar 03, 2020 at 07:28:34PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Create an in-core fake root for inode-rooted btree types so that callers
> can generate a whole new btree using the upcoming btree bulk load
> function without making the new tree accessible from the rest of the
> filesystem.  It is up to the individual btree type to provide a function
> to create a staged cursor (presumably with the appropriate callouts to
> update the fakeroot) and then commit the staged root back into the
> filesystem.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/libxfs/xfs_btree.c |   82 +++++++++++++++++++++++++++++++++++++++++++--
>  fs/xfs/libxfs/xfs_btree.h |   52 ++++++++++++++++++++++++-----
>  fs/xfs/xfs_trace.h        |   33 ++++++++++++++++++
>  3 files changed, 154 insertions(+), 13 deletions(-)
> 
> 
> diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
> index 9a7c1a4d0423..469e1e9053bb 100644
> --- a/fs/xfs/libxfs/xfs_btree.c
> +++ b/fs/xfs/libxfs/xfs_btree.c
> @@ -644,6 +644,17 @@ xfs_btree_ptr_addr(
>  		((char *)block + xfs_btree_ptr_offset(cur, n, level));
>  }
>  
> +struct xfs_ifork *
> +xfs_btree_ifork_ptr(
> +	struct xfs_btree_cur	*cur)
> +{
> +	ASSERT(cur->bc_flags & XFS_BTREE_ROOT_IN_INODE);
> +
> +	if (cur->bc_flags & XFS_BTREE_STAGING)
> +		return cur->bc_private.b.ifake->if_fork;
> +	return XFS_IFORK_PTR(cur->bc_private.b.ip, cur->bc_private.b.whichfork);
> +}
> +
>  /*
>   * Get the root block which is stored in the inode.
>   *
> @@ -654,9 +665,8 @@ STATIC struct xfs_btree_block *
>  xfs_btree_get_iroot(
>  	struct xfs_btree_cur	*cur)
>  {
> -	struct xfs_ifork	*ifp;
> +	struct xfs_ifork	*ifp = xfs_btree_ifork_ptr(cur);
>  
> -	ifp = XFS_IFORK_PTR(cur->bc_private.b.ip, cur->bc_private.b.whichfork);
>  	return (struct xfs_btree_block *)ifp->if_broot;
>  }
>  
> @@ -4952,8 +4962,17 @@ xfs_btree_fakeroot_init_ptr_from_cur(
>  
>  	ASSERT(cur->bc_flags & XFS_BTREE_STAGING);
>  
> -	afake = cur->bc_private.a.afake;
> -	ptr->s = cpu_to_be32(afake->af_root);
> +	if (cur->bc_flags & XFS_BTREE_ROOT_IN_INODE) {
> +		/*
> +		 * The root block lives in the inode core, so we zero the
> +		 * pointer (like the bmbt code does) to make it obvious if
> +		 * anyone ever tries to use this pointer.
> +		 */
> +		ptr->l = cpu_to_be64(0);
> +	} else {
> +		afake = cur->bc_private.a.afake;
> +		ptr->s = cpu_to_be32(afake->af_root);
> +	}
>  }
>  
>  /* Set the root block when our tree has a fakeroot. */
> @@ -5025,3 +5044,58 @@ xfs_btree_commit_afakeroot(
>  	cur->bc_ops = ops;
>  	cur->bc_flags &= ~XFS_BTREE_STAGING;
>  }

Please add the following block comment here:

/*
 * Bulk Loading for Inode-Rooted Btrees
 * ====================================
 *
 * For a btree rooted in an inode fork, use an xbtree_ifakeroot
 * structure.  This structure should be initialized as follows:
 *
 * - if_fork_size field should be set to the number of bytes available
 *   to the fork in the inode.
 *
 * - if_fork should point to a freshly allocated struct xfs_ifork.
 *
 * - if_format should be set to the appropriate fork type (e.g.
 *   XFS_DINODE_FMT_BTREE).
 *
 * All other fields must be zero.
 *
 * The _stage_cursor() function for a specific btree type should call
 * xfs_btree_stage_ifakeroot to set up the in-memory cursor as a staging
 * cursor.  The corresponding _commit_staged_btree() function should log
 * the new root and call xfs_btree_commit_ifakeroot() to transform the
 * staging cursor into a regular btree cursor.
 */

--D

> +/*
> + * Initialize an inode-rooted btree cursor with the given inode btree fake
> + * root.  The btree cursor's @bc_ops will be overridden as needed to make the
> + * staging functionality work.  If @new_ops is not NULL, these new ops will be
> + * passed out to the caller for further overriding.
> + */
> +void
> +xfs_btree_stage_ifakeroot(
> +	struct xfs_btree_cur		*cur,
> +	struct xbtree_ifakeroot		*ifake,
> +	struct xfs_btree_ops		**new_ops)
> +{
> +	struct xfs_btree_ops		*nops;
> +
> +	ASSERT(!(cur->bc_flags & XFS_BTREE_STAGING));
> +	ASSERT(cur->bc_flags & XFS_BTREE_ROOT_IN_INODE);
> +
> +	nops = kmem_alloc(sizeof(struct xfs_btree_ops), KM_NOFS);
> +	memcpy(nops, cur->bc_ops, sizeof(struct xfs_btree_ops));
> +	nops->alloc_block = xfs_btree_fakeroot_alloc_block;
> +	nops->free_block = xfs_btree_fakeroot_free_block;
> +	nops->init_ptr_from_cur = xfs_btree_fakeroot_init_ptr_from_cur;
> +	nops->dup_cursor = xfs_btree_fakeroot_dup_cursor;
> +
> +	cur->bc_private.b.ifake = ifake;
> +	cur->bc_nlevels = ifake->if_levels;
> +	cur->bc_ops = nops;
> +	cur->bc_flags |= XFS_BTREE_STAGING;
> +
> +	if (new_ops)
> +		*new_ops = nops;
> +}
> +
> +/*
> + * Transform an inode-rooted staging btree cursor back into a regular cursor by
> + * substituting a real btree root for the fake one and restoring normal btree
> + * cursor ops.  The caller must log the btree root change prior to calling
> + * this.
> + */
> +void
> +xfs_btree_commit_ifakeroot(
> +	struct xfs_btree_cur		*cur,
> +	int				whichfork,
> +	const struct xfs_btree_ops	*ops)
> +{
> +	ASSERT(cur->bc_flags & XFS_BTREE_STAGING);
> +
> +	trace_xfs_btree_commit_ifakeroot(cur);
> +
> +	kmem_free((void *)cur->bc_ops);
> +	cur->bc_private.b.ifake = NULL;
> +	cur->bc_private.b.whichfork = whichfork;
> +	cur->bc_ops = ops;
> +	cur->bc_flags &= ~XFS_BTREE_STAGING;
> +}
> diff --git a/fs/xfs/libxfs/xfs_btree.h b/fs/xfs/libxfs/xfs_btree.h
> index 3ada085609a8..2965ed663418 100644
> --- a/fs/xfs/libxfs/xfs_btree.h
> +++ b/fs/xfs/libxfs/xfs_btree.h
> @@ -10,6 +10,7 @@ struct xfs_buf;
>  struct xfs_inode;
>  struct xfs_mount;
>  struct xfs_trans;
> +struct xfs_ifork;
>  
>  extern kmem_zone_t	*xfs_btree_cur_zone;
>  
> @@ -198,6 +199,18 @@ struct xfs_btree_priv_ag {			/* needed for BNO, CNT, INO */
>  	union xfs_btree_cur_private	priv;
>  };
>  
> +/* Private information for an inode-rooted btree. */
> +struct xfs_btree_priv_inode {			/* needed for BMAP */
> +	struct xfs_inode	*ip;		/* pointer to our inode */
> +	struct xbtree_ifakeroot	*ifake;		/* fake inode fork */
> +	int			allocated;	/* count of alloced */
> +	short			forksize;	/* fork's inode space */
> +	char			whichfork;	/* data or attr fork */
> +	char			flags;		/* flags */
> +#define	XFS_BTCUR_BPRV_WASDEL		(1<<0)	/* was delayed */
> +#define	XFS_BTCUR_BPRV_INVALID_OWNER	(1<<1)	/* for ext swap */
> +};
> +
>  /*
>   * Btree cursor structure.
>   * This collects all information needed by the btree code in one place.
> @@ -220,15 +233,7 @@ typedef struct xfs_btree_cur
>  	int		bc_statoff;	/* offset of btre stats array */
>  	union {
>  		struct xfs_btree_priv_ag a;
> -		struct {			/* needed for BMAP */
> -			struct xfs_inode *ip;	/* pointer to our inode */
> -			int		allocated;	/* count of alloced */
> -			short		forksize;	/* fork's inode space */
> -			char		whichfork;	/* data or attr fork */
> -			char		flags;		/* flags */
> -#define	XFS_BTCUR_BPRV_WASDEL		(1<<0)		/* was delayed */
> -#define	XFS_BTCUR_BPRV_INVALID_OWNER	(1<<1)		/* for ext swap */
> -		} b;
> +		struct xfs_btree_priv_inode b;
>  	}		bc_private;	/* per-btree type data */
>  } xfs_btree_cur_t;
>  
> @@ -506,6 +511,7 @@ union xfs_btree_key *xfs_btree_high_key_from_key(struct xfs_btree_cur *cur,
>  int xfs_btree_has_record(struct xfs_btree_cur *cur, union xfs_btree_irec *low,
>  		union xfs_btree_irec *high, bool *exists);
>  bool xfs_btree_has_more_records(struct xfs_btree_cur *cur);
> +struct xfs_ifork *xfs_btree_ifork_ptr(struct xfs_btree_cur *cur);
>  
>  /* Does this cursor point to the last block in the given level? */
>  static inline bool
> @@ -544,4 +550,32 @@ void xfs_btree_commit_afakeroot(struct xfs_btree_cur *cur,
>  		struct xfs_buf *agbp,
>  		const struct xfs_btree_ops *ops);
>  
> +/* Fake root for an inode-rooted btree. */
> +struct xbtree_ifakeroot {
> +	/* Fake inode fork. */
> +	struct xfs_ifork	*if_fork;
> +
> +	/* Number of blocks used by the btree. */
> +	int64_t			if_blocks;
> +
> +	/* Height of the new btree. */
> +	unsigned int		if_levels;
> +
> +	/* Number of bytes available for this fork in the inode. */
> +	unsigned int		if_fork_size;
> +
> +	/* Fork format. */
> +	unsigned int		if_format;
> +
> +	/* Number of records. */
> +	unsigned int		if_extents;
> +};
> +
> +/* Cursor interactions with with fake roots for inode-rooted btrees. */
> +void xfs_btree_stage_ifakeroot(struct xfs_btree_cur *cur,
> +		struct xbtree_ifakeroot *ifake,
> +		struct xfs_btree_ops **new_ops);
> +void xfs_btree_commit_ifakeroot(struct xfs_btree_cur *cur, int whichfork,
> +		const struct xfs_btree_ops *ops);
> +
>  #endif	/* __XFS_BTREE_H__ */
> diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
> index 57ff9f583b5f..7e162ca80c92 100644
> --- a/fs/xfs/xfs_trace.h
> +++ b/fs/xfs/xfs_trace.h
> @@ -3622,6 +3622,39 @@ TRACE_EVENT(xfs_btree_commit_afakeroot,
>  		  __entry->agbno)
>  )
>  
> +TRACE_EVENT(xfs_btree_commit_ifakeroot,
> +	TP_PROTO(struct xfs_btree_cur *cur),
> +	TP_ARGS(cur),
> +	TP_STRUCT__entry(
> +		__field(dev_t, dev)
> +		__field(xfs_btnum_t, btnum)
> +		__field(xfs_agnumber_t, agno)
> +		__field(xfs_agino_t, agino)
> +		__field(unsigned int, levels)
> +		__field(unsigned int, blocks)
> +		__field(int, whichfork)
> +	),
> +	TP_fast_assign(
> +		__entry->dev = cur->bc_mp->m_super->s_dev;
> +		__entry->btnum = cur->bc_btnum;
> +		__entry->agno = XFS_INO_TO_AGNO(cur->bc_mp,
> +					cur->bc_private.b.ip->i_ino);
> +		__entry->agino = XFS_INO_TO_AGINO(cur->bc_mp,
> +					cur->bc_private.b.ip->i_ino);
> +		__entry->levels = cur->bc_private.b.ifake->if_levels;
> +		__entry->blocks = cur->bc_private.b.ifake->if_blocks;
> +		__entry->whichfork = cur->bc_private.b.whichfork;
> +	),
> +	TP_printk("dev %d:%d btree %s ag %u agino %u whichfork %s levels %u blocks %u",
> +		  MAJOR(__entry->dev), MINOR(__entry->dev),
> +		  __print_symbolic(__entry->btnum, XFS_BTNUM_STRINGS),
> +		  __entry->agno,
> +		  __entry->agino,
> +		  __entry->whichfork == XFS_ATTR_FORK ? "attr" : "data",
> +		  __entry->levels,
> +		  __entry->blocks)
> +)
> +
>  #endif /* _TRACE_XFS_H */
>  
>  #undef TRACE_INCLUDE_PATH
> 
