Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p5S1Sgcs168253 for <xfs@oss.sgi.com>; Mon, 27 Jun 2011 20:28:42 -0500
Received: from ipmail07.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2AFC7E316AE
	for <xfs@oss.sgi.com>; Mon, 27 Jun 2011 18:28:40 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	NgD8BrxuWoB65sVY for <xfs@oss.sgi.com>;
	Mon, 27 Jun 2011 18:28:40 -0700 (PDT)
Date: Tue, 28 Jun 2011 11:28:38 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs_repair: Check if agno is inside the filesystem
Message-ID: <20110628012838.GI32466@dastard>
References: <1309193610-17078-1-git-send-email-lczerner@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1309193610-17078-1-git-send-email-lczerner@redhat.com>
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
To: Lukas Czerner <lczerner@redhat.com>
Cc: aelder@sgi.com, xfs@oss.sgi.com

On Mon, Jun 27, 2011 at 06:53:30PM +0200, Lukas Czerner wrote:
> When getting an inode tree pointer from an array inode_tree_ptrs, we
> should check if agno, which is used as a pointer to the array, lives
> within the file system, because if it is not, we can end up touching
> uninitialized memory.

How do you get an agno outside the bounds of the filesystem?

> This commit fixes it by passing xfs_mount_t to affected functions and
> checking if agno really is inside the file system.

We're slowly removing typedefs as we change code. So probably better
to use struct xfs_mount for all the places where you add an
xfs_mount_t.

Otherwise seems fine.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
