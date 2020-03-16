Return-Path: <SRS0=1m5L=5B=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C398C0044D
	for <linux-xfs@archiver.kernel.org>; Mon, 16 Mar 2020 14:58:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CD27720679
	for <linux-xfs@archiver.kernel.org>; Mon, 16 Mar 2020 14:58:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Otss38PF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731737AbgCPO6M (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 16 Mar 2020 10:58:12 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:48738 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731731AbgCPO6M (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 16 Mar 2020 10:58:12 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02GEqmEH088909;
        Mon, 16 Mar 2020 14:58:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=SUgBKDTC32A24W2n36QohwmjjMiZVziR2KpRAFqM2JA=;
 b=Otss38PFfUB2EX6DiT55Odv71WCne/5F6nPP4oEVzvowxl2IEXYuH6EuJjwhOY+dATga
 uD79UlYNUQHZfMbljbZqeewkpuNEIxtjLmOWtKfNdE6Y5Rhwv/jD+/H/KMw4bC9FsFGu
 N+Otb4szrAFyIh4TXou1WKMwLkHGEFJCrZEt37vD5RptgbdDNqD+LXtfSQ2tSaudxF6y
 cc0jf0krLW7wfibHe2M2h7RhnTyssw7ItNZzfcXWpglUYCz/m9ucEW3shmnMsKu5Pkzb
 pntx6EZ54BP5mdVToveFnoEGg3eii4qcmkePCSgYAd8Sto+IQ0oEFAY5lUNEjrWSVEd/ Yw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 2yrppqyey9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 16 Mar 2020 14:58:08 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02GEqNdZ172713;
        Mon, 16 Mar 2020 14:58:07 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 2ys8yvydgt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 16 Mar 2020 14:58:07 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 02GEw6sU007401;
        Mon, 16 Mar 2020 14:58:06 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 16 Mar 2020 07:58:06 -0700
Date:   Mon, 16 Mar 2020 07:58:04 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/7] xfs: add support for free space btree staging cursors
Message-ID: <20200316145804.GB256767@magnolia>
References: <158431623997.357791.9599758740528407024.stgit@magnolia>
 <158431626637.357791.7694218797816175496.stgit@magnolia>
 <20200316122942.GA12313@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200316122942.GA12313@bfoster>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9561 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxlogscore=999 mlxscore=0
 adultscore=0 bulkscore=0 malwarescore=0 spamscore=0 suspectscore=2
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2003160072
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9561 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0
 suspectscore=2 lowpriorityscore=0 phishscore=0 adultscore=0 clxscore=1015
 impostorscore=0 priorityscore=1501 spamscore=0 mlxlogscore=999 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2003160072
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Mar 16, 2020 at 08:29:42AM -0400, Brian Foster wrote:
> On Sun, Mar 15, 2020 at 04:51:06PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Add support for btree staging cursors for the free space btrees.  This
> > is needed both for online repair and also to convert xfs_repair to use
> > btree bulk loading.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  fs/xfs/libxfs/xfs_alloc_btree.c |   98 +++++++++++++++++++++++++++++++--------
> >  fs/xfs/libxfs/xfs_alloc_btree.h |    7 +++
> >  2 files changed, 86 insertions(+), 19 deletions(-)
> > 
> > 
> > diff --git a/fs/xfs/libxfs/xfs_alloc_btree.c b/fs/xfs/libxfs/xfs_alloc_btree.c
> > index a28041fdf4c0..93792ee7924e 100644
> > --- a/fs/xfs/libxfs/xfs_alloc_btree.c
> > +++ b/fs/xfs/libxfs/xfs_alloc_btree.c
> ...
> > @@ -485,36 +520,61 @@ xfs_allocbt_init_cursor(
> ...
> >  
> > +/*
> > + * Install a new free space btree root.  Caller is responsible for invalidating
> > + * and freeing the old btree blocks.
> > + */
> > +void
> > +xfs_allocbt_commit_staged_btree(
> > +	struct xfs_btree_cur	*cur,
> > +	struct xfs_trans	*tp,
> > +	struct xfs_buf		*agbp)
> > +{
> > +	struct xfs_agf		*agf = agbp->b_addr;
> > +	struct xbtree_afakeroot	*afake = cur->bc_ag.afake;
> > +
> > +	ASSERT(cur->bc_flags & XFS_BTREE_STAGING);
> > +
> > +	agf->agf_roots[cur->bc_btnum] = cpu_to_be32(afake->af_root);
> > +	agf->agf_levels[cur->bc_btnum] = cpu_to_be32(afake->af_levels);
> > +	xfs_alloc_log_agf(tp, agbp, XFS_AGF_ROOTS | XFS_AGF_LEVELS);
> > +
> > +	if (cur->bc_btnum == XFS_BTNUM_BNO) {
> > +		xfs_btree_commit_afakeroot(cur, tp, agbp, &xfs_bnobt_ops);
> > +	} else {
> > +		cur->bc_flags |= XFS_BTREE_LASTREC_UPDATE;
> 
> Any reason this is set here and not at init time for the staging cursor?

Originally it was so that ->update_lastrec couldn't get called, but
since you're not supposed to be calling the regular btree operations
anyway I suppose it doesn't matter if the flag is set in staging
cursors... will fix.

--D

> Brian
> 
> > +		xfs_btree_commit_afakeroot(cur, tp, agbp, &xfs_cntbt_ops);
> > +	}
> > +}
> > +
> >  /*
> >   * Calculate number of records in an alloc btree block.
> >   */
> > diff --git a/fs/xfs/libxfs/xfs_alloc_btree.h b/fs/xfs/libxfs/xfs_alloc_btree.h
> > index c9305ebb69f6..047f09f0be3c 100644
> > --- a/fs/xfs/libxfs/xfs_alloc_btree.h
> > +++ b/fs/xfs/libxfs/xfs_alloc_btree.h
> > @@ -13,6 +13,7 @@
> >  struct xfs_buf;
> >  struct xfs_btree_cur;
> >  struct xfs_mount;
> > +struct xbtree_afakeroot;
> >  
> >  /*
> >   * Btree block header size depends on a superblock flag.
> > @@ -48,8 +49,14 @@ struct xfs_mount;
> >  extern struct xfs_btree_cur *xfs_allocbt_init_cursor(struct xfs_mount *,
> >  		struct xfs_trans *, struct xfs_buf *,
> >  		xfs_agnumber_t, xfs_btnum_t);
> > +struct xfs_btree_cur *xfs_allocbt_stage_cursor(struct xfs_mount *mp,
> > +		struct xbtree_afakeroot *afake, xfs_agnumber_t agno,
> > +		xfs_btnum_t btnum);
> >  extern int xfs_allocbt_maxrecs(struct xfs_mount *, int, int);
> >  extern xfs_extlen_t xfs_allocbt_calc_size(struct xfs_mount *mp,
> >  		unsigned long long len);
> >  
> > +void xfs_allocbt_commit_staged_btree(struct xfs_btree_cur *cur,
> > +		struct xfs_trans *tp, struct xfs_buf *agbp);
> > +
> >  #endif	/* __XFS_ALLOC_BTREE_H__ */
> > 
> 
