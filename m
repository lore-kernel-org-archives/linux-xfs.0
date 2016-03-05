Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id A495A7CA1
	for <xfs@oss.sgi.com>; Fri,  4 Mar 2016 18:35:39 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 692DA8F8035
	for <xfs@oss.sgi.com>; Fri,  4 Mar 2016 16:35:39 -0800 (PST)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id 4d4kjPPqT4FPdTkd (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 04 Mar 2016 16:35:37 -0800 (PST)
Subject: [PATCH v5 0/6] xfs-docs: reorganize chapters,
	refcountbt and rmapbt chapters update
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 04 Mar 2016 16:35:05 -0800
Message-ID: <20160305003505.28327.95288.stgit@birch.djwong.org>
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

This is part of the fifth revision of a patchset for adding support to
XFS for tracking reverse-mappings of physical blocks to file and
metadata; and support for mapping multiple file logical blocks to the
same physical block, more commonly known as reflinking.

This patch set does the following:

 * Adds a chapter discussing the importance of thoroughly testing new
   disk format changes with xfstests, and how to find the source code.

 * Adds in all the disk format changes for Linux 4.5.

 * Separates the btree sections into a separate chapter about the
   generic btree structure, and adds a section about the new support
   for overlapped interval records.

 * Adds chapters discussing reflink, the reference count btree, and
 * the reserve-mapping btree.

The patch set is based on the current master branch of xfs-docs[1].
Comments and questions are, as always, welcome.

--D

[1] https://github.com/djwong/xfs-documentation/tree/reflink-devel

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
