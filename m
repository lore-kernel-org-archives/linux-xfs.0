Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 61A437F3F
	for <xfs@oss.sgi.com>; Wed, 16 Apr 2014 20:27:45 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id E3FBEAC001
	for <xfs@oss.sgi.com>; Wed, 16 Apr 2014 18:27:44 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	r1Bm1MFHDn4eVqaD for <xfs@oss.sgi.com>;
	Wed, 16 Apr 2014 18:27:42 -0700 (PDT)
Date: Thu, 17 Apr 2014 11:27:39 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH/RFC 00/19] Support loop-back NFS mounts
Message-ID: <20140417012739.GU15995@dastard>
References: <20140416033623.10604.69237.stgit@notabene.brown>
	<20140416104207.75b044e8@tlielax.poochiereds.net>
	<20140417102048.2fc8275c@notabene.brown>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140417102048.2fc8275c@notabene.brown>
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
Cc: linux-nfs@vger.kernel.org, Jeff Layton <jlayton@redhat.com>, Peter Zijlstra <peterz@infradead.org>, netdev@vger.kernel.org, Ming Lei <ming.lei@canonical.com>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, linux-mm@kvack.org, Ingo Molnar <mingo@redhat.com>

On Thu, Apr 17, 2014 at 10:20:48AM +1000, NeilBrown wrote:
> A good example is the deadlock with the flush-* threads.
> flush-* will lock a page, and  then call ->writepage.  If ->writepage
> allocates memory it can enter reclaim, call ->releasepage on NFS, and block
> waiting for a COMMIT to complete.
> The COMMIT might already be running, performing fsync on that same file that
> flush-* is flushing.  It locks each page in turn.  When it  gets to the page
> that flush-* has locked, it will deadlock.

It's nfs_release_page() again....

> In general, if nfsd is allowed to block on local filesystem, and local
> filesystem is allowed to block on NFS, then a deadlock can happen.
> We would need a clear hierarchy
> 
>    __GFP_NETFS > __GFP_FS > __GFP_IO
> 
> for it to work.  I'm not sure the extra level really helps a lot and it would
> be a lot of churn.

I think you are looking at this the wrong way - it's not the other
filesystems that have to avoid memory reclaim recursion, it's the
NFS client mount that is on loopback that needs to avoid recursion.

IMO, the fix should be that the NFS client cannot block on messages sent to the NFSD
on the same host during memory reclaim. That is, nfs_release_page()
cannot send commit messages to the server if the server is on
localhost. Instead, it just tells memory reclaim that it can't
reclaim that page.

If nfs_release_page() no longer blocks in memory reclaim, and all
these nfsd-gets-blocked-in-GFP_KERNEL-memory-allocation recursion
problems go away. Do the same for all the other memory reclaim
operations in the NFS client, and you've got a solution that should
work without needing to walk all over the rest of the kernel....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
