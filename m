Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qAS1B29Y118365 for <xfs@oss.sgi.com>; Tue, 27 Nov 2012 19:11:02 -0600
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93]) by
	cuda.sgi.com with ESMTP id 1KDwNoLegJZqVC5N for
	<xfs@oss.sgi.com>; Tue, 27 Nov 2012 17:13:18 -0800 (PST)
Message-Id: <b94cdc$7i2bv3@fmsmga001.fm.intel.com>
From: Chris Wilson <chris@chris-wilson.co.uk>
Subject: Re: [PATCH 17/19] drivers: convert shrinkers to new count/scan API
In-Reply-To: <1354058086-27937-18-git-send-email-david@fromorbit.com>
References: <1354058086-27937-1-git-send-email-david@fromorbit.com>
	<1354058086-27937-18-git-send-email-david@fromorbit.com>
Date: Wed, 28 Nov 2012 01:13:11 +0000
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>, glommer@parallels.com
Cc: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

On Wed, 28 Nov 2012 10:14:44 +1100, Dave Chinner <david@fromorbit.com> wrote:
> +/*
> + * XXX: (dchinner) This is one of the worst cases of shrinker abuse I've seen.
> + *
> + * i915_gem_purge() expects a byte count to be passed, and the minimum object
> + * size is PAGE_SIZE.

No, purge() expects a count of pages to be freed. Each pass of the
shrinker therefore tries to free a minimum of 128 pages.

> The shrinker doesn't work on bytes - it works on
> + * *objects*.

And I thought you were reviewing the shrinker API to be useful where a
single object may range between 4K and 4G.

> So it passes a nr_to_scan of 128 objects, which is interpreted
> + * here to mean "free 128 bytes". That means a single object will be freed, as
> + * the minimum object size is a page.
> + *
> + * But the craziest part comes when i915_gem_purge() has walked all the objects
> + * and can't free any memory. That results in i915_gem_shrink_all() being
> + * called, which idles the GPU and frees everything the driver has in it's
> + * active and inactive lists. It's basically hitting the driver with a great big
> + * hammer because it was busy doing stuff when something else generated memory
> + * pressure. This doesn't seem particularly wise...
> + */

As opposed to triggering an OOM? The choice was between custom code for
a hopefully rare code path in a situation of last resort, or first
implementing the simplest code that stopped i915 from starving the
system of memory.
-Chris

-- 
Chris Wilson, Intel Open Source Technology Centre

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
