Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59C0BC433EF
	for <linux-xfs@archiver.kernel.org>; Mon,  6 Jun 2022 00:02:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348695AbiFFACg (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 5 Jun 2022 20:02:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348637AbiFFACg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 5 Jun 2022 20:02:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E0E82558F
        for <linux-xfs@vger.kernel.org>; Sun,  5 Jun 2022 17:02:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 263FD60A73
        for <linux-xfs@vger.kernel.org>; Mon,  6 Jun 2022 00:02:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85D70C385A5;
        Mon,  6 Jun 2022 00:02:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654473753;
        bh=NXkZF+j5H/UIeTX7l9vXa9wITB3tQK2Vmw4h0rRGQjo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=aD6GQk+MlhnWHzTOg/d0jSiN+oBjR+GaLylBwNhqjF2upCBshUDqQZuD+jGmg7Mhl
         hq0Px5U/t6kQFWcvLXcDLSI+sb53uXaZcwvAWdqnAfo8XvtrkhOa+qbjwiFNqf83zu
         zwLz2swkbs8R3gWRPnfNpFUS292VytzHbTCdTtcU4Q+JhMlC610a/mOpKniqxKqClG
         +rTXbG2sdUgG+tWiFdflU/IRqCMqU35eqbiQaGtydOE5biXux8t0eCoyjDDIKuAgbv
         9K/m5xRlHqe5QBbRsZkXnkHP2h2OSeLAlvT0aRXv5p7zdS9560KHJ46zEEqUqi9dR1
         mWhSSn00Zhkhw==
Date:   Sun, 5 Jun 2022 17:02:33 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     Chandan Babu R <chandanrlinux@gmail.com>,
        xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs: preserve DIFLAG2_NREXT64 when setting other inode
 attributes
Message-ID: <Yp1EGf+d/rzCgvJ4@magnolia>
References: <YpzbX/5sgRIcN2LC@magnolia>
 <20220605222940.GL1098723@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220605222940.GL1098723@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jun 06, 2022 at 08:29:40AM +1000, Dave Chinner wrote:
> On Sun, Jun 05, 2022 at 09:35:43AM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > It is vitally important that we preserve the state of the NREXT64 inode
> > flag when we're changing the other flags2 fields.
> > 
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > ---
> >  fs/xfs/xfs_ioctl.c |    3 ++-
> >  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> Fixes tag?

Does this really need one?  NREXT64 is still experimental, none of this
code is in any released kernel, and I'm not even sure what would be a
good target -- the patch that introduced XFS_DIFLAG_NREXT64?

> > diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
> > index 5a364a7d58fd..0d67ff8a8961 100644
> > --- a/fs/xfs/xfs_ioctl.c
> > +++ b/fs/xfs/xfs_ioctl.c
> > @@ -1096,7 +1096,8 @@ xfs_flags2diflags2(
> >  {
> >  	uint64_t		di_flags2 =
> >  		(ip->i_diflags2 & (XFS_DIFLAG2_REFLINK |
> > -				   XFS_DIFLAG2_BIGTIME));
> > +				   XFS_DIFLAG2_BIGTIME |
> > +				   XFS_DIFLAG2_NREXT64));
> >  
> >  	if (xflags & FS_XFLAG_DAX)
> >  		di_flags2 |= XFS_DIFLAG2_DAX;
> 
> Otherwise looks good.
> 
> Reviewed-by: Dave Chinner <dchinner@redhat.com>

Thx. :)

--D

> 
> -Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
