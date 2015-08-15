Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 24A0D7F37
	for <xfs@oss.sgi.com>; Fri, 14 Aug 2015 20:43:47 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id EA1218F8033
	for <xfs@oss.sgi.com>; Fri, 14 Aug 2015 18:43:43 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id EUz80Pe2D5s6zzNy (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 14 Aug 2015 18:43:42 -0700 (PDT)
Subject: [PATCH 00/10] xfsprogs August 2015 patchbomb
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 14 Aug 2015 18:43:38 -0700
Message-ID: <20150815014338.1839.37405.stgit@birch.djwong.org>
MIME-Version: 1.0
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
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: xfs@oss.sgi.com

Hi all,

This is a rollup of various fixes for xfsprogs 4.2.0-rc1.

The first patch fixes the dir3 data block verifier to use the standard
read verifiers during readahead.  Just a resync with the kernel, since
nothing in xfsprogs uses libxfs readahead.

The second patch fixes xfs_db's inode command not to crash when the
user tries to navigate to a corrupt inode.

The third patch fixes a bug in xfs_repair wherein if xfs_repair fixes
a broken xattr block and later decides to unmap the block, the
"repaired" flag inadvertently prohibits the unmapping of that block.

The fourth patch fixes sign handling mistakes when dealing with the
b_error field in a xfs_buf -- error values in this field are negative,
so all checks and assignments must be as well.

The fifth patch forces prefetch to mark corrupt bmbt blocks UNCHECKED
so that the regular bmbt examination will fix the bad CRC if it
doesn't take any other action against the block.  Without this, a
corruption in the unused area will trigger a kernel error yet never
get fixed by repair.

The sixth patch fixes an obscure problem in xfs_repair -- when
prefetch is enabled and there exists a directory with multiple
corrupted blocks, it's possible that both corrupt blocks will be read
in and marked UNCHECKED.  If either the first corrupt block is so
badly damaged so as to cause the directory to be erased, or if the
second corrupt block is an index block (which is automatically
unmapped when the directory is rebuilt), the second block's buffer
will remain UNCHECKED.  If the block is then allocated to something
else (say lost+found), the next readbuf of the block will fail because
nobody clears UNCHECKED and CRCs are only set during writebufr, which
only happens when repair finishes its examination.

Patch 7 implements a 'reflink' and 'dedupe' command in xfs_io.  This
will be used in future xfstests to test reflink and dedupe features of
btrfs and xfs filesystems.

Patch 8 fixes xfs_db/blocktrash to not fail write verification when
corrupting a block and allows trashing of log and symlink blocks.

Patch 9 enhances the blocktrash command with a '-z' option that
trashes the block at the top of the cursor stack and doesn't require
blockget to have been run.

Patch 10 implements blockget for v5 filesystems.  This is a second try
at a previous patch which didn't quite catch all the new magic numbers
and had some problems iterating directory index data.

I've tested these xfsprogs changes against the for-next branch as of
8/03.  The rmap/reflink patches will be dealt with separately.

Scary rewound github repo with everything attached:
https://github.com/djwong/xfsprogs

Comments and questions are, as always, welcome.

--D

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
