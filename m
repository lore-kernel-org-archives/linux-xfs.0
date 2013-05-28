Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 055D37CBF
	for <xfs@oss.sgi.com>; Tue, 28 May 2013 16:32:54 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id D592C8F8049
	for <xfs@oss.sgi.com>; Tue, 28 May 2013 14:32:53 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	X4fDy8fwYw855S37 for <xfs@oss.sgi.com>;
	Tue, 28 May 2013 14:32:52 -0700 (PDT)
Date: Wed, 29 May 2013 07:32:48 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: 3.10-rc3 xfs mount/recovery failure & ext fsck hang.
Message-ID: <20130528213248.GC29338@dastard>
References: <20130528161230.GA7577@redhat.com> <20130528211012.GX29466@dastard>
	<20130528211544.GB24342@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130528211544.GB24342@redhat.com>
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

On Tue, May 28, 2013 at 05:15:44PM -0400, Dave Jones wrote:
> On Wed, May 29, 2013 at 07:10:12AM +1000, Dave Chinner wrote:
>  > On Tue, May 28, 2013 at 12:12:30PM -0400, Dave Jones wrote:
>  > > box crashed, and needed rebooting. On next bootup, when it found the dirty partition,
>  > > xfs chose to spew and then hang instead of replaying the journal and mounting :(
>  > > 
>  > > [   14.694731] SGI XFS with ACLs, security attributes, realtime, large block/inode numbers, debug enabled
>  > > [   14.722328] XFS (sda2): Mounting Filesystem
>  > > [   14.757801] XFS (sda2): Starting recovery (logdev: internal)
>  > > [   14.782049] XFS: Assertion failed: fs_is_ok, file: fs/xfs/xfs_dir2_data.c, line: 169
>  > 
>  > A directory block has an entry that is not in the hash index.
>  > Either there's an underlying corruption on disk, or there's an
>  > inconsistency in what has been logged and so an entire change has
>  > not been replayed. Hence the post recovery verification has thrown a
>  > corruption error....
>  > 
>  > If you haven't already repaired the filesystem, can you send me a
>  > metadump of the filesystem in question?
> 
> Sorry, too late. If I can repro, I'll do so next time.
> FYI, I ran xfs_repair and it just hung. Wouldn't even answer ctrl-c.
> Rebooted, and then it mounted and recovered just fine!

Strange. I can't think of any reason outside a kernel problem for
xfs_repair going into an uninterruptible sleep. Did it happen after
the repair completed (i.e. after phase 7)? If so, then closing the
block device might have tripped the same problem that fsck.ext2
hit....

>  > > [   40.642521] BUG: soft lockup - CPU#0 stuck for 22s! [fsck.ext2:294]
>  > 
>  > I'm not sure what this has to do with the XFS problem - it's
>  > apparently stuck in invalidate_bh_lrus() walking a CPU mask....
> 
> there for completion, it was sandwiched between the other xfs bits :)

*nod*

You never know what might be relevant to the problem :)

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
