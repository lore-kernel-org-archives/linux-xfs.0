Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:55440 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750968AbdHaNaU (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 31 Aug 2017 09:30:20 -0400
Date: Thu, 31 Aug 2017 15:30:19 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] xfs: remove experimental tag for reflinks
Message-ID: <20170831133019.GA5468@lst.de>
References: <20170830145400.3681-1-hch@lst.de> <20170831064033.GF3775@magnolia> <20170831124321.GA21939@bfoster.bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170831124321.GA21939@bfoster.bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org

On Thu, Aug 31, 2017 at 08:43:21AM -0400, Brian Foster wrote:
> FWIW, I don't really have a strong opinion. To me, removing experimental
> means we feel the code has stabilized long enough in principle, there
> are no significant problems (i.e., corruption/crash vectors) that we are
> aware of and the feature is complete (full userspace tool support, etc).
> The in-core extent list thing seems like more of a general problem to me

Agreed so far.

> That aside, shouldn't we consider the rmapbt experimental tag first, or
> at least at the same time? It's been around for slightly longer.

I've not done much testing on that or have experience with it in general,
nor do I have a customer with a big QA team beating it hard, so I can't
really comment on that one.
