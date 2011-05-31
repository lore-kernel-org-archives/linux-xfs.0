Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p4VMJUSs079162 for <xfs@oss.sgi.com>; Tue, 31 May 2011 17:19:31 -0500
Subject: Re: [PATCH 2/2] xfs: prevent bogus assert when trying to remove
	non-existent attribute
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <1306815659-23346-3-git-send-email-david@fromorbit.com>
References: <1306815659-23346-1-git-send-email-david@fromorbit.com>
	<1306815659-23346-3-git-send-email-david@fromorbit.com>
Date: Tue, 31 May 2011 17:19:26 -0500
Message-ID: <1306880366.2865.74.camel@doink>
MIME-Version: 1.0
Reply-To: aelder@sgi.com
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
Cc: xfs@oss.sgi.com

On Tue, 2011-05-31 at 14:20 +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> If the attribute fork on an inode is in btree format and has
> multiple levels (i.e node format rather than leaf format), then a
> lookup failure will trigger an assert failure in xfs_da_path_shift
> if the flag XFS_DA_OP_OKNOENT is not set. This flag is used to
> indicate to the directory btree code that not finding an entry is
> not a fatal error. In the case of doing a lookup for a directory
> name removal, this is valid as a user cannot insert an arbitrary
> name to remove from the directory btree.
> 
> However, in the case of the attribute tree, a user has direct
> control over the attribute name and can ask for any random name to
> be removed without any validation. In this case, fsstress is asking
> for a non-existent user.selinux attribute to be removed, and that is
> causing xfs_da_path_shift() to fall off the bottom of the tree where
> it asserts that a lookup failure is allowed. Because the flag is not
> set, we die a horrible death on a debug enable kernel.
> 
> Prevent this assert from firing on attribute removes by adding the
> op_flag XFS_DA_OP_OKNOENT to atribute removal operations.
> 
> Discovered when testing on a SELinux enabled system by fsstress in
> test 070 by trying to remove a non-existent user.selinux attribute.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

I have not carefully verified this change, but your
description of the problem was very good so based
on this the change looks right to me.

Signed-off-by: Alex Elder <aelder@sgi.com>



_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
