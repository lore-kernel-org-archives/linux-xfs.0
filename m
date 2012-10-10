Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q9ANPEsK189432 for <xfs@oss.sgi.com>; Wed, 10 Oct 2012 18:25:14 -0500
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	6lGpZ4aZEgmzZtuy for <xfs@oss.sgi.com>;
	Wed, 10 Oct 2012 16:26:44 -0700 (PDT)
Date: Thu, 11 Oct 2012 10:25:53 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 2/2 V2] xfs_io: configure tests for preadv/pwritev &
	sync_file_range
Message-ID: <20121010232553.GB23644@dastard>
References: <50749EE2.6070408@redhat.com> <5074A05A.6000709@sandeen.net>
	<5074EE1B.3090600@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <5074EE1B.3090600@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs-oss <xfs@oss.sgi.com>

On Tue, Oct 09, 2012 at 10:40:11PM -0500, Eric Sandeen wrote:
> On older systems we may not have preadv/pwritev and/or
> sync_file_range.
> 
> Add the configure magic, and stub out the code
> where needed.
> 
> (sync_file_range just needed a better test; preadv/pwritev
> took a little more rearranging)
> 
> And fix a couple typos ("numberic") while we're at it.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
> 
> V2: add -DHAVE_PWRITEV and use that test in io/pwrite.c
> rather than HAVE_PREADV
.....

> +# Also implies PWRITEV
> +ifeq ($(HAVE_PREADV),yes)
> +LCFLAGS += -DHAVE_PREADV -DHAVE_PWRITEV
> +endif

Nice solution ;)

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
