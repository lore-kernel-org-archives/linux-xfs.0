Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F9FFC433E0
	for <linux-xfs@archiver.kernel.org>; Thu,  7 Jan 2021 19:38:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 15AE6233CF
	for <linux-xfs@archiver.kernel.org>; Thu,  7 Jan 2021 19:38:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727215AbhAGTiK (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 7 Jan 2021 14:38:10 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:46622 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726600AbhAGTiK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 7 Jan 2021 14:38:10 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 107JZ0ZI174006;
        Thu, 7 Jan 2021 19:37:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=nrgxvHxJMxx6/mLtgDuxeDi+HGrX5YBmRMsMn4XduhQ=;
 b=LbO1ipM5NbQCxWPwr9VLLDdVPb2jb6DbIlHYJxiTBhGnXqd8PZLT2zG9jGfQXC5+jdSv
 bSmU7qNQdXBzuKbQz5/hzzVwR52gsjVOhP0nRTc7rlNYBrqHlOzaNYdOoVvkGJR2SxaA
 x3x0j8Vf1DscyZGjezTbG4XXsAYUPYlQXW2H9992GtjTAOF+erfnoCmJzqcFBhwhGBZV
 Wjue6noBhwo3JFHi27euraFnefER8/iQ3wTujOp/QtbJn/LzqdM4jnn2pR9QX4SbJ1dN
 lYCYZVHzJ94O/PTtlnRuzuPdOigEy1FAYdJQ4aahWnX+KeaoaHXECJby/1/C2LM5qf7D Wg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 35wepme0kk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 07 Jan 2021 19:37:27 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 107JZZ2G063196;
        Thu, 7 Jan 2021 19:37:26 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 35w3g37p37-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 07 Jan 2021 19:37:26 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 107JbPuE006396;
        Thu, 7 Jan 2021 19:37:25 GMT
Received: from localhost (/10.159.138.126)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 07 Jan 2021 11:37:25 -0800
Date:   Thu, 7 Jan 2021 11:37:24 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Eric Sandeen <sandeen@redhat.com>
Cc:     xfs <linux-xfs@vger.kernel.org>, Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH V2] xfsprogs: cosmetic changes to libxfs_inode_alloc
Message-ID: <20210107193724.GI6918@magnolia>
References: <3fa15760-2e68-2c64-3914-fafbdd0e41fd@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3fa15760-2e68-2c64-3914-fafbdd0e41fd@redhat.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9857 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 adultscore=0
 phishscore=0 spamscore=0 mlxlogscore=999 suspectscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101070114
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9857 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 spamscore=0
 impostorscore=0 phishscore=0 lowpriorityscore=0 suspectscore=0
 priorityscore=1501 mlxscore=0 malwarescore=0 clxscore=1015 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101070114
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jan 07, 2021 at 01:20:49PM -0600, Eric Sandeen wrote:
> This pre-patch helps make the next libxfs-sync for 5.11 a bit
> more clear.
> 
> In reality, the libxfs_inode_alloc function matches the kernel's
> xfs_dir_ialloc so rename it for clarity before the rest of the
> sync, and change several variable names for the same reason.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
> 
> V2: Fix up local transaction pointer problems pointed out by Brian.
> 
> Essentially, use tp locally, and reassign tpp on return.
> 
> diff --git a/include/xfs_inode.h b/include/xfs_inode.h
> index 742aebc8..01a62daa 100644
> --- a/include/xfs_inode.h
> +++ b/include/xfs_inode.h
> @@ -156,7 +156,7 @@ typedef struct cred {
>  	gid_t	cr_gid;
>  } cred_t;
>  
> -extern int	libxfs_inode_alloc (struct xfs_trans **, struct xfs_inode *,
> +extern int	libxfs_dir_ialloc (struct xfs_trans **, struct xfs_inode *,
>  				mode_t, nlink_t, xfs_dev_t, struct cred *,
>  				struct fsxattr *, struct xfs_inode **);
>  extern void	libxfs_trans_inode_alloc_buf (struct xfs_trans *,
> diff --git a/libxfs/util.c b/libxfs/util.c
> index 252cf91e..376c5dac 100644
> --- a/libxfs/util.c
> +++ b/libxfs/util.c
> @@ -531,9 +531,9 @@ error0:	/* Cancel bmap, cancel trans */
>   * other in repair - now there is just the one.
>   */
>  int
> -libxfs_inode_alloc(
> -	xfs_trans_t	**tp,
> -	xfs_inode_t	*pip,
> +libxfs_dir_ialloc(
> +	xfs_trans_t	**tpp,
> +	xfs_inode_t	*dp,
>  	mode_t		mode,
>  	nlink_t		nlink,
>  	xfs_dev_t	rdev,
> @@ -541,16 +541,18 @@ libxfs_inode_alloc(
>  	struct fsxattr	*fsx,
>  	xfs_inode_t	**ipp)
>  {
> -	xfs_buf_t	*ialloc_context;
> +	xfs_trans_t	*tp;
>  	xfs_inode_t	*ip;
> -	int		error;
> +	xfs_buf_t	*ialloc_context = NULL;
> +	int		code;

Maybe de-typedef this function too?  Though I guess if the next patch is
a backport of "xfs: move on-disk inode allocation out of xfs_ialloc" to
libxfs/util.c then maybe that doesn't matter and I'll just shut up.  :)

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

>  
> -	ialloc_context = (xfs_buf_t *)0;
> -	error = libxfs_ialloc(*tp, pip, mode, nlink, rdev, cr, fsx,
> +	tp = *tpp;
> +
> +	code = libxfs_ialloc(tp, dp, mode, nlink, rdev, cr, fsx,
>  			   &ialloc_context, &ip);
> -	if (error) {
> +	if (code) {
>  		*ipp = NULL;
> -		return error;
> +		return code;
>  	}
>  	if (!ialloc_context && !ip) {
>  		*ipp = NULL;
> @@ -559,25 +561,29 @@ libxfs_inode_alloc(
>  
>  	if (ialloc_context) {
>  
> -		xfs_trans_bhold(*tp, ialloc_context);
> +		xfs_trans_bhold(tp, ialloc_context);
>  
> -		error = xfs_trans_roll(tp);
> -		if (error) {
> +		code = xfs_trans_roll(&tp);
> +		if (code) {
>  			fprintf(stderr, _("%s: cannot duplicate transaction: %s\n"),
> -				progname, strerror(error));
> +				progname, strerror(code));
>  			exit(1);
>  		}
> -		xfs_trans_bjoin(*tp, ialloc_context);
> -		error = libxfs_ialloc(*tp, pip, mode, nlink, rdev, cr,
> +		xfs_trans_bjoin(tp, ialloc_context);
> +		code = libxfs_ialloc(tp, dp, mode, nlink, rdev, cr,
>  				   fsx, &ialloc_context, &ip);
>  		if (!ip)
> -			error = -ENOSPC;
> -		if (error)
> -			return error;
> +			code = -ENOSPC;
> +		if (code) {
> +			*tpp = tp;
> +			*ipp = NULL;
> +			return code;
> +		}
>  	}
>  
>  	*ipp = ip;
> -	return error;
> +	*tpp = tp;
> +	return code;
>  }
>  
>  void
> diff --git a/mkfs/proto.c b/mkfs/proto.c
> index 0fa6ffb0..8439efc4 100644
> --- a/mkfs/proto.c
> +++ b/mkfs/proto.c
> @@ -453,7 +453,7 @@ parseproto(
>  	case IF_REGULAR:
>  		buf = newregfile(pp, &len);
>  		tp = getres(mp, XFS_B_TO_FSB(mp, len));
> -		error = -libxfs_inode_alloc(&tp, pip, mode|S_IFREG, 1, 0,
> +		error = -libxfs_dir_ialloc(&tp, pip, mode|S_IFREG, 1, 0,
>  					   &creds, fsxp, &ip);
>  		if (error)
>  			fail(_("Inode allocation failed"), error);
> @@ -477,7 +477,7 @@ parseproto(
>  		}
>  		tp = getres(mp, XFS_B_TO_FSB(mp, llen));
>  
> -		error = -libxfs_inode_alloc(&tp, pip, mode|S_IFREG, 1, 0,
> +		error = -libxfs_dir_ialloc(&tp, pip, mode|S_IFREG, 1, 0,
>  					  &creds, fsxp, &ip);
>  		if (error)
>  			fail(_("Inode pre-allocation failed"), error);
> @@ -498,7 +498,7 @@ parseproto(
>  		tp = getres(mp, 0);
>  		majdev = getnum(getstr(pp), 0, 0, false);
>  		mindev = getnum(getstr(pp), 0, 0, false);
> -		error = -libxfs_inode_alloc(&tp, pip, mode|S_IFBLK, 1,
> +		error = -libxfs_dir_ialloc(&tp, pip, mode|S_IFBLK, 1,
>  				IRIX_MKDEV(majdev, mindev), &creds, fsxp, &ip);
>  		if (error) {
>  			fail(_("Inode allocation failed"), error);
> @@ -513,7 +513,7 @@ parseproto(
>  		tp = getres(mp, 0);
>  		majdev = getnum(getstr(pp), 0, 0, false);
>  		mindev = getnum(getstr(pp), 0, 0, false);
> -		error = -libxfs_inode_alloc(&tp, pip, mode|S_IFCHR, 1,
> +		error = -libxfs_dir_ialloc(&tp, pip, mode|S_IFCHR, 1,
>  				IRIX_MKDEV(majdev, mindev), &creds, fsxp, &ip);
>  		if (error)
>  			fail(_("Inode allocation failed"), error);
> @@ -525,7 +525,7 @@ parseproto(
>  
>  	case IF_FIFO:
>  		tp = getres(mp, 0);
> -		error = -libxfs_inode_alloc(&tp, pip, mode|S_IFIFO, 1, 0,
> +		error = -libxfs_dir_ialloc(&tp, pip, mode|S_IFIFO, 1, 0,
>  				&creds, fsxp, &ip);
>  		if (error)
>  			fail(_("Inode allocation failed"), error);
> @@ -537,7 +537,7 @@ parseproto(
>  		buf = getstr(pp);
>  		len = (int)strlen(buf);
>  		tp = getres(mp, XFS_B_TO_FSB(mp, len));
> -		error = -libxfs_inode_alloc(&tp, pip, mode|S_IFLNK, 1, 0,
> +		error = -libxfs_dir_ialloc(&tp, pip, mode|S_IFLNK, 1, 0,
>  				&creds, fsxp, &ip);
>  		if (error)
>  			fail(_("Inode allocation failed"), error);
> @@ -548,7 +548,7 @@ parseproto(
>  		break;
>  	case IF_DIRECTORY:
>  		tp = getres(mp, 0);
> -		error = -libxfs_inode_alloc(&tp, pip, mode|S_IFDIR, 1, 0,
> +		error = -libxfs_dir_ialloc(&tp, pip, mode|S_IFDIR, 1, 0,
>  				&creds, fsxp, &ip);
>  		if (error)
>  			fail(_("Inode allocation failed"), error);
> @@ -640,7 +640,7 @@ rtinit(
>  
>  	memset(&creds, 0, sizeof(creds));
>  	memset(&fsxattrs, 0, sizeof(fsxattrs));
> -	error = -libxfs_inode_alloc(&tp, NULL, S_IFREG, 1, 0,
> +	error = -libxfs_dir_ialloc(&tp, NULL, S_IFREG, 1, 0,
>  					&creds, &fsxattrs, &rbmip);
>  	if (error) {
>  		fail(_("Realtime bitmap inode allocation failed"), error);
> @@ -657,7 +657,7 @@ rtinit(
>  	libxfs_trans_log_inode(tp, rbmip, XFS_ILOG_CORE);
>  	libxfs_log_sb(tp);
>  	mp->m_rbmip = rbmip;
> -	error = -libxfs_inode_alloc(&tp, NULL, S_IFREG, 1, 0,
> +	error = -libxfs_dir_ialloc(&tp, NULL, S_IFREG, 1, 0,
>  					&creds, &fsxattrs, &rsumip);
>  	if (error) {
>  		fail(_("Realtime summary inode allocation failed"), error);
> diff --git a/repair/phase6.c b/repair/phase6.c
> index 682356f0..f69afac9 100644
> --- a/repair/phase6.c
> +++ b/repair/phase6.c
> @@ -919,7 +919,7 @@ mk_orphanage(xfs_mount_t *mp)
>  		do_error(_("%d - couldn't iget root inode to make %s\n"),
>  			i, ORPHANAGE);*/
>  
> -	error = -libxfs_inode_alloc(&tp, pip, mode|S_IFDIR,
> +	error = -libxfs_dir_ialloc(&tp, pip, mode|S_IFDIR,
>  					1, 0, &zerocr, &zerofsx, &ip);
>  	if (error) {
>  		do_error(_("%s inode allocation failed %d\n"),
> 
