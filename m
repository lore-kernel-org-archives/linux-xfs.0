Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cthulhu.engr.sgi.com (cthulhu.engr.sgi.com [150.166.39.100])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q9UHu6Vs061164 for <xfs@oss.sgi.com>; Tue, 30 Oct 2012 12:56:07 -0500
Date: Tue, 30 Oct 2012 06:32:18 -0700
From: Phil White <pwhite@sgi.com>
Subject: Re: [PATCH 21/25] xfs: add buffer pre-write callback
Message-ID: <20121030133218.GG18595@caliban.engr.sgi.com>
References: <1351146854-19343-1-git-send-email-david@fromorbit.com>
	<1351146854-19343-22-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1351146854-19343-22-git-send-email-david@fromorbit.com>
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

On Thu, Oct 25, 2012 at 05:34:10PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Add a callback to the buffer write path to enable verification of
> the buffer and CRC calculation prior to issuing the write to the
> underlying storage.
> 
> If the callback function detects some kind of failure or error
> condition, it must mark the buffer with an error so that the caller
> can take appropriate action. In the case of xfs_buf_ioapply(), a
> corrupt metadta buffer willt rigger a shutdown of the filesystem,
> because something is clearly wrong and we can't allow corrupt
> metadata to be written to disk.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Reviewed-by: Phil White <pwhite@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
