Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 5836A7F63
	for <xfs@oss.sgi.com>; Mon, 18 Mar 2013 09:50:00 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 43BDA30406B
	for <xfs@oss.sgi.com>; Mon, 18 Mar 2013 07:50:00 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id tbn1PuFXemlb8UBZ for
	<xfs@oss.sgi.com>; Mon, 18 Mar 2013 07:49:59 -0700 (PDT)
Received: from int-mx10.intmail.prod.int.phx2.redhat.com
	(int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r2IEnwhR026964
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Mon, 18 Mar 2013 10:49:58 -0400
Received: from bfoster.bfoster (dhcp-189-135.bos.redhat.com [10.16.189.135])
	by int-mx10.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id r2IEnwQk021453
	for <xfs@oss.sgi.com>; Mon, 18 Mar 2013 10:49:58 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH v5 0/6] speculative preallocation quota throttling
Date: Mon, 18 Mar 2013 10:51:42 -0400
Message-Id: <1363618308-53594-1-git-send-email-bfoster@redhat.com>
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

Here is v5 of speculative prealloc. quota throttling. Sorry for the delay. This
is mostly a rebase. I'm running some quick xfstests tests since we've moved onto
3.9-rc1 now, but the only real merge conflict was inheritance of the infinite
loop alloc_blocks fix. Otherwise, this just includes some extra fixups to remove
dependence on typedef's of various functions we happen to modify.

Brian

v5:
- Rebased against current tree (3.9-rc1), incl. e78c420b.
- Added Mark's reviewed-by's.
- Removed use of typedef's in modified functions (affects patches 3 and 4).
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

 fs/xfs/xfs_dquot.c       |   48 ++++++++++++--
 fs/xfs/xfs_dquot.h       |   16 ++++-
 fs/xfs/xfs_iomap.c       |  161 +++++++++++++++++++++++++++++++++++++---------
 fs/xfs/xfs_qm.c          |    2 +-
 fs/xfs/xfs_qm.h          |    2 +-
 fs/xfs/xfs_qm_syscalls.c |    9 ++-
 fs/xfs/xfs_trace.h       |   24 +++++++
 fs/xfs/xfs_trans_dquot.c |   10 ++--
 8 files changed, 224 insertions(+), 48 deletions(-)

-- 
1.7.7.6

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
