Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B04BC433EF
	for <linux-xfs@archiver.kernel.org>; Wed,  9 Mar 2022 22:32:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238696AbiCIWdv (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 9 Mar 2022 17:33:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238709AbiCIWdu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 9 Mar 2022 17:33:50 -0500
Received: from mail105.syd.optusnet.com.au (mail105.syd.optusnet.com.au [211.29.132.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 7B7452B191
        for <linux-xfs@vger.kernel.org>; Wed,  9 Mar 2022 14:32:47 -0800 (PST)
Received: from dread.disaster.area (pa49-186-150-27.pa.vic.optusnet.com.au [49.186.150.27])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 91C3E10E2CEF;
        Thu, 10 Mar 2022 09:32:46 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1nS4rN-003YXP-Dw; Thu, 10 Mar 2022 09:32:45 +1100
Date:   Thu, 10 Mar 2022 09:32:45 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] xfs: constify xfs_name_dotdot
Message-ID: <20220309223245.GK661808@dread.disaster.area>
References: <164685375609.496011.2754821878646256374.stgit@magnolia>
 <164685376731.496011.1567771444928519597.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <164685376731.496011.1567771444928519597.stgit@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=VuxAv86n c=1 sm=1 tr=0 ts=62292b0e
        a=sPqof0Mm7fxWrhYUF33ZaQ==:117 a=sPqof0Mm7fxWrhYUF33ZaQ==:17
        a=kj9zAlcOel0A:10 a=o8Y5sQTvuykA:10 a=VwQbUJbxAAAA:8 a=7-415B0cAAAA:8
        a=teNfEa-P9VIzn0qQ3soA:9 a=CjuIK1q_8ugA:10 a=AjGcO6oz07-iQ99wixmX:22
        a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Mar 09, 2022 at 11:22:47AM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> The symbol xfs_name_dotdot is a global variable that the xfs codebase
> uses here and there to look up directory dotdot entries.  Currently it's
> a non-const variable, which means that it's a mutable global variable.
> So far nobody's abused this to cause problems, but let's use the
> compiler to enforce that.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  fs/xfs/libxfs/xfs_dir2.c |    6 +++++-
>  fs/xfs/libxfs/xfs_dir2.h |    2 +-
>  fs/xfs/scrub/parent.c    |    6 ++++--
>  fs/xfs/xfs_export.c      |    3 ++-
>  4 files changed, 12 insertions(+), 5 deletions(-)
> 
> 
> diff --git a/fs/xfs/libxfs/xfs_dir2.c b/fs/xfs/libxfs/xfs_dir2.c
> index a77d931d65a3..cf9fa07e62d5 100644
> --- a/fs/xfs/libxfs/xfs_dir2.c
> +++ b/fs/xfs/libxfs/xfs_dir2.c
> @@ -19,7 +19,11 @@
>  #include "xfs_error.h"
>  #include "xfs_trace.h"
>  
> -struct xfs_name xfs_name_dotdot = { (unsigned char *)"..", 2, XFS_DIR3_FT_DIR };
> +const struct xfs_name xfs_name_dotdot = {
> +	.name	= (unsigned char *)"..",
> +	.len	= 2,
> +	.type	= XFS_DIR3_FT_DIR,
> +};

*nod*

> diff --git a/fs/xfs/scrub/parent.c b/fs/xfs/scrub/parent.c
> index ab182a5cd0c0..e9549d998cdc 100644
> --- a/fs/xfs/scrub/parent.c
> +++ b/fs/xfs/scrub/parent.c
> @@ -131,6 +131,7 @@ xchk_parent_validate(
>  	xfs_ino_t		dnum,
>  	bool			*try_again)
>  {
> +	struct xfs_name		dotdot = xfs_name_dotdot;
>  	struct xfs_mount	*mp = sc->mp;
>  	struct xfs_inode	*dp = NULL;
>  	xfs_nlink_t		expected_nlink;
> @@ -230,7 +231,7 @@ xchk_parent_validate(
>  	expected_nlink = VFS_I(sc->ip)->i_nlink == 0 ? 0 : 1;
>  
>  	/* Look up '..' to see if the inode changed. */
> -	error = xfs_dir_lookup(sc->tp, sc->ip, &xfs_name_dotdot, &dnum, NULL);
> +	error = xfs_dir_lookup(sc->tp, sc->ip, &dotdot, &dnum, NULL);
>  	if (!xchk_fblock_process_error(sc, XFS_DATA_FORK, 0, &error))
>  		goto out_rele;
>  

Why can't xfs_dir_lookup() be defined as a const xname for the input
name? All it does is extract the contents into the da_args fields,
and pass it to xfs_dir_hashname() which you converted to const in
the previous patch.

Or does the compiler then complain at all the other callsites that
you're passing non-const stuff to const function parameters? i.e. am
I just pulling on another dangling end of the ball of string at this
point?

> @@ -263,6 +264,7 @@ int
>  xchk_parent(
>  	struct xfs_scrub	*sc)
>  {
> +	struct xfs_name		dotdot = xfs_name_dotdot;
>  	struct xfs_mount	*mp = sc->mp;
>  	xfs_ino_t		dnum;
>  	bool			try_again;
> @@ -293,7 +295,7 @@ xchk_parent(
>  	xfs_iunlock(sc->ip, XFS_ILOCK_EXCL | XFS_MMAPLOCK_EXCL);
>  
>  	/* Look up '..' */
> -	error = xfs_dir_lookup(sc->tp, sc->ip, &xfs_name_dotdot, &dnum, NULL);
> +	error = xfs_dir_lookup(sc->tp, sc->ip, &dotdot, &dnum, NULL);
>  	if (!xchk_fblock_process_error(sc, XFS_DATA_FORK, 0, &error))
>  		goto out;
>  	if (!xfs_verify_dir_ino(mp, dnum)) {
> diff --git a/fs/xfs/xfs_export.c b/fs/xfs/xfs_export.c
> index 1064c2342876..8939119191f4 100644
> --- a/fs/xfs/xfs_export.c
> +++ b/fs/xfs/xfs_export.c
> @@ -206,10 +206,11 @@ STATIC struct dentry *
>  xfs_fs_get_parent(
>  	struct dentry		*child)
>  {
> +	struct xfs_name		dotdot = xfs_name_dotdot;
>  	int			error;
>  	struct xfs_inode	*cip;
>  
> -	error = xfs_lookup(XFS_I(d_inode(child)), &xfs_name_dotdot, &cip, NULL);
> +	error = xfs_lookup(XFS_I(d_inode(child)), &dotdot, &cip, NULL);
>  	if (unlikely(error))
>  		return ERR_PTR(error);

This only calls xfs_dir_lookup() with name, so if xfs_dir_lookup()
can have a const name, so can xfs_lookup()....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
