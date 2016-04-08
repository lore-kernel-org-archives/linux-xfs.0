Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 3311C7CB0
	for <xfs@oss.sgi.com>; Fri,  8 Apr 2016 12:18:51 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 824D1AC004
	for <xfs@oss.sgi.com>; Fri,  8 Apr 2016 10:18:47 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id k6WVCwvQKJCihLrI (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 08 Apr 2016 10:18:46 -0700 (PDT)
Date: Fri, 8 Apr 2016 13:18:44 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 0/6 v2] xfs: xfs_iflush_cluster vs xfs_reclaim_inode
Message-ID: <20160408171843.GC30614@bfoster.bfoster>
References: <1460072271-23923-1-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1460072271-23923-1-git-send-email-david@fromorbit.com>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Fri, Apr 08, 2016 at 09:37:45AM +1000, Dave Chinner wrote:
> Hi folks,
> 
> This is the second version of this patch set, first posted and
> described here:
> 
> http://oss.sgi.com/archives/xfs/2016-04/msg00069.html
> 
> The only change from the first version is splitting up the first
> patch into two as Christoph requested - one for the bug fix, the
> other for the variable renaming.
> 

Did your xfstests testing for this series include generic/233? I'm
seeing a consistently reproducible test hang. The test is hanging on a
"xfs_quota -x -c off -ug /mnt/scratch" command. The stack is as follows:

[<ffffffffa0772306>] xfs_qm_dquot_walk.isra.8+0x196/0x1b0 [xfs]
[<ffffffffa0774a98>] xfs_qm_dqpurge_all+0x78/0x80 [xfs]
[<ffffffffa07713e8>] xfs_qm_scall_quotaoff+0x148/0x640 [xfs]
[<ffffffffa077733d>] xfs_quota_disable+0x3d/0x50 [xfs]
[<ffffffff812c27e3>] SyS_quotactl+0x3b3/0x8c0
[<ffffffff81003e17>] do_syscall_64+0x67/0x190
[<ffffffff81763f7f>] return_from_SYSCALL_64+0x0/0x7a
[<ffffffffffffffff>] 0xffffffffffffffff

... and it looks like the kernel is spinning somehow or another between
inode reclaim and xfsaild:

    ...
     kworker/1:2-210   [001] ...1   895.750591: xfs_perag_get_tag: dev 253:3 agno 1 refcount 1 caller xfs_reclaim_inodes_ag [xfs]
     kworker/1:2-210   [001] ...1   895.750609: xfs_perag_put: dev 253:3 agno 1 refcount 0 caller xfs_reclaim_inodes_ag [xfs]
     kworker/1:2-210   [001] ...1   895.750609: xfs_perag_get_tag: dev 253:3 agno 2 refcount 5 caller xfs_reclaim_inodes_ag [xfs]
     kworker/1:2-210   [001] ...1   895.750611: xfs_perag_put: dev 253:3 agno 2 refcount 4 caller xfs_reclaim_inodes_ag [xfs]
     kworker/1:2-210   [001] ...1   895.750612: xfs_perag_get_tag: dev 253:3 agno 3 refcount 1 caller xfs_reclaim_inodes_ag [xfs]
     kworker/1:2-210   [001] ...1   895.750613: xfs_perag_put: dev 253:3 agno 3 refcount 0 caller xfs_reclaim_inodes_ag [xfs]
    xfsaild/dm-3-12406 [003] ...2   895.760588: xfs_ail_locked: dev 253:3 lip 0xffff8801f8e65d80 lsn 2/5709 type XFS_LI_QUOTAOFF flags IN_AIL
    xfsaild/dm-3-12406 [003] ...2   895.810595: xfs_ail_locked: dev 253:3 lip 0xffff8801f8e65d80 lsn 2/5709 type XFS_LI_QUOTAOFF flags IN_AIL
    xfsaild/dm-3-12406 [003] ...2   895.860586: xfs_ail_locked: dev 253:3 lip 0xffff8801f8e65d80 lsn 2/5709 type XFS_LI_QUOTAOFF flags IN_AIL
    xfsaild/dm-3-12406 [003] ...2   895.910596: xfs_ail_locked: dev 253:3 lip 0xffff8801f8e65d80 lsn 2/5709 type XFS_LI_QUOTAOFF flags IN_AIL
    ...

FWIW, this only occurs with patch 6 applied. The test and scratch
devices are both 10GB lvm volumes formatted with mkfs defaults (v5).

Brian

> Cheers,
> 
> Dave.
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
