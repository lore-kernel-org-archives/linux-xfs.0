Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p051xftt075310 for <xfs@oss.sgi.com>; Tue, 4 Jan 2011 19:59:41 -0600
Subject: Re: [PATCH] xfs: ensure log covering transactions are synchronous
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <1294116569-15052-1-git-send-email-david@fromorbit.com>
References: <1294116569-15052-1-git-send-email-david@fromorbit.com>
Date: Tue, 04 Jan 2011 20:01:46 -0600
Message-ID: <1294192906.2485.730.camel@doink>
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

On Tue, 2011-01-04 at 15:49 +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> To ensure the log is covered and the filesystem idles correctly, we
> need to ensure that dummy transactions hit the disk and do not stay
> pinned in memory.  If the superblock is pinned in memory, it can't
> be flushed so the log covering cannot make progress. The result is
> dependent on timing - more oftent han not we continue to issues a
> log covering transaction every 36s rather than idling after ~90s.
> 
> Fix this by making the log covering transaction synchronous. To
> avoid additional log force from xfssyncd, make the log covering
> transaction take the place of the existing log force in the xfssyncd
> background sync process.
> 

Looks good.

Reviewed-by: Alex Elder <aelder@sgi.com>

> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
