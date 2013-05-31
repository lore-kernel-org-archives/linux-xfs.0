Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 941417F37
	for <xfs@oss.sgi.com>; Fri, 31 May 2013 16:03:07 -0500 (CDT)
Subject: [GIT PULL] XFS fixes #2 for 3.10-rc4
Message-Id: <20130531210303.EDAE1500B4B@whiskey.americas.sgi.com>
Date: Fri, 31 May 2013 16:03:03 -0500 (CDT)
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

   Please pull these fixes for XFS.  Here are several fixes that are relevant
   on CRC enabled XFS filesystems.  They are followed by a rework of the remote
   attribute code so that each block of the attribute contains a header with a
   CRC.  Previously there was a CRC header per extent in the remote attribute
   code, but this was untenable because it was not possible to know how many
   extents would be allocated for the attribute until after the allocation has
   completed, due to the fragmentation of free space.  This became complicated
   because the size of the headers needs to be added to the length of the
   payload to get the overall length required for the allocation.  With a
   header per block, things are less complicated at the cost of a little space.  

   I would have preferred to defer this and the rest of the CRC queue to 3.11
   to mitigate risk for existing non-crc users in 3.10.  Doing so would require
   setting a feature bit for the on-disk changes, and so I have been pressured
   into sending this pull request by Eric Sandeen and David Chinner from Red
   Hat.  I'll send another pull request or two with the rest of the CRC queue
   next week.

Thanks,
     Ben	
   
The following changes since commit e400d27d1690d609f203f2d7d8efebc98cbc3089:

  xfs: fix dir3 freespace block corruption (2013-05-30 17:22:54 -0500)

are available in the git repository at:

  git://oss.sgi.com/xfs/xfs tags/for-linus-v3.10-rc4-crc-xattr-fixes

for you to fetch changes up to 7bc0dc271e494e12be3afd3c6431e5216347c624:

  xfs: rework remote attr CRCs (2013-05-30 17:26:31 -0500)

----------------------------------------------------------------
xfs: extended attribute fixes for CRCs

- Remove assert on count of remote attribute CRC headers
- Fix the number of blocks read in for remote attributes
- Zero remote attribute tails properly
- Fix mapping of remote attribute buffers to have correct length
- initialize temp leaf properly in xfs_attr3_leaf_unbalance, and
  xfs_attr3_leaf_compact
- Rework remote atttributes to have a header per block

----------------------------------------------------------------
Dave Chinner (7):
      xfs: remote attribute allocation may be contiguous
      xfs: remote attribute read too short
      xfs: remote attribute tail zeroing does too much
      xfs: correctly map remote attr buffers during removal
      xfs: fully initialise temp leaf in xfs_attr3_leaf_unbalance
      xfs: fully initialise temp leaf in xfs_attr3_leaf_compact
      xfs: rework remote attr CRCs

 fs/xfs/xfs_attr_leaf.c   |  71 ++++++---
 fs/xfs/xfs_attr_remote.c | 408 +++++++++++++++++++++++++++++------------------
 fs/xfs/xfs_attr_remote.h |  10 ++
 fs/xfs/xfs_buf.c         |   1 +
 4 files changed, 307 insertions(+), 183 deletions(-)

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
