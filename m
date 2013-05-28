Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id C41B67CBF
	for <xfs@oss.sgi.com>; Tue, 28 May 2013 16:10:15 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id A9709304051
	for <xfs@oss.sgi.com>; Tue, 28 May 2013 14:10:15 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	uT7iBkUgL1MbWY8o for <xfs@oss.sgi.com>;
	Tue, 28 May 2013 14:10:14 -0700 (PDT)
Date: Wed, 29 May 2013 07:10:12 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: 3.10-rc3 xfs mount/recovery failure & ext fsck hang.
Message-ID: <20130528211012.GX29466@dastard>
References: <20130528161230.GA7577@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130528161230.GA7577@redhat.com>
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
To: Dave Jones <davej@redhat.com>, xfs@oss.sgi.com, Linux Kernel <linux-kernel@vger.kernel.org>

On Tue, May 28, 2013 at 12:12:30PM -0400, Dave Jones wrote:
> box crashed, and needed rebooting. On next bootup, when it found the dirty partition,
> xfs chose to spew and then hang instead of replaying the journal and mounting :(
> 
> 	Dave
> 
> [   14.694731] SGI XFS with ACLs, security attributes, realtime, large block/inode numbers, debug enabled
> [   14.722328] XFS (sda2): Mounting Filesystem
> [   14.757801] XFS (sda2): Starting recovery (logdev: internal)
> [   14.782049] XFS: Assertion failed: fs_is_ok, file: fs/xfs/xfs_dir2_data.c, line: 169

A directory block has an entry that is not in the hash index.
Either there's an underlying corruption on disk, or there's an
inconsistency in what has been logged and so an entire change has
not been replayed. Hence the post recovery verification has thrown a
corruption error....

If you haven't already repaired the filesystem, can you send me a
metadump of the filesystem in question?

> [   40.642521] BUG: soft lockup - CPU#0 stuck for 22s! [fsck.ext2:294]

I'm not sure what this has to do with the XFS problem - it's
apparently stuck in invalidate_bh_lrus() walking a CPU mask....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
