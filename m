Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p6G1KrWx227980 for <xfs@oss.sgi.com>; Fri, 15 Jul 2011 20:20:54 -0500
Received: from ipmail05.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9578B17DB20D
	for <xfs@oss.sgi.com>; Fri, 15 Jul 2011 18:20:51 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	x2xMS9ZKDvbgTzvB for <xfs@oss.sgi.com>;
	Fri, 15 Jul 2011 18:20:51 -0700 (PDT)
Date: Sat, 16 Jul 2011 11:20:48 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] stable: restart busy extent search after node removal
Message-ID: <20110716012048.GE21663@dastard>
References: <4E1CC4BA.1010107@redhat.com> <20110713001234.GN23038@dastard>
	<4E1CE35B.4010404@redhat.com> <20110713002022.GO23038@dastard>
	<4E1CF47D.7080909@sandeen.net> <1310739542.2921.8.camel@doink>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1310739542.2921.8.camel@doink>
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
To: Alex Elder <aelder@sgi.com>
Cc: Eric Sandeen <sandeen@redhat.com>, Eric Sandeen <sandeen@sandeen.net>, xfs-oss <xfs@oss.sgi.com>

On Fri, Jul 15, 2011 at 09:19:02AM -0500, Alex Elder wrote:
> On Tue, 2011-07-12 at 20:27 -0500, Eric Sandeen wrote:
> > On 7/12/11 7:20 PM, Dave Chinner wrote:
> > > On Tue, Jul 12, 2011 at 07:14:19PM -0500, Eric Sandeen wrote:
> > >>> I'm guessing that the only case I was able to hit during testing of
> > >>> this code originally was the "overlap with exact start block match",
> > >>> otherwise I would have seen this. I'm not sure that there really is
> > >>> much we can do to improve the test coverage of this code, though.
> > >>> Hell, just measuring our test coverage so we know what we aren't
> > >>> testing would probably be a good start. :/
> > >>
> > >> Apparently the original oops, and the subsequent replay oopses,
> > >> were on a filesystem VERY busy with torrents.
> > >>
> > >> Might be a testcase ;)
> 
> So, would you mind trying to create this as a test?
> Can you come up with a reliable way to create a
> small but *very* fragmented filesystem to do stuff
> with?

See test 042 - it's not hard to do..

But 042 only uses a 48MB filesystem. To generate hundreds of
thousands of extents, it needs to be done on a filesystem that can
hold hundreds of thousands of blocks - gigabytes in size, IOWs.

What I'd like to do is basically fill the fs full of single block
files, delete every alternate one (fragments free space to stress
those btrees), then fill the fs again with a single preallocation on
a new file to convert the freespace fragments to a fragmented bmbt
index, then free the remaining single block files and fill the fs
again with a single preallocation on the same file that already
fills half the fs. Finally, unmount the filesystem, mount it again
and remove the extents back to the free space by iteratively
punching out sparse ranges of the large file until it is empty. e.g.
0-1MB, 10-11MB, .... 1000MB-1001MB, 1-2MB, 11-12MB, .....

That should be a deterministic test that does the same btree
operations from run to run and provide decent coverage of most of
the btree and extent tree operations - including loading a massive
bmap tree from disk into memory.

I'd also like to repeat the test, but this time doing a random
delete of half the files so the fragmented file is not made up
entirely of single block extents. That will perturb the way the
btrees grow and shrink and so will execute btree operations in
combinations that the above deterministic test won't. e.g. it will
trip bmbt split/merges causing freespace btree split/merges in the
one allocation/free operation that a deterministic test will
never hit...

We don't really have coverage of bmap extent trees with that number
of extents in them right now, and test 250 shows that we do really
need that coverage (it exercised a bug in a 2->3 level split, IIRC).
I'd also be inclined to use a 512 byte filesystem block size with
only 2 AGs to cause the height of both the freespace and bmap the
btrees to increase much more quickly, too.

If we can, I'd like the test to range up to at least million extents
in a bmap btree - that covers single unfragmented files into the
multi-PB range for 4k block size filesystems.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
