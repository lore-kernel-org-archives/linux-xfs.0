Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7DEF2C00A5A
	for <linux-xfs@archiver.kernel.org>; Wed, 18 Jan 2023 00:24:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229774AbjARAY0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 17 Jan 2023 19:24:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229649AbjARAYE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 17 Jan 2023 19:24:04 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77B9B46083
        for <linux-xfs@vger.kernel.org>; Tue, 17 Jan 2023 15:41:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E47AD6157F
        for <linux-xfs@vger.kernel.org>; Tue, 17 Jan 2023 23:41:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 443DFC433EF;
        Tue, 17 Jan 2023 23:41:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673998903;
        bh=hCeWp4xEiOTsx+NhwoiCM/s6HrWxeBfY8Zth4W10dF4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=V5RiDZazS77qe70DNIdRkOAtFpw2CiaRA/8KwG6aX2ENwCfBcoLMKQvz4KmefjbGr
         mZzLRtpzhC3aXoCYmAV4a1x1N2nzMe6s95gAuSAp1pcxQUsG9hyTpvdsQB75z5YtR/
         7UDKLxfIwz7Y1J4bDqy+kSAIz1z5Nzl16gJFzdQriXkLF+WN9CTaqhtkh8rDQDL66/
         RH7YlpzvR9AgDgQwSWsfD+d9ggTDbfaMC2rgaKe6p8DMl6b2geWNyfAS0NOiAPv1Ya
         NhqLaVJsQFUs6jrDkBGqEsi9nxrf9DlC5hVDxlE6Q1AQt4q7wjc2SQwGcrTh902Mq+
         9NNZC44AjN+ZQ==
Date:   Tue, 17 Jan 2023 15:41:42 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     Dan Carpenter <error27@gmail.com>, linux-xfs@vger.kernel.org
Subject: Re: [bug report] xfs: allow setting and clearing of log incompat
 feature flags
Message-ID: <Y8cyNsEn372fjMRb@magnolia>
References: <Y8Z+y9j2nT6bQ0Hz@kili>
 <20230117210757.GF360264@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230117210757.GF360264@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jan 18, 2023 at 08:07:57AM +1100, Dave Chinner wrote:
> On Tue, Jan 17, 2023 at 01:56:11PM +0300, Dan Carpenter wrote:
> > Hello Darrick J. Wong,
> > 
> > The patch 908ce71e54f8: "xfs: allow setting and clearing of log
> > incompat feature flags" from Aug 8, 2021, leads to the following
> > Smatch static checker warning:
> > 
> > 	fs/xfs/xfs_mount.c:1315 xfs_add_incompat_log_feature()
> > 	warn: missing error code 'error'
> > 
> > fs/xfs/xfs_mount.c
> >     1280 int
> >     1281 xfs_add_incompat_log_feature(
> >     1282         struct xfs_mount        *mp,
> >     1283         uint32_t                feature)
> >     1284 {
> >     1285         struct xfs_dsb                *dsb;
> >     1286         int                        error;
> >     1287 
> >     1288         ASSERT(hweight32(feature) == 1);
> >     1289         ASSERT(!(feature & XFS_SB_FEAT_INCOMPAT_LOG_UNKNOWN));
> >     1290 
> >     1291         /*
> >     1292          * Force the log to disk and kick the background AIL thread to reduce
> >     1293          * the chances that the bwrite will stall waiting for the AIL to unpin
> >     1294          * the primary superblock buffer.  This isn't a data integrity
> >     1295          * operation, so we don't need a synchronous push.
> >     1296          */
> >     1297         error = xfs_log_force(mp, XFS_LOG_SYNC);
> >     1298         if (error)
> >     1299                 return error;
> >     1300         xfs_ail_push_all(mp->m_ail);
> >     1301 
> >     1302         /*
> >     1303          * Lock the primary superblock buffer to serialize all callers that
> >     1304          * are trying to set feature bits.
> >     1305          */
> >     1306         xfs_buf_lock(mp->m_sb_bp);
> >     1307         xfs_buf_hold(mp->m_sb_bp);
> >     1308 
> >     1309         if (xfs_is_shutdown(mp)) {
> >     1310                 error = -EIO;
> >     1311                 goto rele;
> >     1312         }
> >     1313 
> >     1314         if (xfs_sb_has_incompat_log_feature(&mp->m_sb, feature))
> > --> 1315                 goto rele;
> >                          ^^^^^^^^^
> > It's not clear to me, why this old code is suddenly showing up as a new
> > warning...  But it does feel like it should be an error path.
> 
> Seems like a smatch issue?
> 
> error at this point will be zero and this test is checking if the
> superblock is already marked with the incompat feature we need to
> add as there can be races with adding and removing the feature flag.
> If it is set once we hold the superblock buffer locked, then we just
> need to release the locked superblock buffer and return 0 to say it
> is set.
> 
> IOWs, it looks to me like the code is correct and the checker hasn't
> understood the code pattern being used....

This is similar to the exchange we had last March:
https://lore.kernel.org/linux-xfs/20220324104521.GF12805@kadam/

wherein there was a series of if tests that would bail out early on
error, followed by one last test that checks if we've no further work to
do and returns a zero that was set earlier in the function.  This sort
of situation is probably very difficult to detect within a static
checker, but I would much prefer that we review the online fsck
patchset[1] instead of reopening review on existing code that already
works and has already been merged.

[1] https://lore.kernel.org/linux-xfs/Y69UceeA2MEpjMJ8@magnolia/

--D

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
