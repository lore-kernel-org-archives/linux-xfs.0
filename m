Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q3NHt5VE221912 for <xfs@oss.sgi.com>; Mon, 23 Apr 2012 12:55:05 -0500
Date: Mon, 23 Apr 2012 12:57:25 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH 29/37] xfs: move busy extent handling to it's own file
Message-ID: <20120423175725.GG16881@sgi.com>
References: <1335160747-17254-1-git-send-email-david@fromorbit.com>
	<1335160747-17254-30-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1335160747-17254-30-git-send-email-david@fromorbit.com>
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

Hey Dave,

On Mon, Apr 23, 2012 at 03:58:59PM +1000, Dave Chinner wrote:
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

D'oh!  This one doesn't compile:

/root/xfs/fs/xfs/xfs_discard.c:32:29: fatal error: xfs_extent_busy.h: No such file or directory

-Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
