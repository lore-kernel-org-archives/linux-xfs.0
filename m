Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 810147F3F
	for <xfs@oss.sgi.com>; Fri, 10 Jan 2014 13:04:10 -0600 (CST)
Subject: [GIT PULL] XFS bugfixes for 3.13-rc8
Message-Id: <20140110190406.DAB254266DC@whiskey.americas.sgi.com>
Date: Fri, 10 Jan 2014 13:04:06 -0600 (CST)
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: torvalds@linux-foundation.org
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

Hi Linus,

Please pull these fixes for XFS.  Here we have a bugfix for an
off-by-one in the remote attribute verifier that results in a forced
shutdown which you can hit with v5 superblock by creating a 64k xattr,
and a fix for a missing destroy_work_on_stack() in the allocation
worker.  It's a bit late, but they are both fairly straightforward.

Thanks,
	Ben

The following changes since commit ac8809f9ab01a73de1a47b5a37bd8dcca8712fb3:

  xfs: abort metadata writeback on permanent errors (2013-12-17 09:40:23 -0600)

are available in the git repository at:

  git://oss.sgi.com/xfs/xfs.git tags/xfs-for-linus-v3.13-rc8

for you to fetch changes up to 1f4a63bf019524c96e79f088cd717b96ef00a249:

  xfs: Calling destroy_work_on_stack() to pair with INIT_WORK_ONSTACK() (2014-01-10 12:39:38 -0600)

----------------------------------------------------------------
xfs: bugfixes for 3.13-rc8

- fix off-by-one in xfs_attr3_rmt_verify
- fix missing destroy_work_on_stack() in xfs_bmapi_allocate

----------------------------------------------------------------
Chuansheng Liu (1):
      xfs: Calling destroy_work_on_stack() to pair with INIT_WORK_ONSTACK()

Jie Liu (1):
      xfs: fix off-by-one error in xfs_attr3_rmt_verify

 fs/xfs/xfs_attr_remote.c | 2 +-
 fs/xfs/xfs_bmap_util.c   | 1 +
 2 files changed, 2 insertions(+), 1 deletion(-)

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
