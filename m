Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65BB2C433FE
	for <linux-xfs@archiver.kernel.org>; Wed, 25 May 2022 08:22:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229753AbiEYIWY (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 25 May 2022 04:22:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237818AbiEYIWN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 25 May 2022 04:22:13 -0400
Received: from mail105.syd.optusnet.com.au (mail105.syd.optusnet.com.au [211.29.132.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C3C3391577
        for <linux-xfs@vger.kernel.org>; Wed, 25 May 2022 01:21:45 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-2-147.pa.nsw.optusnet.com.au [49.181.2.147])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 816D810E6C89;
        Wed, 25 May 2022 18:21:42 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1ntmGy-00G9nU-Vk; Wed, 25 May 2022 18:21:41 +1000
Date:   Wed, 25 May 2022 18:21:40 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Chandan Babu R <chandanrlinux@gmail.com>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        "Darrick J . Wong" <darrick.wong@oracle.com>,
        "Darrick J. Wong" <djwong@kernel.org>,
        Christoph Hellwig <hch@lst.de>,
        Allison Henderson <allison.henderson@oracle.com>,
        "Luis R. Rodriguez" <mcgrof@kernel.org>,
        Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH V14 00/16] Bail out if transaction can cause extent count
 to overflow
Message-ID: <20220525082140.GG1098723@dread.disaster.area>
References: <20210110160720.3922965-1-chandanrlinux@gmail.com>
 <CAOQ4uxi8eNVCjqeSeVFRgrYC00gjdbuPyV4B2WPN0DmqjrfyFg@mail.gmail.com>
 <20220523224352.GT1098723@dread.disaster.area>
 <CAOQ4uxgJFVOs-p8kX+4n=TSCK-KbwjgDPaM4t81-x8gHO77FnQ@mail.gmail.com>
 <CAOQ4uxhhvsH8zLHxVc=HNViO12cssWFK4y+Pq5Jsz=2ymGaypg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxhhvsH8zLHxVc=HNViO12cssWFK4y+Pq5Jsz=2ymGaypg@mail.gmail.com>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=e9dl9Yl/ c=1 sm=1 tr=0 ts=628de717
        a=ivVLWpVy4j68lT4lJFbQgw==:117 a=ivVLWpVy4j68lT4lJFbQgw==:17
        a=kj9zAlcOel0A:10 a=oZkIemNP1mAA:10 a=pGLkceISAAAA:8 a=Kcop4rikAAAA:8
        a=7-415B0cAAAA:8 a=0o2Jp6kQItSxoVs12CEA:9 a=CjuIK1q_8ugA:10
        a=oOGgkXYeSvsA:10 a=R_rtKUxZEV9kUOUgeWU-:22 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, May 24, 2022 at 07:05:07PM +0300, Amir Goldstein wrote:
> On Tue, May 24, 2022 at 8:36 AM Amir Goldstein <amir73il@gmail.com> wrote:
> 
> Allow me to rephrase that using a less hypothetical use case.
> 
> Our team is working on an out-of-band dedupe tool, much like
> https://markfasheh.github.io/duperemove/duperemove.html
> but for larger scale filesystems and testing focus is on xfs.

dedupe is nothing new. It's being done in production systems and has
been for a while now. e.g. Veeam has a production server back end
for their reflink/dedupe based backup software that is hosted on
XFS.

The only scalability issues we've seen with those systems managing
tens of TB of heavily cross-linked files so far have been limited to
how long unlink of those large files takes. Dedupe/reflink speeds up
ingest for backup farms, but it slows down removal/garbage
collection of backup that are no longer needed. The big
reflink/dedupe backup farms I've seen problems with are generally
dealing with extent counts per file in the tens of millions,
which is still very managable.

Maybe we'll see more problems as data sets grow, but it's also
likely that the crosslinked data sets the applications build will
scale out (more base files) instead of up (larger base files). This
will mean they remain at the "tens of millions of extents per file"
level and won't stress the filesystem any more than they already do.

> In certain settings, such as containers, the tool does not control the
> running kernel and *if* we require a new kernel, the newest we can
> require in this setting is 5.10.y.

*If* you have a customer that creates a billion extents in a single
file, then you could consider backporting this. But until managing
billions of extents per file is an actual issue for production
filesystems, it's unnecessary to backport these changes.

> How would the tool know that it can safely create millions of dups
> that may get fragmented?

Millions or shared extents in a single file aren't a problem at all.
Millions of references to a single shared block aren't a problem at
all, either.

But there are limits to how much you can share a single block, and
those limits are *highly variable* because they are dependent on
free space being available to record references.  e.g. XFS can
share a single block a maximum of 2^32 -1 times. If a user turns on
rmapbt, that max share limit drops way down to however many
individual rmap records can be stored in the rmap btree before the
AG runs out of space. If the AGs are small and/or full of other data,
that could limit sharing of a single block to a few hundreds of
references.

IOWs, applications creating shared extents must expect the operation
to fail at any time, without warning. And dedupe applications need
to be able to index multiple replicas of the same block so that they
aren't limited to deduping that data to a single block that has
arbitrary limits on how many times it can be shared.

> Does anyone *object* to including this series in the stable kernel
> after it passes the tests?

If you end up having a customer that hits a billion extents in a
single file, then you can backport these patches to the 5.10.y
series. But without any obvious production need for these patches,
they don't fit the criteria for stable backports...

Don't change what ain't broke.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
