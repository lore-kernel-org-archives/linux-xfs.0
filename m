Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p0QLKYR5165849 for <xfs@oss.sgi.com>; Wed, 26 Jan 2011 15:20:34 -0600
Subject: Re: [PATCH 5/8] xfs: prevent extsize alignment from exceeding
	maximum extent size
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <1295945444-29488-6-git-send-email-david@fromorbit.com>
References: <1295945444-29488-1-git-send-email-david@fromorbit.com>
	<1295945444-29488-6-git-send-email-david@fromorbit.com>
Date: Wed, 26 Jan 2011 15:22:55 -0600
Message-ID: <1296076975.1980.942.camel@doink>
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

On Tue, 2011-01-25 at 19:50 +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> When doing delayed allocation, if the allocation size is for a
> maximally sized extent, extent size alignment can push it over this
> limit. This results in an assert failure in xfs_bmbt_set_allf() as
> the extent length is too large to find in the extent record.
> 
> Fix this by ensuring that we allow for space that extent size
> alignment requires (up to 2 * (extsize -1) blocks as we have to
> handle both head and tail alignment) when limiting the maximum size
> of the extent.

I think this is OK, however...

It seems to me that the XFS_FILBLKS_MIN() call you're making is
sort of magical because it pre-supposes exactly what the following
xfs_bmap_extsize_align() actually does.  And because of that, I
would rather see that logic built into xfs_bmap_extsize_align()
itself.  I haven't looked at it closely, but I presume the other
two spots that call xfs_bmap_extsize_align() would be subject to
the same MAXEXTLEN limit.

OK with me if you disagree though.

Reviewed-by: Alex Elder <aelder@sgi.com>

> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/xfs_bmap.c |   10 ++++++++++
>  1 files changed, 10 insertions(+), 0 deletions(-)


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
