Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p49E8Dpc012579 for <xfs@oss.sgi.com>; Mon, 9 May 2011 09:08:13 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C46BB1E22BE5
	for <xfs@oss.sgi.com>; Mon,  9 May 2011 07:08:12 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id oONIc4BJSTnMYWyf for
	<xfs@oss.sgi.com>; Mon, 09 May 2011 07:08:12 -0700 (PDT)
Date: Mon, 9 May 2011 10:08:12 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/5] xfs: exit AIL push work correctly when AIL is empty
Message-ID: <20110509140812.GC12262@infradead.org>
References: <1304650448-28438-1-git-send-email-david@fromorbit.com>
	<1304650448-28438-3-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1304650448-28438-3-git-send-email-david@fromorbit.com>
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
Cc: xfs@oss.sgi.com

On Fri, May 06, 2011 at 12:54:05PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> The recent conversion of the xfsaild functionality to a work queue
> introduced a hard-to-hit log space grant hang. The main cause is a
> regression where a work exit path fails to clear the PUSHING state
> and recheck the target correctly.
> 
> Make both exit paths do the same PUSHING bit clearing and target
> checking when the "no more work to be done" condition is hit.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
