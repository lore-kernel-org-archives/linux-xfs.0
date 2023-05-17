Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8FCACC77B75
	for <linux-xfs@archiver.kernel.org>; Wed, 17 May 2023 01:21:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229814AbjEQBVC (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 16 May 2023 21:21:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229452AbjEQBVB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 16 May 2023 21:21:01 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06C3546B6
        for <linux-xfs@vger.kernel.org>; Tue, 16 May 2023 18:21:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 97D1E60FBA
        for <linux-xfs@vger.kernel.org>; Wed, 17 May 2023 01:21:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFA24C433D2;
        Wed, 17 May 2023 01:20:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1684286460;
        bh=qS6PaqO9X+LkH0ToTMHn+KZRUIZNp0ZxR1bBd5nrVTo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Dn/inrS9ScND5atIbxcByWf6CsnZV9OlhfB6NOv8HAZxVStdGeJs56jcwYo+3hepl
         juRU2qecZvXp/ScAbqba4C6JOytCNX7lgeylztuDvkWw2y6twBqVx2TRJwF2njMwt2
         cGTC1QwM1it90uASbL+d56ARag/oHZPrWMmcMD6ZgHdZ/u36lpPaoG1oE93HnO1KWC
         5r85Cq5n6QcDY5XrfQtCzftJQcHl69b07Zz5bqc9dTwi7WM/le5+Dm6I7ijVOwzuSY
         shwT2ZXmlj3hW3a9YVy/0NinUfdfq+FQ149ngBV1KpeNmmsaX1Y7Kl3+x2HdqGruI4
         7oUE25lsuLxEg==
Date:   Tue, 16 May 2023 18:20:59 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/4] xfs: defered work could create precommits
Message-ID: <20230517012059.GO858799@frogsfrogsfrogs>
References: <20230517000449.3997582-1-david@fromorbit.com>
 <20230517000449.3997582-4-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230517000449.3997582-4-david@fromorbit.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, May 17, 2023 at 10:04:48AM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> To fix a AGI-AGF-inode cluster buffer deadlock, we need to move
> inode cluster buffer oeprations to the ->iop_precommit() method.

                       operations

> However, this means that deferred operations can require precommits
> to be run on the final transaction that the deferred ops pass back
> to xfs_trans_commit() context. This will be exposed by attribute
> handling, in that the last changes to the inode in the attr set
> state machine "disappear" because the precommit operation is not run.

Wait, what?

OH, this is because the LARP state machine can log the inode in the
final transaction in its chain.  __xfs_trans_commit calls the noroll
variant of xfs_defer_finish, which means that when we get to...

> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/xfs_trans.c | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
> index 8afc0c080861..664084509af5 100644
> --- a/fs/xfs/xfs_trans.c
> +++ b/fs/xfs/xfs_trans.c
> @@ -970,6 +970,11 @@ __xfs_trans_commit(
>  		error = xfs_defer_finish_noroll(&tp);
>  		if (error)
>  			goto out_unreserve;

...here, tp might actually be a dirty transaction.  Prior to
xlog_cil_committing the dirty transaction, we need to run the precommit
hooks or else we don't actually (re)attach the inode cluster buffer to
the transaction, and everything goes batty from there.  Right?

This isn't specific to LARP; any defer item that logs an item with a
precommit hook is subject to this.  Right?

> +
> +		/* Run precomits from final tx in defer chain */

                       precommits

If the answers to the last 2 questions are 'yes' and the spelling errors
get fixed, I think I'm ok enough with this one to throw it at
fstestscloud.

Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D


> +		error = xfs_trans_run_precommits(tp);
> +		if (error)
> +			goto out_unreserve;
>  	}
>  
>  	/*
> -- 
> 2.40.1
> 
