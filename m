Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B5B9C433DB
	for <linux-xfs@archiver.kernel.org>; Mon, 22 Mar 2021 23:38:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C4B5E619A5
	for <linux-xfs@archiver.kernel.org>; Mon, 22 Mar 2021 23:38:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230334AbhCVXhe (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 22 Mar 2021 19:37:34 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:56321 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229871AbhCVXhX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 22 Mar 2021 19:37:23 -0400
Received: from dread.disaster.area (pa49-181-239-12.pa.nsw.optusnet.com.au [49.181.239.12])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 8E524828B86;
        Tue, 23 Mar 2021 10:37:21 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1lOU6r-005coM-1P; Tue, 23 Mar 2021 10:37:21 +1100
Date:   Tue, 23 Mar 2021 10:37:21 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 06/11] xfs: deferred inode inactivation
Message-ID: <20210322233721.GA63242@dread.disaster.area>
References: <161543194009.1947934.9910987247994410125.stgit@magnolia>
 <161543197372.1947934.1230576164438094965.stgit@magnolia>
 <20210316072710.GA375263@infradead.org>
 <20210316154729.GI22100@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210316154729.GI22100@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=YKPhNiOx c=1 sm=1 tr=0 cx=a_idp_d
        a=gO82wUwQTSpaJfP49aMSow==:117 a=gO82wUwQTSpaJfP49aMSow==:17
        a=kj9zAlcOel0A:10 a=dESyimp9J3IA:10 a=VwQbUJbxAAAA:8 a=7-415B0cAAAA:8
        a=X2ocrCnXp-qTJZT782AA:9 a=CjuIK1q_8ugA:10 a=AjGcO6oz07-iQ99wixmX:22
        a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Mar 16, 2021 at 08:47:29AM -0700, Darrick J. Wong wrote:
> On Tue, Mar 16, 2021 at 07:27:10AM +0000, Christoph Hellwig wrote:
> > Still digesting this.  What trips me off a bit is the huge amount of
> > duplication vs the inode reclaim mechanism.  Did you look into sharing
> > more code there and if yes what speaks against that?
> 
> TBH I didn't look /too/ hard because once upon a time[1] Dave was aiming
> to replace the inode reclaim tagging and iteration with an lru list walk
> so I decided not to entangle the two.
> 
> [1] https://lore.kernel.org/linux-xfs/20191009032124.10541-23-david@fromorbit.com/

I prototyped that and discarded it - it made inode reclaim much,
much slower because it introduced delays (lock contention) adding
new inodes to the reclaim list while a reclaim isolation walk was in
progress.

The radix tree based mechanism we have right now is very efficient
as only the inodes being marked for reclaim take the radix tree
lock and hence there is minimal contention for it...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
