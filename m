Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p3LHXIMr167317 for <xfs@oss.sgi.com>; Thu, 21 Apr 2011 12:33:18 -0500
Received: from rcsinet10.oracle.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 14F2F400C68
	for <xfs@oss.sgi.com>; Thu, 21 Apr 2011 10:36:45 -0700 (PDT)
Received: from rcsinet10.oracle.com (rcsinet10.oracle.com [148.87.113.121]) by
	cuda.sgi.com with ESMTP id SGwCbSicCfI1Ttlx for
	<xfs@oss.sgi.com>; Thu, 21 Apr 2011 10:36:45 -0700 (PDT)
From: Chris Mason <chris.mason@oracle.com>
Subject: Re: buffered writeback torture program
In-reply-to: <20110421083258.GA26784@infradead.org>
References: <1303322378-sup-1722@think> <20110421083258.GA26784@infradead.org>
Date: Thu, 21 Apr 2011 13:34:44 -0400
Message-Id: <1303407205-sup-6141@think>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: axboe <axboe@kernel.dk>, jack <jack@suse.cz>, xfs <xfs@oss.sgi.com>, dchinner <dchinner@redhat.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-ext4 <linux-ext4@vger.kernel.org>

Excerpts from Christoph Hellwig's message of 2011-04-21 04:32:58 -0400:
> On Wed, Apr 20, 2011 at 02:23:29PM -0400, Chris Mason wrote:
> But given that you are able to reproduce it, does the following patch
> help your latencies?  Currently XFS actually does stop I/O when
> nr_to_write reaches zero, but only for non-blocking I/O. This behaviour
> was introduced in commit efceab1d563153a2b1a6e7d35376241a48126989
> 
>     "xfs: handle negative wbc->nr_to_write during sync writeback"
> 
> and works around issues in the generic writeback code.
> 
> 
> Index: linux-2.6/fs/xfs/linux-2.6/xfs_aops.c
> ===================================================================
> --- linux-2.6.orig/fs/xfs/linux-2.6/xfs_aops.c    2011-04-21 10:20:48.303550404 +0200
> +++ linux-2.6/fs/xfs/linux-2.6/xfs_aops.c    2011-04-21 10:20:58.203496773 +0200
> @@ -765,8 +765,7 @@ xfs_convert_page(
>          SetPageUptodate(page);
>  
>      if (count) {
> -        if (--wbc->nr_to_write <= 0 &&
> -            wbc->sync_mode == WB_SYNC_NONE)
> +        if (--wbc->nr_to_write <= 0)
>              done = 1;
>      }
>      xfs_start_page_writeback(page, !page_dirty, count);

Sorry, this doesn't do it.  I think that given what a strange special
case this is, we're best off waiting for the IO-less throttling, and
maybe changing the code in xfs/ext4 to be a little more seek aware.  Or
maybe not, it has to get written eventually either way.

-chris

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
