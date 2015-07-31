Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id A22147F6C
	for <xfs@oss.sgi.com>; Thu, 30 Jul 2015 21:08:07 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 3D8D4AC004
	for <xfs@oss.sgi.com>; Thu, 30 Jul 2015 19:08:03 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	VAVfGUHWJQjitE6c for <xfs@oss.sgi.com>;
	Thu, 30 Jul 2015 19:07:57 -0700 (PDT)
Date: Fri, 31 Jul 2015 12:03:29 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [GIT PULL] xfs: updates for 4.2-rc4
Message-ID: <20150731020329.GO16638@dastard>
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
To: torvalds@linux-foundation.org
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

Hi Linus,

Can you please pull the XFS fixes from the tag below? There are a
couple of recently found, long standing remote attribute corruption
fixes caused by log recovery getting confused after a crash, and the
new DAX code in XFS (merged in 4.2-rc1) needs to actually use the
DAX fault path on read faults.

Thanks!

-Dave.

The following changes since commit bc0195aad0daa2ad5b0d76cce22b167bc3435590:

  Linux 4.2-rc2 (2015-07-12 15:10:30 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/dgc/linux-xfs.git tags/xfs-for-linus-4.2-rc4

for you to fetch changes up to df150ed102baa0e78c06e08e975dfb47147dd677:

  xfs: remote attributes need to be considered data (2015-07-29 11:48:02 +1000)

----------------------------------------------------------------
xfs: updates for 4.2-rc4

- remote attribute log recovery corruption fixes
- DAX page faults need to use direct mappings, not a page cache
  mapping.

----------------------------------------------------------------
Dave Chinner (3):
      xfs: call dax_fault on read page faults for DAX
      xfs: remote attribute headers contain an invalid LSN
      xfs: remote attributes need to be considered data

 fs/dax.c                        |   14 +++++++++++--
 fs/xfs/libxfs/xfs_attr_remote.c |   44 ++++++++++++++++++++++++++++++---------
 fs/xfs/xfs_file.c               |   21 +++++++++++++------
 fs/xfs/xfs_log_recover.c        |   11 +++++++---
 4 files changed, 69 insertions(+), 21 deletions(-)
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
