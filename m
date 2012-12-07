Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qB79p47a208093 for <xfs@oss.sgi.com>; Fri, 7 Dec 2012 03:51:05 -0600
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	p2GnPFIy8d4NyyZr for <xfs@oss.sgi.com>;
	Fri, 07 Dec 2012 01:53:29 -0800 (PST)
Date: Fri, 7 Dec 2012 20:53:26 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: Fix re-use of EWOULDBLOCK during read on dm-mirror
Message-ID: <20121207095326.GI27172@dastard>
References: <50C11E95.4050502@suse.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <50C11E95.4050502@suse.com>
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
To: Jeff Mahoney <jeffm@suse.com>
Cc: xfs@oss.sgi.com

On Thu, Dec 06, 2012 at 05:39:17PM -0500, Jeff Mahoney wrote:
> When using lvconvert to convert a linear mapping to a dm-raid1 mirror,
> we encountered issues where the log would be flooded with messages like:
> 
> metadata I/O error: block 0xee7060 ("xfs_trans_read_buf") error 11 numblks 8
> 
> The cause is that dm-mirror (and striping, and others) will return
> -EWOULDBLOCK for readahead requests while the mirror is rebuilding.

That's nasty - since when has DM been doing this? I doubt anything
handles a EAGAIN error from the storage layer properly - it's not
an error the filesystem expects from the lower layers at all.

> XFS's
> end_io routine caches the errno and then xfs_buf_iowait bails out early
> when it encounters it after issuing the i/o request.

That doesn't sound right. when XFS issues buffer readahead, it does
not wait for it to complete. i.e. we never get to xfs_buf_iowait()
on readahead buffers.

If something then issues a read on the buffer that failed the
readahead, then we enter xfs_buf_iowait() after reissuing the IO.
If it's aborting because of a stale EWOULDBLOCK as a result of
readahead, then the problem is either:

	- failed readahead should not be leaving an error in
	  b_error; or
	- the read IO did not zero b_error before starting the IO

> The I/O eventually
> succeeds and the endio routine resets bp->b_error,

AFAICT, it's a different IO that succeeds (i.e. the resubmitted one
that is being waited for), not the same one.

> but the original read
> request has already returned -EWOULDBLOCK to the user and added the log
> message above to the kernel log, freaking everyone out.
> 
> This patch ignores EWOULDBLOCK when deciding whether to wait for the I/O
> to complete and tries again, allowing the read to succeed as expected.

Which does not appear to be the correct fix - preventing failed
readahead from leaving a stale error on the buffer seems like the
right thing to do here...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
