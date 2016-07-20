Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 243C87CA0
	for <xfs@oss.sgi.com>; Wed, 20 Jul 2016 17:43:25 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id EBAFD8F8035
	for <xfs@oss.sgi.com>; Wed, 20 Jul 2016 15:43:24 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	WiuesrTnQULxhTZy for <xfs@oss.sgi.com>;
	Wed, 20 Jul 2016 15:43:19 -0700 (PDT)
Received: from dave by dastard with local (Exim 4.80)
	(envelope-from <david@fromorbit.com>) id 1bQ0Ca-0002wb-AX
	for xfs@oss.sgi.com; Thu, 21 Jul 2016 08:42:52 +1000
Date: Thu, 21 Jul 2016 08:42:52 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [ANNOUNCE] xfsprogs: master branch updated to v4.7.0-rc2
Message-ID: <20160720224252.GN16044@dastard>
MIME-Version: 1.0
Content-Disposition: inline
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
To: xfs@oss.sgi.com

Hi Folks,

The xfsprogs repository at:

git://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git

has just been updated and tagged as the 4.7.0-rc2 release. Only
minor changes in this update - I've added the copy_range command to
xfs_io even though this is an -rc2 as it's pretty much a standalone
change, not widely suppported by existing kernels and so is very low
risk to anything else. A 4.7 release should be just around the
corner, now....

-Dave.

The new head of the master branch is commit:

0054f91 xfsprogs: Release v4.7-rc2

New Commits:

Anna Schumaker (1):
      [628e112] xfs_io: implement 'copy_range' command

Dave Chinner (1):
      [0054f91] xfsprogs: Release v4.7-rc2

Zorro Lang (1):
      [70a4820] xfs_repair: low memory shouldn't indicate corruption on exit


Code Diffstat:

 VERSION               |   2 +-
 configure.ac          |   3 +-
 doc/CHANGES           |   5 ++
 include/builddefs.in  |   1 +
 io/Makefile           |   5 ++
 io/copy_file_range.c  | 148 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 io/init.c             |   1 +
 io/io.h               |   6 +++
 m4/package_libcdev.m4 |  17 ++++++
 repair/xfs_repair.c   |   6 +--
 10 files changed, 189 insertions(+), 5 deletions(-)
 create mode 100644 io/copy_file_range.c
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
