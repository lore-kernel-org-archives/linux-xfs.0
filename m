Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id EB5A27F37
	for <xfs@oss.sgi.com>; Tue,  6 Oct 2015 23:54:52 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id DC755304032
	for <xfs@oss.sgi.com>; Tue,  6 Oct 2015 21:54:49 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id jRuT0udRt1pQOENw (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 06 Oct 2015 21:54:47 -0700 (PDT)
Subject: [RFCv3 00/58] xfs: add reverse-mapping, reflink, and dedupe support
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 06 Oct 2015 21:54:44 -0700
Message-ID: <20151007045443.30457.47038.stgit@birch.djwong.org>
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
Cc: linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com

Hi all,

This is the third revision of an RFC for adding to XFS kernel support
for tracking reverse-mappings of physical blocks to file and metadata;
and support for mapping multiple file logical blocks to the same
physical block, more commonly known as reflinking.  Given the
significant amount of re-engineering required to make the initial rmap
implementation compatible with reflink, I decided to publish both
features as an integrated patchset off of upstream.  This means that
rmap and reflink are now compatible with each other.

Dave Chinner's initial rmap implementation featured a simple b+tree
containing (_physical_block_, blockcount, owner) records and enough
code to stuff the rmap btree (rmapbt) whenever a block was allocated
or freed.  However, a generic reflink implementation requires the
ability to map a block to any logical block offset in any file.
Therefore it is necessary to expand the rmapbt record definition to be
(_physical block_, _owner_, _offset_, blockcount) to maintain uniquely
identifiable records.  The upper two bits of the offset field are used
to flag attr fork records and bmbt block records, respectively.  The
highest bit of the blockcount is used to indicate an unwritten extent.
It is intended that in the future the rmapbt will some day be used to
reconstruct a corrupt block map btree (bmbt).

The reflink implementation features a simple b+tree containing
(_physical block_, blockcount, refcount) records to track the
reference counts of extents of physical blocks.  There's also support
code to provide the desired copy-on-write behavior and the userland
interfaces to reflink, query the status of, and a new fallocate mode
to un-reflink parts of files.

For single-owner blocks (i.e. metadata) the rmapbt records are still
managed at alloc/free time.  To enable reflink and rmap at the same
time, however, it becomes necessary to manage rmapbt records for file
extents at map/unmap time.  In the current implementation, file extent
records exactly mirror bmbt contents.  It should be easy to merge
file extent rmaps on non-reflink filesystems, but that is not yet
written.  In theory merging can happen for file extent rmaps on
reflink filesystems too, but that could involve a lot of searching
through the tree since records are not indexed on the last physical
block of the extent.

The ioctl interface to XFS reflink looks surprisingly like the btrfs
ioctl interface -- you can reflink a file, reflink subranges
of a file, or dedupe subranges of files.  To un-reflink a file, I'm
proposing a new fallocate flag which will (try to) fork all shared
blocks within a certain file range.  xfs_fsr is a better candidate
for de-reflinking a file since it also defragments the file; the
extent swap ioctl has also been upgraded (crappily) to support
updating the rmapbt as needed.

The patch set is based on the current (4.3-rc4) upstream kernel.
There are plenty of bugs in this code; in particular the copy-on-write
code is still terrible and prone to all sorts of amusing crashes.
There are too many patches to discuss individually, but they are
grouped by subject area:

0. Cleanups
1. rmapbt support
2. Re-engineering rmapbt to support reflink
3. refcntbt support
4. Implement the data block sharing pieces of reflink

Issues: 

 * The toy CoW implementation exists as a single-threaded workqueue(!)
In talking with Dave Chinner, I get the sense that he sees CoW as a a
natural extension of a reworked XFS write path that doesn't use buffer
heads.  That work hasn't landed, so I've only put enough effort into
fixing the CoW so that it can (barely) pass the associated xfstests.
In the future, a CoW block being written would simply become a
delalloc extent and the process of allocating the delalloc extent
would merely have to know to unmap whatever's there first.

 * The extent swapping ioctl now allocates a bigger fixed-size
transaction.  That's most likely a stupid thing to do, so getting a
better grip on how the journalling code works and auditing all the new
transaction users will have to happen.  Right now it mostly gets
lucky.

 * Don't ENOSPC.  This should get fixed up once we start using delalloc.

 * We'll want to connect to copy_file_range when it appears in a
kernel release some time.

If you're going to start using this mess, you probably ought to just
pull from my github trees for kernel[1], xfsprogs[2], and xfstests[3].

This is an extraordinary way to eat your data.  Enjoy!

Comments and questions are, as always, welcome.

--D

[1] https://github.com/djwong/linux-xfs-dev/commits/master
[2] https://github.com/djwong/xfsprogs/commits/for-next
[3] https://github.com/djwong/xfstests/commits/master

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
