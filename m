Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62A1FC433EF
	for <linux-xfs@archiver.kernel.org>; Wed,  6 Jul 2022 01:35:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229648AbiGFBfg (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 5 Jul 2022 21:35:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229623AbiGFBfg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 5 Jul 2022 21:35:36 -0400
Received: from mail104.syd.optusnet.com.au (mail104.syd.optusnet.com.au [211.29.132.246])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 7922E63B3
        for <linux-xfs@vger.kernel.org>; Tue,  5 Jul 2022 18:35:35 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-2-147.pa.nsw.optusnet.com.au [49.181.2.147])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 371465ED002;
        Wed,  6 Jul 2022 11:35:34 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1o8twz-00F3NV-3V; Wed, 06 Jul 2022 11:35:33 +1000
Date:   Wed, 6 Jul 2022 11:35:33 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Wengang Wang <wen.gang.wang@oracle.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH V2] xfs: make src file readable during reflink
Message-ID: <20220706013533.GK227878@dread.disaster.area>
References: <20220629060755.25537-1-wen.gang.wang@oracle.com>
 <YsSFAmc70npnoCbM@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YsSFAmc70npnoCbM@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=OJNEYQWB c=1 sm=1 tr=0 ts=62c4e6e6
        a=ivVLWpVy4j68lT4lJFbQgw==:117 a=ivVLWpVy4j68lT4lJFbQgw==:17
        a=kj9zAlcOel0A:10 a=RgO8CyIxsXoA:10 a=7-415B0cAAAA:8
        a=u8Fc6oTTe8JoRR-HtaIA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jul 05, 2022 at 11:37:54AM -0700, Darrick J. Wong wrote:
> On Tue, Jun 28, 2022 at 11:07:55PM -0700, Wengang Wang wrote:
> > During a reflink operation, the IOLOCK and MMAPLOCK of the source file
> > are held in exclusive mode for the duration. This prevents reads on the
> > source file, which could be a very long time if the source file has
> > millions of extents.
> > 
> > As the source of copy, besides some necessary modification (say dirty page
> > flushing), it plays readonly role. Locking source file exclusively through
> > out the full reflink copy is unreasonable.
> > 
> > This patch downgrades exclusive locks on source file to shared modes after
> > page cache flushing and before cloning the extents. To avoid source file
> > change after lock downgradation, direct write paths take IOLOCK_EXCL on
> > seeing reflink copy happening to the files.
.....

> I /do/ wonder if range locking would be a better solution here, since we
> can safely unlock file ranges that we've already remapped?

Depends. The prototype I did allowed concurrent remaps to run on
different ranges of the file. The extent manipulations were still
internally serialised by the ILOCK so the concurrent modifications
were still serialised. Hence things like block mapping lookups for
read IO still serialised. (And hence my interest in lockless btrees
for the extent list so read IO wouldn't need to take the ILOCK at
all.)

However, if you want to remap the entire file, we've still got to
start with locking the entire file range and draining IO and writing
back all dirty data. So cloning a file is still a complete
serialisation event with range locking, but we can optimise away
some of the tail latencies by unlocking ranges remapped range by
remapped range...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
