Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 453507F5E
	for <xfs@oss.sgi.com>; Wed, 28 May 2014 09:01:09 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 3496B8F8035
	for <xfs@oss.sgi.com>; Wed, 28 May 2014 07:01:06 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id TnEHyQmRZTB1diWd for
	<xfs@oss.sgi.com>; Wed, 28 May 2014 07:01:05 -0700 (PDT)
Date: Wed, 28 May 2014 10:00:36 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH v2 1/3] xfs: add scan owner field to xfs_eofblocks
Message-ID: <20140528140034.GB5567@bfoster.bfoster>
References: <1400845950-41435-1-git-send-email-bfoster@redhat.com>
	<1400845950-41435-2-git-send-email-bfoster@redhat.com>
	<20140527104428.GC1440@infradead.org>
	<20140527121810.GB63281@bfoster.bfoster>
	<20140527212653.GC6677@dastard>
	<20140528053019.GB3816@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140528053019.GB3816@infradead.org>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Tue, May 27, 2014 at 10:30:19PM -0700, Christoph Hellwig wrote:
> On Wed, May 28, 2014 at 07:26:53AM +1000, Dave Chinner wrote:
> > > Right... maybe I'm not parsing your point. The purpose here is to avoid
> > > the trylock entirely. E.g., Indicate that we have already acquired the
> > > lock and can proceed with xfs_free_eofblocks(), rather than fail a
> > > trylock and skip (which appears to be a potential infinite loop scenario
> > > here due to how the AG walking code handles EAGAIN).
> > 
> > I think Christoph's concern here is that we are calling a function
> > that can take the iolock while we already hold the iolock. i.e. the
> > reason we have to add the anti-deadlock code in the first place.
> 
> Indeed.
> 

Ah, I didn't parse correctly then. Thanks...

> > To
> > address that, can we restructure xfs_file_buffered_aio_write() such
> > that the ENOSPC/EDQUOT flush is done outside the iolock?
> > 
> > >From a quick check, I don't think there is any problem with dropping
> > the iolock, doing the flushes and then going all the way back to the
> > start of the function again, but closer examination and testing is
> > warranted...
> 

I considered this briefly early on, but wasn't sure about whether we
should run through the write_checks() bits more than once (e.g.,
potentially do the eof zeroing, etc., multiple times..?).

> I think we'd need some form of early space reservation, otherwise we'd
> get non-atomic writes.  Time to get those batches write patches out
> again..
> 

So the concern is that multiple writers to an overlapped range could
become interleaved? From passing through the code, we hit
generic_perform_write(), which iters over the iov in a
write_begin/copy_write_end loop. If we hit ENOSPC somewhere in the
middle, we'd return what we've written so far. I don't believe the
buffered_aio_write() path would see the error unless it was the first
attempt at a delayed allocation. IOW, mid-write failure will be a short
write vs. an ENOSPC error.

It seems like it _might_ be safe to drop and reacquire iolock given
these semantics (notwithstanding the write_checks() bits), but I could
certainly be missing something...

Brian

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
