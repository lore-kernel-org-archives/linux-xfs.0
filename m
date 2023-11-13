Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 533AEC4332F
	for <linux-xfs@archiver.kernel.org>; Mon, 13 Nov 2023 08:25:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229686AbjKMIZG (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 13 Nov 2023 03:25:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233083AbjKMIZF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 13 Nov 2023 03:25:05 -0500
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8D9A10F0;
        Mon, 13 Nov 2023 00:25:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=li5b6HvrSAtd0lQREMWpvnGSM883ci1Av/YtBmCW+5U=; b=dxfNd7LGxAT0Mlid+sCMoH0Q/+
        qqcACWUxRaG8oZvfgWq5TkitzmsxtXvAfR47uagyYe8LiJVDn3CRMeryduiYF+GVCXdhrAZl3/dS4
        BLgFrtbHXoJuRVLIMQ7Tdsh4WRd8YWk7GDI5crO1YFIKErDO5xbJJ4TlLhGwPBGvMa+cDx0wa8xZi
        +ejiYnZONuE6lYX4l9OzT+/bWOtBvD/vreSjw0VgAruOcsEuOAWug3EdwGxM97QKvZDO07ULT1AIC
        Z2iixbTctZTqJM2XK+9ps/AXFsXYCSmLmvvFpLO6Tc0rNJ8nfWPLGqBHOLV9VT5So8kiyccDGrWCC
        GFDbfllw==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
        by desiato.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
        id 1r2SFA-001M52-2r;
        Mon, 13 Nov 2023 08:24:33 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
        id 5FAE4300427; Mon, 13 Nov 2023 09:24:28 +0100 (CET)
Date:   Mon, 13 Nov 2023 09:24:27 +0100
From:   Peter Zijlstra <peterz@infradead.org>
To:     "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc:     Ingo Molnar <mingo@redhat.com>, Will Deacon <will@kernel.org>,
        Waiman Long <longman@redhat.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Chandan Babu R <chandan.babu@oracle.com>,
        "Darrick J . Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org,
        Mateusz Guzik <mjguzik@gmail.com>
Subject: Re: [PATCH v3 1/4] locking: Add rwsem_assert_held() and
 rwsem_assert_held_write()
Message-ID: <20231113082427.GB16138@noisy.programming.kicks-ass.net>
References: <20231110204119.3692023-1-willy@infradead.org>
 <20231110204119.3692023-2-willy@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231110204119.3692023-2-willy@infradead.org>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Nov 10, 2023 at 08:41:16PM +0000, Matthew Wilcox (Oracle) wrote:

> +static inline void rwsem_assert_held_nolockdep(const struct rw_semaphore *sem)
> +{
> +	WARN_ON(atomic_long_read(&sem->count) == RWSEM_UNLOCKED_VALUE);
> +}
> +
> +static inline void rwsem_assert_held_write_nolockdep(const struct rw_semaphore *sem)
> +{
> +	WARN_ON(!(atomic_long_read(&sem->count) & RWSEM_WRITER_LOCKED));
> +}

> +static inline void rwsem_assert_held_nolockdep(const struct rw_semaphore *sem)
> +{
> +	BUG_ON(!rwsem_is_locked(sem));
> +}

What's with the WARN_ON() vs BUG_ON() thing?

