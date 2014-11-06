Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 157E07F3F
	for <xfs@oss.sgi.com>; Thu,  6 Nov 2014 00:54:40 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id A5851AC004
	for <xfs@oss.sgi.com>; Wed,  5 Nov 2014 22:54:36 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	P49jiKBQJGm6GOjb for <xfs@oss.sgi.com>;
	Wed, 05 Nov 2014 22:54:33 -0800 (PST)
Date: Thu, 6 Nov 2014 17:53:59 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 0/6 v2] xfs: fix the bulkstat mess
Message-ID: <20141106065359.GD23575@dastard>
References: <1415145921-31507-1-git-send-email-david@fromorbit.com>
	<20141105060728.GE28565@dastard> <20141105063226.GF28565@dastard>
	<20141105131706.GB26724@bfoster.bfoster>
	<20141105212100.GG28565@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20141105212100.GG28565@dastard>
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

On Thu, Nov 06, 2014 at 08:21:00AM +1100, Dave Chinner wrote:
> On Wed, Nov 05, 2014 at 08:17:06AM -0500, Brian Foster wrote:
> > On Wed, Nov 05, 2014 at 05:32:26PM +1100, Dave Chinner wrote:
> > > OK, this looks like a problem with handling the last record in the
> > > AGI btree:
> > > 
> > > $ for i in `cat s.diff | grep "^+/" | sed -e 's/^+//'` ; do ls -i $i; done |sort -n
> > > 163209114099 /mnt/scratch/2/dbc/5459605f~~~~~~~~RDJX8QBHPPMCGMD7YJQGYPD2
> > > ....
> > > 163209114129 /mnt/scratch/2/dbc/5459605f~~~~~~~~U820IYQFKS8A6QYCC8HU3ZBX
> > > 292057960758 /mnt/scratch/0/dcc/54596070~~~~~~~~9BUH5D5PZTGAC8BT1YL77OZ0
> > > ...
> > > 292057960769 /mnt/scratch/0/dcc/54596070~~~~~~~~DAO78GAAFNUZU8PH7Q0UZNRH
> > > 1395864555809 /mnt/scratch/1/e60/54596103~~~~~~~~GEMXGHYNREW409N7W9INBMVA
> > > .....
> > > 1395864555841 /mnt/scratch/1/e60/54596103~~~~~~~~9XPK9FWHCE21AJ3EN023DU47
> > > 1653562593576 /mnt/scratch/5/e79/5459611c~~~~~~~~BSBZ6EUCT9HOIRQPMFZDVPQ5
> > > .....
> > > 1653562593601 /mnt/scratch/5/e79/5459611c~~~~~~~~6QY1SO8ZGGNQESAGXSB3G3DH
> > > $
> > > 
> > > xfs_db> convert inode 163209114099 agno
> > > 0x26 (38)
> > > xfs_db> convert inode 163209114099 agino
> > > 0x571f3 (356851)
> > > xfs_db> convert inode 163209114129 agino
> > > 0x57211 (356881)
> > > xfs_db> agi 38
> > > xfs_db> a root
> > > xfs_db> a ptrs[2]
> > > xfs_db> p
> > > ....
> > > recs[1-234] = [startino,freecount,free]
> > > ......
> > > 228:[356352,0,0] 229:[356416,0,0] 230:[356512,0,0] 231:[356576,0,0]
> > > 232:[356672,0,0] 233:[356736,0,0] 234:[356832,14,0xfffc000000000000]
> > > 
> > > So the first contiguous inode range they all fall into the partial final record
> > > in the AG.
> > > 
> > > xfs_db> convert inode 292057960758 agino
> > > 0x2d136 (184630)
> > > .....
> > > 155:[184544,0,0] 156:[184608,30,0xfffffffc00000000]
> > > 
> > > Same.
> > > 
> > > xfs_db> convert inode 1395864555809 agino
> > > 0x2d121 (184609)
> > > .....
> > > 155:[184544,0,0] 156:[184608,30,0xfffffffc00000000]
> > > 
> > > Same.
> > > 
> > > xfs_db> convert inode 1653562593576 agino
> > > 0x2d128 (184616)
> > > ....
> > > 155:[184544,0,0] 156:[184608,30,0xfffffffc00000000]
> > > 
> > > Same.
> > > 
> > > So they are all falling into the last btree record in the AG, and so
> > > appear to have been skipped as a result of the same issue. At least
> > > that gives me something to look at.
> > > 
> > 
> > Interesting, though just to note... is it possible this is related to
> > records with free inodes?
> 
> Oh, definitely possible - I haven't ruled that out yet. However, I
> would have expected such an issue ot manifest itself during xfstests
> (e.g. xfs/068) where random files are removed from the filesystem
> and so leaving fre inodes in the inobt....

It's not.

> > It also might be interesting to know whether this repeats without the
> > last patch in the series. IIRC that one seemed to have the most
> > potential impact on the overall algorithm (by changing loop iteration
> > logic, etc.). Just a thought.
> 
> I'll try that, but the missing files don't seem aligned to the

And it's not that.

THe issue, as I suspected was to do with end of AG handling, in a
special corner case: the user buffer ran out of space part way
through processing the last records in the AG.

That is, we've scanned all the way to the end of the ag and records
the inobt records into the temp buffer. As this runs off the end of
the AG, it sets the end_of_ag flag. We then walk the temp
buffer to format the inodes, and while doing so we run out of space
before all the inodes are formatted. We then hit the loop
termination, which does agno++; agino = 0; and then we hit the
"user buffer full check".

And so the cookie we pass back to userspace doesn't match the last
inode we actually formatted, and so it skips a bunch of files in the
dump. So, we have missing inodes in the dump. THe scary part about
this is that the inodes are actually in the directory tree that
xfsdump builds but it does not give any warnings that
inodes weren't found during scan. And xfsrestore doesn't warn that
entries in the directory tree didn't have any corresponding inode in
the dump....

Hence I could look at the dump and find the path and inode number
corresponding to one of the missing files, mark it for extraction
and then extract it *successfully* but the file was not restored -
it is actually missing from the dump....

Anyway, the bug was in patch 3 - we have to check whether the user
buffer has space left before processing the end_of_ag state. I
removed the buffer space check from the for() loop logic because
it's just plain misleading and with the check in the formatter and
the end of the main loop is entires redundant. I'll post the series
again once I've confirmed a good dump and restore.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
