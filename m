Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oB73hIL9080590 for <xfs@oss.sgi.com>; Mon, 6 Dec 2010 21:43:20 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8C97E14223AA
	for <xfs@oss.sgi.com>; Mon,  6 Dec 2010 19:45:01 -0800 (PST)
Received: from mail.internode.on.net (bld-mail15.adl6.internode.on.net
	[150.101.137.100]) by cuda.sgi.com with ESMTP id
	UCW5xyiDAmzbiR6G for <xfs@oss.sgi.com>;
	Mon, 06 Dec 2010 19:45:01 -0800 (PST)
Date: Tue, 7 Dec 2010 14:44:56 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 6/8] xfs: remove all the inodes on a buffer from the
	AIL in bulk
Message-ID: <20101207034456.GB29856@dastard>
References: <1290993152-20999-1-git-send-email-david@fromorbit.com>
	<1290993152-20999-7-git-send-email-david@fromorbit.com>
	<20101206143308.GA31100@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20101206143308.GA31100@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Mon, Dec 06, 2010 at 09:33:08AM -0500, Christoph Hellwig wrote:
> While the patch looks good for the ail lock contetion removal, I don't
> quite like the model with the double iteration over the log item list
> on the buffer.  What do you think about the following plan:
> 
>  (1) merge xfs_istale_done into xfs_iflush_done by checking for
>      XFS_ISTALE
>  (2) convert not only the inode log item completion to your new scheme,
>      but also the dquots
>  (3) replace xfs_buf_do_callbacks with a callback in the buffer, which
>      now points to the inode and dqout routines, or calls the completion
>      for the only items in "normal" buf items.

Seems like a reasonable approach. However, what I'd prefer to do is
make these changes as a separate set of changes on top of this patch
series rather than try to integrate them into the existing series.
If there are problems, that should make it more bisectable. Do you
have any concerns with such an approach?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
