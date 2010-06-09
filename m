Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o59L7qjV032559 for <xfs@oss.sgi.com>; Wed, 9 Jun 2010 16:07:52 -0500
Received: from smtp1.linux-foundation.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 092231591969
	for <xfs@oss.sgi.com>; Wed,  9 Jun 2010 14:13:25 -0700 (PDT)
Received: from smtp1.linux-foundation.org (smtp1.linux-foundation.org
	[140.211.169.13]) by cuda.sgi.com with ESMTP id
	VqIGzDJB85EnA6MM for <xfs@oss.sgi.com>;
	Wed, 09 Jun 2010 14:13:25 -0700 (PDT)
Date: Wed, 9 Jun 2010 14:09:42 -0700
From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/3] writeback: pay attention to wbc->nr_to_write in
	write_cache_pages
Message-Id: <20100609140942.6799c84a.akpm@linux-foundation.org>
In-Reply-To: <1276043840-1946-2-git-send-email-david@fromorbit.com>
References: <1276043840-1946-1-git-send-email-david@fromorbit.com>
	<1276043840-1946-2-git-send-email-david@fromorbit.com>
Mime-Version: 1.0
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
Cc: linux-fsdevel@vger.kernel.org, stable@kernel.org, torvalds@linux-foundation.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

On Wed,  9 Jun 2010 10:37:18 +1000
Dave Chinner <david@fromorbit.com> wrote:

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

Might be needed in -stable.  Unfortunately the most important piece of
information which is needed to make that decision was cunningly hidden
from us behind the vague-to-the-point-of-uselessness term "adverse
effects".

_what_ "adverse effects"??

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
