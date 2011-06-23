Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p5N58QM7158407 for <xfs@oss.sgi.com>; Thu, 23 Jun 2011 00:08:26 -0500
Received: from ipmail04.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 03CC11752127
	for <xfs@oss.sgi.com>; Wed, 22 Jun 2011 22:08:24 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	gxw8GItcvcJAeEBq for <xfs@oss.sgi.com>;
	Wed, 22 Jun 2011 22:08:24 -0700 (PDT)
Date: Thu, 23 Jun 2011 15:08:19 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: only SetPageUptodate if all buffers are uptodate
Message-ID: <20110623050819.GW32466@dastard>
References: <20110419114028.7844.10303.stgit@nfs3>
	<20110420103521.GA20510@infradead.org>
	<20110420145722.GB29759@sgi.com>
	<20110420153614.GA11362@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110420153614.GA11362@infradead.org>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: bpm@sgi.com, xfs@oss.sgi.com, aelder@sgi.com

On Wed, Apr 20, 2011 at 11:36:14AM -0400, Christoph Hellwig wrote:
> On Wed, Apr 20, 2011 at 09:57:22AM -0500, bpm@sgi.com wrote:
> > Wish I did.  The test case that discovered this only applies to CXFS.  I
> > would have liked to post a test case for XFS but decided that this has
> > been on my TODO list for too long already.  Looks to me like it has to
> > be related to the inode size, so you quit probing buffers after the
> > first.  Maybe some discussion will ring some bells for somebody.
> 
> It would be really good to have one, but the actual patch looks good
> enough that I'd consider putting it in.  I can assumes you ran
> xfstests with various small blocksize options for both the test
> and scratch device and it didn't show any regressions?

I've been running this patch for quite some time, but having just
upgraded to the latest xfstests, this patch is causing fsx failures
in tests 075 091 112 127 and 231 on 3.0-rc4 on x86_64 with default
mkfs and mount parameters. fsx passes again with this patch removed
from my test stack....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
