Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cthulhu.engr.sgi.com (cthulhu.engr.sgi.com [150.166.39.100])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q9UHu6WO061164 for <xfs@oss.sgi.com>; Tue, 30 Oct 2012 12:56:17 -0500
Date: Mon, 29 Oct 2012 18:06:42 -0700
From: Phil White <pwhite@sgi.com>
Subject: Re: [PATCH 09/25] xfs: verify inode buffers as they are read from disk
Message-ID: <20121030010641.GL30227@caliban.engr.sgi.com>
References: <1351146854-19343-1-git-send-email-david@fromorbit.com>
	<1351146854-19343-10-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1351146854-19343-10-git-send-email-david@fromorbit.com>
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

On Thu, Oct 25, 2012 at 05:33:58PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Add an inode buffer verify callback function and pass it into the
> buffer read functions. Inodes are special in that the verbose checks
> will be done when reading the inode, but we still need to sanity
> check the buffer when that is first read. Always verify the magic
> numbers in all inodes in the buffer, rather than jus ton debug
> kernels.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/xfs_inode.c |  100 +++++++++++++++++++++++++++-------------------------
>  1 file changed, 51 insertions(+), 49 deletions(-)

Hunky dory as it's essentially just lifting the same code into a
function.  I wonder a bit if all those checks are strictly necessary vs.
simply being belt-and-suspenders safe, but that thought's not related to
your patch.

Reviewed-by: Phil White <pwhite@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
