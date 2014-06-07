Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id D2DB47F3F
	for <xfs@oss.sgi.com>; Fri,  6 Jun 2014 19:18:39 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id B1D618F8040
	for <xfs@oss.sgi.com>; Fri,  6 Jun 2014 17:18:36 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	e8jRBEGdOE1kJLMe for <xfs@oss.sgi.com>;
	Fri, 06 Jun 2014 17:18:34 -0700 (PDT)
Date: Sat, 7 Jun 2014 10:18:19 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [RFC PATCH 1/1] cleanup: use bool as return type for
	rwsem_is_locked
Message-ID: <20140607001819.GE4453@dastard>
References: <5390D7E1.7060606@gatech.edu> <5391FFFD.1060901@gatech.edu>
	<53920446.7060505@gatech.edu>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <53920446.7060505@gatech.edu>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Pranith Kumar <pranith@gatech.edu>
Cc: peterz@infradead.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, mingo@redhat.com, davidlohr@hp.com, tim.c.chen@linux.intel.com

On Fri, Jun 06, 2014 at 02:11:18PM -0400, Pranith Kumar wrote:
> On 06/06/2014 01:53 PM, Pranith Kumar wrote:
> > On Fri, Jun 6, 2014 at 3:35 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> >>
> >> Now in general, I don't particularly like such superfluous changes, so
> >> unless you can show that GCC actually generates better code, I'd prefer
> >> to keep things as they are.
> > 
> > Fixed and checked the assembly. It saves us 2 bytes of code, not much. I am not sure if that is worth it :(
> > 
> > use bool as the return type for rwsem_is_locked() instead of int
> > 
> > Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>
....

Makes sense to me.

> I observed one other user of rwsem_is_locked() in xfs, change accordingly
> 
> Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>
> ---
>  fs/xfs/xfs_inode.c |    2 +-
>  fs/xfs/xfs_inode.h |    2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index 768087b..9047eda 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -285,7 +285,7 @@ xfs_ilock_demote(
>  }
>  
>  #if defined(DEBUG) || defined(XFS_WARN)
> -int
> +bool
>  xfs_isilocked(
>  	xfs_inode_t		*ip,
>  	uint			lock_flags)

If you are going to change the return type to bool, then you should
also remove the manual "!!" conversions to a boolean return and let
the compiler do it in the most optimal way.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
