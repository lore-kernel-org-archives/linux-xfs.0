Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o3S9brUl221596 for <xfs@oss.sgi.com>; Wed, 28 Apr 2010 04:37:54 -0500
Received: from mx1.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 4CEC71AEC5E6
	for <xfs@oss.sgi.com>; Wed, 28 Apr 2010 02:39:57 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id FT8O8hZPXjJvqP0t for
	<xfs@oss.sgi.com>; Wed, 28 Apr 2010 02:39:57 -0700 (PDT)
Message-ID: <4BD80260.3050501@redhat.com>
Date: Wed, 28 Apr 2010 12:39:44 +0300
From: Avi Kivity <avi@redhat.com>
MIME-Version: 1.0
Subject: Re: [PATCH 1/2] mm: add context argument to shrinker callback
References: <1271118255-21070-1-git-send-email-david@fromorbit.com>
	<1271118255-21070-2-git-send-email-david@fromorbit.com>
In-Reply-To: <1271118255-21070-2-git-send-email-david@fromorbit.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

On 04/13/2010 03:24 AM, Dave Chinner wrote:
> From: Dave Chinner<dchinner@redhat.com>
>
> The current shrinker implementation requires the registered callback
> to have global state to work from. This makes it difficult to shrink
> caches that are not global (e.g. per-filesystem caches). Add a
> context argument to the shrinker callback so that it can easily be
> used in such situations.
>    

> @@ -995,7 +995,8 @@ static inline void sync_mm_rss(struct task_struct *task, struct mm_struct *mm)
>    * querying the cache size, so a fastpath for that case is appropriate.
>    */
>   struct shrinker {
> -	int (*shrink)(int nr_to_scan, gfp_t gfp_mask);
> +	int (*shrink)(void *ctx, int nr_to_scan, gfp_t gfp_mask);
> +	void *ctx;	/* user callback context */
>   	int seeks;	/* seeks to recreate an obj */
>    


It's nicer (and slightly cheaper) to have

   int (*shrink)(struct shrinker *shrinker, int nr_to_scan, gfp_t gfp_mask);
   /* no void *ctx; */

Clients can use container_of() to reach their context from the shrinker 
argument.

-- 
error compiling committee.c: too many arguments to function

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
