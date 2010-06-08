Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o585f1tj193948 for <xfs@oss.sgi.com>; Tue, 8 Jun 2010 00:41:01 -0500
Received: from mx2.suse.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 74DD43A149F
	for <xfs@oss.sgi.com>; Mon,  7 Jun 2010 22:43:32 -0700 (PDT)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id woekTSMvkqTggbFG for <xfs@oss.sgi.com>;
	Mon, 07 Jun 2010 22:43:32 -0700 (PDT)
Date: Tue, 8 Jun 2010 15:43:30 +1000
From: Nick Piggin <npiggin@suse.de>
Subject: Re: [PATCH 4/6] writeback: pay attention to wbc->nr_to_write in
	write_cache_pages
Message-ID: <20100608054330.GS26335@laptop>
References: <1275957487-23633-1-git-send-email-david@fromorbit.com>
	<1275957487-23633-5-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1275957487-23633-5-git-send-email-david@fromorbit.com>
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
Cc: linux-fsdevel@vger.kernel.org, akpm@linux-foundation.org, torvalds@linux-foundation.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

On Tue, Jun 08, 2010 at 10:38:05AM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> If a filesystem writes more than one page in ->writepage, write_cache_pages
> fails to notice this and continues to attempt writeback when wbc->nr_to_write
> has gone negative - this trace was captured from XFS:
> 
> 
>     wbc_writeback_start: towrt=1024
>     wbc_writepage: towrt=1024
>     wbc_writepage: towrt=0
>     wbc_writepage: towrt=-1
>     wbc_writepage: towrt=-5
>     wbc_writepage: towrt=-21
>     wbc_writepage: towrt=-85
> 
> This has adverse effects on filesystem writeback behaviour. write_cache_pages()
> needs to terminate after a certain number of pages are written, not after a
> certain number of calls to ->writepage are made.  This is a regression
> introduced by 17bc6c30cf6bfffd816bdc53682dd46fc34a2cf4 ("vfs: Add
> no_nrwrite_index_update writeback control flag"), but cannot be reverted
> directly due to subsequent bug fixes that have gone in on top of it.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
Acked-by: Nick Piggin <npiggin@suse.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
