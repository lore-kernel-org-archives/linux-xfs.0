Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qA9Hc2I5132557 for <xfs@oss.sgi.com>; Fri, 9 Nov 2012 11:38:02 -0600
Date: Fri, 9 Nov 2012 11:40:02 -0600
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH 0/4] xfs: fs/xfs/xfs_fs_subr.c die die die
Message-ID: <20121109174001.GV9783@sgi.com>
References: <1352455804-17045-1-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1352455804-17045-1-git-send-email-david@fromorbit.com>
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

On Fri, Nov 09, 2012 at 09:10:00PM +1100, Dave Chinner wrote:
> This patch series replaces all the functions in fs/xfs/xfs_fs_subr.c
> with direct calls to their VFS equivalents. This fixes bugs and
> removes code at the same time.
> 
> I haven't bothered to change the ranges passed to the functions -
> that requires a lot more scrutiny and testing - the ranges have now
> may not be optimal but they are a known factor. The changes have
> passed smoke testing on several different configurations and about 6
> hours of continuous fsx testing, which is what I'd expect seeing as
> I have changed the ranges at all.

Thanks for the quick turnaround on this.  It looks like this will indeed be
appropriate for -stable.  I'd like to have seen Andrew go through the whole
process on this bug.  Maybe next time.  We still have the xfstest to do I
guess.  Putting this series on the 3.8 queue.

Regards,
	Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
