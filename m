Return-Path: <SRS0=Kgg+=CR=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68ACFC433E2
	for <linux-xfs@archiver.kernel.org>; Tue,  8 Sep 2020 21:07:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 34CFF20659
	for <linux-xfs@archiver.kernel.org>; Tue,  8 Sep 2020 21:07:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728709AbgIHVH2 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 8 Sep 2020 17:07:28 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:34401 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728197AbgIHVH0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 8 Sep 2020 17:07:26 -0400
Received: from dread.disaster.area (pa49-195-191-192.pa.nsw.optusnet.com.au [49.195.191.192])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id C6893822D29;
        Wed,  9 Sep 2020 07:07:21 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1kFkpk-000517-Mg; Wed, 09 Sep 2020 07:07:20 +1000
Date:   Wed, 9 Sep 2020 07:07:20 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: quotaoff, transaction quiesce, and dquot logging
Message-ID: <20200908210720.GP12131@dread.disaster.area>
References: <20200904155949.GF529978@bfoster>
 <20200904222936.GH12131@dread.disaster.area>
 <20200908155602.GB721341@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200908155602.GB721341@bfoster>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=XJ9OtjpE c=1 sm=1 tr=0 cx=a_idp_d
        a=vvDRHhr1aDYKXl+H6jx2TA==:117 a=vvDRHhr1aDYKXl+H6jx2TA==:17
        a=kj9zAlcOel0A:10 a=reM5J-MqmosA:10 a=7-415B0cAAAA:8
        a=3RFmrxTV0MZea7iHLlsA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Sep 08, 2020 at 11:56:02AM -0400, Brian Foster wrote:
> On Sat, Sep 05, 2020 at 08:29:36AM +1000, Dave Chinner wrote:
> > IOWs, the barrier mechanism I added was designed to provide the
> > exact "no dquots are logged after the quotaoff item is committed to
> > the log" invariant you describe. It's basically the same mechanism
> > we use for draining direct IO via taking IOLOCKs to prevent new
> > submissions and calling inode_dio_wait() to drain everything in
> > flight....
> > 
> 
> Right, I follow all of the above. I've been experimenting with an
> approach that just freezes all transactions as opposed to only quota
> transactions just to reduce the amount of code involved. What I'm trying
> to point out is that I don't think this quotaoff logic alone is
> sufficient to prevent dquot log ordering problems.
> 
> Consider the following example scenario:
> 
> - fs mounted w/ user+group quotas enabled
> - inode 0x123 is in-core w/ user+group dquots already attached
> - user executes 'xfs_quota -xc "off -g" <mnt>' to turn off group quotas
> - quotaoff drains all outstanding transactions, clears (group) quota
>   flag, logs quotaoff start/end ...
> 
> Meanwhile..
> 
> - user executes an fallocate request on inode 0x123, which blocks down
>   in xfs_alloc_file_space() -> xfs_trans_alloc() due to the quotaoff in
>   progress.
> - quotaoff releases the trans barrier and begins doing its dquot
>   flush/purge thing..
> - falloc grabs the 0x123 ilock and xfs_trans_reserve_quota_bydquots() ->
>   xfs_trans_dqresv() -> xfs_trans_mod_dquot() joins the user/group
>   dquots to the transaction quota ctx because they are still attached to
>   the inode at this point (and user quota is still enabled), hence quota
>   blocks are reserved in both

There's the bug. The patch I wrote needs to ensure that the quotas
are enabled when attaching the dquot to the dqinfo. The code
currently checks for global "quota on" state, but it doesn't check
individual quota state...

> - xfs_trans_mod_dquot_byino() (via xfs_bmapi_write() -> ... -> xfs_bmap_btalloc() ->
>   xfs_bmap_btalloc_accounting()) skips accounting the allocated blocks
>   to the group dquot because it is not enabled

Right, the reservation functions need to do the same thing as
xfs_trans_mod_dquot_byino(). I simply missed that for the
reservation functions. i.e. Adding the same style of check like:

	if (XFS_IS_UQUOTA_ON(mp) && udq)

before doing anything with user quota will avoid this problem as
we are already in transaction context and the UQUOTA on or off state
will not change until the transaction ends.

> concept itself. It seems like we should be able to head this issue off
> somewhere in this sequence (i.e., checking the appropriate flag before
> the dquot is attached), but it also seems like the quotaoff start/end
> plus various quota flags all fit together a certain way and I feel like
> some pieces of the puzzle are still missing from a design standpoint...

I can't think of anything that is missing - the quota off barrier
gives us an atomic quota state change w.r.t. running transactions,
so we just need to make sure we check the quota state before joining
anything quota related to a transaction rather than assume that the
presence of a dquot attached to an inode means that quotas are on.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
