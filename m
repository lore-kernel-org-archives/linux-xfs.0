Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 8ED8E7F63
	for <xfs@oss.sgi.com>; Sun, 24 Feb 2013 19:32:31 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 1B699AC001
	for <xfs@oss.sgi.com>; Sun, 24 Feb 2013 17:32:31 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	r15g8zJhjddKsxwT for <xfs@oss.sgi.com>;
	Sun, 24 Feb 2013 17:32:28 -0800 (PST)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1U9mut-0002sm-6T
	for xfs@oss.sgi.com; Mon, 25 Feb 2013 12:31:43 +1100
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1U9mus-0003Hf-S9
	for xfs@oss.sgi.com; Mon, 25 Feb 2013 12:31:42 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 00/16] xfs: metadata CRCs, second batch
Date: Mon, 25 Feb 2013 12:31:25 +1100
Message-Id: <1361755901-12453-1-git-send-email-david@fromorbit.com>
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

Hi folks,

This is the second version of the kernel support for metadata CRCs.
This builds on the first batch posted here:

http://oss.sgi.com/archives/xfs/2013-01/msg00328.html

I won't write everything I wrote in that description again, so I'll
just focus on what is new in this series:

- based on xfs_bmap.c rearrangement patch
- fixed up a couple of bugs and comments noted by Ben
- fixed a significant number of bugs, including the dquot recovery
  problem and some symlink issues on 512 byte block size
  filesystems.
- added support for directories and attributes
- moved the superblock CRC addition and enablment patch to the end
  of the series.

Things that are still missing from this version:

- remote attribute CRCs
- directory/attribute buffer type tracking for log recovery
- DT_* type fields in the directory entries
- storage of attributes larger than 256 bytes in shortform attribute
  forks.

The fact that directory/attr buffer type tracking is missing means
this code simply won't work right now with CRCs enabled. My
mainfocus so far is getting all the structural changes to the code
in place without causing regressions. In general, the directory/attr
code changes are along the lines of:

- CRC enabled directories are named as "dir3", btree nodes "da3" and
  attribute trees are "attr3".

- functions that support both attr/attr3 and dir2/dir3 types are
  renamed to attr3/dir3/da3 so it is obvious that they can support
  both types. This may not be 100% consistent through the patches
  yet - I didn't settle name change until a bit into the directory
  conversion. The directory code needs cleaning up, and will be done
  as an additional patch.

- header sizes change, so access to data types after the header need
  to be abstracted. this is done by helper functions rather tan
  direct dereference of a structure type.

- header sizes change, so that access to certain header fields need
  ot be abstracted. This is done in most cases by introducing an
  "in-core header" type and to/from disk translation functions. This
  has removed a *lot* of endian swapping from the code.

- code has been modified to use abtract access functions, and in
  some cases pass in-core headers around when child functions also
  modify headers. In some cases, logging of header has been pulled
  up into the parent functions that own the incore header
  structure.

- much of the function declarations has been reformatted to be
  consistent with the rest of the XFS code. Every time I touched a
  function name I reformatted the parameters and the local variable
  declarations inside the functions.

While the changes to the directory/attr code look complex, but
really they are mostly mechanical changes. i.e. the same change done
over and over again. There are places that I know that I've missed
changing, and these will be corrected in followup patches as I start
testing with CRCs enabled.

In terms of testing, this series passes xfstests on several machines
with 512 byte and 4k block size filesystems using existing tools
(i.e. no CRC support) without any new regressions being introduced.
It survives repeated fsmark runs on 100TB filesystems, and so seems
fairly robust when used with existing tools and filesystems.

Diffstat for the series:

$ git diff --stat 2292716..
 fs/xfs/Makefile           |    5 +-
 fs/xfs/xfs_ag.h           |   56 +-
 fs/xfs/xfs_alloc.c        |  199 +-
 fs/xfs/xfs_alloc_btree.c  |  105 +-
 fs/xfs/xfs_alloc_btree.h  |   12 +-
 fs/xfs/xfs_attr.c         |  158 +-
 fs/xfs/xfs_attr_leaf.c    | 1769 +++++----
 fs/xfs/xfs_attr_leaf.h    |  121 +-
 fs/xfs/xfs_bmap.c         | 9214 +++++++++++++++++++++++------------------------
 fs/xfs/xfs_bmap_btree.c   |  110 +-
 fs/xfs/xfs_bmap_btree.h   |   19 +-
 fs/xfs/xfs_btree.c        |  256 +-
 fs/xfs/xfs_btree.h        |   64 +-
 fs/xfs/xfs_buf_item.h     |   36 +-
 fs/xfs/xfs_da_btree.c     | 1426 +++++---
 fs/xfs/xfs_da_btree.h     |  121 +-
 fs/xfs/xfs_dinode.h       |   43 +-
 fs/xfs/xfs_dir2_block.c   |  161 +-
 fs/xfs/xfs_dir2_data.c    |  257 +-
 fs/xfs/xfs_dir2_format.h  |  249 +-
 fs/xfs/xfs_dir2_leaf.c    |  845 +++--
 fs/xfs/xfs_dir2_node.c    |  972 +++--
 fs/xfs/xfs_dir2_priv.h    |   48 +-
 fs/xfs/xfs_dquot.c        |  112 +-
 fs/xfs/xfs_file.c         |    2 +-
 fs/xfs/xfs_fsops.c        |   34 +-
 fs/xfs/xfs_ialloc.c       |   80 +-
 fs/xfs/xfs_ialloc_btree.c |   87 +-
 fs/xfs/xfs_ialloc_btree.h |    9 +-
 fs/xfs/xfs_inode.c        |  212 +-
 fs/xfs/xfs_inode.h        |   31 +-
 fs/xfs/xfs_inode_item.c   |    2 +-
 fs/xfs/xfs_log_recover.c  |  118 +-
 fs/xfs/xfs_mount.c        |   97 +-
 fs/xfs/xfs_mount.h        |    1 +
 fs/xfs/xfs_qm.c           |   23 +-
 fs/xfs/xfs_qm.h           |    2 +
 fs/xfs/xfs_quota.h        |   11 +-
 fs/xfs/xfs_sb.h           |  100 +-
 fs/xfs/xfs_trace.c        |    2 +-
 fs/xfs/xfs_trans.h        |    2 +
 fs/xfs/xfs_trans_buf.c    |   34 +-
 fs/xfs/xfs_vnodeops.c     |  480 +--
 43 files changed, 9830 insertions(+), 7855 deletions(-)

So you can see most of the change is in xfs_bmap.c and the directory
code. Without the first xfs_bmap.c patch, it is about half that size
and the majority comes from the directory and attribute changes.

43 files changed, 5315 insertions(+), 3206 deletions(-)

Reviews, testing, etc. welcome!

Cheers,

Dave.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
