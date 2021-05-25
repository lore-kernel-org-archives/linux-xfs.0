Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0884FC2B9F8
	for <linux-xfs@archiver.kernel.org>; Tue, 25 May 2021 07:18:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CEB7861419
	for <linux-xfs@archiver.kernel.org>; Tue, 25 May 2021 07:18:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229726AbhEYHTy (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 25 May 2021 03:19:54 -0400
Received: from mail106.syd.optusnet.com.au ([211.29.132.42]:60450 "EHLO
        mail106.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229503AbhEYHTy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 25 May 2021 03:19:54 -0400
Received: from dread.disaster.area (pa49-180-230-185.pa.nsw.optusnet.com.au [49.180.230.185])
        by mail106.syd.optusnet.com.au (Postfix) with ESMTPS id 11E9580BBE6;
        Tue, 25 May 2021 17:18:22 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1llRKX-004yAx-Bg; Tue, 25 May 2021 17:18:21 +1000
Date:   Tue, 25 May 2021 17:18:21 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: don't take a spinlock unconditionally in the DIO
 fastpath
Message-ID: <20210525071821.GI664593@dread.disaster.area>
References: <20210519011920.450421-1-david@fromorbit.com>
 <20210520233332.GB9675@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210520233332.GB9675@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=F8MpiZpN c=1 sm=1 tr=0
        a=dUIOjvib2kB+GiIc1vUx8g==:117 a=dUIOjvib2kB+GiIc1vUx8g==:17
        a=IkcTkHD0fZMA:10 a=5FLXtPjwQuUA:10 a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8
        a=7VT5sB6wFeOGSSwmT0IA:9 a=QEXdDO2ut3YA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, May 20, 2021 at 04:33:32PM -0700, Darrick J. Wong wrote:
> On Wed, May 19, 2021 at 11:19:20AM +1000, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > Because this happens at high thread counts on high IOPS devices
> > doing mixed read/write AIO-DIO to a single file at about a million
> > iops:
> > 
> >    64.09%     0.21%  [kernel]            [k] io_submit_one
> >    - 63.87% io_submit_one
> >       - 44.33% aio_write
> >          - 42.70% xfs_file_write_iter
> >             - 41.32% xfs_file_dio_write_aligned
> >                - 25.51% xfs_file_write_checks
> >                   - 21.60% _raw_spin_lock
> >                      - 21.59% do_raw_spin_lock
> >                         - 19.70% __pv_queued_spin_lock_slowpath
> > 
> > This also happens of the IO completion IO path:
> > 
> >    22.89%     0.69%  [kernel]            [k] xfs_dio_write_end_io
> >    - 22.49% xfs_dio_write_end_io
> >       - 21.79% _raw_spin_lock
> >          - 20.97% do_raw_spin_lock
> >             - 20.10% __pv_queued_spin_lock_slowpath                                                                                                            ▒
> 
> Super long line there.

Ah, forgot to trim it.

> > @@ -500,7 +510,17 @@ xfs_dio_write_end_io(
> >  	 * other IO completions here to update the EOF. Failing to serialise
> >  	 * here can result in EOF moving backwards and Bad Things Happen when
> >  	 * that occurs.
> > +	 *
> > +	 * As IO completion only ever extends EOF, we can do an unlocked check
> > +	 * here to avoid taking the spinlock. If we land within the current EOF,
> > +	 * then we do not need to do an extending update at all, and we don't
> > +	 * need to take the lock to check this. If we race with an update moving
> > +	 * EOF, then we'll either still be beyond EOF and need to take the lock,
> > +	 * or we'll be within EOF and we don't need to take it at all.
> 
> Is truncate locked out at this point too?  I /think/ it is since we
> still hold the iolock (shared or excl) which blocks truncate?

truncate and fallocate are locked out because the inode dio count is
still elevated at this point. i.e. they'll block in inode_dio_wait()
until we return to iomap_dio_complete() and it (eventually) calls
inode_dio_end()....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
