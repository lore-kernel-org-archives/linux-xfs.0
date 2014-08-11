Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 096087F57
	for <xfs@oss.sgi.com>; Mon, 11 Aug 2014 16:56:02 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id C359330404E
	for <xfs@oss.sgi.com>; Mon, 11 Aug 2014 14:56:01 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	vQgSHQXrv69PLqSC for <xfs@oss.sgi.com>;
	Mon, 11 Aug 2014 14:55:59 -0700 (PDT)
Date: Tue, 12 Aug 2014 07:55:57 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 0/2] xfs: for-next file collapse bug fixes
Message-ID: <20140811215557.GT20518@dastard>
References: <1407523766-62233-1-git-send-email-bfoster@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1407523766-62233-1-git-send-email-bfoster@redhat.com>
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
To: Brian Foster <bfoster@redhat.com>
Cc: xfs@oss.sgi.com

On Fri, Aug 08, 2014 at 02:49:24PM -0400, Brian Foster wrote:
> Hi all,
> 
> I've seen collapse range fall over during some recent stress testing.
> I'm running fsx and 16 fsstress threads in parallel to reproduce. Note
> that the fsstress workload doesn't need to be on the same fs (I suspect
> a sync() is a trigger). These patches are what has fallen out so far...
> 
> The first patch stems from the fact that the error caused an fs shutdown
> that appeared to be unnecessary. I was initially going to skip the inode
> log on any error, but on closer inspection it seems like we expect to
> abort/shutdown if something has in fact been changed, so this modifies
> the code to reduce that shutdown window. The second patch deals with the
> actual collapse failure by fixing up the locking.
> 
> Note that I still reproduced at least one collapse failure even with
> these fixes, so there could be more at play here with the
> implementation:
> 
> XFS: Internal error XFS_WANT_CORRUPTED_GOTO at line 5535 of file fs/xfs/libxfs/xfs_bmap.c.  Caller xfs_collapse_file_space+0x1af/0x280 [xfs]
> 
> This took significantly longer to reproduce and I don't yet have a feel
> for how reproducible it is in general. In the meantime, these two seemed
> relatively straightforward and incremental...

They look good, but it's too late for the 3.17 merge window.
However, given that we've got other fixes that need to go to 3.17
but are also too late (Chris Mason's direct IO invalidation fixes)
I'll plan these for 3.17-rc2 or so.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
