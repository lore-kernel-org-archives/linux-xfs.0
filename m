Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p11Nag3Q251660 for <xfs@oss.sgi.com>; Tue, 1 Feb 2011 17:36:43 -0600
Subject: Re: [PATCH] xfs_repair: multithread phase 2
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <1294620248-17098-1-git-send-email-david@fromorbit.com>
References: <1294620248-17098-1-git-send-email-david@fromorbit.com>
Date: Tue, 01 Feb 2011 17:39:10 -0600
Message-ID: <1296603550.2350.134.camel@doink>
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

On Mon, 2011-01-10 at 11:44 +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Running some recent repair tests on broken filesystem meant running
> phase 1 and 2 repeatedly to reproduce an issue at the start of phase
> 3. Phase 2 was taking approximately 10 minutes to run as it
> processes each AG serially.
> 
> Phase 2 can be trivially parallelised - it is simply scanning the
> per AG trees to calculate free block counts and free and used inodes
> counts. This can be done safely in parallel by giving each AG it's
> own structure to aggregate counts into, then once the AG scan is
> complete adding them all together.
> 
> This patch uses 32-way threading which results in no noticable
> slowdown on single SATA drives with NCQ, but results in ~10x
> reduction in runtime on a 12 disk RAID-0 array.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

This looks good.  Sorry I didn't say so earlier (I signed
off on your first one).

Reviewed-by: Alex Elder <aelder@sgi.com>


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
