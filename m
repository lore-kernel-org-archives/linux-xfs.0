Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 291DD7CA3
	for <xfs@oss.sgi.com>; Thu,  2 Jun 2016 17:54:21 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id A9C4CAC003
	for <xfs@oss.sgi.com>; Thu,  2 Jun 2016 15:54:20 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	Nm4Cg8XCqBCJ9lhi for <xfs@oss.sgi.com>;
	Thu, 02 Jun 2016 15:54:17 -0700 (PDT)
Date: Fri, 3 Jun 2016 08:54:15 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [RFC] allow enabling reflinks at runtime
Message-ID: <20160602225415.GP12670@dastard>
References: <1464877150-20457-1-git-send-email-hch@lst.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1464877150-20457-1-git-send-email-hch@lst.de>
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
To: Christoph Hellwig <hch@lst.de>
Cc: xfs@oss.sgi.com, darrick.wong@oracle.com

On Thu, Jun 02, 2016 at 04:19:07PM +0200, Christoph Hellwig wrote:
> I've had some vocal user requests to allow enabling reflinks at run time,
> which happens to be a mostly trivial feature.  The only caveat is that we
> need a large enough log size to support the reflink requirements, but for
> typical large file systems that's not an issue.

Hmmm - how does this interact with all the rmap code? I was not
planning on enabling reflink without rmap and vice versa simply
because it makes the validation and testing matrix vastly more
complex. Indeed, having reflink turned on after a filesystem has
aged for some time (i.e. from unknown initial conditions) makes
validation especially tricky....

Darrick?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
