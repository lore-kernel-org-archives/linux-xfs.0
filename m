Return-Path: <SRS0=IeGX=YO=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3767CA9EAF
	for <linux-xfs@archiver.kernel.org>; Mon, 21 Oct 2019 18:14:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A971620873
	for <linux-xfs@archiver.kernel.org>; Mon, 21 Oct 2019 18:14:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="qaHz3rI4"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728185AbfJUSOW (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 21 Oct 2019 14:14:22 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:43144 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726672AbfJUSOW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 21 Oct 2019 14:14:22 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9LI8w1K066336;
        Mon, 21 Oct 2019 18:14:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=6z7A8so//9xqNWNM6qRHqsSJoQ+UgVkurQbMmMr3wLc=;
 b=qaHz3rI4MZZ3NY+OMSV6Ex/49d1FYL1jQj0tjTWFyB2a4hIRrdKI2FOkICGnecK9qjTr
 vZyHTOXdpe52Jf3BjUhdn00evflEkWx83DT3/KWTYxLNSW5s3CN7x4l+QdeOZilk33gr
 7497h0VK311uGg6q/jEdTRaW+ww816zJCZ2Dib7mC5gEM7TxqGEG69rQ47qdvNFD+P8i
 JpyVvD3O7qKpyyle77Ex0UFhhENOL9Ra7eIFcOEocArFK9r82YAKbQYn/URqSBrtGFcm
 Ogq0CVPFzeYUtzWvuq4/XNlBNK//P7iImGEB6I9viP3UfeJEAH1MUaGxBmDVxsD1L4UE Bg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 2vqswt9kvw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 21 Oct 2019 18:14:19 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9LIE2QR013786;
        Mon, 21 Oct 2019 18:14:18 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 2vsakbnfnm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 21 Oct 2019 18:14:14 +0000
Received: from abhmp0021.oracle.com (abhmp0021.oracle.com [141.146.116.27])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x9LIEBiN004444;
        Mon, 21 Oct 2019 18:14:11 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 21 Oct 2019 18:14:10 +0000
Date:   Mon, 21 Oct 2019 11:14:09 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Eric Sandeen <sandeen@sandeen.net>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 06/11] xfs_scrub: reduce fsmap activity for media errors
Message-ID: <20191021181409.GD913374@magnolia>
References: <156944736739.300131.5717633994765951730.stgit@magnolia>
 <156944740409.300131.11774965759850122284.stgit@magnolia>
 <bda4db03-54a2-8ed7-26b2-369ddcc1b697@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bda4db03-54a2-8ed7-26b2-369ddcc1b697@sandeen.net>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9417 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1910210174
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9417 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1910210174
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Oct 21, 2019 at 12:17:52PM -0500, Eric Sandeen wrote:
> On 9/25/19 4:36 PM, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Right now we rather foolishly query the fsmap data for every single
> > media error that we find.  This is a silly waste of time since we
> > have yet to combine adjacent bad blocks into bad extents, so move the
> > rmap query until after we've constructed the bad block bitmap data.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  libfrog/bitmap.c |   10 +---
> >  scrub/phase6.c   |  148 ++++++++++++++++++++++++++++++++++++++----------------
> >  2 files changed, 108 insertions(+), 50 deletions(-)
> > 
> > 
> > diff --git a/libfrog/bitmap.c b/libfrog/bitmap.c
> > index 6a88ef48..5daa1081 100644
> > --- a/libfrog/bitmap.c
> > +++ b/libfrog/bitmap.c
> > @@ -314,7 +314,6 @@ bitmap_clear(
> >  }
> >  #endif
> >  
> > -#ifdef DEBUG
> >  /* Iterate the set regions of this bitmap. */
> >  int
> >  bitmap_iterate(
> > @@ -324,20 +323,19 @@ bitmap_iterate(
> >  {
> >  	struct avl64node	*node;
> >  	struct bitmap_node	*ext;
> > -	int			error = 0;
> > +	int			ret;
> >  
> >  	pthread_mutex_lock(&bmap->bt_lock);
> >  	avl_for_each(bmap->bt_tree, node) {
> >  		ext = container_of(node, struct bitmap_node, btn_node);
> > -		error = fn(ext->btn_start, ext->btn_length, arg);
> > -		if (error)
> > +		ret = fn(ext->btn_start, ext->btn_length, arg);
> > +		if (ret)
> >  			break;
> >  	}
> >  	pthread_mutex_unlock(&bmap->bt_lock);
> >  
> > -	return error;
> > +	return ret;
> >  }
> > -#endif
> >  
> >  /* Iterate the set regions of part of this bitmap. */
> >  int
> > diff --git a/scrub/phase6.c b/scrub/phase6.c
> > index ec821373..378ea0fb 100644
> > --- a/scrub/phase6.c
> > +++ b/scrub/phase6.c
> > @@ -341,27 +341,9 @@ xfs_report_verify_dirent(
> >  	return moveon;
> >  }
> >  
> > -/* Given bad extent lists for the data & rtdev, find bad files. */
> > -static bool
> > -xfs_report_verify_errors(
> > -	struct scrub_ctx		*ctx,
> > -	struct media_verify_state	*vs)
> > -{
> > -	bool				moveon;
> > -
> > -	/* Scan the directory tree to get file paths. */
> > -	moveon = scan_fs_tree(ctx, xfs_report_verify_dir,
> > -			xfs_report_verify_dirent, vs);
> > -	if (!moveon)
> > -		return false;
> > -
> > -	/* Scan for unlinked files. */
> > -	return xfs_scan_all_inodes(ctx, xfs_report_verify_inode, vs);
> > -}
> > -
> >  /* Report an IO error resulting from read-verify based off getfsmap. */
> >  static bool
> > -xfs_check_rmap_error_report(
> > +ioerr_fsmap_report(
> >  	struct scrub_ctx	*ctx,
> >  	const char		*descr,
> >  	struct fsmap		*map,
> > @@ -409,12 +391,31 @@ xfs_check_rmap_error_report(
> >  	return true;
> >  }
> >  
> > +static struct bitmap *
> > +bitmap_for_disk(
> > +	struct scrub_ctx		*ctx,
> > +	struct disk			*disk,
> > +	struct media_verify_state	*vs)
> > +{
> > +	dev_t				dev = xfs_disk_to_dev(ctx, disk);
> > +
> > +	/*
> > +	 * If we don't have parent pointers, save the bad extent for
> > +	 * later rescanning.
> > +	 */
> 
> This comment doesn't make sense here, does it?
> 
> > +	if (dev == ctx->fsinfo.fs_datadev)
> > +		return vs->d_bad;
> > +	else if (dev == ctx->fsinfo.fs_rtdev)
> > +		return vs->r_bad;
> > +	return NULL;
> > +}
> > +
> >  /*
> >   * Remember a read error for later, and see if rmap will tell us about the
> >   * owner ahead of time.
> >   */
> >  static void
> > -xfs_check_rmap_ioerr(
> > +remember_ioerr(
> >  	struct scrub_ctx		*ctx,
> >  	struct disk			*disk,
> >  	uint64_t			start,
> > @@ -422,32 +423,39 @@ xfs_check_rmap_ioerr(
> >  	int				error,
> >  	void				*arg)
> >  {
> > -	struct fsmap			keys[2];
> > -	char				descr[DESCR_BUFSZ];
> >  	struct media_verify_state	*vs = arg;
> >  	struct bitmap			*tree;
> > -	dev_t				dev;
> >  	int				ret;
> >  
> > -	dev = xfs_disk_to_dev(ctx, disk);
> > +	tree = bitmap_for_disk(ctx, disk, vs);
> > +	if (!tree)
> > +		return;
> >  
> > -	/*
> > -	 * If we don't have parent pointers, save the bad extent for
> > -	 * later rescanning.
> > -	 */
> > -	if (dev == ctx->fsinfo.fs_datadev)
> > -		tree = vs->d_bad;
> > -	else if (dev == ctx->fsinfo.fs_rtdev)
> > -		tree = vs->r_bad;
> > -	else
> > -		tree = NULL;
> > -	if (tree) {
> > -		ret = bitmap_set(tree, start, length);
> > -		if (ret)
> > -			str_liberror(ctx, ret, _("setting bad block bitmap"));
> > -	}
> 
> Maybe that comment should be here?

Oops, yes.

> > +	ret = bitmap_set(tree, start, length);
> > +	if (ret)
> > +		str_liberror(ctx, ret, _("setting bad block bitmap"));
> > +}
> > +
> > +struct walk_ioerr {
> > +	struct scrub_ctx	*ctx;
> > +	struct disk		*disk;
> > +};
> 
> comment here would be great.  Is this walking an ioerror?  Reporting an ioerror
> from a walk?  (or maybe also/instead a comment on walk_ioerrs())
> 
> also whee, functions and structures w/ the same name :D

Dorky C thing to pass variable scope to an iterator function.

> > +static int
> > +walk_ioerr(
> > +	uint64_t		start,
> > +	uint64_t		length,
> > +	void			*arg)
> > +{
> > +	struct walk_ioerr	*wioerr = arg;
> > +	struct fsmap		keys[2];
> > +	char			descr[DESCR_BUFSZ];
> > +	dev_t			dev;
> > +
> > +	dev = xfs_disk_to_dev(wioerr->ctx, wioerr->disk);
> >  
> > -	snprintf(descr, DESCR_BUFSZ, _("dev %d:%d ioerr @ %"PRIu64":%"PRIu64" "),
> > +	snprintf(descr, DESCR_BUFSZ,
> > +_("dev %d:%d ioerr @ %"PRIu64":%"PRIu64" "),
> >  			major(dev), minor(dev), start, length);
> >  
> >  	/* Go figure out which blocks are bad from the fsmap. */
> > @@ -459,8 +467,60 @@ xfs_check_rmap_ioerr(
> >  	(keys + 1)->fmr_owner = ULLONG_MAX;
> >  	(keys + 1)->fmr_offset = ULLONG_MAX;
> >  	(keys + 1)->fmr_flags = UINT_MAX;
> > -	xfs_iterate_fsmap(ctx, descr, keys, xfs_check_rmap_error_report,
> > +	xfs_iterate_fsmap(wioerr->ctx, descr, keys, ioerr_fsmap_report,
> >  			&start);
> > +	return 0;
> > +}
> > +
> > +static int
> > +walk_ioerrs(
> > +	struct scrub_ctx		*ctx,
> > +	struct disk			*disk,
> > +	struct media_verify_state	*vs)
> > +{
> > +	struct walk_ioerr		wioerr = {
> > +		.ctx			= ctx,
> > +		.disk			= disk,
> > +	};> +	struct bitmap			*tree;
> > +
> > +	if (!disk)
> > +		return 0;
> > +	tree = bitmap_for_disk(ctx, disk, vs);
> > +	if (!tree)
> > +		return 0;
> > +	return bitmap_iterate(tree, walk_ioerr, &wioerr);
> > +}
> > +
> > +/* Given bad extent lists for the data & rtdev, find bad files. */
> 
> maybe "find and report bad files" just to tie it in w/ the "report" in
> the function name?

Ok.  I'll work on improving the comments in this file.

> is this only for media errors?  Maybev xfs_report_media_errors?  There are
> so many things going on in scrub (and apparently such a limited namespace
> for functions :D) that I find myself wishing for a little more context
> when I read something in isolation...

Yes.  I'm dropping the xfs_ prefixes, fwiw....

--D

> 
> > +static bool
> > +xfs_report_verify_errors(
> > +	struct scrub_ctx		*ctx,
> > +	struct media_verify_state	*vs)
> > +{
> > +	bool				moveon;
> > +	int				ret;
> > +
> > +	ret = walk_ioerrs(ctx, ctx->datadev, vs);
> > +	if (ret) {
> > +		str_liberror(ctx, ret, _("walking datadev io errors"));
> > +		return false;
> > +	}
> > +
> > +	ret = walk_ioerrs(ctx, ctx->rtdev, vs);
> > +	if (ret) {
> > +		str_liberror(ctx, ret, _("walking rtdev io errors"));
> > +		return false;
> > +	}
> > +
> > +	/* Scan the directory tree to get file paths. */
> > +	moveon = scan_fs_tree(ctx, xfs_report_verify_dir,
> > +			xfs_report_verify_dirent, vs);
> > +	if (!moveon)
> > +		return false;
> > +
> > +	/* Scan for unlinked files. */
> > +	return xfs_scan_all_inodes(ctx, xfs_report_verify_inode, vs);
> >  }
> >  
> >  /* Schedule a read-verify of a (data block) extent. */
> > @@ -571,7 +631,7 @@ xfs_scan_blocks(
> >  	}
> >  
> >  	ret = read_verify_pool_alloc(ctx, ctx->datadev,
> > -			ctx->mnt.fsgeom.blocksize, xfs_check_rmap_ioerr,
> > +			ctx->mnt.fsgeom.blocksize, remember_ioerr,
> >  			scrub_nproc(ctx), &vs.rvp_data);
> >  	if (ret) {
> >  		str_liberror(ctx, ret, _("creating datadev media verifier"));
> > @@ -579,7 +639,7 @@ xfs_scan_blocks(
> >  	}
> >  	if (ctx->logdev) {
> >  		ret = read_verify_pool_alloc(ctx, ctx->logdev,
> > -				ctx->mnt.fsgeom.blocksize, xfs_check_rmap_ioerr,
> > +				ctx->mnt.fsgeom.blocksize, remember_ioerr,
> >  				scrub_nproc(ctx), &vs.rvp_log);
> >  		if (ret) {
> >  			str_liberror(ctx, ret,
> > @@ -589,7 +649,7 @@ xfs_scan_blocks(
> >  	}
> >  	if (ctx->rtdev) {
> >  		ret = read_verify_pool_alloc(ctx, ctx->rtdev,
> > -				ctx->mnt.fsgeom.blocksize, xfs_check_rmap_ioerr,
> > +				ctx->mnt.fsgeom.blocksize, remember_ioerr,
> >  				scrub_nproc(ctx), &vs.rvp_realtime);
> >  		if (ret) {
> >  			str_liberror(ctx, ret,
> > 
