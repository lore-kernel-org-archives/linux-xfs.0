Return-Path: <SRS0=RL8k=AD=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B691C433DF
	for <linux-xfs@archiver.kernel.org>; Mon, 22 Jun 2020 19:38:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5C57B2076A
	for <linux-xfs@archiver.kernel.org>; Mon, 22 Jun 2020 19:38:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="O2s4trg/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728050AbgFVTi3 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 22 Jun 2020 15:38:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728068AbgFVTi3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 22 Jun 2020 15:38:29 -0400
X-Greylist: delayed 1301 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 22 Jun 2020 12:38:29 PDT
Received: from casper.infradead.org (unknown [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6980FC061573
        for <linux-xfs@vger.kernel.org>; Mon, 22 Jun 2020 12:38:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=vOlums0omprzRySIKDtGsk5lTE0w50R9+b2YKHN4UQg=; b=O2s4trg/qew86YOcSdJjIffHmA
        DdcAc3OSzu0c6CusCt867ZtR+rnFlEybpH5JG+mdx6CLhP1tRxZQsJZoKjgrEbf5rwiPNstH9ldEG
        N3fkuuR2Cv5QACnTkpY7XpSMCg4yon9Hh7VDDhVY1kLdmIMlmc2ryh8fFFJSiRpd059xok714noEx
        XnfWUmAGEv+ORIyTWMNzfLNQueG/IuuE9/vpinRJrgBwb6m6MAh8YLwIzpr8WBy+N4YpviXPf/Nkf
        cHXElQepKwFRdULiSknyeZ6DPEnBfDOo5ATJwwa5m628ktMXyZOOQKtiFmJPAgolo7WpJnEB9Hko/
        M7I0k82A==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=worktop.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jnRvS-0001lC-9Q; Mon, 22 Jun 2020 19:16:14 +0000
Received: by worktop.programming.kicks-ass.net (Postfix, from userid 1000)
        id 3986D9834A6; Mon, 22 Jun 2020 21:16:13 +0200 (CEST)
Date:   Mon, 22 Jun 2020 21:16:13 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     Waiman Long <longman@redhat.com>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Ingo Molnar <mingo@redhat.com>,
        Juri Lelli <juri.lelli@redhat.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        Qian Cai <cai@lca.pw>, Eric Sandeen <sandeen@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v2 1/2] sched: Add PF_MEMALLOC_NOLOCKDEP flag
Message-ID: <20200622191613.GB2483@worktop.programming.kicks-ass.net>
References: <20200617175310.20912-1-longman@redhat.com>
 <20200617175310.20912-2-longman@redhat.com>
 <20200618000110.GF2005@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200618000110.GF2005@dread.disaster.area>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jun 18, 2020 at 10:01:10AM +1000, Dave Chinner wrote:

> And, really, if we are playing "re-use existing bits" games because
> we've run out of process flags, all these memalloc flags should be
> moved to a new field in the task, say current->memalloc_flags. You
> could also move PF_SWAPWRITE, PF_LOCAL_THROTTLE, and PF_KSWAPD into
> that field as well as they are all memory allocation context process
> flags...

FWIW

There's still 23 bits free after task_struct::in_memstall. That word has
'current only' semantics, just like PF.
