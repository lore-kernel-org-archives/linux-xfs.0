Return-Path: <SRS0=OEwr=77=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C15E6C433E1
	for <linux-xfs@archiver.kernel.org>; Thu, 18 Jun 2020 16:58:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 99D472075E
	for <linux-xfs@archiver.kernel.org>; Thu, 18 Jun 2020 16:58:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="cGr9TcaF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730373AbgFRQ6a (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 18 Jun 2020 12:58:30 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:47150 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730289AbgFRQ63 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 18 Jun 2020 12:58:29 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05IGv7iv042006;
        Thu, 18 Jun 2020 16:58:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=6Val1dPTLO1VGfse1RMsDh+Cbn6oyqPYQ9T1Cl1lp+8=;
 b=cGr9TcaFwjIjS1Yb+dREfN2ss73FJ+hnpUxZckqy6POVa/DhmQpsRB7+zixLfb2g8XVR
 6gnaN1pATwenOxdPPAGAr5toKvb3d4b/t3V3eHuR4WsIV6t1tGyHuydu4cLwLB4w9Ieb
 DNjJXJa1U/J+9k5dyjeuQ4Jlyx1FNgGZhSG3aUtEbim2R01dWMOEjkRls/CflT99y+Qy
 5IYS1jLE0P7nmTm+PQQ7CpxPuoB/7jge3i4bvaRJxM5zRxnc9unAmHQH+30zaty3CZwF
 PWIBJ97d7tN83e/EM4yoV2llOQ3ClKXLTB5wjF4GLlZQX9OdiUFD1pWOANzqwD957fjY 0w== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 31qecm0x4q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 18 Jun 2020 16:58:25 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05IGmRTI187526;
        Thu, 18 Jun 2020 16:56:24 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 31q66b7xeq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 18 Jun 2020 16:56:24 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 05IGuN9b027259;
        Thu, 18 Jun 2020 16:56:24 GMT
Received: from localhost (/10.159.234.138)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 18 Jun 2020 09:56:23 -0700
Date:   Thu, 18 Jun 2020 09:56:22 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 10/12] xfs_repair: rebuild refcount btrees with bulk
 loader
Message-ID: <20200618165622.GX11245@magnolia>
References: <159107201290.315004.4447998785149331259.stgit@magnolia>
 <159107207766.315004.3208486320108630923.stgit@magnolia>
 <20200618152617.GD32216@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200618152617.GD32216@bfoster>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9656 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0
 suspectscore=5 bulkscore=0 adultscore=0 mlxlogscore=999 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2006180127
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9656 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 cotscore=-2147483648 malwarescore=0
 clxscore=1015 adultscore=0 suspectscore=5 spamscore=0 lowpriorityscore=0
 mlxlogscore=999 priorityscore=1501 bulkscore=0 phishscore=0 mlxscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2006180128
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jun 18, 2020 at 11:26:17AM -0400, Brian Foster wrote:
> On Mon, Jun 01, 2020 at 09:27:57PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Use the btree bulk loading functions to rebuild the refcount btrees
> > and drop the open-coded implementation.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  libxfs/libxfs_api_defs.h |    1 
> >  repair/agbtree.c         |   71 ++++++++++
> >  repair/agbtree.h         |    5 +
> >  repair/phase5.c          |  341 ++--------------------------------------------
> >  4 files changed, 93 insertions(+), 325 deletions(-)
> > 
> > 
> ...
> > diff --git a/repair/phase5.c b/repair/phase5.c
> > index 1c6448f4..ad009416 100644
> > --- a/repair/phase5.c
> > +++ b/repair/phase5.c
> ...
> > @@ -817,10 +510,14 @@ build_agf_agfl(
> >  				cpu_to_be32(btr_rmap->newbt.afake.af_blocks);
> >  	}
> >  
> > -	agf->agf_refcount_root = cpu_to_be32(refcnt_bt->root);
> > -	agf->agf_refcount_level = cpu_to_be32(refcnt_bt->num_levels);
> > -	agf->agf_refcount_blocks = cpu_to_be32(refcnt_bt->num_tot_blocks -
> > -			refcnt_bt->num_free_blocks);
> > +	if (xfs_sb_version_hasreflink(&mp->m_sb)) {
> > +		agf->agf_refcount_root =
> > +				cpu_to_be32(btr_refc->newbt.afake.af_root);
> > +		agf->agf_refcount_level =
> > +				cpu_to_be32(btr_refc->newbt.afake.af_levels);
> > +		agf->agf_refcount_blocks =
> > +				cpu_to_be32(btr_refc->newbt.afake.af_blocks);
> > +	}
> 
> It looks like the previous cursor variant (refcnt_bt) would be zeroed
> out if the feature isn't enabled (causing this to zero out the agf
> fields on disk), whereas now we only write the fields when the feature
> is enabled. Any concern over removing that zeroing behavior? Also note
> that an assert further down unconditionally reads the
> ->agf_refcount_root field.
> 
> BTW, I suppose the same question may apply to the previous patch as
> well...

I'll double check, but we do memset the AGF (and AGI) to zero before we
start initializing things, so the asserts should be fine even on
!reflink filesystems.

--D

> Brian
> 
> >  
> >  	/*
> >  	 * Count and record the number of btree blocks consumed if required.
> > @@ -981,7 +678,7 @@ phase5_func(
> >  	struct bt_rebuild	btr_ino;
> >  	struct bt_rebuild	btr_fino;
> >  	struct bt_rebuild	btr_rmap;
> > -	bt_status_t		refcnt_btree_curs;
> > +	struct bt_rebuild	btr_refc;
> >  	int			extra_blocks = 0;
> >  	uint			num_freeblocks;
> >  	xfs_agblock_t		num_extents;
> > @@ -1017,11 +714,7 @@ _("unable to rebuild AG %u.  Not enough free space in on-disk AG.\n"),
> >  
> >  	init_rmapbt_cursor(&sc, agno, num_freeblocks, &btr_rmap);
> >  
> > -	/*
> > -	 * Set up the btree cursors for the on-disk refcount btrees,
> > -	 * which includes pre-allocating all required blocks.
> > -	 */
> > -	init_refc_cursor(mp, agno, &refcnt_btree_curs);
> > +	init_refc_cursor(&sc, agno, num_freeblocks, &btr_refc);
> >  
> >  	num_extents = count_bno_extents_blocks(agno, &num_freeblocks);
> >  	/*
> > @@ -1085,16 +778,14 @@ _("unable to rebuild AG %u.  Not enough free space in on-disk AG.\n"),
> >  		sb_fdblocks_ag[agno] += btr_rmap.newbt.afake.af_blocks - 1;
> >  	}
> >  
> > -	if (xfs_sb_version_hasreflink(&mp->m_sb)) {
> > -		build_refcount_tree(mp, agno, &refcnt_btree_curs);
> > -		write_cursor(&refcnt_btree_curs);
> > -	}
> > +	if (xfs_sb_version_hasreflink(&mp->m_sb))
> > +		build_refcount_tree(&sc, agno, &btr_refc);
> >  
> >  	/*
> >  	 * set up agf and agfl
> >  	 */
> > -	build_agf_agfl(mp, agno, &btr_bno, &btr_cnt, &btr_rmap,
> > -			&refcnt_btree_curs, lost_fsb);
> > +	build_agf_agfl(mp, agno, &btr_bno, &btr_cnt, &btr_rmap, &btr_refc,
> > +			lost_fsb);
> >  
> >  	build_inode_btrees(&sc, agno, &btr_ino, &btr_fino);
> >  
> > @@ -1112,7 +803,7 @@ _("unable to rebuild AG %u.  Not enough free space in on-disk AG.\n"),
> >  	if (xfs_sb_version_hasrmapbt(&mp->m_sb))
> >  		finish_rebuild(mp, &btr_rmap, lost_fsb);
> >  	if (xfs_sb_version_hasreflink(&mp->m_sb))
> > -		finish_cursor(&refcnt_btree_curs);
> > +		finish_rebuild(mp, &btr_refc, lost_fsb);
> >  
> >  	/*
> >  	 * release the incore per-AG bno/bcnt trees so the extent nodes
> > 
> 
