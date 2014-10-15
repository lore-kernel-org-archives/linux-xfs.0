Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 2BB777F3F
	for <xfs@oss.sgi.com>; Wed, 15 Oct 2014 13:17:59 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id BB771AC005
	for <xfs@oss.sgi.com>; Wed, 15 Oct 2014 11:17:58 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id uBckEdHVAOfCRrWx (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 15 Oct 2014 11:17:57 -0700 (PDT)
Received: from int-mx13.intmail.prod.int.phx2.redhat.com
	(int-mx13.intmail.prod.int.phx2.redhat.com [10.5.11.26])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id s9FIHuNY013648
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256
	verify=FAIL) for <xfs@oss.sgi.com>; Wed, 15 Oct 2014 14:17:56 -0400
Received: from hades.localdomain.com (ovpn-113-106.phx2.redhat.com
	[10.3.113.106])
	by int-mx13.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id s9FIHsmM014766
	for <xfs@oss.sgi.com>; Wed, 15 Oct 2014 14:17:55 -0400
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: [PATCH 0/2] Add support to RENAME_EXCHANGE flat to XFS
Date: Wed, 15 Oct 2014 15:17:20 -0300
Message-Id: <1413397042-32229-1-git-send-email-cmaiolino@redhat.com>
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

I'd like some suggestions about the way I handled journaling, probably 
XFS_TRANS_RENAME is not the best way to log the changes during the
RENAME_EXCHANGE, and we might need a new journal type for this specific reason.

BTW, this patchset passed the xfstests 23, 24 and 25 (specifically for
RENAME_EXCHANGE), and I also tested the projectID inheritance problem, where
both paths must be under the same projectID to be able to change (I'm going to
implement this test into the xfstests too).

Carlos Maiolino (2):
  xfs_vn_rename by xfs_vn_rename2
  Add support to RENAME_EXCHANGE flag

 fs/xfs/xfs_inode.c | 187 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_inode.h |   4 ++
 fs/xfs/xfs_iops.c  |  22 +++++--
 3 files changed, 207 insertions(+), 6 deletions(-)

-- 
2.1.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
