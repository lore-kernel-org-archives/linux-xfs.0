Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q15Mhaqs082018 for <xfs@oss.sgi.com>; Sun, 5 Feb 2012 16:43:36 -0600
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	50NCEw3Vcx1jTFYV for <xfs@oss.sgi.com>;
	Sun, 05 Feb 2012 14:43:34 -0800 (PST)
Date: Mon, 6 Feb 2012 09:43:30 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Performance problem - reads slower than writes
Message-ID: <20120205224330.GF6922@dastard>
References: <20120130220019.GA45782@nsrc.org> <20120131020508.GF9090@dastard>
	<20120131103126.GA46170@nsrc.org> <20120131141604.GB46571@nsrc.org>
	<20120131202526.GJ9090@dastard> <20120203184723.GA2261@nsrc.org>
	<20120203190304.GA11809@infradead.org>
	<20120203210114.GD2479@nsrc.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120203210114.GD2479@nsrc.org>
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
To: Brian Candler <B.Candler@pobox.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Fri, Feb 03, 2012 at 09:01:14PM +0000, Brian Candler wrote:
> On Fri, Feb 03, 2012 at 02:03:04PM -0500, Christoph Hellwig wrote:
> > > With defaults, the files in one directory are spread all over the
> > > filesystem.  But with -i size=1024, the files in a directory are stored
> > > adjacent to each other. Hence reading all the files in one directory
> > > requires far less seeking across the disk, and runs about 3 times faster.
> > 
> > Not sure if you mentioned it somewhere before, but:
> > 
> >  a) how large is the filesystem?
> 
> 3TB.
> 
> >  b) do use the inode64 mount option
> 
> No: the only mount options I've given are noatime,nodiratime.
> 
> >  c) can you see the same good behaviour when using inode64 and small
> >     inodes (not that inode64 can NOT be set using remount)
> 
> I created a fresh filesystem (/dev/sdh), default parameters, but mounted it
> with inode64.  Then I tar'd across my corpus of 100K files.  Result: files
> are located close to the directories they belong to, and read performance
> zooms.
> 
> So I conclude that XFS *does* try to keep file extents close to the
> enclosing directory, but was being thwarted by the limitations of 32-bit
> inodes.
> 
> There is a comment "performance sucks" at:
> http://xfs.org/index.php/XFS_FAQ#Q:_What_is_the_inode64_mount_option_for.3F
> 
> However, there it talks about files [extents?] being located close to their
> inodes, rather than file extents being located close to their parent
> directory.

With inode64, inodes are located close to their parent directories'
inode, and file extent allocation is close to the owner's inode.
Hence file extent allocation is close to the parent directory inode,
too.

Directory inodes are where the locality changes - each new subdir is
placed in a different AG, with the above behaviour you get
per directory locality with inode64.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
