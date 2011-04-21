Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p3LI4eUn168558 for <xfs@oss.sgi.com>; Thu, 21 Apr 2011 13:04:40 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2247615112FC
	for <xfs@oss.sgi.com>; Thu, 21 Apr 2011 11:08:09 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id Ua38geGMlAKHCzTe for
	<xfs@oss.sgi.com>; Thu, 21 Apr 2011 11:08:09 -0700 (PDT)
Date: Thu, 21 Apr 2011 14:08:05 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: buffered writeback torture program
Message-ID: <20110421180805.GA2627@infradead.org>
References: <1303322378-sup-1722@think> <20110421083258.GA26784@infradead.org>
	<1303407205-sup-6141@think> <20110421174120.GA7267@infradead.org>
	<93CB867E-B908-4B38-A146-A9DC958ACF64@dilger.ca>
	<20110421180213.GA19255@infradead.org> <1303408883-sup-1495@think>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1303408883-sup-1495@think>
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
To: Chris Mason <chris.mason@oracle.com>
Cc: Andreas Dilger <adilger@dilger.ca>, axboe <axboe@kernel.dk>, jack <jack@suse.cz>, xfs <xfs@oss.sgi.com>, Christoph Hellwig <hch@infradead.org>, dchinner <dchinner@redhat.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-ext4 <linux-ext4@vger.kernel.org>

On Thu, Apr 21, 2011 at 02:02:43PM -0400, Chris Mason wrote:
> For this program, they are almost all dirty pages.
> 
> I tried patching it to give up if we seek but it is still pretty slow.
> There's something else going on in addition to the xfs clustering being
> too aggressive.

I'm not sure where you this beeing to agressive from - it's doing
exactly the same amount of I/O as a filesystem writing out a single
page from ->writepage or using write_cache_pages (either directly
or as a copy) as ->writepages.  The only thing special compared to
the no ->writepages case is that it's submitting a large I/O
from the first ->writepage call.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
