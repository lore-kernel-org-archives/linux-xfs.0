Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o4L8O5Ah257217 for <xfs@oss.sgi.com>; Fri, 21 May 2010 03:24:05 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D81A514219B9
	for <xfs@oss.sgi.com>; Fri, 21 May 2010 01:26:22 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail12.adl6.internode.on.net
	[150.101.137.97]) by cuda.sgi.com with ESMTP id
	PMejtGT41Wn9AxHs for <xfs@oss.sgi.com>;
	Fri, 21 May 2010 01:26:22 -0700 (PDT)
Date: Fri, 21 May 2010 18:26:19 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: XFS on 2.6.26: reading the first 4K of a large file takes ages
Message-ID: <20100521082619.GX8120@dastard>
References: <8239xojfco.fsf@mid.bfk.de> <20100519114826.GA18224@infradead.org>
	<82sk5m7oyz.fsf@mid.bfk.de>
	<87zkztojwh.fsf@willster.local.flamingspork.com>
	<828w7d69h8.fsf@mid.bfk.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <828w7d69h8.fsf@mid.bfk.de>
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
To: Florian Weimer <fweimer@bfk.de>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Fri, May 21, 2010 at 06:43:15AM +0000, Florian Weimer wrote:
> * Stewart Smith:
> 
> > On Thu, 20 May 2010 12:11:00 +0000, Florian Weimer <fweimer@bfk.de> wrote:
> >> Thanks for confirming my hunch.  I don't think it's worth fixing this
> >> in XFS.  The database should call posix_fallocate() before flushing
> >> its internal cache to the file in essentially random order, but it's
> >> difficult to get upstream to implement this (the source code is a bit
> >> hard to follow, unfortunately).
> >
> > Which database?
> 
> Oracle Berkeley DB.
> 
> > You could always mount with allocsize
> 
> This happens with "allocsize=4194304".

Because allocsize only works for allocations extending the file.

> > or use other tools to do the preallocation before things got too
> > bad.
> 
> Is there a way to transparently preallocate a few GB after the current
> end of the file?  That would be helpful because Berkeley DB wouldn't
> have to know about it.

Yes. the fallocate() syscall has a mode that allows allocation
beyond the current end of file, as does the XFS_IOC_RESVSP ioctl.

Or, even easier, with xfs_io:

$ stat /mnt/test/foo
  File: `/mnt/test/foo'
  Size: 0               Blocks: 0          IO Block: 4096   regular empty file
....
$ xfs_io -f -c "resvsp 0 1048576" /mnt/test/foo
$ stat /mnt/test/foo
  File: `/mnt/test/foo'
  Size: 0               Blocks: 2048       IO Block: 4096   regular empty file
....
$ xfs_bmap -vp /mnt/test/foo
/mnt/test/foo:
 EXT: FILE-OFFSET      BLOCK-RANGE      AG AG-OFFSET        TOTAL FLAGS
   0: [0..2047]:       171912..173959    0 (171912..173959)  2048 10000
$

/mnt/test/foo still a zero length file but has 1MB of extents allocated.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
