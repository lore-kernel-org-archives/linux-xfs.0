Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q7OH4FJE062595 for <xfs@oss.sgi.com>; Fri, 24 Aug 2012 12:04:15 -0500
Subject: [GIT PULL] XFS update for 3.6-rc4
Message-Id: <20120824170459.85A444266DC@whiskey.americas.sgi.com>
Date: Fri, 24 Aug 2012 12:04:59 -0500 (CDT)
From: bpm@sgi.com (Ben Myers)
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: torvalds@linux-foundation.org
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

Hi Linus,

   Please pull these 2 bugfixes and a regression fix for XFS.  Here we have a
   fix for a possible overlow in trim code, a fix for an uninitialised
   variable, and a fix for a regression in the v3.6-rc1 XFS merge.

Thanks,
       Ben	

The following changes since commit 0d7614f09c1ebdbaa1599a5aba7593f147bf96ee:

  Linux 3.6-rc1 (2012-08-02 16:38:10 -0700)

are available in the git repository at:

  git://oss.sgi.com/xfs/xfs tags/for-linus-v3.6-rc4

for you to fetch changes up to a672e1be30d5bc848cd0067c55ed29b2015b7c17:

  xfs: check for possible overflow in xfs_ioc_trim (2012-08-23 14:48:44 -0500)

----------------------------------------------------------------
xfs: bugfixes for 3.6-rc4

- fix uninitialised variable in xfs_rtbuf_get()
- unlock the AGI buffer when looping in xfs_dialloc
- check for possible overflow in xfs_ioc_trim

----------------------------------------------------------------
Christoph Hellwig (1):
      xfs: unlock the AGI buffer when looping in xfs_dialloc

Dave Chinner (1):
      xfs: fix uninitialised variable in xfs_rtbuf_get()

Tomas Racek (1):
      xfs: check for possible overflow in xfs_ioc_trim

 fs/xfs/xfs_discard.c |  6 ++++--
 fs/xfs/xfs_ialloc.c  | 17 +++++++++--------
 fs/xfs/xfs_rtalloc.c |  2 +-
 3 files changed, 14 insertions(+), 11 deletions(-)

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
