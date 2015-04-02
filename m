Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 578A37F59
	for <xfs@oss.sgi.com>; Thu,  2 Apr 2015 17:43:30 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 47449304032
	for <xfs@oss.sgi.com>; Thu,  2 Apr 2015 15:43:27 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	fWgg2nWfT0kOkqFx for <xfs@oss.sgi.com>;
	Thu, 02 Apr 2015 15:43:24 -0700 (PDT)
Date: Fri, 3 Apr 2015 09:43:10 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: FYI: xfstests generic/019 result panic. 4.0.0-rc5
Message-ID: <20150402224310.GG8465@dastard>
References: <87r3s2g3md.fsf@openvz.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <87r3s2g3md.fsf@openvz.org>
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
To: Dmitry Monakhov <dmonakhov@openvz.org>
Cc: xfs@oss.sgi.com

On Thu, Apr 02, 2015 at 02:40:26PM +0300, Dmitry Monakhov wrote:
> 
> Hi I've played with recent kernel 4.0.0-rc5 (AlViro's tree vfs.git/for-next)
> 
> And have found two issues (I do not know whenever it was fixed in
> xfs.git already, so I just want to let you know)
> First one is Panic caused by xfstest generic/019 (disk failure
> simulation test) see attachment
.....
> 
> generic/019		[13:30:32][   17.619593] XFS (vdc): xlog_verify_grant_tail: space > BBTOB(tail_blocks)
> [   41.914283] XFS (vdc): metadata I/O error: block 0x503d1f ("xlog_iodone") error 5 numblks 64

So the test has shut down the filesystem via device pull...

> [   41.917326] XFS (vdc): xfs_bmap_check_leaf_extents: BAD after btree leaves for 6623 extents

in the middle of a bmbt update operation, which aborted in an
inconsistent state in memory due to shutdown...

> [   41.917376] XFS (vdc): Log I/O Error Detected.  Shutting down filesystem
> [   41.917378] XFS (vdc): Please umount the filesystem and rectify the problem(s)
> [   41.918098] fsstress (3180) used greatest stack depth: 11392 bytes left
> [   41.918876] XFS (vdc): metadata I/O error: block 0x503d5f ("xlog_iodone") error 5 numblks 64
> [   41.918966] XFS (vdc): xfs_log_force: error -5 returned.
> [   41.930237] Kernel panic - not syncing: xfs_bmap_check_leaf_extents: CORRUPTED BTREE OR SOMETHING

And debug code detected that inconsistent in-memory state, and threw
out the panic. Production machines won't run this code (it's
CONFIG_XFS_DEBUG=y specific) so they'll just shut down normally.

> Second one is lockdep's complain from splice, It looks like a false-positive one, but still.

No, that's a real one. splice has inverted locks and we've been able
to deadlock it since, well, forever. The recent rework that Al Viro
did removed the old lock inversion problem, and created a new one
w.r.t. to the pipe_lock and filesystem locks. I've reported this to
him previously, but I've never got any response about it...

Thanks for the reports, though, Dmitry.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
