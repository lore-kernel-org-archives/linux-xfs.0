Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35093EB64DA
	for <linux-xfs@archiver.kernel.org>; Wed,  5 Jul 2023 23:52:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231753AbjGEXwp (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 5 Jul 2023 19:52:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229793AbjGEXwp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 5 Jul 2023 19:52:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B262A172B
        for <linux-xfs@vger.kernel.org>; Wed,  5 Jul 2023 16:52:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 50A92617D6
        for <linux-xfs@vger.kernel.org>; Wed,  5 Jul 2023 23:52:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9EB3C433C7;
        Wed,  5 Jul 2023 23:52:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1688601163;
        bh=aKEWRfkQ4Uk4nGtnAdjHBLuFIU3mGhg3HPyIZqBltfc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=YPya3pOlQFN1bCR0k0mBRYCLooMfp+FtQpKI+oMTEjoQqt9Dc3DMQ81ZCDlDIHnl7
         +NuUWGCVWziaXPsfDNXq1nz3uhJnujjFUXpQxhZm+HgU8ZF3GHErT3m16FBzX9Aeah
         km2Wr7sttZNpBdz/krkIPvwtJk7TbADylUksprqO61YWyVc5zQFZNCj/gcygmDpqGq
         hMcrB7uKgVuNitOzlfpUE7TIeJDLw1IwvJNftzASGN6x30VnI6KZo+mk+KApPjAkqS
         cOFZXcP8thN0hGaMq8zhukUP1mGCOvXgiO8seqP+DiXcyKJfjIdHQ4YpklLpktidWx
         nSIdZUGzTPGWQ==
Date:   Wed, 5 Jul 2023 16:52:43 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] xfs: allow userspace to rebuild metadata structures
Message-ID: <20230705235243.GW11441@frogsfrogsfrogs>
References: <168506057570.3730125.9735079571472245559.stgit@frogsfrogsfrogs>
 <168506057600.3730125.4561906767586624097.stgit@frogsfrogsfrogs>
 <ZJO9TA2f+ne6y7cT@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZJO9TA2f+ne6y7cT@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jun 22, 2023 at 01:17:32PM +1000, Dave Chinner wrote:
> On Thu, May 25, 2023 at 05:50:47PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > Add a new (superuser-only) flag to the online metadata repair ioctl to
> > force it to rebuild structures, even if they're not broken.  We will use
> > this to move metadata structures out of the way during a free space
> > defragmentation operation.
> > 
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > ---
> >  fs/xfs/libxfs/xfs_fs.h |    6 +++++-
> >  fs/xfs/scrub/scrub.c   |   11 ++++++++++-
> >  fs/xfs/scrub/trace.h   |    3 ++-
> >  3 files changed, 17 insertions(+), 3 deletions(-)
> > 
> > 
> > diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
> > index 1cfd5bc6520a..920fd4513fcb 100644
> > --- a/fs/xfs/libxfs/xfs_fs.h
> > +++ b/fs/xfs/libxfs/xfs_fs.h
> > @@ -741,7 +741,11 @@ struct xfs_scrub_metadata {
> >   */
> >  #define XFS_SCRUB_OFLAG_NO_REPAIR_NEEDED (1u << 7)
> >  
> > -#define XFS_SCRUB_FLAGS_IN	(XFS_SCRUB_IFLAG_REPAIR)
> > +/* i: Rebuild the data structure. */
> > +#define XFS_SCRUB_IFLAG_FORCE_REBUILD	(1 << 31)
> 
> (1U << 31), otherwise a compiler somewhere will complain.
> 
> Also, why use the high bit here?

Mostly to make it much more obvious that some new flag bit is in use
here.  I'll change it to 1U<<8 before I merge it upstream.  You'll see
it in v26 which will also have all the api adjustments for 6.5.

--D

> -Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
