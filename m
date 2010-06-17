Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o5HMn0gg195049 for <xfs@oss.sgi.com>; Thu, 17 Jun 2010 17:49:01 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9905714F7378
	for <xfs@oss.sgi.com>; Thu, 17 Jun 2010 15:51:37 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail19.adl2.internode.on.net
	[150.101.137.104]) by cuda.sgi.com with ESMTP id
	zrBUGguGRmYcTuhe for <xfs@oss.sgi.com>;
	Thu, 17 Jun 2010 15:51:37 -0700 (PDT)
Date: Fri, 18 Jun 2010 08:51:30 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfsqa: test open_by_handle() on unlinked and freed
	inode clusters V2
Message-ID: <20100617225130.GX6590@dastard>
References: <1276756659-12338-1-git-send-email-david@fromorbit.com>
	<201006171007.26040@zmi.at>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <201006171007.26040@zmi.at>
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
To: Michael Monnerie <michael.monnerie@is.it-management.at>
Cc: aelder@sgi.com, xfs@oss.sgi.com

On Thu, Jun 17, 2010 at 10:07:25AM +0200, Michael Monnerie wrote:
> On Donnerstag, 17. Juni 2010 Dave Chinner wrote:
> > Hence if we get a cold cache lookup from a stale handle that
> > references such an inode, we can read the inode off disk even though
> > it has been deleted because we don't check if the inode is allocated
> > or not.  If the inode chunk has not been overwritten, then the inode
> > read will succeed and the handle-to-dentry conversion will not error
> > out like it is supposed to. The result is that stale NFS filehandles
> > and open_by_handle() will succeed incorrectly on unlinked files for
> > cold cache lookups.
>  
> Wouldn't that qualify as a security problem and be handled as such? 
> There should be back ports for "long term support" kernels of security-
> sensitive people, and so on.

Probably. Alex, are you able to handle this side of things?

Note that local open_by_handle() use is not really an issue - it
requires root and if you have root you can run xfs_db or dd on the
block device to get the same information.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
