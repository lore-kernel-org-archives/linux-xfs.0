Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C5BFC433C1
	for <linux-xfs@archiver.kernel.org>; Wed, 24 Mar 2021 18:10:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5F52F61A23
	for <linux-xfs@archiver.kernel.org>; Wed, 24 Mar 2021 18:10:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237258AbhCXSKI (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 24 Mar 2021 14:10:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:39544 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237324AbhCXSJx (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 24 Mar 2021 14:09:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2BF2261A1F;
        Wed, 24 Mar 2021 18:09:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616609393;
        bh=/A1JWkDQo9+214fqCIR1vBugAXpc+jc25Hua7y9K/x4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=rgLWOQhoJewGYaGv4m34rXsShQA4TIlPKFzYyG4tnEx6wKYmr5KnI8MsJIlewHVaB
         7SyOk/R+I4ilAa31EvZ2dPCwd35vHbbaNPkJqt+KGJE5MuzxRvTUU+e+eHxUdu022k
         2/tXOhs6d+eZ6nvl+qxFR/IRRrm5/upSnF6GL5FX1nhvLsQEQdEB4kpz2dW9ej0J13
         oI8C8OnqXDP6JaLTyjKWZ29tmxyQ0ClaG5pLlBkeEP5cyBQweCwig7q3GQFUEL9Txs
         K6UyFH5AivkJg4giE2WEubQzrI8WJtU2XcMt/6YA2xmQEJq3oTFcHMdC1Jlcj79AFX
         o2IPnR8oakeZg==
Date:   Wed, 24 Mar 2021 11:09:52 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 03/18] xfs: handle crtime more carefully in
 xfs_bulkstat_one_int
Message-ID: <20210324180952.GB22100@magnolia>
References: <20210324142129.1011766-1-hch@lst.de>
 <20210324142129.1011766-4-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210324142129.1011766-4-hch@lst.de>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Mar 24, 2021 at 03:21:14PM +0100, Christoph Hellwig wrote:
> The crtime only exists for v5 inodes, so only copy it for those.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks good,
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_itable.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/xfs/xfs_itable.c b/fs/xfs/xfs_itable.c
> index ca310a125d1e14..444b551d540f44 100644
> --- a/fs/xfs/xfs_itable.c
> +++ b/fs/xfs/xfs_itable.c
> @@ -99,8 +99,6 @@ xfs_bulkstat_one_int(
>  	buf->bs_mtime_nsec = inode->i_mtime.tv_nsec;
>  	buf->bs_ctime = inode->i_ctime.tv_sec;
>  	buf->bs_ctime_nsec = inode->i_ctime.tv_nsec;
> -	buf->bs_btime = dic->di_crtime.tv_sec;
> -	buf->bs_btime_nsec = dic->di_crtime.tv_nsec;
>  	buf->bs_gen = inode->i_generation;
>  	buf->bs_mode = inode->i_mode;
>  
> @@ -113,6 +111,8 @@ xfs_bulkstat_one_int(
>  	buf->bs_version = XFS_BULKSTAT_VERSION_V5;
>  
>  	if (xfs_sb_version_has_v3inode(&mp->m_sb)) {
> +		buf->bs_btime = dic->di_crtime.tv_sec;
> +		buf->bs_btime_nsec = dic->di_crtime.tv_nsec;
>  		if (dic->di_flags2 & XFS_DIFLAG2_COWEXTSIZE)
>  			buf->bs_cowextsize_blks = dic->di_cowextsize;
>  	}
> -- 
> 2.30.1
> 
