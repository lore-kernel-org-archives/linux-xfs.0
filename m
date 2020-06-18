Return-Path: <SRS0=OEwr=77=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8379C433DF
	for <linux-xfs@archiver.kernel.org>; Thu, 18 Jun 2020 16:54:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 87A05208C3
	for <linux-xfs@archiver.kernel.org>; Thu, 18 Jun 2020 16:54:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="EXdFzlQj"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728090AbgFRQyc (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 18 Jun 2020 12:54:32 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:39656 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727882AbgFRQyb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 18 Jun 2020 12:54:31 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05IGlVLE194518;
        Thu, 18 Jun 2020 16:54:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=T2ECB5lTeuHsKtuYX98al9WqaEP6e2NXUhvS3eoAkrQ=;
 b=EXdFzlQjXBjwDJk/2uzBesk9wrp5nXcWYm1V0uOuTFAFfuzvuP326gZ0QZZTGMKrI6UV
 FF9gyFJbTXQM06Ta5AQhk7k+6uNm9jRn3l1htrlg6NgiQAPwx13n75GoPrP9wbHv4zzN
 DPYPnA8oeDXeVxtAqDWQs/YKgPXhHXkcY8nl6WaPVoGigR+t6wdXtfd4t7ERW7MoUq4W
 YwZLyKqY0QBm3jSwKMbV8ZBhW4ZIK2g+sA5ksCdjY5cON4VXxhSz+5goof6vhOe70MCQ
 wJLnY513tZPvbgsR7X0wTly34JZ8uhsauE/Sp9nuvUL8ef38XLwZPiyU2XDoCOc7YIfk jA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 31qg358anh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 18 Jun 2020 16:54:27 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05IGnECK136001;
        Thu, 18 Jun 2020 16:54:26 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 31q66q2he4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 18 Jun 2020 16:54:26 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 05IGsPti026267;
        Thu, 18 Jun 2020 16:54:25 GMT
Received: from localhost (/10.159.234.138)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 18 Jun 2020 09:54:25 -0700
Date:   Thu, 18 Jun 2020 09:54:24 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 09/12] xfs_repair: rebuild reverse mapping btrees with
 bulk loader
Message-ID: <20200618165424.GW11245@magnolia>
References: <159107201290.315004.4447998785149331259.stgit@magnolia>
 <159107207124.315004.2948634653215669449.stgit@magnolia>
 <20200618152511.GC32216@bfoster>
 <20200618153100.GG11255@magnolia>
 <20200618153740.GE32216@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200618153740.GE32216@bfoster>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9656 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0 phishscore=0
 mlxscore=0 bulkscore=0 malwarescore=0 mlxlogscore=999 suspectscore=5
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006180127
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9656 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0 mlxscore=0
 clxscore=1015 malwarescore=0 impostorscore=0 adultscore=0
 cotscore=-2147483648 lowpriorityscore=0 mlxlogscore=999 spamscore=0
 suspectscore=5 priorityscore=1501 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2006180127
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jun 18, 2020 at 11:37:40AM -0400, Brian Foster wrote:
> On Thu, Jun 18, 2020 at 08:31:00AM -0700, Darrick J. Wong wrote:
> > On Thu, Jun 18, 2020 at 11:25:11AM -0400, Brian Foster wrote:
> > > On Mon, Jun 01, 2020 at 09:27:51PM -0700, Darrick J. Wong wrote:
> > > > From: Darrick J. Wong <darrick.wong@oracle.com>
> > > > 
> > > > Use the btree bulk loading functions to rebuild the reverse mapping
> > > > btrees and drop the open-coded implementation.
> > > > 
> > > > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > > > ---
> > > >  libxfs/libxfs_api_defs.h |    1 
> > > >  repair/agbtree.c         |   70 ++++++++
> > > >  repair/agbtree.h         |    5 +
> > > >  repair/phase5.c          |  409 ++--------------------------------------------
> > > >  4 files changed, 96 insertions(+), 389 deletions(-)
> > > > 
> > > > 
> > > ...
> > > > diff --git a/repair/phase5.c b/repair/phase5.c
> > > > index e570349d..1c6448f4 100644
> > > > --- a/repair/phase5.c
> > > > +++ b/repair/phase5.c
> > > ...
> > > > @@ -1244,6 +879,8 @@ build_agf_agfl(
> > > >  	freelist = xfs_buf_to_agfl_bno(agfl_buf);
> > > >  	fill_agfl(btr_bno, freelist, &agfl_idx);
> > > >  	fill_agfl(btr_cnt, freelist, &agfl_idx);
> > > > +	if (xfs_sb_version_hasrmapbt(&mp->m_sb))
> > > > +		fill_agfl(btr_rmap, freelist, &agfl_idx);
> > > 
> > > Is this new behavior? Either way, I guess it makes sense since the
> > > rmapbt feeds from/to the agfl:
> > 
> > It's a defensive move to make sure we don't lose the blocks if we
> > overestimate the size of the rmapbt.  We never did in the past (and we
> > shouldn't now) but I figured I should throw that in as a defensive
> > measure so we don't leak the blocks if something goes wrong.
> > 
> > (Granted, I think in the past any overages would have been freed back
> > into the filesystem...)
> > 
> 
> I thought that was still the case since finish_rebuild() moves any
> unused blocks over to the lost_fsb slab, which is why I was asking about
> the agfl filling specifically..

Ah, right.  Ok.  I'll add a note to the commit message about how now we
feed unused rmapbt blocks back to the AGFL, similar to how we would in
regular operation.

--D

> Brian
> 
> > Thanks for the review.
> > 
> > --D
> > 
> > > Reviewed-by: Brian Foster <bfoster@redhat.com>
> > > 
> > > >  
> > > >  	/* Set the AGF counters for the AGFL. */
> > > >  	if (agfl_idx > 0) {
> > > > @@ -1343,7 +980,7 @@ phase5_func(
> > > >  	struct bt_rebuild	btr_cnt;
> > > >  	struct bt_rebuild	btr_ino;
> > > >  	struct bt_rebuild	btr_fino;
> > > > -	bt_status_t		rmap_btree_curs;
> > > > +	struct bt_rebuild	btr_rmap;
> > > >  	bt_status_t		refcnt_btree_curs;
> > > >  	int			extra_blocks = 0;
> > > >  	uint			num_freeblocks;
> > > > @@ -1378,11 +1015,7 @@ _("unable to rebuild AG %u.  Not enough free space in on-disk AG.\n"),
> > > >  	init_ino_cursors(&sc, agno, num_freeblocks, &sb_icount_ag[agno],
> > > >  			&sb_ifree_ag[agno], &btr_ino, &btr_fino);
> > > >  
> > > > -	/*
> > > > -	 * Set up the btree cursors for the on-disk rmap btrees, which includes
> > > > -	 * pre-allocating all required blocks.
> > > > -	 */
> > > > -	init_rmapbt_cursor(mp, agno, &rmap_btree_curs);
> > > > +	init_rmapbt_cursor(&sc, agno, num_freeblocks, &btr_rmap);
> > > >  
> > > >  	/*
> > > >  	 * Set up the btree cursors for the on-disk refcount btrees,
> > > > @@ -1448,10 +1081,8 @@ _("unable to rebuild AG %u.  Not enough free space in on-disk AG.\n"),
> > > >  	ASSERT(btr_bno.freeblks == btr_cnt.freeblks);
> > > >  
> > > >  	if (xfs_sb_version_hasrmapbt(&mp->m_sb)) {
> > > > -		build_rmap_tree(mp, agno, &rmap_btree_curs);
> > > > -		write_cursor(&rmap_btree_curs);
> > > > -		sb_fdblocks_ag[agno] += (rmap_btree_curs.num_tot_blocks -
> > > > -				rmap_btree_curs.num_free_blocks) - 1;
> > > > +		build_rmap_tree(&sc, agno, &btr_rmap);
> > > > +		sb_fdblocks_ag[agno] += btr_rmap.newbt.afake.af_blocks - 1;
> > > >  	}
> > > >  
> > > >  	if (xfs_sb_version_hasreflink(&mp->m_sb)) {
> > > > @@ -1462,7 +1093,7 @@ _("unable to rebuild AG %u.  Not enough free space in on-disk AG.\n"),
> > > >  	/*
> > > >  	 * set up agf and agfl
> > > >  	 */
> > > > -	build_agf_agfl(mp, agno, &btr_bno, &btr_cnt, &rmap_btree_curs,
> > > > +	build_agf_agfl(mp, agno, &btr_bno, &btr_cnt, &btr_rmap,
> > > >  			&refcnt_btree_curs, lost_fsb);
> > > >  
> > > >  	build_inode_btrees(&sc, agno, &btr_ino, &btr_fino);
> > > > @@ -1479,7 +1110,7 @@ _("unable to rebuild AG %u.  Not enough free space in on-disk AG.\n"),
> > > >  	if (xfs_sb_version_hasfinobt(&mp->m_sb))
> > > >  		finish_rebuild(mp, &btr_fino, lost_fsb);
> > > >  	if (xfs_sb_version_hasrmapbt(&mp->m_sb))
> > > > -		finish_cursor(&rmap_btree_curs);
> > > > +		finish_rebuild(mp, &btr_rmap, lost_fsb);
> > > >  	if (xfs_sb_version_hasreflink(&mp->m_sb))
> > > >  		finish_cursor(&refcnt_btree_curs);
> > > >  
> > > > 
> > > 
> > 
> 
