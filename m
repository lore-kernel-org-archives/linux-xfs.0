Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:36754 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933832AbeEILjm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 9 May 2018 07:39:42 -0400
Date: Wed, 9 May 2018 04:39:42 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v2 1/3] xfs: add bmapi nodiscard flag
Message-ID: <20180509113942.GA17093@infradead.org>
References: <20180508172231.53570-1-bfoster@redhat.com>
 <20180508172231.53570-2-bfoster@redhat.com>
 <20180509074629.GC19933@infradead.org>
 <20180509105853.GD64624@bfoster.bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180509105853.GD64624@bfoster.bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org

> I deliberately went away from that approach based on Dave's feedback
> (similarly with the xfs_itruncate_extents() comment in the subsequent
> patch). I used the bool that is used here rather than pass the flag
> directly, but it's essentially the same idea in terms of exposing the
> function signature change to callers.

I haven't had time to catch up on the previous iterations, sorry.

> 
> TBH, I don't much care which of the N possible variants of code
> factoring we use here, but I think we're officially bikeshedding once
> the feedback starts to go in circles as such. ;) So unless I see some
> broader/mutual agreement (or a strong preference from the maintainer) on
> a change back to something like the original factoring (perhaps using a
> flag instead of a bool), I'm going to assume changing it back will
> simply reintroduce the previous feedback and leave this as is.

FYI, I really hate trivial rappers that just hide a single argument.
There are a few use cases for them, mostly because the API has a lot
of pre-existing callers that don't care and it would create too much
churn.  But creating wrappers for both possible arguments of a bool
is just silly.

Also in general bools can be ver confusing, especially once we grow
more than one in a given prototype.  If we already only use it to set
a flag deeper down I much, much prefer to expose the flag as it is
self-documenting, very much unlike a 'true' or 'false' argument.
