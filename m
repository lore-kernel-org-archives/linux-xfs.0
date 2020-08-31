Return-Path: <SRS0=tsMC=CJ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C7D2C433E2
	for <linux-xfs@archiver.kernel.org>; Mon, 31 Aug 2020 19:40:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DB15F20719
	for <linux-xfs@archiver.kernel.org>; Mon, 31 Aug 2020 19:40:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="KHWyTVF+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728806AbgHaTkn (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 31 Aug 2020 15:40:43 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:49512 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728414AbgHaTkn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 31 Aug 2020 15:40:43 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07VJcwQw086679;
        Mon, 31 Aug 2020 19:40:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=S+XkuGb5q6nBrO7BZVPeFabztmRx3yEU/Ks/trMWtyg=;
 b=KHWyTVF+BVQlD3Po37kM+OOvBQkDiRcryrbPweqZjfNVLD9yZMVtuEW2YK1sC3H/nC5H
 QXgzAOaQMLX2qbjEuNAClLGUTtniDBRvCSgwjwxDfqh0DanaF8e4+OeauS+s3jYGIV6I
 SVrgwJeZoj3WPsTS2PIIkuumDySUXLb7k+b/mI0DZw+mfN6HPsCU/Cr0DeWSBol+2Mva
 c7oOsdVMeugID7b4ic/rpAgNawmvkpsIKwEAA8vRg0s3qiDU4x2uc0aeX+2L0cCUd8Sq
 bP3IHqwpNbZMfT8O9KxVF1J5u6DP9p8LVV72F9fbOPLKPxYzEigIRO1HXmCae4EA6oAm Fg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 337eeqr7vm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 31 Aug 2020 19:40:40 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07VJZBZg090391;
        Mon, 31 Aug 2020 19:40:39 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 3380km4yph-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 31 Aug 2020 19:40:39 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 07VJecNq011531;
        Mon, 31 Aug 2020 19:40:38 GMT
Received: from localhost (/10.159.252.155)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 31 Aug 2020 12:40:38 -0700
Date:   Mon, 31 Aug 2020 12:40:41 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/5] xfs: support inode btree blockcounts in online repair
Message-ID: <20200831194041.GT6096@magnolia>
References: <159858219107.3058056.6897728273666872031.stgit@magnolia>
 <159858221586.3058056.4012330529904111156.stgit@magnolia>
 <20200831190712.GF12035@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200831190712.GF12035@bfoster>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9730 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0 adultscore=0
 mlxscore=0 suspectscore=1 malwarescore=0 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008310115
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9730 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 clxscore=1015 priorityscore=1501
 lowpriorityscore=0 malwarescore=0 adultscore=0 spamscore=0 mlxscore=0
 phishscore=0 impostorscore=0 mlxlogscore=999 bulkscore=0 suspectscore=1
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008310115
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Aug 31, 2020 at 03:07:12PM -0400, Brian Foster wrote:
> On Thu, Aug 27, 2020 at 07:36:55PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Add the necessary bits to the online repair code to support logging the
> > inode btree counters when rebuilding the btrees, and to support fixing
> > the counters when rebuilding the AGI.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  fs/xfs/libxfs/xfs_ialloc_btree.c |   16 +++++++++++++---
> >  fs/xfs/scrub/agheader_repair.c   |   23 +++++++++++++++++++++++
> >  2 files changed, 36 insertions(+), 3 deletions(-)
> > 
> > 
> ...
> > diff --git a/fs/xfs/scrub/agheader_repair.c b/fs/xfs/scrub/agheader_repair.c
> > index bca2ab1d4be9..efa8152a0139 100644
> > --- a/fs/xfs/scrub/agheader_repair.c
> > +++ b/fs/xfs/scrub/agheader_repair.c
> > @@ -810,10 +810,33 @@ xrep_agi_calc_from_btrees(
> >  	error = xfs_ialloc_count_inodes(cur, &count, &freecount);
> >  	if (error)
> >  		goto err;
> > +	if (xfs_sb_version_hasinobtcounts(&mp->m_sb)) {
> > +		xfs_agblock_t	blocks;
> > +
> > +		error = xfs_btree_count_blocks(cur, &blocks);
> > +		if (error)
> > +			goto err;
> > +		agi->agi_iblocks = cpu_to_be32(blocks);
> > +	}
> >  	xfs_btree_del_cursor(cur, error);
> >  
> >  	agi->agi_count = cpu_to_be32(count);
> >  	agi->agi_freecount = cpu_to_be32(freecount);
> > +
> > +	if (xfs_sb_version_hasinobtcounts(&mp->m_sb)) {
> > +		xfs_agblock_t	blocks;
> > +
> > +		cur = xfs_inobt_init_cursor(mp, sc->tp, agi_bp, sc->sa.agno,
> > +				XFS_BTNUM_FINO);
> > +		if (error)
> > +			goto err;
> > +		error = xfs_btree_count_blocks(cur, &blocks);
> > +		if (error)
> > +			goto err;
> > +		xfs_btree_del_cursor(cur, error);
> > +		agi->agi_fblocks = cpu_to_be32(blocks);
> 
> Similar question as for patch 1 around using hasfinobt()...

Yep, and the fix (adding a hasfinobt check) is the same.

--D

> Brian
> 
> > +	}
> > +
> >  	return 0;
> >  err:
> >  	xfs_btree_del_cursor(cur, error);
> > 
> 
