Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8AF89E9271F
	for <linux-xfs@archiver.kernel.org>; Thu,  5 Oct 2023 15:58:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237907AbjJEP6D (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 5 Oct 2023 11:58:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233953AbjJEP4r (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 5 Oct 2023 11:56:47 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62D05525D
        for <linux-xfs@vger.kernel.org>; Thu,  5 Oct 2023 06:52:33 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 134FFC32798;
        Thu,  5 Oct 2023 12:35:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1696509359;
        bh=TuF4iiJ2jpmWLmCZ3B8Wlqx8k1IBK7Tm8czNV2uJZi4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=H4snFmFcbjWCIzFh6kuQjKxmIrWcCtQF8S5S1Jc38dC/HrM6vz9KVbtLKUj7W/q8J
         IWRhe3hGIlou4+/tRw2qcJAbc8NJOywa5jOBChjVkui7bXmU2YmTbn7o9LkDZta34k
         lqGZi5B6XV9yxkKjtL80J4WN/wqolP+D6pbUYdTpEv61Z2MTj3gIfo+etH9a+GREfb
         0iBEOfspfKr2S66QW4mR68xOaVlDfuZE+XE7ZOKWmW6bBJJVuxazmAqiBadx3AVN9A
         C6ABTo0rmBZ/fHg3wq7J2/Jaunvz306dBsCxaZoBoycpTdoujgOeygr3glrlha3ux9
         qI4MM3HmR8t0A==
Date:   Thu, 5 Oct 2023 14:35:56 +0200
From:   Carlos Maiolino <cem@kernel.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/6] libxfs: use XFS_IGET_CREATE when creating new files
Message-ID: <20231005123556.yt4a6pju4fxisa77@andromeda>
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

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
Carlos


> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
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
