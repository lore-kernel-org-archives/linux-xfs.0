Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:55564 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728167AbfDYMDZ (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 25 Apr 2019 08:03:25 -0400
Date: Thu, 25 Apr 2019 14:03:22 +0200
From: Michal Hocko <mhocko@kernel.org>
Subject: Re: [LSF/MM TOPIC] guarantee natural alignment for kmalloc()?
Message-ID: <20190425120322.GW12751@dhcp22.suse.cz>
References: <790b68b7-3689-0ff6-08ae-936728bc6458@suse.cz>
 <20190411132819.GB22763@bombadil.infradead.org>
 <20190425113358.GI19031@bombadil.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190425113358.GI19031@bombadil.infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Matthew Wilcox <willy@infradead.org>
Cc: Vlastimil Babka <vbabka@suse.cz>, lsf-pc@lists.linux-foundation.org, Linux-FSDevel <linux-fsdevel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>, linux-block@vger.kernel.org, Christoph Lameter <cl@linux.com>, David Rientjes <rientjes@google.com>, Pekka Enberg <penberg@kernel.org>, Joonsoo Kim <iamjoonsoo.kim@lge.com>, Ming Lei <ming.lei@redhat.com>, linux-xfs@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, Dave Chinner <david@fromorbit.com>, "Darrick J . Wong" <darrick.wong@oracle.com>

On Thu 25-04-19 04:33:59, Matthew Wilcox wrote:
> On Thu, Apr 11, 2019 at 06:28:19AM -0700, Matthew Wilcox wrote:
> > On Thu, Apr 11, 2019 at 02:52:08PM +0200, Vlastimil Babka wrote:
> > > In the session I hope to resolve the question whether this is indeed the
> > > right thing to do for all kmalloc() users, without an explicit alignment
> > > requests, and if it's worth the potentially worse
> > > performance/fragmentation it would impose on a hypothetical new slab
> > > implementation for which it wouldn't be optimal to split power-of-two
> > > sized pages into power-of-two-sized objects (or whether there are any
> > > other downsides).
> > 
> > I think this is exactly the kind of discussion that LSFMM is for!  It's
> > really a whole-system question; is Linux better-off having the flexibility
> > for allocators to return non-power-of-two aligned memory, or allowing
> > consumers of the kmalloc API to assume that "sufficiently large" memory
> > is naturally aligned.
> 
> This has been scheduled for only the MM track.  I think at least the
> filesystem people should be involved in this discussion since it's for
> their benefit.

Agreed. I have marked it as a MM/IO/FS track, we just haven't added it
to the schedule that way. I still plan to go over all topics again and
consolidate the current (very preliminary) schedule. Thanks for catching
this up.

> Do we have an lsf-discuss mailing list this year?  Might be good to
> coordinate arrivals / departures for taxi sharing purposes.

Yes, the list should be established AFAIK and same address as last
years.

-- 
Michal Hocko
SUSE Labs
