Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o7IAACwZ106798 for <xfs@oss.sgi.com>; Wed, 18 Aug 2010 05:10:12 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2CE20506F
	for <xfs@oss.sgi.com>; Wed, 18 Aug 2010 03:10:41 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id aOYGLfaCgGwNZHEw for
	<xfs@oss.sgi.com>; Wed, 18 Aug 2010 03:10:41 -0700 (PDT)
Date: Wed, 18 Aug 2010 06:10:36 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] Re: xfsdump-3.0.4 problems
Message-ID: <20100818101036.GA14467@infradead.org>
References: <20100816182236.249a2a0f@x2.grafnetz>
	<20100816223021.GL10429@dastard>
	<20100817083227.06e23889@x2.grafnetz>
	<20100817071337.GN10429@dastard>
	<20100817095340.6b9ab8e2@x2.grafnetz>
	<20100817090534.GP10429@dastard> <20100817114550.GQ10429@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100817114550.GQ10429@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: Mario Bachmann <mbachman@stud.uni-frankfurt.de>, xfs@oss.sgi.com

> xfs: fix untrusted inode number lookup
> 
> From: Dave Chinner <dchinner@redhat.com>
> 
> Commit 7124fe0a5b619d65b739477b3b55a20bf805b06d ("xfs: validate untrusted inode
> numbers during lookup") changes the inode lookup code to do btree lookups for
> untrusted inode numbers. This change made an invalid assumption about the
> alignment of inodes and hence incorrectly calculated the first inode in the
> cluster. As a result, some inode numbers were being incorrectly considered
> invalid when they were actually valid.
> 
> The issue was not picked up by the xfstests suite because it always runs fsr
> and dump (the two utilities that utilise the bulkstat interface) on cache hot
> inodes and hence the lookup code in the cold cache path was not sufficiently
> exercised to uncover this intermittent problem.
> 
> Fix the issue by relaxing the btree lookup criteria and then checking if the
> record returned contains the inode number we are lookup for. If it we get an
> incorrect record, then the inode number is invalid.

Looks good and fixes the dump issues I've seen in xfstests.


Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
