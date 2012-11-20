Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qAK9FWkd133699 for <xfs@oss.sgi.com>; Tue, 20 Nov 2012 03:15:32 -0600
Received: from mail-da0-f53.google.com (mail-da0-f53.google.com
	[209.85.210.53]) by cuda.sgi.com with ESMTP id 6gbDout2jUlfurV6
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 20 Nov 2012 01:17:14 -0800 (PST)
Received: by mail-da0-f53.google.com with SMTP id x6so105973dac.26
	for <xfs@oss.sgi.com>; Tue, 20 Nov 2012 01:17:13 -0800 (PST)
From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: [PATCH 0/4][RFC] remove duplicated check from ext4, xfs, btrfs,
	and ocfs2
Date: Tue, 20 Nov 2012 17:29:41 +0800
Message-Id: <1353403785-3489-1-git-send-email-wenqing.lz@taobao.com>
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
To: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, xfs@oss.sgi.com, linux-btrfs@vger.kernel.org, ocfs2-devel@oss.oracle.com
Cc: yan@linux.vnet.ibm.com, Zheng Liu <wenqing.lz@taobao.com>

Hi all,

This patch series tries to remove a sanity check in fallocate from specific
filesystems because vfs has already checked it.

I am not very familiar with why we need to do this duplicated check.  Please let
me know if I miss something.

Regards,
						- Zheng

---
Zheng Liu(4):
      ext4: remove dupoicated check from ext4_fallocate
      xfs: remove duplicated check from xfs_file_fallocate
      btrfs: remove duplicated check from btrfs_fallocate
      ocfs2: remove duplicated check from ocfs2_fallocate

 fs/btrfs/file.c   | 4 ----
 fs/ext4/extents.c | 4 ----
 fs/ocfs2/file.c   | 2 --
 fs/xfs/xfs_file.c | 3 ---
 4 files changed, 13 deletions(-)

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
