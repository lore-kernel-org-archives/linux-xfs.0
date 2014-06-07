Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 1D90C7F3F
	for <xfs@oss.sgi.com>; Fri,  6 Jun 2014 21:39:36 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 0BA7C8F8037
	for <xfs@oss.sgi.com>; Fri,  6 Jun 2014 19:39:35 -0700 (PDT)
Received: from smtprelay.hostedemail.com (smtprelay0133.hostedemail.com
	[216.40.44.133]) by cuda.sgi.com with ESMTP id wDGt5M7xq2wiwmXp
	for <xfs@oss.sgi.com>; Fri, 06 Jun 2014 19:39:34 -0700 (PDT)
Message-ID: <1402108770.25112.5.camel@joe-AO725>
Subject: Re: [RFC PATCH 1/1] cleanup: use bool as return type for
	rwsem_is_locked
From: Joe Perches <joe@perches.com>
Date: Fri, 06 Jun 2014 19:39:30 -0700
In-Reply-To: <53926DC1.4050304@gmail.com>
References: <5390D7E1.7060606@gatech.edu> <5391FFFD.1060901@gatech.edu>
	<53920446.7060505@gatech.edu> <20140607001819.GE4453@dastard>
	<53926406.4020200@gmail.com> <53926DC1.4050304@gmail.com>
Mime-Version: 1.0
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
To: Pranith Kumar <bobby.prani@gmail.com>
Cc: peterz@infradead.org, tim.c.chen@linux.intel.com, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, mingo@redhat.com, davidlohr@hp.com, Pranith Kumar <pranith@gatech.edu>

On Fri, 2014-06-06 at 21:41 -0400, Pranith Kumar wrote:
> On 06/06/2014 08:59 PM, Pranith Kumar wrote:
> > On 06/06/2014 08:18 PM, Dave Chinner wrote:
> >> If you are going to change the return type to bool, then you should
> >> also remove the manual "!!" conversions to a boolean return and let
> >> the compiler do it in the most optimal way.
> > Agreed, please find patch below:
> Simplify the "!!" condition. This is much simpler. :)
[]
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c

> @@ -285,25 +285,25 @@ xfs_ilock_demote(
>  }
>  
>  #if defined(DEBUG) || defined(XFS_WARN)
> -int
> +bool
>  xfs_isilocked(
>  	xfs_inode_t		*ip,
>  	uint			lock_flags)
>  {
>  	if (lock_flags & (XFS_ILOCK_EXCL|XFS_ILOCK_SHARED)) {
>  		if (!(lock_flags & XFS_ILOCK_SHARED))
> -			return !!ip->i_lock.mr_writer;
> +			return (ip->i_lock.mr_writer != 0);

simpler still would be just removing the !! completely.
I presume in no case would it make an actual difference
in emitted code.

ie:
			return ip->i_lock.mr_writer;


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
