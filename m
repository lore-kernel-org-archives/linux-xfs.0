Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 472F5C4338F
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Jul 2021 04:24:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 236CC61008
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Jul 2021 04:24:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229644AbhG3EYJ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Jul 2021 00:24:09 -0400
Received: from mail108.syd.optusnet.com.au ([211.29.132.59]:42248 "EHLO
        mail108.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229465AbhG3EYJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Jul 2021 00:24:09 -0400
Received: from dread.disaster.area (pa49-181-34-10.pa.nsw.optusnet.com.au [49.181.34.10])
        by mail108.syd.optusnet.com.au (Postfix) with ESMTPS id 27D041B161E;
        Fri, 30 Jul 2021 14:24:02 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1m9K40-00CNwE-Km; Fri, 30 Jul 2021 14:24:00 +1000
Date:   Fri, 30 Jul 2021 14:24:00 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, hch@infradead.org
Subject: Re: [PATCH 03/20] xfs: defer inode inactivation to a workqueue
Message-ID: <20210730042400.GB2757197@dread.disaster.area>
References: <162758423315.332903.16799817941903734904.stgit@magnolia>
 <162758425012.332903.3784529658243630550.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <162758425012.332903.3784529658243630550.stgit@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=Tu+Yewfh c=1 sm=1 tr=0
        a=hdaoRb6WoHYrV466vVKEyw==:117 a=hdaoRb6WoHYrV466vVKEyw==:17
        a=kj9zAlcOel0A:10 a=e_q4qTt1xDgA:10 a=VwQbUJbxAAAA:8 a=7-415B0cAAAA:8
        a=EB9kwkj8bIxfFFwXR3oA:9 a=CjuIK1q_8ugA:10 a=AjGcO6oz07-iQ99wixmX:22
        a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jul 29, 2021 at 11:44:10AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Instead of calling xfs_inactive directly from xfs_fs_destroy_inode,
> defer the inactivation phase to a separate workqueue.  With this change,
> we can speed up directory tree deletions by reducing the duration of
> unlink() calls to the directory and unlinked list updates.
> 
> By moving the inactivation work to the background, we can reduce the
> total cost of deleting a lot of files by performing the file deletions
> in disk order instead of directory entry order, which can be arbitrary.
> 
> We introduce two new inode flags -- NEEDS_INACTIVE and INACTIVATING.
> The first flag helps our worker find inodes needing inactivation, and
> the second flag marks inodes that are in the process of being
> inactivated.  A concurrent xfs_iget on the inode can still resurrect the
> inode by clearing NEEDS_INACTIVE (or bailing if INACTIVATING is set).
> 
> Unfortunately, deferring the inactivation has one huge downside --
> eventual consistency.  Since all the freeing is deferred to a worker
> thread, one can rm a file but the space doesn't come back immediately.
> This can cause some odd side effects with quota accounting and statfs,
> so we flush inactivation work during syncfs in order to maintain the
> existing behaviors, at least for callers that unlink() and sync().
> 
> For this patch we'll set the delay to zero to mimic the old timing as
> much as possible; in the next patch we'll play with different delay
> settings.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
.....
> +
> +/* Disable the inode inactivation background worker and wait for it to stop. */
> +void
> +xfs_inodegc_stop(
> +	struct xfs_mount	*mp)
> +{
> +	if (!test_and_clear_bit(XFS_OPFLAG_INODEGC_RUNNING_BIT, &mp->m_opflags))
> +		return;
> +
> +	cancel_delayed_work_sync(&mp->m_inodegc_work);
> +	trace_xfs_inodegc_stop(mp, __return_address);
> +}

FWIW, this introduces a new mount field that does the same thing as the
m_opstate field I added in my feature flag cleanup series (i.e.
atomic operational state changes).  Personally I much prefer my
opstate stuff because this is state, not flags, and the namespace is
much less verbose...

THere's also conflicts all over the place because of that. All the
RO checks are busted, lots of the quota mods in your tree conflict
with the sb_version_hasfeat -> has_feat conversion, etc.

We're going to have to reconcile this at some point soon...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
