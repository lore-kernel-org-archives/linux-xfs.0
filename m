Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p5SBEfvm212075 for <xfs@oss.sgi.com>; Tue, 28 Jun 2011 06:14:43 -0500
Date: Tue, 28 Jun 2011 13:14:33 +0200 (CEST)
From: Lukas Czerner <lczerner@redhat.com>
Subject: Re: [PATCH] xfs_repair: Check if agno is inside the filesystem
In-Reply-To: <1309255279-15608-1-git-send-email-lczerner@redhat.com>
Message-ID: <alpine.LFD.2.00.1106281314060.3864@dhcp-27-109.brq.redhat.com>
References: <1309255279-15608-1-git-send-email-lczerner@redhat.com>
MIME-Version: 1.0
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

On Tue, 28 Jun 2011, Lukas Czerner wrote:

> When getting an inode tree pointer from an array inode_tree_ptrs, we
> should check if agno, which is used as a pointer to the array, lives
> within the file system, because if it is not, we can end up touching
> uninitialized memory.
> 
> This commit fixes it by passing xfs_mount to affected functions and
> checking if agno really is inside the file system.
> 
> This solves Red Hat bug #694706
> 
> Signed-off-by: Lukas Czerner <lczerner@redhat.com>
> Reviewed-by: Dave Chinner <dchinner@redhat.com>

I forgot to mention a version of the patch. This is version 2.

Thanks!
-Lukas

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
