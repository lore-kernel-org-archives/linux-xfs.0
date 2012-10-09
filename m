Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q99JkOOA094584 for <xfs@oss.sgi.com>; Tue, 9 Oct 2012 14:46:24 -0500
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	8gJf2EFLAQ4j7v6N for <xfs@oss.sgi.com>;
	Tue, 09 Oct 2012 12:47:54 -0700 (PDT)
Date: Wed, 10 Oct 2012 06:47:52 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 2/2] xfsprogs: report projid32 status in growfs output
Message-ID: <20121009194752.GM23644@dastard>
References: <50747753.6040105@redhat.com>
 <5074792A.2080509@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <5074792A.2080509@sandeen.net>
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
Cc: Eric Sandeen <sandeen@redhat.com>, xfs-oss <xfs@oss.sgi.com>

On Tue, Oct 09, 2012 at 02:21:14PM -0500, Eric Sandeen wrote:
> With the projid32 flag now in the FSGEOM ioctl results we
> can report projid32 status in xfs_growfs / xfs_info output,
> to match the mkfs.xfs output.
> 
> However, since the flag was only recently added to the kernel,
> we may get some incorrect reports of "projid32bit=0"
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
> 
> ... and I don't know how big a problem those incorrect reports
> might be ...

I doubt it will be a problem - the 32bit projid is pretty
self-contained, and we can still get the info from xfs_db if we
really need to confirm that it is set.

Code looks good.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
