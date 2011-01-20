Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p0KEglKB099004 for <xfs@oss.sgi.com>; Thu, 20 Jan 2011 08:42:47 -0600
Date: Thu, 20 Jan 2011 08:45:03 -0600
From: Geoffrey Wehrman <gwehrman@sgi.com>
Subject: Re: Issues with delalloc->real extent allocation
Message-ID: <20110120144503.GA7225@sgi.com>
References: <20110114002900.GF16267@dastard> <20110114214334.GN28274@sgi.com>
	<20110114235549.GI16267@dastard>
	<20110118204752.GB28791@infradead.org>
	<20110118231831.GZ28803@dastard>
	<20110119120321.GC12941@infradead.org>
	<20110119133147.GN16267@dastard>
	<20110119135548.GA11502@infradead.org>
	<20110120013346.GO16267@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110120013346.GO16267@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@infradead.org>, bpm@sgi.com, xfs@oss.sgi.com

On Thu, Jan 20, 2011 at 12:33:46PM +1100, Dave Chinner wrote:
| Given that XFS is aimed towards optimising for the large file/large
| IO/high throughput type of application, I'm comfortable with saying
| that avoiding sub-page writes for optimal throughput IO is an
| application problem and going from there. Especially considering
| that stuff like rsync and untarring kernel tarballs are all
| appending writes so won't take any performance hit at all...

I agree.  I do not expect systems with 64K pages to be used for single
bit manipulations.  However, I do see a couple of potential problems.

The one place where page size I/O may not work though is for an DMAPI/HSM
(DMF) managed filesystem where some blocks are managed on near-line media.
The DMAPI needs to be able to remove and restore extents on a filesystem
block boundary, not a page boundary.

The other downside is that for sparse files, we could end up allocating
space for zero filled blocks.  There may be some workloads where
significant quantities of space are wasted.


-- 
Geoffrey Wehrman

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
