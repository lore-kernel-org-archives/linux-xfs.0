Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p2PKvvK9245902 for <xfs@oss.sgi.com>; Fri, 25 Mar 2011 15:57:57 -0500
Subject: Re: [PATCH 4/6] xfs: xfs_trans_read_buf() should return an error
	on failure
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <1300860870-15471-5-git-send-email-david@fromorbit.com>
References: <1300860870-15471-1-git-send-email-david@fromorbit.com>
	<1300860870-15471-5-git-send-email-david@fromorbit.com>
Date: Fri, 25 Mar 2011 16:01:01 -0500
Message-ID: <1301086861.2537.682.camel@doink>
Mime-Version: 1.0
Reply-To: aelder@sgi.com
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

On Wed, 2011-03-23 at 17:14 +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> When inside a transaction and we fail to read a buffer,
> xfs_trans_read_buf returns a null buffer pointer and no error.
> xfs_do_da_buf() checks the error return, but not the buffer, and as
> a result this read failure condition causes a panic when it attempts
> to dereference the non-existant buffer.
> 
> Make xfs_trans_read_buf() return the same error for this situation
> regardless of whether it is in a transaction or not. This means
> every caller does not need to check both the error return and the
> buffer before proceeding to use the buffer.

Good idea.  Later we can clean up callers.  I see that not
all callers currently check for a null buffer return...

Reviewed-by: Alex Elder <aelder@sgi.com>

> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/xfs_trans_buf.c |    3 ++-

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
