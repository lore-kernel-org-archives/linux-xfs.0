Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id B1B567CA0
	for <xfs@oss.sgi.com>; Thu,  7 Apr 2016 18:21:43 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 2FCA1AC004
	for <xfs@oss.sgi.com>; Thu,  7 Apr 2016 16:21:39 -0700 (PDT)
Received: from newverein.lst.de (verein.lst.de [213.95.11.211]) by
	cuda.sgi.com with ESMTP id BSS0nxWpQE4CUCRL (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 07 Apr 2016 16:21:37 -0700 (PDT)
Date: Fri, 8 Apr 2016 01:21:35 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: support RCU lookups for inline symlinks
Message-ID: <20160407232135.GA11502@lst.de>
References: <1458740935-31260-1-git-send-email-hch@lst.de>
	<20160405215508.GH11238@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160405215508.GH11238@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Wed, Apr 06, 2016 at 07:55:08AM +1000, Dave Chinner wrote:
> On Wed, Mar 23, 2016 at 02:48:51PM +0100, Christoph Hellwig wrote:
> > Return the inline link body in the inode to support RCU mode lookups.
> 
> The series doesn't appear to cause any regressions and the code
> looks good, so I've added the missing xfs_setup_iops() call in
> xfs_rename_alloc_whiteout() (patch 2), and converted dentry->d_inode
> to d_inode(dentry) in patch 3 for consistency withe the rest of the
> code and committed this series.

Thanks.  After some pondering I think we should setup the iops for the
quota inodes as well - if we ever do something like vfs_getattr on them
now that we're using VFS inode everywhere we'll need it.  And I'd better
be prepared for that than finding bugs after I've forgotten about all
this.  I'll send an incremental patch.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
