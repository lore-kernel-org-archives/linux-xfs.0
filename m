Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id E97BF7F47
	for <xfs@oss.sgi.com>; Thu, 23 Apr 2015 12:15:16 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id CA3C8304039
	for <xfs@oss.sgi.com>; Thu, 23 Apr 2015 10:15:13 -0700 (PDT)
Received: from g4t3425.houston.hp.com (g4t3425.houston.hp.com [15.201.208.53])
	by cuda.sgi.com with ESMTP id AlLlaUEIc9tk1iwO (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 23 Apr 2015 10:15:09 -0700 (PDT)
Message-ID: <55392880.30301@hp.com>
Date: Thu, 23 Apr 2015 13:14:40 -0400
From: Waiman Long <waiman.long@hp.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfs: call xfs_idestroy_fork() in xfs_ilock() critical
	section
References: <1429724021-7675-1-git-send-email-Waiman.Long@hp.com>
	<20150422231758.GQ21261@dastard>
In-Reply-To: <20150422231758.GQ21261@dastard>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com

On 04/22/2015 07:17 PM, Dave Chinner wrote:
> -- 
> Dave Chinner
> david@fromorbit.com
>
> xfs: xfs_attr_inactive leaves inconsistent attr fork state behind
>
> From: Dave Chinner<dchinner@redhat.com>
>
> xfs_attr_inactive() is supposed to clean up the attribute fork when
> the inode is being freed. While it removes attribute fork extents,
> it completely ignores attributes in local format, which means that
> there can still be active attributes on the inode after
> xfs_attr_inactive() has run.
>
> This leads to problems with concurrent inode writeback - the in-core
> inode attribute fork is removed without locking on the assumption
> that nothing will be attempting to access the attribute fork after a
> call to xfs_attr_inactive() because it isn't supposed to exist on
> disk any more.
>
> To fix this, make xfs_attr_inactive() completely remove all traces
> of the attribute fork from the inode, regardless of it's state.
> Further, also remove the in-core attribute fork structure safely so
> that there is nothing further that needs to be done by callers to
> clean up the attribute fork. This means we can remove the in-core
> and on-disk attribute forks atomically.
>
> Also, on error simply remove the in-memory attribute fork. There's
> nothing that can be done with it once we have failed to remove the
> on-disk attribute fork, so we may as well just blow it away here
> anyway.
>
> cc:<stable@vger.kernel.org>  # 3.12 to 4.0
> Reported-by: Waiman Long<waiman.long@hp.com>
> Signed-off-by: Dave Chinner<dchinner@redhat.com>
> ---
>   fs/xfs/libxfs/xfs_attr_leaf.c |  2 +-
>   fs/xfs/libxfs/xfs_attr_leaf.h |  2 +-
>   fs/xfs/xfs_attr_inactive.c    | 81 ++++++++++++++++++++++++++-----------------
>   fs/xfs/xfs_inode.c            | 12 +++----
>   4 files changed, 55 insertions(+), 42 deletions(-)

Thanks for figuring out a better way to fix the underlying problem. I 
tested it in my test machine and it did fix the errors that I had seen 
in my test case.

Tested-by: Waiman Long<Waiman.Long@hp.com>

Cheers,
Longman

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
