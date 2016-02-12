Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 444347CA3
	for <xfs@oss.sgi.com>; Thu, 11 Feb 2016 21:44:00 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id C8E09AC006
	for <xfs@oss.sgi.com>; Thu, 11 Feb 2016 19:43:59 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	udpq71rQopcUbDlk for <xfs@oss.sgi.com>;
	Thu, 11 Feb 2016 19:43:57 -0800 (PST)
Date: Fri, 12 Feb 2016 14:43:19 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [GIT PULL] xfs: fixes for 4.5-rc4
Message-ID: <20160212034319.GW14668@dastard>
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

Can you please pull the XFS commit from the tag below? It contains a
fix for a regression introduced in 4.5-rc1 by the new log recovery
CRC validation code. Thanks!

-Dave.

The following changes since commit 36f90b0a2ddd60823fe193a85e60ff1906c2a9b3:

  Linux 4.5-rc2 (2016-01-31 18:12:16 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/dgc/linux-xfs.git tags/xfs-fixes-for-linus-4.5

for you to fetch changes up to 8e0bd4925bf693520295de403483efad4dc5cc16:

  xfs: fix endianness error when checking log block crc on big endian platforms (2016-02-08 11:03:58 +1100)

----------------------------------------------------------------
xfs: updates for 4.5-rc4

Contains:
o fix for endian conversion issue in new CRC validation in
  log recovery that was discovered on a ppc64 platform.

----------------------------------------------------------------
Darrick J. Wong (1):
      xfs: fix endianness error when checking log block crc on big endian platforms

 fs/xfs/xfs_log_recover.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
