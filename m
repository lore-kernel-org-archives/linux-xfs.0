Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 74CC07F3F
	for <xfs@oss.sgi.com>; Thu, 26 Sep 2013 17:47:55 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 630FA304067
	for <xfs@oss.sgi.com>; Thu, 26 Sep 2013 15:47:52 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	eldkop9fsmdML7SR for <xfs@oss.sgi.com>;
	Thu, 26 Sep 2013 15:47:50 -0700 (PDT)
Date: Fri, 27 Sep 2013 08:47:27 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Issues and new to the group
Message-ID: <20130926224727.GS26872@dastard>
References: <52444BDD.9060100@gmail.com>
	<20084214.8829.1380209207683.JavaMail.root@benjamin.baylink.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20084214.8829.1380209207683.JavaMail.root@benjamin.baylink.com>
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
To: Jay Ashworth <jra@baylink.com>
Cc: xfs@oss.sgi.com

On Thu, Sep 26, 2013 at 11:26:47AM -0400, Jay Ashworth wrote:
> ----- Original Message -----
> > From: "Joe Landman" <joe.landman@gmail.com>
> 
> > > takes. The folders are image folders that have anywhere between 5 to
> > > 10 million images in each folder.
> > 
> > The combination of very large folders, and virtualization is working
> > against you. Couple that with an old (ancient by Linux standards) xfs
> > in the virtual CentOS 5.9 system, and you aren't going to have much
> > joy with this without changing a few things.
> 
> > Can you change from one single large folder to a heirarchical set of
> > folders? The single large folder means any metadata operation (ls,
> > stat, open, close) has a huge set of lists to traverse. It will work,
> > albiet slowly. As a rule of thumb, we try to make sure our users don't
> > go much beyond 10k files/folder. If they need to, building a heirarchy
> > of folders slightly increases management complexity, but keeps the
> > lists that are needed to be traversed much smaller.
> > 
> > A strategy for doing this: If your files are named "aaaa0001"
> > "aaaa0002" ... "zzzz9999" or similar, then you can chop off the first
> > letter, and make a directory of it, and then put all files starting
> > with that letter in that directory. Then within each of those directories,
> > do the same thing with the second letter. This gets you 676
> > directories and about 15k files per directory. Much faster directory operations.
> > Much smaller lists to traverse.
> 
> While this problem isn't *near* as bad on XFS as it was on older filesystems,
> where over maybe 500-1000 files would result in 'ls' commands taking
> over a minute...

Assuming a worst case, 500-1000 files requires 700-1200 IOs for LS
to complete. If that's taking over a minute, then you're getting
less than 10-20 IOPS for the workload which is about 10% of the
capability of a typical SATA drive. This sounds to me like there was
lots of other stuff competing for IO bandwidth at the same time or
something else wrong to result in such poor performance for ls.

> It's still a good idea to filename hash large collections of files of 
> similar types into a directory tree, as Joe recommends.  The best approach
> I myself have seen to this is to has a filename of
> 
> 835bfak3f89yu12.jpg
> 
> into
> 
> 8/3/5/b/835bfak3f89yu12.jpg
> 8/3/5/b/f/835bfak3f89yu12.jpg
> 8/3/5/b/f/a/835bfak3f89yu12.jpg

No, not on XFS. here you have a fanout per level of 16. i.e.
consider a tree with a fanout of 16. To move from level to level, it
takes 2 IOs.

Lets consider the internal hash btree in XFS. For a 4k directory
block, it fits 500 entries - call it 512 to make the math easy. i.e.
it is a tree with a fanout per level of 512 To move from level to
level, it takes 1 IO.

> 8/3/5/b/f/a/835bfak3f89yu12.jpg

Here we have 6 levels of hash, that's 16^6 = 16.7M fanout.

With a fanout of 512, the internal XFS hash btree needs only 3
levels (64 * 512 * 512) to index the same number directory entries.

So, do a lookup on the hash, it takes 12 IOs to get to the leaf
directory, then as many IOs are required to look up the entry in the
leaf directory. For a single large XFS directory, it takes 3 IOs to
find the dirent, and another 1 to read the dirent and return it to
userspace i.e. 4 IOs total vs 12 + N IOs for the equivalent 16-way
hash of the same depth...

What I am trying to point out is that on XFS deep hashing will not
improve performance like it might on ext4 - on XFS you should look
to use wide, shallow directory hashing with relatively large numbers
of entries in each leaf directory because the internal directory
structure is much more efficient that from an IO perspective than
hashing is...

And then, of course, if directory IO is still the limiting factor
with large numbers of leaf entries (e.g. you're indexing billions of
files), you have the option of using larger directory blocks and
making the internal directory fanout up to 16x wider than in this
example...

> Going as deep as necessary to reduce the size of the directories. What
> you lose in needing to cache the extra directory levels outweighs (probably
> far outweighs) having to handle Directories Of Unusual Size.

On XFS, a directory with a million entries is not an unusual size -
with a 4k directory block size the algorithms are still pretty CPU
efficient at this point, though it's going to be at roughly half
that of an empty directory. It's once you get above several million
entries that the modification cost starts to dominate performance
considerations and at that point a wider hash, not a deeper hash
should be considered..

> Note that I didn't actually trim the filename proper; the final file still has
> its full name.  This hash is easy to build, as long as you fix the number of layers
> in advance... and if you need to make it deeper, later, it's easy to build a 
> shell script that crawls the current tree and adds the next layer.

Avoiding the need for rebalancing a directory hash is one of the
reasons for designing it around a scalable directory structure in
the first place.  It pretty much means the only consideration for
the width of the hash and the underlying filesystem layout is the
concurrency your application requires.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
