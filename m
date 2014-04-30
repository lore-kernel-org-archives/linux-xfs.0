Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id EA64029DF9
	for <xfs@oss.sgi.com>; Wed, 30 Apr 2014 09:02:18 -0500 (CDT)
Received: from eagdhcp-232-128.americas.sgi.com
	(eagdhcp-232-128.americas.sgi.com [128.162.232.128])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 81408AC008
	for <xfs@oss.sgi.com>; Wed, 30 Apr 2014 07:02:15 -0700 (PDT)
Received: from eagdhcp-232-128.americas.sgi.com (localhost [127.0.0.1])
	by eagdhcp-232-128.americas.sgi.com (8.14.5/8.14.5) with ESMTP id
	s3UE2DZ4007720
	for <xfs@oss.sgi.com>; Wed, 30 Apr 2014 09:02:13 -0500 (CDT)
	(envelope-from tinguely@eagdhcp-232-128.americas.sgi.com)
Message-Id: <20140430134844.924376330@sgi.com>
Date: Wed, 30 Apr 2014 08:48:44 -0500
From: Mark Tinguely <tinguely@sgi.com>
Subject: [PATCH 0/2] xfsprog: fix xfs_inode lifetime issue
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

These patches clean up the xfs(_trans)_iput() and fix the
xfs_inode life time so that inodes with a extended attribute
fork can add an attributes.

Patch 1	removes the unused argument in _iput routines and
	introduces the IRELSE define for xfs_iput().
Patch 2 fixes the xfs_inode lifetime problem.

Mark.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
