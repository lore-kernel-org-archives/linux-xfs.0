Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q9OKsJVl054795 for <xfs@oss.sgi.com>; Wed, 24 Oct 2012 15:54:19 -0500
Received: from mail-vb0-f53.google.com (mail-vb0-f53.google.com
	[209.85.212.53]) by cuda.sgi.com with ESMTP id 1DBXtONGhyDTUAUQ
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 24 Oct 2012 13:56:03 -0700 (PDT)
Received: by mail-vb0-f53.google.com with SMTP id fc21so1080669vbb.26
	for <xfs@oss.sgi.com>; Wed, 24 Oct 2012 13:56:03 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <cover.1348639531.git.rprabhu@wnohang.net>
References: <cover.1348639531.git.rprabhu@wnohang.net>
Date: Thu, 25 Oct 2012 02:26:02 +0530
Message-ID: <CAEtq3tN20oZ6NjT37tXo8XYW=N=AFTdsZxWTuD681RPbQeS_iw@mail.gmail.com>
Subject: Re: [PATCH v3 0/3] Print when ENOSPC due to lack of inodes.
From: Raghavendra Prabhu <raghu.prabhu13@gmail.com>
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
To: xfs@oss.sgi.com, Dave Chinner <david@fromorbit.com>

Hi,

Checking back on this, whether it has been reviewed and if so, any comments.

On Wed, Sep 26, 2012 at 12:26 PM,  <raghu.prabhu13@gmail.com> wrote:
> From: Raghavendra D Prabhu <rprabhu@wnohang.net>
>
> Currently, when there are no free inodes left / free space to allocate them (usually
> without inode64), there is no indication anywhere of this case, making it harder
> to diagnose this case.
>
> Hence, this series prints the causes/reasons to kernel log in a ratelimited
> manner, when such a situation arises.
>
> Regarding why it is printed at callee location instead at caller, it gives
> greater granularity in expressing the precise reason and give more details, and
> also some along the path are not ENOSPC (such in xfs_ialloc where ialloc_context is not NULL but
> ino is) along with the fact that it (xfs_ialloc) is called at multiple sites, so to avoid duplication.
>
> Version 1: Initial series.
> Version 2: Added ratelimited printing to xfs_message and used that.
> Version 3: Kept the logic intact in few places, fixed the column requirement.
>
> Raghavendra D Prabhu (3):
>   xfs: Add ratelimited printk for different alert levels
>   xfs: Print error when xfs_ialloc_ag_select fails to find continuous
>     free space.
>   xfs: Print error when unable to allocate inodes or out of free
>     inodes.
>
>  fs/xfs/xfs_ialloc.c  | 31 ++++++++++++++++++++++++++++---
>  fs/xfs/xfs_linux.h   |  1 +
>  fs/xfs/xfs_message.h | 26 ++++++++++++++++++++++++++
>  3 files changed, 55 insertions(+), 3 deletions(-)
>
> --
> 1.7.12.1
>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
