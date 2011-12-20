Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pBKGifGR154605 for <xfs@oss.sgi.com>; Tue, 20 Dec 2011 10:44:41 -0600
Date: Tue, 20 Dec 2011 10:45:07 -0600
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH] xfs: mark the xfssyncd workqueue as non-reentrant
Message-ID: <20111220164507.GQ29840@sgi.com>
References: <20111205085321.GA10986@infradead.org>
	<20111219000227.GJ23662@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20111219000227.GJ23662@dastard>
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
Cc: xfs@oss.sgi.com

On Mon, Dec 19, 2011 at 11:02:27AM +1100, Dave Chinner wrote:
> On Mon, Dec 05, 2011 at 03:53:21AM -0500, Christoph Hellwig wrote:
> > On a system with lots of memory pressure that is stuck on synchronous inode
> > reclaim the workqueue code will run one instance of the inode reclaim work
> > item on every CPU. which is not what we want.  Make sure to mark the
> > xfssyncd workqueue as non-reentrant to make sure there only is one instace
> > of each running globally.  Also stop using special paramater for the
> > workqueue; now that we guarantee each fs has only running one of each works
> > at a time there is no need to artificially lower max_active and compensate
> > for that by setting the WQ_CPU_INTENSIVE flag.
> > 
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> Ok, I've had a look in detail at what the WQ_NON_REENTRANT flag does
> and I agree that this is the correct behaviour for the xfssyncd -
> only one instance per filesystem should run at any given time.
> 
> Reviewed-by: Dave Chinner <dchinner@redhat.com>

FWICS this seems reasonable...

Reviewed-by: Ben Myers <bpm@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
