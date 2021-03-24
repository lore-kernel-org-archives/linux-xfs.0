Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 030D8C433C1
	for <linux-xfs@archiver.kernel.org>; Wed, 24 Mar 2021 18:28:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BFB8C61A0E
	for <linux-xfs@archiver.kernel.org>; Wed, 24 Mar 2021 18:28:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237554AbhCXS2A (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 24 Mar 2021 14:28:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:45552 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237489AbhCXS11 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 24 Mar 2021 14:27:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6F2CE61A0E;
        Wed, 24 Mar 2021 18:27:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616610446;
        bh=oVUAEnv9SxpJMW3ePWH2WIqX1xiyvcueahthR33I6nc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=RqYXlbM3JVWWmkVpedkU0dhDP6+BhBGIbVm8Zf7JAFoeEL4DXZsRfCTgVy/LqqUhH
         J4JiN8/4j3ox01T31NNi2dL/xBbgDND+MwoC6HrIY5v0u50tPbk0wN7h+9WSnCjdLU
         51v6kxYf79Hnu7HPdhKD+3lKZLESSU7ljBH/rvRPjb3rxVoocOvM2fP+bF/7HMf9B0
         NwVEjbbjp1KZAp/CRmmDoDeC+PKiL4jtdUzqLevlenOnGuJ0i3/xM7RPLtMcT3OqIp
         6qwvwmEnYwgT9ScZvO1LVQ6ksvt8nC5vSMOChGyM/qCOYZJTPdPFV9frPTRHA4TUQs
         hcZ9ocpwKdoJQ==
Date:   Wed, 24 Mar 2021 11:27:25 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 06/18] xfs: don't clear the "dinode core" in
 xfs_inode_alloc
Message-ID: <20210324182725.GH22100@magnolia>
References: <20210324142129.1011766-1-hch@lst.de>
 <20210324142129.1011766-7-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210324142129.1011766-7-hch@lst.de>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Mar 24, 2021 at 03:21:17PM +0100, Christoph Hellwig wrote:
> The xfs_icdinode structure just contains a random mix of inode field,
> which are all read from the on-disk inode and mostly not looked at
> before reading the inode or initializing a new inode cluster.  The
> only exceptions are the forkoff and blocks field, which are used
> in sanity checks for freshly allocated inodes.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Hmm, does this fix the crash I complained about last time?

https://lore.kernel.org/linux-xfs/20200702183426.GD7606@magnolia/

I /think/ it does, but can't tell for sure from the comments. :/

--D

> ---
>  fs/xfs/xfs_icache.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
> index 0e43d27e8e13bc..a8d982a10df828 100644
> --- a/fs/xfs/xfs_icache.c
> +++ b/fs/xfs/xfs_icache.c
> @@ -63,8 +63,9 @@ xfs_inode_alloc(
>  	memset(&ip->i_df, 0, sizeof(ip->i_df));
>  	ip->i_flags = 0;
>  	ip->i_delayed_blks = 0;
> -	memset(&ip->i_d, 0, sizeof(ip->i_d));
>  	ip->i_d.di_flags2 = mp->m_ino_geo.new_diflags2;
> +	ip->i_d.di_nblocks = 0;
> +	ip->i_d.di_forkoff = 0;
>  	ip->i_sick = 0;
>  	ip->i_checked = 0;
>  	INIT_WORK(&ip->i_ioend_work, xfs_end_io);
> -- 
> 2.30.1
> 
