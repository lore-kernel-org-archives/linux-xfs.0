Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 17F097F4E
	for <xfs@oss.sgi.com>; Tue, 19 Feb 2013 10:35:00 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id DD6EC8F8033
	for <xfs@oss.sgi.com>; Tue, 19 Feb 2013 08:34:56 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id Cd7NjiPnNOdnBBx9 for
	<xfs@oss.sgi.com>; Tue, 19 Feb 2013 08:34:56 -0800 (PST)
Received: from int-mx10.intmail.prod.int.phx2.redhat.com
	(int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r1JGYtI6010483
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Tue, 19 Feb 2013 11:34:55 -0500
Received: from bfoster.bfoster (dhcp-189-135.bos.redhat.com [10.16.189.135])
	by int-mx10.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id r1JGYtUE003473
	for <xfs@oss.sgi.com>; Tue, 19 Feb 2013 11:34:55 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH v3 0/7] speculative preallocation quota throttling
Date: Tue, 19 Feb 2013 11:37:24 -0500
Message-Id: <1361291851-24714-1-git-send-email-bfoster@redhat.com>
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

This v3 speculative prealloc quota throttling set is a simple rebase of v2 on
top of the recent speculative prealloc algorithm update to support sparse files.
I carried over the reviewed-by tags from patches 1-2, as I didn't fundamentally
change that code. Those are the patches slightly affected by the rebase, however,
so a second look at those might be prudent.

I've run a 1TB limit uquota sanity check to verify behavior as described in v2.
The numbers change slightly due to the slightly altered behavior of the new
prealloc algorithm (e.g., switching from using the size of the previous extent to
the size of the file causes maximum extent allocations to kick in a bit later),
but otherwise the general behavior is the same. I'll run some tests with larger
files in parallel with review as well.

[Note that these tests also include the currently posted "xfs: increase prealloc
size to double ..." change to restore effectiveness of the prealloc algorithm
to my particular test case.]

Brian

v3:
- Rebased on top of updated speculative preallocation algorithm.
v2:
- Fix up xfs_iomap_prealloc_size() rounding (patch 2).
- Add pre-calculated fields to xfs_dquot to support throttling.
- Move to logarithmic (shift) throttler and finer tuned trigger/throttle logic.

Brian Foster (7):
  xfs: reorganize xfs_iomap_prealloc_size to remove indentation
  xfs: push rounddown_pow_of_two() to after prealloc throttle
  xfs: cap prealloc size to free space before shift
  xfs: pass xfs_dquot to xfs_qm_adjust_dqlimits() instead of
    xfs_disk_dquot_t
  xfs: xfs_dquot prealloc throttling watermarks and low free space
  xfs: add quota-driven speculative preallocation throttling
  xfs: xfs_iomap_prealloc_size() tracepoint

 fs/xfs/xfs_dquot.c       |   46 ++++++++++++-
 fs/xfs/xfs_dquot.h       |   15 ++++-
 fs/xfs/xfs_iomap.c       |  163 +++++++++++++++++++++++++++++++++++++---------
 fs/xfs/xfs_qm.c          |    2 +-
 fs/xfs/xfs_qm_syscalls.c |    1 +
 fs/xfs/xfs_trace.h       |   24 +++++++
 fs/xfs/xfs_trans_dquot.c |    2 +-
 7 files changed, 217 insertions(+), 36 deletions(-)

-- 
1.7.7.6

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
