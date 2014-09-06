Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id B5E5C7F3F
	for <xfs@oss.sgi.com>; Fri,  5 Sep 2014 19:07:20 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 94F168F8049
	for <xfs@oss.sgi.com>; Fri,  5 Sep 2014 17:07:17 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	QtFNWSZtAdCndWir for <xfs@oss.sgi.com>;
	Fri, 05 Sep 2014 17:07:15 -0700 (PDT)
Date: Sat, 6 Sep 2014 10:07:11 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [GIT PULL] xfs: fixes for 3.17-rc3
Message-ID: <20140906000711.GX20518@dastard>
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

Can you please pull the following XFS fixes? The fixes all address
recently discovered data corruption issues. The original Direct IO
issue was discovered by Chris Mason @ Facebook on a production
workload which mixed buffered reads with direct reads and writes IO
to the same file. The fix for that exposed other issues with page
invalidation (exposed by millions of fsx operations) failing due to
dirty buffers beyond EOF.

Finally, the collapse_range code could also cause problems due to
racing writeback changing the extent map while it was being shifted
around. The commits for that problem are simple mitigation fixes
that prevent the problem from occuring. A more robust fix for 3.18
that addresses the underlying problem is currently being worked on
by Brian.

-Dave.

The following changes since commit 52addcf9d6669fa439387610bc65c92fa0980cef:

  Linux 3.17-rc2 (2014-08-25 15:36:20 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/dgc/linux-xfs tags/xfs-for-linus-3.17-rc3

for you to fetch changes up to 41b9d7263ea1e270019c5d04fa0ab15db50b9725:

  xfs: trim eofblocks before collapse range (2014-09-02 12:12:53 +1000)

----------------------------------------------------------------
xfs: fixes for v3.17-rc3

Fix:
- a direct IO read/buffered read data corruption
- the associated fallout from the DIO data corruption fix
- collapse range bugs that are potential data corruption issues.

----------------------------------------------------------------
Brian Foster (2):
      xfs: don't log inode unless extent shift makes extent modifications
      xfs: trim eofblocks before collapse range

Chris Mason (1):
      xfs: don't zero partial page cache pages during O_DIRECT writes

Dave Chinner (4):
      xfs: don't dirty buffers beyond EOF
      xfs: don't zero partial page cache pages during O_DIRECT writes
      xfs: use ranged writeback and invalidation for direct IO
      xfs: xfs_file_collapse_range is delalloc challenged

 fs/xfs/libxfs/xfs_bmap.c |   18 ++++++++------
 fs/xfs/xfs_aops.c        |   61 ++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_bmap_util.c   |   20 +++++++++++++++
 fs/xfs/xfs_file.c        |   27 +++++++++++++++++---
 4 files changed, 114 insertions(+), 12 deletions(-)

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
