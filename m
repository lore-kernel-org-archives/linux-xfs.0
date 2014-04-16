Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 56FC67F5E
	for <xfs@oss.sgi.com>; Wed, 16 Apr 2014 01:25:24 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id DA077AC001
	for <xfs@oss.sgi.com>; Tue, 15 Apr 2014 23:25:23 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	3O29evQlmPHYApkf for <xfs@oss.sgi.com>;
	Tue, 15 Apr 2014 23:25:22 -0700 (PDT)
Date: Wed, 16 Apr 2014 16:25:20 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 16/19] VFS: use GFP_NOFS rather than GFP_KERNEL in
	__d_alloc.
Message-ID: <20140416062520.GG15995@dastard>
References: <20140416033623.10604.69237.stgit@notabene.brown>
	<20140416040337.10604.61837.stgit@notabene.brown>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140416040337.10604.61837.stgit@notabene.brown>
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
To: NeilBrown <neilb@suse.de>
Cc: linux-mm@kvack.org, linux-nfs@vger.kernel.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

On Wed, Apr 16, 2014 at 02:03:37PM +1000, NeilBrown wrote:
> __d_alloc can be called with i_mutex held, so it is safer to
> use GFP_NOFS.
> 
> lockdep reports this can deadlock when loop-back NFS is in use,
> as nfsd may be required to write out for reclaim, and nfsd certainly
> takes i_mutex.

But not the same i_mutex as is currently held. To me, this seems
like a false positive? If you are holding the i_mutex on an inode,
then you have a reference to the inode and hence memory reclaim
won't ever take the i_mutex on that inode.

FWIW, this sort of false positive was a long stabding problem for
XFS - we managed to get rid of most of the false positives like this
by ensuring that only the ilock is taken within memory reclaim and
memory reclaim can't be entered while we hold the ilock.

You can't do that with the i_mutex, though....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
