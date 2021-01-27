Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19B0CC433DB
	for <linux-xfs@archiver.kernel.org>; Wed, 27 Jan 2021 21:01:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B752064D9F
	for <linux-xfs@archiver.kernel.org>; Wed, 27 Jan 2021 21:01:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231801AbhA0VBs (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 27 Jan 2021 16:01:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:50062 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231309AbhA0VBj (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 27 Jan 2021 16:01:39 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A539E64D9A;
        Wed, 27 Jan 2021 21:00:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611781258;
        bh=2hV2w1KjvrV5yyULhtWPfTejrr5Nwxl0iDBvw7bkKiA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=qtVGV1eWgWbqYlnXFrFnjRgX/7MURp35lJtlFpWy1nZDBZT1Bzk6dqQLrxQCYc73A
         xYHJ4ebglvEqZnxC9BNODY/XnFlEs+e4i1LTPrMqTRR4XqmJbIq0i6tma1XA22WG9p
         kYgC9DrjWARCNd5LjAMBcTlFZPAH+/itHSNmliwaZLP8tv5exyDk8rhNOW4wVZKdEq
         zeid6l9U0Jv9Nf7HiHyKR9Q9bPZiJFOiSvPHaQGqdSxBcFx7oTsGY0QtpUOY7Q4Lek
         SAwOSd+kmhQnaA56Co6HLLVIS2SUj6bnp+wuoOdIczcR2UPjNNbZpKlwcAxhoEczFq
         rpDN880V9ndpg==
Date:   Wed, 27 Jan 2021 13:00:56 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org,
        david@fromorbit.com
Subject: Re: [PATCH 11/11] xfs: flush speculative space allocations when we
 run out of space
Message-ID: <20210127210056.GK7698@magnolia>
References: <161142791950.2171939.3320927557987463636.stgit@magnolia>
 <161142798066.2171939.9311024588681972086.stgit@magnolia>
 <20210124094816.GE670331@infradead.org>
 <20210125200216.GE7698@magnolia>
 <20210125210628.GP2047559@bfoster>
 <20210126002901.GI7698@magnolia>
 <20210127165734.GA1729362@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210127165734.GA1729362@infradead.org>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jan 27, 2021 at 04:57:34PM +0000, Christoph Hellwig wrote:
> On Mon, Jan 25, 2021 at 04:29:01PM -0800, Darrick J. Wong wrote:
> > ...except that doing so will collide with what we've been telling Yafang
> > (as part of his series to detect nested transactions) as far as when is
> > the appropriate time to set current->journal_info/PF_MEMALLOC_NOFS.
> 
> Can't we do that based on a log/blk reservation?  If not I'm also fine
> with going back to your original goto based loop, it just looked rather
> cumbersome to me.

Meh, we'll figure that out when that series gets closer to merging...

--D
