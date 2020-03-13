Return-Path: <SRS0=BjFQ=46=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A33C1C10DCE
	for <linux-xfs@archiver.kernel.org>; Fri, 13 Mar 2020 16:32:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6E3DD206BE
	for <linux-xfs@archiver.kernel.org>; Fri, 13 Mar 2020 16:32:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="zDNx14Gy"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726480AbgCMQcr (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 13 Mar 2020 12:32:47 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:51090 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726406AbgCMQcq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 13 Mar 2020 12:32:46 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02DGMVdw010781;
        Fri, 13 Mar 2020 16:32:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=9QO/GqALD8F76QcAC0SyPp5lgN7a2KRSu5KrpDZP+x0=;
 b=zDNx14Gy+vsU1W1csyEjVdqxlWBoWkIIOBRzwVlsclhipmwmoSr3Yr2E/INtQPTtw+Zj
 IBSmiQ3o+0neuF0b8NRRKq/RN//Fdx33/Dk8ddYGjyqjdh4M3x6pUixD7wkQu/wLt+6j
 sZUrmc2G5ED6YIMhaeuD/JOuwfwaq4x2Uq0qha2u/rtNhgssAXFA+LpG+gd8qTwUmqzl
 dO+RtVlaPOizhOBoCS1M3PsRO3zJpMsWeIlmd4fbDmsvQHTZsUUgQZ8EN5bnrKP/EtDj
 OjIcOJJKYhZTe+SPxky8XSbBnyqRy/cCgAjNaPjRs1ymNzDncfglvKX3i2okn1y5PPnK cg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 2yqtaevqjh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 13 Mar 2020 16:32:41 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02DGNIaq037897;
        Fri, 13 Mar 2020 16:30:41 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 2yqtawamqt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 13 Mar 2020 16:30:40 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 02DGUdAw014987;
        Fri, 13 Mar 2020 16:30:39 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 13 Mar 2020 09:30:39 -0700
Date:   Fri, 13 Mar 2020 09:30:38 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/7] xfs: introduce fake roots for ag-rooted btrees
Message-ID: <20200313163038.GA1981824@magnolia>
References: <158398473036.1308059.18353233923283406961.stgit@magnolia>
 <158398473702.1308059.5932849079464881055.stgit@magnolia>
 <20200313144712.GA11929@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200313144712.GA11929@bfoster>
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

On Fri, Mar 13, 2020 at 10:47:12AM -0400, Brian Foster wrote:
> On Wed, Mar 11, 2020 at 08:45:37PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Create an in-core fake root for AG-rooted btree types so that callers
> > can generate a whole new btree using the upcoming btree bulk load
> > function without making the new tree accessible from the rest of the
> > filesystem.  It is up to the individual btree type to provide a function
> > to create a staged cursor (presumably with the appropriate callouts to
> > update the fakeroot) and then commit the staged root back into the
> > filesystem.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  fs/xfs/libxfs/xfs_btree.c |  168 +++++++++++++++++++++++++++++++++++++++++++++
> >  fs/xfs/libxfs/xfs_btree.h |   30 ++++++++
> >  fs/xfs/xfs_trace.h        |   28 ++++++++
> >  3 files changed, 225 insertions(+), 1 deletion(-)
> > 
> > 
> > diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
> > index 4ef9f0b42c7f..085bc070e804 100644
> > --- a/fs/xfs/libxfs/xfs_btree.c
> > +++ b/fs/xfs/libxfs/xfs_btree.c
> ...
> > @@ -4908,3 +4910,169 @@ xfs_btree_has_more_records(
> >  	else
> >  		return block->bb_u.s.bb_rightsib != cpu_to_be32(NULLAGBLOCK);
> >  }
> > +
> ...
> > +/*
> > + * Initialize a AG-rooted btree cursor with the given AG btree fake root.  The
> > + * btree cursor's bc_ops will be overridden as needed to make the staging
> > + * functionality work.  If new_ops is not NULL, these new ops will be passed
> > + * out to the caller for further overriding.
> > + */
> > +void
> > +xfs_btree_stage_afakeroot(
> > +	struct xfs_btree_cur		*cur,
> > +	struct xbtree_afakeroot		*afake,
> > +	struct xfs_btree_ops		**new_ops)
> > +{
> > +	struct xfs_btree_ops		*nops;
> > +
> > +	ASSERT(!(cur->bc_flags & XFS_BTREE_STAGING));
> > +	ASSERT(!(cur->bc_flags & XFS_BTREE_ROOT_IN_INODE));
> > +	ASSERT(cur->bc_tp == NULL);
> > +
> > +	nops = kmem_alloc(sizeof(struct xfs_btree_ops), KM_NOFS);
> > +	memcpy(nops, cur->bc_ops, sizeof(struct xfs_btree_ops));
> > +	nops->alloc_block = xfs_btree_fakeroot_alloc_block;
> > +	nops->free_block = xfs_btree_fakeroot_free_block;
> > +	nops->init_ptr_from_cur = xfs_btree_fakeroot_init_ptr_from_cur;
> > +	nops->set_root = xfs_btree_afakeroot_set_root;
> > +	nops->dup_cursor = xfs_btree_fakeroot_dup_cursor;
> > +
> > +	cur->bc_ag.afake = afake;
> > +	cur->bc_nlevels = afake->af_levels;
> > +	cur->bc_ops = nops;
> > +	cur->bc_flags |= XFS_BTREE_STAGING;
> > +
> > +	if (new_ops)
> > +		*new_ops = nops;
> 
> Curious why we have new_ops if the caller unconditionally assigns
> ->bc_ops to the same value..? That aside:

The callers don't assign bc_ops anymore, though the benefit of hindsight
is that nobody uses *new_ops here so perhaps it makes more sense to drop
the parameter for _afakeroot.

--D

> Reviewed-by: Brian Foster <bfoster@redhat.com> 
> 
> > +}
> > +
> > +/*
> > + * Transform an AG-rooted staging btree cursor back into a regular cursor by
> > + * substituting a real btree root for the fake one and restoring normal btree
> > + * cursor ops.  The caller must log the btree root change prior to calling
> > + * this.
> > + */
> > +void
> > +xfs_btree_commit_afakeroot(
> > +	struct xfs_btree_cur		*cur,
> > +	struct xfs_trans		*tp,
> > +	struct xfs_buf			*agbp,
> > +	const struct xfs_btree_ops	*ops)
> > +{
> > +	ASSERT(cur->bc_flags & XFS_BTREE_STAGING);
> > +	ASSERT(cur->bc_tp == NULL);
> > +
> > +	trace_xfs_btree_commit_afakeroot(cur);
> > +
> > +	kmem_free((void *)cur->bc_ops);
> > +	cur->bc_ag.agbp = agbp;
> > +	cur->bc_ops = ops;
> > +	cur->bc_flags &= ~XFS_BTREE_STAGING;
> > +	cur->bc_tp = tp;
> > +}
> > diff --git a/fs/xfs/libxfs/xfs_btree.h b/fs/xfs/libxfs/xfs_btree.h
> > index 0d10bbd5223a..aa4a7bd40023 100644
> > --- a/fs/xfs/libxfs/xfs_btree.h
> > +++ b/fs/xfs/libxfs/xfs_btree.h
> > @@ -179,7 +179,10 @@ union xfs_btree_irec {
> >  
> >  /* Per-AG btree information. */
> >  struct xfs_btree_cur_ag {
> > -	struct xfs_buf		*agbp;
> > +	union {
> > +		struct xfs_buf		*agbp;
> > +		struct xbtree_afakeroot	*afake;	/* fake ag header root */
> > +	};
> >  	xfs_agnumber_t		agno;
> >  	union {
> >  		struct {
> > @@ -235,6 +238,12 @@ typedef struct xfs_btree_cur
> >  #define XFS_BTREE_LASTREC_UPDATE	(1<<2)	/* track last rec externally */
> >  #define XFS_BTREE_CRC_BLOCKS		(1<<3)	/* uses extended btree blocks */
> >  #define XFS_BTREE_OVERLAPPING		(1<<4)	/* overlapping intervals */
> > +/*
> > + * The root of this btree is a fakeroot structure so that we can stage a btree
> > + * rebuild without leaving it accessible via primary metadata.  The ops struct
> > + * is dynamically allocated and must be freed when the cursor is deleted.
> > + */
> > +#define XFS_BTREE_STAGING		(1<<5)
> >  
> >  
> >  #define	XFS_BTREE_NOERROR	0
> > @@ -515,4 +524,23 @@ xfs_btree_islastblock(
> >  	return block->bb_u.s.bb_rightsib == cpu_to_be32(NULLAGBLOCK);
> >  }
> >  
> > +/* Fake root for an AG-rooted btree. */
> > +struct xbtree_afakeroot {
> > +	/* AG block number of the new btree root. */
> > +	xfs_agblock_t		af_root;
> > +
> > +	/* Height of the new btree. */
> > +	unsigned int		af_levels;
> > +
> > +	/* Number of blocks used by the btree. */
> > +	unsigned int		af_blocks;
> > +};
> > +
> > +/* Cursor interactions with with fake roots for AG-rooted btrees. */
> > +void xfs_btree_stage_afakeroot(struct xfs_btree_cur *cur,
> > +		struct xbtree_afakeroot *afake,
> > +		struct xfs_btree_ops **new_ops);
> > +void xfs_btree_commit_afakeroot(struct xfs_btree_cur *cur, struct xfs_trans *tp,
> > +		struct xfs_buf *agbp, const struct xfs_btree_ops *ops);
> > +
> >  #endif	/* __XFS_BTREE_H__ */
> > diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
> > index 059c3098a4a0..d8c229492973 100644
> > --- a/fs/xfs/xfs_trace.h
> > +++ b/fs/xfs/xfs_trace.h
> > @@ -3605,6 +3605,34 @@ TRACE_EVENT(xfs_check_new_dalign,
> >  		  __entry->calc_rootino)
> >  )
> >  
> > +TRACE_EVENT(xfs_btree_commit_afakeroot,
> > +	TP_PROTO(struct xfs_btree_cur *cur),
> > +	TP_ARGS(cur),
> > +	TP_STRUCT__entry(
> > +		__field(dev_t, dev)
> > +		__field(xfs_btnum_t, btnum)
> > +		__field(xfs_agnumber_t, agno)
> > +		__field(xfs_agblock_t, agbno)
> > +		__field(unsigned int, levels)
> > +		__field(unsigned int, blocks)
> > +	),
> > +	TP_fast_assign(
> > +		__entry->dev = cur->bc_mp->m_super->s_dev;
> > +		__entry->btnum = cur->bc_btnum;
> > +		__entry->agno = cur->bc_ag.agno;
> > +		__entry->agbno = cur->bc_ag.afake->af_root;
> > +		__entry->levels = cur->bc_ag.afake->af_levels;
> > +		__entry->blocks = cur->bc_ag.afake->af_blocks;
> > +	),
> > +	TP_printk("dev %d:%d btree %s ag %u levels %u blocks %u root %u",
> > +		  MAJOR(__entry->dev), MINOR(__entry->dev),
> > +		  __print_symbolic(__entry->btnum, XFS_BTNUM_STRINGS),
> > +		  __entry->agno,
> > +		  __entry->levels,
> > +		  __entry->blocks,
> > +		  __entry->agbno)
> > +)
> > +
> >  #endif /* _TRACE_XFS_H */
> >  
> >  #undef TRACE_INCLUDE_PATH
> > 
> 
