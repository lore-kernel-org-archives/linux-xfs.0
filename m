Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6BE10C433B4
	for <linux-xfs@archiver.kernel.org>; Wed, 19 May 2021 12:21:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5051761353
	for <linux-xfs@archiver.kernel.org>; Wed, 19 May 2021 12:21:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346486AbhESMW2 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 19 May 2021 08:22:28 -0400
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:47465 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1347770AbhESMWO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 19 May 2021 08:22:14 -0400
Received: from dread.disaster.area (pa49-195-118-180.pa.nsw.optusnet.com.au [49.195.118.180])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 40D7B104391B
        for <linux-xfs@vger.kernel.org>; Wed, 19 May 2021 22:20:53 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1ljLC0-002m9u-NI
        for linux-xfs@vger.kernel.org; Wed, 19 May 2021 22:20:52 +1000
Date:   Wed, 19 May 2021 22:20:52 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: don't take a spinlock unconditionally in the DIO
 fastpath
Message-ID: <20210519122052.GO2893@dread.disaster.area>
References: <20210519011920.450421-1-david@fromorbit.com>
 <20210519075929.glb3kdbthuybywcs@omega.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210519075929.glb3kdbthuybywcs@omega.lan>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=Tu+Yewfh c=1 sm=1 tr=0
        a=xcwBwyABtj18PbVNKPPJDQ==:117 a=xcwBwyABtj18PbVNKPPJDQ==:17
        a=IkcTkHD0fZMA:10 a=5FLXtPjwQuUA:10 a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8
        a=zfqAleI-jo9dw3_pwSkA:9 a=QEXdDO2ut3YA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, May 19, 2021 at 09:59:29AM +0200, Carlos Maiolino wrote:
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
> > 
> > IOWs, fio is burning ~14 whole CPUs on this spin lock.
> > 
> > So, do an unlocked check against inode size first, then if we are
> > at/beyond EOF, take the spinlock and recheck. This makes the
> > spinlock disappear from the overwrite fastpath.
> > 
> > I'd like to report that fixing this makes things go faster.
> 
> maybe you meant this does not make things go faster?

Yes, that is what this statement means. That is, I'd -like- to
report that things went faster, but reality doesn't care about what
I'd -like- to have happen, as the next sentence explained... :(

> > It
> > doesn't - it just exposes the the XFS_ILOCK as the next severe
> > contention point doing extent mapping lookups, and that now burns
> > all the 14 CPUs this spinlock was burning.
> > 
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> 
> The patch looks good, and the comments about why it's safe to not take the
> spinlock (specially why the EOF can't be moved back) is much welcomed.
> 
> Feel free to add:
> Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

thanks!

-Dave.
-- 
Dave Chinner
david@fromorbit.com
