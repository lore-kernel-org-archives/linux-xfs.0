Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q3OIAdDU094884 for <xfs@oss.sgi.com>; Tue, 24 Apr 2012 13:10:39 -0500
Message-ID: <4F96EC97.3050404@sgi.com>
Date: Tue, 24 Apr 2012 13:10:31 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 29/37 V2] xfs: move busy extent handling to it's own file
References: <1335160747-17254-1-git-send-email-david@fromorbit.com>
	<1335160747-17254-30-git-send-email-david@fromorbit.com>
	<20120423175725.GG16881@sgi.com>
	<20120424002502.GS9541@dastard> <4F96CD24.2070805@sgi.com>
In-Reply-To: <4F96CD24.2070805@sgi.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: Ben Myers <bpm@sgi.com>, xfs@oss.sgi.com

On 04/24/12 10:56, Mark Tinguely wrote:
> On 04/23/12 19:25, Dave Chinner wrote:
>
> From: Dave Chinner <dchinner@redhat.com>
>
> To make it easier to handle userspace code merges, move all the busy
> extent handling out of the allocation code and into it's own file.
> The userspace code does not need the busy extent code, so this
> simplifies the merging of the kernel code into the userspace
> xfsprogs library.
>
> Because the busy extent code has been almost completely rewritten
> over the past couple of years, also update the copyright on this new
> file to include the authors that made all those changes.
>
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>
> Should xfs_alloc_busy_trim() be STATIC? It is defined in
> xfs_extent_busy.c and used in xfs_alloc.c.
>
> Same story for the next patch which renames this routine.
>
> Thanks,
>
> Mark Tinguely <tinguely@sgi.com>

FYI,

The routines in this patch call for struct xfs_busy_extent, but the 
xfs_extent_busy.h header file defines struct xfs_extent_busy.

I know this structure will get converted for the next patch.

Reviewed-by: Mark Tinguely <tinguely@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
