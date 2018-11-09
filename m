Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:55670 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727781AbeKJApM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 9 Nov 2018 19:45:12 -0500
Date: Fri, 9 Nov 2018 07:04:12 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs: defer online discard submission to a workqueue
Message-ID: <20181109150412.GA9153@infradead.org>
References: <20181105181021.8174-1-bfoster@redhat.com>
 <20181105215139.GA3160@infradead.org>
 <41f009c2-8f17-ca67-6981-72160bdc94c7@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <41f009c2-8f17-ca67-6981-72160bdc94c7@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Christoph Hellwig <hch@infradead.org>, Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org

On Mon, Nov 05, 2018 at 04:20:24PM -0600, Eric Sandeen wrote:
> Is there some downside to Brian's proposal, in principle?
> It seems like it would be an improvement for device that might cause
> a discard bottleneck like this.

We create another bottleneck, we lost thottling, we don't flush
the workqueue when needed and probably a few more.

Nevermind that I don't see any point in optimizing for out of tree
code that no one even bothers to upstream.  All this VDO here and there
crap from Red Hat in the last year is really more than enough.
