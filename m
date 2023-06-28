Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50A4CEB64D7
	for <linux-xfs@archiver.kernel.org>; Wed, 28 Jun 2023 17:46:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230499AbjF1Rqy (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 28 Jun 2023 13:46:54 -0400
Received: from dfw.source.kernel.org ([139.178.84.217]:58158 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229924AbjF1Rqx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 28 Jun 2023 13:46:53 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CB2886120E
        for <linux-xfs@vger.kernel.org>; Wed, 28 Jun 2023 17:46:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32F6EC433C8;
        Wed, 28 Jun 2023 17:46:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1687974412;
        bh=Dwo9izQV42pt2oZYexs4seMrI0z0806HpNNSAmDgYkQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Ze8P5jkgk+QUu1zCCT0uYT/2hZFg+87qsZ2mO6e0PVbRlrEy2lMNlHmU+aE6FR3+j
         4yUvUiMJsMWdcJv31GCysfLinNXO+VbL5JlCYu4OR8T96r7p4vBb2IMF8lT1eiHouZ
         yaJ4WCOkh90qpgtn7vZ68pGnWRbFyFHdHA5yq8w0xPKYsNyYvTL74+FNKgQRsn7owU
         3cbzTWZ6xVILG9gVCkW0ClNkqtubsumBMqFy2M4eryzOqgFm4eNO1p4LcxO8TBRJDL
         tBFsJlOVA6RZE94lG6N3vNyxj1qWc3Frdvaz6TmFCrXFCUZphFYE1Qgk1iDhPXdcgi
         MAOZ1gnSq4C3w==
Date:   Wed, 28 Jun 2023 10:46:51 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/8] xfs: don't reverse order of items in bulk AIL
 insertion
Message-ID: <20230628174651.GU11441@frogsfrogsfrogs>
References: <20230627224412.2242198-1-david@fromorbit.com>
 <20230627224412.2242198-2-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230627224412.2242198-2-david@fromorbit.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jun 28, 2023 at 08:44:05AM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> XFS has strict metadata ordering requirements. One of the things it
> does is maintain the commit order of items from transaction commit
> through the CIL and into the AIL. That is, if a transaction logs
> item A before item B in a modification, then they will be inserted
> into the CIL in the order {A, B}. These items are then written into
> the iclog during checkpointing in the order {A, B}. When the
> checkpoint commits, they are supposed to be inserted into the AIL in
> the order {A, B}, and when they are pushed from the AIL, they are
> pushed in the order {A, B}.
> 
> If we crash, log recovery then replays the two items from the
> checkpoint in the order {A, B}, resulting in the objects the items
> apply to being queued for writeback at the end of the checkpoint
> in the order {A, B}. This means recovery behaves the same way as the
> runtime code.
> 
> In places, we have subtle dependencies on this ordering being
> maintained. One of this place is performing intent recovery from the
> log. It assumes that recovering an intent will result in a
> non-intent object being the first thing that is modified in the
> recovery transaction, and so when the transaction commits and the
> journal flushes, the first object inserted into the AIL beyond the
> intent recovery range will be a non-intent item.  It uses the
> transistion from intent items to non-intent items to stop the
> recovery pass.
> 
> A recent log recovery issue indicated that an intent was appearing
> as the first item in the AIL beyond the recovery range, hence
> breaking the end of recovery detection that exists.
> 
> Tracing indicated insertion of the items into the AIL was apparently
> occurring in the right order (the intent was last in the commit item
> list), but the intent was appearing first in the AIL. IOWs, the
> order of items in the AIL was {D,C,B,A}, not {A,B,C,D}, and bulk
> insertion was reversing the order of the items in the batch of items
> being inserted.
> 
> Lucky for us, all the items fed to bulk insertion have the same LSN,
> so the reversal of order does not affect the log head/tail tracking
> that is based on the contents of the AIL. It only impacts on code
> that has implicit, subtle dependencies on object order, and AFAICT
> only the intent recovery loop is impacted by it.
> 
> Make sure bulk AIL insertion does not reorder items incorrectly.
> 
> Fixes: 0e57f6a36f9b ("xfs: bulk AIL insertion during transaction commit")
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Coulda sworn I already RVBd this but cannot find any evidence I actually
did.

Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_trans_ail.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_trans_ail.c b/fs/xfs/xfs_trans_ail.c
> index 7d4109af193e..1098452e7f95 100644
> --- a/fs/xfs/xfs_trans_ail.c
> +++ b/fs/xfs/xfs_trans_ail.c
> @@ -823,7 +823,7 @@ xfs_trans_ail_update_bulk(
>  			trace_xfs_ail_insert(lip, 0, lsn);
>  		}
>  		lip->li_lsn = lsn;
> -		list_add(&lip->li_ail, &tmp);
> +		list_add_tail(&lip->li_ail, &tmp);
>  	}
>  
>  	if (!list_empty(&tmp))
> -- 
> 2.40.1
> 
