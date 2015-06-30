Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 4E87A7F7C
	for <xfs@oss.sgi.com>; Mon, 29 Jun 2015 22:25:48 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id ECB6AAC005
	for <xfs@oss.sgi.com>; Mon, 29 Jun 2015 20:25:44 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id Fehrp0FYk8aYxmjB (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 29 Jun 2015 20:25:42 -0700 (PDT)
Subject: [RFC 00/15] xfsprogs: support the reflink btree
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Mon, 29 Jun 2015 20:25:38 -0700
Message-ID: <20150630032538.572.20293.stgit@birch.djwong.org>
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

This is a RFC-quality pass at xfsprogs support for the reflink btree.
As discussed in the kernel-side patches, reflink enables XFS to map
multiple logical blocks to the same physical block.  There is a single
[block, refcount] btree to track the reference counts of extents of
physical blocks.  The xfs_db and xfs_metadump tools have been extended
to deal with the reflink btree; xfs_repair now records all reverse
mapping data for the purpose of checking and rebuilding the reflink
btree (and some day will do likewise for the rmap btree).

The patch set is based on the current (3.2.3+) for-next branch plus
Dave's rmap RFC patches for rmap (i.e. the rmap-btree branch).  The
first patch wires up xfs_io to talk to the "XFS" reflink ioctls, which
are of course the same ioctls that BTRFS uses.  These commands will be
used by the xfstests I've written to test reflink/CoW support.  There
are a couple of patches to fix up xfs_db's check functionality well
enough to support blocktrash-type fuzzing.  After that comes the
libxfs port of the kernel rlbt declarations and modifications to the
individual programs to support reflink.

I've not had time to get reflink and rmap to work together; don't
enable rmap and reflink at the same time!

This is an extraordinary way to eat your data.  Enjoy!

Comments and questions are, as always, welcome.

--D

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
