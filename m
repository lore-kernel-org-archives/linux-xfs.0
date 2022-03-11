Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AAA72C433F5
	for <linux-xfs@archiver.kernel.org>; Fri, 11 Mar 2022 00:13:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344753AbiCKAO2 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 10 Mar 2022 19:14:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238512AbiCKAO2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 10 Mar 2022 19:14:28 -0500
Received: from mail105.syd.optusnet.com.au (mail105.syd.optusnet.com.au [211.29.132.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 627A3A2517
        for <linux-xfs@vger.kernel.org>; Thu, 10 Mar 2022 16:13:26 -0800 (PST)
Received: from dread.disaster.area (pa49-186-150-27.pa.vic.optusnet.com.au [49.186.150.27])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 748CA10E291C;
        Fri, 11 Mar 2022 11:13:25 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1nSSuK-003ylS-03; Fri, 11 Mar 2022 11:13:24 +1100
Date:   Fri, 11 Mar 2022 11:13:23 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/4] xfs: log worker needs to start before intent/unlink
 recovery
Message-ID: <20220311001323.GI3927073@dread.disaster.area>
References: <20220309015512.2648074-1-david@fromorbit.com>
 <20220309015512.2648074-2-david@fromorbit.com>
 <20220310234650.GJ8224@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220310234650.GJ8224@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=e9dl9Yl/ c=1 sm=1 tr=0 ts=622a9425
        a=sPqof0Mm7fxWrhYUF33ZaQ==:117 a=sPqof0Mm7fxWrhYUF33ZaQ==:17
        a=kj9zAlcOel0A:10 a=o8Y5sQTvuykA:10 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8
        a=7-415B0cAAAA:8 a=Koss5zSuFPq2mw5qEnQA:9 a=CjuIK1q_8ugA:10
        a=AjGcO6oz07-iQ99wixmX:22 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Mar 10, 2022 at 03:46:50PM -0800, Darrick J. Wong wrote:
> On Wed, Mar 09, 2022 at 12:55:09PM +1100, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > After 963 iterations of generic/530, it deadlocked during recovery
> > on a pinned inode cluster buffer like so:
....
> > What has happened here is that the AIL push thread has raced with
> > the inodegc process modifying, committing and pinning the inode
> > cluster buffer here in xfs_buf_delwri_submit_buffers() here:
> > 
> > 	blk_start_plug(&plug);
> > 	list_for_each_entry_safe(bp, n, buffer_list, b_list) {
> > 		if (!wait_list) {
> > 			if (xfs_buf_ispinned(bp)) {
> > 				pinned++;
> > 				continue;
> > 			}
> > Here >>>>>>
> > 			if (!xfs_buf_trylock(bp))
> > 				continue;
> > 
> > Basically, the AIL has found the buffer wasn't pinned and got the
> > lock without blocking, but then the buffer was pinned. This implies
> > the processing here was pre-empted between the pin check and the
> > lock, because the pin count can only be increased while holding the
> > buffer locked. Hence when it has gone to submit the IO, it has
> > blocked waiting for the buffer to be unpinned.
> > 
> > With all executing threads now waiting on the buffer to be unpinned,
> > we normally get out of situations like this via the background log
> > worker issuing a log force which will unpinned stuck buffers like
> > this. But at this point in recovery, we haven't started the log
> > worker. In fact, the first thing we do after processing intents and
> > unlinked inodes is *start the log worker*. IOWs, we start it too
> > late to have it break deadlocks like this.
> 
> Because finishing the intents, processing unlinked inodes, and freeing
> dead COW extents are all just regular transactional updates that run
> after sorting out the log contents, there's no reason why the log worker
> oughtn't be running, right?

Yes.

> > Avoid this and any other similar deadlock vectors in intent and
> > unlinked inode recovery by starting the log worker before we recover
> > intents and unlinked inodes. This part of recovery runs as though
> > the filesystem is fully active, so we really should have the same
> > infrastructure running as we normally do at runtime.
> > 
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > ---
> >  fs/xfs/xfs_log.c | 3 +--
> >  1 file changed, 1 insertion(+), 2 deletions(-)
> > 
> > diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> > index 89fec9a18c34..ffd928cf9a9a 100644
> > --- a/fs/xfs/xfs_log.c
> > +++ b/fs/xfs/xfs_log.c
> > @@ -812,10 +812,9 @@ xfs_log_mount_finish(
> >  	 * mount failure occurs.
> >  	 */
> >  	mp->m_super->s_flags |= SB_ACTIVE;
> > +	xfs_log_work_queue(mp);
> >  	if (xlog_recovery_needed(log))
> >  		error = xlog_recover_finish(log);
> > -	if (!error)
> > -		xfs_log_work_queue(mp);
> 
> I /think/ in the error case, we'll cancel and wait for the worker in
> xfs_mountfs -> xfs_log_mount_cancel -> xfs_log_unmount -> xfs_log_clean
> -> xfs_log_quiesce, right?

Yeah, It took me a while to convince myself we did actually tear it
down correctly on later failures in xfs_mountfs() because this is a
bit of a twisty path.

> TBH I'd tried to solve these g/530 hangs by making this exact change, so
> assuming the answers are {yes, yes}, then:
> 
> Reviewed-by: Darrick J. Wong <djwong@kernel.org>

Thanks!

-Dave.
-- 
Dave Chinner
david@fromorbit.com
