Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o59LAAUs032677 for <xfs@oss.sgi.com>; Wed, 9 Jun 2010 16:10:10 -0500
Received: from smtp1.linux-foundation.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id AD51815919C6
	for <xfs@oss.sgi.com>; Wed,  9 Jun 2010 14:15:45 -0700 (PDT)
Received: from smtp1.linux-foundation.org (smtp1.linux-foundation.org
	[140.211.169.13]) by cuda.sgi.com with ESMTP id
	UEeOcOHFSbEFW85X for <xfs@oss.sgi.com>;
	Wed, 09 Jun 2010 14:15:45 -0700 (PDT)
Date: Wed, 9 Jun 2010 14:12:08 -0700
From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 3/3] writeback: limit write_cache_pages integrity
	scanning to current EOF
Message-Id: <20100609141208.a1babcf4.akpm@linux-foundation.org>
In-Reply-To: <1276043840-1946-4-git-send-email-david@fromorbit.com>
References: <1276043840-1946-1-git-send-email-david@fromorbit.com>
	<1276043840-1946-4-git-send-email-david@fromorbit.com>
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

On Wed,  9 Jun 2010 10:37:20 +1000
Dave Chinner <david@fromorbit.com> wrote:

> From: Dave Chinner <dchinner@redhat.com>
> 
> sync can currently take a really long time if a concurrent writer is
> extending a file. The problem is that the dirty pages on the address
> space grow in the same direction as write_cache_pages scans, so if
> the writer keeps ahead of writeback, the writeback will not
> terminate until the writer stops adding dirty pages.
> 
> For a data integrity sync, we only need to write the pages dirty at
> the time we start the writeback, so we can stop scanning once we get
> to the page that was at the end of the file at the time the scan
> started.
> 
> This will prevent operations like copying a large file preventing
> sync from completing as it will not write back pages that were
> dirtied after the sync was started. This does not impact the
> existing integrity guarantees, as any dirty page (old or new)
> within the EOF range at the start of the scan will still be
> captured.
> 
> This patch will not prevent sync from blocking on large writes into
> holes. That requires more complex intervention while this patch only
> addresses the common append-case of this sync holdoff.
> 

I don't know if this regression sucks enough to warrant backporting,
but the fix is simple and is independent of [1/3] and [2/3].

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
