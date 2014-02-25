Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 4D1C97F50
	for <xfs@oss.sgi.com>; Tue, 25 Feb 2014 17:36:04 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 2375E304075
	for <xfs@oss.sgi.com>; Tue, 25 Feb 2014 15:36:01 -0800 (PST)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	usSy4ei8Fee6QiAy for <xfs@oss.sgi.com>;
	Tue, 25 Feb 2014 15:35:58 -0800 (PST)
Date: Wed, 26 Feb 2014 10:35:57 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v2] xfs_io: add support for flink
Message-ID: <20140225233556.GI13647@dastard>
References: <20140220220000.GA17541@infradead.org>
	<20140221004933.GA9445@infradead.org>
	<20140225195218.GA14110@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140225195218.GA14110@infradead.org>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Tue, Feb 25, 2014 at 11:52:18AM -0800, Christoph Hellwig wrote:
> Signed-off-by: Christoph Hellwig <hch@lst.de>
....
> --- a/man/man8/xfs_io.8
> +++ b/man/man8/xfs_io.8
> @@ -638,6 +638,10 @@ Only available in expert mode and requires privileges.
>  Undo the effects of a filesystem freeze operation.
>  Only available in expert mode and requires privileges.
>  .TP
> +.BI "flink " path
> +Reads a range of bytes in a specified blocksize from the given
> +Link the currently open file descriptor into the filesystem namespace.
> +.TP

Looks like some noise got into that hunk. Other than that:

Reviewed-by: Dave Chinner <dchinner@redhat.com>

I'll remove that extra line when I commit it.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
