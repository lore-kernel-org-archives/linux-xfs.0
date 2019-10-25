Return-Path: <SRS0=Pn/S=YS=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC084CA9EA0
	for <linux-xfs@archiver.kernel.org>; Fri, 25 Oct 2019 20:23:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AAF1321D81
	for <linux-xfs@archiver.kernel.org>; Fri, 25 Oct 2019 20:23:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="XmPW2BIS"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728221AbfJYUXI (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 25 Oct 2019 16:23:08 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:34220 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728077AbfJYUXI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 25 Oct 2019 16:23:08 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9PKEYP4133788;
        Fri, 25 Oct 2019 20:22:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=VToqfSg4ljMkBqbjO/VbAFYnqt0UECsYRl2SI0fDDA4=;
 b=XmPW2BISoqDEU4/xEClhFBIVfPjyz8U9jjLzGEMS+EyuJkfhmbiiPjwZeW/N9/XUmfQx
 uLEWodc+m4pExb20HontCz43uKqhJwhtcxUnQUiffTu/a4JIlZav91JLpbQyLajj6pLy
 G24nND2gUkhWYrggqLwskXB50+Knpdvgjpyi5ER84edDMZMPTDu9uurRaoX7u3DVoCBW
 i7/rmlAeY601r6QK04VqpEHWrEStaiMTw5W3cZOc1ZNrrRvy3RktQ7yDupdpDcBEbhzB
 Ktn5UHu+tgI5AeeeBCIo4kXJ3HCe7zLd/rA1M2OT1k12hKrO8UKMoU6MH+NGQkS3qkra kw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 2vqswu5gtd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 25 Oct 2019 20:22:49 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9PKJFvg050676;
        Fri, 25 Oct 2019 20:22:49 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 2vuun24t1j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 25 Oct 2019 20:22:49 +0000
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x9PKMllE005455;
        Fri, 25 Oct 2019 20:22:48 GMT
Received: from localhost (/10.145.178.128)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 25 Oct 2019 13:22:47 -0700
Date:   Fri, 25 Oct 2019 13:22:44 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/3] xfs: only invalidate blocks if we're going to free
 them
Message-ID: <20191025202244.GQ913374@magnolia>
References: <157063971218.2913192.8762913814390092382.stgit@magnolia>
 <157063972723.2913192.12835516373692425243.stgit@magnolia>
 <20191017125512.GD20114@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191017125512.GD20114@bfoster>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9421 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1910250185
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9421 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1910250185
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Oct 17, 2019 at 08:55:12AM -0400, Brian Foster wrote:
> On Wed, Oct 09, 2019 at 09:48:47AM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > When we're discarding old btree blocks after a repair, only invalidate
> > the buffers for the ones that we're freeing -- if the metadata was
> > crosslinked with another data structure, we don't want to touch it.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  fs/xfs/scrub/repair.c |   76 +++++++++++++++++++++++--------------------------
> >  fs/xfs/scrub/repair.h |    1 -
> >  2 files changed, 35 insertions(+), 42 deletions(-)
> > 
> > 
> > diff --git a/fs/xfs/scrub/repair.c b/fs/xfs/scrub/repair.c
> > index 3a58788e0bd8..e21faef6db5a 100644
> > --- a/fs/xfs/scrub/repair.c
> > +++ b/fs/xfs/scrub/repair.c
> ...
> > @@ -515,6 +477,35 @@ xrep_put_freelist(
> >  	return 0;
> >  }
> >  
> > +/* Try to invalidate the incore buffer for a block that we're about to free. */
> > +STATIC void
> > +xrep_reap_invalidate_block(
> > +	struct xfs_scrub	*sc,
> > +	xfs_fsblock_t		fsbno)
> > +{
> > +	struct xfs_buf		*bp;
> > +
> > +	/*
> > +	 * For each block in each extent, see if there's an incore buffer for
> > +	 * exactly that block; if so, invalidate it.  The buffer cache only
> > +	 * lets us look for one buffer at a time, so we have to look one block
> > +	 * at a time.  Avoid invalidating AG headers and post-EOFS blocks
> > +	 * because we never own those; and if we can't TRYLOCK the buffer we
> > +	 * assume it's owned by someone else.
> > +	 */
> > +	/* Skip AG headers and post-EOFS blocks */
> 
> The comment doesn't seem to quite go with the implementation any longer.
> Also, there's probably no need to have two separate comments here.
> Otherwise looks Ok.

<nod> Fixed.

--D

> Brian
> 
> > +	if (!xfs_verify_fsbno(sc->mp, fsbno))
> > +		return;
> > +	bp = xfs_buf_incore(sc->mp->m_ddev_targp,
> > +			XFS_FSB_TO_DADDR(sc->mp, fsbno),
> > +			XFS_FSB_TO_BB(sc->mp, 1), XBF_TRYLOCK);
> > +	if (!bp)
> > +		return;
> > +
> > +	xfs_trans_bjoin(sc->tp, bp);
> > +	xfs_trans_binval(sc->tp, bp);
> > +}
> > +
> >  /* Dispose of a single block. */
> >  STATIC int
> >  xrep_reap_block(
> > @@ -568,12 +559,15 @@ xrep_reap_block(
> >  	 * blow on writeout, the filesystem will shut down, and the admin gets
> >  	 * to run xfs_repair.
> >  	 */
> > -	if (has_other_rmap)
> > +	if (has_other_rmap) {
> >  		error = xfs_rmap_free(sc->tp, agf_bp, agno, agbno, 1, oinfo);
> > -	else if (resv == XFS_AG_RESV_AGFL)
> > +	} else if (resv == XFS_AG_RESV_AGFL) {
> > +		xrep_reap_invalidate_block(sc, fsbno);
> >  		error = xrep_put_freelist(sc, agbno);
> > -	else
> > +	} else {
> > +		xrep_reap_invalidate_block(sc, fsbno);
> >  		error = xfs_free_extent(sc->tp, fsbno, 1, oinfo, resv);
> > +	}
> >  	if (agf_bp != sc->sa.agf_bp)
> >  		xfs_trans_brelse(sc->tp, agf_bp);
> >  	if (error)
> > diff --git a/fs/xfs/scrub/repair.h b/fs/xfs/scrub/repair.h
> > index 60c61d7052a8..eab41928990f 100644
> > --- a/fs/xfs/scrub/repair.h
> > +++ b/fs/xfs/scrub/repair.h
> > @@ -31,7 +31,6 @@ int xrep_init_btblock(struct xfs_scrub *sc, xfs_fsblock_t fsb,
> >  struct xfs_bitmap;
> >  
> >  int xrep_fix_freelist(struct xfs_scrub *sc, bool can_shrink);
> > -int xrep_invalidate_blocks(struct xfs_scrub *sc, struct xfs_bitmap *btlist);
> >  int xrep_reap_extents(struct xfs_scrub *sc, struct xfs_bitmap *exlist,
> >  		const struct xfs_owner_info *oinfo, enum xfs_ag_resv_type type);
> >  
> > 
