Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 1B2DA7FA8
	for <xfs@oss.sgi.com>; Wed, 24 Feb 2016 14:27:41 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id E0489304062
	for <xfs@oss.sgi.com>; Wed, 24 Feb 2016 12:27:34 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id GanitvLhBjgpmGBb (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 24 Feb 2016 11:48:25 -0800 (PST)
From: mchristi@redhat.com
Subject: [PATCH 00/35 v4] separate operations from flags in the bio/request
	structs
Date: Wed, 24 Feb 2016 13:47:37 -0600
Message-Id: <1456343292-14535-1-git-send-email-mchristi@redhat.com>
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
To: linux-f2fs-devel@lists.sourceforge.net, linux-ext4@vger.kernel.org, konrad.wilk@oracle.com, drbd-dev@lists.linbit.com, philipp.reisner@linbit.com, lars.ellenberg@linbit.com, linux-raid@vger.kernel.org, dm-devel@redhat.com, linux-fsdevel@vger.kernel.org, linux-bcache@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-mtd@lists.infradead.org, target-devel@vger.kernel.org, linux-btrfs@vger.kernel.org, osd-dev@open-osd.org, xfs@oss.sgi.com, ocfs2-devel@oss.oracle.com

The following patches begin to cleanup the request->cmd_flags and
bio->bi_rw mess. We currently use cmd_flags to specify the operation,
attributes and state of the request. For bi_rw we use it for similar
info and also the priority but then also have another bi_flags field
for state. At some point, we abused them so much we just made cmd_flags
64 bits, so we could add more.

The following patches seperate the operation (read, write discard,
flush, etc) from cmd_flags/bi_rw.

This patchset was made against linux-next from today Feb 24 2016
(git tag next-20160224).

I put a git tree here:
https://github.com/mikechristie/linux-kernel.git

v4:
1. Rebased to current linux-next tree.

v3:

1. Used "=" instead of "|="  to setup bio bi_rw.
2. Removed __get_request cmd_flags compat code.
3. Merged initial dm related changes requested by Mike Snitzer.
4. Fixed ubd kbuild errors in flush related patches.
5. Fix 80 char col issues in several patches.
6. Fix issue with one of the btrfs patches where it looks like I reverted
a patch when trying to fix a merge error.

v2

1. Dropped arguments from submit_bio, and had callers setup
bio.
2. Add REQ_OP_FLUSH for request_fn users and renamed REQ_FLUSH
to REQ_PREFLUSH for make_request_fn users.
3. Dropped bio/rq_data_dir functions, and added a op_is_write
function instead.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
