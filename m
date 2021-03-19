Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C67F9C433E0
	for <linux-xfs@archiver.kernel.org>; Fri, 19 Mar 2021 01:49:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8BB2E64E09
	for <linux-xfs@archiver.kernel.org>; Fri, 19 Mar 2021 01:49:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229736AbhCSBs3 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 18 Mar 2021 21:48:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:50786 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229820AbhCSBsX (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 18 Mar 2021 21:48:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BBBFB64E45;
        Fri, 19 Mar 2021 01:48:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616118501;
        bh=mzPNzCcnD0AYGniOYMzc9EP7+k+dzOuDfd5mGIfVm/8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ZZYOz/2h1RzGETf5qS+aHy1iIjOfT9gA9ci+o2Q454XT+9P7vr9qmq29h1sDFenUE
         QWrXcG9FWog7ORiVfYgjEqJ8zxtrzdQs8TZABqBZlikDP9TFvFv7dOqcwp5k6zXwbi
         7nyqdLaCUqeEJXDdsOhdX1q/pBz2i3x5ZV9/5AZ5yiSCu60XjSLSlb2CjOX0zZzJ2K
         QGiOm0kDgc0Yb/N77TLty1e3wsQ5noLvYh/0xaVCwsCfnVNn3TRKrnX5+cS/EtQCsT
         w5H11P3kr4ZBXhj8hDqdwH44mTnGyRv95HoirSIL9QjhVk/is46COq1yL/RqvCNNVt
         E27uj4VhDP+8g==
Date:   Thu, 18 Mar 2021 18:48:21 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH v3 1/2] xfs: set a mount flag when perag reservation is
 active
Message-ID: <20210319014821.GP22100@magnolia>
References: <20210318161707.723742-1-bfoster@redhat.com>
 <20210318161707.723742-2-bfoster@redhat.com>
 <20210318205536.GO63242@dread.disaster.area>
 <20210318221901.GN22100@magnolia>
 <20210319010506.GP63242@dread.disaster.area>
 <20210319014303.GQ63242@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210319014303.GQ63242@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Mar 19, 2021 at 12:43:03PM +1100, Dave Chinner wrote:
> On Fri, Mar 19, 2021 at 12:05:06PM +1100, Dave Chinner wrote:
> > On Thu, Mar 18, 2021 at 03:19:01PM -0700, Darrick J. Wong wrote:
> > > TBH I think the COW recovery and the AG block reservation pieces are
> > > prime candidates for throwing at an xfs_pwork workqueue so we can
> > > perform those scans in parallel.
> > 
> > As I mentioned on #xfs, I think we only need to do the AG read if we
> > are near enospc. i.e. we can take the entire reservation at mount
> > time (which is fixed per-ag) and only take away the used from the
> > reservation (i.e. return to the free space pool) when we actually
> > access the AGF/AGI the first time. Or when we get a ENOSPC
> > event, which might occur when we try to take the fixed reservation
> > at mount time...
> 
> Which leaves the question about when we need to actually do the
> accounting needed to fix the bug Brian is trying to fix. Can that be
> delayed until we read the AGFs or have an ENOSPC event occur? Or
> maybe some other "we are near ENOSPC and haven't read all AGFs yet"
> threshold/trigger?

Or just load them in the background and let mount() return to userspace?

> If that's the case, then I'm happy to have this patchset proceed as
> it stands under the understanding that there will be follow up to
> make the clean, lots of space free mount case avoid reading the the
> AG headers.
> 
> If it can't be made constrained, then I think we probably need to
> come up with a different approach that doesn't require reading every
> AG header on every mount...
> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
