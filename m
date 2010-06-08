Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o585a45h193784 for <xfs@oss.sgi.com>; Tue, 8 Jun 2010 00:36:04 -0500
Received: from mx2.suse.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D91D6149EF2F
	for <xfs@oss.sgi.com>; Mon,  7 Jun 2010 22:38:34 -0700 (PDT)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id TlNWYwOugI5Xbv2W for <xfs@oss.sgi.com>;
	Mon, 07 Jun 2010 22:38:34 -0700 (PDT)
Date: Tue, 8 Jun 2010 15:38:31 +1000
From: Nick Piggin <npiggin@suse.de>
Subject: Re: [PATCH 6/6] writeback: limit write_cache_pages integrity
	scanning to current EOF
Message-ID: <20100608053831.GR26335@laptop>
References: <1275957487-23633-1-git-send-email-david@fromorbit.com>
	<1275957487-23633-7-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1275957487-23633-7-git-send-email-david@fromorbit.com>
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

On Tue, Jun 08, 2010 at 10:38:07AM +1000, Dave Chinner wrote:
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
> holes.

The writes don't have to be into holes to cause this starvation
problem, do they?


> That requires more complex intervention while this patch only
> addresses the common append-case of this sync holdoff.

Jan's tagging patch looks pretty good to me and isn't so complex.
I think we should just take that.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
