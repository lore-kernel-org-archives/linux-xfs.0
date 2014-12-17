Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id E1A5A7F3F
	for <xfs@oss.sgi.com>; Wed, 17 Dec 2014 12:13:08 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id D00BF8F8033
	for <xfs@oss.sgi.com>; Wed, 17 Dec 2014 10:13:08 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id KCGAukXyYCeyu30G (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 17 Dec 2014 10:13:07 -0800 (PST)
Received: from int-mx10.intmail.prod.int.phx2.redhat.com
	(int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id sBHID6n7011509
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256
	verify=FAIL) for <xfs@oss.sgi.com>; Wed, 17 Dec 2014 13:13:06 -0500
Received: from lenovo-rd230-04.lab.bos.redhat.com
	(lenovo-rd230-04.lab.bos.redhat.com [10.16.42.190])
	by int-mx10.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id sBHID6Ko019215
	for <xfs@oss.sgi.com>; Wed, 17 Dec 2014 13:13:06 -0500
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: [PATCH 0/2] Add support to RENAME_EXCHANGE flag to XFS V9
Date: Wed, 17 Dec 2014 13:13:02 -0500
Message-Id: <1418839984-2514-1-git-send-email-cmaiolino@redhat.com>
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

This patchset aims to implement RENAME_EXCHANGE support (from sys_renameat2) to
XFS.

For this to be achieved, XFS need to export a rename2() method, which I included
in the first patch.

The second patch is the real implementation of the RENAME_EXCHANGE flags, which
most of the work I based on xfs_rename().

This patchset passed the xfstests 23, 24 and 25 (specifically for
RENAME_EXCHANGE), and I also tested the projectID inheritance problem, where
both paths must be under the same projectID to be able to change (I'm going to
implement this test into the xfstests too).

Changelog

 Make xfs_vn_rename compliant with renameat2() syscall

	V2: Use xfs_vn_rename as-is, instead of rename it to xfs_vn_rename2

 Add support to RENAME_EXCHANGE flag

	V2: - refactor xfs_cross_rename() to not duplicate code from xfs_rename()

	V3: - fix indentation to avoid 80 column crossing, decrease the amount of
	      arguments passed to xfs_cross_rename()
	    - Rebase patches over the latest linux code

	v4: - use a label/goto statement instead of an if conditional after
	      xfs_cross_rename() return, to finish the rename operation
	    - Make xfs_cross_rename() static
	    - Fix some comments

	V5: - Keep all the code under 80 columns

	V6: - Ensure i_mode of both files are updated during exchange

	V7: - Use struct names instead of typedefs in the xfs_cross_rename()
	      definition

	V8: - Replace src/target names for better variable names
	    - Log and timestamp updates done in different places
	    - Fix missing space in comments
	    - get rid of {src,tgt}_is_directory and new_parent variables

	V9: - Use flags to track down inode changes and update its timestamps
	    - Fix some comments

 fs/xfs/xfs_inode.c | 134 ++++++++++++++++++++++++++++++++++++++++++++++++++++-
 fs/xfs/xfs_inode.h |   2 +-
 fs/xfs/xfs_iops.c  |  21 ++++++---
 3 files changed, 149 insertions(+), 8 deletions(-)

-- 
1.9.3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
