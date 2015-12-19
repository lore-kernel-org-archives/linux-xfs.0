Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 5167829EA8
	for <xfs@oss.sgi.com>; Sat, 19 Dec 2015 03:12:49 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id DB75DAC003
	for <xfs@oss.sgi.com>; Sat, 19 Dec 2015 01:12:48 -0800 (PST)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id 2GKxRulXVumQjZH6 (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Sat, 19 Dec 2015 01:12:47 -0800 (PST)
Subject: [RFCv4 00/22] xfs-documentation: massive cleanups and add v5 format,
	reverse-mapping, reflink, and dedupe support
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Sat, 19 Dec 2015 01:12:08 -0800
Message-ID: <20151219091208.15558.65013.stgit@birch.djwong.org>
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
To: hch@infradead.org, david@fromorbit.com, darrick.wong@oracle.com
Cc: xfs@oss.sgi.com

Hi all,

This is part of the third revision of an RFC for adding support to XFS
for tracking reverse-mappings of physical blocks to file and metadata;
and support for mapping multiple file logical blocks to the same
physical block, more commonly known as reflinking.  This is the first
time I've posted patches against the documentation, but they fit with
the pending RFCv4 code patches, so they're now a part of the full
suite.

This patch set does the following:

 * Cleans up leftover artifacts of the XML -> asciidoc conversion.

 * Fixes the formatting of quoted text and structure field
   definitions.

 * Fixes a lot of the strange wording in the existing documentation.

 * Replaces the screen dump PNGs with (much smaller) text sections.
   There's a huge 1.2MB patch to remove the image files as well, but
   I'll probably just send that privately to Dave later on.

 * Fills in the missing xfs_db examples and structure field
   definitions.

 * Fills in the missing realtime and journal sections.

 * Covers the new header formats for v5 filesystems.

 * Adds a magic number index.

 * Adds a brief overview of what is XFS, prior to jumping into the
   disk format.

 * Covers sparse inodes, reverse mapping btrees, reference count
   btrees and reflink.

 * Switches the xattr and directory chapters since the directory
   chapter introduces the btrees that xattrs can use.

The patch set is based on the current master branch.  As specified
eleswhere, I have git trees for the kernel[1], xfsprogs[2],
xfstests[3], xfs-docs[4], and man-pages[5].  Comments and questions
are, as always, welcome.

--D

[1] https://github.com/djwong/linux/tree/for-dave
[2] https://github.com/djwong/xfsprogs/tree/for-dave
[3] https://github.com/djwong/xfstests/tree/for-dave
[4] https://github.com/djwong/xfs-documentation/tree/for-dave
[5] https://github.com/djwong/man-pages/commits/for-mtk

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
