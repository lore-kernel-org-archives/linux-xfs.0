Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pB76IhMo046578 for <xfs@oss.sgi.com>; Wed, 7 Dec 2011 00:18:44 -0600
Received: from ipmail05.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8AB291305D3E
	for <xfs@oss.sgi.com>; Tue,  6 Dec 2011 22:18:41 -0800 (PST)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	0UDbz4rEBnEjmJ4l for <xfs@oss.sgi.com>;
	Tue, 06 Dec 2011 22:18:41 -0800 (PST)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1RYApz-0003nj-Gy
	for xfs@oss.sgi.com; Wed, 07 Dec 2011 17:18:39 +1100
Received: from dave by disappointment with local (Exim 4.76)
	(envelope-from <dave@disappointment.disaster>) id 1RYApp-0003UU-1l
	for xfs@oss.sgi.com; Wed, 07 Dec 2011 17:18:29 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [RFC, PATCH 0/12] xfs: compound buffers for directory blocks
Date: Wed,  7 Dec 2011 17:18:11 +1100
Message-Id: <1323238703-13198-1-git-send-email-david@fromorbit.com>
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
To: xfs@oss.sgi.com

This series is an infrastructure change needed to allow CRCs to be
easily implemented on directory blocks. Directory blocks can be
larger than filesytem blocks and are mapped like data in a file via
the inode block map btree. Hence a given directory block can be made
up of discontiguous filesystem blocks.

The current way of handling this is via the struct xfs_dabuf - a
separate structure that tracks individual struct xfs_bufs for each
discontiguous region of a directory block. This abstracts the
discontiguity away from all the directory code by hiding it behind
linear memory buffer and memcpy()ing to and from the underlying
xfs_bufs as the dabuf is created and destroyed for each directory
operation that operates in a given directory block. the struct
xfs-bufs are cached, but the dabuf is not, leading to significant
overhead in constructing, destroying and modifying large directory
buffers.

Further, because CRCs requires a single CRC for each directory
block, we need to keep the buffer in an aggregated state until we do
IO on it and can run a CRC calculation callback. With the xfs_dabuf
destroyed long before write IO occurs, there is no way to calculate
the CRC sanely.

To solve this problem we effectively need the functionality of a
xfs_dabuf in a struct xfs_buf. That is, an xfs-buf needs to be able
to map a discontiguous block range and aggregate all the IO needed
to read and write such a discontiguous buffer. Further, the buffer
logging need to support discontiguous ranges as well, and translate
the in-memory new construct into the existing individual discontigous
buffer log format.

To do this, the xfs_buf has a block vector array added to it,
similar in concept to the page array. When IO is issued, it issues
separate Io for each vector in the block array, building the IO
appropriately from the page array. In this way, we avoid the need
for a separate memory buffer for the directory code to work on - it
can work directly on the vmapped buffer address. hence we remove two
memcpy()s from each large directory block modification. Adding a io
count for each vector means that the current method of dispatching,
completing and waiting for IO is unchanged.

Further, by modifying the buffer item formatting to deal with
discontiguous buffers, we remove the need for the xfs_dabuf to
interpose to select the correct xfs_buf to record the changes to.
This means that compound buffers can be used completely
transparently throughout the existing XFS codebase (not just the
directory code) without any modification.

To build compound buffers, we need some method of specifying the
block map. We already have a structure for this - the struct
xfs_bmbt_irec, which is what xfs_bmapi_*() uses and is the native
format for maps in the directory code. hence it makes sense to pass
these into the buffer cache as a method of specifying discontiguous
block ranges.

It makes further sense to use struct xfs_bmbt_irec as the internal
representation of block ranges for all the buffer interfaces, but
this requires one extension. That is, the bmbt format currently only
supports filesystem block sized units (FSB) and metadata requires
sector (disk) addressing (DADDR) units. This is easily handled by
adding a new state value that is held in the xfs_bmbt_irec.br_state
field to indicate what unit the xfs_bmbt_irec map is encoded in.
With this, the irec format can be used throughout the buffer
interfaces to support discontiguous buffers everywhere.

Finally, with al these changes, the struct xfs_dabuf is not
necessary anymore, so can be removed.

The series passes xfstests on 4k/4k, 4k/512b, 64k/4k and 64k/512b
(dirblksz/fsblksz) configurations without any new regressions, and
survives 100 million inode fs_mark benchmarks on a 17TB filesystem
using 4k/4k, 64k/512b and 64k/512b configurations.

Some of the series is a bit verbose - code is rearranged a couple of
times to suite testing step by step (e.g. duplicate code in the
patch that introduces a new interface, factor the duplication back
out in a later patch), so could probably be done neater. However,
I'd prefer not to have to redo the entire series to avoid this
if the end result is substantially identical code - it's time
consuming to make sure each patch doesn't break stuff and I'd like
to try to get this into 3.3 so I can focus on the real goal (CRC
support) ASAP.

Comments, flames and ridicule all welcome. :)

Cheers,

Dave.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
