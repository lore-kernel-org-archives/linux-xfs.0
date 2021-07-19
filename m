Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22224C07E95
	for <linux-xfs@archiver.kernel.org>; Mon, 19 Jul 2021 23:38:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 06B436113E
	for <linux-xfs@archiver.kernel.org>; Mon, 19 Jul 2021 23:38:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346243AbhGSW5S (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 19 Jul 2021 18:57:18 -0400
Received: from mail107.syd.optusnet.com.au ([211.29.132.53]:59509 "EHLO
        mail107.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1388277AbhGSUsq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 19 Jul 2021 16:48:46 -0400
Received: from dread.disaster.area (pa49-181-34-10.pa.nsw.optusnet.com.au [49.181.34.10])
        by mail107.syd.optusnet.com.au (Postfix) with ESMTPS id E61634F6C;
        Tue, 20 Jul 2021 07:29:16 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1m5ap9-008U3y-NI; Tue, 20 Jul 2021 07:29:15 +1000
Date:   Tue, 20 Jul 2021 07:29:15 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     "Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: xfs/319 vs 1k block size file systems
Message-ID: <20210719212915.GJ664593@dread.disaster.area>
References: <YPVSBie+Bk5FAngH@infradead.org>
 <20210719180015.GH22402@magnolia>
 <YPXCqMUoSLehQqde@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YPXCqMUoSLehQqde@infradead.org>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=Tu+Yewfh c=1 sm=1 tr=0
        a=hdaoRb6WoHYrV466vVKEyw==:117 a=hdaoRb6WoHYrV466vVKEyw==:17
        a=kj9zAlcOel0A:10 a=e_q4qTt1xDgA:10 a=7-415B0cAAAA:8
        a=INLTsetQehM4DXZxDbkA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jul 19, 2021 at 07:21:28PM +0100, Christoph Hellwig wrote:
> On Mon, Jul 19, 2021 at 11:00:15AM -0700, Darrick J. Wong wrote:
> > On Mon, Jul 19, 2021 at 12:20:54PM +0200, Christoph Hellwig wrote:
> > > Hi all,
> > > 
> > > xfs/319 keeps crashing for me when running it for a 1k block size
> > > file systems on x86 with debugging enabled.  The problem is that
> > > xfs_bmapi_remap is called on a range that is not a hole.
> > 
> > Hmm.  Dave sent me a warning late last night about some sort of log
> > recovery problem in -rc2 due to FUA changes or something.  Did this
> > happen in -rc1?
> 
> I've reproduced it all the way back to 5.12 so far.

Ok, so not the regression I introduced in 5.14-rc1 with the journal
flush/FUA changes (caused by flush vs tail_lsn updates racing). THat
smells like the problem both Brian and I have seen that has occurred
occasionally for some time (I see it maybe once a month here) but we
haven't been able to reproduce reliably enough debug it.

Sounds like it's reliable on your setup? What's your test machine
config?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
