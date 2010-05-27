Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o4RKUIPP162286 for <xfs@oss.sgi.com>; Thu, 27 May 2010 15:30:18 -0500
Received: from smtp1.linux-foundation.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 221701D52AD1
	for <xfs@oss.sgi.com>; Thu, 27 May 2010 13:32:41 -0700 (PDT)
Received: from smtp1.linux-foundation.org (smtp1.linux-foundation.org
	[140.211.169.13]) by cuda.sgi.com with ESMTP id
	1VwGXdb3Q8Rr0jed for <xfs@oss.sgi.com>;
	Thu, 27 May 2010 13:32:41 -0700 (PDT)
Date: Thu, 27 May 2010 13:32:34 -0700
From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 3/5] superblock: introduce per-sb cache shrinker
	infrastructure
Message-Id: <20100527133234.e0814239.akpm@linux-foundation.org>
In-Reply-To: <1274777588-21494-4-git-send-email-david@fromorbit.com>
References: <1274777588-21494-1-git-send-email-david@fromorbit.com>
	<1274777588-21494-4-git-send-email-david@fromorbit.com>
Mime-Version: 1.0
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

On Tue, 25 May 2010 18:53:06 +1000
Dave Chinner <david@fromorbit.com> wrote:

> From: Dave Chinner <dchinner@redhat.com>
> 
> With context based shrinkers, we can implement a per-superblock
> shrinker that shrinks the caches attached to the superblock. We
> currently have global shrinkers for the inode and dentry caches that
> split up into per-superblock operations via a coarse proportioning
> method that does not batch very well.  The global shrinkers also
> have a dependency - dentries pin inodes - so we have to be very
> careful about how we register the global shrinkers so that the
> implicit call order is always correct.
> 
> With a per-sb shrinker callout, we can encode this dependency
> directly into the per-sb shrinker, hence avoiding the need for
> strictly ordering shrinker registrations. We also have no need for
> any proportioning code for the shrinker subsystem already provides
> this functionality across all shrinkers. Allowing the shrinker to
> operate on a single superblock at a time means that we do less
> superblock list traversals and locking and reclaim should batch more
> effectively. This should result in less CPU overhead for reclaim and
> potentially faster reclaim of items from each filesystem.
> 

I go all tingly when a changelog contains the word "should".

OK, it _should_ do X.  But _does_ it actually do X?

>  fs/super.c         |   53 +++++++++++++++++++++
>  include/linux/fs.h |    7 +++
>  4 files changed, 88 insertions(+), 214 deletions(-)
> 
> diff --git a/fs/dcache.c b/fs/dcache.c
> index dba6b6d..d7bd781 100644
> --- a/fs/dcache.c
> +++ b/fs/dcache.c
> @@ -456,21 +456,16 @@ static void prune_one_dentry(struct dentry * dentry)
>   * which flags are set. This means we don't need to maintain multiple
>   * similar copies of this loop.
>   */
> -static void __shrink_dcache_sb(struct super_block *sb, int *count, int flags)
> +static void __shrink_dcache_sb(struct super_block *sb, int count, int flags)

Forgot to update the kerneldoc description of `count'.


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
