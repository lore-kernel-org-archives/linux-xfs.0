Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id AF5097F81
	for <xfs@oss.sgi.com>; Fri, 13 Dec 2013 08:28:35 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id A3BC3304077
	for <xfs@oss.sgi.com>; Fri, 13 Dec 2013 06:28:23 -0800 (PST)
Received: from e34.co.us.ibm.com (e34.co.us.ibm.com [32.97.110.152]) by
	cuda.sgi.com with ESMTP id yvnZFhFYGVFEF8by (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 13 Dec 2013 06:28:04 -0800 (PST)
Received: from /spool/local
	by e34.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only!
	Violators will be prosecuted
	for <xfs@oss.sgi.com> from <zwu.kernel@gmail.com>;
	Fri, 13 Dec 2013 07:28:04 -0700
Received: from b03cxnp08025.gho.boulder.ibm.com
	(b03cxnp08025.gho.boulder.ibm.com [9.17.130.17])
	by d03dlp02.boulder.ibm.com (Postfix) with ESMTP id E07B73E40044
	for <xfs@oss.sgi.com>; Fri, 13 Dec 2013 07:28:01 -0700 (MST)
Received: from d03av01.boulder.ibm.com (d03av01.boulder.ibm.com [9.17.195.167])
	by b03cxnp08025.gho.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with
	ESMTP id rBDES1PX8323440
	for <xfs@oss.sgi.com>; Fri, 13 Dec 2013 15:28:01 +0100
Received: from d03av01.boulder.ibm.com (localhost [127.0.0.1])
	by d03av01.boulder.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP
	id rBDES15V032565
	for <xfs@oss.sgi.com>; Fri, 13 Dec 2013 07:28:01 -0700
From: Zhi Yong Wu <zwu.kernel@gmail.com>
Subject: [PATCH 0/5] xfs: add O_TMPFILE support
Date: Fri, 13 Dec 2013 22:27:48 +0800
Message-Id: <1386944873-16796-1-git-send-email-zwu.kernel@gmail.com>
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
Cc: linux-fsdevel@vger.kernel.org, Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org

From: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>

HI, folks

  It's time to post out the first formal version, welcome to any constructive comment, thanks.

  If anyone is interested in playing with it, you can get this patchset from my dev git on github:
  git://github.com/wuzhy/kernel.git xfs_tmpfile

  The patchset was tests agaist the code snippet from Andy Lutomirski and other test cases:
  http://lwn.net/Articles/562296/
  If you have any other better test cases, please let me know, thanks.

#include <stdio.h>
#include <err.h>
#include <fcntl.h>
#include <unistd.h>
#include <string.h>

#define __O_TMPFILE 020000000
#define O_DIRECTORY 0200000
#define O_TMPFILE (__O_TMPFILE | O_DIRECTORY)
#define AT_EMPTY_PATH 0x1000

int main(int argc, char **argv)
{
   char buf[128];

   if (argc != 3)
     errx(1, "Usage: flinktest PATH linkat|proc");

   int fd = open(".", O_TMPFILE | O_RDWR, 0600);
   if (fd == -1)
     err(1, "O_TMPFILE");
   else
     printf("fd #: %d\n", fd);

   write(fd, "test", 4);

   if (!strcmp(argv[2], "linkat")) {
     if (linkat(fd, "", AT_FDCWD, argv[1], AT_EMPTY_PATH) != 0)
       err(1, "linkat");
   } else if (!strcmp(argv[2], "proc")) {
     sprintf(buf, "/proc/self/fd/%d", fd);
     if (linkat(AT_FDCWD, buf, AT_FDCWD, argv[1], AT_SYMLINK_FOLLOW) != 0)
       err(1, "linkat");
   } else {
     errx(1, "invalid mode");
   }

   return 0;
}


Changelog from rfc:
 - Addressed the comments from Dave Chinner and Christoph Hellwig.

Zhi Yong Wu (5):
  xfs: factor prid related codes into xfs_get_initial_prid()
  xfs: adjust the interface of xfs_qm_vop_dqalloc()
  xfs: add xfs_create_tmpfile() for O_TMPFILE support
  xfs: add a new method xfs_vn_tmpfile()
  xfs: allow linkat() on O_TMPFILE files

 fs/xfs/xfs_inode.c      |  142 ++++++++++++++++++++++++++++++++++++++++++++---
 fs/xfs/xfs_inode.h      |    2 +
 fs/xfs/xfs_ioctl.c      |    2 +-
 fs/xfs/xfs_iops.c       |   25 ++++++++-
 fs/xfs/xfs_qm.c         |   50 ++++++++++------
 fs/xfs/xfs_quota.h      |    6 +-
 fs/xfs/xfs_shared.h     |    4 +-
 fs/xfs/xfs_symlink.c    |    2 +-
 fs/xfs/xfs_trans_resv.c |   51 +++++++++++++++++
 fs/xfs/xfs_trans_resv.h |    4 +
 10 files changed, 255 insertions(+), 33 deletions(-)

-- 
1.7.6.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
