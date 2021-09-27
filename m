Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CDA09C433EF
	for <linux-xfs@archiver.kernel.org>; Mon, 27 Sep 2021 20:55:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B1AE561058
	for <linux-xfs@archiver.kernel.org>; Mon, 27 Sep 2021 20:55:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237026AbhI0U50 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 27 Sep 2021 16:57:26 -0400
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:54145 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236800AbhI0U5Z (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 27 Sep 2021 16:57:25 -0400
Received: from dread.disaster.area (pa49-195-238-16.pa.nsw.optusnet.com.au [49.195.238.16])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 26F001052F47;
        Tue, 28 Sep 2021 06:55:43 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1mUxf4-00HRnk-8p; Tue, 28 Sep 2021 06:55:42 +1000
Date:   Tue, 28 Sep 2021 06:55:42 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Chandan Babu R <chandan.babu@oracle.com>
Cc:     Eric Sandeen <sandeen@sandeen.net>, linux-xfs@vger.kernel.org,
        Dave Chinner <dchinner@redhat.com>, djwong@kernel.org
Subject: Re: [PATCH V2 4/5] libxfs: add kernel-compatible completion API
Message-ID: <20210927205542.GG1756565@dread.disaster.area>
References: <20210924140912.201481-1-chandan.babu@oracle.com>
 <20210924140912.201481-5-chandan.babu@oracle.com>
 <a268ae0e-01c4-c0cc-5144-adb9128d5d3a@sandeen.net>
 <8735pt2bkj.fsf@debian-BULLSEYE-live-builder-AMD64>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8735pt2bkj.fsf@debian-BULLSEYE-live-builder-AMD64>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=YKPhNiOx c=1 sm=1 tr=0
        a=DzKKRZjfViQTE5W6EVc0VA==:117 a=DzKKRZjfViQTE5W6EVc0VA==:17
        a=kj9zAlcOel0A:10 a=7QKq2e-ADPsA:10 a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8
        a=rtmF-Si7FxWao7wO6YUA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, Sep 25, 2021 at 03:59:00PM +0530, Chandan Babu R wrote:
> On 25 Sep 2021 at 04:32, Eric Sandeen wrote:
> > On 9/24/21 9:09 AM, Chandan Babu R wrote:
> >> From: Dave Chinner <dchinner@redhat.com>
> >> This is needed for the kernel buffer cache conversion to be able
> >> to wait on IO synchrnously. It is implemented with pthread mutexes
> >> and conditional variables.
> >> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> >
> > I am inclined to not merge patches 4 or 5 until there's something that
> > uses it. It can be merged and tested together with consumers, rather
> > than adding unused code at this point.  Thoughts?
> >
> 
> I think I will let Dave answer this question since I believe he most likely
> has a roadmap on when the consumers will land.

Don't care, as long as everyone agrees with the direction. FWIW, I'm
much more likely to use this completion interface in new userspace
code than I am to use pthreads directly...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
