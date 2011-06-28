Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p5S9Oux6205695 for <xfs@oss.sgi.com>; Tue, 28 Jun 2011 04:24:56 -0500
Date: Tue, 28 Jun 2011 11:24:46 +0200 (CEST)
From: Lukas Czerner <lczerner@redhat.com>
Subject: Re: [PATCH] xfs_repair: Check if agno is inside the filesystem
In-Reply-To: <20110628012838.GI32466@dastard>
Message-ID: <alpine.LFD.2.00.1106281120250.3864@dhcp-27-109.brq.redhat.com>
References: <1309193610-17078-1-git-send-email-lczerner@redhat.com>
	<20110628012838.GI32466@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: Lukas Czerner <lczerner@redhat.com>, aelder@sgi.com, xfs@oss.sgi.com

On Tue, 28 Jun 2011, Dave Chinner wrote:

> On Mon, Jun 27, 2011 at 06:53:30PM +0200, Lukas Czerner wrote:
> > When getting an inode tree pointer from an array inode_tree_ptrs, we
> > should check if agno, which is used as a pointer to the array, lives
> > within the file system, because if it is not, we can end up touching
> > uninitialized memory.
> 
> How do you get an agno outside the bounds of the filesystem?

Hi Dave,

in my particular case the problem was in
longform_dir2_entry_check_data(). xfs_dir2_data_entry_t was read and we
used inode numbed (xfs_dir2_data_entry_t)->inumber to compute AG number.
However it contained garbage so the resulting agno was too high. In
modify mode it was not a problem, because the inode was cleared in the
earlies phase, but in no_modify mode, the was still there.

> 
> > This commit fixes it by passing xfs_mount_t to affected functions and
> > checking if agno really is inside the file system.
> 
> We're slowly removing typedefs as we change code. So probably better
> to use struct xfs_mount for all the places where you add an
> xfs_mount_t.

Will do. Thanks!
-Lukas

> 
> Otherwise seems fine.
> 
> Cheers,
> 
> Dave.
> 

-- 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
