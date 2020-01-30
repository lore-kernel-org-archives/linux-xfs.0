Return-Path: <SRS0=Xde3=3T=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CDF66C33CB3
	for <linux-xfs@archiver.kernel.org>; Thu, 30 Jan 2020 20:15:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AE01C20CC7
	for <linux-xfs@archiver.kernel.org>; Thu, 30 Jan 2020 20:15:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727513AbgA3UPC (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 30 Jan 2020 15:15:02 -0500
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:48427 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727089AbgA3UPB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 30 Jan 2020 15:15:01 -0500
Received: from dread.disaster.area (pa49-195-111-217.pa.nsw.optusnet.com.au [49.195.111.217])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 8B7107EB54B;
        Fri, 31 Jan 2020 07:14:48 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1ixGD9-0004Gs-L2; Fri, 31 Jan 2020 07:14:47 +1100
Date:   Fri, 31 Jan 2020 07:14:47 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     Pavel Reichl <preichl@redhat.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/4] xfs: change xfs_isilocked() to always use lockdep()
Message-ID: <20200130201447.GQ18610@dread.disaster.area>
References: <20200128145528.2093039-1-preichl@redhat.com>
 <20200128145528.2093039-2-preichl@redhat.com>
 <20200129221819.GO18610@dread.disaster.area>
 <20200130074424.GA26672@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200130074424.GA26672@infradead.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=X6os11be c=1 sm=1 tr=0
        a=0OveGI8p3fsTA6FL6ss4ZQ==:117 a=0OveGI8p3fsTA6FL6ss4ZQ==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=Jdjhy38mL1oA:10
        a=7-415B0cAAAA:8 a=qOw1xwdTp3iPh-SbM6wA:9 a=CjuIK1q_8ugA:10
        a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jan 29, 2020 at 11:44:24PM -0800, Christoph Hellwig wrote:
> On Thu, Jan 30, 2020 at 09:18:19AM +1100, Dave Chinner wrote:
> > This captures both read and write locks on the rwsem, and doesn't
> > discriminate at all. Now we don't have explicit writer lock checking
> > in CONFIG_XFS_DEBUG=y kernels, I think we need to at least check
> > that the rwsem is locked in all cases to catch cases where we are
> > calling a function without the lock held. That will ctach most
> > programming mistakes, and then lockdep will provide the
> > read-vs-write discrimination to catch the "hold the wrong lock type"
> > mistakes.
> > 
> > Hence I think this code should end up looking like this:
> > 
> > 	if (lock_flags & (XFS_ILOCK_EXCL|XFS_ILOCK_SHARED)) {
> > 		bool locked = false;
> > 
> > 		if (!rwsem_is_locked(&ip->i_lock))
> > 			return false;
> > 		if (!debug_locks)
> > 			return true;
> > 		if (lock_flags & XFS_ILOCK_EXCL)
> > 			locked = lockdep_is_held_type(&ip->i_lock, 0);
> > 		if (lock_flags & XFS_ILOCK_SHARED)
> > 			locked |= lockdep_is_held_type(&ip->i_lock, 1);
> > 		return locked;
> > 	}
> > 
> > Thoughts?
> 
> I like the idea, but I really think that this does not belong into XFS,
> but into the core rwsem code.  That means replacing the lock_flags with
> a bool exclusive, picking a good name for it (can't think of one right
> now, except for re-using rwsem_is_locked), and adding a kerneldoc
> comment explaining the semantics and use cases in detail.

I'd say that's the step after removing mrlocks in XFS. Get this
patchset sorted, then lift the rwsem checking function to the core
code as a separate patchset that can be handled indepedently to the
changes we need to make to XFS...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
