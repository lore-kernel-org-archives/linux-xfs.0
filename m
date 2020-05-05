Return-Path: <SRS0=NnDK=6T=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9CA6C47258
	for <linux-xfs@archiver.kernel.org>; Tue,  5 May 2020 22:36:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C44B1206FA
	for <linux-xfs@archiver.kernel.org>; Tue,  5 May 2020 22:36:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729370AbgEEWgv (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 5 May 2020 18:36:51 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:44949 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729398AbgEEWgt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 5 May 2020 18:36:49 -0400
Received: from dread.disaster.area (pa49-195-157-175.pa.nsw.optusnet.com.au [49.195.157.175])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id CEBAC58BBB0;
        Wed,  6 May 2020 08:36:45 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1jW6B9-0000TB-Va; Wed, 06 May 2020 08:36:43 +1000
Date:   Wed, 6 May 2020 08:36:43 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v4 00/17] xfs: flush related error handling cleanups
Message-ID: <20200505223643.GO2040@dread.disaster.area>
References: <20200504141154.55887-1-bfoster@redhat.com>
 <20200504215307.GL2040@dread.disaster.area>
 <20200505115810.GA60048@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200505115810.GA60048@bfoster>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=QIgWuTDL c=1 sm=1 tr=0
        a=ONQRW0k9raierNYdzxQi9Q==:117 a=ONQRW0k9raierNYdzxQi9Q==:17
        a=kj9zAlcOel0A:10 a=sTwFKg_x9MkA:10 a=7-415B0cAAAA:8
        a=xdAnyV-4onUG7gXlSvMA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, May 05, 2020 at 07:58:10AM -0400, Brian Foster wrote:
> On Tue, May 05, 2020 at 07:53:07AM +1000, Dave Chinner wrote:
> > On Mon, May 04, 2020 at 10:11:37AM -0400, Brian Foster wrote:
> > > Hi all,
> > > 
> > > I think everything has been reviewed to this point. Only minor changes
> > > noted below in this release. A git repo is available here[1].
> > > 
> > > The only outstanding feedback that I'm aware of is Dave's comment on
> > > patch 7 of v3 [2] regarding the shutdown assert check. I'm not aware of
> > > any means to get through xfs_wait_buftarg() with a dirty buffer that
> > > hasn't undergone the permanant error sequence and thus shut down the fs.
> > 
> > # echo 0 > /sys/fs/xfs/<dev>/fail_at_unmount
> > 
> > And now any error with a "retry forever" config (the default) will
> > be collected by xfs_buftarg_wait() without a preceeding shutdown as
> > xfs_buf_iodone_callback_error() will not treat it as a permanent
> > error during unmount. i.e. this doesn't trigger:
> > 
> >         /* At unmount we may treat errors differently */
> >         if ((mp->m_flags & XFS_MOUNT_UNMOUNTING) && mp->m_fail_unmount)
> >                 goto permanent_error;
> > 
> > and so the error handling just marks it with a write error and lets
> > it go for a write retry in future. These are then collected in
> > xfs_buftarg_wait() as nothing is going to retry them once unmount
> > gets to this point...
> > 
> 
> That doesn't accurately describe the behavior of that configuration,
> though. "Retry forever" means that dirty buffers are going to cycle
> through submission retries and the unmount is going to hang indefinitely
> (on pushing the AIL). Indeed, preventing this unmount hang is the
> original purpose of the fail at unmount knob (commit here[1]).

So this patch is relying on something else hanging before we get to
xfs_wait_buftarg and hence "we don't have to handle that here".

Please document that assumption along with the ASSERT, because if we
change AIL behaviour to prevent retry-forever hangs with freeze
and/or remount-ro we're going to hit this assert...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
