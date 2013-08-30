Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 1987B7F3F
	for <xfs@oss.sgi.com>; Fri, 30 Aug 2013 13:15:24 -0500 (CDT)
Date: Fri, 30 Aug 2013 13:15:20 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH] xfs: inode buffers may not be valid during recovery
	readahead
Message-ID: <20130830181520.GD1935@sgi.com>
References: <1377567577-24312-1-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1377567577-24312-1-git-send-email-david@fromorbit.com>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

Dave,

On Tue, Aug 27, 2013 at 11:39:37AM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> CRC enabled filesystems fail log recovery with 100% reliability on
> xfstests xfs/085 with the following failure:

Unfortunately I have not been able to hit this one... not sure why.

> XFS (vdb): Mounting Filesystem
> XFS (vdb): Starting recovery (logdev: internal)
> XFS (vdb): Corruption detected. Unmount and run xfs_repair
> XFS (vdb): bad inode magic/vsn daddr 144 #0 (magic=0)
> XFS: Assertion failed: 0, file: fs/xfs/xfs_inode_buf.c, line: 95
> 
> The problem is that the inode buffer has not been recovered before
> the readahead on the inode buffer is issued. The checkpoint being
> recovered actually allocates the inode chunk we are doing readahead
> from, so what comes from disk during readahead is essentially
> random and the verifier barfs on it.
> 
> This inode buffer readahead problem affects non-crc filesystems,
> too, but xfstests does not trigger it at all on such
> configurations....
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

I've been mulling this one over for a bit, and I'm not quite sure this
is correct:

My feeling is that in light of commit 9222a9cf, if we do take part of a
buffer back in time, the write verifier should fail.  I think for a v2
inode the read and write verifiers should both be disabled for the
duration of recovery.  For v3 inodes, I suspect the current situation
where we do use write verifiers is broken in the same way, at least
until we pull in 'xfs: prevent transient corrupt states during log
recovery', which, as you say, won't fix the problem for the v2 inode.

I'll pull this in and send a patch to that effect.

Reviewed-by: Ben Myers <bpm@sgi.com>

Regards,
	Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
