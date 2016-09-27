Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:43084 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752826AbcI0Nhd (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 27 Sep 2016 09:37:33 -0400
Date: Tue, 27 Sep 2016 21:37:30 +0800
From: Eryu Guan <eguan@redhat.com>
Subject: Re: [PATCH v3] tests/generic: test xfs log recovery metadata LSN
 ordering
Message-ID: <20160927133730.GP27776@eguan.usersys.redhat.com>
References: <1471265786-24970-1-git-send-email-bfoster@redhat.com>
 <20160927131249.GA38187@bfoster.bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20160927131249.GA38187@bfoster.bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: fstests@vger.kernel.org, xfs@oss.sgi.com, linux-xfs@vger.kernel.org

On Tue, Sep 27, 2016 at 09:12:49AM -0400, Brian Foster wrote:
> On Mon, Aug 15, 2016 at 08:56:26AM -0400, Brian Foster wrote:
> > XFS had a bug that lead to a possible out-of-order log recovery
> > situation (e.g., replay a stale modification from the log over more
> > recent metadata in destination buffer). This resulted in false
> > corruption reports during log recovery and thus mount failure.
> > 
> > This condition is caused by system crash or filesystem shutdown shortly
> > after a successful log recovery. Add a test to run a combined workload,
> > fs shutdown and log recovery loop known to reproduce the problem on
> > affected kernels.
> > 
> > Signed-off-by: Brian Foster <bfoster@redhat.com>
> > ---
> > 
> 
> ping

It's pending in my stage tree, because it crashes current upstream
kernel, and Dave wants the fixes go upstream first, so the test won't
crash the test machine and interrupt the test.

I noticed the fixes are in xfs tree for-next branch, I think we're ready
to include this test in next fstests update.

Thanks,
Eryu
