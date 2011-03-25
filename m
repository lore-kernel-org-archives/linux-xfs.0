Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p2PL1jef247211 for <xfs@oss.sgi.com>; Fri, 25 Mar 2011 16:01:45 -0500
Subject: Re: [PATCH 5/6] xfs: add online discard support
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <20110322200138.024991786@bombadil.infradead.org>
References: <20110322195550.260682574@bombadil.infradead.org>
	<20110322200138.024991786@bombadil.infradead.org>
Date: Fri, 25 Mar 2011 16:04:52 -0500
Message-ID: <1301087092.2537.691.camel@doink>
Mime-Version: 1.0
Reply-To: aelder@sgi.com
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

On Tue, 2011-03-22 at 15:55 -0400, Christoph Hellwig wrote:
> Now that we have reliably tracking of deleted extents in a transaction
> we can easily implement "online" discard support which calls
> blkdev_issue_discard once a transaction commits.
> 
> The actual discard is a two stage operation as we first have to mark
> the busy extent as not available for reuse before we can start the
> actual discard.  Note that we don't bother supporting discard for
> the non-delaylog mode.  While that would be possible with this patch
> performance is awfull, and the optimization in the next patch won't
> work as easily.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

. . .

This one looks good overall.  How about adding
documentation to Documentation/filesystems/xfs.txt
to describe the new mount options?  (Dave, same
goes for you with delaylog.  I haven't looked for
any other things missing from there.)

Reviewed-by: Alex Elder <aelder@sgi.com>


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
