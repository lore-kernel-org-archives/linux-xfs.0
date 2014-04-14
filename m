Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 9C2157F4E
	for <xfs@oss.sgi.com>; Mon, 14 Apr 2014 03:13:13 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 2D47DAC002
	for <xfs@oss.sgi.com>; Mon, 14 Apr 2014 01:13:12 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	MvfsaoAcRSriaTU3 for <xfs@oss.sgi.com>;
	Mon, 14 Apr 2014 01:13:11 -0700 (PDT)
Date: Mon, 14 Apr 2014 18:13:07 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 3/6] xfs: xfs_vm_write_end truncates too much on failure
Message-ID: <20140414081307.GA31578@dastard>
References: <1397106053-7489-1-git-send-email-david@fromorbit.com>
	<1397106053-7489-4-git-send-email-david@fromorbit.com>
	<20140410103555.GF17641@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140410103555.GF17641@infradead.org>
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

On Thu, Apr 10, 2014 at 03:35:55AM -0700, Christoph Hellwig wrote:
> On Thu, Apr 10, 2014 at 03:00:50PM +1000, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > Similar to the write_begin problem, xfs-vm_write_end will truncate
> > back to the old EOF, potentially removing page cache from over the
> > top of delalloc blocks with valid data in them. Fix this by
> > truncating back to just the start of the failed write.
> > 
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> 
> Looks good,
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> 
> Any reason you used max_t in the previous one, and opencode it here?

No, just made the changes at different times. I'll fix them both to
use max_t....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
