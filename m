Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qA2LMKn2185321 for <xfs@oss.sgi.com>; Fri, 2 Nov 2012 16:22:20 -0500
Message-ID: <509439F9.7090403@sgi.com>
Date: Fri, 02 Nov 2012 16:24:09 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 4/6] xfs: don't vmap inode cluster buffers during free
References: <1351816724-3000-1-git-send-email-david@fromorbit.com>
	<1351816724-3000-5-git-send-email-david@fromorbit.com>
In-Reply-To: <1351816724-3000-5-git-send-email-david@fromorbit.com>
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

On 11/01/12 19:38, Dave Chinner wrote:
> From: Dave Chinner<dchinner@redhat.com>
>
> Inode buffers do not need to be mapped as inodes are read or written
> directly from/to the pages underlying the buffer. This fixes a
> regression introduced by commit 611c994 ("xfs: make XBF_MAPPED the
> default behaviour").
>
> Signed-off-by: Dave Chinner<dchinner@redhat.com>
> ---


Looks good.

Reviewed-by: Mark Tinguely <tinguely@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
