Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 5BC3E29E05
	for <xfs@oss.sgi.com>; Mon, 22 Apr 2013 18:31:07 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id DF3B3AC002
	for <xfs@oss.sgi.com>; Mon, 22 Apr 2013 16:31:03 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	JfhuCSypMTMucT2u for <xfs@oss.sgi.com>;
	Mon, 22 Apr 2013 16:31:02 -0700 (PDT)
Date: Tue, 23 Apr 2013 09:30:33 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: shutdown filesystem if xfs_perag_get fails
Message-ID: <20130422233033.GK30622@dastard>
References: <20130419204102.736961610@sgi.com>
	<20130421174107.007313126@sgi.com> <5174603A.8030208@sandeen.net>
	<51753EDE.6000301@sgi.com> <51754A13.5000808@sandeen.net>
	<5175532B.3050509@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <5175532B.3050509@sgi.com>
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
Cc: Eric Sandeen <sandeen@sandeen.net>, xfs@oss.sgi.com

On Mon, Apr 22, 2013 at 10:11:39AM -0500, Mark Tinguely wrote:
>  #6 [ffff880135603980] _xfs_buf_find at ffffffffa01a7fef [xfs]
>  #7 [ffff8801356039f0] xfs_buf_get at ffffffffa01a824a [xfs]
>  #8 [ffff880135603a30] xfs_buf_read at ffffffffa01a83a4 [xfs]
>  #9 [ffff880135603a60] xlog_recover_inode_pass2 at ffffffffa0193629 [xfs]

So it's the same problem as this bug fix addresses:

commit 10616b806d1d7835b1d23b8d75ef638f92cb98b6
Author: Dave Chinner <dchinner@redhat.com>
Date:   Mon Jan 21 23:53:52 2013 +1100

    xfs: fix _xfs_buf_find oops on blocks beyond the filesystem end
    
    When _xfs_buf_find is passed an out of range address, it will fail
    to find a relevant struct xfs_perag and oops with a null
    dereference. This can happen when trying to walk a filesystem with a
    metadata inode that has a partially corrupted extent map (i.e. the
    block number returned is corrupt, but is otherwise intact) and we
    try to read from the corrupted block address.
    
    In this case, just fail the lookup. If it is readahead being issued,
    it will simply not be done, but if it is real read that fails we
    will get an error being reported.  Ideally this case should result
    in an EFSCORRUPTED error being reported, but we cannot return an
    error through xfs_buf_read() or xfs_buf_get() so this lookup failure
    may result in ENOMEM or EIO errors being reported instead.
    
    Signed-off-by: Dave Chinner <dchinner@redhat.com>
    Reviewed-by: Brian Foster <bfoster@redhat.com>
    Reviewed-by: Ben Myers <bpm@sgi.com>
    Signed-off-by: Ben Myers <bpm@sgi.com>

> The recovery value is bad and is a problem on its own, but XFS does
> not verify the validity of ag number when doing a xfs_perag_get().

Right, that's what the above fix does, but it can't be done on older
kernels because grwofs relies on being able to get buffers beyond
the existing filesystem limits...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
