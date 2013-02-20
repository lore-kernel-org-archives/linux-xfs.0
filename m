Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id DAA0C7F61
	for <xfs@oss.sgi.com>; Wed, 20 Feb 2013 09:07:50 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id C2E278F8037
	for <xfs@oss.sgi.com>; Wed, 20 Feb 2013 07:07:47 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id EWpwmiHbKWPm6oIZ for
	<xfs@oss.sgi.com>; Wed, 20 Feb 2013 07:07:46 -0800 (PST)
Received: from int-mx09.intmail.prod.int.phx2.redhat.com
	(int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r1KF7kv6001467
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Wed, 20 Feb 2013 10:07:46 -0500
Received: from bfoster.bfoster (dhcp-189-135.bos.redhat.com [10.16.189.135])
	by int-mx09.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id r1KF7j5v007943
	for <xfs@oss.sgi.com>; Wed, 20 Feb 2013 10:07:46 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH v4 0/6] speculative preallocation quota throttling
Date: Wed, 20 Feb 2013 10:10:13 -0500
Message-Id: <1361373019-30891-1-git-send-email-bfoster@redhat.com>
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

Here is v4 of the speculative preallocation quota throttling set. Patch 3 of v3
is dropped due to a redundancy and a few changes are made to the threshold
management code (patch 4/6). The remaining patches are unchanged from v3.

Brian

v4:
- Drop patch 3/7 from v3 (xfs: cap prealloc size to free space before shift).
- Several updates to patch 4/6:
  - Rename xfs_dquot_init_prealloc() to xfs_dquot_set_prealloc_limits().
  - Unroll the prealloc threshold loop and remove the increment def.
  - Fix up some comments.
v3:
- Rebased on top of updated speculative preallocation algorithm.
v2:
- Fix up xfs_iomap_prealloc_size() rounding (patch 2).
- Add pre-calculated fields to xfs_dquot to support throttling.
- Move to logarithmic (shift) throttler and finer tuned trigger/throttle logic.

Brian Foster (6):
  xfs: reorganize xfs_iomap_prealloc_size to remove indentation
  xfs: push rounddown_pow_of_two() to after prealloc throttle
  xfs: pass xfs_dquot to xfs_qm_adjust_dqlimits() instead of
    xfs_disk_dquot_t
  xfs: xfs_dquot prealloc throttling watermarks and low free space
  xfs: add quota-driven speculative preallocation throttling
  xfs: xfs_iomap_prealloc_size() tracepoint

 fs/xfs/xfs_dquot.c       |   44 ++++++++++++-
 fs/xfs/xfs_dquot.h       |   14 ++++-
 fs/xfs/xfs_iomap.c       |  161 +++++++++++++++++++++++++++++++++++++---------
 fs/xfs/xfs_qm.c          |    2 +-
 fs/xfs/xfs_qm_syscalls.c |    1 +
 fs/xfs/xfs_trace.h       |   24 +++++++
 fs/xfs/xfs_trans_dquot.c |    2 +-
 7 files changed, 212 insertions(+), 36 deletions(-)

-- 
1.7.7.6

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
