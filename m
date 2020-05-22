Return-Path: <SRS0=AE4z=7E=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC870C433E0
	for <linux-xfs@archiver.kernel.org>; Fri, 22 May 2020 00:30:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9348D2072C
	for <linux-xfs@archiver.kernel.org>; Fri, 22 May 2020 00:30:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726785AbgEVAau (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 21 May 2020 20:30:50 -0400
Received: from mail107.syd.optusnet.com.au ([211.29.132.53]:40915 "EHLO
        mail107.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726762AbgEVAat (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 21 May 2020 20:30:49 -0400
Received: from dread.disaster.area (pa49-195-157-175.pa.nsw.optusnet.com.au [49.195.157.175])
        by mail107.syd.optusnet.com.au (Postfix) with ESMTPS id D97EED59A4B;
        Fri, 22 May 2020 10:30:28 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1jbvZz-0001P7-UM; Fri, 22 May 2020 10:30:27 +1000
Date:   Fri, 22 May 2020 10:30:27 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Dave Airlie <airlied@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        xfs <linux-xfs@vger.kernel.org>
Subject: Re: lockdep trace with xfs + mm in it from 5.7.0-rc5
Message-ID: <20200522003027.GC2040@dread.disaster.area>
References: <CAPM=9tyy5vubggbcj32bGpA_h6yDaBNM3QeJPySTzci-etfBZw@mail.gmail.com>
 <20200521231312.GJ17635@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200521231312.GJ17635@magnolia>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=QIgWuTDL c=1 sm=1 tr=0
        a=ONQRW0k9raierNYdzxQi9Q==:117 a=ONQRW0k9raierNYdzxQi9Q==:17
        a=kj9zAlcOel0A:10 a=sTwFKg_x9MkA:10 a=7-415B0cAAAA:8
        a=nMFCFe5KEfRbL1dfepcA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, May 21, 2020 at 04:13:12PM -0700, Darrick J. Wong wrote:
> [cc linux-xfs]
> 
> On Fri, May 22, 2020 at 08:21:50AM +1000, Dave Airlie wrote:
> > Hi,
> > 
> > Just updated a rawhide VM to the Fedora 5.7.0-rc5 kernel, did some
> > package building,
> > 
> > got the below trace, not sure if it's known and fixed or unknown.
> 
> It's a known false-positive.  An inode can't simultaneously be getting
> reclaimed due to zero refcount /and/ be the target of a getxattr call.
> Unfortunately, lockdep can't tell the difference, and it seems a little
> strange to set NOFS on the allocation (which increases the chances of a
> runtime error) just to quiet that down.

__GFP_NOLOCKDEP is the intended flag to telling memory allocation
that lockdep is stupid.

However, it seems that the patches that were in progress some months
ago to convert XFS to kmalloc interfaces and using GFP flags
directly stalled - being able to mark locations like this with
__GFP_NOLOCKDEP was one of the main reasons for getting rid of all
the internal XFS memory allocation wrappers...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
