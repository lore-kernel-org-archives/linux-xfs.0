Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F36BC4332F
	for <linux-xfs@archiver.kernel.org>; Tue, 14 Nov 2023 21:26:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232570AbjKNV0o (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 14 Nov 2023 16:26:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234061AbjKNV0n (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 14 Nov 2023 16:26:43 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A74BF9D;
        Tue, 14 Nov 2023 13:26:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=Y22DQC8Lsmp2Azl/1OW9hvIgtyMMXTeICc25wGhveAU=; b=sv3IZklUAfVpOdArpL3vBg5u4z
        nU4X8iSmDNVmMH+vX5s2MRxtujH5Rc6XAZJRYfJSPrR6UaJzZhl+rz+wiLgBYyVt9h+2DfLtJDrm+
        S8CERw9AGfh+nnfoatywmSz7OJWEjRkzud4TJlU0fH0Nhs+mQBGR+zh9q/OTHuabvuEWy+G6nJ9EP
        oWNb6T5wYMEJnsWmOtK4flkmqzJX15sMuLKcZ2t1wsJuOFC2x0dxpfNPm1SGl0QxM+GvqxA8uyepQ
        yM4ZQicSOLXD8zhDcla4X9ZvYv/ZVZlCya8kKpHwoC+AtyUUlXS1Bvzn+YR0ToksugZKO3pRKNrpx
        r16DH0VQ==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1r30va-00AHdF-MR; Tue, 14 Nov 2023 21:26:34 +0000
Date:   Tue, 14 Nov 2023 21:26:34 +0000
From:   Matthew Wilcox <willy@infradead.org>
To:     Waiman Long <longman@redhat.com>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>, Will Deacon <will@kernel.org>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Chandan Babu R <chandan.babu@oracle.com>,
        "Darrick J . Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org,
        Mateusz Guzik <mjguzik@gmail.com>
Subject: Re: [PATCH v3 1/4] locking: Add rwsem_assert_held() and
 rwsem_assert_held_write()
Message-ID: <ZVPmCoLVXyShSrkN@casper.infradead.org>
References: <20231110204119.3692023-1-willy@infradead.org>
 <20231110204119.3692023-2-willy@infradead.org>
 <52f481a3-bf4f-85ae-9ae6-10a23b48c7c5@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52f481a3-bf4f-85ae-9ae6-10a23b48c7c5@redhat.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Nov 10, 2023 at 05:21:22PM -0500, Waiman Long wrote:
> On 11/10/23 15:41, Matthew Wilcox (Oracle) wrote:
> >   static inline int rwsem_is_locked(struct rw_semaphore *sem)
> >   {
> > -	return atomic_long_read(&sem->count) != 0;
> > +	return atomic_long_read(&sem->count) != RWSEM_UNLOCKED_VALUE;
> >   }
> > -#define RWSEM_UNLOCKED_VALUE		0L
> > -#define __RWSEM_COUNT_INIT(name)	.count = ATOMIC_LONG_INIT(RWSEM_UNLOCKED_VALUE)
> > +static inline void rwsem_assert_held_nolockdep(const struct rw_semaphore *sem)
> > +{
> > +	WARN_ON(atomic_long_read(&sem->count) == RWSEM_UNLOCKED_VALUE);
> > +}
> That is not correct. You mean "!= RWSEM_UNLOCKED_VALUE". Right?

Uhhh ... I always get confused between assert and BUG_ON being opposite
polarity, but I think it's correct.

We are asserting that the rwsem is locked (either for read or write).
That is, it is a bug if the rwsem is unlocked.
So WARN_ON(sem->count == UNLOCKED_VALUE) is correct.  No?

> There are some inconsistency in the use of WARN_ON() and BUG_ON() in the
> assertions. For PREEMPT_RT, held_write is a BUG_ON. For non-PREEMPT_RT, held
> is a BUG_ON. It is not clear why one is BUG_ON and other one is WARN_ON. Is
> there a rationale for that?

I'll fix that up.

> BTW, we can actually check if the current process is the write-lock owner of
> a rwsem, but not for a reader-owned rwsem.

We actually don't want to do that.  See patches 3/4 where I explain how
XFS takes the XFS_ILOCK for write, then passes control to a workqueue
which asserts that the XFS_ILOCK is held for write.  The thread which
took the rwsem for write waits for the workqueue and unlocks the rwsem.

