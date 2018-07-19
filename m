Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:60036 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727556AbeGSVRg (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 19 Jul 2018 17:17:36 -0400
Date: Thu, 19 Jul 2018 16:32:49 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 08/14] xfs: support embedded dfops in transaction
Message-ID: <20180719203249.GG29404@bfoster>
References: <20180719134919.29939-1-bfoster@redhat.com>
 <20180719134919.29939-9-bfoster@redhat.com>
 <20180719195653.GI6558@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180719195653.GI6558@infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs@vger.kernel.org

On Thu, Jul 19, 2018 at 12:56:53PM -0700, Christoph Hellwig wrote:
> > +/*
> > + * Move state from one xfs_defer_ops to another and reset the source to initial
> > + * state. This is primarily used to carry state forward across transaction rolls
> > + * with internal dfops.
> > + */
> 
> > +void
> > +xfs_defer_move(
> > +	struct xfs_defer_ops	*dst,
> > +	struct xfs_defer_ops	*src)
> > +{
> > +	int			i;
> > +
> > +	ASSERT(dst != src);
> > +
> > +	list_splice_init(&src->dop_intake, &dst->dop_intake);
> > +	list_splice_init(&src->dop_pending, &dst->dop_pending);
> > +
> > +	for (i = 0; i < XFS_DEFER_OPS_NR_INODES; i++) {
> > +		if (!src->dop_inodes[i])
> > +			break;
> > +		dst->dop_inodes[i] = src->dop_inodes[i];
> > +	}
> > +	for (i = 0; i< XFS_DEFER_OPS_NR_BUFS; i++) {
> > +		if (!src->dop_bufs[i])
> > +			break;
> > +		dst->dop_bufs[i] = src->dop_bufs[i];
> > +	}
> 
> I suspect simply memcpy()ing the state over would be faster..

Hm, I figured open-coding it would be faster than function calls since
there are only 2 pointers, but tbh I'm not sure either way and don't
have a strong preference. That said, I've been thinking a bit about how
to get rid of dop_bufs/inodes entirely (see my reply to the cover letter
thread). If that looks promising then it's probably not worth changing
this over since the code will go away (but otherwise I'll change it to
memcpy() if that's preferred)..

Brian
