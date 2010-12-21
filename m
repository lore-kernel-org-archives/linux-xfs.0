Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oBLGiaOR057416 for <xfs@oss.sgi.com>; Tue, 21 Dec 2010 10:44:36 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0DEF614712CC
	for <xfs@oss.sgi.com>; Tue, 21 Dec 2010 08:46:33 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id ERIkL1GV6MgfGoJl for
	<xfs@oss.sgi.com>; Tue, 21 Dec 2010 08:46:33 -0800 (PST)
Date: Tue, 21 Dec 2010 11:46:32 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfsqa: make hole tests independent of speculative
	allocation patterns
Message-ID: <20101221164632.GB9093@infradead.org>
References: <1292922120-28360-1-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1292922120-28360-1-git-send-email-david@fromorbit.com>
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

On Tue, Dec 21, 2010 at 08:02:00PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Many of the "count-the-holes" tests (008, 012, etc) do writes that extend the
> file and hence allocation patterns are dependent on speculative allocation
> beyond EOF behaviour. Hence if we change that behaviour, these tests all fail
> because there is a different pattern of holes.
> 
> Make the tests independent of EOF preallocation behaviour by first truncating
> the file to the size the test is defined to use. This prevents speculative
> prealocation from occurring, and hence changes in such behaviour will not cause
> the tests to fail.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Looks good and fixes the test failure I saw with the dirty release
counter patch.

Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
