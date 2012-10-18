Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q9IMo0H4218613 for <xfs@oss.sgi.com>; Thu, 18 Oct 2012 17:50:00 -0500
Date: Thu, 18 Oct 2012 17:51:36 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH 0/2] xfs: fix AGF/alloc workqueue deadlock.
Message-ID: <20121018225136.GJ1377@sgi.com>
References: <1349399219-13024-1-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1349399219-13024-1-git-send-email-david@fromorbit.com>
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

Hi Dave,

On Fri, Oct 05, 2012 at 11:06:57AM +1000, Dave Chinner wrote:
> This is a followup from the last conversation with Mark about this
> deadlock. I haven't heard anything in the last coupl eof days, so I
> figured I'd just write the patches that did what I thought is
> needed.
> 
> Basically, the stack switch is only needed for userdata in the
> delayed allocation path, and nowhere else at this point in time. To
> make it so we switch stacks only at this point in time, I introduced
> a flag to pass to xfs_bmapi_write(). This means we don't switch
> stacks during direct IO, unwritten extent conversion or
> preallocation via fallocate/XFS_IOC_RESVSP.
> 
> I then moved the stack switch to xfs_bmapi_allocate(), which is
> where allocation happens. All the allocation calls within a single
> userdata extent allocation occur in this function (both data extent
> and bmap btree blocks), so switching stacks here will ensure that
> only mapping calls that require allocation will have the stack
> switched.
> 
> Comments welcome...

These two patches have been committed to git://oss.sgi.com/xfs/xfs.git, master
and for-next branches.

Regards,
	Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
