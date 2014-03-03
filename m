Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id E6F2C29DF7
	for <xfs@oss.sgi.com>; Sun,  2 Mar 2014 22:43:55 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id BA765304032
	for <xfs@oss.sgi.com>; Sun,  2 Mar 2014 20:43:52 -0800 (PST)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	ODMBRdUlngXuCyCY for <xfs@oss.sgi.com>;
	Sun, 02 Mar 2014 20:43:50 -0800 (PST)
Received: from dave by dastard with local (Exim 4.80)
	(envelope-from <david@fromorbit.com>) id 1WKKjD-0002UA-BC
	for xfs@oss.sgi.com; Mon, 03 Mar 2014 15:43:47 +1100
Date: Mon, 3 Mar 2014 15:43:47 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [ANNOUNCE] xfsprogs: master branch updated to 48733b2
Message-ID: <20140303044347.GH13647@dastard>
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
To: xfs@oss.sgi.com

Hi folks,

The xfsprogs repository at git://oss.sgi.com/xfs/cmds/xfsprogs has
just been updated.

The new head of the master branch is commit:

48733b2 xfs_repair.8: Fix a grammatical error

New Commits:

Andrew Clayton (1):
      [48733b2] xfs_repair.8: Fix a grammatical error

Dave Chinner (14):
      [9718fa2] mkfs: default log size for small filesystems too large
      [0aa7d59] mkfs: proto file creation does not set ftype correctly
      [beed0dc] repair: translation lookups limit scalability
      [586f8ab] repair: per AG locks contend for cachelines
      [602dcc0] libxfs: buffer cache hashing is suboptimal
      [12b55ba] repair: limit auto-striding concurrency apprpriately
      [1177f66] repair: use a listhead for the dotdot list
      [004e18d] repair: fix prefetch queue limiting
      [1c88e98] repair: BMBT prefetch needs to be CRC aware
      [1164bde] repair: factor out threading setup code
      [71014d1] repair: prefetch runs too far ahead
      [0c6b1ca] metadump: contiguous metadata object need to be split
      [fd49185] metadump: Only verify obfuscated metadata being dumped
      [f63c754] metadump: pathname obfuscation overruns symlink buffer

Eric Sandeen (7):
      [4e11214] xfs_metadump: include F in getopts string
      [a872b62] xfs_copy: band-aids for CRC filesystems
      [a223e63] xfs_logprint: Don't error out after split items lose context
      [81c4920] xfs_logprint: don't advance op counter in xlog_print_trans_icreate
      [617c3c2] xfs_io: add missing break in O_TMPFILE case
      [ade06f8] xfs_io: test for invalid -Tr flag combination before open
      [17d7016] xfs_growfs: don't grow data if only -m is specified

Lukas Czerner (1):
      [938904c] xfs_io: add fzero command for zeroing range via fallocate


Code Diffstat:

 copy/xfs_copy.c       |  18 ++++++-
 db/io.h               |   1 +
 db/metadump.c         | 124 ++++++++++++++++++++++++++++++--------------
 db/xfs_metadump.sh    |   2 +-
 growfs/xfs_growfs.c   |   9 ++--
 include/cache.h       |   4 +-
 include/libxfs.h      |   1 +
 io/init.c             |   1 +
 io/open.c             |  10 ++--
 io/prealloc.c         |  44 +++++++++++++++-
 libxfs/cache.c        |   7 ++-
 libxfs/init.h         |   1 -
 libxfs/rdwr.c         |  12 ++++-
 logprint/log_misc.c   |   9 ++--
 man/man8/xfs_io.8     |   5 ++
 man/man8/xfs_repair.8 |   2 +-
 mkfs/proto.c          |   8 +++
 mkfs/xfs_mkfs.c       |  48 +++++++++--------
 repair/dino_chunks.c  |  24 ++++-----
 repair/dinode.c       |  55 ++++++++++++++------
 repair/dinode.h       |  18 ++++---
 repair/globals.h      |   5 +-
 repair/incore.c       |   4 +-
 repair/phase3.c       |  40 ++-------------
 repair/phase4.c       |  48 ++---------------
 repair/phase6.c       |  46 ++++++++---------
 repair/prefetch.c     | 139 +++++++++++++++++++++++++++++++++++++++++++++++++-
 repair/prefetch.h     |  10 ++++
 repair/scan.c         |  11 ++--
 repair/xfs_repair.c   |  23 ++++++++-
 30 files changed, 489 insertions(+), 240 deletions(-)
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
