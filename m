Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C14C8EB64DD
	for <linux-xfs@archiver.kernel.org>; Wed, 12 Jul 2023 15:44:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233792AbjGLPo5 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 12 Jul 2023 11:44:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231856AbjGLPo4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 12 Jul 2023 11:44:56 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F58810C4
        for <linux-xfs@vger.kernel.org>; Wed, 12 Jul 2023 08:44:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C13DD61871
        for <linux-xfs@vger.kernel.org>; Wed, 12 Jul 2023 15:44:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 210CAC433C7;
        Wed, 12 Jul 2023 15:44:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1689176694;
        bh=4HynN4gJAuFfP5i5kPqYkjPpt+kinSyN6YDdbdAqeXs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=hVyeTvRK12AyjCf3Kc1yOu5EejJsKYUgbRBAEtdudoRYtOswvKVMTGnlaJB3b+qYw
         NIVDBaL2dgIZ2BmHSz1RqXKmwT+RCu4or2ZNTS5nTYdZTrzYfSBoGavQnHF05e24c+
         ntaTwFoxnPKZe3bM3VgVnfFUkV0bGWjLOYfNXKPXTxmnVGgGHgo5a695+7QQTfbKZc
         mxYTjIxhtVAK6xnGaj4Siu2rHN/7VDFDKtCcldKevc+JNILkQ9Efl+mMPUnqGzYTMh
         x5wshmCx1Qg+QXYxD3mg3jwtGK0Qbr9rauALwY7UFDcHpzvcBSdo5bKeB/edgC8RCS
         w1ENufTlwfVOg==
Date:   Wed, 12 Jul 2023 08:44:53 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Chandan Babu R <chandan.babu@oracle.com>,
        Leah Rumancik <leah.rumancik@gmail.com>,
        Dave Chinner <david@fromorbit.com>,
        Chris Dunlop <chris@onthe.net.au>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 6.1 CANDIDATE 0/3] xfs inodegc fixes for 6.1.y (from v6.4)
Message-ID: <20230712154453.GE108251@frogsfrogsfrogs>
References: <20230712094733.1265038-1-amir73il@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230712094733.1265038-1-amir73il@gmail.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jul 12, 2023 at 12:47:30PM +0300, Amir Goldstein wrote:
> Darrick,
> 
> These are the patches we discussed that Leah requested for the 5.15.y
> backport of non-blocking inodegc pushes series [1].
> 
> They may or may not help the 5.15.y -> 6.1.y regression that was
> reported by Chris [2].
> 
> Note that I did not include:
> 2d5f38a31980 ("xfs: disable reaping in fscounters scrub")
> in this backport set, because I generally do not want to deal with
> backporting fixes for experimental features.

I don't agree with this decision because the comment for
xfs_inodegc_stop now says that callers must hold s_umount.
xchk_stop_reaping definitely does /not/ hold that lock, which means it's
now buggy.  Someone downstream could be using scrub, even if it's still
experimental.

I've generally said not to bother with scrub fixes, but I don't think
it's correct to introduce a bug in an LTS kernel.  Please backport
2d5f38a31980 since all it does is removes the offending call and turns
off code in fscounters.c.

--D

> This series has gone through the usual kdevops testing routine.
> 
> Please ACK.
> 
> Thanks,
> Amir.
> 
> [1] https://www.spinics.net/lists/linux-xfs/msg61813.html
> [2] https://lore.kernel.org/all/ZK4E%2FgGuaBu+qvKL@dread.disaster.area/
> 
> Darrick J. Wong (3):
>   xfs: explicitly specify cpu when forcing inodegc delayed work to run
>     immediately
>   xfs: check that per-cpu inodegc workers actually run on that cpu
>   xfs: fix xfs_inodegc_stop racing with mod_delayed_work
> 
>  fs/xfs/xfs_icache.c | 40 +++++++++++++++++++++++++++++++++-------
>  fs/xfs/xfs_mount.h  |  3 +++
>  fs/xfs/xfs_super.c  |  3 +++
>  3 files changed, 39 insertions(+), 7 deletions(-)
> 
> -- 
> 2.34.1
> 
