Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qACFZkGC233251 for <xfs@oss.sgi.com>; Mon, 12 Nov 2012 09:35:46 -0600
Message-ID: <50A117CD.8040907@sgi.com>
Date: Mon, 12 Nov 2012 09:37:49 -0600
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 32/32] xfs: add CRC checks to the log
References: <1352721264-3700-1-git-send-email-david@fromorbit.com>
	<1352721264-3700-33-git-send-email-david@fromorbit.com>
In-Reply-To: <1352721264-3700-33-git-send-email-david@fromorbit.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On 11/12/12 05:54, Dave Chinner wrote:
> From: Christoph Hellwig<hch@lst.de>
>
> Implement CRCs for the log buffers.  We re-use a field in
> struct xlog_rec_header that was used for a weak checksum of the
> log buffer payload in debug builds before.
>
> The new checksumming uses the crc32c checksum we will use elsewhere
> in XFS, and also protects the record header and addition cycle data.
>
> Due to this there are some interesting changes in xlog_sync, as we
> need to do the cycle wrapping for the split buffer case much earlier,
> as we would touch the buffer after generating the checksum otherwise.
>
> The CRC calculation is always enabled, even for non-CRC filesystems,
> as adding this CRC does not change the log format. On non-CRC
> filesystems, only issue an alert if a CRC mismatch is found and
> allow recovery to continue - this will act as an indicator that
> log recovery problems are a result of log corruption. On CRC enabled
> filesystems, however, log recovery will fail.
>
> Note that existing debug kernels will write a simple checksum value
> to the log, so the first time this is run on a filesystem taht was
> last used on a debug kernel it will through CRC mismatch warning
> errors. These can be ignored.
>
> Initially based on a patch from Dave Chinner, then modified
> significantly by Christoph Hellwig.  Modified again by Dave Chinner
> to get to this version.
>
> Signed-off-by: Christoph Hellwig<hch@lst.de>
> Signed-off-by: Dave Chinner<dchinner@redhat.com>
> ---


Reviewed-by: Mark Tinguely <tinguely@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
