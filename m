Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AEC70C04A6A
	for <linux-xfs@archiver.kernel.org>; Thu,  3 Aug 2023 14:56:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236056AbjHCO4B (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 3 Aug 2023 10:56:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236016AbjHCOz7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 3 Aug 2023 10:55:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB4AE1728
        for <linux-xfs@vger.kernel.org>; Thu,  3 Aug 2023 07:55:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5878761DC4
        for <linux-xfs@vger.kernel.org>; Thu,  3 Aug 2023 14:55:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B30BCC433C8;
        Thu,  3 Aug 2023 14:55:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1691074557;
        bh=PZ+8ORcdsiPMGmF6Z75WfLQyh7Jag1oOfdZeTGq9CJc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Fj8b9LX6ywFyRpOQDKDC0YBF64T3CppM1VpdsEvo/LXRTd2X6cMgN4sQH8PWtlPr5
         bqc+qErI30i4+zh106QsxtZ79EjaavgRt9knvDU6Ws6VkrA2G8sbJ6XapDQk91waj0
         2Yn3XmUvv+ZnovmlQsMHC7WLR5PG0gOAJsRs9H9120PupdmPCv/ffcMYQVYrUFSosn
         E0NFBhxqFi1WxFq1zTA1pT8AV4NQZDZjsGai+sMwYeDorB9OIFyPF0cyQK/YWjBquA
         l/nbdR8n8/IxEi8LBf+yZr+T9uy6WbVdotdoWhhCgfG0GUZH5C/ZNpVEhDnRrBIGfW
         lW+sEB48VDjZw==
Date:   Thu, 3 Aug 2023 07:55:57 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: stabilize fs summary counters for online fsck
Message-ID: <20230803145557.GF11352@frogsfrogsfrogs>
References: <20230803052218.GE11352@frogsfrogsfrogs>
 <ZMtKiMSVOtk7CbmL@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZMtKiMSVOtk7CbmL@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Aug 03, 2023 at 04:34:48PM +1000, Dave Chinner wrote:
> On Wed, Aug 02, 2023 at 10:22:18PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > If the fscounters scrubber notices incorrect summary counters, it's
> > entirely possible that scrub is simply racing with other threads that
> > are updating the incore counters.  There isn't a good way to stabilize
> > percpu counters or set ourselves up to observe live updates with hooks
> > like we do for the quotacheck or nlinks scanners, so we instead choose
> > to freeze the filesystem long enough to walk the incore per-AG
> > structures.
> > 
> > Past me thought that it was going to be commonplace to have to freeze
> > the filesystem to perform some kind of repair and set up a whole
> > separate infrastructure to freeze the filesystem in such a way that
> > userspace could not unfreeze while we were running.  This involved
> > adding a mutex and freeze_super/thaw_super functions and dealing with
> > the fact that the VFS freeze/thaw functions can free the VFS superblock
> > references on return.
> > 
> > This was all very overwrought, since fscounters turned out to be the
> > only user of scrub freezes, and it doesn't require the log to quiesce,
> > only the incore superblock counters.  We prevent other threads from
> > changing the freeze level by calling freeze_super_excl with a custom
> > freeze cookie to keep everyone else out of the filesystem.
> > 
> > The end result is that fscounters should be much more efficient.  When
> > we're checking a busy system and we can't stabilize the counters, the
> > custom freeze will do less work, which should result in less downtime.
> > Repair should be similarly speedy, but that's in the next patch.
> > 
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > ---
> >  fs/xfs/scrub/fscounters.c |  198 ++++++++++++++++++++++++++++++++++-----------
> >  fs/xfs/scrub/fscounters.h |   20 +++++
> >  fs/xfs/scrub/scrub.c      |    6 +
> >  fs/xfs/scrub/scrub.h      |    1 
> >  fs/xfs/scrub/trace.h      |   26 ++++++
> >  5 files changed, 203 insertions(+), 48 deletions(-)
> >  create mode 100644 fs/xfs/scrub/fscounters.h
> 
> Code changes look ok, though I am wondering why struct
> xchk_fscounters needs to be moved to it's own header file? AFAICT it
> is still only used by fs/xfs/scrub/fscounters.c, so I'm not sure
> what purpose the new header file serves....

The header file is the basis for the repair patch which I've previously
sent to the list.
https://lore.kernel.org/linux-xfs/168506061531.3732954.7713322896089390150.stgit@frogsfrogsfrogs/

It's not strictly needed at this time.  I'll resend without that bit.

--D

> -Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
