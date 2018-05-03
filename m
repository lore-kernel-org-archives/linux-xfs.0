Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:58751 "EHLO
        ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750970AbeECWbs (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 3 May 2018 18:31:48 -0400
Date: Fri, 4 May 2018 08:31:20 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Oops from linux-next 20180430
Message-ID: <20180503223119.GF23861@dastard>
References: <20180503205703.GA27821@bombadil.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180503205703.GA27821@bombadil.infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Matthew Wilcox <willy@infradead.org>
Cc: linux-xfs@vger.kernel.org

On Thu, May 03, 2018 at 01:57:03PM -0700, Matthew Wilcox wrote:
> I was running xfstests xfs/350 at the time.

It's a superblock fuzzing test. Described as:

tests/xfs/group:350 dangerous_fuzzers dangerous_scrub dangerous_repair

Are you trying to run xfstests as a regression test suite (i.e.
check -g auto) , or as a fuzzer to find on-disk format parsing
issues (check -g dangerous_fuzzers)?

> No kernel patches applied
> beyond linux-next (I was hoping to get a baseline).
> 
> 5726 XFS: Assertion failed: sbp->sb_rsumino != NULLFSINO, file: ../fs/xfs/xfs_rtalloc.c, line: 1223

And you're running a debug kernel, so assert failures are expected.

Essentially, the fuzzed superblock has a non-null realtime bitmap
inode, but a null realtime summary inode. Which on a non-debug
kernel will result in mount failing, but on a CONFIG_XFS_DEBUG=y
kernel it fires this assert....

We're slowly converting asserts like this to explicit checks that
return -EFSCORRUPTED as we come across them - this is obviously code
that hasn't been converted yet....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
