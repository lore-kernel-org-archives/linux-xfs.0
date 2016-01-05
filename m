Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id CB8897F37
	for <xfs@oss.sgi.com>; Mon,  4 Jan 2016 19:14:28 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id AA80130405F
	for <xfs@oss.sgi.com>; Mon,  4 Jan 2016 17:14:25 -0800 (PST)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id MVUL3gZjLMa27jzc (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 04 Jan 2016 17:14:24 -0800 (PST)
Date: Mon, 4 Jan 2016 17:13:58 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 57/76] xfs: allocate delayed extents in CoW fork
Message-ID: <20160105011358.GH28330@birch.djwong.org>
References: <20151219085622.12713.88678.stgit@birch.djwong.org>
	<20151219090248.12713.32309.stgit@birch.djwong.org>
	<20160103122058.GE28429@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160103122058.GE28429@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Sun, Jan 03, 2016 at 04:20:58AM -0800, Christoph Hellwig wrote:
> I really don't like the separate XFS_IOEND_COW flag.  This should
> be an ioend type just like XFS_IO_DELALLOC, XFS_IO_UNWRITTEN and
> XFS_IO_OVERWRITE.  We might need some work in the direct I/O
> completions for that to really work, though.

The COW completion is an ioend flag (instead of an ioend type) *because* of how
I thought directio completions work. :)

It looked to me like you could only have one ioend for a dio, and that there
wasn't a clean way to make XFS have multiple ioends for a particular dio.
Since the remap operation remaps everything it finds in the COW fork for a
given part of a file and leaves the rest alone, it seemed natural to encode COW
as a flag in the ioend, leave the ioend type as XFS_IO_OVERWRITE, and try to
have as few ioends as possible.  For dio writes I can COW write almost as fast
as a regular overwrite.

I further observed with the RFCv3 COW (which did have a separate ioend type for
COW) that random writes had a tendency to create a /lot/ of ioends.  If you let
all these writes accumulate and then flushed them out with a single fsync, the
scatteredness of the COW blocks caused the creation of a lot of ioends, which
then caused a thundering herd when all those ioends had to be pushed separately
through the workqueue.  Changing the ioend handling to the way it is in RFCv4
greatly reduced the number of ioends that have to be processed, and
dramatically improved write speeds.

(I also fixed a bug where it would create ioends for each COW block in a
streaming write; both fixes make v4's COW 5x faster on a ramdisk than v3's.)

Did I overlook some subtlety with ioends?  So far it's worked fine as-is.

--D

> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
