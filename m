Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 988A27F3F
	for <xfs@oss.sgi.com>; Tue, 22 Apr 2014 04:10:50 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 85D38304043
	for <xfs@oss.sgi.com>; Tue, 22 Apr 2014 02:10:50 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	e0wJU3y7oYp5XrCn for <xfs@oss.sgi.com>;
	Tue, 22 Apr 2014 02:10:46 -0700 (PDT)
Date: Tue, 22 Apr 2014 19:10:43 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 5/9] repair: detect CRC errors in AG headers
Message-ID: <20140422091043.GF15995@dastard>
References: <1397550301-31883-1-git-send-email-david@fromorbit.com>
	<1397550301-31883-6-git-send-email-david@fromorbit.com>
	<20140421071106.GF20384@infradead.org>
	<20140421233512.GE18672@dastard>
	<20140422064737.GA32026@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140422064737.GA32026@infradead.org>
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

On Mon, Apr 21, 2014 at 11:47:37PM -0700, Christoph Hellwig wrote:
> On Tue, Apr 22, 2014 at 09:35:12AM +1000, Dave Chinner wrote:
> > > Shouldn't we apply the same scheme as for directories here, that is if
> > > it fails with a verifier error re-read without the verifier and then
> > > still do the full check as well?
> > 
> > The directory code is the special case - it uses xfs_trans_read_buf*
> > interfaces, which return either a good buffer with no error or an
> > error with no buffer. Hence for the directory code, we have to
> > re-read the buffer without the verifier to grab the unchecked buffer
> > from the cache when the verifier detects an error.
> 
> How about just having a variant of xfs_da_read_buf that doesn't use
> xfs_trans_read_buf *?  xfs_da_read_buf is pretty simple, especially
> when removing the magic test that has been superceeded by the verifiers.

Right now I ijust want to keep the change as small as possible and
get a release out.

Yes, I agree there's much more cleanup that is needed in this code,
but at this point is seems unnecessary and doesn't matter for the
purpose of providing this functionality initially.  We have to
provide the same functionality for the kernel code for it to be able
to handle CRC errors sanely, and so we're going to need to
restructure xfs_trans_read_buf() to handle it. in doing this, we
solve the libxfs problem, too, because what we do to the kernel code
will flow on to userspace...

So really, I'd prefer to leave the userspace code doing this retry
for this one piece of infrastructure and do all the major
restructing of the directory buffer read code in the kernel code
first. That way we can pick up all the changes for userspace when
the libxfs code is updated.

Keep in mind that right now we've got a *lot* of updates from the
kernel to the libxfs code pending that are stalled waiting for a
release to be done...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
