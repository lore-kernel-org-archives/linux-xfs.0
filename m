Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EFBA7C433F5
	for <linux-xfs@archiver.kernel.org>; Mon, 23 May 2022 19:31:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229868AbiEWTbp (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 23 May 2022 15:31:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230495AbiEWTaw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 23 May 2022 15:30:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72556111B84
        for <linux-xfs@vger.kernel.org>; Mon, 23 May 2022 12:12:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 03C8B612B2
        for <linux-xfs@vger.kernel.org>; Mon, 23 May 2022 19:12:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63879C385A9;
        Mon, 23 May 2022 19:12:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653333142;
        bh=x8RPDZNkogR2Ta9ZAPan7EYeADUvGriGQCRAYAvl7AI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=qANIfI6mhfSHLhCOBV78umBOotyfxST3rIosEw1HLz8u6ECHVSqjzAVeJ8cZKx2HZ
         ZYI9aMr+ptGDhZ2O1oEiXooy6f6e2YPy/60z6xnriWgUs77JjhXuYiqyqca55wdejW
         tXWN+skzioqI4mCCNjoPaDBTlxZLBW2NWqIVE2z8WCA3i1ibEmodCL771Nw74kqFtl
         NsqIgZ1R0NKY6l53X5ekDEa/glzGh/WsS/PFDXdYw2bjSvfUR3bF807PUEWXxcWF/A
         PDNdNpo2LQMjqHH10kw23yddAzcAQmKru9HWHxcexmido8Q/DFm4koyTuFpcxJfSrU
         vXlDfG/Z9RXyw==
Date:   Mon, 23 May 2022 12:12:21 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org, allison.henderson@oracle.com
Subject: Re: [PATCH 5/5] xfs: move xfs_attr_use_log_assist out of libxfs
Message-ID: <YovclVb71ZblumWh@magnolia>
References: <165323329374.78886.11371349029777433302.stgit@magnolia>
 <165323332197.78886.8893427108008735872.stgit@magnolia>
 <20220523033445.GQ1098723@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220523033445.GQ1098723@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, May 23, 2022 at 01:34:45PM +1000, Dave Chinner wrote:
> On Sun, May 22, 2022 at 08:28:42AM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > libxfs itself should never be messing with whether or not to enable
> > logging for extended attribute updates -- this decision should be made
> > on a case-by-case basis by libxfs callers.  Move the code that actually
> > enables the log features to xfs_xattr.c, and adjust the callers.
> > 
> > This removes an awkward coupling point between libxfs and what would be
> > libxlog, if the XFS log were actually its own library.  Furthermore, it
> > makes bulk attribute updates and inode security initialization a tiny
> > bit more efficient, since they now avoid cycling the log feature between
> > every single xattr.
> > 
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > ---
> >  fs/xfs/libxfs/xfs_attr.c |   12 +-------
> >  fs/xfs/xfs_acl.c         |   10 +++++++
> >  fs/xfs/xfs_ioctl.c       |   22 +++++++++++++---
> >  fs/xfs/xfs_ioctl.h       |    2 +
> >  fs/xfs/xfs_ioctl32.c     |    4 ++-
> >  fs/xfs/xfs_iops.c        |   25 ++++++++++++++----
> >  fs/xfs/xfs_log.c         |   45 --------------------------------
> >  fs/xfs/xfs_log.h         |    1 -
> >  fs/xfs/xfs_super.h       |    2 +
> >  fs/xfs/xfs_xattr.c       |   65 ++++++++++++++++++++++++++++++++++++++++++++++
> >  10 files changed, 120 insertions(+), 68 deletions(-)
> 
> This seems like the wrong way to approach this. I would have defined
> a wrapper function for xfs_attr_set() to do the log state futzing,
> not moved it all into callers that don't need (or want) to know
> anything about how attrs are logged internally....

I started doing this, and within a few hours realized that I'd set upon
yet *another* refactoring of xfs_attr_set.  I'm not willing to do that
so soon after Allison's refactoring, so I'm dropping this patch.

--D

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
