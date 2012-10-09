Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q99JhsjO094173 for <xfs@oss.sgi.com>; Tue, 9 Oct 2012 14:43:54 -0500
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	l0GXOGROrtZB7Y7C for <xfs@oss.sgi.com>;
	Tue, 09 Oct 2012 12:45:24 -0700 (PDT)
Date: Wed, 10 Oct 2012 06:45:22 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: report projid32bit feature in geometry call
Message-ID: <20121009194522.GL23644@dastard>
References: <507476F1.3080503@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <507476F1.3080503@redhat.com>
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
To: Eric Sandeen <sandeen@redhat.com>
Cc: xfs-oss <xfs@oss.sgi.com>

On Tue, Oct 09, 2012 at 02:11:45PM -0500, Eric Sandeen wrote:
> When xfs gained the projid32bit feature, it was never added to
> the FSGEOMETRY ioctl feature flags, so it's not queryable without
> this patch.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
> 
> note1: is there a reason we had gaps in the flags?

No idea. I don't think it matters, though.

> note2: I don't *think* this requires a new version for the ioctl

No, it doesn't - the structure format is unchanged.

Looks good.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
