Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p0IKbrje156670 for <xfs@oss.sgi.com>; Tue, 18 Jan 2011 14:37:56 -0600
Date: Tue, 18 Jan 2011 15:40:09 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Issues with delalloc->real extent allocation
Message-ID: <20110118204008.GA28791@infradead.org>
References: <20110114002900.GF16267@dastard> <20110114164016.GB30134@sgi.com>
	<20110114225907.GH16267@dastard> <20110115041629.GC11968@sgi.com>
	<20110117051827.GL16267@dastard> <20110117143708.GE11968@sgi.com>
	<20110118002437.GS28803@dastard> <20110118143000.GB8803@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110118143000.GB8803@sgi.com>
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
To: Geoffrey Wehrman <gwehrman@sgi.com>
Cc: xfs@oss.sgi.com

On Tue, Jan 18, 2011 at 08:30:00AM -0600, Geoffrey Wehrman wrote:
> Glad you were able to understand what I meant.  Something I didn't think
> of earlier though:  What happens when I try to use an 8 GB on a system
> with only 4 GB of memory?  I'm not really worried about this pathological
> case, but I do wonder what the effects will be of allocating what could
> be significant quantities of memory in .aio_write.

I think for large regions we'd be much better off to only zero the
blocks on disk, not in-memory - for example like the code in
xfs_zero_remaining_bytes does.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
