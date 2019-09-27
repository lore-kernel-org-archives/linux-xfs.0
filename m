Return-Path: <SRS0=ETTY=XW=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4183C4360C
	for <linux-xfs@archiver.kernel.org>; Fri, 27 Sep 2019 22:48:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8FEE1217D9
	for <linux-xfs@archiver.kernel.org>; Fri, 27 Sep 2019 22:48:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726116AbfI0WsB (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 27 Sep 2019 18:48:01 -0400
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:57644 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725306AbfI0WsB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 27 Sep 2019 18:48:01 -0400
Received: from dread.disaster.area (pa49-181-226-196.pa.nsw.optusnet.com.au [49.181.226.196])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id D46223634FB;
        Sat, 28 Sep 2019 08:47:58 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.2)
        (envelope-from <david@fromorbit.com>)
        id 1iDz1q-0007kY-69; Sat, 28 Sep 2019 08:47:58 +1000
Date:   Sat, 28 Sep 2019 08:47:58 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/2] xfs: Lower CIL flush limit for large logs
Message-ID: <20190927224758.GN16973@dread.disaster.area>
References: <20190909015159.19662-1-david@fromorbit.com>
 <20190909015159.19662-2-david@fromorbit.com>
 <20190916163325.GZ2229799@magnolia>
 <20190924222901.GI16973@dread.disaster.area>
 <20190925120859.GC21991@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190925120859.GC21991@bfoster>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.2 cv=FNpr/6gs c=1 sm=1 tr=0
        a=dRuLqZ1tmBNts2YiI0zFQg==:117 a=dRuLqZ1tmBNts2YiI0zFQg==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=J70Eh1EUuV4A:10
        a=7-415B0cAAAA:8 a=Lf9q5KbF3B9v1kTeIqMA:9 a=CjuIK1q_8ugA:10
        a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Sep 25, 2019 at 08:08:59AM -0400, Brian Foster wrote:
> On Wed, Sep 25, 2019 at 08:29:01AM +1000, Dave Chinner wrote:
> > That's in commit 80168676ebfe ("xfs: force background CIL push under
> > sustained load") which went into 2.6.38 or so. The cause of the
> > problem in that case was concurrent transaction commit load causing
> > lock contention and preventing a background push from getting the
> > context lock to do the actual push.
> > 
> 
> More related to the next patch, but what prevents a similar but
> generally unbound concurrent workload from exceeding the new hard limit
> once transactions start to block post commit?

The new code, like the original code, is not actually a "hard" limit.
It's essentially just throttles ongoing work until the CIL push
starts. In this case, it forces the current process to give up the
CPU immediately once over the CIL high limit, which allows the
workqueue to run the push work straight away.

I thought about making it a "hard limit" by blocking before the CIL
insert, but that's no guarantee that by the time we get woken and
add the new commit to the CIL that this new context has not already
gone over the hard limit. i.e. we block the unbound concurrency
before commit, then let it all go in a thundering herd on the new
context and immeidately punch that way over the hard threshold
again. To avoid this, we'd probably need a CIL ticket and grant
mechanism to make CIL insertion FIFO and wakeups limited by
remaining space in the CIL. I'm not sure we actually need such a
complex solution, especially considering the potential serialisation
problems it introduces in what is a highly concurrent fast path...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
