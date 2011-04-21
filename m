Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p3LIS52f169235 for <xfs@oss.sgi.com>; Thu, 21 Apr 2011 13:28:05 -0500
Received: from rcsinet10.oracle.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 93BFB1510746
	for <xfs@oss.sgi.com>; Thu, 21 Apr 2011 11:31:33 -0700 (PDT)
Received: from rcsinet10.oracle.com (rcsinet10.oracle.com [148.87.113.121]) by
	cuda.sgi.com with ESMTP id lB6ZZz4JnH1xhfz7 for
	<xfs@oss.sgi.com>; Thu, 21 Apr 2011 11:31:33 -0700 (PDT)
From: Chris Mason <chris.mason@oracle.com>
Subject: Re: buffered writeback torture program
In-reply-to: <20110421180805.GA2627@infradead.org>
References: <1303322378-sup-1722@think> <20110421083258.GA26784@infradead.org>
	<1303407205-sup-6141@think> <20110421174120.GA7267@infradead.org>
	<93CB867E-B908-4B38-A146-A9DC958ACF64@dilger.ca>
	<20110421180213.GA19255@infradead.org> <1303408883-sup-1495@think>
	<20110421180805.GA2627@infradead.org>
Date: Thu, 21 Apr 2011 14:29:37 -0400
Message-Id: <1303410534-sup-6933@think>
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

Excerpts from Christoph Hellwig's message of 2011-04-21 14:08:05 -0400:
> On Thu, Apr 21, 2011 at 02:02:43PM -0400, Chris Mason wrote:
> > For this program, they are almost all dirty pages.
> > 
> > I tried patching it to give up if we seek but it is still pretty slow.
> > There's something else going on in addition to the xfs clustering being
> > too aggressive.
> 
> I'm not sure where you this beeing to agressive from - it's doing
> exactly the same amount of I/O as a filesystem writing out a single
> page from ->writepage or using write_cache_pages (either directly
> or as a copy) as ->writepages.  The only thing special compared to
> the no ->writepages case is that it's submitting a large I/O
> from the first ->writepage call.
> 

Ok, I see what you mean.  The clustering code stops once it hits
nr_to_write, I missed that.  So we shouldn't be doing more than a single
writepages call.

-chris

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
