Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q9GKGrGM217430 for <xfs@oss.sgi.com>; Tue, 16 Oct 2012 15:16:54 -0500
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	Gzh0HZOcYsoKnQxj for <xfs@oss.sgi.com>;
	Tue, 16 Oct 2012 13:18:30 -0700 (PDT)
Date: Wed, 17 Oct 2012 07:18:29 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 2/2] 251: Do not allow step to be zero
Message-ID: <20121016201829.GK2739@dastard>
References: <1350380494-17482-1-git-send-email-lczerner@redhat.com>
	<1350380494-17482-2-git-send-email-lczerner@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1350380494-17482-2-git-send-email-lczerner@redhat.com>
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
To: Lukas Czerner <lczerner@redhat.com>
Cc: xfs@oss.sgi.com

On Tue, Oct 16, 2012 at 11:41:34AM +0200, Lukas Czerner wrote:
> Currently 'step' variable which is used as length of the range to
> discard can be zero. However it would result in error returned by the
> fstrim.
> 
> Fix this by forcing 'step' to be at least 4KB.
> 
> Signed-off-by: Lukas Czerner <lczerner@redhat.com>

Looks fine. It may not be perfect for large block filesystems (e.g.
on ppc or ia64) but it's better than nothing right now.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
