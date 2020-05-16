Return-Path: <SRS0=gkwD=66=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96CD3C433DF
	for <linux-xfs@archiver.kernel.org>; Sat, 16 May 2020 17:48:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6FFEC20671
	for <linux-xfs@archiver.kernel.org>; Sat, 16 May 2020 17:48:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="vud+ctl1"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726361AbgEPRsL (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 16 May 2020 13:48:11 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:48098 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726292AbgEPRsK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 16 May 2020 13:48:10 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04GHi3u8022545;
        Sat, 16 May 2020 17:48:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=mIwdQHJJCijpIvognfkzuOTHWBCLRfv1J2ua+jYaywE=;
 b=vud+ctl1bTxXd5bHgY3+zY0V2pAHctR6e9w2YS7cLTloJ+qMnLYdDyJSQo43hfzMn2hH
 4Om8pqU3U55wKHNhMqqBTJUZbmfeZWFH2+49zm1u7vb2P4RBJW4YcOaOaxD1a6GjHZM1
 PL2emkMba6ceOPFXF8yjmeXS8m4FOxstcWPKJ3iKRsAKrzYm6cHn6jBQwXNVSlvuzmH9
 IFjKL5kjBpW3K2uOy78BZkR1Y4dr1Sw4dNqUFAjkwlgVtyYr6H4UOBxO5P1Cmqte6Boh
 8CYb/8eCxpuoDJx5X5Y5rAZEL43fEbXeMJ12aIh8/yEXdDaMqiZkkfRC9FmRRH18DySm SA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 3127kqsf85-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Sat, 16 May 2020 17:48:04 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04GHiIJG183298;
        Sat, 16 May 2020 17:48:03 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 312679da0b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 16 May 2020 17:48:03 +0000
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 04GHm3B1027904;
        Sat, 16 May 2020 17:48:03 GMT
Received: from localhost (/10.159.131.94)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sat, 16 May 2020 10:48:02 -0700
Date:   Sat, 16 May 2020 10:48:02 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 08/12] xfs: remove xfs_ifork_ops
Message-ID: <20200516174802.GX6714@magnolia>
References: <20200508063423.482370-1-hch@lst.de>
 <20200508063423.482370-9-hch@lst.de>
 <20200508150543.GF27577@bfoster>
 <20200509081715.GA21748@lst.de>
 <20200509111344.GA32702@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200509111344.GA32702@bfoster>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9623 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 suspectscore=1 spamscore=0
 bulkscore=0 malwarescore=0 adultscore=0 mlxscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2005160159
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9623 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0 spamscore=0
 bulkscore=0 clxscore=1015 priorityscore=1501 mlxscore=0 impostorscore=0
 suspectscore=1 mlxlogscore=999 malwarescore=0 cotscore=-2147483648
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2005160159
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, May 09, 2020 at 07:13:44AM -0400, Brian Foster wrote:
> On Sat, May 09, 2020 at 10:17:15AM +0200, Christoph Hellwig wrote:
> > On Fri, May 08, 2020 at 11:05:43AM -0400, Brian Foster wrote:
> > > On Fri, May 08, 2020 at 08:34:19AM +0200, Christoph Hellwig wrote:
> > > > xfs_ifork_ops add up to two indirect calls per inode read and flush,
> > > > despite just having a single instance in the kernel.  In xfsprogs
> > > > phase6 in xfs_repair overrides the verify_dir method to deal with inodes
> > > > that do not have a valid parent, but that can be fixed pretty easily
> > > > by ensuring they always have a valid looking parent.
> > > > 
> > > > Signed-off-by: Christoph Hellwig <hch@lst.de>
> > > > ---
> > > 
> > > Code looks fine, but I assume we'll want a repair fix completed and
> > > merged before wiping this out:
> > 
> > With the xfsprogs merge delays I'm not sure merged will work, but I'll
> > happily take your patch and get it in shape for submission.
> > 
> 
> The critical bit is that repair is fixed before this lands in xfsprogs,
> otherwise we just reintroduce the regression the callback mechanism was
> designed to fix. The repair change is not huge, but it's not necessarily
> trivial so it's probably worth making sure the repair change is at least
> reviewed before putting this into the kernel pipeline.
> 
> BTW, I played with this a bit more yesterday and made some tweaks that I
> think make it a little cleaner. Namely instead of processing the parent
> bits in phases 3 and 4 and setting the parent in the internal structures
> in phase 4, to do everything in phase 3 and skip the repeat checks in
> phase 4. This has the side effect of eliminating some duplicate error
> messages where repair complains about the original bogus value in phase
> 3, sets it to zero, and then complains about the zero value again in
> phase 4. This still needs some auditing to assess whether we're losing
> any extra verification by setting the parent in phase 3, however. It
> also might be worth looking at giving the other dir formats the same
> treatment. Squashed diff of my local tree below...
> 
> Brian
> 
> diff --git a/repair/dino_chunks.c b/repair/dino_chunks.c
> index 6685a4d2..96ed6a5b 100644
> --- a/repair/dino_chunks.c
> +++ b/repair/dino_chunks.c
> @@ -859,14 +859,7 @@ next_readbuf:
>  		 */
>  		if (isa_dir)  {
>  			set_inode_isadir(ino_rec, irec_offset);
> -			/*
> -			 * we always set the parent but
> -			 * we may as well wait until
> -			 * phase 4 (no inode discovery)
> -			 * because the parent info will
> -			 * be solid then.
> -			 */
> -			if (!ino_discovery)  {
> +			if (ino_discovery)  {
>  				ASSERT(parent != 0);
>  				set_inode_parent(ino_rec, irec_offset, parent);
>  				ASSERT(parent ==
> diff --git a/repair/dir2.c b/repair/dir2.c
> index cbbce601..9c789b4a 100644
> --- a/repair/dir2.c
> +++ b/repair/dir2.c
> @@ -165,7 +165,6 @@ process_sf_dir2(
>  	int			tmp_elen;
>  	int			tmp_len;
>  	xfs_dir2_sf_entry_t	*tmp_sfep;
> -	xfs_ino_t		zero = 0;
>  
>  	sfp = (struct xfs_dir2_sf_hdr *)XFS_DFORK_DPTR(dip);
>  	max_size = XFS_DFORK_DSIZE(dip, mp);
> @@ -480,6 +479,9 @@ _("corrected entry offsets in directory %" PRIu64 "\n"),
>  	 * check parent (..) entry
>  	 */
>  	*parent = libxfs_dir2_sf_get_parent_ino(sfp);
> +	if (!ino_discovery)
> +		return 0;
> +
>  
>  	/*
>  	 * if parent entry is bogus, null it out.  we'll fix it later .
> @@ -494,7 +496,7 @@ _("bogus .. inode number (%" PRIu64 ") in directory inode %" PRIu64 ", "),
>  		if (!no_modify)  {
>  			do_warn(_("clearing inode number\n"));
>  
> -			libxfs_dir2_sf_put_parent_ino(sfp, zero);
> +			libxfs_dir2_sf_put_parent_ino(sfp, mp->m_sb.sb_rootino);
>  			*dino_dirty = 1;
>  			*repair = 1;
>  		} else  {
> @@ -529,7 +531,7 @@ _("bad .. entry in directory inode %" PRIu64 ", points to self, "),
>  		if (!no_modify)  {
>  			do_warn(_("clearing inode number\n"));
>  
> -			libxfs_dir2_sf_put_parent_ino(sfp, zero);
> +			libxfs_dir2_sf_put_parent_ino(sfp, mp->m_sb.sb_rootino);
>  			*dino_dirty = 1;
>  			*repair = 1;
>  		} else  {
> diff --git a/repair/phase6.c b/repair/phase6.c
> index beceea9a..43bcea50 100644
> --- a/repair/phase6.c
> +++ b/repair/phase6.c
> @@ -26,58 +26,6 @@ static struct xfs_name		xfs_name_dot = {(unsigned char *)".",
>  						1,
>  						XFS_DIR3_FT_DIR};
>  
> -/*
> - * When we're checking directory inodes, we're allowed to set a directory's
> - * dotdot entry to zero to signal that the parent needs to be reconnected
> - * during phase 6.  If we're handling a shortform directory the ifork
> - * verifiers will fail, so temporarily patch out this canary so that we can
> - * verify the rest of the fork and move on to fixing the dir.
> - */
> -static xfs_failaddr_t
> -phase6_verify_dir(
> -	struct xfs_inode		*ip)
> -{
> -	struct xfs_mount		*mp = ip->i_mount;
> -	struct xfs_ifork		*ifp;
> -	struct xfs_dir2_sf_hdr		*sfp;
> -	xfs_failaddr_t			fa;
> -	xfs_ino_t			old_parent;
> -	bool				parent_bypass = false;
> -	int				size;
> -
> -	ifp = XFS_IFORK_PTR(ip, XFS_DATA_FORK);
> -	sfp = (struct xfs_dir2_sf_hdr *)ifp->if_u1.if_data;
> -	size = ifp->if_bytes;
> -
> -	/*
> -	 * If this is a shortform directory, phase4 may have set the parent
> -	 * inode to zero to indicate that it must be fixed.  Temporarily
> -	 * set a valid parent so that the directory verifier will pass.
> -	 */
> -	if (size > offsetof(struct xfs_dir2_sf_hdr, parent) &&
> -	    size >= xfs_dir2_sf_hdr_size(sfp->i8count)) {
> -		old_parent = libxfs_dir2_sf_get_parent_ino(sfp);
> -		if (old_parent == 0) {
> -			libxfs_dir2_sf_put_parent_ino(sfp, mp->m_sb.sb_rootino);
> -			parent_bypass = true;
> -		}
> -	}
> -
> -	fa = libxfs_default_ifork_ops.verify_dir(ip);
> -
> -	/* Put it back. */
> -	if (parent_bypass)
> -		libxfs_dir2_sf_put_parent_ino(sfp, old_parent);
> -
> -	return fa;
> -}
> -
> -static struct xfs_ifork_ops phase6_ifork_ops = {
> -	.verify_attr	= xfs_attr_shortform_verify,
> -	.verify_dir	= phase6_verify_dir,
> -	.verify_symlink	= xfs_symlink_shortform_verify,
> -};
> -
>  /*
>   * Data structures used to keep track of directories where the ".."
>   * entries are updated. These must be rebuilt after the initial pass
> @@ -1104,7 +1052,7 @@ mv_orphanage(
>  					(unsigned long long)ino, ++incr);
>  
>  	/* Orphans may not have a proper parent, so use custom ops here */
> -	err = -libxfs_iget(mp, NULL, ino, 0, &ino_p, &phase6_ifork_ops);
> +	err = -libxfs_iget(mp, NULL, ino, 0, &ino_p, &xfs_default_ifork_ops);

Hmm.  I'll have to look at this more thoroughly on a non-weekend, but I
think I like this approach, since it removes the weird quirk that if
repair fails after writing out a sf directory with parent==0, we'll have
transformed an fs with bad directory parent pointers to an fs with a
directory that totally fails the verifier.

So for the kernel patch, provisionally:
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

>  	if (err)
>  		do_error(_("%d - couldn't iget disconnected inode\n"), err);
>  
> @@ -2875,7 +2823,7 @@ process_dir_inode(
>  
>  	ASSERT(!is_inode_refchecked(irec, ino_offset) || dotdot_update);
>  
> -	error = -libxfs_iget(mp, NULL, ino, 0, &ip, &phase6_ifork_ops);
> +	error = -libxfs_iget(mp, NULL, ino, 0, &ip, &xfs_default_ifork_ops);
>  	if (error) {
>  		if (!no_modify)
>  			do_error(
> 
