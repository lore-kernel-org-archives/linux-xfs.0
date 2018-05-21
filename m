Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:36594 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751504AbeEUObg (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 21 May 2018 10:31:36 -0400
Date: Mon, 21 May 2018 10:31:35 -0400
From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 00/13] convert block layer to bioset_init()/mempool_init()
Message-ID: <20180521143132.GB19194@redhat.com>
References: <20180520222558.7053-1-kent.overstreet@gmail.com>
 <20180521140348.GA19069@redhat.com>
 <686d7df6-c7d1-48a6-b7ff-48dc8aff6a62@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <686d7df6-c7d1-48a6-b7ff-48dc8aff6a62@kernel.dk>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jens Axboe <axboe@kernel.dk>
Cc: Kent Overstreet <kent.overstreet@gmail.com>, linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, hch@infradead.org, colyli@suse.de, darrick.wong@oracle.com, clm@fb.com, bacik@fb.com, linux-xfs@vger.kernel.org, drbd-dev@lists.linbit.com, linux-btrfs@vger.kernel.org, linux-raid@vger.kernel.org, neilb@suse.com

On Mon, May 21 2018 at 10:19am -0400,
Jens Axboe <axboe@kernel.dk> wrote:

> On 5/21/18 8:03 AM, Mike Snitzer wrote:
> > On Sun, May 20 2018 at  6:25pm -0400,
> > Kent Overstreet <kent.overstreet@gmail.com> wrote:
> > 
> >> Jens - this series does the rest of the conversions that Christoph wanted, and
> >> drops bioset_create().
> >>
> >> Only lightly tested, but the changes are pretty mechanical. Based on your
> >> for-next tree.
> > 
> > By switching 'mempool_t *' to 'mempool_t' and 'bio_set *' to 'bio_set'
> > you've altered the alignment of members in data structures.  So I'll
> > need to audit all the data structures you've modified in DM.
> > 
> > Could we get the backstory on _why_ you're making this change?
> > Would go a long way to helping me appreciate why this is a good use of
> > anyone's time.
> 
> Yeah, it's in the first series, it gets rid of a pointer indirection.

"Allows mempools to be embedded in other structs, getting rid of a
pointer indirection from allocation fastpaths."

So this is about using contiguous memory or avoiding partial allocation
failure?  Or both?

Or more to it?  Just trying to fully appreciate the theory behind the
perceived associated benefit.

I do think the increased risk of these embedded bio_set and mempool_t
themselves crossing cachelines, or struct members that follow them doing
so, really detracts from these types of changes.

Thanks,
Mike
