Return-Path: <SRS0=9CIi=XZ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8A55C32792
	for <linux-xfs@archiver.kernel.org>; Mon, 30 Sep 2019 12:24:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9512720815
	for <linux-xfs@archiver.kernel.org>; Mon, 30 Sep 2019 12:24:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729852AbfI3MYs (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 30 Sep 2019 08:24:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36088 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726072AbfI3MYr (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 30 Sep 2019 08:24:47 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 8F9133086246;
        Mon, 30 Sep 2019 12:24:47 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 234345D9C3;
        Mon, 30 Sep 2019 12:24:47 +0000 (UTC)
Date:   Mon, 30 Sep 2019 08:24:45 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/2] xfs: Lower CIL flush limit for large logs
Message-ID: <20190930122445.GB57295@bfoster>
References: <20190909015159.19662-1-david@fromorbit.com>
 <20190909015159.19662-2-david@fromorbit.com>
 <20190916163325.GZ2229799@magnolia>
 <20190924222901.GI16973@dread.disaster.area>
 <20190925120859.GC21991@bfoster>
 <20190927224758.GN16973@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190927224758.GN16973@dread.disaster.area>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.49]); Mon, 30 Sep 2019 12:24:47 +0000 (UTC)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, Sep 28, 2019 at 08:47:58AM +1000, Dave Chinner wrote:
> On Wed, Sep 25, 2019 at 08:08:59AM -0400, Brian Foster wrote:
> > On Wed, Sep 25, 2019 at 08:29:01AM +1000, Dave Chinner wrote:
> > > That's in commit 80168676ebfe ("xfs: force background CIL push under
> > > sustained load") which went into 2.6.38 or so. The cause of the
> > > problem in that case was concurrent transaction commit load causing
> > > lock contention and preventing a background push from getting the
> > > context lock to do the actual push.
> > > 
> > 
> > More related to the next patch, but what prevents a similar but
> > generally unbound concurrent workload from exceeding the new hard limit
> > once transactions start to block post commit?
> 
> The new code, like the original code, is not actually a "hard" limit.
> It's essentially just throttles ongoing work until the CIL push
> starts. In this case, it forces the current process to give up the
> CPU immediately once over the CIL high limit, which allows the
> workqueue to run the push work straight away.
> 
> I thought about making it a "hard limit" by blocking before the CIL
> insert, but that's no guarantee that by the time we get woken and
> add the new commit to the CIL that this new context has not already
> gone over the hard limit. i.e. we block the unbound concurrency
> before commit, then let it all go in a thundering herd on the new
> context and immeidately punch that way over the hard threshold
> again. To avoid this, we'd probably need a CIL ticket and grant
> mechanism to make CIL insertion FIFO and wakeups limited by
> remaining space in the CIL. I'm not sure we actually need such a
> complex solution, especially considering the potential serialisation
> problems it introduces in what is a highly concurrent fast path...
> 

Ok. The latter is more of what I'd expect to see if the objective is
truly to hard cap CIL size, FWIW. This seems more reasonable if the
objective is to yield committers under overloaded CIL conditions, with
the caveat that CIL size is still not hard capped, so long as the
documentation and whatnot is updated to more accurately reflect the
implementation (and at a glance, it looks like that has happened in the
next version..).

Brian

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
