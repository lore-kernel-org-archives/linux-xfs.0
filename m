Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id CAE307F4E
	for <xfs@oss.sgi.com>; Wed, 28 May 2014 00:30:22 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id A2E578F8087
	for <xfs@oss.sgi.com>; Tue, 27 May 2014 22:30:22 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.9])
	by cuda.sgi.com with ESMTP id 8x86lFoGLxCUUpL8 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 27 May 2014 22:30:21 -0700 (PDT)
Date: Tue, 27 May 2014 22:30:19 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v2 1/3] xfs: add scan owner field to xfs_eofblocks
Message-ID: <20140528053019.GB3816@infradead.org>
References: <1400845950-41435-1-git-send-email-bfoster@redhat.com>
	<1400845950-41435-2-git-send-email-bfoster@redhat.com>
	<20140527104428.GC1440@infradead.org>
	<20140527121810.GB63281@bfoster.bfoster>
	<20140527212653.GC6677@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140527212653.GC6677@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@infradead.org>, Brian Foster <bfoster@redhat.com>, xfs@oss.sgi.com

On Wed, May 28, 2014 at 07:26:53AM +1000, Dave Chinner wrote:
> > Right... maybe I'm not parsing your point. The purpose here is to avoid
> > the trylock entirely. E.g., Indicate that we have already acquired the
> > lock and can proceed with xfs_free_eofblocks(), rather than fail a
> > trylock and skip (which appears to be a potential infinite loop scenario
> > here due to how the AG walking code handles EAGAIN).
> 
> I think Christoph's concern here is that we are calling a function
> that can take the iolock while we already hold the iolock. i.e. the
> reason we have to add the anti-deadlock code in the first place.

Indeed.

> To
> address that, can we restructure xfs_file_buffered_aio_write() such
> that the ENOSPC/EDQUOT flush is done outside the iolock?
> 
> >From a quick check, I don't think there is any problem with dropping
> the iolock, doing the flushes and then going all the way back to the
> start of the function again, but closer examination and testing is
> warranted...

I think we'd need some form of early space reservation, otherwise we'd
get non-atomic writes.  Time to get those batches write patches out
again..

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
