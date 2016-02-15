Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 3AD417CA2
	for <xfs@oss.sgi.com>; Sun, 14 Feb 2016 23:32:33 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id D09CFAC003
	for <xfs@oss.sgi.com>; Sun, 14 Feb 2016 21:32:32 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	uFPMfQddHMOas5Yh for <xfs@oss.sgi.com>;
	Sun, 14 Feb 2016 21:32:30 -0800 (PST)
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 0/3] xfsprogs: FS_IOC_FS[SG]ETXATTR and DAX support
Date: Mon, 15 Feb 2016 16:32:23 +1100
Message-Id: <1455514346-15481-1-git-send-email-david@fromorbit.com>
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
Cc: ross.zwisler@linux.intel.com, jack@suse.cz

Hi folks,

There are two parts to this patchset. The first is ensuring that
xfsprogs builds correctly with the new kernel header provided
definitions of XFS_IOC_FS[SG]SETXATTR and it's flags. I modified
my original approach to this to hide the definitions of the FS*
ioctl and flags in the platofrm headers if the system didn't provide
them.

While this does result in some duplication, it solves the problem of
needing different definitions for FS_IOC_FS[SG]ETXATTR on different
platforms - they are different ioctl names on IRIX, so we can't just
define it once in xfs_fs.h. The detection can also then be different
- we only include the definitions on linux if we don't have the
system version, and on the other platforms it retains the
HAVE_FSXATTR guards.

The second and third patches are adding support for the FS_XFLAG_DAX
and enabling xfs_io to set, get and clear the flag. Actual support
of the on disk flag in libxfs will come in a later patchset that
adds support into db and repair, too. This is the patchset I used to
test the kernel side flag support.

Comments and testing welcome.

Cheers,

Dave.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
