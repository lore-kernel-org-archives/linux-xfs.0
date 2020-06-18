Return-Path: <SRS0=OEwr=77=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F97EC433E0
	for <linux-xfs@archiver.kernel.org>; Thu, 18 Jun 2020 15:33:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0BEDE208B8
	for <linux-xfs@archiver.kernel.org>; Thu, 18 Jun 2020 15:33:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="IiIuHdh1"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728269AbgFRPdJ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 18 Jun 2020 11:33:09 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:59988 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728113AbgFRPdJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 18 Jun 2020 11:33:09 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05IFVVD1057196;
        Thu, 18 Jun 2020 15:33:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=vc1XxnUpd1k1nFxLCfdei0oAX6Oj8s9UnkaUyRhcigw=;
 b=IiIuHdh1fIYAfdKXpyxkL1pkThHJFtEEoPiKsOQOYyDNzcWWH8yuNpsQuvsyCHi+haVF
 UPh8Kf2rO7S2kW2BJf3XU14lVyp4Y0pmhmIs8Zm85I0Q2/+iFmuBlvw7xG5B6bwtSk/h
 mN+kFnSP78zbbSvQIiBl+TquUfsZA9dNyYOZX6vxakCxg8UX2nDaUJguD/ei/IsJXRWI
 i7mi33RMhdBlAP6k1zCO0w7qOek7hfjdCWrC0yac3qtdQB7fXgDkZHctW6iTFxoh/tMV
 JzrLtnYGWT6xU8MpyAZd/y4jB1AUrJ7hoSUu7Hy2kYEgrOZ7hmRKSP6jxy90NTuUiYkN mA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 31qg357vrw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 18 Jun 2020 15:33:04 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05IFRqQN176445;
        Thu, 18 Jun 2020 15:31:04 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 31q660x31q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 18 Jun 2020 15:31:04 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 05IFV2b9017042;
        Thu, 18 Jun 2020 15:31:02 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 18 Jun 2020 08:31:02 -0700
Date:   Thu, 18 Jun 2020 08:31:00 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 09/12] xfs_repair: rebuild reverse mapping btrees with
 bulk loader
Message-ID: <20200618153100.GG11255@magnolia>
References: <159107201290.315004.4447998785149331259.stgit@magnolia>
 <159107207124.315004.2948634653215669449.stgit@magnolia>
 <20200618152511.GC32216@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200618152511.GC32216@bfoster>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9656 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 spamscore=0
 phishscore=0 bulkscore=0 malwarescore=0 mlxscore=0 adultscore=0
 suspectscore=5 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2006180117
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9656 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0 mlxscore=0
 clxscore=1015 malwarescore=0 impostorscore=0 adultscore=0
 cotscore=-2147483648 lowpriorityscore=0 mlxlogscore=999 spamscore=0
 suspectscore=5 priorityscore=1501 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2006180118
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jun 18, 2020 at 11:25:11AM -0400, Brian Foster wrote:
> On Mon, Jun 01, 2020 at 09:27:51PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Use the btree bulk loading functions to rebuild the reverse mapping
> > btrees and drop the open-coded implementation.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  libxfs/libxfs_api_defs.h |    1 
> >  repair/agbtree.c         |   70 ++++++++
> >  repair/agbtree.h         |    5 +
> >  repair/phase5.c          |  409 ++--------------------------------------------
> >  4 files changed, 96 insertions(+), 389 deletions(-)
> > 
> > 
> ...
> > diff --git a/repair/phase5.c b/repair/phase5.c
> > index e570349d..1c6448f4 100644
> > --- a/repair/phase5.c
> > +++ b/repair/phase5.c
> ...
> > @@ -1244,6 +879,8 @@ build_agf_agfl(
> >  	freelist = xfs_buf_to_agfl_bno(agfl_buf);
> >  	fill_agfl(btr_bno, freelist, &agfl_idx);
> >  	fill_agfl(btr_cnt, freelist, &agfl_idx);
> > +	if (xfs_sb_version_hasrmapbt(&mp->m_sb))
> > +		fill_agfl(btr_rmap, freelist, &agfl_idx);
> 
> Is this new behavior? Either way, I guess it makes sense since the
> rmapbt feeds from/to the agfl:

It's a defensive move to make sure we don't lose the blocks if we
overestimate the size of the rmapbt.  We never did in the past (and we
shouldn't now) but I figured I should throw that in as a defensive
measure so we don't leak the blocks if something goes wrong.

(Granted, I think in the past any overages would have been freed back
into the filesystem...)

Thanks for the review.

--D

> Reviewed-by: Brian Foster <bfoster@redhat.com>
> 
> >  
> >  	/* Set the AGF counters for the AGFL. */
> >  	if (agfl_idx > 0) {
> > @@ -1343,7 +980,7 @@ phase5_func(
> >  	struct bt_rebuild	btr_cnt;
> >  	struct bt_rebuild	btr_ino;
> >  	struct bt_rebuild	btr_fino;
> > -	bt_status_t		rmap_btree_curs;
> > +	struct bt_rebuild	btr_rmap;
> >  	bt_status_t		refcnt_btree_curs;
> >  	int			extra_blocks = 0;
> >  	uint			num_freeblocks;
> > @@ -1378,11 +1015,7 @@ _("unable to rebuild AG %u.  Not enough free space in on-disk AG.\n"),
> >  	init_ino_cursors(&sc, agno, num_freeblocks, &sb_icount_ag[agno],
> >  			&sb_ifree_ag[agno], &btr_ino, &btr_fino);
> >  
> > -	/*
> > -	 * Set up the btree cursors for the on-disk rmap btrees, which includes
> > -	 * pre-allocating all required blocks.
> > -	 */
> > -	init_rmapbt_cursor(mp, agno, &rmap_btree_curs);
> > +	init_rmapbt_cursor(&sc, agno, num_freeblocks, &btr_rmap);
> >  
> >  	/*
> >  	 * Set up the btree cursors for the on-disk refcount btrees,
> > @@ -1448,10 +1081,8 @@ _("unable to rebuild AG %u.  Not enough free space in on-disk AG.\n"),
> >  	ASSERT(btr_bno.freeblks == btr_cnt.freeblks);
> >  
> >  	if (xfs_sb_version_hasrmapbt(&mp->m_sb)) {
> > -		build_rmap_tree(mp, agno, &rmap_btree_curs);
> > -		write_cursor(&rmap_btree_curs);
> > -		sb_fdblocks_ag[agno] += (rmap_btree_curs.num_tot_blocks -
> > -				rmap_btree_curs.num_free_blocks) - 1;
> > +		build_rmap_tree(&sc, agno, &btr_rmap);
> > +		sb_fdblocks_ag[agno] += btr_rmap.newbt.afake.af_blocks - 1;
> >  	}
> >  
> >  	if (xfs_sb_version_hasreflink(&mp->m_sb)) {
> > @@ -1462,7 +1093,7 @@ _("unable to rebuild AG %u.  Not enough free space in on-disk AG.\n"),
> >  	/*
> >  	 * set up agf and agfl
> >  	 */
> > -	build_agf_agfl(mp, agno, &btr_bno, &btr_cnt, &rmap_btree_curs,
> > +	build_agf_agfl(mp, agno, &btr_bno, &btr_cnt, &btr_rmap,
> >  			&refcnt_btree_curs, lost_fsb);
> >  
> >  	build_inode_btrees(&sc, agno, &btr_ino, &btr_fino);
> > @@ -1479,7 +1110,7 @@ _("unable to rebuild AG %u.  Not enough free space in on-disk AG.\n"),
> >  	if (xfs_sb_version_hasfinobt(&mp->m_sb))
> >  		finish_rebuild(mp, &btr_fino, lost_fsb);
> >  	if (xfs_sb_version_hasrmapbt(&mp->m_sb))
> > -		finish_cursor(&rmap_btree_curs);
> > +		finish_rebuild(mp, &btr_rmap, lost_fsb);
> >  	if (xfs_sb_version_hasreflink(&mp->m_sb))
> >  		finish_cursor(&refcnt_btree_curs);
> >  
> > 
> 
