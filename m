Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id B575B7F3F
	for <xfs@oss.sgi.com>; Mon, 21 Apr 2014 18:35:16 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 345FDAC007
	for <xfs@oss.sgi.com>; Mon, 21 Apr 2014 16:35:16 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	sr4cTuQKfJJEMmHz for <xfs@oss.sgi.com>;
	Mon, 21 Apr 2014 16:35:14 -0700 (PDT)
Date: Tue, 22 Apr 2014 09:35:12 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 5/9] repair: detect CRC errors in AG headers
Message-ID: <20140421233512.GE18672@dastard>
References: <1397550301-31883-1-git-send-email-david@fromorbit.com>
	<1397550301-31883-6-git-send-email-david@fromorbit.com>
	<20140421071106.GF20384@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140421071106.GF20384@infradead.org>
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

On Mon, Apr 21, 2014 at 12:11:06AM -0700, Christoph Hellwig wrote:
> On Tue, Apr 15, 2014 at 06:24:57PM +1000, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > repair doesn't currently detect verifier errors in AG header
> > blocks - apart from the primary superblock they are not detected.
> > They are, fortunately, corrected in the important cases (AGF, AGI
> > and AGFL) because these structures are rebuilt in phase 5, but if
> > you run xfs_repair in checking mode it won't report them as bad.
> 
> Shouldn't we apply the same scheme as for directories here, that is if
> it fails with a verifier error re-read without the verifier and then
> still do the full check as well?

The directory code is the special case - it uses xfs_trans_read_buf*
interfaces, which return either a good buffer with no error or an
error with no buffer. Hence for the directory code, we have to
re-read the buffer without the verifier to grab the unchecked buffer
from the cache when the verifier detects an error.

> Btw, it might make sense to have special read_buf variants in libxfs
> that always return a valid buffer even if the verifier fails, just
> telling us about it without having to re-read.

That's exactly what they do now - you get the xfs_buf, the data in
bp->b_addr and the verifier error in bp->b_error all in one call.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
