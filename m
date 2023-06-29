Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C717EB64DC
	for <linux-xfs@archiver.kernel.org>; Thu, 29 Jun 2023 15:01:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232146AbjF2PBA (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 29 Jun 2023 11:01:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232458AbjF2PA5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 29 Jun 2023 11:00:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1633230DD
        for <linux-xfs@vger.kernel.org>; Thu, 29 Jun 2023 08:00:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A007161573
        for <linux-xfs@vger.kernel.org>; Thu, 29 Jun 2023 15:00:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A68CC433C8;
        Thu, 29 Jun 2023 15:00:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1688050856;
        bh=pArG8uTrpvpZiv7cQ4ONMZ3zy81HJG7R+kyVdAE8HRA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=EUQkzQyGI+gk2C+WsmEi6xdizowGxiH82knVPNXNnSPsf5xsaxwbp+3KM71tCvCEc
         eAhRZuBq/tREqpk8geEZq2sj0piepFo/pVz2luRoEbGmLi4qRqMPAtAJnXm+SbENCT
         Gfjs8ysPTD0FtYk2Zo/uQZgMRwz6zhXN7GyM8w7f6+VIZo0toMjd19Eu2qtLt4Fwuh
         Ws8rC8HEa2mShNYwVGh2pAA+I6R9c0odZK3/TVMdoItrR4IGrnw8X3QcH+d2cDhYSf
         dkQF3LYWHL3XhsTF9DEquJ8+WJ+RivEcU17NE7kFnT8T6aQsHKKmKj5DDpUc6fgkA5
         XpEAnE7s3pUKQ==
Date:   Thu, 29 Jun 2023 08:00:55 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Donald Douwsma <ddouwsma@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfsrestore: suggest -x rather than assert for false roots
Message-ID: <20230629150055.GE11441@frogsfrogsfrogs>
References: <20230623062918.636014-1-ddouwsma@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230623062918.636014-1-ddouwsma@redhat.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Jun 23, 2023 at 04:29:18PM +1000, Donald Douwsma wrote:
> If we're going to have a fix for false root problems its a good idea to
> let people know that there's a way to recover, error out with a useful
> message that mentions the `-x` option rather than just assert.
> 
> Before
> 
>   xfsrestore: searching media for directory dump
>   xfsrestore: reading directories
>   xfsrestore: tree.c:757: tree_begindir: Assertion `ino != persp->p_rootino || hardh == persp->p_rooth' failed.
>   Aborted
> 
> After
> 
>   xfsrestore: ERROR: tree.c:791: tree_begindir: Assertion `ino != persp->p_rootino || hardh == persp->p_rooth` failed.
>   xfsrestore: ERROR: False root detected. Recovery may be possible using the `-x` option
>   Aborted
> 
> Fixes: d7cba74 ("xfsrestore: fix rootdir due to xfsdump bulkstat misuse")
> Signed-off-by: Donald Douwsma <ddouwsma@redhat.com>
> ---
>  restore/tree.c | 13 +++++++++++--
>  1 file changed, 11 insertions(+), 2 deletions(-)
> 
> diff --git a/restore/tree.c b/restore/tree.c
> index bfa07fe..0b65d0f 100644
> --- a/restore/tree.c
> +++ b/restore/tree.c
> @@ -783,8 +783,17 @@ tree_begindir(filehdr_t *fhdrp, dah_t *dahp)
>  	/* lookup head of hardlink list
>  	 */
>  	hardh = link_hardh(ino, gen);
> -	if (need_fixrootdir == BOOL_FALSE)
> -		assert(ino != persp->p_rootino || hardh == persp->p_rooth);
> +	if (need_fixrootdir == BOOL_FALSE
> +		&& !(ino != persp->p_rootino || hardh == persp->p_rooth)) {

Usually we put the && operator on the line above.  But ignore that
comment if that's actually the predominant style in xfsrestore.

	if (need_fixrootdir == BOOL_FALSE &&
	    !(ino != persp->p_rootino || hardh == persp->p_rooth)) {

> +		mlog(MLOG_ERROR | MLOG_TREE, 

Trailing space.

> +			"%s:%d: %s: Assertion "
> +			"`ino != persp->p_rootino || hardh == persp->p_rooth` failed.\n",

Might be nice to put the entire string on one line for greppability?

		mlog(MLOG_ERROR | MLOG_TREE,
 "%s:%d: %s: Assertion `ino != persp->p_rootino || hardh == persp->p_rooth` failed.\n",

> +			__FILE__, __LINE__, __FUNCTION__);
> +		mlog(MLOG_ERROR | MLOG_TREE, _(
> +			"False root detected. "
> +			"Recovery may be possible using the `-x` option\n"));

Same here.

Otherwise this looks like a good improvement.

--D

> +		return NH_NULL;
> +	};
>  
>  	/* already present
>  	 */
> -- 
> 2.39.3
> 
