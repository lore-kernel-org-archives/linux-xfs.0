Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CEF9BC38A2D
	for <linux-xfs@archiver.kernel.org>; Tue, 25 Oct 2022 19:13:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232537AbiJYTNu (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 25 Oct 2022 15:13:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232038AbiJYTNu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 25 Oct 2022 15:13:50 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76C0ABBE3F
        for <linux-xfs@vger.kernel.org>; Tue, 25 Oct 2022 12:13:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 138CB61AFD
        for <linux-xfs@vger.kernel.org>; Tue, 25 Oct 2022 19:13:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B280C433D6;
        Tue, 25 Oct 2022 19:13:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666725228;
        bh=gD6RXHJAS2p29dqhpRS8YzmiDPEcZSrmSbyU+SH+JtY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=JFVg9y0ASUnnj9feEaHprbYSQ4JVpSn4HO64JyPCIkvzHCpfMB2hdfWTS4VdjjbB6
         5nHcjxHc367uA3GfAArRerazaVIghmYWeQwWArJOjC//NkTbFbgPNGEjeDN07CktOZ
         OhytAb9fu0Fldcsbg0/Ffghoif+aU9E0bOYr12RCVNUtUkUvlAM6knLukpupXwKzj4
         mHr048kKtNSUsJ4nt26g0EzBC3tF7T9Osrz0ZgZ/r8u2QU6YDR2EmQva/E1GWLweZA
         gvxiJ/DAgYu2HP8YqCKsWXIC7CvOtw1/dly602PJjTLNmZIrdbLoj0xjfZ86jK7oGb
         sgWOc3NwYEtaA==
Date:   Tue, 25 Oct 2022 12:13:47 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     allison.henderson@oracle.com
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v4 06/27] xfs: Expose init_xattrs in xfs_create_tmpfile
Message-ID: <Y1g1a+D6uMz6wSjs@magnolia>
References: <20221021222936.934426-1-allison.henderson@oracle.com>
 <20221021222936.934426-7-allison.henderson@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221021222936.934426-7-allison.henderson@oracle.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Oct 21, 2022 at 03:29:15PM -0700, allison.henderson@oracle.com wrote:
> From: Allison Henderson <allison.henderson@oracle.com>
> 
> Tmp files are used as part of rename operations and will need attr forks
> initialized for parent pointers.  Expose the init_xattrs parameter to
> the calling function to initialize the fork.
> 
> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
> ---
>  fs/xfs/xfs_inode.c | 5 +++--
>  fs/xfs/xfs_inode.h | 2 +-
>  fs/xfs/xfs_iops.c  | 3 ++-
>  3 files changed, 6 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index 44b68fa53a72..8b3aefd146a2 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -1108,6 +1108,7 @@ xfs_create_tmpfile(
>  	struct user_namespace	*mnt_userns,
>  	struct xfs_inode	*dp,
>  	umode_t			mode,
> +	bool			init_xattrs,
>  	struct xfs_inode	**ipp)
>  {
>  	struct xfs_mount	*mp = dp->i_mount;
> @@ -1148,7 +1149,7 @@ xfs_create_tmpfile(
>  	error = xfs_dialloc(&tp, dp->i_ino, mode, &ino);
>  	if (!error)
>  		error = xfs_init_new_inode(mnt_userns, tp, dp, ino, mode,
> -				0, 0, prid, false, &ip);
> +				0, 0, prid, init_xattrs, &ip);
>  	if (error)
>  		goto out_trans_cancel;
>  
> @@ -2748,7 +2749,7 @@ xfs_rename_alloc_whiteout(
>  	int			error;
>  
>  	error = xfs_create_tmpfile(mnt_userns, dp, S_IFCHR | WHITEOUT_MODE,
> -				   &tmpfile);
> +				   false, &tmpfile);

Similar question to last time -- shouldn't we initialize the attr fork
at whiteout creation time if we know that we're about to add the new
file to a directory?  IOWs, s/false/xfs_has_parent(mp)/ here?

--D

>  	if (error)
>  		return error;
>  
> diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
> index 2eaed98af814..5735de32beeb 100644
> --- a/fs/xfs/xfs_inode.h
> +++ b/fs/xfs/xfs_inode.h
> @@ -478,7 +478,7 @@ int		xfs_create(struct user_namespace *mnt_userns,
>  			   umode_t mode, dev_t rdev, bool need_xattr,
>  			   struct xfs_inode **ipp);
>  int		xfs_create_tmpfile(struct user_namespace *mnt_userns,
> -			   struct xfs_inode *dp, umode_t mode,
> +			   struct xfs_inode *dp, umode_t mode, bool init_xattrs,
>  			   struct xfs_inode **ipp);
>  int		xfs_remove(struct xfs_inode *dp, struct xfs_name *name,
>  			   struct xfs_inode *ip);
> diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
> index 2e10e1c66ad6..10a5e85f2a70 100644
> --- a/fs/xfs/xfs_iops.c
> +++ b/fs/xfs/xfs_iops.c
> @@ -200,7 +200,8 @@ xfs_generic_create(
>  				xfs_create_need_xattr(dir, default_acl, acl),
>  				&ip);
>  	} else {
> -		error = xfs_create_tmpfile(mnt_userns, XFS_I(dir), mode, &ip);
> +		error = xfs_create_tmpfile(mnt_userns, XFS_I(dir), mode, false,
> +					   &ip);
>  	}
>  	if (unlikely(error))
>  		goto out_free_acl;
> -- 
> 2.25.1
> 
