Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 738B1C433EF
	for <linux-xfs@archiver.kernel.org>; Thu, 21 Apr 2022 22:58:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1392255AbiDUXBf (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 21 Apr 2022 19:01:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1392235AbiDUXBf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 21 Apr 2022 19:01:35 -0400
Received: from mail104.syd.optusnet.com.au (mail104.syd.optusnet.com.au [211.29.132.246])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C51F34739D
        for <linux-xfs@vger.kernel.org>; Thu, 21 Apr 2022 15:58:41 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-115-138.pa.nsw.optusnet.com.au [49.181.115.138])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 8AB735346E7;
        Fri, 22 Apr 2022 08:58:39 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1nhfl0-002xI5-Gh; Fri, 22 Apr 2022 08:58:38 +1000
Date:   Fri, 22 Apr 2022 08:58:38 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Chandan Babu R <chandan.babu@oracle.com>
Cc:     linux-xfs@vger.kernel.org, djwong@kernel.org
Subject: Re: [GIT PULL] xfs: Large extent counters
Message-ID: <20220421225838.GU1544202@dread.disaster.area>
References: <87r15vouta.fsf@debian-BULLSEYE-live-builder-AMD64>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87r15vouta.fsf@debian-BULLSEYE-live-builder-AMD64>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=deDjYVbe c=1 sm=1 tr=0 ts=6261e1a1
        a=/kVtbFzwtM2bJgxRVb+eeA==:117 a=/kVtbFzwtM2bJgxRVb+eeA==:17
        a=kj9zAlcOel0A:10 a=z0gMJWrwH1QA:10 a=NEAV23lmAAAA:8 a=VwQbUJbxAAAA:8
        a=7-415B0cAAAA:8 a=YEyoaHGsQedtcYhF1HQA:9 a=CjuIK1q_8ugA:10
        a=AjGcO6oz07-iQ99wixmX:22 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi Chandan,

On Mon, Apr 18, 2022 at 10:24:25AM +0530, Chandan Babu R wrote:
> Hi Dave,
> 
> The following changes since commit ce522ba9ef7e2d9fb22a39eb3371c0c64e2a433e:
> 
>   Linux 5.18-rc2 (2022-04-10 14:21:36 -1000)
> 
> are available in the Git repository at:
> 
>   https://github.com/chandanr/linux.git tags/large-extent-counters-v9

I've pulled this down and it seems fine, but there's problem I can't
solve directly: the tag isn't signed so I can't tell if the tree
I've pulled is unmolested.

If you were asking me to pull from git.kernel.org, that wouldn't be
a problem. But I don't trust github to be safe - forget about
hackers, github's owners have demonstrated they will modify
repositories directly if it is convenient for them to do so. i.e.
they have overwritten hosted trees without the author's and/or
copyright owner's consent and locked out the owner(s) of the code
from ever being able to update their tree again.

As such, I don't consider github to be a trustworthy source, and so
if you are going to use it for pull requests I need the tag to be
signed with you gpg key so that I can verify the commits I'm pulling
match the ones you pushed to the hosting site.

Can you post on #xfs or DM on oftc the last five commits (--one-line
format is fine) from your local branch that you pushed to github so
that I have an OOB confirmation that the commit IDs I've pulled
match your original commits?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
