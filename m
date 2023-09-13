Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A3C3EDEC4F
	for <linux-xfs@archiver.kernel.org>; Wed, 13 Sep 2023 12:58:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240665AbjIMM6Z (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 13 Sep 2023 08:58:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239713AbjIMM6Z (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 13 Sep 2023 08:58:25 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 359CE19B4
        for <linux-xfs@vger.kernel.org>; Wed, 13 Sep 2023 05:58:21 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5040C433C7;
        Wed, 13 Sep 2023 12:58:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1694609900;
        bh=OD9QYWtPllxoaNPT2p5l37SrzI5p6Ful+SR/1Cpnn64=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=AuDi8j87JaBIOKS30yyqsvF682nbrFkO6fYo63E1aTjHpTiEpbHa1CTUT7L70JQ2e
         4BK9A03tRYqRVic82J+/GlE94nGBFphiDvm4ZyvH7jhx/nDAwaaRei8Dtv72VSEh/P
         /Vmly2xHsuvu6b2NPPDL8x3Mn6rTwt70tNxJdaHE3Jc6iHv7uslPIK6iNlO2f9HkKF
         s+i92C6PggqABzH5YVj5zLcONtsav2Uy3qcOQBVXd8ROIo90W7Ixs3d9smo8vv+38F
         OHCA9AiD98a342Yjs/L52eRFRhJ9T32IjcV8z6BYJAHtvsR2rioSBbusaXnIxlSXTp
         M9kkeZYSBol7g==
Date:   Wed, 13 Sep 2023 14:58:16 +0200
From:   Carlos Maiolino <cem@kernel.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/6] libxfs: use XFS_IGET_CREATE when creating new files
Message-ID: <20230913125816.jlrpbrol7u6nidcg@andromeda>
References: <169454757570.3539425.3597048437340386509.stgit@frogsfrogsfrogs>
 <kv5ZrgmAplafivXwNCHNwJEF4N3Ri8bwYvanxuMKj_kk-0aDYKm7AtDx76mhEP69Ug9CTu7lhqFuPTkDS81kzg==@protonmail.internalid>
 <169454759296.3539425.5228393276062246709.stgit@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <169454759296.3539425.5228393276062246709.stgit@frogsfrogsfrogs>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Sep 12, 2023 at 12:39:52PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Use this flag to check that newly allocated inodes are, in fact,
> unallocated.  This matches the kernel, and prevents userspace programs
> from making latent corruptions worse by unintentionally crosslinking
> files.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>

Looks good,
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>


> ---
>  libxfs/util.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> 
> diff --git a/libxfs/util.c b/libxfs/util.c
> index e7d3497ec96..8f79b0cd17b 100644
> --- a/libxfs/util.c
> +++ b/libxfs/util.c
> @@ -260,7 +260,7 @@ libxfs_init_new_inode(
>  	unsigned int		flags;
>  	int			error;
> 
> -	error = libxfs_iget(tp->t_mountp, tp, ino, 0, &ip);
> +	error = libxfs_iget(tp->t_mountp, tp, ino, XFS_IGET_CREATE, &ip);
>  	if (error != 0)
>  		return error;
>  	ASSERT(ip != NULL);
> 
