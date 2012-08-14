Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q7ELaWYS010788 for <xfs@oss.sgi.com>; Tue, 14 Aug 2012 16:36:33 -0500
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	J0qGzFf7kf8vFzFk for <xfs@oss.sgi.com>;
	Tue, 14 Aug 2012 14:36:31 -0700 (PDT)
Date: Wed, 15 Aug 2012 07:36:29 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v4] xfs: check for possible overflow in xfs_ioc_trim
Message-ID: <20120814213629.GL2877@dastard>
References: <1344933304-16014-1-git-send-email-tracek@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1344933304-16014-1-git-send-email-tracek@redhat.com>
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
To: Tomas Racek <tracek@redhat.com>
Cc: lczerner@redhat.com, xfs@oss.sgi.com

On Tue, Aug 14, 2012 at 10:35:04AM +0200, Tomas Racek wrote:
> If range.start or range.minlen is bigger than filesystem size, return
> invalid value error. This fixes possible overflow in BTOBB macro when
> passed value was nearly ULLONG_MAX.
> 
> Signed-off-by: Tomas Racek <tracek@redhat.com>

looks ok to me.

Reviewed-by: Dave Chinner <dchinner@redhat.com>
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
