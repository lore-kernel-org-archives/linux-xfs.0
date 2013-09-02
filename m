Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id C4F377F52
	for <xfs@oss.sgi.com>; Mon,  2 Sep 2013 05:09:36 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 521EEAC003
	for <xfs@oss.sgi.com>; Mon,  2 Sep 2013 03:09:36 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	g2n7TXAjnn9ASyrT for <xfs@oss.sgi.com>;
	Mon, 02 Sep 2013 03:09:34 -0700 (PDT)
Date: Mon, 2 Sep 2013 20:09:30 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 2/2] xfs: ensure we copy buffer type in da btree root
	splits
Message-ID: <20130902100930.GD12779@dastard>
References: <1378081921-18570-1-git-send-email-david@fromorbit.com>
	<1378081921-18570-3-git-send-email-david@fromorbit.com>
	<20130902081725.GB11210@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130902081725.GB11210@infradead.org>
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

On Mon, Sep 02, 2013 at 01:17:25AM -0700, Christoph Hellwig wrote:
> On Mon, Sep 02, 2013 at 10:32:01AM +1000, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > When splitting the root of the da btree, we shuffled data between
> > buffers and the structures that track them. At one point, we copy
> > data and state from one buffer to another, including the ops
> > aasociated with the buffer. When we do this, we also need to copy
> > the buffer type associated with the buf log item so that the buffer
> > is logged correctly. If we don't do that, log recovery won't
> > recognise it and hence it won't recalculate the CRC on the buffer
> > after recovery. This leads to a directory block that can't be read
> > after recovery has run.
> > 
> > Found by inspection after finding the same problem with remote
> > symlink buffers.
> 
> It would be great to find a way to trigger this in QA as this shows
> another area lacking coverage.

I'm pretty sure the same script I discovered the symlink problem was
triggering it. It was actually trying to track down an
assert failure in the directory code that Michael Semon had reported
to me with a rough test case that I then scripted.

I just haven't done enough testing to be certain it wasn't something
else. Also, xfs/182 was assert failures after log recovery that had
a similar signature that I also haven't seen since adding this
patch. So I think we got some coverage of it...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
