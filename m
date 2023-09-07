Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26CEBEC875B
	for <linux-xfs@archiver.kernel.org>; Thu,  7 Sep 2023 21:40:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235106AbjIGVkM (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 7 Sep 2023 17:40:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236616AbjIGVkL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 7 Sep 2023 17:40:11 -0400
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AC3E1BDD
        for <linux-xfs@vger.kernel.org>; Thu,  7 Sep 2023 14:40:05 -0700 (PDT)
Received: by mail-pg1-x536.google.com with SMTP id 41be03b00d2f7-5654051b27fso1092632a12.0
        for <linux-xfs@vger.kernel.org>; Thu, 07 Sep 2023 14:40:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1694122805; x=1694727605; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=awtzfXvtvHooPM3WqNF2yUt1F3YwH28SL8iOT9QCT3E=;
        b=MbX25niFJivA368U9fxhfiWXI9DyXogc4k7lSkaDY49XQ58B4OeOwslerMWm4xqNAV
         pnySe2RD86vGj94JHPOUoRoJ/y+9VH1XnTWyiihoUUmRkq5s4U3oukOuQD/EgWk2LE6z
         Y7GX7Zx00kHWRs9qXsC9IO2wFGEq15H3vs1a5gQWwVhz8w250MJ0pWfDmpt42WF7eJJO
         vqcWVBvKClKmu67Xru+eGji4aB/IWEMaKik1WdnC2d4g7o52XQ3z42pCE85Ss+I70Cl4
         63BVcv+JeT2K2F5lJhz5Dwsp3m+B9K6sg03wO2hYvssbk+kXse91oSFTSjL+d8jmrUqY
         UKxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694122805; x=1694727605;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=awtzfXvtvHooPM3WqNF2yUt1F3YwH28SL8iOT9QCT3E=;
        b=szAMlS2aUtciY91pSrLG2T27i/ZuHyDW2xM5bbqsnAzz6+v6fv50nO94XpI2aPGlPt
         YSWhsbeGXeYItWc4OU3JRO8ABQz7JGAJdLRI/aipoB1rSDdxCD3h7Wx/lbpxu7YoS/Sw
         rzBS+BEyfh6pwn5ckkYeNzVuIkLpQkJ+3TeF+FW+LSXcHoK+qd/OLsg/x3pz06wQ55iR
         zFEfEyai7BOXQzrmlM29mowJU7VaSr3gqEwSbsZy1lwzL03wzAYdpQ6r7URa1SkbPz0e
         H+cpITt2GE8kWyGPgU2DckA24FQdtDNWgGU/aKdtbGtSwgzBNQ7M4SLaFPyhvBQPajX3
         4qOA==
X-Gm-Message-State: AOJu0YxU/Qp/8qLaTHwQg9fhw4RUmrO8G7IDA/wowhX66tuggITubvi4
        vOgrjL0YwheD6nH7ZxT2HQ2SrA==
X-Google-Smtp-Source: AGHT+IEbHEfODtwZFLHPHWdqA+qqvUaJJT9LPYz6Ye83xHvR/DDKRa0+9Wn8oz8zvvhw0QPvsBl/Kw==
X-Received: by 2002:a17:90a:fd89:b0:26d:2bac:a0bb with SMTP id cx9-20020a17090afd8900b0026d2baca0bbmr826042pjb.6.1694122804724;
        Thu, 07 Sep 2023 14:40:04 -0700 (PDT)
Received: from dread.disaster.area (pa49-195-66-88.pa.nsw.optusnet.com.au. [49.195.66.88])
        by smtp.gmail.com with ESMTPSA id t5-20020a17090aae0500b0026b3ed37ddcsm106286pjq.32.2023.09.07.14.40.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Sep 2023 14:40:04 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
        (envelope-from <david@fromorbit.com>)
        id 1qeMjJ-00CCGh-17;
        Fri, 08 Sep 2023 07:40:01 +1000
Date:   Fri, 8 Sep 2023 07:40:01 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     chandan.babu@gmail.com, linux-xfs@vger.kernel.org
Subject: Re: [PATCH v1.1 3/3] xfs: make inode unlinked bucket recovery work
 with quotacheck
Message-ID: <ZPpDMXYL06ks4l+j@dread.disaster.area>
References: <169375774749.3323693.18063212270653101716.stgit@frogsfrogsfrogs>
 <169375776451.3323693.17265659636054853468.stgit@frogsfrogsfrogs>
 <20230905163303.GU28186@frogsfrogsfrogs>
 <ZPl3ucKG33L7NI8B@dread.disaster.area>
 <20230907183441.GN28202@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230907183441.GN28202@frogsfrogsfrogs>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Sep 07, 2023 at 11:34:41AM -0700, Darrick J. Wong wrote:
> On Thu, Sep 07, 2023 at 05:11:53PM +1000, Dave Chinner wrote:
> > On Tue, Sep 05, 2023 at 09:33:03AM -0700, Darrick J. Wong wrote:
> > > From: Darrick J. Wong <djwong@kernel.org>
> > > 
> > > Teach quotacheck to reload the unlinked inode lists when walking the
> > > inode table.  This requires extra state handling, since it's possible
> > > that a reloaded inode will get inactivated before quotacheck tries to
> > > scan it; in this case, we need to ensure that the reloaded inode does
> > > not have dquots attached when it is freed.
> > > 
> > > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > > ---
> > > v1.1: s/CONFIG_QUOTA/CONFIG_XFS_QUOTA/ and fix tracepoint flags decoding
> > > ---
> > >  fs/xfs/xfs_inode.c |   12 +++++++++---
> > >  fs/xfs/xfs_inode.h |    5 ++++-
> > >  fs/xfs/xfs_mount.h |   10 +++++++++-
> > >  fs/xfs/xfs_qm.c    |    7 +++++++
> > >  4 files changed, 29 insertions(+), 5 deletions(-)
> > > 
> > > diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> > > index 56f6bde6001b..22af7268169b 100644
> > > --- a/fs/xfs/xfs_inode.c
> > > +++ b/fs/xfs/xfs_inode.c
> > > @@ -1743,9 +1743,13 @@ xfs_inactive(
> > >  	     ip->i_df.if_nextents > 0 || ip->i_delayed_blks > 0))
> > >  		truncate = 1;
> > >  
> > > -	error = xfs_qm_dqattach(ip);
> > > -	if (error)
> > > -		goto out;
> > > +	if (xfs_iflags_test(ip, XFS_IQUOTAUNCHECKED)) {
> > > +		xfs_qm_dqdetach(ip);
> > > +	} else {
> > > +		error = xfs_qm_dqattach(ip);
> > > +		if (error)
> > > +			goto out;
> > > +	}
> > 
> > That needs a comment - I'm not going to remember why sometimes we
> > detatch dquots instead of attach them here....
> 
> 	/*
> 	 * If this inode is being inactivated during a quotacheck and
> 	 * has not yet been scanned by quotacheck, we /must/ remove the
> 	 * dquots from the inode before inactivation changes the block
> 	 * and inode counts.  Most probably this is a result of
> 	 * reloading the incore iunlinked list to purge unrecovered
> 	 * unlinked inodes.
> 	 */
> 
> How does that sound?

LGTM.

-Dave.
-- 
Dave Chinner
david@fromorbit.com
