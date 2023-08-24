Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37087C3DA6F
	for <linux-xfs@archiver.kernel.org>; Thu, 24 Aug 2023 07:55:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234787AbjHXHzW (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 24 Aug 2023 03:55:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234949AbjHXHyz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 24 Aug 2023 03:54:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 986C5170C
        for <linux-xfs@vger.kernel.org>; Thu, 24 Aug 2023 00:54:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3839B64542
        for <linux-xfs@vger.kernel.org>; Thu, 24 Aug 2023 07:54:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F14FC433C7;
        Thu, 24 Aug 2023 07:54:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1692863692;
        bh=BPabguOcd8L9KbYxoZoYHVuV+xtimO2PsQne9dslJQU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=UE8Kw6kvVe19nNL/yggWKXbUAVN7T9ZtxmC/ZZISK4hr81obdq1Rj3NVOXvbZc8O/
         ewBmSm7TtP1/1+UdrPK003GIMgbs9589oy9tI/KaIBP4e8oSfwZt+4SghZba3WLztp
         QC4/DBf08RcTBOVC18BVNtqo8Vdl1mfi4XEBAfHtLIo0IvR6IMV4GVvezR95kwburI
         G7+ra+P8JSdtljsJ2P90S9FrRXjKrGSHVKArjhureLxtinBvyMxf3rn/JrqeVTsS7H
         SiBgPw/j5vHC3DPfGNvDZLTvMgM1wpsk3mKosmSH2Bh4ujzH5ZrFhhT/G7Va6SgjU4
         kSvmtYf8fioCg==
Date:   Thu, 24 Aug 2023 09:54:48 +0200
From:   Carlos Maiolino <cem@kernel.org>
To:     Donald Douwsma <ddouwsma@redhat.com>
Cc:     linux-xfs@vger.kernel.org, Pavel Reichl <preichl@redhat.com>,
        "Darrick J . Wong" <djwong@kernel.org>
Subject: Re: [PATCH v3] xfsrestore: suggest -x rather than assert for false
 roots
Message-ID: <20230824075448.nysr6c3regljbejf@andromeda>
References: <9vndCLUbYXuMskUywWT2tF1xXMB9o1oIRIu9CYFfBmSKma891vS_Z_bn84hb0LvXlKQy4SAktJfwgLHP4PNyXA==@protonmail.internalid>
 <20230824020704.1893521-1-ddouwsma@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230824020704.1893521-1-ddouwsma@redhat.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Aug 24, 2023 at 12:07:04PM +1000, Donald Douwsma wrote:
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
> Reviewed-by: Darrick J. Wong <djwong@kernel.org>

Thanks for the patch!

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

> 
> ---
> Changes for v2
> - Use xfsprogs style for conditional
> - Remove trailing white-space
> - Place printf format all on one line for grepability
> - use __func__ instead of gcc specific __FUNCTION__
> Changes for v3
> - Fix indentation of if statement
> ---
>  restore/tree.c | 11 +++++++++--
>  1 file changed, 9 insertions(+), 2 deletions(-)
> 
> diff --git a/restore/tree.c b/restore/tree.c
> index bfa07fe..6f3180f 100644
> --- a/restore/tree.c
> +++ b/restore/tree.c
> @@ -783,8 +783,15 @@ tree_begindir(filehdr_t *fhdrp, dah_t *dahp)
>  	/* lookup head of hardlink list
>  	 */
>  	hardh = link_hardh(ino, gen);
> -	if (need_fixrootdir == BOOL_FALSE)
> -		assert(ino != persp->p_rootino || hardh == persp->p_rooth);
> +	if (need_fixrootdir == BOOL_FALSE &&
> +	    !(ino != persp->p_rootino || hardh == persp->p_rooth)) {
> +		mlog(MLOG_ERROR | MLOG_TREE,
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
