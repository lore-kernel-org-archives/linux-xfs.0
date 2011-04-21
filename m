Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p3LIjp4g169878 for <xfs@oss.sgi.com>; Thu, 21 Apr 2011 13:45:51 -0500
Received: from rcsinet10.oracle.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0DA78132DDDD
	for <xfs@oss.sgi.com>; Thu, 21 Apr 2011 11:49:18 -0700 (PDT)
Received: from rcsinet10.oracle.com (rcsinet10.oracle.com [148.87.113.121]) by
	cuda.sgi.com with ESMTP id KdcN0LMaD43YviE3 for
	<xfs@oss.sgi.com>; Thu, 21 Apr 2011 11:49:18 -0700 (PDT)
From: Chris Mason <chris.mason@oracle.com>
Subject: Re: buffered writeback torture program
In-reply-to: <004198D6-9941-4322-BDB1-8176B80262C7@dilger.ca>
References: <1303322378-sup-1722@think> <20110421083258.GA26784@infradead.org>
	<1303407205-sup-6141@think> <20110421174120.GA7267@infradead.org>
	<93CB867E-B908-4B38-A146-A9DC958ACF64@dilger.ca>
	<20110421180213.GA19255@infradead.org> <1303408883-sup-1495@think>
	<20110421180805.GA2627@infradead.org> <1303410534-sup-6933@think>
	<004198D6-9941-4322-BDB1-8176B80262C7@dilger.ca>
Date: Thu, 21 Apr 2011 14:47:22 -0400
Message-Id: <1303411432-sup-9992@think>
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
To: Andreas Dilger <adilger@dilger.ca>
Cc: axboe <axboe@kernel.dk>, jack <jack@suse.cz>, xfs <xfs@oss.sgi.com>, Christoph Hellwig <hch@infradead.org>, dchinner <dchinner@redhat.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-ext4 <linux-ext4@vger.kernel.org>

Excerpts from Andreas Dilger's message of 2011-04-21 14:43:47 -0400:
> On 2011-04-21, at 12:29 PM, Chris Mason wrote:
> > Excerpts from Christoph Hellwig's message of 2011-04-21 14:08:05 -0400:
> >> On Thu, Apr 21, 2011 at 02:02:43PM -0400, Chris Mason wrote:
> >>> For this program, they are almost all dirty pages.
> >>> 
> >>> I tried patching it to give up if we seek but it is still pretty slow.
> >>> There's something else going on in addition to the xfs clustering being
> >>> too aggressive.
> >> 
> >> I'm not sure where you this beeing to agressive from - it's doing
> >> exactly the same amount of I/O as a filesystem writing out a single
> >> page from ->writepage or using write_cache_pages (either directly
> >> or as a copy) as ->writepages.  The only thing special compared to
> >> the no ->writepages case is that it's submitting a large I/O
> >> from the first ->writepage call.
> > 
> > Ok, I see what you mean.  The clustering code stops once it hits
> > nr_to_write, I missed that.  So we shouldn't be doing more than a single
> > writepages call.
> 
> I wonder if it makes sense to disentangle the two processes state in the kernel, by forking the fsync thread before any writes are done.  That would avoid penalizing the random writer in the VM/VFS, but means there needs to be some coordination between the threads (e.g. polling for a sentinel file written when the sequential phase is complete).
> 

The test itself may not be realistic, but I actually think its a feature
that we end up stuck doing the random buffered ios.  Somehow it is much
slower than it should be on my box on xfs.  This isn't universal, other
machines seem to be working fine.

-chris

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
