Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 572C97F3F
	for <xfs@oss.sgi.com>; Fri, 14 Nov 2014 11:33:52 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 35B618F8040
	for <xfs@oss.sgi.com>; Fri, 14 Nov 2014 09:33:52 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id sWs3X3itQjQqM57f (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 14 Nov 2014 09:33:51 -0800 (PST)
Received: from int-mx11.intmail.prod.int.phx2.redhat.com
	(int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id sAEHXokZ001232
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256
	verify=FAIL) for <xfs@oss.sgi.com>; Fri, 14 Nov 2014 12:33:50 -0500
Received: from hades.localdomain.com (ovpn-113-81.phx2.redhat.com
	[10.3.113.81])
	by int-mx11.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id sAEHXmpV000577
	for <xfs@oss.sgi.com>; Fri, 14 Nov 2014 12:33:49 -0500
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: [PATCH 0/2] Add support to RENAME_EXCHANGE flag to XFS V6
Date: Fri, 14 Nov 2014 15:33:28 -0200
Message-Id: <1415986410-18367-1-git-send-email-cmaiolino@redhat.com>
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

In this version of the patch, I tried to use xfs_rename for everything in
common between a usual rename and the RENAME_EXCHANGE, using xfs_cross_rename()
just for the needed stuff to accomplish RENAME_EXCHANGE requirements (as 
suggested by Brian).

Also, this new version contains a fix to ensure both files will have their
i_mode updated, so that d_type object (in superblock V5) will contain the proper
information after the exchange happens

Carlos Maiolino (2):
  Make xfs_vn_rename compliant with renameat2() syscall
  Add support to RENAME_EXCHANGE flag V6

 fs/xfs/xfs_inode.c | 112 ++++++++++++++++++++++++++++++++++++++++++++++++++++-
 fs/xfs/xfs_inode.h |   2 +-
 fs/xfs/xfs_iops.c  |  24 +++++++++---
 3 files changed, 130 insertions(+), 8 deletions(-)

-- 
2.1.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
