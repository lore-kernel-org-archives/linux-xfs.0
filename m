Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q1TJbqnN041134 for <xfs@oss.sgi.com>; Wed, 29 Feb 2012 13:37:52 -0600
Date: Wed, 29 Feb 2012 13:37:57 -0600
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH 2/8] xfs: include reservations in quota reporting
Message-ID: <20120229193757.GK7762@sgi.com>
References: <20120220022815.018921977@bombadil.infradead.org>
	<20120220022903.684527645@bombadil.infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120220022903.684527645@bombadil.infradead.org>
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

On Sun, Feb 19, 2012 at 09:28:17PM -0500, Christoph Hellwig wrote:
> Report all quota usage including the currently pending reservations.  This
> avoids the need to flush delalloc space before gathering quota information,
> and matches quota enforcement, which already takes the reservations into
> account.
> 
> This fixes xfstests 270.
> 
> Reviewed-by: Dave Chinner <dchinner@redhat.com>
> Signed-off-by: Christoph Hellwig <hch@lst.de>

I'm a little concerned about large speculative delay block reservations
with this code, but that remains to be seen.

Looks good.

Reviewed-by: Ben Myers <bpm@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
