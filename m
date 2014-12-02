Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 440947F56
	for <xfs@oss.sgi.com>; Tue,  2 Dec 2014 15:02:25 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 32AF4304039
	for <xfs@oss.sgi.com>; Tue,  2 Dec 2014 13:02:22 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	VrjfjNZxQOrcuqhR for <xfs@oss.sgi.com>;
	Tue, 02 Dec 2014 13:02:20 -0800 (PST)
Date: Wed, 3 Dec 2014 08:02:04 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: active inodes stat is broken
Message-ID: <20141202210204.GA18131@dastard>
References: <1417473270-17467-1-git-send-email-david@fromorbit.com>
	<547DC411.3090202@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <547DC411.3090202@sgi.com>
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
To: Mark Tinguely <tinguely@sgi.com>
Cc: xfs@oss.sgi.com

On Tue, Dec 02, 2014 at 07:52:17AM -0600, Mark Tinguely wrote:
> On 12/01/14 16:34, Dave Chinner wrote:
> >From: Dave Chinner<dchinner@redhat.com>
> >
> >vn_active only ever gets decremented, so it has a very large
> >negative number.  Make it track the inode count we currently have
> >allocated properly so we can easily track the size of the inode
> >cache via tools like PCP.
> >
> >Signed-off-by: Dave Chinner<dchinner@redhat.com>
> >---
> >  fs/xfs/xfs_icache.c | 3 +++
> >  fs/xfs/xfs_super.c  | 1 -
> >  2 files changed, 3 insertions(+), 1 deletion(-)
> >
> >diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
> >index 92ca910..8bc3d78 100644
> >--- a/fs/xfs/xfs_icache.c
> >+++ b/fs/xfs/xfs_icache.c
> >@@ -128,6 +128,7 @@ xfs_inode_free(
> >  	/* asserts to verify all state is correct here */
> >  	ASSERT(atomic_read(&ip->i_pincount) == 0);
> >  	ASSERT(!xfs_isiflocked(ip));
> >+	XFS_STATS_DEC(vn_active);
> >
> >  	call_rcu(&VFS_I(ip)->i_rcu, xfs_inode_free_callback);
> >  }
> 
> Would the inode allocated and freed in xfs_recover_inode_owner_change()
> cause this the count to go negative?

Good catch - it will. Recovering swap extent operations is pretty
rare, so I wouldn't have noticed an off-by-one-or-two on a normal
system where there are several thousand allocated and cached inodes
even at idle. I'll fix it.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
