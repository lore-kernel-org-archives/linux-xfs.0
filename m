Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 74BAC7CA0
	for <xfs@oss.sgi.com>; Fri, 11 Mar 2016 09:06:13 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id D94F5AC003
	for <xfs@oss.sgi.com>; Fri, 11 Mar 2016 07:06:09 -0800 (PST)
Received: from newverein.lst.de (verein.lst.de [213.95.11.211]) by
	cuda.sgi.com with ESMTP id qxxBn8uZgrwBlLAH (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 11 Mar 2016 07:06:08 -0800 (PST)
Date: Fri, 11 Mar 2016 16:06:06 +0100
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 3/3] xfs: optimize bio handling in the buffer writeback
	path
Message-ID: <20160311150606.GA3016@lst.de>
References: <1456302011-18915-1-git-send-email-hch@lst.de>
	<1456302011-18915-4-git-send-email-hch@lst.de>
	<20160303151730.GC57990@bfoster.bfoster>
	<20160304133854.GB3758@bfoster.bfoster>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160304133854.GB3758@bfoster.bfoster>
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
To: Brian Foster <bfoster@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>, xfs@oss.sgi.com

On Fri, Mar 04, 2016 at 08:38:55AM -0500, Brian Foster wrote:
> One thing I'm a bit suspicious about still is whether the error
> propagation is racy. For example, consider we've created two chained
> bios A and B, such that A is the parent and thus bio(io_remaining) for
> each is A(2) and B(1). Suppose bio A happens to complete first with an
> error. A->bi_error is set and bio_endio(A) is called, which IIUC
> basically just does A(2)->A(1). If bio B completes successfully,
> B->bi_error presumably remains set to 0 and bio_endio(B) is called. The
> latter checks that B->bi_end_io == bio_chain_endio, propagates
> B->bi_error to A->bi_error unconditionally and then walks up to the
> parent bio to drop its reference and finally call A->bi_end_io().
> 
> Doesn't this mean that we can potentially lose errors in the chain? I
> could easily still be missing something here...

Yes, it looks like bio_chain_endio and bio_endio should be fixed
to only set parent->bi_error if it's not already set.  I'll send a 
patch.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
