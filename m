Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o3SDh2Vf238031 for <xfs@oss.sgi.com>; Wed, 28 Apr 2010 08:43:03 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id F2FCF1DDFB9B
	for <xfs@oss.sgi.com>; Wed, 28 Apr 2010 06:45:05 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail16.adl2.internode.on.net
	[150.101.137.101]) by cuda.sgi.com with ESMTP id
	bNrOikPxkgLTBnpq for <xfs@oss.sgi.com>;
	Wed, 28 Apr 2010 06:45:05 -0700 (PDT)
Date: Wed, 28 Apr 2010 23:45:02 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 1/2] mm: add context argument to shrinker callback
Message-ID: <20100428134502.GI9783@dastard>
References: <1271118255-21070-1-git-send-email-david@fromorbit.com>
	<1271118255-21070-2-git-send-email-david@fromorbit.com>
	<4BD80260.3050501@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4BD80260.3050501@redhat.com>
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
To: Avi Kivity <avi@redhat.com>
Cc: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

On Wed, Apr 28, 2010 at 12:39:44PM +0300, Avi Kivity wrote:
> On 04/13/2010 03:24 AM, Dave Chinner wrote:
> >From: Dave Chinner<dchinner@redhat.com>
> >
> >The current shrinker implementation requires the registered callback
> >to have global state to work from. This makes it difficult to shrink
> >caches that are not global (e.g. per-filesystem caches). Add a
> >context argument to the shrinker callback so that it can easily be
> >used in such situations.
> 
> >@@ -995,7 +995,8 @@ static inline void sync_mm_rss(struct task_struct *task, struct mm_struct *mm)
> >   * querying the cache size, so a fastpath for that case is appropriate.
> >   */
> >  struct shrinker {
> >-	int (*shrink)(int nr_to_scan, gfp_t gfp_mask);
> >+	int (*shrink)(void *ctx, int nr_to_scan, gfp_t gfp_mask);
> >+	void *ctx;	/* user callback context */
> >  	int seeks;	/* seeks to recreate an obj */
> 
> 
> It's nicer (and slightly cheaper) to have
> 
>   int (*shrink)(struct shrinker *shrinker, int nr_to_scan, gfp_t gfp_mask);
>   /* no void *ctx; */
> 
> Clients can use container_of() to reach their context from the
> shrinker argument.

Agreed, that makes a lot of sense. I'll change it for the next version.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
