Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q09LkYS8042221 for <xfs@oss.sgi.com>; Mon, 9 Jan 2012 15:46:34 -0600
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	FzglTzk1D5iEg7jt for <xfs@oss.sgi.com>;
	Mon, 09 Jan 2012 13:46:32 -0800 (PST)
Date: Tue, 10 Jan 2012 08:46:30 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Get file using a specific sector number
Message-ID: <20120109214630.GG4198@dastard>
References: <CAPPqfY1DOesJGfpZfnukr6PGo-KsGQ3u3tnF8UdVTZgWn2=HKA@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAPPqfY1DOesJGfpZfnukr6PGo-KsGQ3u3tnF8UdVTZgWn2=HKA@mail.gmail.com>
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
To: olivier@ajeux.com
Cc: xfs@oss.sgi.com

On Mon, Jan 09, 2012 at 07:14:23PM +0100, Olivier Doucet wrote:
> Hello everyone,
> 
> I'm actually using xfsprogs quite heavily and I'm stuck with one problem :
> 
> I have a sector number and I want to know which file is using it. xfs_bmap
> does exactly the opposite (give sector number for a specific file), but I
> cannot find how to do it the other way.
> I made several attempts with xfs_db but cannot find how to do it properly.
> Moreover, I need to do it on a mounted filesystem (RW), and xfs_db does not
> seem very friendly about that ...
> 
> Any help would be much appreciated.

There is no easy way to do it, because XFS does not have a reverse
map btree to tell you the owner of any given block. The only way to
find this is to walk the entire metadata tree to find the owner of
the block.

You can't do that reliably just by walking the directory heirarchy
and running xfs_bmap and xfs_bmap -a on every file and directory,
because the sector you are after may be in metadata that you can't
expose via this method. e.g. it might be a block in the extent tree
that xfs_bmap walks, in the free space or inode btrees, etc.

xfs_db is really the only way you can do this right now, using the
blockget command. You can run xfs_db on a RW filesystem (run it in
read-only mode), but xfs_db is not coherent with active filesystem
changes and hence is likely to crash randomly as the filesytem
changes under it. Also, blockget takes blocks in FSB format, so you
need to convert your sector (daddr) to FSB units using the convert
command first.

FWIW, you could always freeze the filesystem while you run the xfs_db
command, but that may cause other problems for your applications...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
