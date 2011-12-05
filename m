Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pB595kpJ124181 for <xfs@oss.sgi.com>; Mon, 5 Dec 2011 03:05:46 -0600
Date: Mon, 5 Dec 2011 04:05:44 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 4/4] xfs: fix the logspace waiting algorithm
Message-ID: <20111205090543.GA18658@infradead.org>
References: <20111128081732.350228200@bombadil.infradead.org>
	<20111128081925.981681380@bombadil.infradead.org>
	<20111130235641.GX29840@sgi.com>
	<20111201072149.GA1319@infradead.org>
	<20111201195128.GZ29840@sgi.com>
	<20111202115141.GA21643@infradead.org>
	<20111205025316.GD7046@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20111205025316.GD7046@dastard>
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
Cc: Christoph Hellwig <hch@infradead.org>, Ben Myers <bpm@sgi.com>, Dave Chinner <dchinner@redhat.com>, xfs@oss.sgi.com

On Mon, Dec 05, 2011 at 01:53:16PM +1100, Dave Chinner wrote:
> Actually, it's quite simple to fix simply by having the free space
> check return the grant head value at the time of the check and then
> using that as the old value in the cmpxchg loop for updating the
> grant head. That is:

I;ll give it a go for 3.3.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
