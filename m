Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 948D1EB64DC
	for <linux-xfs@archiver.kernel.org>; Fri, 14 Jul 2023 14:10:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234930AbjGNOKM (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 14 Jul 2023 10:10:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234693AbjGNOKL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 14 Jul 2023 10:10:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A943D1989
        for <linux-xfs@vger.kernel.org>; Fri, 14 Jul 2023 07:10:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4460A61D26
        for <linux-xfs@vger.kernel.org>; Fri, 14 Jul 2023 14:10:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97F0AC433C7;
        Fri, 14 Jul 2023 14:10:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1689343809;
        bh=sR+15sNzsRIsLjV3G5309iNuHGuE+cNi6ZnOH3UpomQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=CXuxCnaOCj25VYUOcqELnFkGASjgs9TjZmMZv5jkfPiPYeZu5fJ3AXs2FD8XsOWjW
         LBJ7qpj57XXTq9uBzlQVTH4Rr2U8Sqi1XwC7RKbk0ogA05vf61LOUoyH/pOqp2TFHk
         4tGY5iEI6DayX3ZeVDXOpvGYTUUyyEK6RXbq4lWHc9+pVaCi6vt44vKIM/yvm5Jz5E
         yLj0IUXtfpnY1yVcaE6RV9VTbSm0n9nLONBw6aG7XMxeF5h77BAN1S4/yYYvjlazoa
         5A+eASHNPDNydk2/rpbzauOYXn1xjUt3imZM2bP/R3f2ICVrI5ncjnJleDujt8U5he
         4oBNoZoD/7ewQ==
Date:   Fri, 14 Jul 2023 07:10:08 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Chandan Babu R <chandan.babu@oracle.com>,
        Leah Rumancik <leah.rumancik@gmail.com>,
        Dave Chinner <david@fromorbit.com>,
        Chris Dunlop <chris@onthe.net.au>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 6.1 CANDIDATE v2 0/4] xfs inodegc fixes for 6.1.y (from
 v6.4)
Message-ID: <20230714141008.GT108251@frogsfrogsfrogs>
References: <20230714064509.1451122-1-amir73il@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230714064509.1451122-1-amir73il@gmail.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Jul 14, 2023 at 09:45:05AM +0300, Amir Goldstein wrote:
> Darrick,
> 
> These are the patches we discussed that Leah requested for the 5.15.y
> backport of non-blocking inodegc pushes series [1].
> 
> They may or may not help the 5.15.y -> 6.1.y regression that was
> reported by Chris [2].
> 
> This v2 series has gone through 3 rounds of kdevops loop on top
> of the testing already run on v1.
> 
> Please ACK.

Looks good to me,
Acked-by: Darrick J. Wong <djwong@kernel.org>

--D

> 
> Thanks,
> Amir.
> 
> Changed since v1:
> - include: 2d5f38a31980 ("xfs: disable reaping in fscounters scrub")
> 
> [1] https://www.spinics.net/lists/linux-xfs/msg61813.html
> [2] https://lore.kernel.org/all/ZK4E%2FgGuaBu+qvKL@dread.disaster.area/
> 
> Darrick J. Wong (4):
>   xfs: explicitly specify cpu when forcing inodegc delayed work to run
>     immediately
>   xfs: check that per-cpu inodegc workers actually run on that cpu
>   xfs: disable reaping in fscounters scrub
>   xfs: fix xfs_inodegc_stop racing with mod_delayed_work
> 
>  fs/xfs/scrub/common.c     | 26 -------------------------
>  fs/xfs/scrub/common.h     |  2 --
>  fs/xfs/scrub/fscounters.c | 13 ++++++-------
>  fs/xfs/scrub/scrub.c      |  2 --
>  fs/xfs/scrub/scrub.h      |  1 -
>  fs/xfs/xfs_icache.c       | 40 ++++++++++++++++++++++++++++++++-------
>  fs/xfs/xfs_mount.h        |  3 +++
>  fs/xfs/xfs_super.c        |  3 +++
>  8 files changed, 45 insertions(+), 45 deletions(-)
> 
> -- 
> 2.34.1
> 
