Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51885C433F5
	for <linux-xfs@archiver.kernel.org>; Mon, 23 May 2022 02:53:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240967AbiEWCxl (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 22 May 2022 22:53:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239751AbiEWCxk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 22 May 2022 22:53:40 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A40F37A3E
        for <linux-xfs@vger.kernel.org>; Sun, 22 May 2022 19:53:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 372CBB80EAD
        for <linux-xfs@vger.kernel.org>; Mon, 23 May 2022 02:53:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0B87C385B8;
        Mon, 23 May 2022 02:53:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653274416;
        bh=tGa3KVVIDKtjjY+vRYQVukAhXe3PE3Oy7O4Mq7ylC0Q=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Mop60/V3KnhANWONEJokt3wqDMFZey/XwotZ9zocufhGRRp3Z3CGyOTxx94C2fvXM
         jAn6oPMjbWpz+U6PjjwoNIE/jPTT+iA8mOCGW4Q2jkcu83WxxUHKBgj2oddlCTlfhc
         6tkg0Tnk3twh/RDV8yWJ70hffhpcOhGm0N8CP7qFndh2sI4Q94SrdQV1KwK70EvCFr
         Zso/tnNuT54Xef6U9svB7qN1WhU4EyAdgQF3GlOIrEcFLa3UQOqW/MIm2GJ5Z22mCu
         UCOeKzOdi1HoCnnp044pdqIijHUyLwKdqfA/5RoIJGOM9QAqAzJFrdN4ixELj0SYoc
         W6kjmNoCHwABA==
Date:   Sun, 22 May 2022 19:53:36 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org, allison.henderson@oracle.com
Subject: Re: [PATCH 3/5] xfs: warn about LARP once per day
Message-ID: <Yor3MMnNggD0oS0i@magnolia>
References: <165323329374.78886.11371349029777433302.stgit@magnolia>
 <165323331075.78886.2887944532927333265.stgit@magnolia>
 <20220522225404.GN1098723@dread.disaster.area>
 <YorgidgW7bXAdcZt@magnolia>
 <20220523025104.GP1098723@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220523025104.GP1098723@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, May 23, 2022 at 12:51:04PM +1000, Dave Chinner wrote:
> On Sun, May 22, 2022 at 06:16:57PM -0700, Darrick J. Wong wrote:
> > On Mon, May 23, 2022 at 08:54:04AM +1000, Dave Chinner wrote:
> > > On Sun, May 22, 2022 at 08:28:30AM -0700, Darrick J. Wong wrote:
> > > > From: Darrick J. Wong <djwong@kernel.org>
> > > > 
> > > > Since LARP is an experimental debug-only feature, we should try to warn
> > > > about it being in use once per day, not once per reboot.
> > > > 
> > > > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > > > ---
> > > >  fs/xfs/xfs_log.c |    4 ++--
> > > >  1 file changed, 2 insertions(+), 2 deletions(-)
> > > > 
> > > > 
> > > > diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> > > > index 9dc748abdf33..edd077e055d5 100644
> > > > --- a/fs/xfs/xfs_log.c
> > > > +++ b/fs/xfs/xfs_log.c
> > > > @@ -3910,8 +3910,8 @@ xfs_attr_use_log_assist(
> > > >  	if (error)
> > > >  		goto drop_incompat;
> > > >  
> > > > -	xfs_warn_once(mp,
> > > > -"EXPERIMENTAL logged extended attributes feature added. Use at your own risk!");
> > > > +	xfs_warn_daily(mp,
> > > > + "EXPERIMENTAL logged extended attributes feature added. Use at your own risk!");
> > > 
> > > I think even this is wrong. We need this to warn once per *mount*
> > > like we do with all other experimental features, not once or once
> > > per day.  i.e. we could have 10 filesystems mounted and only one of
> > > them will warn that EXPERIMENTAL features are in use.
> > > 
> > > We really need all filesystems that use an experimental feature to
> > > warn about the use of said feature, not just a single filesystem.
> > > That will make this consistent with the way we warn once (and once
> > > only) at mount time about EXPERIMENTAL features that are enabled at
> > > mount time...
> > 
> > Ok.  I was thinking we could have an unsigned long m_warned then all
> > we'd need to do is convert the existing three callers (scrub, shrink,
> > larp) to something like:
> > 
> > 	if (!test_and_set_bit(XFS_WARNED_FUBAR, &mp->m_warned))
> > 		xfs_warn(mp,
> >  "EXPERIMENTAL fubar feature is enabled, use at your own risk!");
> 
> Just use an m_opstate bit. We've got heaps, and these will
> eventually get reclaimed anyway....

Ok, I'll do that tomorrow.

> > Also, any thoughts on the last two patches?
> 
> Not yet, been doing tree and test stuff so far today.

<nod>

--D

> -Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
