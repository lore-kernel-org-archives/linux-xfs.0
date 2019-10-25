Return-Path: <SRS0=Pn/S=YS=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82F35CA9EA0
	for <linux-xfs@archiver.kernel.org>; Fri, 25 Oct 2019 19:04:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3BED321D82
	for <linux-xfs@archiver.kernel.org>; Fri, 25 Oct 2019 19:04:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="JRiF1NF8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725955AbfJYTEt (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 25 Oct 2019 15:04:49 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:43072 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725847AbfJYTEt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 25 Oct 2019 15:04:49 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9PJ4OXi060841;
        Fri, 25 Oct 2019 19:04:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=o6OC05lV+QOQQwtTHNvdMzhzp2sRBIAtrab3PKQCbVU=;
 b=JRiF1NF80XW148jKQz3S4L12BIR7Udv/71DaYNgt5ERaFTMzcp6emuAhurMxwPOWRN+E
 WEGbCof6RJD2u9/nGuv1blUBB3mihWGGl1njd6ZUUypPG8n/uSoJldGOaxSK9rjMHL9L
 hZlNpllowfqcG0erLgtZY4cJfEYgwtPddR++ZmcDOZ/FPaoBos+ArybM0YhFqfpsUcDB
 4p3VtJWkbp63ht2kgp5h9CHQFwlV6GlPX/bagDvJyMP2zg8MFe0fTFiakmdai/HKMza1
 1FtPhvgQ/kwdn5iVLnzj2RtLl1MYu8V7+TiF3OY1CmvjqlMHmZbIYAR8ktGiNIKkaGxD hg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 2vqteqd1b2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 25 Oct 2019 19:04:45 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9PJ4KG3191893;
        Fri, 25 Oct 2019 19:04:45 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 2vu0fs7ah1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 25 Oct 2019 19:04:45 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x9PJ4iDR013214;
        Fri, 25 Oct 2019 19:04:45 GMT
Received: from localhost (/10.145.178.128)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 25 Oct 2019 12:04:44 -0700
Date:   Fri, 25 Oct 2019 12:04:41 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/4] xfs: introduce fake roots for ag-rooted btrees
Message-ID: <20191025190441.GP913374@magnolia>
References: <157063967800.2912204.4012307770844087647.stgit@magnolia>
 <157063968551.2912204.15634530264967900662.stgit@magnolia>
 <20191016152629.GB41077@bfoster>
 <20191016165356.GY13108@magnolia>
 <20191016173638.GA16688@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191016173638.GA16688@bfoster>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9421 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1910250172
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9421 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1910250172
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Oct 16, 2019 at 01:36:38PM -0400, Brian Foster wrote:
> On Wed, Oct 16, 2019 at 09:53:56AM -0700, Darrick J. Wong wrote:
> > On Wed, Oct 16, 2019 at 11:26:29AM -0400, Brian Foster wrote:
> > > On Wed, Oct 09, 2019 at 09:48:05AM -0700, Darrick J. Wong wrote:
> > > > From: Darrick J. Wong <darrick.wong@oracle.com>
> > > > 
> > > > Create an in-core fake root for AG-rooted btree types so that callers
> > > > can generate a whole new btree using the upcoming btree bulk load
> > > > function without making the new tree accessible from the rest of the
> > > > filesystem.  It is up to the individual btree type to provide a function
> > > > to create a staged cursor (presumably with the appropriate callouts to
> > > > update the fakeroot) and then commit the staged root back into the
> > > > filesystem.
> > > > 
> > > > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > > > ---
> > > 
> > > >  fs/xfs/libxfs/xfs_btree.c |  115 +++++++++++++++++++++++++++++++++++++++++++++
> > > >  fs/xfs/libxfs/xfs_btree.h |   43 +++++++++++++++--
> > > >  fs/xfs/xfs_trace.h        |   28 +++++++++++
> > > >  3 files changed, 181 insertions(+), 5 deletions(-)
> > > > 
> > > > 
> > > > diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
> > > > index 71de937f9e64..7b18f0fa5e99 100644
> > > > --- a/fs/xfs/libxfs/xfs_btree.c
> > > > +++ b/fs/xfs/libxfs/xfs_btree.c
> > > ...
> > > > @@ -4930,3 +4932,116 @@ xfs_btree_has_more_records(
> > > ...
> > > > +/* Initialize a pointer to the root block from the fakeroot. */
> > > > +STATIC void
> > > > +xfs_btree_fakeroot_init_ptr_from_cur(
> > > > +	struct xfs_btree_cur	*cur,
> > > > +	union xfs_btree_ptr	*ptr)
> > > > +{
> > > > +	struct xbtree_afakeroot	*afake;
> > > > +
> > > > +	ASSERT(cur->bc_flags & XFS_BTREE_STAGING);
> > > > +
> > > > +	if (cur->bc_flags & XFS_BTREE_LONG_PTRS) {

Heh, this should be XFS_BTREE_ROOT_IN_INODE, and it ought to be in the
next patch.  Will fix. :)

> > > > +		ptr->l = cpu_to_be64(0);
> > > 
> > > Why zero here? Is this just not supported?
> > 
> > <shrug> The only existing longptr btree does this too.
> > 
> > There's no root block so we might as well set the pointer to 0 to catch
> > incorrect accesses.
> > 
> > > Otherwise this seems straightforward code-wise. I think I get the
> > > general idea, but it's hard to reason further about the pieces until I
> > > see the broader context..
> > 
> > Sorry about that. :/
> > 
> 
> Not a big deal..
> 
> > You can skip to the v20 repair series to see how this all gets used in
> > the kernel, since the two sets in between are cleanups of other common
> > code.  I also have a series to refactor xfs_repair to use btree bulk
> > loading[1], if that helps.
> > 
> 
> I'll get there eventually. :P This was just an FYI that I'd probably
> have to at least make a cursory pass through the rest and come back to
> this in order to properly review.

<nod>

--D

> Brian
> 
> > --D
> > 
> > [1] https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=repair-bulk-load
> > 
> > > Brian
> > > 
> > > > +	} else {
> > > > +		afake = cur->bc_private.a.afake;
> > > > +		ptr->s = cpu_to_be32(afake->af_root);
> > > > +	}
> > > > +}
> > > > +
> > > > +/* Set the root block when our tree has a fakeroot. */
> > > > +STATIC void
> > > > +xfs_btree_afakeroot_set_root(
> > > > +	struct xfs_btree_cur	*cur,
> > > > +	union xfs_btree_ptr	*ptr,
> > > > +	int			inc)
> > > > +{
> > > > +	struct xbtree_afakeroot	*afake = cur->bc_private.a.afake;
> > > > +
> > > > +	ASSERT(cur->bc_flags & XFS_BTREE_STAGING);
> > > > +	afake->af_root = be32_to_cpu(ptr->s);
> > > > +	afake->af_levels += inc;
> > > > +}
> > > > +
> > > > +/*
> > > > + * Initialize a AG-rooted btree cursor with the given AG @fakeroot, and prepare
> > > > + * @ops for overriding by duplicating them into @new_ops.  The caller can
> > > > + * replace pointers in @new_ops as necessary once this call completes.  Note
> > > > + * that staging cursors can only be used for bulk loading.
> > > > + */
> > > > +void
> > > > +xfs_btree_stage_afakeroot(
> > > > +	struct xfs_btree_cur		*cur,
> > > > +	struct xbtree_afakeroot		*afake,
> > > > +	const struct xfs_btree_ops	*ops,
> > > > +	struct xfs_btree_ops		**new_ops)
> > > > +{
> > > > +	ASSERT(!(cur->bc_flags & XFS_BTREE_STAGING));
> > > > +	ASSERT(!(cur->bc_flags & XFS_BTREE_ROOT_IN_INODE));
> > > > +
> > > > +	*new_ops = kmem_alloc(sizeof(struct xfs_btree_ops), KM_NOFS);
> > > > +	memcpy(*new_ops, ops, sizeof(struct xfs_btree_ops));
> > > > +	(*new_ops)->alloc_block = xfs_btree_fakeroot_alloc_block;
> > > > +	(*new_ops)->free_block = xfs_btree_fakeroot_free_block;
> > > > +	(*new_ops)->init_ptr_from_cur = xfs_btree_fakeroot_init_ptr_from_cur;
> > > > +	(*new_ops)->set_root = xfs_btree_afakeroot_set_root;
> > > > +	(*new_ops)->dup_cursor = xfs_btree_fakeroot_dup_cursor;
> > > > +
> > > > +	cur->bc_private.a.afake = afake;
> > > > +	cur->bc_nlevels = afake->af_levels;
> > > > +	cur->bc_ops = *new_ops;
> > > > +	cur->bc_flags |= XFS_BTREE_STAGING;
> > > > +}
> > > > +
> > > > +/*
> > > > + * Transform an AG-rooted staging btree cursor back into a regular btree
> > > > + * cursor.  Caller is responsible for logging changes before this.
> > > > + */
> > > > +void
> > > > +xfs_btree_commit_afakeroot(
> > > > +	struct xfs_btree_cur		*cur,
> > > > +	struct xfs_buf			*agbp,
> > > > +	const struct xfs_btree_ops	*ops)
> > > > +{
> > > > +	ASSERT(cur->bc_flags & XFS_BTREE_STAGING);
> > > > +
> > > > +	trace_xfs_btree_commit_afakeroot(cur);
> > > > +
> > > > +	kmem_free((void *)cur->bc_ops);
> > > > +	cur->bc_private.a.agbp = agbp;
> > > > +	cur->bc_ops = ops;
> > > > +	cur->bc_flags &= ~XFS_BTREE_STAGING;
> > > > +}
> > > > diff --git a/fs/xfs/libxfs/xfs_btree.h b/fs/xfs/libxfs/xfs_btree.h
> > > > index ced1e65d1483..453de8a49e96 100644
> > > > --- a/fs/xfs/libxfs/xfs_btree.h
> > > > +++ b/fs/xfs/libxfs/xfs_btree.h
> > > > @@ -185,6 +185,16 @@ union xfs_btree_cur_private {
> > > >  	} refc;
> > > >  };
> > > >  
> > > > +/* Private information for a AG-rooted btree. */
> > > > +struct xfs_btree_priv_ag {			/* needed for BNO, CNT, INO */
> > > > +	union {
> > > > +		struct xfs_buf		*agbp;	/* agf/agi buffer pointer */
> > > > +		struct xbtree_afakeroot	*afake;	/* fake ag header root */
> > > > +	};
> > > > +	xfs_agnumber_t			agno;	/* ag number */
> > > > +	union xfs_btree_cur_private	priv;
> > > > +};
> > > > +
> > > >  /*
> > > >   * Btree cursor structure.
> > > >   * This collects all information needed by the btree code in one place.
> > > > @@ -206,11 +216,7 @@ typedef struct xfs_btree_cur
> > > >  	xfs_btnum_t	bc_btnum;	/* identifies which btree type */
> > > >  	int		bc_statoff;	/* offset of btre stats array */
> > > >  	union {
> > > > -		struct {			/* needed for BNO, CNT, INO */
> > > > -			struct xfs_buf	*agbp;	/* agf/agi buffer pointer */
> > > > -			xfs_agnumber_t	agno;	/* ag number */
> > > > -			union xfs_btree_cur_private	priv;
> > > > -		} a;
> > > > +		struct xfs_btree_priv_ag a;
> > > >  		struct {			/* needed for BMAP */
> > > >  			struct xfs_inode *ip;	/* pointer to our inode */
> > > >  			int		allocated;	/* count of alloced */
> > > > @@ -229,6 +235,12 @@ typedef struct xfs_btree_cur
> > > >  #define XFS_BTREE_LASTREC_UPDATE	(1<<2)	/* track last rec externally */
> > > >  #define XFS_BTREE_CRC_BLOCKS		(1<<3)	/* uses extended btree blocks */
> > > >  #define XFS_BTREE_OVERLAPPING		(1<<4)	/* overlapping intervals */
> > > > +/*
> > > > + * The root of this btree is a fakeroot structure so that we can stage a btree
> > > > + * rebuild without leaving it accessible via primary metadata.  The ops struct
> > > > + * is dynamically allocated and must be freed when the cursor is deleted.
> > > > + */
> > > > +#define XFS_BTREE_STAGING		(1<<5)
> > > >  
> > > >  
> > > >  #define	XFS_BTREE_NOERROR	0
> > > > @@ -514,4 +526,25 @@ int xfs_btree_has_record(struct xfs_btree_cur *cur, union xfs_btree_irec *low,
> > > >  		union xfs_btree_irec *high, bool *exists);
> > > >  bool xfs_btree_has_more_records(struct xfs_btree_cur *cur);
> > > >  
> > > > +/* Fake root for an AG-rooted btree. */
> > > > +struct xbtree_afakeroot {
> > > > +	/* AG block number of the new btree root. */
> > > > +	xfs_agblock_t		af_root;
> > > > +
> > > > +	/* Height of the new btree. */
> > > > +	unsigned int		af_levels;
> > > > +
> > > > +	/* Number of blocks used by the btree. */
> > > > +	unsigned int		af_blocks;
> > > > +};
> > > > +
> > > > +/* Cursor interactions with with fake roots for AG-rooted btrees. */
> > > > +void xfs_btree_stage_afakeroot(struct xfs_btree_cur *cur,
> > > > +		struct xbtree_afakeroot *afake,
> > > > +		const struct xfs_btree_ops *ops,
> > > > +		struct xfs_btree_ops **new_ops);
> > > > +void xfs_btree_commit_afakeroot(struct xfs_btree_cur *cur,
> > > > +		struct xfs_buf *agbp,
> > > > +		const struct xfs_btree_ops *ops);
> > > > +
> > > >  #endif	/* __XFS_BTREE_H__ */
> > > > diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
> > > > index eaae275ed430..e04ed5324696 100644
> > > > --- a/fs/xfs/xfs_trace.h
> > > > +++ b/fs/xfs/xfs_trace.h
> > > > @@ -3609,6 +3609,34 @@ DEFINE_KMEM_EVENT(kmem_alloc_large);
> > > >  DEFINE_KMEM_EVENT(kmem_realloc);
> > > >  DEFINE_KMEM_EVENT(kmem_zone_alloc);
> > > >  
> > > > +TRACE_EVENT(xfs_btree_commit_afakeroot,
> > > > +	TP_PROTO(struct xfs_btree_cur *cur),
> > > > +	TP_ARGS(cur),
> > > > +	TP_STRUCT__entry(
> > > > +		__field(dev_t, dev)
> > > > +		__field(xfs_btnum_t, btnum)
> > > > +		__field(xfs_agnumber_t, agno)
> > > > +		__field(xfs_agblock_t, agbno)
> > > > +		__field(unsigned int, levels)
> > > > +		__field(unsigned int, blocks)
> > > > +	),
> > > > +	TP_fast_assign(
> > > > +		__entry->dev = cur->bc_mp->m_super->s_dev;
> > > > +		__entry->btnum = cur->bc_btnum;
> > > > +		__entry->agno = cur->bc_private.a.agno;
> > > > +		__entry->agbno = cur->bc_private.a.afake->af_root;
> > > > +		__entry->levels = cur->bc_private.a.afake->af_levels;
> > > > +		__entry->blocks = cur->bc_private.a.afake->af_blocks;
> > > > +	),
> > > > +	TP_printk("dev %d:%d btree %s ag %u levels %u blocks %u root %u",
> > > > +		  MAJOR(__entry->dev), MINOR(__entry->dev),
> > > > +		  __print_symbolic(__entry->btnum, XFS_BTNUM_STRINGS),
> > > > +		  __entry->agno,
> > > > +		  __entry->levels,
> > > > +		  __entry->blocks,
> > > > +		  __entry->agbno)
> > > > +)
> > > > +
> > > >  #endif /* _TRACE_XFS_H */
> > > >  
> > > >  #undef TRACE_INCLUDE_PATH
> > > > 
