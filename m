Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id D35087CBF
	for <xfs@oss.sgi.com>; Tue, 28 May 2013 16:15:54 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 5E1F0AC00A
	for <xfs@oss.sgi.com>; Tue, 28 May 2013 14:15:51 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 54koVlBZfPjxs43i for
	<xfs@oss.sgi.com>; Tue, 28 May 2013 14:15:50 -0700 (PDT)
Date: Tue, 28 May 2013 17:15:44 -0400
From: Dave Jones <davej@redhat.com>
Subject: Re: 3.10-rc3 xfs mount/recovery failure & ext fsck hang.
Message-ID: <20130528211544.GB24342@redhat.com>
References: <20130528161230.GA7577@redhat.com> <20130528211012.GX29466@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130528211012.GX29466@dastard>
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
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com

On Wed, May 29, 2013 at 07:10:12AM +1000, Dave Chinner wrote:
 > On Tue, May 28, 2013 at 12:12:30PM -0400, Dave Jones wrote:
 > > box crashed, and needed rebooting. On next bootup, when it found the dirty partition,
 > > xfs chose to spew and then hang instead of replaying the journal and mounting :(
 > > 
 > > [   14.694731] SGI XFS with ACLs, security attributes, realtime, large block/inode numbers, debug enabled
 > > [   14.722328] XFS (sda2): Mounting Filesystem
 > > [   14.757801] XFS (sda2): Starting recovery (logdev: internal)
 > > [   14.782049] XFS: Assertion failed: fs_is_ok, file: fs/xfs/xfs_dir2_data.c, line: 169
 > 
 > A directory block has an entry that is not in the hash index.
 > Either there's an underlying corruption on disk, or there's an
 > inconsistency in what has been logged and so an entire change has
 > not been replayed. Hence the post recovery verification has thrown a
 > corruption error....
 > 
 > If you haven't already repaired the filesystem, can you send me a
 > metadump of the filesystem in question?

Sorry, too late. If I can repro, I'll do so next time.
FYI, I ran xfs_repair and it just hung. Wouldn't even answer ctrl-c.
Rebooted, and then it mounted and recovered just fine!
 
 > > [   40.642521] BUG: soft lockup - CPU#0 stuck for 22s! [fsck.ext2:294]
 > 
 > I'm not sure what this has to do with the XFS problem - it's
 > apparently stuck in invalidate_bh_lrus() walking a CPU mask....

there for completion, it was sandwiched between the other xfs bits :)

	Dave

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
