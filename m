Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oA9MX9dP176493 for <xfs@oss.sgi.com>; Tue, 9 Nov 2010 16:33:09 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 29BC81683E8
	for <xfs@oss.sgi.com>; Tue,  9 Nov 2010 14:34:35 -0800 (PST)
Received: from mail.internode.on.net (bld-mail17.adl2.internode.on.net
	[150.101.137.102]) by cuda.sgi.com with ESMTP id
	PPCgbXNX64NIqMeh for <xfs@oss.sgi.com>;
	Tue, 09 Nov 2010 14:34:35 -0800 (PST)
Date: Wed, 10 Nov 2010 09:34:26 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfstests: check block truncation after write failure
Message-ID: <20101109223426.GO2715@dastard>
References: <20101109114923.GA29629@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20101109114923.GA29629@infradead.org>
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
Cc: Marius Tolzmann <tolzmann@molgen.mpg.de>, xfs@oss.sgi.com

On Tue, Nov 09, 2010 at 06:49:23AM -0500, Christoph Hellwig wrote:
> Extraced from  https://bugzilla.kernel.org/show_bug.cgi?id=22452
> "data corruption after mmap()ing a file and writev() some data to another file"
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks good. One comment below....

Reviewed-by: Dave Chinner <david@fromorbit.com>

> +{
> +	rm -rf $file
> +	rm -rf $file.NEW
> +}
> +
> +trap "_cleanup ; exit \$status" 0 1 2 3 15
> +
> +echo -n "cccccccccc" > $file
> +$here/src/t_mmap_writev $file $file.NEW
> +xxd $file.NEW

xxd - on debian that's packaged in the vim-common package, which
not everyone will have installed (e.g. emacs users ;).

Better to use 'od -Ax' as od is part of coreutils and already used
in other qa tests so we don't introduce a new external dependency...

CHeers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
