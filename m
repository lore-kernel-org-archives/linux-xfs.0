Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F1CFC433EF
	for <linux-xfs@archiver.kernel.org>; Wed,  6 Oct 2021 22:27:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 73AC5611C1
	for <linux-xfs@archiver.kernel.org>; Wed,  6 Oct 2021 22:27:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229926AbhJFW3p (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 6 Oct 2021 18:29:45 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:42050 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229809AbhJFW3o (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 6 Oct 2021 18:29:44 -0400
Received: from dread.disaster.area (pa49-195-238-16.pa.nsw.optusnet.com.au [49.195.238.16])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 51884885FF5;
        Thu,  7 Oct 2021 09:27:50 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1mYFO9-003HCi-Lf; Thu, 07 Oct 2021 09:27:49 +1100
Date:   Thu, 7 Oct 2021 09:27:49 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Hao Sun <sunhao.th@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-xfs@vger.kernel.org
Subject: Re: BUG: unable to handle kernel NULL pointer dereference in
 xlog_cil_commit
Message-ID: <20211006222749.GE54211@dread.disaster.area>
References: <CACkBjsbaCmZK2wUExMqu_KKBr2jnEi-T6iEr=vzw4YS5g5DOOQ@mail.gmail.com>
 <20211006154327.GH24307@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211006154327.GH24307@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=e9dl9Yl/ c=1 sm=1 tr=0 ts=615e22e6
        a=DzKKRZjfViQTE5W6EVc0VA==:117 a=DzKKRZjfViQTE5W6EVc0VA==:17
        a=kj9zAlcOel0A:10 a=8gfv0ekSlNoA:10 a=KJwQ5lK5AAAA:20 a=vv83xpn8AAAA:20
        a=pGLkceISAAAA:8 a=VwQbUJbxAAAA:8 a=7-415B0cAAAA:8 a=aTJriFvqDCuL6hGtFqkA:9
        a=CjuIK1q_8ugA:10 a=AjGcO6oz07-iQ99wixmX:22 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Oct 06, 2021 at 08:43:27AM -0700, Darrick J. Wong wrote:
> On Wed, Oct 06, 2021 at 04:14:43PM +0800, Hao Sun wrote:
> > Hello,
> > 
> > When using Healer to fuzz the latest Linux kernel, the following crash
> > was triggered.
> > 
> > HEAD commit: 0513e464f900 Merge tag 'perf-tools-fixes-for-v5.15-2021-09-27'
> > git tree: upstream
> > console output:
> > https://drive.google.com/file/d/1vm5fDM220kkghoiGa3Aw_Prl4O_pqAXF/view?usp=sharing
> > kernel config: https://drive.google.com/file/d/1Jqhc4DpCVE8X7d-XBdQnrMoQzifTG5ho/view?usp=sharing
> > 
> > Sorry, I don't have a reproducer for this crash, hope the symbolized
> > report can help.
> > If you fix this issue, please add the following tag to the commit:
> > Reported-by: Hao Sun <sunhao.th@gmail.com>
> 
> So figure out how to fix the problem and send a patch.  You don't get to
> hand out fixit tasks like you're some kind of manager for people you
> don't employ.

I fully agree with this Darrick but, OTOH, the cynical, jaded
engineer in me says "I don't think people that run bots and
copy/paste their output to mailing lists have the capability to fix
the problems the bots find."

Quite frankly, it's even more of a waste of our time trying to
review crap patches and make suggestions to fix it and then going
around the review loop 15 times getting nowhere like we have in teh
past.

So, kvmalloc() sucks dogs balls, as I pointed out in this recent
patch in the intent whiteouts series:

https://lore.kernel.org/linux-xfs/20210902095927.911100-8-david@fromorbit.com/

Because of the crap implementation of kvmalloc(), we can't just pass
__GFP_NOFAIL because that will cause it to try to run
kmalloc_node(__GFP_NORETRY | __GFP_NOFAIL) and that will cause heads
to go all explodey. Not to mention that kvmalloc won't even allow
GFP_NOFS to be passed and still actually do the vmalloc() fallback.

So, basically, we've got to go back to doing an open coded kvmalloc
loop here that cannot fail. Because kvmalloc can fail and we can't
tell it that it must succeed or die trying.

That's what the above patch does - gets rid of the garbage kvmalloc
direct reclaim -> memory compaction behaviour, and wraps it in a
loop so that the fail-fast memory allocation semantics it uses does
not end up in a shadow buffer allocation failure.

So, yeah, I've already fixed this in my trees....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
