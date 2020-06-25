Return-Path: <SRS0=UnAH=AG=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8EFBFC433DF
	for <linux-xfs@archiver.kernel.org>; Thu, 25 Jun 2020 12:34:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6B18320709
	for <linux-xfs@archiver.kernel.org>; Thu, 25 Jun 2020 12:34:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="tQrQyjUi"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404610AbgFYMef (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 Jun 2020 08:34:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404518AbgFYMef (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 Jun 2020 08:34:35 -0400
Received: from casper.infradead.org (unknown [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2AD7EC061573;
        Thu, 25 Jun 2020 05:34:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=XkLx6/a9SPirjCFhvFXv+MOqpvQiQH1vWHfIK3Sdj8s=; b=tQrQyjUiSNf9o8IAggGIK2eRAA
        pF4uiy+ASHgIpPGM2WdXRydoHUKsDz0jKejKPd6UEQ283oUUubmJ21V2RV+891/Bqi2rGeMc+sDm7
        3VOsbW8nMA9K7tt1x0+Px87Fq2D9xxfKcgHZOMBHHgkYGRIP7EU9g4EvNVe08Urlq/241Y15TcLMV
        8vuOLA1AvMyUQlQCSaezCGkWrKF+1O1thsqIZjkX7O6DUccVpECDtTVOQbWOyErtyXxoTNqd4VzRm
        1hUntVD3lHKz/KQFO1nFvRPHWXk3rcLpsgBj6EyWL4dW3VI+7CkrtxyWi5nfYwf7uMWBmVayXiCXX
        oDQBdtlg==;
Received: from willy by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1joR58-00051J-Dq; Thu, 25 Jun 2020 12:34:18 +0000
Date:   Thu, 25 Jun 2020 13:34:18 +0100
From:   Matthew Wilcox <willy@infradead.org>
To:     Michal Hocko <mhocko@kernel.org>
Cc:     linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-xfs@vger.kernel.org, dm-devel@redhat.com,
        Mikulas Patocka <mpatocka@redhat.com>,
        Jens Axboe <axboe@kernel.dk>, NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 1/6] mm: Replace PF_MEMALLOC_NOIO with memalloc_noio
Message-ID: <20200625123418.GB7703@casper.infradead.org>
References: <20200625113122.7540-1-willy@infradead.org>
 <20200625113122.7540-2-willy@infradead.org>
 <20200625122239.GJ1320@dhcp22.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200625122239.GJ1320@dhcp22.suse.cz>
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jun 25, 2020 at 02:22:39PM +0200, Michal Hocko wrote:
> On Thu 25-06-20 12:31:17, Matthew Wilcox wrote:
> > We're short on PF_* flags, so make memalloc_noio its own bit where we
> > have plenty of space.
> 
> I do not mind moving that outside of the PF_* space. Unless I
> misremember all flags in this space were intented to be set only on the
> current which rules out any RMW races and therefore they can be
> lockless. I am not sure this holds for the bitfield you are adding this
> to. At least in_memstall seem to be set on external task as well. But
> this would require double checking. Maybe that is not really intended or
> just a bug.

I was going from the comment:

        /* Unserialized, strictly 'current' */
(which you can't see from the context of the diff, but is above the block)

The situation with ->flags is a little more ambiguous:

/*
 * Only the _current_ task can read/write to tsk->flags, but other
 * tasks can access tsk->flags in readonly mode for example
 * with tsk_used_math (like during threaded core dumping).
 * There is however an exception to this rule during ptrace
 * or during fork: the ptracer task is allowed to write to the
 * child->flags of its traced child (same goes for fork, the parent
 * can write to the child->flags), because we're guaranteed the
 * child is not running and in turn not changing child->flags
 * at the same time the parent does it.
 */

but it wasn't unsafe to use the PF_ flags in the way that you were.
It's just crowded.

If in_memstall is set on other tasks, then it should be moved to the
PFA flags, which there are plenty of.

But a quick grep shows it only being read on other tasks and always
set on current:

kernel/sched/psi.c:     *flags = current->in_memstall;
kernel/sched/psi.c:      * in_memstall setting & accounting needs to be atomic wrt
kernel/sched/psi.c:     current->in_memstall = 1;
kernel/sched/psi.c:      * in_memstall clearing & accounting needs to be atomic wrt
kernel/sched/psi.c:     current->in_memstall = 0;
kernel/sched/psi.c:     if (task->in_memstall)
kernel/sched/stats.h:           if (p->in_memstall)
kernel/sched/stats.h:           if (p->in_memstall)
kernel/sched/stats.h:   if (unlikely(p->in_iowait || p->in_memstall)) {
kernel/sched/stats.h:           if (p->in_memstall)
kernel/sched/stats.h:   if (unlikely(rq->curr->in_memstall))

so I think everything is fine.
