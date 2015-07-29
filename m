Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 5CCB87F94
	for <xfs@oss.sgi.com>; Wed, 29 Jul 2015 17:33:08 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id DB2A98F8033
	for <xfs@oss.sgi.com>; Wed, 29 Jul 2015 15:33:07 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id HjZIZDfHf4beVBqK (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 29 Jul 2015 15:33:06 -0700 (PDT)
Subject: [RFC v2 00/24] xfs: add reflink and dedupe support
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Wed, 29 Jul 2015 15:32:59 -0700
Message-ID: <20150729223258.17414.91354.stgit@birch.djwong.org>
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

This is the second revision of an RFC for adding to XFS kernel support
for mapping multiple file logical blocks to the same physical block,
more commonly known as reflinking.  The implementation a single [block
range, refcount] tree to track the reference counts of extents of
physical blocks.  There's also support code to provide the desired
copy-on-write behavior and the userland interfaces to reflink, query
the status of, and un-reflink files.

The patch set is based on the current (4.2-rc4) upstream kernel plus
Dave's reverse-map RFC patches.  There are plenty of bugs in this
code; in particular the copy-on-write code is still terrible and prone
to all sorts of amusing crashes.

To expand on that, the copy on write code is horribly broken, but I'm
posting this patchset in the hopes of getting some review of the other
pieces while I try to solve CoW.  Since "RFC(RAP)" post last month I
broke up the patches into smaller pieces, added tracepoints, and
provided longer descriptions + ASCII art of what the big algorithms
are trying to do.

What I'd like to do for CoW is to (ab|re)use the delayed allocation
code to implement copy on write.  In xfs_get_blocks we'd reserve
whatever blocks we need (or return ENOSPC to users) as in regular
delalloc; and in xfs_vm_writepage we'd use xfs_map_blocks to allocate
the forked blocks, remove the old mapping, and add in the new mapping,
which is almost what delalloc does now.  One problem I've not yet
worked around is that __block_write_begin won't call get_blocks if the
bh is already mapped, which means that we fail to make the necessary
reservations in certain cases (write file, reflink, rewrite original
file).  The current CoW patch sort of forces this to work by doing its
own reservation outside of get_blocks and delalloc, but doesn't
necessarily get it right.

At the moment, the reverse-map and reflink features are /not/
compatible.  This will be resolved soon.

The ioctl interface to XFS reflink looks surprisingly like the btrfs
ioctl interface <cough> -- you can reflink a file, reflink subranges
of a file, or dedupe subranges of files.  (Dedupe also checks file
blocks, though I have a feeling it's racy.)  To un-reflink a file,
simply chattr +C it to mark it no-cow.  xfs_fsr is a better candidate
for de-reflinking a file since it also defragments the file.

If you're going to start using this mess, you're going to want to pull
my xfsprogs dev tree[1], which itself is also based on xfsprogs
for-next and the userland rmap support bits.  I've not had time to get
reflink and rmap to work together.

I've also prepared a bunch of xfstests[2] to exercise the userland
interfaces; btrfs' reflink implementation more or less passes.

This is an extraordinary way to eat your data.  Enjoy!

Comments and questions are, as always, welcome.

--D

[1] https://github.com/djwong/xfsprogs/commits/for-next
[2] https://github.com/djwong/xfstests/commits/master

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
