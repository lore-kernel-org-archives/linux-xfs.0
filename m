Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5568EE49AE
	for <linux-xfs@archiver.kernel.org>; Tue, 22 Aug 2023 18:34:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229582AbjHVSeH (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 22 Aug 2023 14:34:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229788AbjHVSeG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 22 Aug 2023 14:34:06 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F46BCE9
        for <linux-xfs@vger.kernel.org>; Tue, 22 Aug 2023 11:34:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E030664F6B
        for <linux-xfs@vger.kernel.org>; Tue, 22 Aug 2023 18:34:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4586BC433C8;
        Tue, 22 Aug 2023 18:34:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1692729242;
        bh=iJxLV3xQM7cURu79VS6RrMAVnAxfzd7/nN96UR3wK/M=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=tFSBCKLm10zp1oJx8x/mTz0IX7olRke/RF2rIIBNz8/2zB8u38IStHju+MPirfclt
         8/NvK75D9VBuvM+6+DIlz2sIXKNVAf0y4ulIHl5XD1snrL1DllZ0PtCREjU9JOB9D1
         Fb4QsTBM2fylgmSXK2Dhowk8vDnAXnM9nvtBb5DmidI12Fh6xdcFTY53frjq7J28/U
         TZyiGWXKqKM3LXUvyel0h4l+rUWmTyktE4kd1Pg6FKi1yPI3eJi0jxdA1yswLVRXkr
         iH18T1dfr1zVbxjlUo2m7ZOcUp43yIz4JcPfUQ9s36wTHftfBxM7YmitfhJcq7Waji
         FdiE7k10bPpEw==
Date:   Tue, 22 Aug 2023 11:34:01 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Donald Douwsma <ddouwsma@redhat.com>
Cc:     linux-xfs@vger.kernel.org, Pavel Reichl <preichl@redhat.com>
Subject: Re: [PATCH v2] xfsrestore: suggest -x rather than assert for false
 roots
Message-ID: <20230822183401.GD11263@frogsfrogsfrogs>
References: <20230807045357.360114-1-ddouwsma@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230807045357.360114-1-ddouwsma@redhat.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Aug 07, 2023 at 02:53:57PM +1000, Donald Douwsma wrote:
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
> Fixes: d7cba7410710 ("xfsrestore: fix rootdir due to xfsdump bulkstat misuse")
> Signed-off-by: Donald Douwsma <ddouwsma@redhat.com>
> 
> ---
> Changes for v2
> - Use xfsprogs style for conditional
> - Remove trailing white-space
> - Place printf format all on one line for grepability
> - use __func__ instead of gcc specific __FUNCTION__
> ---
>  restore/tree.c | 11 +++++++++--
>  1 file changed, 9 insertions(+), 2 deletions(-)
> 
> diff --git a/restore/tree.c b/restore/tree.c
> index bfa07fe..e959aa1 100644
> --- a/restore/tree.c
> +++ b/restore/tree.c
> @@ -783,8 +783,15 @@ tree_begindir(filehdr_t *fhdrp, dah_t *dahp)
>  	/* lookup head of hardlink list
>  	 */
>  	hardh = link_hardh(ino, gen);
> -	if (need_fixrootdir == BOOL_FALSE)
> -		assert(ino != persp->p_rootino || hardh == persp->p_rooth);
> +	if (need_fixrootdir == BOOL_FALSE &&
> +		!(ino != persp->p_rootino || hardh == persp->p_rooth)) {
> +		mlog(MLOG_ERROR | MLOG_TREE,

Nit: Second line of the if test has the same level of indentation as the
if body.

With that fixed,
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> +"%s:%d: %s: Assertion `ino != persp->p_rootino || hardh == persp->p_rooth` failed.\n",
> +			__FILE__, __LINE__, __func__);
> +		mlog(MLOG_ERROR | MLOG_TREE, _(
> +"False root detected. Recovery may be possible using the `-x` option\n"));
> +		return NH_NULL;
> +	}
>  
>  	/* already present
>  	 */
> -- 
> 2.39.3
> 
