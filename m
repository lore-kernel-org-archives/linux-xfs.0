Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o8NHcbEN138770 for <xfs@oss.sgi.com>; Thu, 23 Sep 2010 12:38:38 -0500
Subject: Re: [PATCH 13/16] xfs: batch inode reclaim lookup
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <1285137869-10310-14-git-send-email-david@fromorbit.com>
References: <1285137869-10310-1-git-send-email-david@fromorbit.com>
	<1285137869-10310-14-git-send-email-david@fromorbit.com>
Date: Thu, 23 Sep 2010 12:39:29 -0500
Message-ID: <1285263569.1973.62.camel@doink>
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

On Wed, 2010-09-22 at 16:44 +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Batch and optimise the per-ag inode lookup for reclaim to minimise
> scanning overhead. This involves gang lookups on the radix trees to
> get multiple inodes during each tree walk, and tighter validation of
> what inodes can be reclaimed without blocking befor we take any
> locks.
> 
> This is based on ideas suggested in a proof-of-concept patch
> posted by Nick Piggin.

Looks good.

Reviewed-by: Alex Elder <aelder@sgi.com>

> Signed-off-by: Dave Chinner <dchinner@redhat.com>


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
