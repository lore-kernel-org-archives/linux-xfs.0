Return-Path: <SRS0=4OPL=YK=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA4BAECE58E
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Oct 2019 15:06:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A47D120820
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Oct 2019 15:06:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="KgHJwuB0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388672AbfJQPGx (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 17 Oct 2019 11:06:53 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:54004 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389795AbfJQPGx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 17 Oct 2019 11:06:53 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9HF6Qt4195728;
        Thu, 17 Oct 2019 15:06:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=sh0tuRei8gKLXqfSbijZeY+P2wB6kJPzYxQ0tnyByJY=;
 b=KgHJwuB0HOv/Ok3WorR2U25qGdKI+uEGBx6KeYBG+OLHxMxtNUWMU3yPPLO2PGn+6vQp
 rKIVhKcRAjK+Xsz1DbFtqD0JMLMifENrOy7u6azTReP8t37YO49mI+61OM70ztjLz4DY
 HXVgUXEPxdYgI9xdoxvh2o2t607YbC5jzhzvoCKZ1q5wUgVMiPAF68LoqlTLezwC2bOQ
 GzEAcaUZjgtuDhfWEcIQALW5sIB8fzN6M5iJruL8NEMjSurOz+iQhmALdRRle2GQKylW
 vMUIKzBxZH3j0Nwm9QcK4ujURgVxBArJVqMwlLxBHuBtbWt+Fs0YZCDmKy00fKWlXsM1 kw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 2vk68uy271-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 17 Oct 2019 15:06:45 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9HF3r43056392;
        Thu, 17 Oct 2019 15:06:44 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 2vpcm338kc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 17 Oct 2019 15:06:44 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x9HF6gAX013919;
        Thu, 17 Oct 2019 15:06:42 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 17 Oct 2019 15:06:42 +0000
Date:   Thu, 17 Oct 2019 08:06:41 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/3] xfs: use deferred frees to reap old btree blocks
Message-ID: <20191017150641.GK13108@magnolia>
References: <157063971218.2913192.8762913814390092382.stgit@magnolia>
 <157063973378.2913192.158267929318422892.stgit@magnolia>
 <20191017125537.GE20114@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191017125537.GE20114@bfoster>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9412 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1910170136
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9412 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1910170137
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Oct 17, 2019 at 08:55:37AM -0400, Brian Foster wrote:
> On Wed, Oct 09, 2019 at 09:48:53AM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Use deferred frees (EFIs) to reap the blocks of a btree that we just
> > replaced.  This helps us to shrink the window in which those old blocks
> > could be lost due to a system crash, though we try to flush the EFIs
> > every few hundred blocks so that we don't also overflow the transaction
> > reservations during and after we commit the new btree.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  fs/xfs/scrub/repair.c |   29 ++++++++++++++++++++++++-----
> >  1 file changed, 24 insertions(+), 5 deletions(-)
> > 
> > 
> > diff --git a/fs/xfs/scrub/repair.c b/fs/xfs/scrub/repair.c
> > index e21faef6db5a..8349694f985d 100644
> > --- a/fs/xfs/scrub/repair.c
> > +++ b/fs/xfs/scrub/repair.c
> ...
> > @@ -565,14 +568,24 @@ xrep_reap_block(
> >  		xrep_reap_invalidate_block(sc, fsbno);
> >  		error = xrep_put_freelist(sc, agbno);
> >  	} else {
> > +		/*
> > +		 * Use deferred frees to get rid of the old btree blocks to try
> > +		 * to minimize the window in which we could crash and lose the
> > +		 * old blocks.  However, we still need to roll the transaction
> > +		 * every 100 or so EFIs so that we don't exceed the log
> > +		 * reservation.
> > +		 */
> >  		xrep_reap_invalidate_block(sc, fsbno);
> > -		error = xfs_free_extent(sc->tp, fsbno, 1, oinfo, resv);
> > +		__xfs_bmap_add_free(sc->tp, fsbno, 1, oinfo, true);
> 
> xfs_free_extent() sets skip_discard to false and this changes it to
> true. Intentional?

Nope.  Will fix this (and the comment in the previous patch).

--D

> Otherwise the rest looks straightforward.
> 
> Brian
> 
> > +		(*deferred)++;
> > +		need_roll = *deferred > 100;
> >  	}
> >  	if (agf_bp != sc->sa.agf_bp)
> >  		xfs_trans_brelse(sc->tp, agf_bp);
> > -	if (error)
> > +	if (error || !need_roll)
> >  		return error;
> >  
> > +	*deferred = 0;
> >  	if (sc->ip)
> >  		return xfs_trans_roll_inode(&sc->tp, sc->ip);
> >  	return xrep_roll_ag_trans(sc);
> > @@ -594,6 +607,7 @@ xrep_reap_extents(
> >  	struct xfs_bitmap_range		*bmr;
> >  	struct xfs_bitmap_range		*n;
> >  	xfs_fsblock_t			fsbno;
> > +	unsigned int			deferred = 0;
> >  	int				error = 0;
> >  
> >  	ASSERT(xfs_sb_version_hasrmapbt(&sc->mp->m_sb));
> > @@ -605,12 +619,17 @@ xrep_reap_extents(
> >  				XFS_FSB_TO_AGNO(sc->mp, fsbno),
> >  				XFS_FSB_TO_AGBNO(sc->mp, fsbno), 1);
> >  
> > -		error = xrep_reap_block(sc, fsbno, oinfo, type);
> > +		error = xrep_reap_block(sc, fsbno, oinfo, type, &deferred);
> >  		if (error)
> >  			break;
> >  	}
> >  
> > -	return error;
> > +	if (error || deferred == 0)
> > +		return error;
> > +
> > +	if (sc->ip)
> > +		return xfs_trans_roll_inode(&sc->tp, sc->ip);
> > +	return xrep_roll_ag_trans(sc);
> >  }
> >  
> >  /*
> > 
