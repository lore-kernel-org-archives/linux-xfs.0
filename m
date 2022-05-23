Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7127C433F5
	for <linux-xfs@archiver.kernel.org>; Mon, 23 May 2022 01:17:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231931AbiEWBRE (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 22 May 2022 21:17:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230072AbiEWBRD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 22 May 2022 21:17:03 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EA4CB63
        for <linux-xfs@vger.kernel.org>; Sun, 22 May 2022 18:17:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 17A35B80E2D
        for <linux-xfs@vger.kernel.org>; Mon, 23 May 2022 01:16:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9812C385AA;
        Mon, 23 May 2022 01:16:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653268617;
        bh=O/P0ytzKXqYcYyb/gKvgMMLIyfvI6ItZ3H4lRz+WhCE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=fFwBZZDa4YhSguVh0+9QBVMrLwDoYdBA1XZofTacmmimTO/2RXLosVAc6v9jzDml3
         mDXz0VDFNqdXeI/YYjp032ffmC06F2pFE2dfu+zPgqenX5DzXO2TqvxTn+l0B4vpRd
         AKCw70c2P2n4xG3CmSDxv80asAh2ced7618sxK4T8xj9OeIxACLu+Q3n35tjfhdI/D
         JxcrE56OtQU4IgqxfKifKYjea0ShB0NTkV0ot6ev7CGyHUS9ZNfnb2ldZasgSxgD8U
         Elez3zNO8bnY53eah7pKBafWMkBAoYVVAWXiU2/um6pUw2CKG5EdXRX8pYBB2I1CX8
         4SUmb8EsIpMag==
Date:   Sun, 22 May 2022 18:16:57 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org, allison.henderson@oracle.com
Subject: Re: [PATCH 3/5] xfs: warn about LARP once per day
Message-ID: <YorgidgW7bXAdcZt@magnolia>
References: <165323329374.78886.11371349029777433302.stgit@magnolia>
 <165323331075.78886.2887944532927333265.stgit@magnolia>
 <20220522225404.GN1098723@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220522225404.GN1098723@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, May 23, 2022 at 08:54:04AM +1000, Dave Chinner wrote:
> On Sun, May 22, 2022 at 08:28:30AM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > Since LARP is an experimental debug-only feature, we should try to warn
> > about it being in use once per day, not once per reboot.
> > 
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > ---
> >  fs/xfs/xfs_log.c |    4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> > 
> > 
> > diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> > index 9dc748abdf33..edd077e055d5 100644
> > --- a/fs/xfs/xfs_log.c
> > +++ b/fs/xfs/xfs_log.c
> > @@ -3910,8 +3910,8 @@ xfs_attr_use_log_assist(
> >  	if (error)
> >  		goto drop_incompat;
> >  
> > -	xfs_warn_once(mp,
> > -"EXPERIMENTAL logged extended attributes feature added. Use at your own risk!");
> > +	xfs_warn_daily(mp,
> > + "EXPERIMENTAL logged extended attributes feature added. Use at your own risk!");
> 
> I think even this is wrong. We need this to warn once per *mount*
> like we do with all other experimental features, not once or once
> per day.  i.e. we could have 10 filesystems mounted and only one of
> them will warn that EXPERIMENTAL features are in use.
> 
> We really need all filesystems that use an experimental feature to
> warn about the use of said feature, not just a single filesystem.
> That will make this consistent with the way we warn once (and once
> only) at mount time about EXPERIMENTAL features that are enabled at
> mount time...

Ok.  I was thinking we could have an unsigned long m_warned then all
we'd need to do is convert the existing three callers (scrub, shrink,
larp) to something like:

	if (!test_and_set_bit(XFS_WARNED_FUBAR, &mp->m_warned))
		xfs_warn(mp,
 "EXPERIMENTAL fubar feature is enabled, use at your own risk!");

Also, any thoughts on the last two patches?

--D

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
