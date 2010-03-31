Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o2VDP9kl022253 for <xfs@oss.sgi.com>; Wed, 31 Mar 2010 08:25:10 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 62A301BCD6C4
	for <xfs@oss.sgi.com>; Wed, 31 Mar 2010 06:26:53 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail17.adl2.internode.on.net
	[150.101.137.102]) by cuda.sgi.com with ESMTP id
	dsa1u8lThDypQVnT for <xfs@oss.sgi.com>;
	Wed, 31 Mar 2010 06:26:53 -0700 (PDT)
Received: from dastard (unverified [121.44.229.111])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	18851309-1927428
	for <xfs@oss.sgi.com>; Wed, 31 Mar 2010 23:56:52 +1030 (CDT)
Date: Thu, 1 Apr 2010 00:26:40 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [RFC] Delayed logging
Message-ID: <20100331132640.GG7671@dastard>
References: <20100315043000.GK4732@dastard>
	<20100315180841.GA21975@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100315180841.GA21975@infradead.org>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Mon, Mar 15, 2010 at 02:08:41PM -0400, Christoph Hellwig wrote:
> On Mon, Mar 15, 2010 at 03:30:00PM +1100, Dave Chinner wrote:
> > 	- occasional recovery failure with recovery reading an inode
> > 	  buffer that does not contain inodes. Cause unknown, tends
> > 	  to be reproduced by xfsqa test 121 semi-reliably. Needs
> > 	  further analysis and fixing. May already be fixed with a
> > 	  recent fix to commit record synchronisation.
> 
> I just saw a corrupted inode buffer during log recovery in 087, even
> without the delaylog mount option.  It's however not easily
> reproducible.

Ok, I got reliable reproduction of this problem with delayed logging
on a single CPU VM, and I've been able to understand the problem
that delayed logging it triggering..

It appears to be related to the way recover deals with logging inode
buffers.  We log inode changes in buffers in two different places -
inode chunk allocation (i.e.  allocation of chunks of 64 inodes) and
again when recording changes to the inode unlinked lists.

When we allocate inodes, the buffer is marked in memory as an inode
alloc buffer, but this is not recorded in the buf log format item
that is recorded in the log.

When we update the unlinked list pointer for an inode, we mark the
buffer as an inode buffer, and this is recorded in the buf log
format item and written to the log. The list pointer is only updated
if there is more than one inode in the unlinked list bucket, hence
we need a certain number of allocations and unlinks to occur in
the same delayed logging transaction window to trigger this.

Unsurprisingly, the reproducer (test 121) is specifically setting up
the unlinked lists to have more than one inode in them and then
triggering shutdown and recovery. i.e. it is pretty much
specifically exercising this problem case.

In the inode alloc case, recovery of all the newly stamped inodes in
the buffer takes place via the regular buffer recovery code.
However, buffers that are marked as "inode buffers" and contain
unlinked list pointer updates go through a different buffer recovery
path that only updates the unlinked list pointers.

Hence if we get the situation where a buffer in a transaction
contains both inode allocation data and unlinked list manipulation,
the inode allocation portion of the buffer does not get replayed.

Because the buffer has not been cancelled, inode changes are then
replayed, which requires the buffer to be read in. At this point,
the buffer contains nothing but:

xfs_db> daddr 0x60
xfs_db> p
000: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
020: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
040: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
060: ffffffff 00000000 00000000 00000000 00000000 00000000 00000000 00000000
080: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
0a0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
0c0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
0e0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000

A NULL unlinked list pointer, so the magic number check fails and
recovery aborts.

Now, this should only be a problem for delayed logging because there
is no way the current code can put an unlink operation in the same
transaction as an allocation operation. However, it sounds like it
is happening for current code as well. I've got some wild-ass
theories about how it might occur, but nothing concrete yet. I need
to be able to reproduce it without delayed logging, but I haven't
been able to do that yet....

I think the problem is easy to fix by pushing the inode alloc buffer
status into the log and only doing the inode buffer specific replay
if (INODE_BUF | INODE_ALLOC_BUF) == INODE_BUF. Once written into the
log *once*, the INODE_ALLOC_BUF flag needs to be removed from the
blf so that subsequent inode unlinked list pointer updates do not
overwrite inode state. I'll code this up and test it out
tomorrow...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
