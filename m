Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id B501129E09
	for <xfs@oss.sgi.com>; Tue, 18 Jun 2013 23:05:59 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 47331AC002
	for <xfs@oss.sgi.com>; Tue, 18 Jun 2013 21:05:56 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	HmpDeF1VAIeE8Elr for <xfs@oss.sgi.com>;
	Tue, 18 Jun 2013 21:05:51 -0700 (PDT)
Date: Wed, 19 Jun 2013 14:05:47 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: garbage block(s) after powercycle/reboot + sparse writes
Message-ID: <20130619040547.GG29338@dastard>
References: <alpine.DEB.2.00.1306041210070.15156@cobra.newdream.net>
	<51AE84C9.5030903@sandeen.net>
	<alpine.DEB.2.00.1306120955460.15386@cobra.newdream.net>
	<20130619014646.GF29338@dastard>
	<alpine.DEB.2.00.1306181959250.27409@cobra.newdream.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1306181959250.27409@cobra.newdream.net>
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
To: Sage Weil <sage@inktank.com>
Cc: Eric Sandeen <sandeen@sandeen.net>, xfs@oss.sgi.com

On Tue, Jun 18, 2013 at 08:12:01PM -0700, Sage Weil wrote:
> On Wed, 19 Jun 2013, Dave Chinner wrote:
> > On Wed, Jun 12, 2013 at 10:02:52AM -0700, Sage Weil wrote:
> > > Hi guys,
> > > 
> > > I reproduced this on two more boxes and have more data.  The full set of 
> > > notes/logs is at
> > > 
> > > 	http://newdream.net/~sage/bug-4976/notes.txt
> > 
> > case c:
> > 
> > /var/lib/ceph/osd/ceph-0/current/3.0_head/DIR_9/plana8021941-457__head_834C52B9__3:
> >         0: [0..7]: 244206232..244206239
> >         1: [8..1351]: hole
> >         2: [1352..2431]: 244252824..244253903
> >         3: [2432..3255]: hole
> >         4: [3256..4855]: 244254728..244256327
> > 
> > bad data starts at offset 1179648:
> > 
> > Which lies within the middle of an allocated extent (offset 2304bb).
> > 
> > IIUC, then there was a write at offset 700466 for 445465 bytes,
> > (i.e start @ 1368bb, end @ 2239bb), but given the block count of
> > the file didn't change, this must have been an overwrite of existing
> > data. It's well within EOF, too, so it's not clear what has happened
> > here - the bad data was not written by the ceph journal replay, and
> > the extent was already allocated on disk...
> > 
> > case d:
> > 
> >         0: [0..7]: 732632192..732632199
> >         1: [8..783]: hole
> >         2: [784..2943]: 733513808..733515967
> >         3: [2944..3511]: hole
> >         4: [3512..4703]: 733516536..733517727
> > 
> > 
> > INFO:teuthology.task.rados.rados.0.out:incorrect buffer at pos 1179648  (((same offset as previous case!!!))
> > 
> > So, similar layout, we have a write at offset 404703 for 773518
> > bytes (start @790bb, end @2302). Ok, that makes a little more sense
> > to have corruption starting @ 2304. The pages in the page cache that
> > cover this write would cover offsets 784bb to 2303bb, having zeroed
> > the head and tail sections.
> > 
> > The file size and number of blocks didn't change again and it's
> > well within the file size, so this is also an overwrite without
> > allocat. IOWs the overwrite ended at 2303bb, with corruption
> > starting at 2304bb.
> > 
> > Let's play a "what-if" game. there are 3 writes to the file:
> > 
> > 	-@ 0 for 57 bytes	(1FSB)
> > 	-@ 404703 for 773518 bytes (
> > 	-@ 1801584 for 603119 bytes
> > 
> > These translate to the following regions in BB:
> > 
> > 	- [0..1]
> > 	- [790..2302]
> > 	- [3518..4697]
> > 
> > If we round these to filesystem blocks, we have:
> > 
> > 	- [0..7]
> > 	- [784..2303]
> > 	- [3512..4703]
> > 
> > And in filesystem blocks:
> > 
> > 	Should have		Actually have
> > 	-----------		------------
> > 	- [0..1]		- [0..1]
> > 	- [98..287]		- [98..367]
> > 	- [439..587]		- [439..587]
> > 
> > So there's an extra 80 filesystem blocks in the middle extent. Does
> > that tally with the block count of 3360bb = 420fsb? 1 + 190 + 149 =
> > 340fsb. it doesn't, so there's another 60fsb beyond EOF.
> > 
> > And that's pretty telling. There's non-zero'd speculative
> > preallocation there. The *big* question is this: why was the file
> > size extented (i.e. user data IO completed) and updated and the
> > file size update logged to the journal *before* the zeroed regions
> > of the file had been written to zero?
> > 
> > And why only on 3.8/3.9?
> 
> I haven't gone back and tested on older kernels.  It's possible this isn't 
> a new problem and previous failures were lost in the noise.  :/
>  
> > > Any ideas?
> > 
> > I'd love to see the code that is writing the files in the first
> > place - it's not playing silly buggers with sync_file_range(), is
> > it?
> 
> Actually, it is!
> 
> ...
> 	  ::sync_file_range(fd, off, len, SYNC_FILE_RANGE_WRITE);
> ...
> 	    int fa_r = posix_fadvise(fd, off, len, POSIX_FADV_DONTNEED);
> 
> ...and a call to close(2).

<sigh>

> The intent was just to push things out of the disk so that a syncfs() 
> that comes later will take less time.  I wouldn't have expected this to 
> change the commit ordering semantics, though; only to initiate writeback 
> sooner.

It initiates writeback on certain ranges of the file before others,
and so therefore can expose issues related to ordering of writeback.
It's made worse by the fact that, by definition, both
sync_file_range() and posix_fadvise(POSIX_FADV_DONTNEED) provide no
data integrity guarantees. And, further, neither are vectored
through the filesystem like fsync is and so the filesystem can't
provide any integrity guarantees, either.

Hence if you use range based posix_fadvise(DONTNEED) and/or
sync_file_range(), you can get real strange things happening as data
writeback ordering is fully under the control of the user, not the
filesystem, and the user, in general, has no clue about what the
filesystem is doing under the covers.

> (Coincidentally, all of this code was just recently rewritten to do a 
> simple fsync.  I haven't retested the powercycling since then, though.)

fsync should work just fine, as it does increasing offset writeback
and that means the zeroed blocks will get written before the data
blocks and so uninitialised data won't get exposed....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
