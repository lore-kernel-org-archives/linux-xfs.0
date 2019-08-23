Return-Path: <SRS0=lWMA=WT=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33077C3A5A2
	for <linux-xfs@archiver.kernel.org>; Fri, 23 Aug 2019 15:24:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EFC432133F
	for <linux-xfs@archiver.kernel.org>; Fri, 23 Aug 2019 15:24:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Ry+KkJ2h"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404978AbfHWPYI (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 23 Aug 2019 11:24:08 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:52460 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726899AbfHWPYI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 23 Aug 2019 11:24:08 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7NExgfe147400;
        Fri, 23 Aug 2019 15:23:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=0UOacI7mN/G9HLP7fPSyux293L60sdOWAuhcfy5v67k=;
 b=Ry+KkJ2h7lZu47EGTnKQMcJ4IWxULcoY99iNdgXstYzC0Yav22WSceVwOgn8dqNsJgs3
 YSAiHevEbq/bUCwN7bgvzz7ulXPl6ZJUgW84aQQvGmpBOva2VnukfJbkYC4mc96bjL//
 zIH2iM5IzsR5sKbw9F/0JXix1O/RWs5+2lTOPEL91H7ttghPMkH9bKa44aDCDgjLU31A
 oWDB3wivq9BEGnS9nIhmpo45hTduIk/wdtnLZLv9yYY1PKi4pLyiXuLCheKnVvd2Gc8k
 IOyW8HNaZ2e7eMYroX1Zul2YosIfH47yhP9xaif480m6aKWrVCBP7zucs+UeJuJYK473 2w== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 2ue9hq5bp1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 23 Aug 2019 15:23:52 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7NF3fXX045232;
        Fri, 23 Aug 2019 15:23:51 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 2ujhvca0k8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 23 Aug 2019 15:23:51 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x7NFNoIR015301;
        Fri, 23 Aug 2019 15:23:50 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 23 Aug 2019 08:23:50 -0700
Date:   Fri, 23 Aug 2019 08:23:49 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs: bmap scrub should only scrub records once
Message-ID: <20190823152349.GJ1037350@magnolia>
References: <20190817020651.GH752159@magnolia>
 <20190823150221.GB54025@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190823150221.GB54025@bfoster>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9358 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1908230157
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9358 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908230157
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Aug 23, 2019 at 11:02:21AM -0400, Brian Foster wrote:
> On Fri, Aug 16, 2019 at 07:06:51PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > The inode block mapping scrub function does more work for btree format
> > extent maps than is absolutely necessary -- first it will walk the bmbt
> > and check all the entries, and then it will load the incore tree and
> > check every entry in that tree.
> > 
> > Reduce the run time of the ondisk bmbt walk if the incore tree is loaded
> > by checking that the incore tree has an exact match for the bmbt extent.
> > Similarly, skip the incore tree walk if we have to load it from the
> > bmbt, since we just checked that.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  fs/xfs/scrub/bmap.c |   40 +++++++++++++++++++++++++++++++++++++---
> >  1 file changed, 37 insertions(+), 3 deletions(-)
> > 
> > diff --git a/fs/xfs/scrub/bmap.c b/fs/xfs/scrub/bmap.c
> > index 1bd29fdc2ab5..6170736fa94f 100644
> > --- a/fs/xfs/scrub/bmap.c
> > +++ b/fs/xfs/scrub/bmap.c
> > @@ -384,6 +384,7 @@ xchk_bmapbt_rec(
> >  	struct xfs_inode	*ip = bs->cur->bc_private.b.ip;
> >  	struct xfs_buf		*bp = NULL;
> >  	struct xfs_btree_block	*block;
> > +	struct xfs_ifork	*ifp = XFS_IFORK_PTR(ip, info->whichfork);
> >  	uint64_t		owner;
> >  	int			i;
> >  
> > @@ -402,8 +403,30 @@ xchk_bmapbt_rec(
> >  		}
> >  	}
> >  
> > -	/* Set up the in-core record and scrub it. */
> > +	/*
> > +	 * If the incore bmap cache is already loaded, check that it contains
> > +	 * an extent that matches this one exactly.  We validate those cached
> > +	 * bmaps later, so we don't need to check here.
> > +	 *
> > +	 * If the cache is /not/ loaded, we need to validate the bmbt records
> > +	 * now.
> > +	 */
> >  	xfs_bmbt_disk_get_all(&rec->bmbt, &irec);
> > +        if (ifp->if_flags & XFS_IFEXTENTS) {
> 
> ^ looks like whitespace damage right here.

Oops.  Fixed.

> > +		struct xfs_bmbt_irec	iext_irec;
> > +		struct xfs_iext_cursor	icur;
> > +
> > +		if (!xfs_iext_lookup_extent(ip, ifp, irec.br_startoff, &icur,
> > +					&iext_irec) ||
> > +		    irec.br_startoff != iext_irec.br_startoff ||
> > +		    irec.br_startblock != iext_irec.br_startblock ||
> > +		    irec.br_blockcount != iext_irec.br_blockcount ||
> > +		    irec.br_state != iext_irec.br_state)
> > +			xchk_fblock_set_corrupt(bs->sc, info->whichfork,
> > +					irec.br_startoff);
> > +		return 0;
> > +	}
> > +
> 
> Ok, so right now the bmbt walk makes no consideration of in-core state.
> With this change, we correlate every on-disk record with an in-core
> counterpart (if cached) and skip the additional extent checks...
> 
> >  	return xchk_bmap_extent(ip, bs->cur, info, &irec);
> >  }
> >  
> > @@ -671,11 +694,22 @@ xchk_bmap(
> >  	if (sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT)
> >  		goto out;
> >  
> > -	/* Now try to scrub the in-memory extent list. */
> > +	/*
> > +	 * If the incore bmap cache isn't loaded, then this inode has a bmap
> > +	 * btree and we already walked it to check all of the mappings.  Load
> > +	 * the cache now and skip ahead to rmap checking (which requires the
> > +	 * bmap cache to be loaded).  We don't need to check twice.
> > +	 *
> > +	 * If the cache /is/ loaded, then we haven't checked any mappings, so
> > +	 * iterate the incore cache and check the mappings now, because the
> > +	 * bmbt iteration code skipped the checks, assuming that we'd do them
> > +	 * here.
> > +	 */
> >          if (!(ifp->if_flags & XFS_IFEXTENTS)) {
> >  		error = xfs_iread_extents(sc->tp, ip, whichfork);
> >  		if (!xchk_fblock_process_error(sc, whichfork, 0, &error))
> >  			goto out;
> > +		goto out_check_rmap;
> 
> ... because we end up doing that here. Otherwise, the bmbt walk did the
> extent checks, so we can skip it here.

Yep.  On the stress test case (which is bmapbtd checking of mdrestore'd
sparse images of large filesystems), only doing the extent walk + check
once can cut down the runtime by ~30%.

> I think I follow, but I'm a little confused by the need for such split
> logic when we follow up with an unconditional read of the extent tree
> anyways. Maybe I'm missing something, but couldn't we just read the
> extent tree a little earlier and always do the extent checks in one
> place?

The original goal was that if the extent cache isn't loaded, we want to
check the bmbt records before we even bother to call xfs_iread_extents,
so that someone could find out from the trace data exactly where in the
bmbt was the corruption found.

Granted, since we're reducing the scrub code to the bare minimum needed
to decide if something's good or bad due to the primary interface being
a bit field... I could unconditionally load the extent map earlier,
unconditionally check the iext records, and then the bmbt walk only
needs to check that the tree shape is ok and that each bmbt record
corresponds to an iext record.

The other way to go would be to convert xchk_bmap_check_rmaps to use a
bmbt cursor if the iext isn't loaded, in which case we wouldn't need to
load the iext cache at all.  That would reduce the kernel slab
perturbations at a cost of extra code complexity.

Thoughts?

--D

> Brian
> 
> >  	}
> >  
> >  	/* Find the offset of the last extent in the mapping. */
> > @@ -689,7 +723,7 @@ xchk_bmap(
> >  	for_each_xfs_iext(ifp, &icur, &irec) {
> >  		if (xchk_should_terminate(sc, &error) ||
> >  		    (sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT))
> > -			break;
> > +			goto out;
> >  		if (isnullstartblock(irec.br_startblock))
> >  			continue;
> >  		if (irec.br_startoff >= endoff) {
