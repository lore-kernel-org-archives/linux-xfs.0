Return-Path: <SRS0=5D7u=6E=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA812C54FCC
	for <linux-xfs@archiver.kernel.org>; Mon, 20 Apr 2020 22:31:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B22A520724
	for <linux-xfs@archiver.kernel.org>; Mon, 20 Apr 2020 22:31:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726262AbgDTWbP (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 20 Apr 2020 18:31:15 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:33405 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725918AbgDTWbO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 20 Apr 2020 18:31:14 -0400
Received: from dread.disaster.area (pa49-180-0-232.pa.nsw.optusnet.com.au [49.180.0.232])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id DCF98584FBA;
        Tue, 21 Apr 2020 08:31:12 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1jQewa-0006V1-8t; Tue, 21 Apr 2020 08:31:12 +1000
Date:   Tue, 21 Apr 2020 08:31:12 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 06/12] xfs: remove duplicate verification from
 xfs_qm_dqflush()
Message-ID: <20200420223112.GQ9800@dread.disaster.area>
References: <20200417150859.14734-1-bfoster@redhat.com>
 <20200417150859.14734-7-bfoster@redhat.com>
 <20200420035322.GI9800@dread.disaster.area>
 <20200420140221.GF27516@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200420140221.GF27516@bfoster>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=X6os11be c=1 sm=1 tr=0
        a=XYjVcjsg+1UI/cdbgX7I7g==:117 a=XYjVcjsg+1UI/cdbgX7I7g==:17
        a=kj9zAlcOel0A:10 a=cl8xLZFz6L8A:10 a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8
        a=-ja3n3AcIAuvXTLIq7kA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Apr 20, 2020 at 10:02:21AM -0400, Brian Foster wrote:
> On Mon, Apr 20, 2020 at 01:53:22PM +1000, Dave Chinner wrote:
> > On Fri, Apr 17, 2020 at 11:08:53AM -0400, Brian Foster wrote:
> > > The dquot read/write verifier calls xfs_dqblk_verify() on every
> > > dquot in the buffer. Remove the duplicate call from
> > > xfs_qm_dqflush().
> > 
> > Ah, I think there's a bug here - it's not supposed to be a
> > duplicate....
> > 
> > > Signed-off-by: Brian Foster <bfoster@redhat.com>
> > > ---
> > >  fs/xfs/xfs_dquot.c | 14 --------------
> > >  1 file changed, 14 deletions(-)
> > > 
> > > diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
> > > index af2c8e5ceea0..73032c18a94a 100644
> > > --- a/fs/xfs/xfs_dquot.c
> > > +++ b/fs/xfs/xfs_dquot.c
> > > @@ -1071,7 +1071,6 @@ xfs_qm_dqflush(
> > >  	struct xfs_buf		*bp;
> > >  	struct xfs_dqblk	*dqb;
> > >  	struct xfs_disk_dquot	*ddqp;
> > > -	xfs_failaddr_t		fa;
> > >  	int			error;
> > >  
> > >  	ASSERT(XFS_DQ_IS_LOCKED(dqp));
> > > @@ -1116,19 +1115,6 @@ xfs_qm_dqflush(
> > >  	dqb = bp->b_addr + dqp->q_bufoffset;
> > >  	ddqp = &dqb->dd_diskdq;
> > >  
> > > -	/*
> > > -	 * A simple sanity check in case we got a corrupted dquot.
> > > -	 */
> > > -	fa = xfs_dqblk_verify(mp, dqb, be32_to_cpu(ddqp->d_id), 0);
> > 
> > So this verifies the on disk dquot ....
> > 
> > > -	if (fa) {
> > > -		xfs_alert(mp, "corrupt dquot ID 0x%x in memory at %pS",
> > 
> > ...which issues an "in memory corruption" alert on failure...
> > 
> > > -				be32_to_cpu(ddqp->d_id), fa);
> > > -		xfs_buf_relse(bp);
> > > -		xfs_dqfunlock(dqp);
> > > -		xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
> > > -		return -EFSCORRUPTED;
> > > -	}
> > > -
> > >  	/* This is the only portion of data that needs to persist */
> > >  	memcpy(ddqp, &dqp->q_core, sizeof(struct xfs_disk_dquot));
> > 
> > .... and on success we immediately overwrite the on-disk copy with
> > the unchecked in-memory copy of the dquot. 
> > 
> > IOWs, I think that verification call here should be checking the
> > in-memory dquot core, not the on disk buffer that is about to get
> > trashed.  i.e. something like this:
> > 
> > -	fa = xfs_dqblk_verify(mp, dqb, be32_to_cpu(ddqp->d_id), 0);
> > +	fa = xfs_dquot_verify(mp, &dqp->q_core, be32_to_cpu(ddqp->d_id), 0);
> > 
> 
> Isn't this still essentially duplicated by the write verifier? I don't
> feel strongly about changing it as above vs. removing it, but it does
> still seem unnecessary to me..

It's no different to the xfs_iflush_int() code that runs a heap of
checks on the in-memory inode before it is flushed to the backing
buffer. That uses a combination of open coded checks (for error
injection) and verifier functions (e.g. fork checking), so this
really isn't that unusual.

Realistically, it's better to catch the corruption as early as
possible - if we catch it here we know we corrupted the in-memory
dquot. However, if the write verifier catches it we have no idea
exactly when the corruption occurred, or whether it was a result of
a code problem or an external memory corruption in memory we haven't
modified at all...

IOWs the two checks or intended to catch very different classes of
in-memory corruptions, so they really aren't redundant or
unnecessary at all...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
