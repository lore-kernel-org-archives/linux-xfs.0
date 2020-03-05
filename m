Return-Path: <SRS0=4NJG=4W=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3DE5BC3F2D2
	for <linux-xfs@archiver.kernel.org>; Thu,  5 Mar 2020 21:27:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1AEF620728
	for <linux-xfs@archiver.kernel.org>; Thu,  5 Mar 2020 21:27:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726111AbgCEV1K (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 5 Mar 2020 16:27:10 -0500
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:50287 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726067AbgCEV1K (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 5 Mar 2020 16:27:10 -0500
Received: from dread.disaster.area (pa49-195-202-68.pa.nsw.optusnet.com.au [49.195.202.68])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 714C33A2B93;
        Fri,  6 Mar 2020 08:27:06 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1j9y1J-0004Sz-F2; Fri, 06 Mar 2020 08:27:05 +1100
Date:   Fri, 6 Mar 2020 08:27:05 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "zhengbin (A)" <zhengbin13@huawei.com>
Cc:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        linux-xfs@vger.kernel.org
Subject: Re: Questions about CVE-2016-8660
Message-ID: <20200305212705.GJ10776@dread.disaster.area>
References: <50013503-3b51-c1ac-dcc3-31266609b973@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50013503-3b51-c1ac-dcc3-31266609b973@huawei.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=W5xGqiek c=1 sm=1 tr=0
        a=mqTaRPt+QsUAtUurwE173Q==:117 a=mqTaRPt+QsUAtUurwE173Q==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=SS2py6AdgQ4A:10
        a=3L6Nh-GTAAAA:8 a=VwQbUJbxAAAA:8 a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8
        a=uqTaCnnDFwkgAJLm560A:9 a=CjuIK1q_8ugA:10 a=izEBCtx8DkBWphcOf488:22
        a=AjGcO6oz07-iQ99wixmX:22 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Mar 05, 2020 at 04:28:55PM +0800, zhengbin (A) wrote:
> Recently I am studying CVE-2016-8660, in https://seclists.org/oss-sec/2016/q4/118,

Why?

> it says that this bug is introduced by commit fc0561cefc04 ("xfs: optimise away log forces on timestamp updates for fdatasync").
> And in https://patchwork.kernel.org/patch/9363339/#19693745, david correction has nothing to do with this commit,

And if you read a little further down, I say:

| Why? This isn't a security issue - CVEs cost time and effort for
| everyone to track and follow and raising them for issues like this
| does not help anyone fix the actual problem.  It doesn't help us
| track it, analyse it, communicate with the bug reporter, test it or
| get the fix committed.  It's meaningless to the developers fixing
| the code, it's meaningless to users, and it's meaningless to most
| distros that are supporting XFS because the distro maintainers don't
| watch the CVE lists for XFS bugs they need to backport and fix.
| 
| All this does is artificially inflate the supposed importance of the
| bug. CVEs are for security or severe issues. This is neither serious
| or a security issue - please have the common courtesy to ask the
| people with the knowledge to make such a determination (i.e. the
| maintainers) before you waste the time of a /large number/ of people
| by raising a useless CVE...

And look, 4 years later this unnecessary CVE is still wasting
multiple peoples' valuable time.

> and is a page lock order bug in the XFS seek hole/data implementation(demsg is in http://people.redhat.com/qcai/tmp/dmesg-sync,
> Unfortunately, it is not accessible now, I do not understand why this is a page lock order bug).

the old XFS seek hole/data code did ilock -> page_lock, while
everything else in XFS (like readahead, writeback, etc) does
page_lock -> ilock.

> Is this CVE solved? Can I see the demsg in other way? thanks.

Yes. back in 2017 we completely rewrote the seek hole/data
implementation around the iomap infrastructure with
iomap_seek_hole and iomap_seek_data. These do not have a lock
inversion problem. commit 9b2970aacfd9 ("xfs: Switch
to iomap for SEEK_HOLE / SEEK_DATA") is the one that switched XFS,
but there are several more that introduce the infrastructure it
uses.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
