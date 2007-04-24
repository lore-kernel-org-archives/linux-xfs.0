Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 23 Apr 2007 20:08:38 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l3O38XfB029221
	for <xfs@oss.sgi.com>; Mon, 23 Apr 2007 20:08:35 -0700
Date: Tue, 24 Apr 2007 13:08:26 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: review: don't hold ilock when calling vn_iowait
Message-ID: <20070424030826.GG48531920@melbourne.sgi.com>
References: <20070422230303.GX32602149@melbourne.sgi.com> <20070423214338.GA17561@infradead.org> <20070423231706.GO32602149@melbourne.sgi.com> <1A5D0CA3BA5C7CF8B7241F39@timothy-shimmins-power-mac-g5.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1A5D0CA3BA5C7CF8B7241F39@timothy-shimmins-power-mac-g5.local>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Timothy Shimmin <tes@sgi.com>
Cc: David Chinner <dgc@sgi.com>, Christoph Hellwig <hch@infradead.org>, xfs-dev <xfs-dev@sgi.com>, xfs-oss <xfs@oss.sgi.com>

On Tue, Apr 24, 2007 at 12:00:38PM +1000, Timothy Shimmin wrote:
> 
> 
> --On 24 April 2007 9:17:06 AM +1000 David Chinner <dgc@sgi.com> wrote:
> 
> >On Mon, Apr 23, 2007 at 10:43:38PM +0100, Christoph Hellwig wrote:
> >>On Mon, Apr 23, 2007 at 09:03:03AM +1000, David Chinner wrote:
> >>>
> >>> Regression introduced by recent freezing fixes - we should
> >>> not hold the ilock while waiting for I/O completion.
> >>
> >>Looks good, and actually simplies the twisted maze the xfs_sync_inodes is
> >>a little bit.  And the missing IPOINTER_INSERT in the SYNC_CLOSE case
> >>looks like an actual bugfix.
> >
> >I had to look closely at that IPOINTER_INSERT case with SYNC_CLOSE;
> >it was actaully working properly because you'd always end up in
> >the SYNC_CLOSE case having inserted a pointer earlier on in the flow
> >of the function. It certainly wasn't obvious that it was doing the
> >right thing, though.
> >
> I find this existing code and the use of marker pointer macros a bit hard 
> to follow.

Doesn't everyone?

> Can you explain where "earlier on in the flow of the function" we've 
> inserted
> the marker pointer (and unlocked the inode-list lock).

I confused that with the removal of the vp == NULL checks I removed.
Too many things, so little time.

So yes, this probably does fix a bug.

> It would be nice if this could be clearer somehow.

Yes, we should be looking to rip all this cruft out because most of
it is redundant - the generic inode writeback does most of this
for us anyway.

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
