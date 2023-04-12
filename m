Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94B86C77B6C
	for <linux-xfs@archiver.kernel.org>; Wed, 12 Apr 2023 21:43:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230088AbjDLVnL (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 12 Apr 2023 17:43:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230084AbjDLVnK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 12 Apr 2023 17:43:10 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5A001FD2
        for <linux-xfs@vger.kernel.org>; Wed, 12 Apr 2023 14:43:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6442463999
        for <linux-xfs@vger.kernel.org>; Wed, 12 Apr 2023 21:43:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE557C433D2;
        Wed, 12 Apr 2023 21:43:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681335788;
        bh=fJWmoi9iThTCK93GJPnOdhBjMhek0ugfqjLRV+86qxc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=V27HJCk5RalkP1VicxhthhKkHO+Dq+nd0JzbDffrFkXnD1aDOh53C3M1M8DGYpWCo
         4T3k1w4hGa2emsdSIjTb5QIFaR9d4YtikFENTfyh47tEEplysVsyqzOdAOQHfkqhDg
         5cwiLq8bWwuQ+sBOecCggPGKz6wr4q2kww73iYh9xz3Cygk2Fk2NTDe9pH7YhPpc1z
         uSeCRXVWqoAm7qUvCJVHA35jNpwZFTVHg25Qxhjn72dn5mMlrOFFOfoQ7/rRGzsAoe
         9ysV+yKjVlAvvjWZYGzMqCIYoq0UX/fmVy0x02AsV1b4g+G6O2HvUGFpVN6yFtcSDo
         nLv60tL+OwT3w==
Date:   Wed, 12 Apr 2023 14:43:08 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs_db: fix inverted logic in error path
Message-ID: <20230412214308.GQ360889@frogsfrogsfrogs>
References: <20230411174644.GI360889@frogsfrogsfrogs>
 <20230411235903.GF3223426@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230411235903.GF3223426@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Apr 12, 2023 at 09:59:03AM +1000, Dave Chinner wrote:
> On Tue, Apr 11, 2023 at 10:46:44AM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > smatch complains proceeding into the if body if leaf is a null pointer.
> > This is backwards, so correct that.
> > 
> > check.c:3455 process_leaf_node_dir_v2_int() warn: variable dereferenced before check 'leaf'
> > 
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > ---
> >  db/check.c |    2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/db/check.c b/db/check.c
> > index 964756d0..d5f3d225 100644
> > --- a/db/check.c
> > +++ b/db/check.c
> > @@ -3452,7 +3452,7 @@ process_leaf_node_dir_v2_int(
> >  				 id->ino, dabno, stale,
> >  				 be16_to_cpu(leaf3->hdr.stale));
> >  		error++;
> > -	} else if (!leaf && stale != be16_to_cpu(leaf->hdr.stale)) {
> > +	} else if (leaf && stale != be16_to_cpu(leaf->hdr.stale)) {
> >  		if (!sflag || v)
> >  			dbprintf(_("dir %lld block %d stale mismatch "
> >  				 "%d/%d\n"),
> 
> Looks good. I'm surprised the compiler didn't warn about this
> obviously broken code...
> 
> Reviewed-by: Dave Chinner <dchinner@redhat.com>

NAK, this logic is actually trying to switch between the V4 and V5
directory format logic, but it's using the subtlety that @leaf3 is a
null pointer for a V4 fs and non-null for a V5 fs.   Hence this check
really should be:

	} else if (!leaf3 && stale != be16_to_cpu(leaf->hdr.stale)) {

Even though that looks *totally* wrong.  But xfs_check is deprecated, so
fmeh.

So I'll go fix that and rerun through testing.  I had thought this was
fine, but xfs/291 barfed up errors overnight.

--D

> -- 
> Dave Chinner
> david@fromorbit.com
