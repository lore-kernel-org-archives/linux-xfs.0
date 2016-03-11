Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 382647CA0
	for <xfs@oss.sgi.com>; Thu, 10 Mar 2016 18:23:43 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id DF040304051
	for <xfs@oss.sgi.com>; Thu, 10 Mar 2016 16:23:42 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	lsOSBBswJelF1UUR for <xfs@oss.sgi.com>;
	Thu, 10 Mar 2016 16:23:39 -0800 (PST)
Date: Fri, 11 Mar 2016 11:23:23 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [GIT PULL v2] xfs: fixes for 4.5-rc7 
Message-ID: <20160311002323.GB11812@dastard>
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

[v2 - now with correct cc list. Sorry for the dup, Linus]

Hi Linus,

Can you please pull the XFS fixes from the tag below? This is a fix
for a regression introduced in 4.5-rc1 by the new torn log write
detection code. The regression only affects people moving a clean
filesystem between machines/kernels of different architecture (such
as changing between 32 bit and 64 bit kernels), but this is the
recommended (and only!) safe way to migrate a filesystem between
architectures so we really need to ensure it works.

The changes are larger than I'd prefer right at the end of the
release cycle, but the majority of the change is just factoring
code to enable the detection of a clean log at the correct time to
avoid this issue.

Thanks!

-Dave.

The following changes since commit 36f90b0a2ddd60823fe193a85e60ff1906c2a9b3:

  Linux 4.5-rc2 (2016-01-31 18:12:16 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/dgc/linux-xfs.git tags/xfs-for-linus-4.5-rc7

for you to fetch changes up to 7f6aff3a29b08fc4234c8136eb1ac31b4897522c:

  xfs: only run torn log write detection on dirty logs (2016-03-07 08:22:22 +1100)

----------------------------------------------------------------
xfs: fixes for 4.5-rc7

Changes:

o Only perform torn log write detection on dirty logs. This prevents
  failures being detected due to a clean filesystem being moved
  between machines or kernels of different architectures (e.g. 32
  -> 64 bit, BE -> LE, etc). This fixes a regression introduced by
  the torn log write detection in 4.5-rc1.

----------------------------------------------------------------
Brian Foster (4):
      xfs: separate log head record discovery from verification
      xfs: refactor unmount record detection into helper
      xfs: refactor in-core log state update to helper
      xfs: only run torn log write detection on dirty logs

 fs/xfs/xfs_log_recover.c |  271 ++++++++++++++++++++++++++++------------------
 1 file changed, 168 insertions(+), 103 deletions(-)
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
