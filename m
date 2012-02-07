Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q17IcXe6252899 for <xfs@oss.sgi.com>; Tue, 7 Feb 2012 12:38:33 -0600
Date: Tue, 7 Feb 2012 13:38:30 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 3/8] xfsprogs: xfs_repair: don't set the root inode pointer
Message-ID: <20120207183830.GA31143@infradead.org>
References: <3ed89446f6dc1231ec1de712f242522052952b7e.1320955675.git.aelder@sgi.com>
	<6833e89ecf7daa3ba69676fb98a4538ee6c3a1b5.1320955675.git.aelder@sgi.com>
	<20111113120133.GC19435@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20111113120133.GC19435@infradead.org>
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
To: Kevan Rehm <kfr@sgi.com>, xfs@oss.sgi.com

On Sun, Nov 13, 2011 at 07:01:33AM -0500, Christoph Hellwig wrote:
> On Thu, Nov 10, 2011 at 02:35:13PM -0600, Alex Elder wrote:
> > From: Kevan Rehm <kfr@sgi.com>
> > 
> > In phase 6, in mk_root_dir(), xfs_repair initializes the mount
> > point's m_rootip pointer without accounting for that reference.
> > This field never really used or needed in repair otherwise, and the
> > assigned pointer doesn't really represent a real reference to an
> > inode that needs to be cached.  So just kill off this assignment.
> > 
> > Signed-off-by: Alex Elder <aelder@sgi.com>
> 
> Shouldn't this also have Kevan's signoff?

Kevan, can you give me a signoff for this patch, I'd like to put it in?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
