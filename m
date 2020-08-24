Return-Path: <SRS0=BK4F=CC=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ACDECC433E1
	for <linux-xfs@archiver.kernel.org>; Mon, 24 Aug 2020 22:55:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9224B20706
	for <linux-xfs@archiver.kernel.org>; Mon, 24 Aug 2020 22:55:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726532AbgHXWzj (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 24 Aug 2020 18:55:39 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:35582 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726531AbgHXWzi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 24 Aug 2020 18:55:38 -0400
Received: from dread.disaster.area (pa49-181-146-199.pa.nsw.optusnet.com.au [49.181.146.199])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id A8F7E823208;
        Tue, 25 Aug 2020 08:55:34 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1kALNF-0005Yp-3g; Tue, 25 Aug 2020 08:55:33 +1000
Date:   Tue, 25 Aug 2020 08:55:33 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Anthony Iliopoulos <ailiop@suse.com>
Cc:     Eric Sandeen <sandeen@sandeen.net>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 0/6] xfsprogs: blockdev dax detection and warnings
Message-ID: <20200824225533.GA12131@dread.disaster.area>
References: <20200824203724.13477-1-ailiop@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200824203724.13477-1-ailiop@suse.com>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=QIgWuTDL c=1 sm=1 tr=0 cx=a_idp_d
        a=GorAHYkI+xOargNMzM6qxQ==:117 a=GorAHYkI+xOargNMzM6qxQ==:17
        a=kj9zAlcOel0A:10 a=y4yBn9ojGxQA:10 a=7-415B0cAAAA:8
        a=ugs-L-zGaiGLnAFgLOAA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Aug 24, 2020 at 10:37:18PM +0200, Anthony Iliopoulos wrote:
> Hi all,
> 
> This short series adds blockdev dax capability detection via libblkid,
> and subsequently uses this bit to warn on a couple of incompatible
> configurations during mkfs.
> 
> The first patch adds the detection capability to libtopology, and the
> following two patches add mkfs warnings that are issued when the fs
> block size is not matching the page size, and when reflink is being
> enabled in conjunction with dax.

This makes the assumption that anyone running mkfs on a dax capable
device is going to use DAX, and prevents mkfs from running if the
config is not DAX compatible.

The issue here is that making a filesystem that is not DAX
compatible on a DAX capable device is not a fatal error. The
filesystem will work just fine using buffered and direct IO, and
there are definitely workloads where we want to use buffered IO on
pmem and not DAX. Why? Because existing pmem is terribly slow for
write intensive applications compared to page cache based mmap().
And even buffered writes are faster than DAX direct writes because
the slow writeback is done in the background via async writeback.

Also, what happens if you have a 64kB page size? mkfs defaults to
4kB block size, so with these changes mkfs will refuse to run on a
dax capable device unless the user specifically directs it to do
something different. That's not a good behaviour for the default
config to have....

Hence I don't think that preventing mkfs from running unless the config
is exactly waht DAX requires or the "force" option is set is the
right policy here.

I agree that mkfs needs to be aware of DAX capability of the block
device, but that capability existing should not cause mkfs to fail.
If we want users to be able to direct mkfs to to create a DAX
capable filesystem then adding a -d dax option would be a better
idea. This would direct mkfs to align/size all the data options to
use a DAX compatible topology if blkid supports reporting the DAX
topology. It would also do things like turn off reflink (until that
is supported w/ DAX), etc.

i.e. if the user knows they are going to use DAX (and they will)
then they can tell mkfs to make a DAX compatible filesystem.

> The next patch adds a new cli option that can be used to override
> warnings, and converts all warnings that can be forced to this option
> instead the overloaded -f option. This avoids cases where forcing a
> warning may also be implicitly forcing overwriting an existing
> partition.

I don't want both an "ignore warnings" and a "force" CLI option.
They both do the same thing - allow the user to override things that
are potentially destructive or result in an unusable config - so why
should we add the complexity of having a different "force" options
for every different possible thing that can be overridden?

Then we'll grow a "--force-all" option to override everything.
i.e.  we end up with this insanity:

$ dpkg --help |grep force
  --force-help                     Show help on forcing.
  --[no-]triggers            Skip or force consequential trigger processing.
  --force-<thing>[,...]      Override problems (see --force-help).
  --no-force-<thing>[,...]   Stop when problems encountered.

and "--force-help" gives you a list of about 30 different things you
can force the behaviour of, including "--force-all". This is simply
not a good UI model...

> The last two patches are small cleanups that remove redundant code.

They should be first.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
