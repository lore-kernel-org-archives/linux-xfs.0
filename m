Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71AE4EB64DA
	for <linux-xfs@archiver.kernel.org>; Fri, 14 Jul 2023 06:35:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234066AbjGNGf2 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 14 Jul 2023 02:35:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234930AbjGNGfF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 14 Jul 2023 02:35:05 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83A4030CA
        for <linux-xfs@vger.kernel.org>; Thu, 13 Jul 2023 23:35:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2242C61C33
        for <linux-xfs@vger.kernel.org>; Fri, 14 Jul 2023 06:35:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 833A2C433C8;
        Fri, 14 Jul 2023 06:35:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1689316503;
        bh=uisfRFd6lCOCCTBejK2MhIRkEvEDNb04jjuDY8vMKj4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=FUQHm3b+acnK/jQ0zd8kE/NlpZsmkH+vzAb/al8PN2hDRt2G97j+qHqpZjeiVDlOW
         xv1tT02v+ZrpmO7MRuXzObz4AYVg2hi+RWcvzq43GB57Uionj7x9hh7i2o1g3zg1ws
         CHqLN0K0AjngUZYyUGOcGdBS/Xph0uA5dA9H4izBjDnCxG1NuX7AXA32LUkmgWlxb+
         idvhbShThBEpI2GIwzzj2EV2Ym8dWsdYNdg18dsBtTWhJJ5vCjUinAiRN2l7HiL4zM
         BTiuRQCx7hQRsc7fHDB+/+7KCb3r6suspwoEXeqwaz1GHEuOitNriIm+SttRL3O3Q4
         +va+QQRBSlHlQ==
Date:   Thu, 13 Jul 2023 23:35:02 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Jeff Layton <jlayton@kernel.org>
Cc:     Anthony Iliopoulos <ailiop@suse.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH v5 5/8] xfs: XFS_ICHGTIME_CREATE is unused
Message-ID: <20230714063502.GS108251@frogsfrogsfrogs>
References: <20230713-mgctime-v5-0-9eb795d2ae37@kernel.org>
 <20230713-mgctime-v5-5-9eb795d2ae37@kernel.org>
 <ZLCOaj3Xo0CWL3t2@technoir>
 <2b782aa87e50d6ee9195a9725fef2d56d52d8afe.camel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2b782aa87e50d6ee9195a9725fef2d56d52d8afe.camel@kernel.org>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jul 13, 2023 at 08:15:21PM -0400, Jeff Layton wrote:
> On Fri, 2023-07-14 at 01:53 +0200, Anthony Iliopoulos wrote:
> > On Thu, Jul 13, 2023 at 07:00:54PM -0400, Jeff Layton wrote:
> > > Nothing ever sets this flag, which makes sense since the create time is
> > > set at inode instantiation and is never changed. Remove it and the
> > > handling of it in xfs_trans_ichgtime.
> > 
> > It is currently used by xfs_repair during recreating the root inode and
> > the internal realtime inodes when needed (libxfs is exported to xfsprogs
> > so there are userspace consumers of this code).
> > 
> 
> Ahh thanks. I didn't think to look at userland for this. We can drop
> this patch, and I'll respin #6.
> 
> Looking briefly at xfsprogs, it looks like XFS_ICHGTIME_CREATE is never
> set without also setting XFS_ICHGTIME_CHG. Is that safe assumption?

There are four timestamps in an xfs inode and an ICHGTIME flag for each:
MOD is mtime, CHG is ctime, CREATE is crtime/btime, and ACCESS is atime.
I'd rather leave it that way than tie flags together.

--D

> 
> > > Signed-off-by: Jeff Layton <jlayton@kernel.org>
> > > ---
> > >  fs/xfs/libxfs/xfs_shared.h      | 2 --
> > >  fs/xfs/libxfs/xfs_trans_inode.c | 2 --
> > >  2 files changed, 4 deletions(-)
> > > 
> > > diff --git a/fs/xfs/libxfs/xfs_shared.h b/fs/xfs/libxfs/xfs_shared.h
> > > index c4381388c0c1..8989fff21723 100644
> > > --- a/fs/xfs/libxfs/xfs_shared.h
> > > +++ b/fs/xfs/libxfs/xfs_shared.h
> > > @@ -126,8 +126,6 @@ void	xfs_log_get_max_trans_res(struct xfs_mount *mp,
> > >   */
> > >  #define	XFS_ICHGTIME_MOD	0x1	/* data fork modification timestamp */
> > >  #define	XFS_ICHGTIME_CHG	0x2	/* inode field change timestamp */
> > > -#define	XFS_ICHGTIME_CREATE	0x4	/* inode create timestamp */
> > > -
> > >  
> > >  /*
> > >   * Symlink decoding/encoding functions
> > > diff --git a/fs/xfs/libxfs/xfs_trans_inode.c b/fs/xfs/libxfs/xfs_trans_inode.c
> > > index 6b2296ff248a..0c9df8df6d4a 100644
> > > --- a/fs/xfs/libxfs/xfs_trans_inode.c
> > > +++ b/fs/xfs/libxfs/xfs_trans_inode.c
> > > @@ -68,8 +68,6 @@ xfs_trans_ichgtime(
> > >  		inode->i_mtime = tv;
> > >  	if (flags & XFS_ICHGTIME_CHG)
> > >  		inode_set_ctime_to_ts(inode, tv);
> > > -	if (flags & XFS_ICHGTIME_CREATE)
> > > -		ip->i_crtime = tv;
> > >  }
> > >  
> > >  /*
> > > 
> > > -- 
> > > 2.41.0
> > > 
> > > 
> 
> 
> -- 
> Jeff Layton <jlayton@kernel.org>
