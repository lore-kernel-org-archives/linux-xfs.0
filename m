Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:34546 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726084AbfEOOma (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 15 May 2019 10:42:30 -0400
Date: Wed, 15 May 2019 10:42:28 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 5/6] xfs: refactor by-size extent allocation mode
Message-ID: <20190515144227.GE2898@bfoster>
References: <20190509165839.44329-1-bfoster@redhat.com>
 <20190509165839.44329-6-bfoster@redhat.com>
 <20190510173413.GD18992@infradead.org>
 <20190513154610.GF61135@bfoster>
 <20190515081016.GJ29211@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190515081016.GJ29211@infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs@vger.kernel.org

On Wed, May 15, 2019 at 01:10:16AM -0700, Christoph Hellwig wrote:
> > WRT to merging the functions, I'm a little concerned about the result
> > being too large. What do you think about folding in _vextent_type() but
> > at the same time factoring out the rmap/counter/resv post alloc bits
> > into an xfs_alloc_ag_vextent_accounting() helper or some such?
> 
> Sounds good to me.  I've looked at the function and another nice thing
> to do would be to not pass the ret bno to xfs_alloc_ag_vextent_agfl,
> but let that function fill out the args structure return value itself.
> 

I believe that's what the existing xfs_alloc_ag_vextent_small() function
does if it happens to allocate from the AGFL. I initially found that
inconsistent, but looking at the additional refactoring with the _type()
function folded away and whatnot I think it's actually better. I'll push
the args update back down into the AGFL helper.

> Also for the trace piints that still say near in them - maybe we should
> change that near to ag?

Yeah, I need to make another pass over the tracepoints...

Brian
