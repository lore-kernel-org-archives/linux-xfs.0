Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p121RfAD257025 for <xfs@oss.sgi.com>; Tue, 1 Feb 2011 19:27:41 -0600
Subject: Re: [PATCH 4/4] xfstests: Speed up test 042
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <1295927937-20634-5-git-send-email-david@fromorbit.com>
References: <1295927937-20634-1-git-send-email-david@fromorbit.com>
	<1295927937-20634-5-git-send-email-david@fromorbit.com>
Date: Tue, 01 Feb 2011 19:30:09 -0600
Message-ID: <1296610209.2350.161.camel@doink>
Mime-Version: 1.0
Reply-To: aelder@sgi.com
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
Cc: xfs@oss.sgi.com

On Tue, 2011-01-25 at 14:58 +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> test 042 generates a worst-case fragmented filesystem and uses it to
> test xfs_fsr. It uses small 4k files to generate the hole-space-hole
> pattern that fragments free space badly. It is much faster to
> generate the same pattern by creating a single large file and
> punching holes in it.  Also, instead of writing large files to
> create unfragmented space, just use preallocation so we don't have
> to write the data to disk.
> 
> These changes reduce the runtime of the test on a single SATA drive
> from 106s to 27s.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Perhaps your test system is configured different
from mine, but I don't see the speedup you see.
In fact, it might have slowed it down.  I really
haven't experimented much though and will report
back if I find anything more constructive to say.

Other than that I see no problem with the change.
And the difference either way isn't a big deal
to me, so:

Reviewed-by: Alex Elder <aelder@sgi.com>


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
