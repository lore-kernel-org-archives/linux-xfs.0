Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id DE2A37F37
	for <xfs@oss.sgi.com>; Sun, 29 Sep 2013 17:35:26 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id CB7FD304039
	for <xfs@oss.sgi.com>; Sun, 29 Sep 2013 15:35:23 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	t58tFYW2IWy0EFi3 for <xfs@oss.sgi.com>;
	Sun, 29 Sep 2013 15:35:22 -0700 (PDT)
Date: Mon, 30 Sep 2013 08:35:11 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: get rid of count from xfs_iomap_write_allocate()
Message-ID: <20130929223511.GF26872@dastard>
References: <52480744.10606@oracle.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <52480744.10606@oracle.com>
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
To: Jeff Liu <jeff.liu@oracle.com>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On Sun, Sep 29, 2013 at 06:56:04PM +0800, Jeff Liu wrote:
> From: Jie Liu <jeff.liu@oracle.com>
> 
> Get rid of function variable count from xfs_iomap_write_allocate() as
> it is unused.
> 
> Additionally, checkpatch warn me of the following for this change:
> WARNING: extern prototypes should be avoided in .h files
> +extern int xfs_iomap_write_allocate(struct xfs_inode *, xfs_off_t,

Bah, checkpatch should be considered harmful when run on code that
has been around for years. It's a good guide for new code, but...

$ git grep extern fs/xfs/xfs*h |wc -l
345
$ git grep extern include/linux/*h |wc -l
6878
$

.... and the rule of "consistent with existing coding style" when
adding code to existing files generally trumps any "style errors"
that checkpatch might warn about.

> So this patch also remove all extern function prototypes at xfs_iomap.h
> to suppress it to make this code style in consistent manner in this file.

Anyway, it's a cleanup patch to begin with, and there's only a few
of them, so it's not worth complaining about.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
