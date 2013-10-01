Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 264707F56
	for <xfs@oss.sgi.com>; Tue,  1 Oct 2013 05:57:53 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id A5917AC00D
	for <xfs@oss.sgi.com>; Tue,  1 Oct 2013 03:57:52 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	sAEJF9ewJ4hJu5sa for <xfs@oss.sgi.com>;
	Tue, 01 Oct 2013 03:57:50 -0700 (PDT)
Date: Tue, 1 Oct 2013 20:57:45 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 3/4] xfs: xfs_remove deadlocks due to inverted AGF vs AGI
	lock ordering
Message-ID: <20131001105745.GP12541@dastard>
References: <1380497826-13474-1-git-send-email-david@fromorbit.com>
	<1380497826-13474-4-git-send-email-david@fromorbit.com>
	<20130930221449.GP1935@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130930221449.GP1935@sgi.com>
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
To: Ben Myers <bpm@sgi.com>
Cc: xfs@oss.sgi.com

On Mon, Sep 30, 2013 at 05:14:49PM -0500, Ben Myers wrote:
> Hi Dave,
> 
> On Mon, Sep 30, 2013 at 09:37:05AM +1000, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > Removing an inode from the namespace involves removing the directory
> > entry and dropping the link count on the inode. Removing the
> > directory entry can result in locking an AGF (directory blocks were
> > freed) and removing a link count can result in placing the inode on
> > an unlinked list which results in locking an AGI.
> > 
> > The big problem here is that we have an ordering constraint on AGF
> > and AGI locking - inode allocation locks the AGI, then can allocate
> > a new extent for new inodes, locking the AGF after the AGI.
> > Similarly, freeing the inode removes the inode from the unlinked
> > list, requiring that we lock the AGI first, and then freeing the
> > inode can result in an inode chunk being freed and hence freeing
> > disk space requiring that we lock an AGF.
> > 
> > Hence the ordering that is imposed by other parts of the code is AGI
> > before AGF. This means we cannot remove the directory entry before
> > we drop the inode reference count and put it on the unlinked list as
> > this results in a lock order of AGF then AGI, and this can deadlock
> > against inode allocation and freeing. Therefore we must drop the
> > link counts before we remove the directory entry.
> > 
> > This is still safe from a transactional point of view - it is not
> > until we get to xfs_bmap_finish() that we have the possibility of
> > multiple transactions in this operation. Hence as long as we remove
> > the directory entry and drop the link count in the first transaction
> > of the remove operation, there are no transactional constraints on
> > the ordering here.
> > 
> > Change the ordering of the operations in the xfs_remove() function
> > to align the ordering of AGI and AGF locking to match that of the
> > rest of the code.
> > 
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> 
> Hmmm..  I'm not quite comfortable with this one yet...  It'll probably be
> better after some more review.  Did you happen to have a test case to go with
> this?

Two test cases.

The first that I saw involved a 100TB filesystem and 16-way creates
running concurrently with 16-way unlinks, as reported here:

http://oss.sgi.com/archives/xfs/2013-09/msg00359.html

That's not reliable, though - in general it takes hours of running a
couple of hundred threads doing sequential file create and unlinks
on a 32p VM.  i.e. adding a half-hour long 16-way fsmark workload
every couple of minutes to the load that is aready running on the
filesystem. It runs at about 350,000 file creates/s and 150,000
unlinks/s, so it takes a load that is not really feasible for the
majority of QA environments. I haven't had this workload deadlock
since I wrote this patch.

The other system I have that reliably trips over this is at the
other end of the scale, and it's generic/269 w/ MKFS_OPTIONS="-b
size=1024 -m crc=1" that deadlocks on a single CPU VM with 1GB RAM.
This patch does make generic/269 complete on that machine - it just
changes the deadlock that is being hit.

i.e.  it appears that we have introduced an ENOSPC AGF vs AGF lock
ordering deadlock at some point, but I haven't got a handle on that
yet to be able to even speculate on what the cause might be. I'm in
the process of refining tracepoints to narrow down the exactly order
of operations that is causing problems...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
