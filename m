Return-Path: <SRS0=guuR=DN=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9FC91C41604
	for <linux-xfs@archiver.kernel.org>; Tue,  6 Oct 2020 04:29:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 329C2208C7
	for <linux-xfs@archiver.kernel.org>; Tue,  6 Oct 2020 04:29:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="O+eSt6cp"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726065AbgJFE3i (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 6 Oct 2020 00:29:38 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:51514 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725945AbgJFE3i (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 6 Oct 2020 00:29:38 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0964OPfv094253;
        Tue, 6 Oct 2020 04:29:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=jd3feFw+K5UZbq29xf7azwYCUT3vXFMCWFf6GB1N01w=;
 b=O+eSt6cp48BDASYxIZwsnSr8x5Oe6pEwCWgTrB+ZAMgcGXaaWwgW5j1CBj7o4xy1ZprZ
 2enkLeJBxVTJbZ2bD9apJxF+09j8C4UScSysuRaIb6fnDXLhfIcz7cr5TL/DJOXZNOFz
 wQnjk0ArCmC6PPmQcdYrt5Bu2y4BKkB8yQD3IgzmhMyG4qvu1DU6TRT0cOQhOiILNeLK
 bFcwk0svSO2d+4lm4Q65IGmB/65MZy6yENOYMdBs/fuvB6h60fKzsjlgWpqEkI0V1/p7
 mtAlE6JL/57cCYsktOYKGQ7kekV2nQjSpH1NRXhBrFiE8VvcVADw/ida/4q1LE8gCiBj Og== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2130.oracle.com with ESMTP id 33xetasxuv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 06 Oct 2020 04:29:35 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0964OlSQ063411;
        Tue, 6 Oct 2020 04:27:35 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 33y36xejya-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 06 Oct 2020 04:27:35 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0964RYIu019094;
        Tue, 6 Oct 2020 04:27:34 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 05 Oct 2020 21:27:33 -0700
Date:   Mon, 5 Oct 2020 21:27:32 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Chandan Babu R <chandanrlinux@gmail.com>
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com
Subject: Re: [PATCH V5 12/12] xfs: Introduce error injection to allocate only
 minlen size extents for files
Message-ID: <20201006042732.GR49547@magnolia>
References: <20201003055633.9379-1-chandanrlinux@gmail.com>
 <20201003055633.9379-13-chandanrlinux@gmail.com>
 <2322881.G0kAUReszQ@garuda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2322881.G0kAUReszQ@garuda>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9765 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 bulkscore=0 spamscore=0 malwarescore=0 suspectscore=7 phishscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2010060025
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9765 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 mlxscore=0
 clxscore=1015 priorityscore=1501 adultscore=0 mlxlogscore=999 phishscore=0
 impostorscore=0 malwarescore=0 suspectscore=7 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2010060025
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Oct 06, 2020 at 09:55:03AM +0530, Chandan Babu R wrote:
> On Saturday 3 October 2020 11:26:33 AM IST Chandan Babu R wrote:
> > This commit adds XFS_ERRTAG_BMAP_ALLOC_MINLEN_EXTENT error tag which
> > helps userspace test programs to get xfs_bmap_btalloc() to always
> > allocate minlen sized extents.
> > 
> > This is required for test programs which need a guarantee that minlen
> > extents allocated for a file do not get merged with their existing
> > neighbours in the inode's BMBT. "Inode fork extent overflow check" for
> > Directories, Xattrs and extension of realtime inodes need this since the
> > file offset at which the extents are being allocated cannot be
> > explicitly controlled from userspace.
> > 
> > One way to use this error tag is to,
> > 1. Consume all of the free space by sequentially writing to a file.
> > 2. Punch alternate blocks of the file. This causes CNTBT to contain
> >    sufficient number of one block sized extent records.
> > 3. Inject XFS_ERRTAG_BMAP_ALLOC_MINLEN_EXTENT error tag.
> > After step 3, xfs_bmap_btalloc() will issue space allocation
> > requests for minlen sized extents only.
> > 
> > ENOSPC error code is returned to userspace when there aren't any "one
> > block sized" extents left in any of the AGs.
> > 
> > Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
> > ---
> >  fs/xfs/libxfs/xfs_alloc.c    | 46 ++++++++++++++++++++++++++++++++++++
> >  fs/xfs/libxfs/xfs_alloc.h    |  1 +
> >  fs/xfs/libxfs/xfs_bmap.c     | 26 ++++++++++++++------
> >  fs/xfs/libxfs/xfs_errortag.h |  4 +++-
> >  fs/xfs/xfs_error.c           |  3 +++
> >  5 files changed, 72 insertions(+), 8 deletions(-)
> > 
> > diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
> > index 852b536551b5..d8d8ab1478db 100644
> > --- a/fs/xfs/libxfs/xfs_alloc.c
> > +++ b/fs/xfs/libxfs/xfs_alloc.c
> > @@ -2473,6 +2473,45 @@ xfs_defer_agfl_block(
> >  	xfs_defer_add(tp, XFS_DEFER_OPS_TYPE_AGFL_FREE, &new->xefi_list);
> >  }
> >  
> > +STATIC int
> > +minlen_freespace_available(
> > +	struct xfs_alloc_arg	*args,
> > +	struct xfs_buf		*agbp,
> > +	int			*stat)
> > +{
> > +	xfs_btree_cur_t		*cnt_cur;
> > +	xfs_agblock_t		fbno;
> > +	xfs_extlen_t		flen;
> > +	int			btree_error = XFS_BTREE_NOERROR;
> > +	int			error = 0;
> > +
> > +	cnt_cur = xfs_allocbt_init_cursor(args->mp, args->tp, agbp,
> > +			args->agno, XFS_BTNUM_CNT);
> > +	error = xfs_alloc_lookup_ge(cnt_cur, 0, args->minlen, stat);
> > +	if (error) {
> > +		btree_error = XFS_BTREE_ERROR;
> > +		goto out;
> > +	}
> > +
> > +	ASSERT(*stat == 1);
> > +
> > +	error = xfs_alloc_get_rec(cnt_cur, &fbno, &flen, stat);
> > +	if (error) {
> > +		btree_error = XFS_BTREE_ERROR;
> > +		goto out;
> > +	}
> > +
> > +	if (flen == args->minlen)
> > +		*stat = 1;
> > +	else
> > +		*stat = 0;
> > +
> > +out:
> > +	xfs_btree_del_cursor(cnt_cur, btree_error);
> > +
> > +	return error;
> > +}
> > +
> >  /*
> >   * Decide whether to use this allocation group for this allocation.
> >   * If so, fix up the btree freelist's size.
> > @@ -2490,6 +2529,7 @@ xfs_alloc_fix_freelist(
> >  	struct xfs_alloc_arg	targs;	/* local allocation arguments */
> >  	xfs_agblock_t		bno;	/* freelist block */
> >  	xfs_extlen_t		need;	/* total blocks needed in freelist */
> > +	int			i;
> >  	int			error = 0;
> >  
> >  	/* deferred ops (AGFL block frees) require permanent transactions */
> > @@ -2544,6 +2584,12 @@ xfs_alloc_fix_freelist(
> >  	if (!xfs_alloc_space_available(args, need, flags))
> >  		goto out_agbp_relse;
> >  
> > +	if (args->alloc_minlen_only) {
> > +		error = minlen_freespace_available(args, agbp, &i);
> > +		if (error || !i)
> > +			goto out_agbp_relse;
> > +	}
> > +
> >  	/*
> >  	 * Make the freelist shorter if it's too long.
> >  	 *
> > diff --git a/fs/xfs/libxfs/xfs_alloc.h b/fs/xfs/libxfs/xfs_alloc.h
> > index 6c22b12176b8..1d04089b7fb4 100644
> > --- a/fs/xfs/libxfs/xfs_alloc.h
> > +++ b/fs/xfs/libxfs/xfs_alloc.h
> > @@ -75,6 +75,7 @@ typedef struct xfs_alloc_arg {
> >  	char		wasfromfl;	/* set if allocation is from freelist */
> >  	struct xfs_owner_info	oinfo;	/* owner of blocks being allocated */
> >  	enum xfs_ag_resv_type	resv;	/* block reservation to use */
> > +	bool		alloc_minlen_only;
> >  } xfs_alloc_arg_t;
> >  
> >  /*
> > diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> > index 5156cbd476f2..fab4097e7492 100644
> > --- a/fs/xfs/libxfs/xfs_bmap.c
> > +++ b/fs/xfs/libxfs/xfs_bmap.c
> > @@ -3510,12 +3510,19 @@ xfs_bmap_btalloc(
> >  		ASSERT(ap->length);
> >  	}
> >  
> > +	memset(&args, 0, sizeof(args));
> > +
> > +	args.alloc_minlen_only = XFS_TEST_ERROR(false, mp,
> > +					XFS_ERRTAG_BMAP_ALLOC_MINLEN_EXTENT);
> >  
> >  	nullfb = ap->tp->t_firstblock == NULLFSBLOCK;
> >  	fb_agno = nullfb ? NULLAGNUMBER : XFS_FSB_TO_AGNO(mp,
> >  							ap->tp->t_firstblock);
> >  	if (nullfb) {
> > -		if ((ap->datatype & XFS_ALLOC_USERDATA) &&
> > +		if (args.alloc_minlen_only) {
> > +			ag = 0;
> > +			ap->blkno = XFS_AGB_TO_FSB(mp, ag, 0);
> > +		} else if ((ap->datatype & XFS_ALLOC_USERDATA) &&
> >  		    xfs_inode_is_filestream(ap->ip)) {
> >  			ag = xfs_filestream_lookup_ag(ap->ip);
> >  			ag = (ag != NULLAGNUMBER) ? ag : 0;
> > @@ -3523,10 +3530,12 @@ xfs_bmap_btalloc(
> >  		} else {
> >  			ap->blkno = XFS_INO_TO_FSB(mp, ap->ip->i_ino);
> >  		}
> > -	} else
> > +	} else {
> >  		ap->blkno = ap->tp->t_firstblock;
> > +	}
> >  
> > -	xfs_bmap_adjacent(ap);
> > +	if (!args.alloc_minlen_only)
> > +		xfs_bmap_adjacent(ap);
> >  
> >  	/*
> >  	 * If allowed, use ap->blkno; otherwise must use firstblock since
> > @@ -3540,7 +3549,6 @@ xfs_bmap_btalloc(
> >  	 * Normal allocation, done through xfs_alloc_vextent.
> >  	 */
> >  	tryagain = isaligned = 0;
> > -	memset(&args, 0, sizeof(args));
> >  	args.tp = ap->tp;
> >  	args.mp = mp;
> >  	args.fsbno = ap->blkno;
> > @@ -3549,7 +3557,10 @@ xfs_bmap_btalloc(
> >  	/* Trim the allocation back to the maximum an AG can fit. */
> >  	args.maxlen = min(ap->length, mp->m_ag_max_usable);
> >  	blen = 0;
> > -	if (nullfb) {
> > +	if (args.alloc_minlen_only) {
> > +		args.type = XFS_ALLOCTYPE_START_AG;
> 
> The above should have been,
> 
> args.type = XFS_ALLOCTYPE_FIRST_AG;
> 
> In my experiments, I had introduced a new args.type value and had later
> realized that XFS_ALLOCTYPE_FIRST_AG would suffice for my requirements. I had
> tested the changed version (which was in my git stash) and forgot to apply
> that to this commit after testing was completed. Hence I ended up sending a
> slightly stale patch. I am sorry about this. I will resend the series.

Ok, but wait till I've gotten all the way through the replies (nearly
done now).

--D

> -- 
> chandan
> 
> 
> 
