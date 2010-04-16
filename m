Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o3GH738s261883 for <xfs@oss.sgi.com>; Fri, 16 Apr 2010 12:07:03 -0500
Date: Fri, 16 Apr 2010 13:09:00 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 3/5] xfs: minor odds and ends in xfs_log_recover.c
Message-ID: <20100416170900.GC2729@infradead.org>
References: <1271355454.2680.92.camel@doink>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1271355454.2680.92.camel@doink>
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
To: Alex Elder <aelder@sgi.com>
Cc: xfs@oss.sgi.com

On Thu, Apr 15, 2010 at 01:17:34PM -0500, Alex Elder wrote:
> Odds and ends in "xfs_log_recover.c".  This patch just contains some
> minor things that didn't seem to warrant their own individual
> patches:
> - In xlog_bread_noalign(), drop an assertion that a pointer is
>   non-null (the crash will tell us it was a bad pointer).
> - Add a more descriptive header comment for xlog_find_verify_cycle().
> - Make a few additions to the comments in xlog_find_head().  Also
>   rearrange some expressions in a few spots to produce the same
>   result, but in a way that seems more clear what's being computed.
> 
> (Updated in response to Dave's review comments.  Note I did not
> split this patch like I said I would.)
> 
> Signed-off-by: Alex Elder <aelder@sgi.com>

Looks good,


Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
