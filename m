Return-Path: <SRS0=BjFQ=46=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22ED2C10DCE
	for <linux-xfs@archiver.kernel.org>; Fri, 13 Mar 2020 16:32:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D13E1206EB
	for <linux-xfs@archiver.kernel.org>; Fri, 13 Mar 2020 16:32:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="cz50p9dt"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726528AbgCMQcj (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 13 Mar 2020 12:32:39 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:50938 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726480AbgCMQcj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 13 Mar 2020 12:32:39 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02DGMUUx010756;
        Fri, 13 Mar 2020 16:32:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=YeOdoWzU78n7MFzAQ6SHtyiT9XMtNpjidcnQLioslzA=;
 b=cz50p9dtTVbvLRXNIHSYGArLZTFfrXHZ2wIyLcsBl6Qs9fUpFdXR+4pT3TZwxNsgk7Mz
 Y0m0TBoOE8rGRJ/z0uH/oKUSvP/OfkyO5A00i0dUM4BLnoMmQrLWoWMcnwL9QaZ9DGpD
 lnmKJ2yFKuBE3W4TGLAAlxHuRWBZu4LsRafVcZzR7yU1d2Tm7fjwOXTyeRIkas4LcPGC
 oGoRlpFftYsrD+pGhT4J44lPaaHoyM940bUhnSifTs4A+Nsvne9VfloL2lIgcVn4tGxC
 mejmpUxZoIH0dG4xaUXU8r7s7xTMsnQRiW0GadMhH/F1yN3n1scTVbAZ0VfFkT1zydCB EA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 2yqtaevqha-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 13 Mar 2020 16:32:24 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02DGNIb9037897;
        Fri, 13 Mar 2020 16:32:24 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 2yqtawas65-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 13 Mar 2020 16:32:24 +0000
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 02DGWN0s024975;
        Fri, 13 Mar 2020 16:32:23 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 13 Mar 2020 09:32:22 -0700
Date:   Fri, 13 Mar 2020 09:32:21 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/7] xfs: introduce fake roots for inode-rooted btrees
Message-ID: <20200313163221.GB1981824@magnolia>
References: <158398473036.1308059.18353233923283406961.stgit@magnolia>
 <158398474334.1308059.3288197233526483322.stgit@magnolia>
 <20200313144721.GB11929@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200313144721.GB11929@bfoster>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9558 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0 phishscore=0
 suspectscore=2 mlxscore=0 spamscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2003130083
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9558 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 impostorscore=0
 lowpriorityscore=0 bulkscore=0 priorityscore=1501 suspectscore=2
 mlxlogscore=999 mlxscore=0 adultscore=0 malwarescore=0 spamscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2003130083
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Mar 13, 2020 at 10:47:21AM -0400, Brian Foster wrote:
> On Wed, Mar 11, 2020 at 08:45:43PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Create an in-core fake root for inode-rooted btree types so that callers
> > can generate a whole new btree using the upcoming btree bulk load
> > function without making the new tree accessible from the rest of the
> > filesystem.  It is up to the individual btree type to provide a function
> > to create a staged cursor (presumably with the appropriate callouts to
> > update the fakeroot) and then commit the staged root back into the
> > filesystem.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> 
> Same question as the previous patch, but otherwise looks Ok to me:

This one's different -- the bmbt type will use *new_ops to override more
of the function pointers.  None of the _stage_ifakeroot callers will set
bc_ops since the generic staging function does that now.

--D

> Reviewed-by: Brian Foster <bfoster@redhat.com>
> 
> >  fs/xfs/libxfs/xfs_btree.c |  111 +++++++++++++++++++++++++++++++++++++++++++--
> >  fs/xfs/libxfs/xfs_btree.h |   31 +++++++++++++
> >  fs/xfs/xfs_trace.h        |   33 +++++++++++++
> >  3 files changed, 171 insertions(+), 4 deletions(-)
> > 
> > 
> > diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
> > index 085bc070e804..4e1d4f184d4b 100644
> > --- a/fs/xfs/libxfs/xfs_btree.c
> > +++ b/fs/xfs/libxfs/xfs_btree.c
> > @@ -644,6 +644,17 @@ xfs_btree_ptr_addr(
> >  		((char *)block + xfs_btree_ptr_offset(cur, n, level));
> >  }
> >  
> > +struct xfs_ifork *
> > +xfs_btree_ifork_ptr(
> > +	struct xfs_btree_cur	*cur)
> > +{
> > +	ASSERT(cur->bc_flags & XFS_BTREE_ROOT_IN_INODE);
> > +
> > +	if (cur->bc_flags & XFS_BTREE_STAGING)
> > +		return cur->bc_ino.ifake->if_fork;
> > +	return XFS_IFORK_PTR(cur->bc_ino.ip, cur->bc_ino.whichfork);
> > +}
> > +
> >  /*
> >   * Get the root block which is stored in the inode.
> >   *
> > @@ -654,9 +665,8 @@ STATIC struct xfs_btree_block *
> >  xfs_btree_get_iroot(
> >  	struct xfs_btree_cur	*cur)
> >  {
> > -	struct xfs_ifork	*ifp;
> > +	struct xfs_ifork	*ifp = xfs_btree_ifork_ptr(cur);
> >  
> > -	ifp = XFS_IFORK_PTR(cur->bc_ino.ip, cur->bc_ino.whichfork);
> >  	return (struct xfs_btree_block *)ifp->if_broot;
> >  }
> >  
> > @@ -4985,8 +4995,17 @@ xfs_btree_fakeroot_init_ptr_from_cur(
> >  
> >  	ASSERT(cur->bc_flags & XFS_BTREE_STAGING);
> >  
> > -	afake = cur->bc_ag.afake;
> > -	ptr->s = cpu_to_be32(afake->af_root);
> > +	if (cur->bc_flags & XFS_BTREE_ROOT_IN_INODE) {
> > +		/*
> > +		 * The root block lives in the inode core, so we zero the
> > +		 * pointer (like the bmbt code does) to make it obvious if
> > +		 * anyone ever tries to use this pointer.
> > +		 */
> > +		ptr->l = cpu_to_be64(0);
> > +	} else {
> > +		afake = cur->bc_ag.afake;
> > +		ptr->s = cpu_to_be32(afake->af_root);
> > +	}
> >  }
> >  
> >  /*
> > @@ -5076,3 +5095,87 @@ xfs_btree_commit_afakeroot(
> >  	cur->bc_flags &= ~XFS_BTREE_STAGING;
> >  	cur->bc_tp = tp;
> >  }
> > +
> > +/*
> > + * Bulk Loading for Inode-Rooted Btrees
> > + * ====================================
> > + *
> > + * For a btree rooted in an inode fork, pass a xbtree_ifakeroot structure to
> > + * the staging cursor.  This structure should be initialized as follows:
> > + *
> > + * - if_fork_size field should be set to the number of bytes available to the
> > + *   fork in the inode.
> > + *
> > + * - if_fork should point to a freshly allocated struct xfs_ifork.
> > + *
> > + * - if_format should be set to the appropriate fork type (e.g.
> > + *   XFS_DINODE_FMT_BTREE).
> > + *
> > + * All other fields must be zero.
> > + *
> > + * The _stage_cursor() function for a specific btree type should call
> > + * xfs_btree_stage_ifakeroot to set up the in-memory cursor as a staging
> > + * cursor.  The corresponding _commit_staged_btree() function should log the
> > + * new root and call xfs_btree_commit_ifakeroot() to transform the staging
> > + * cursor into a regular btree cursor.
> > + */
> > +
> > +/*
> > + * Initialize an inode-rooted btree cursor with the given inode btree fake
> > + * root.  The btree cursor's bc_ops will be overridden as needed to make the
> > + * staging functionality work.  If new_ops is not NULL, these new ops will be
> > + * passed out to the caller for further overriding.
> > + */
> > +void
> > +xfs_btree_stage_ifakeroot(
> > +	struct xfs_btree_cur		*cur,
> > +	struct xbtree_ifakeroot		*ifake,
> > +	struct xfs_btree_ops		**new_ops)
> > +{
> > +	struct xfs_btree_ops		*nops;
> > +
> > +	ASSERT(!(cur->bc_flags & XFS_BTREE_STAGING));
> > +	ASSERT(cur->bc_flags & XFS_BTREE_ROOT_IN_INODE);
> > +	ASSERT(cur->bc_tp == NULL);
> > +
> > +	nops = kmem_alloc(sizeof(struct xfs_btree_ops), KM_NOFS);
> > +	memcpy(nops, cur->bc_ops, sizeof(struct xfs_btree_ops));
> > +	nops->alloc_block = xfs_btree_fakeroot_alloc_block;
> > +	nops->free_block = xfs_btree_fakeroot_free_block;
> > +	nops->init_ptr_from_cur = xfs_btree_fakeroot_init_ptr_from_cur;
> > +	nops->dup_cursor = xfs_btree_fakeroot_dup_cursor;
> > +
> > +	cur->bc_ino.ifake = ifake;
> > +	cur->bc_nlevels = ifake->if_levels;
> > +	cur->bc_ops = nops;
> > +	cur->bc_flags |= XFS_BTREE_STAGING;
> > +
> > +	if (new_ops)
> > +		*new_ops = nops;
> > +}
> > +
> > +/*
> > + * Transform an inode-rooted staging btree cursor back into a regular cursor by
> > + * substituting a real btree root for the fake one and restoring normal btree
> > + * cursor ops.  The caller must log the btree root change prior to calling
> > + * this.
> > + */
> > +void
> > +xfs_btree_commit_ifakeroot(
> > +	struct xfs_btree_cur		*cur,
> > +	struct xfs_trans		*tp,
> > +	int				whichfork,
> > +	const struct xfs_btree_ops	*ops)
> > +{
> > +	ASSERT(cur->bc_flags & XFS_BTREE_STAGING);
> > +	ASSERT(cur->bc_tp == NULL);
> > +
> > +	trace_xfs_btree_commit_ifakeroot(cur);
> > +
> > +	kmem_free((void *)cur->bc_ops);
> > +	cur->bc_ino.ifake = NULL;
> > +	cur->bc_ino.whichfork = whichfork;
> > +	cur->bc_ops = ops;
> > +	cur->bc_flags &= ~XFS_BTREE_STAGING;
> > +	cur->bc_tp = tp;
> > +}
> > diff --git a/fs/xfs/libxfs/xfs_btree.h b/fs/xfs/libxfs/xfs_btree.h
> > index aa4a7bd40023..047067f52063 100644
> > --- a/fs/xfs/libxfs/xfs_btree.h
> > +++ b/fs/xfs/libxfs/xfs_btree.h
> > @@ -10,6 +10,7 @@ struct xfs_buf;
> >  struct xfs_inode;
> >  struct xfs_mount;
> >  struct xfs_trans;
> > +struct xfs_ifork;
> >  
> >  extern kmem_zone_t	*xfs_btree_cur_zone;
> >  
> > @@ -198,6 +199,7 @@ struct xfs_btree_cur_ag {
> >  /* Btree-in-inode cursor information */
> >  struct xfs_btree_cur_ino {
> >  	struct xfs_inode	*ip;
> > +	struct xbtree_ifakeroot	*ifake;		/* fake inode fork */
> >  	int			allocated;
> >  	short			forksize;
> >  	char			whichfork;
> > @@ -506,6 +508,7 @@ union xfs_btree_key *xfs_btree_high_key_from_key(struct xfs_btree_cur *cur,
> >  int xfs_btree_has_record(struct xfs_btree_cur *cur, union xfs_btree_irec *low,
> >  		union xfs_btree_irec *high, bool *exists);
> >  bool xfs_btree_has_more_records(struct xfs_btree_cur *cur);
> > +struct xfs_ifork *xfs_btree_ifork_ptr(struct xfs_btree_cur *cur);
> >  
> >  /* Does this cursor point to the last block in the given level? */
> >  static inline bool
> > @@ -543,4 +546,32 @@ void xfs_btree_stage_afakeroot(struct xfs_btree_cur *cur,
> >  void xfs_btree_commit_afakeroot(struct xfs_btree_cur *cur, struct xfs_trans *tp,
> >  		struct xfs_buf *agbp, const struct xfs_btree_ops *ops);
> >  
> > +/* Fake root for an inode-rooted btree. */
> > +struct xbtree_ifakeroot {
> > +	/* Fake inode fork. */
> > +	struct xfs_ifork	*if_fork;
> > +
> > +	/* Number of blocks used by the btree. */
> > +	int64_t			if_blocks;
> > +
> > +	/* Height of the new btree. */
> > +	unsigned int		if_levels;
> > +
> > +	/* Number of bytes available for this fork in the inode. */
> > +	unsigned int		if_fork_size;
> > +
> > +	/* Fork format. */
> > +	unsigned int		if_format;
> > +
> > +	/* Number of records. */
> > +	unsigned int		if_extents;
> > +};
> > +
> > +/* Cursor interactions with with fake roots for inode-rooted btrees. */
> > +void xfs_btree_stage_ifakeroot(struct xfs_btree_cur *cur,
> > +		struct xbtree_ifakeroot *ifake,
> > +		struct xfs_btree_ops **new_ops);
> > +void xfs_btree_commit_ifakeroot(struct xfs_btree_cur *cur, struct xfs_trans *tp,
> > +		int whichfork, const struct xfs_btree_ops *ops);
> > +
> >  #endif	/* __XFS_BTREE_H__ */
> > diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
> > index d8c229492973..05db0398f040 100644
> > --- a/fs/xfs/xfs_trace.h
> > +++ b/fs/xfs/xfs_trace.h
> > @@ -3633,6 +3633,39 @@ TRACE_EVENT(xfs_btree_commit_afakeroot,
> >  		  __entry->agbno)
> >  )
> >  
> > +TRACE_EVENT(xfs_btree_commit_ifakeroot,
> > +	TP_PROTO(struct xfs_btree_cur *cur),
> > +	TP_ARGS(cur),
> > +	TP_STRUCT__entry(
> > +		__field(dev_t, dev)
> > +		__field(xfs_btnum_t, btnum)
> > +		__field(xfs_agnumber_t, agno)
> > +		__field(xfs_agino_t, agino)
> > +		__field(unsigned int, levels)
> > +		__field(unsigned int, blocks)
> > +		__field(int, whichfork)
> > +	),
> > +	TP_fast_assign(
> > +		__entry->dev = cur->bc_mp->m_super->s_dev;
> > +		__entry->btnum = cur->bc_btnum;
> > +		__entry->agno = XFS_INO_TO_AGNO(cur->bc_mp,
> > +					cur->bc_ino.ip->i_ino);
> > +		__entry->agino = XFS_INO_TO_AGINO(cur->bc_mp,
> > +					cur->bc_ino.ip->i_ino);
> > +		__entry->levels = cur->bc_ino.ifake->if_levels;
> > +		__entry->blocks = cur->bc_ino.ifake->if_blocks;
> > +		__entry->whichfork = cur->bc_ino.whichfork;
> > +	),
> > +	TP_printk("dev %d:%d btree %s ag %u agino %u whichfork %s levels %u blocks %u",
> > +		  MAJOR(__entry->dev), MINOR(__entry->dev),
> > +		  __print_symbolic(__entry->btnum, XFS_BTNUM_STRINGS),
> > +		  __entry->agno,
> > +		  __entry->agino,
> > +		  __entry->whichfork == XFS_ATTR_FORK ? "attr" : "data",
> > +		  __entry->levels,
> > +		  __entry->blocks)
> > +)
> > +
> >  #endif /* _TRACE_XFS_H */
> >  
> >  #undef TRACE_INCLUDE_PATH
> > 
> 
