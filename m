Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 92ACB7F90
	for <xfs@oss.sgi.com>; Mon, 26 Jan 2015 21:15:01 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 2EA81AC004
	for <xfs@oss.sgi.com>; Mon, 26 Jan 2015 19:14:57 -0800 (PST)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	O8yGX7KUYNV1ELjw for <xfs@oss.sgi.com>;
	Mon, 26 Jan 2015 19:14:53 -0800 (PST)
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 0/9] xfs: xfs_ioctl_setxattr rework
Date: Tue, 27 Jan 2015 14:14:37 +1100
Message-Id: <1422328486-24661-1-git-send-email-david@fromorbit.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: iustin@k1024.org

Hi folks,

This is a series I started a few months ago when we first started
talking about the issues with extent size hints on directories and
the project ID inherit flags being set on regular files. The code
is particularly nice and has no clear definition of what sort
of changes we allow in the XFS_IOC_FSSETXATTR ioctl.

The first thing the series does is kill the FSX_* flags and separate
out the two different use cases for the xfs_ioctl_setattr()
function. The first is just changing a constrained set of flags via
the xfs_ioc_setxflags(), and the second is supporting
xfs_ioc_fssetxattr(). Factoring out the part of the code that sets
just the inode flags appropriately allows us to kill the FSX_* flags
completely.

The next patch then relaxes the overly defensive approach to
restricting XFS_IOC_FSSETXATTR to only the init namespace. We really
only need to restrict project ID changes - allowing changes to other
parts of the inode are managed by user/group permissions which are
already user namespace aware.

The next part of the patch set factors out the validity checking
of extent size changes and project ID changes from the setattr
functions, making it much clearer the separation between checks and
actions performed by xfs_ioctl_setattr() function.

Finally, with all these changes, Iustin Pop's extent size change
validity checking patch is ported on top. That now becomes a simple,
obvious set of changes to an isolated function, and i've added
comments to explain the rules allowing extent size hints to be
changed.

Comments, thoughts, flames, etc all welcome.

- Dave.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
