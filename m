Return-Path: <SRS0=2CQE=7X=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4FD84C433E0
	for <linux-xfs@archiver.kernel.org>; Wed, 10 Jun 2020 23:40:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 309652074B
	for <linux-xfs@archiver.kernel.org>; Wed, 10 Jun 2020 23:40:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726835AbgFJXkY (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 10 Jun 2020 19:40:24 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:45031 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726782AbgFJXkY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 10 Jun 2020 19:40:24 -0400
Received: from dread.disaster.area (pa49-180-124-177.pa.nsw.optusnet.com.au [49.180.124.177])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id C942F820FBC;
        Thu, 11 Jun 2020 09:40:21 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1jjAKG-0001O9-K4; Thu, 11 Jun 2020 09:40:08 +1000
Date:   Thu, 11 Jun 2020 09:40:08 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 28/30] xfs: rework xfs_iflush_cluster() dirty inode
 iteration
Message-ID: <20200610234008.GM2040@dread.disaster.area>
References: <20200604074606.266213-1-david@fromorbit.com>
 <20200604074606.266213-29-david@fromorbit.com>
 <20200609131155.GB40899@bfoster>
 <20200609220139.GJ2040@dread.disaster.area>
 <20200610130628.GA50747@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200610130628.GA50747@bfoster>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=X6os11be c=1 sm=1 tr=0
        a=k3aV/LVJup6ZGWgigO6cSA==:117 a=k3aV/LVJup6ZGWgigO6cSA==:17
        a=kj9zAlcOel0A:10 a=nTHF0DUjJn0A:10 a=7-415B0cAAAA:8
        a=TmuYs_TZynHkUtMz8tQA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jun 10, 2020 at 09:06:28AM -0400, Brian Foster wrote:
> On Wed, Jun 10, 2020 at 08:01:39AM +1000, Dave Chinner wrote:
> > On Tue, Jun 09, 2020 at 09:11:55AM -0400, Brian Foster wrote:
> > > On Thu, Jun 04, 2020 at 05:46:04PM +1000, Dave Chinner wrote:
> > > > -		 * check is not sufficient.
> > > > +		 * If we are shut down, unpin and abort the inode now as there
> > > > +		 * is no point in flushing it to the buffer just to get an IO
> > > > +		 * completion to abort the buffer and remove it from the AIL.
> > > >  		 */
> > > > -		if (!cip->i_ino) {
> > > > -			xfs_ifunlock(cip);
> > > > -			xfs_iunlock(cip, XFS_ILOCK_SHARED);
> > > > +		if (XFS_FORCED_SHUTDOWN(mp)) {
> > > > +			xfs_iunpin_wait(ip);
> > > 
> > > Note that we have an unlocked check above that skips pinned inodes.
> > 
> > Right, but we could be racing with a transaction commit that pinned
> > the inode and a shutdown. As the comment says: it's a quick and
> > dirty check to avoid trying to get locks when we know that it is
> > unlikely we can flush the inode without blocking. We still have to
> > recheck that state once we have the ILOCK....
> > 
> 
> Right, but that means we can just as easily skip the shutdown processing
> (which waits for unpin) if a particular inode is pinned. So which is
> supposed to happen in the shutdown case?
>
> ISTM that either could happen. As a result this kind of looks like
> random logic to me.

Yes, shutdown is racy, so it could be either. However, I'm not
changing the shutdown logic or handling here. If the shutdown race
could happen before this patchset (and it can), it can still happen
after the patchset, and this patchset does not change the way we
handle the shutdown race at all.

IOWs, while this shutdown logic may appear "random", that's not a
result of this patchset - it a result of design decisions made in
the last major shutdown rework/cleanup that required checks to be
added to places that could hang waiting for an event that would
never occur because shutdown state prevented it from occurring.

There's already enough complexity in this patchset that adding
shutdown logic changes is just too much to ask for.  If we want to
change how various shutdown logics work, lets do it as a separate
set of changes so all the subtle bugs that result from the changes
bisect to the isolated shutdown logic changes...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
