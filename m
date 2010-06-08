Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o586v2eC197078 for <xfs@oss.sgi.com>; Tue, 8 Jun 2010 01:57:03 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0F72C3A1513
	for <xfs@oss.sgi.com>; Mon,  7 Jun 2010 23:59:32 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail17.adl2.internode.on.net
	[150.101.137.102]) by cuda.sgi.com with ESMTP id
	WiO6p7gDUFbCayxE for <xfs@oss.sgi.com>;
	Mon, 07 Jun 2010 23:59:32 -0700 (PDT)
Date: Tue, 8 Jun 2010 16:59:22 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 6/6] writeback: limit write_cache_pages integrity
	scanning to current EOF
Message-ID: <20100608065922.GA7869@dastard>
References: <1275957487-23633-1-git-send-email-david@fromorbit.com>
	<1275957487-23633-7-git-send-email-david@fromorbit.com>
	<20100608053831.GR26335@laptop>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100608053831.GR26335@laptop>
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
To: Nick Piggin <npiggin@suse.de>
Cc: linux-fsdevel@vger.kernel.org, akpm@linux-foundation.org, torvalds@linux-foundation.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

On Tue, Jun 08, 2010 at 03:38:31PM +1000, Nick Piggin wrote:
> On Tue, Jun 08, 2010 at 10:38:07AM +1000, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > sync can currently take a really long time if a concurrent writer is
> > extending a file. The problem is that the dirty pages on the address
> > space grow in the same direction as write_cache_pages scans, so if
> > the writer keeps ahead of writeback, the writeback will not
> > terminate until the writer stops adding dirty pages.
> > 
> > For a data integrity sync, we only need to write the pages dirty at
> > the time we start the writeback, so we can stop scanning once we get
> > to the page that was at the end of the file at the time the scan
> > started.
> > 
> > This will prevent operations like copying a large file preventing
> > sync from completing as it will not write back pages that were
> > dirtied after the sync was started. This does not impact the
> > existing integrity guarantees, as any dirty page (old or new)
> > within the EOF range at the start of the scan will still be
> > captured.
> > 
> > This patch will not prevent sync from blocking on large writes into
> > holes.
> 
> The writes don't have to be into holes to cause this starvation
> problem, do they?

No, they don't.

> > That requires more complex intervention while this patch only
> > addresses the common append-case of this sync holdoff.
> 
> Jan's tagging patch looks pretty good to me and isn't so complex.
> I think we should just take that.

I don't care which one we take as long as it is actually tested by
more than the submitter and we get everything in for 2.6.35...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
