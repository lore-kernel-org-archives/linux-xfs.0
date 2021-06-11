Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14222C48BE0
	for <linux-xfs@archiver.kernel.org>; Fri, 11 Jun 2021 22:33:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DF707613DF
	for <linux-xfs@archiver.kernel.org>; Fri, 11 Jun 2021 22:33:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229937AbhFKWff (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 11 Jun 2021 18:35:35 -0400
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:35696 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229572AbhFKWff (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 11 Jun 2021 18:35:35 -0400
Received: from dread.disaster.area (pa49-179-138-183.pa.nsw.optusnet.com.au [49.179.138.183])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 925161044490;
        Sat, 12 Jun 2021 08:33:34 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1lrpiW-00Bgas-5d; Sat, 12 Jun 2021 08:33:32 +1000
Date:   Sat, 12 Jun 2021 08:33:32 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [BUG] generic/475 recovery failure(s)
Message-ID: <20210611223332.GS664593@dread.disaster.area>
References: <YMIsWJ0Cb2ot/UjG@bfoster>
 <YMOzT1goreWVgo8S@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YMOzT1goreWVgo8S@bfoster>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=F8MpiZpN c=1 sm=1 tr=0
        a=MnllW2CieawZLw/OcHE/Ng==:117 a=MnllW2CieawZLw/OcHE/Ng==:17
        a=kj9zAlcOel0A:10 a=r6YtysWOX24A:10 a=7-415B0cAAAA:8
        a=qX4u6SBrIjunKUc1KhcA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Jun 11, 2021 at 03:02:39PM -0400, Brian Foster wrote:
> On Thu, Jun 10, 2021 at 11:14:32AM -0400, Brian Foster wrote:
> > Hi all,
> > 
> > I'm seeing what looks like at least one new generic/475 failure on
> > current for-next. (I've seen one related to an attr buffer that seems to
> > be older and harder to reproduce.). The test devices are a couple ~15GB
> > lvm devices formatted with mkfs defaults. I'm still trying to establish
> > reproducibility, but so far a failure seems fairly reliable within ~30
> > iterations.
> > 
> > The first [1] looks like log recovery failure processing an EFI. The
> > second variant [2] looks like it passes log recovery, but then fails the
> > mount in the COW extent cleanup stage due to a refcountbt problem. I've
> > also seen one that looks like the same free space corruption error as
> > [1], but triggered via the COW recovery codepath in [2], so these could
> > very well be related. A snippet of the dmesg output for each failed
> > mount is appended below.
> > 
> ...
> 
> A couple updates..
> 
> First (as noted on irc), the generic/475 failure is not new as I was
> able to produce it on vanilla 5.13.0-rc4. I'm not quite sure how far
> back that one goes, but Dave noted he's seen it on occasion for some
> time.
> 
> The generic/019 failure I'm seeing does appear to be new as I cannot
> reproduce on 5.13.0-rc4. This failure looks more like silent fs
> corruption. I.e., the test or log recovery doesn't explicitly fail, but
> the post-test xfs_repair check detects corruption. Example xfs_repair
> output is appended below (note that 'xfs_repair -n' actually crashes,
> while destructive repair seems to work). Since this reproduces fairly
> reliably on for-next, I bisected it (while also navigating an unmount
> hang that I don't otherwise have data on) down to facd77e4e38b ("xfs:
> CIL work is serialised, not pipelined"). From a quick glance at that I'm
> not quite sure what the problem is there, just that it doesn't occur
> prior to that particular commit.

I suspect that there's an underlying bug in the overlapping CIL
commit record sequencing. This commit will be the first time we are
actually getting overlapping checkpoints that need ordering via the
commit record writes. Hence I suspect what is being seen here is a
subtle ordering bug that has been in that code since it was first
introduced but never exercised until now..

I haven't had any success in reproducing this yet, I'll keep trying
to see if I can get it to trigger so I can look at it in more
detail...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
