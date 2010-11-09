Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oA9BxXr1152488 for <xfs@oss.sgi.com>; Tue, 9 Nov 2010 05:59:34 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id BADD31C28147
	for <xfs@oss.sgi.com>; Tue,  9 Nov 2010 04:00:59 -0800 (PST)
Received: from mail.internode.on.net (bld-mail19.adl2.internode.on.net
	[150.101.137.104]) by cuda.sgi.com with ESMTP id
	8cWZ7q1ZNmOB6WKp for <xfs@oss.sgi.com>;
	Tue, 09 Nov 2010 04:00:59 -0800 (PST)
Received: from dastard (unverified [121.44.100.105])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	45280381-1927428
	for <xfs@oss.sgi.com>; Tue, 09 Nov 2010 22:30:58 +1030 (CDT)
Date: Tue, 9 Nov 2010 23:00:36 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfstests: add _require_sparse_files
Message-ID: <20101109120036.GM2715@dastard>
References: <20101028123414.GA24977@infradead.org>
	<20101109113453.GA21237@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20101109113453.GA21237@infradead.org>
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

On Tue, Nov 09, 2010 at 06:34:54AM -0500, Christoph Hellwig wrote:
> updated version to also include test 239 which reqires the check, too.
> 
> ---
> From: Christoph Hellwig <hch@lst.de>
> Subject: [PATCH] xfstests: add _require_sparse_files
> 
> Add a helper to check if the filesystem supports sparse files.  This is
> used to guard tests that exercise sparse file functionality and would
> take forever on filesystems that have to zero all blocks on extending
> truncates.
> 
> Unfortunately there's no good way to autodetect this functionality, so
> just implement it as a blacklist for now.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks ok, minor typo needs fixing, but:

Reviewed-by: Dave Chinner <dchinner@redhat.com>

> +#
> +# Check if the filesystem supports sparese files.
                                      sparse

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
