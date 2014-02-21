Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 1B3497FA6
	for <xfs@oss.sgi.com>; Fri, 21 Feb 2014 16:59:53 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 00C0C8F8050
	for <xfs@oss.sgi.com>; Fri, 21 Feb 2014 14:59:49 -0800 (PST)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	ru4AlKCZi8oJSxoL for <xfs@oss.sgi.com>;
	Fri, 21 Feb 2014 14:59:47 -0800 (PST)
Date: Sat, 22 Feb 2014 09:59:43 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [GIT PULL] xfs: fixes for 3.14-rc3
Message-ID: <20140221225943.GR13647@dastard>
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
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com

Hi Linus,

This is the first pull request I've had to do for you, so I'm still
sorting things out. The reason I'm sending this and not Ben should
be obvious from the first commit below - SGI has stepped down from
the XFS maintainership role. As such, I'd like to take another
opportunity to thank them for their many years of effort maintaining
XFS and supporting the XFS community that they developed from the
ground up.

So I haven't had time to work things like signed tags into my
workflows yet, so this is just a repo branch I'm asking you to pull
from. And yes, I named the branch -rc4 because I wanted the fixes in
-rc4, not because the branch was for merging into -rc3. Probably not
right, either.

Anyway, I should have everything sorted out by the time the next
merge window comes around. If there's anything that you don't like
in the pull req, feel free to flame me unmercifully.

The changes are fixes for recent regressions and important thinkos
in verification code:

	- a log vector buffer alignment issue on ia32
	- timestamps on truncate got mangled
	- primary superblock CRC validation fixes and error message
	  sanitisation

Cheers,

Dave.

The following changes since commit 38dbfb59d1175ef458d006556061adeaa8751b72:

  Linus 3.14-rc1 (2014-02-02 16:42:13 -0800)

are available in the git repository at:

  git://oss.sgi.com/xfs/xfs.git xfs-fixes-for-3.14-rc4

for you to fetch changes up to 5ef11eb0700f806c4671ba33e5befa784a2f70ef:

  xfs: limit superblock corruption errors to actual corruption (2014-02-19 15:39:35 +1100)

----------------------------------------------------------------
Ben Myers (1):
      MAINTAINERS: SGI no longer maintaining XFS

Christoph Hellwig (1):
      xfs: ensure correct timestamp updates from truncate

Dave Chinner (1):
      xfs: ensure correct log item buffer alignment

Eric Sandeen (3):
      xfs: xfs_sb_read_verify() doesn't flag bad crcs on primary sb
      xfs: skip verification on initial "guess" superblock read
      xfs: limit superblock corruption errors to actual corruption

 MAINTAINERS          |    1 -
 fs/xfs/xfs_iops.c    |   16 ++++++++--------
 fs/xfs/xfs_log_cil.c |   19 +++++++++++++++----
 fs/xfs/xfs_mount.c   |   24 ++++++++++++++++--------
 fs/xfs/xfs_sb.c      |   10 ++++------
 5 files changed, 43 insertions(+), 27 deletions(-)
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
