Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 3CF3B7F52
	for <xfs@oss.sgi.com>; Thu,  8 May 2014 16:12:28 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 151658F8040
	for <xfs@oss.sgi.com>; Thu,  8 May 2014 14:12:24 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	rfcQJbaQE1l45HRp for <xfs@oss.sgi.com>;
	Thu, 08 May 2014 14:12:19 -0700 (PDT)
Date: Fri, 9 May 2014 07:12:17 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [GIT PULL] xfs: fixes for 3.15-rc5
Message-ID: <20140508211217.GC26353@dastard>
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

Can you please pull the updates listed below? The main fix is adding
support for default ACLs on O_TMPFILE opened inodes to bring XFS into
line with other filesystems. Metadata CRCs are now also considered
well enough tested to be fully supported, so we're removing the
shouty warnings issued at mount time for filesystems with that
format. And there's transaction block reservation overrun fix.

BTW, will GPG signing these pull requests cause you problems? I've
been signing everything "official" I send as the XFS maintainer
(e.g. notifications of tree updates) and I figured that pull
requests are about as "official" as it gets. The tag is signed, so
I'm not particularly worried either way...

-Dave.

The following changes since commit 330033d697ed8d296fa52b5303db9d802ad901cc:

  xfs: fix tmpfile/selinux deadlock and initialize security (2014-04-17 08:15:30 +1000)

are available in the git repository at:

  git://oss.sgi.com/xfs/xfs.git xfs-fixes-for-3.15-rc5

for you to fetch changes up to 8275cdd0e7ac550dcce2b3ef6d2fb3b808c1ae59:

  xfs: remote attribute overwrite causes transaction overrun (2014-05-06 07:37:31 +1000)

----------------------------------------------------------------
Fixes for 3.15-rc5:
- fix a remote attribute size calculation bug that leads to a
  transaction overrun
- add default ACLs to O_TMPFILE files
- Remove the EXPERIMENTAL tag from filesystems with metadata CRC
  support

----------------------------------------------------------------
Brian Foster (1):
      xfs: initialize default acls for ->tmpfile()

Dave Chinner (2):
      xfs: fully support v5 format filesystems
      xfs: remote attribute overwrite causes transaction overrun

 fs/xfs/xfs_attr.c        |   24 +++++++++++++++++++-
 fs/xfs/xfs_attr_leaf.c   |   21 +++++++++---------
 fs/xfs/xfs_attr_list.c   |    1 +
 fs/xfs/xfs_attr_remote.c |    8 ++++---
 fs/xfs/xfs_da_btree.h    |    2 ++
 fs/xfs/xfs_iops.c        |   55 ++++++++++++++++++++++++----------------------
 fs/xfs/xfs_log.c         |   10 +++++----
 fs/xfs/xfs_mount.c       |    2 --
 fs/xfs/xfs_sb.c          |    4 ----
 9 files changed, 77 insertions(+), 50 deletions(-)
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
