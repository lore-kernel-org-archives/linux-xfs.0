Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82AE0EB64D9
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Jun 2023 00:00:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230054AbjF3AA0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 29 Jun 2023 20:00:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229727AbjF3AAZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 29 Jun 2023 20:00:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78C842974
        for <linux-xfs@vger.kernel.org>; Thu, 29 Jun 2023 17:00:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0EF6661662
        for <linux-xfs@vger.kernel.org>; Fri, 30 Jun 2023 00:00:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C761C433C8;
        Fri, 30 Jun 2023 00:00:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1688083223;
        bh=4DcXV37jM8J9s7nVNJ5RUXqJixhRgYQqwXLTHo16Tks=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=UmDSW9qlzvHEmGwhqGzZtu3lXhJx+GTw/43QeP/t8z8Dif7TsPaKs9s0JZtglMbo0
         EfqiNHhDDKMpNSzZLVU+MJvkquu4LC5C5RmB5I63xHsMCW1dx7Kfm6mA8CbmEi+mjw
         8AOuvEmWJm2ifC/JG1Fvn8/RNTTLfwXRwPS9pSbM6wYxnE6UYexr97AJs5M8DzvAMH
         sqz4Fayma9yH3EUD21Dz0xBukeINiSzqS0Lzp1SSHZLAAPw6ZaAVy7qKV+hIKUS8yz
         VrTVPa6l01MNvbFKx0v6Xp1id6EFm1rg2IyJYDhAM+LLPJJ+heo3L5WQFo5udcKCwc
         dCA5Oy6UMkLlw==
Date:   Thu, 29 Jun 2023 17:00:22 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCHSET 0/7] xfs: fix ranged queries and integer overflows in
 GETFSMAP
Message-ID: <20230630000022.GI11441@frogsfrogsfrogs>
References: <20230526000020.GJ11620@frogsfrogsfrogs>
 <168506055189.3727958.722711918040129046.stgit@frogsfrogsfrogs>
 <ZJEKY/Kan5gVHoKm@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZJEKY/Kan5gVHoKm@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jun 20, 2023 at 12:09:39PM +1000, Dave Chinner wrote:
> On Thu, May 25, 2023 at 05:28:08PM -0700, Darrick J. Wong wrote:
> > Hi all,
> > 
> > As part of merging the parent pointers patchset into my development
> > branch, I noticed a few problems with the GETFSMAP implementation for
> > XFS.  The biggest problem is that ranged queries don't work properly if
> > the query interval is exactly within a single record.  It turns out that
> > I didn't implement the record filtering quite right -- for the first
> > call into the btree code, we want to find any rmap that overlaps with
> > the range specified, but for subsequent calls, we only want rmaps that
> > come after the low key of the query.  This can be fixed by tweaking the
> > filtering logic and pushing the key handling into the individual backend
> > implementations.
> > 
> > The second problem I noticed is that there are integer overflows in the
> > rtbitmap and external log handlers.  This is the result of a poor
> > decision on my part to use the incore rmap records for storing the query
> > ranges; this only works for the rmap code, which is smart enough to
> > iterate AGs.  This breaks down spectacularly if someone tries to query
> > high block offsets in either the rt volume or the log device.  I fixed
> > that by introducing a second filtering implementation based entirely on
> > daddrs.
> > 
> > The third problem was minor by comparison -- the rt volume cannot ever
> > use rtblocks beyond the end of the last rtextent, so it makes no sense
> > for GETFSMAP to try to query those areas.
> > 
> > Having done that, add a few more patches to clean up some messes.
> > 
> > If you're going to start using this mess, you probably ought to just
> > pull from my git trees, which are linked below.
> > 
> > This is an extraordinary way to destroy everything.  Enjoy!
> > Comments and questions are, as always, welcome.
> > 
> > --D
> > 
> > kernel git tree:
> > https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=getfsmap-fixes
> > 
> > xfsprogs git tree:
> > https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=getfsmap-fixes
> > ---
> >  fs/xfs/libxfs/xfs_alloc.c    |   10 --
> >  fs/xfs/libxfs/xfs_refcount.c |   13 +-
> >  fs/xfs/libxfs/xfs_rmap.c     |   10 --
> >  fs/xfs/xfs_fsmap.c           |  261 ++++++++++++++++++++++--------------------
> >  fs/xfs/xfs_trace.h           |   25 ++++
> >  5 files changed, 177 insertions(+), 142 deletions(-)
> 
> Changes look sensible, but I know my limits: I'm not going to find
> off-by-one problems in this code during review.
> 
> Reviewed-by: Dave Chinner <dchinner@redhat.com>

Oh, heh, thanks for the review!

I guess I'll go spin the for-next bottle again...

--D

> -- 
> Dave Chinner
> david@fromorbit.com
