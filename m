Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q9UIaWI8065160 for <xfs@oss.sgi.com>; Tue, 30 Oct 2012 13:36:32 -0500
Received: from whiskey.americas.sgi.com (eagdhcp-232-197.americas.sgi.com
	[128.162.232.197])
	by relay2.corp.sgi.com (Postfix) with ESMTP id CA35230406A
	for <xfs@oss.sgi.com>; Tue, 30 Oct 2012 11:38:19 -0700 (PDT)
Date: Tue, 30 Oct 2012 09:59:19 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH v3 0/3] Print when ENOSPC due to lack of inodes.
Message-ID: <20121030145919.GJ31970@sgi.com>
References: <cover.1348639531.git.rprabhu@wnohang.net>
	<CAEtq3tN20oZ6NjT37tXo8XYW=N=AFTdsZxWTuD681RPbQeS_iw@mail.gmail.com>
	<508A8DC3.3020500@sgi.com> <20121028220516.GA4353@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20121028220516.GA4353@dastard>
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
Cc: Rich Johnston <rjohnston@sgi.com>, xfs@oss.sgi.com

Hi Dave,

On Mon, Oct 29, 2012 at 09:05:16AM +1100, Dave Chinner wrote:
> On Fri, Oct 26, 2012 at 08:18:59AM -0500, Rich Johnston wrote:
> > On 10/24/2012 03:56 PM, Raghavendra Prabhu wrote:
> > >Hi,
> > >
> > >Checking back on this, whether it has been reviewed and if so, any comments.
> > >
> > >On Wed, Sep 26, 2012 at 12:26 PM,  <raghu.prabhu13@gmail.com> wrote:
> > >>From: Raghavendra D Prabhu <rprabhu@wnohang.net>
> > >>
> > >>Currently, when there are no free inodes left / free space to allocate them (usually
> > >>without inode64), there is no indication anywhere of this case, making it harder
> > >>to diagnose this case.
> > >>
> > >>Hence, this series prints the causes/reasons to kernel log in a ratelimited
> > >>manner, when such a situation arises.
> > >>
> > >>Regarding why it is printed at callee location instead at caller, it gives
> > >>greater granularity in expressing the precise reason and give more details, and
> > >>also some along the path are not ENOSPC (such in xfs_ialloc where ialloc_context is not NULL but
> > >>ino is) along with the fact that it (xfs_ialloc) is called at multiple sites, so to avoid duplication.
> > >>
> > >>Version 1: Initial series.
> > >>Version 2: Added ratelimited printing to xfs_message and used that.
> > >>Version 3: Kept the logic intact in few places, fixed the column requirement.
> > >>
> > >>Raghavendra D Prabhu (3):
> > >>   xfs: Add ratelimited printk for different alert levels
> > >>   xfs: Print error when xfs_ialloc_ag_select fails to find continuous
> > >>     free space.
> > >>   xfs: Print error when unable to allocate inodes or out of free
> > >>     inodes.
> > >>
> > >>  fs/xfs/xfs_ialloc.c  | 31 ++++++++++++++++++++++++++++---
> > >>  fs/xfs/xfs_linux.h   |  1 +
> > >>  fs/xfs/xfs_message.h | 26 ++++++++++++++++++++++++++
> > >>  3 files changed, 55 insertions(+), 3 deletions(-)
> > >>
> > >>--
> > >>1.7.12.1
> > >>
> > >
> > >_______________________________________________
> > >xfs mailing list
> > >xfs@oss.sgi.com
> > >http://oss.sgi.com/mailman/listinfo/xfs
> > >
> > 
> > Ben,
> > 
> > When you have a chance can you pull this series in.  I have tested
> > it and it looks good.
> 
> No, not yet. It doesn't address the comments I made in a previous
> iteration.

Ah, ok.  We'll wait for Ragavendra to address your comments.

Regards,
Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
