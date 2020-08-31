Return-Path: <SRS0=tsMC=CJ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70D9FC433E6
	for <linux-xfs@archiver.kernel.org>; Mon, 31 Aug 2020 19:42:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4725720EDD
	for <linux-xfs@archiver.kernel.org>; Mon, 31 Aug 2020 19:42:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="LUiTctpe"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728986AbgHaTmT (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 31 Aug 2020 15:42:19 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:50604 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728414AbgHaTmT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 31 Aug 2020 15:42:19 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07VJdFCY086800;
        Mon, 31 Aug 2020 19:42:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=7dsDhcAotj7XDhkaoX3G6Vp0N3yoCZnOXIRBGD82lGI=;
 b=LUiTctpeY4bJduOmRLdwyrqE9e0Nw703QlqlftaZV3o9x/Ll+KDhBg9APsyOD/5eonBz
 Mc9d9BhOaQZiIPB0w8WtnOl/GJKBcE0BcP8aEPWzKTEHPW66Zyz4yJ08qPfJjLQkPnHo
 JzVtVhYeJAdr3BLvox9YDmG+bHnI5gH8N6bdZIETqcjWene9filVNsaE4IvZC3Ky6d0r
 x29UQCeQz0IDRvGFv10iZOgXK9k382BOX6VBQzNPomrftTD/R9xIoxH+32tdZSp0Nuhm
 yXwKHVMalOhNxekR98Tc9fsowVruUM6xkWCHqMwAr0kVXe9qNWMTCtczBA/KNqaCy2uR 0A== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 337eeqr84h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 31 Aug 2020 19:42:16 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07VJaY27181868;
        Mon, 31 Aug 2020 19:40:16 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 3380x157gg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 31 Aug 2020 19:40:15 +0000
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 07VJeFDp005198;
        Mon, 31 Aug 2020 19:40:15 GMT
Received: from localhost (/10.159.252.155)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 31 Aug 2020 12:40:15 -0700
Date:   Mon, 31 Aug 2020 12:40:18 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/5] xfs: store inode btree block counts in AGI header
Message-ID: <20200831194018.GS6096@magnolia>
References: <159858219107.3058056.6897728273666872031.stgit@magnolia>
 <159858219730.3058056.14835592680951054838.stgit@magnolia>
 <20200831190637.GC12035@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200831190637.GC12035@bfoster>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9730 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 phishscore=0
 mlxlogscore=999 adultscore=0 suspectscore=7 bulkscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008310115
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9730 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 clxscore=1015 priorityscore=1501
 lowpriorityscore=0 malwarescore=0 adultscore=0 spamscore=0 mlxscore=0
 phishscore=0 impostorscore=0 mlxlogscore=999 bulkscore=0 suspectscore=7
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008310115
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Aug 31, 2020 at 03:06:37PM -0400, Brian Foster wrote:
> On Thu, Aug 27, 2020 at 07:36:37PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Add a btree block usage counters for both inode btrees to the AGI header
> > so that we don't have to walk the entire finobt at mount time to create
> > the per-AG reservations.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  fs/xfs/libxfs/xfs_ag.c           |    4 ++++
> >  fs/xfs/libxfs/xfs_format.h       |   18 +++++++++++++++++-
> >  fs/xfs/libxfs/xfs_ialloc.c       |    1 +
> >  fs/xfs/libxfs/xfs_ialloc_btree.c |   21 +++++++++++++++++++++
> >  fs/xfs/xfs_ondisk.h              |    2 +-
> >  fs/xfs/xfs_super.c               |    4 ++++
> >  6 files changed, 48 insertions(+), 2 deletions(-)
> > 
> > 
> > diff --git a/fs/xfs/libxfs/xfs_ag.c b/fs/xfs/libxfs/xfs_ag.c
> > index 8cf73fe4338e..65d443c787d0 100644
> > --- a/fs/xfs/libxfs/xfs_ag.c
> > +++ b/fs/xfs/libxfs/xfs_ag.c
> > @@ -333,6 +333,10 @@ xfs_agiblock_init(
> >  	}
> >  	for (bucket = 0; bucket < XFS_AGI_UNLINKED_BUCKETS; bucket++)
> >  		agi->agi_unlinked[bucket] = cpu_to_be32(NULLAGINO);
> > +	if (xfs_sb_version_hasinobtcounts(&mp->m_sb)) {
> > +		agi->agi_iblocks = cpu_to_be32(1);
> > +		agi->agi_fblocks = cpu_to_be32(1);
> > +	}
> 
> With independent tree counters, shouldn't we be checking for hasfinobt()
> for such finobt changes?

DOH.  Yes, it should, now that hasinobtcounts() no longer requires
hasfinobt.  I'll fix that.

> >  }
> >  
> >  typedef void (*aghdr_init_work_f)(struct xfs_mount *mp, struct xfs_buf *bp,
> ...
> > diff --git a/fs/xfs/libxfs/xfs_ialloc_btree.c b/fs/xfs/libxfs/xfs_ialloc_btree.c
> > index 3c8aebc36e64..ee9d407ab9da 100644
> > --- a/fs/xfs/libxfs/xfs_ialloc_btree.c
> > +++ b/fs/xfs/libxfs/xfs_ialloc_btree.c
> > @@ -67,6 +67,25 @@ xfs_finobt_set_root(
> >  			   XFS_AGI_FREE_ROOT | XFS_AGI_FREE_LEVEL);
> >  }
> >  
> > +/* Update the inode btree block counter for this btree. */
> > +static inline void
> > +xfs_inobt_mod_blockcount(
> > +	struct xfs_btree_cur	*cur,
> > +	int			howmuch)
> > +{
> > +	struct xfs_buf		*agbp = cur->bc_ag.agbp;
> > +	struct xfs_agi		*agi = agbp->b_addr;
> > +
> > +	if (!xfs_sb_version_hasinobtcounts(&cur->bc_mp->m_sb))
> > +		return;
> > +
> > +	if (cur->bc_btnum == XFS_BTNUM_FINO)
> > +		be32_add_cpu(&agi->agi_fblocks, howmuch);
> > +	else
> > +		be32_add_cpu(&agi->agi_iblocks, howmuch);
> > +	xfs_ialloc_log_agi(cur->bc_tp, agbp, XFS_AGI_IBLOCKS);
> 
> Similarly, I thought we were going to be logging them separately as
> well..? It seems odd to log an unused field in the finobt=0 case. Hm?

...and that.  Thank you for catching that.

--D

> Brian
> 
> > +}
> > +
> >  STATIC int
> >  __xfs_inobt_alloc_block(
> >  	struct xfs_btree_cur	*cur,
> > @@ -102,6 +121,7 @@ __xfs_inobt_alloc_block(
> >  
> >  	new->s = cpu_to_be32(XFS_FSB_TO_AGBNO(args.mp, args.fsbno));
> >  	*stat = 1;
> > +	xfs_inobt_mod_blockcount(cur, 1);
> >  	return 0;
> >  }
> >  
> > @@ -134,6 +154,7 @@ __xfs_inobt_free_block(
> >  	struct xfs_buf		*bp,
> >  	enum xfs_ag_resv_type	resv)
> >  {
> > +	xfs_inobt_mod_blockcount(cur, -1);
> >  	return xfs_free_extent(cur->bc_tp,
> >  			XFS_DADDR_TO_FSB(cur->bc_mp, XFS_BUF_ADDR(bp)), 1,
> >  			&XFS_RMAP_OINFO_INOBT, resv);
> > diff --git a/fs/xfs/xfs_ondisk.h b/fs/xfs/xfs_ondisk.h
> > index 5f04d8a5ab2a..acb9b737fe6b 100644
> > --- a/fs/xfs/xfs_ondisk.h
> > +++ b/fs/xfs/xfs_ondisk.h
> > @@ -23,7 +23,7 @@ xfs_check_ondisk_structs(void)
> >  	XFS_CHECK_STRUCT_SIZE(struct xfs_acl_entry,		12);
> >  	XFS_CHECK_STRUCT_SIZE(struct xfs_agf,			224);
> >  	XFS_CHECK_STRUCT_SIZE(struct xfs_agfl,			36);
> > -	XFS_CHECK_STRUCT_SIZE(struct xfs_agi,			336);
> > +	XFS_CHECK_STRUCT_SIZE(struct xfs_agi,			344);
> >  	XFS_CHECK_STRUCT_SIZE(struct xfs_bmbt_key,		8);
> >  	XFS_CHECK_STRUCT_SIZE(struct xfs_bmbt_rec,		16);
> >  	XFS_CHECK_STRUCT_SIZE(struct xfs_bmdr_block,		4);
> > diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> > index 71ac6c1cdc36..c7ffcb57b586 100644
> > --- a/fs/xfs/xfs_super.c
> > +++ b/fs/xfs/xfs_super.c
> > @@ -1549,6 +1549,10 @@ xfs_fc_fill_super(
> >  		goto out_filestream_unmount;
> >  	}
> >  
> > +	if (xfs_sb_version_hasinobtcounts(&mp->m_sb))
> > +		xfs_warn(mp,
> > + "EXPERIMENTAL inode btree counters feature in use. Use at your own risk!");
> > +
> >  	error = xfs_mountfs(mp);
> >  	if (error)
> >  		goto out_filestream_unmount;
> > 
> 
