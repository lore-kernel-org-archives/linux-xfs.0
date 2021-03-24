Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3751FC433DB
	for <linux-xfs@archiver.kernel.org>; Wed, 24 Mar 2021 18:09:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F029361A21
	for <linux-xfs@archiver.kernel.org>; Wed, 24 Mar 2021 18:09:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237327AbhCXSJF (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 24 Mar 2021 14:09:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:38956 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237271AbhCXSI4 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 24 Mar 2021 14:08:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7994361A1C;
        Wed, 24 Mar 2021 18:08:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616609336;
        bh=kTicQdFzeXPTZPat4WD9GKI9PHrw7DK0YR073M2Gi8Q=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=gyFj7rtKL4sxBPH22Yrn80WEMHuT3fEv0W1lNyKOP5kd14ldQk0mJYNGg04vMDJ/6
         xKXJBBfBZ3VQrv3rO1jpVEuzyqJUBkFOmY1dE/a/FQk726V0CsvKpODmuBnfEXs61S
         LgE/e/TcCpjTmDslYd+diVNfjxWeKtvv7n67vf/VgSgb3f7ztrxaFaeiY22soZ+KCB
         6T6cI+mQDe5FDIUcbUg7UYxqOXEqO7nMa/Nbbvvnd6DtO+nuuPPF1kvpipniMAILR8
         opm7cKwBhNdaF4Vn2B8q76vGWIM+WLWofeIP/Nw05J5El3vj6DlWBgm046EEBx+epr
         o3++VMU3RnqAg==
Date:   Wed, 24 Mar 2021 11:08:55 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 02/18] xfs: consistently initialize di_flags2
Message-ID: <20210324180855.GA22100@magnolia>
References: <20210324142129.1011766-1-hch@lst.de>
 <20210324142129.1011766-3-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210324142129.1011766-3-hch@lst.de>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Mar 24, 2021 at 03:21:13PM +0100, Christoph Hellwig wrote:
> Make sure di_flags2 is always initialized.  We currently get this implicitly
> by clearing the dinode core on allocating the in-core inode, but that is
> about to go away.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Hrmm, new_diflags2 is zero on V4 filesystems, so this looks ok.

Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_icache.c | 1 +
>  fs/xfs/xfs_inode.c  | 1 -
>  2 files changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
> index 266fb77ac5608c..0e43d27e8e13bc 100644
> --- a/fs/xfs/xfs_icache.c
> +++ b/fs/xfs/xfs_icache.c
> @@ -64,6 +64,7 @@ xfs_inode_alloc(
>  	ip->i_flags = 0;
>  	ip->i_delayed_blks = 0;
>  	memset(&ip->i_d, 0, sizeof(ip->i_d));
> +	ip->i_d.di_flags2 = mp->m_ino_geo.new_diflags2;
>  	ip->i_sick = 0;
>  	ip->i_checked = 0;
>  	INIT_WORK(&ip->i_ioend_work, xfs_end_io);
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index 3fa332a1d24f9f..093689996f06f3 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -845,7 +845,6 @@ xfs_init_new_inode(
>  
>  	if (xfs_sb_version_has_v3inode(&mp->m_sb)) {
>  		inode_set_iversion(inode, 1);
> -		ip->i_d.di_flags2 = mp->m_ino_geo.new_diflags2;
>  		ip->i_d.di_cowextsize = 0;
>  		ip->i_d.di_crtime = tv;
>  	}
> -- 
> 2.30.1
> 
