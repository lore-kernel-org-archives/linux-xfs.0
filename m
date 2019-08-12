Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:35864 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726200AbfHLT5t (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 12 Aug 2019 15:57:49 -0400
Date: Mon, 12 Aug 2019 12:55:30 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] fs: xfs: xfs_log: Don't use KM_MAYFAIL at
 xfs_log_reserve().
Message-ID: <20190812195530.GK7138@magnolia>
References: <20190729215657.GI7777@dread.disaster.area>
 <1564653995-9004-1-git-send-email-penguin-kernel@I-love.SAKURA.ne.jp>
 <20190801185057.GT30113@42.do-not-panic.com>
 <20190801204614.GD7138@magnolia>
 <20190802222158.GU30113@42.do-not-panic.com>
 <126f1f28-de58-815c-bd37-424a06216884@i-love.sakura.ne.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <126f1f28-de58-815c-bd37-424a06216884@i-love.sakura.ne.jp>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Cc: Luis Chamberlain <mcgrof@kernel.org>, linux-xfs@vger.kernel.org, Dave Chinner <david@fromorbit.com>, Brian Foster <bfoster@redhat.com>

On Mon, Aug 12, 2019 at 07:57:27PM +0900, Tetsuo Handa wrote:
> On 2019/08/03 7:21, Luis Chamberlain wrote:
> >> I'm pretty sure this didn't solve the underlying stale data exposure
> >> problem, which might be why you think this is "opaque".  It fixes a bug
> >> that causes data writeback failure (which was the exposure vector this
> >> time) but I think the ultimate fix for the exposure problem are the two
> >> patches I linked to quite a ways back in this discussion....
> >>
> >> --D
> >>
> >> https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux.git/commit/?id=bd012b434a56d9fac3cbc33062b8e2cd6e1ad0a0
> >> https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux.git/commit/?id=adcf7c0c87191fd3616813c8ce9790f89a9a8eba
> > 
> > Got it, thanks! Even with this, I still think the current commit could
> > say a bit a more about the effects of not having this patch applied.
> > What are the effects of say having the above two patches applied but not
> > the one being submitted now?
> 
> Is this patch going to be applied as-is? Or, someone have a plan to
> rewrite the changelog?

The first one, since the patch eliminates a vector to the writeback race
problem but does not iself solve the race.

--D
