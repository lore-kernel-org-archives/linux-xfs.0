Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p3LI1HHd168433 for <xfs@oss.sgi.com>; Thu, 21 Apr 2011 13:01:17 -0500
Received: from rcsinet10.oracle.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 6193D1142002
	for <xfs@oss.sgi.com>; Thu, 21 Apr 2011 11:04:42 -0700 (PDT)
Received: from rcsinet10.oracle.com (rcsinet10.oracle.com [148.87.113.121]) by
	cuda.sgi.com with ESMTP id Xaykk9hunX8RFAkU for
	<xfs@oss.sgi.com>; Thu, 21 Apr 2011 11:04:42 -0700 (PDT)
From: Chris Mason <chris.mason@oracle.com>
Subject: Re: buffered writeback torture program
In-reply-to: <20110421180213.GA19255@infradead.org>
References: <1303322378-sup-1722@think> <20110421083258.GA26784@infradead.org>
	<1303407205-sup-6141@think> <20110421174120.GA7267@infradead.org>
	<93CB867E-B908-4B38-A146-A9DC958ACF64@dilger.ca>
	<20110421180213.GA19255@infradead.org>
Date: Thu, 21 Apr 2011 14:02:43 -0400
Message-Id: <1303408883-sup-1495@think>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: Andreas Dilger <adilger@dilger.ca>, axboe <axboe@kernel.dk>, jack <jack@suse.cz>, xfs <xfs@oss.sgi.com>, dchinner <dchinner@redhat.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-ext4 <linux-ext4@vger.kernel.org>

Excerpts from Christoph Hellwig's message of 2011-04-21 14:02:13 -0400:
> On Thu, Apr 21, 2011 at 11:59:37AM -0600, Andreas Dilger wrote:
> > But doesn't XFS have potentially very large extents, especially in the case of files that were fallocate()'d or linearly written?  If there is a single 8GB extent, and then random writes within that extent (seems very database like) grouping the all of the writes in the extent doesn't seem so great.
> 
> It doesn't cluster any writes in an extent.  It only writes out
> additional dirty pages directly following that one we were asked to
> write out.  As soon as we hit a non-dirty page we give up.

For this program, they are almost all dirty pages.

I tried patching it to give up if we seek but it is still pretty slow.
There's something else going on in addition to the xfs clustering being
too aggressive.

I'll try dropping the clustering completley.

-chris

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
