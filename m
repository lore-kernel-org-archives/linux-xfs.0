Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qA22h1J0073697 for <xfs@oss.sgi.com>; Thu, 1 Nov 2012 21:43:01 -0500
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	iOPKcQsYf6fcqkW4 for <xfs@oss.sgi.com>;
	Thu, 01 Nov 2012 19:44:52 -0700 (PDT)
Received: from dave by dastard with local (Exim 4.76)
	(envelope-from <david@fromorbit.com>) id 1TU7Ed-0004jT-5E
	for xfs@oss.sgi.com; Fri, 02 Nov 2012 13:43:51 +1100
Date: Fri, 2 Nov 2012 13:43:51 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 5/6] xfs: fix buffer shudown reference count mismatch
Message-ID: <20121102024351.GU29378@dastard>
References: <1351816724-3000-1-git-send-email-david@fromorbit.com>
	<1351816724-3000-6-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1351816724-3000-6-git-send-email-david@fromorbit.com>
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
To: xfs@oss.sgi.com

On Fri, Nov 02, 2012 at 11:38:43AM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> When we shut down the filesystem, we have to unpin and free all the
> buffers currently active in the CIL. To do this we unpin and remove
> them in one operation as a result of a failed iclogbuf write. For
> buffers, we do this removal via a simultated IO completion of after
> marking the buffer stale.
> 
> At the time we do this, we have two references to the buffer - the
> active LRU reference and the buf log item.  The LRU reference is
> removed by marking the buffer stale, and the active CIL reference is
> by the xfs_buf_iodone() callback that is run by
> xfs_buf_do_callbacks() during ioend processing (via the bp->b_iodone
> callback).
> 
> However, ioend processing requires one more reference - that of the
> IO that it is completing. We don't have this reference, so we free
> the buffer prematurely and use it after it is freed. This leads to
> assert failures in xfs_buf_rele() on debug kernels because the
> b_hold count is zero.
> 
> Fix this by making sure we take the necessary IO reference before
> starting IO completion processing on the stale buffer.
> 
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

HOld off on this one for a little while - I think I've found the
source of the subsequent failures that Mark reported.

The reason why this did't fail on every buffer is that not all
buffers drop a reference in xfs_buf_iodone_work(). Only buffers that
are marked with XBF_ASYNC will do this, and they seem to be rare.
Hence the rare failure.

The fix that I've done here means all buffers going through this
path will take an extra reference, but that reference is only
dropped on async buffers. Because all the buffers are markd stale,
they are removed from the LRU, and so xfs_buftarg_wait() during
unmount does not find them and hence the remaining reference is
never removed. Hence the perag reference still remains, and we
assert fail there.

Solution seems simple - set the XBF_ASYNC flag on all buffers so
that the last reference is taken away correctly. Testing that now.

(FWIW, I found this using perag get/put tracing :)

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
