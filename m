Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 6FC377F47
	for <xfs@oss.sgi.com>; Fri, 14 Nov 2014 12:00:15 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 5EB28304051
	for <xfs@oss.sgi.com>; Fri, 14 Nov 2014 10:00:15 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id joRqocmfHM1sFtHb (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 14 Nov 2014 10:00:14 -0800 (PST)
Received: from int-mx14.intmail.prod.int.phx2.redhat.com
	(int-mx14.intmail.prod.int.phx2.redhat.com [10.5.11.27])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id sAEGH8pm006333
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256
	verify=FAIL) for <xfs@oss.sgi.com>; Fri, 14 Nov 2014 11:17:09 -0500
Received: from bfoster.bfoster ([10.18.41.237])
	by int-mx14.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id sAEGH8du014165
	for <xfs@oss.sgi.com>; Fri, 14 Nov 2014 11:17:08 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH RESEND 0/3] xfs: misc. fixes
Date: Fri, 14 Nov 2014 11:17:04 -0500
Message-Id: <1415981827-52993-1-git-send-email-bfoster@redhat.com>
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

Hi all,

This series includes a few miscellaneous patches I came across while
doing some local branch housekeeping. These have been posted previously
and appear to have fallen through the cracks.

Note that there was an alternative version of patch 3 floating around
somewhere. It doesn't matter much to me which one we take.

Brian

Brian Foster (3):
  xfs: replace on-stack xfs_trans_res with pointer in xfs_create()
  xfs: fix error handling in xfs_qm_log_quotaoff()
  xfs: allow lazy sb counter sync during filesystem freeze sequence

 fs/xfs/xfs_inode.c       | 15 ++++++---------
 fs/xfs/xfs_log.c         |  2 +-
 fs/xfs/xfs_mount.c       | 29 +++++++++++++++++++++--------
 fs/xfs/xfs_mount.h       |  2 +-
 fs/xfs/xfs_qm_syscalls.c | 26 ++++++++++----------------
 5 files changed, 39 insertions(+), 35 deletions(-)

-- 
1.8.3.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
