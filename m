Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 329F5C433F5
	for <linux-xfs@archiver.kernel.org>; Mon, 10 Oct 2022 20:54:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229577AbiJJUyt (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 10 Oct 2022 16:54:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230246AbiJJUyq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 10 Oct 2022 16:54:46 -0400
Received: from mail104.syd.optusnet.com.au (mail104.syd.optusnet.com.au [211.29.132.246])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 824FB2735
        for <linux-xfs@vger.kernel.org>; Mon, 10 Oct 2022 13:54:43 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-106-210.pa.nsw.optusnet.com.au [49.181.106.210])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 67FFB8B0170;
        Tue, 11 Oct 2022 07:54:42 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1ohznM-000RIa-Jn; Tue, 11 Oct 2022 07:54:40 +1100
Date:   Tue, 11 Oct 2022 07:54:40 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Philip Li <philip.li@intel.com>
Cc:     Oliver Sang <oliver.sang@intel.com>,
        Guo Xuenan <guoxuenan@huawei.com>, lkp@lists.01.org,
        lkp@intel.com, Hou Tao <houtao1@huawei.com>,
        linux-xfs@vger.kernel.org
Subject: Re: [LKP] Re: [xfs]  a1df10d42b: xfstests.generic.31*.fail
Message-ID: <20221010205440.GV3600936@dread.disaster.area>
References: <202210052153.fedff8e6-oliver.sang@intel.com>
 <20221005213543.GP3600936@dread.disaster.area>
 <Y0J1oxBFwW53udvJ@xsang-OptiPlex-9020>
 <20221010000740.GU3600936@dread.disaster.area>
 <Y0NoKUei4Xfn/afb@rli9-MOBL1.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y0NoKUei4Xfn/afb@rli9-MOBL1.ccr.corp.intel.com>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=OJNEYQWB c=1 sm=1 tr=0 ts=63448693
        a=j6JUzzrSC7wlfFge/rmVbg==:117 a=j6JUzzrSC7wlfFge/rmVbg==:17
        a=kj9zAlcOel0A:10 a=Qawa6l4ZSaYA:10 a=NEAV23lmAAAA:8 a=VwQbUJbxAAAA:8
        a=i0EeH86SAAAA:8 a=7-415B0cAAAA:8 a=7dUWE-uwUhZ5AqLCZe4A:9
        a=CjuIK1q_8ugA:10 a=AjGcO6oz07-iQ99wixmX:22 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Oct 10, 2022 at 08:32:41AM +0800, Philip Li wrote:
> On Mon, Oct 10, 2022 at 11:07:40AM +1100, Dave Chinner wrote:
> > On Sun, Oct 09, 2022 at 03:17:55PM +0800, Oliver Sang wrote:
> > > Hi Dave,
> > > 
> > > On Thu, Oct 06, 2022 at 08:35:43AM +1100, Dave Chinner wrote:
> > > > On Wed, Oct 05, 2022 at 09:45:12PM +0800, kernel test robot wrote:
> > > > > 
> > > > > Greeting,
> > > > > 
> > > > > FYI, we noticed the following commit (built with gcc-11):
> > > > > 
> > > > > commit: a1df10d42ba99c946f6a574d4d31951bc0a57e33 ("xfs: fix exception caused by unexpected illegal bestcount in leaf dir")
> > > > > url: https://github.com/intel-lab-lkp/linux/commits/UPDATE-20220929-162751/Guo-Xuenan/xfs-fix-uaf-when-leaf-dir-bestcount-not-match-with-dir-data-blocks/20220831-195920
> > > > > 
[....]

> > commit a1df10d42ba99c946f6a574d4d31951bc0a57e33 *does not exist in
> > the upstream xfs-dev tree*. The URL provided pointing to the commit
> > above resolves to a "404 page not found" error, so I have not idea
> > what code was even being tested here.
> > 
> > AFAICT, the patch being tested is this one (based on the github url
> > matching the patch title:
> > 
> > https://lore.kernel.org/linux-xfs/20220831121639.3060527-1-guoxuenan@huawei.com/
> > 
> > Which I NACKed almost a whole month ago! The latest revision of the
> > patch was posted 2 days ago here:
> > 
> > https://lore.kernel.org/linux-xfs/20221008033624.1237390-1-guoxuenan@huawei.com/
> > 
> > Intel kernel robot maintainers: I've just wasted the best part of 2
> > hours trying to reproduce and track down a corruption bug that this
> > report lead me to beleive was in the upstream XFS tree.
> 
> hi Dave, we are very sorry to waste your time on this report. It's our fault to not
> make it clear that this is testing a review patch in mailing list. And we also
> miss the NACKed information in your review, and send out this meaningless report.

The biggest issue was how it was presented.

Normally I see reports from the kernel robot for specific
uncommitted patches like this as a threaded reply to the specific
patch that was identified as having a problem.  And normally this
sort of standalone test failure report comes from a failure bisected
to a commit already in an upstream tree. 

So my confusion here is largely because a bug in an uncommitted
patch was reported in the same manner as an upstream regression
would be reported - as a standalone bug report...


> > You need to make it very clear that your bug report is for a commit
> > that *hasn't been merged into an upstream tree*. The CI robot
> > noticed a bug in an *old* NACKed patch, not a bug in a new upstream
> > commit. Please make it *VERY CLEAR* where the code the CI robot is
> > testing has come from.
> 
> We will correct our process ASAP to 
> 
> 1) make it clear, what is tested from, a review patch or a patch on upstream tree

Yes, commit ID by itself is not sufficient to identify the issue,
nor is a pointer to the CI tree the robot built. For a patch pulled
from a list, it should not be reported as a "commit that failed".
It should be reported as "uncommitted patch that failed", with:

- a lore link to the patch that was identified as having an issue;
- a pointer to the base tree the patch(es) were applied to (e.g.
  linus-v5.19-rc7, linux-next-2022-25-09, etc)
- a pointer to the CI integration tree (that doesn't) the patch was
  applied to and tested.

For an upstream commit that failed, reporting "<commit id> failed"
is a good start, but it really needs to include the tree as the
robot might be testing dev trees or linux-next rather than Linus's
tree. i.e. report as "<tree, commit id> failed <test>".

> 2) do not send such report, if the patch has already been NACKed

That's not so much a problem. The real problem that needs solving is
ensuring that the recipients of the bug report are able to quickly
and obviously identify what was being tested when the issue was hit.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
