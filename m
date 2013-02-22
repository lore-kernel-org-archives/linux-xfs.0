Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 40CC97F37
	for <xfs@oss.sgi.com>; Fri, 22 Feb 2013 14:09:07 -0600 (CST)
Message-ID: <5127D060.5050806@sgi.com>
Date: Fri, 22 Feb 2013 14:09:04 -0600
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH v4 0/6] speculative preallocation quota throttling
References: <1361373019-30891-1-git-send-email-bfoster@redhat.com>
In-Reply-To: <1361373019-30891-1-git-send-email-bfoster@redhat.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Brian Foster <bfoster@redhat.com>
Cc: xfs@oss.sgi.com

On 02/20/13 09:10, Brian Foster wrote:
> Hi all,
>
> Here is v4 of the speculative preallocation quota throttling set. Patch 3 of v3
> is dropped due to a redundancy and a few changes are made to the threshold
> management code (patch 4/6). The remaining patches are unchanged from v3.
>
> Brian
>
> v4:
> - Drop patch 3/7 from v3 (xfs: cap prealloc size to free space before shift).
> - Several updates to patch 4/6:
>    - Rename xfs_dquot_init_prealloc() to xfs_dquot_set_prealloc_limits().
>    - Unroll the prealloc threshold loop and remove the increment def.
>    - Fix up some comments.
> v3:
> - Rebased on top of updated speculative preallocation algorithm.
> v2:
> - Fix up xfs_iomap_prealloc_size() rounding (patch 2).
> - Add pre-calculated fields to xfs_dquot to support throttling.
> - Move to logarithmic (shift) throttler and finer tuned trigger/throttle logic.
>
> Brian Foster (6):
>    xfs: reorganize xfs_iomap_prealloc_size to remove indentation
>    xfs: push rounddown_pow_of_two() to after prealloc throttle
>    xfs: pass xfs_dquot to xfs_qm_adjust_dqlimits() instead of
>      xfs_disk_dquot_t
>    xfs: xfs_dquot prealloc throttling watermarks and low free space
>    xfs: add quota-driven speculative preallocation throttling
>    xfs: xfs_iomap_prealloc_size() tracepoint
>
>   fs/xfs/xfs_dquot.c       |   44 ++++++++++++-
>   fs/xfs/xfs_dquot.h       |   14 ++++-
>   fs/xfs/xfs_iomap.c       |  161 +++++++++++++++++++++++++++++++++++++---------
>   fs/xfs/xfs_qm.c          |    2 +-
>   fs/xfs/xfs_qm_syscalls.c |    1 +
>   fs/xfs/xfs_trace.h       |   24 +++++++
>   fs/xfs/xfs_trans_dquot.c |    2 +-
>   7 files changed, 212 insertions(+), 36 deletions(-)
>

The rest of the series looks good to me. Consider it Review-by: me.

The tracing in patch 6 says how much, but not why, BUT I think the why
would require multiple tracepoints, so I okay with it.

	-- since I am being a grouch ... ---
I wish I had caught in the review for commit a1e16c26 that 
xfs_iomap_eof_prealloc_initial_size() is returning an int rather than 
xfs_fsblock_t for consistency.

--Mark.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
