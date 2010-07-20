Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o6KJR8RK036919 for <xfs@oss.sgi.com>; Tue, 20 Jul 2010 14:27:08 -0500
Subject: Re: [PATCH 1/3] mm: add context argument to shrinker callback
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <1279194418-16119-2-git-send-email-david@fromorbit.com>
References: <1279194418-16119-1-git-send-email-david@fromorbit.com>
	<1279194418-16119-2-git-send-email-david@fromorbit.com>
Date: Tue, 20 Jul 2010 14:30:04 -0500
Message-ID: <1279654204.1859.232.camel@doink>
Mime-Version: 1.0
Reply-To: aelder@sgi.com
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

On Thu, 2010-07-15 at 21:46 +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> The current shrinker implementation requires the registered callback
> to have global state to work from. This makes it difficult to shrink
> caches that are not global (e.g. per-filesystem caches). Pass the shrinker
> structure to the callback so that users can embed the shrinker structure
> in the context the shrinker needs to operate on and get back to it in the
> callback via container_of().

> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  arch/x86/kvm/mmu.c              |    2 +-
>  drivers/gpu/drm/i915/i915_gem.c |    2 +-
>  fs/dcache.c                     |    2 +-
>  fs/gfs2/glock.c                 |    2 +-
>  fs/gfs2/quota.c                 |    2 +-
>  fs/gfs2/quota.h                 |    2 +-
>  fs/inode.c                      |    2 +-
>  fs/mbcache.c                    |    5 +++--
>  fs/nfs/dir.c                    |    2 +-
>  fs/nfs/internal.h               |    3 ++-
>  fs/quota/dquot.c                |    2 +-
>  fs/ubifs/shrinker.c             |    2 +-
>  fs/ubifs/ubifs.h                |    2 +-
>  fs/xfs/linux-2.6/xfs_buf.c      |    5 +++--
>  fs/xfs/linux-2.6/xfs_sync.c     |    1 +
>  fs/xfs/quota/xfs_qm.c           |    7 +++++--
>  include/linux/mm.h              |    2 +-
>  mm/vmscan.c                     |    8 +++++---
>  18 files changed, 31 insertions(+), 22 deletions(-)

You seem to have missed two registered shrinkers:
- ttm_pool_mm_shrink() in "drivers/gpu/drm/ttm/ttm_page_alloc.c"
- rpcauth_cache_shrinker() in "net/sunrpc/auth.c"

Other that that, this looks good to me.

					-Alex





_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
