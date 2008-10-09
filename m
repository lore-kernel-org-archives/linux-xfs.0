Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 09 Oct 2008 15:46:59 -0700 (PDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m99MkuX7030738
	for <xfs@oss.sgi.com>; Thu, 9 Oct 2008 15:46:56 -0700
Received: from ipmail05.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0574013D6FEB
	for <xfs@oss.sgi.com>; Thu,  9 Oct 2008 15:48:35 -0700 (PDT)
Received: from ipmail05.adl2.internode.on.net (ipmail05.adl2.internode.on.net [203.16.214.145]) by cuda.sgi.com with ESMTP id gAgIfID5Hyts0pYl for <xfs@oss.sgi.com>; Thu, 09 Oct 2008 15:48:35 -0700 (PDT)
Date: Fri, 10 Oct 2008 09:48:32 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH V2] Re-dirty pages on ENOSPC when converting delayed
	allocations
Message-ID: <20081009224832.GK9597@disturbed>
References: <48EB1ABD.3020503@sgi.com> <20081009122726.GH9597@disturbed>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20081009122726.GH9597@disturbed>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Lachlan McIlroy <lachlan@sgi.com>, xfs-oss <xfs@oss.sgi.com>, xfs-dev <xfs-dev@sgi.com>

On Thu, Oct 09, 2008 at 11:27:26PM +1100, Dave Chinner wrote:
> On Tue, Oct 07, 2008 at 06:15:57PM +1000, Lachlan McIlroy wrote:
> > If we get an error in xfs_page_state_convert() - and it's not EAGAIN - then
> > we throw away the dirty page without converting the delayed allocation.  This
> > leaves delayed allocations that can never be removed and confuses code that
> > expects a flush of the file to clear them.  We need to re-dirty the page on
> > error so we can try again later or report that the flush failed.
> 
> Actually, those delalloc pages can be removed - they just need to
> be handled in ->releasepage. The problem there is that the
> delalloc state is checked by looking at the bufferhead, and by
> the time we get to ->releasepage the buffer heads have already gone
> through discard_buffer() and lost the buffer_delay() flag.
> 
> IIRC I had a patch that did the delalloc conversion correctly in
> ->releasepage by utilising a custom ->invalidatepage callouut, but
> the performance overhead was very bad because it is done a page at a
> time. ISTR even posting it to oss....

FWIW, here's the discussion:

http://oss.sgi.com/archives/xfs/2008-04/msg00542.html

I'm not saying that we ѕhould be fixing this right now, but this
is the underlying problem that is causing the direct I/O read
to trip over stale delalloc extents once they've been invalidated.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
