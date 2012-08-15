Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q7FCNcBt131860 for <xfs@oss.sgi.com>; Wed, 15 Aug 2012 07:23:39 -0500
Date: Wed, 15 Aug 2012 08:23:32 -0400 (EDT)
From: Tomas Racek <tracek@redhat.com>
Message-ID: <1805964222.1573527.1345033412870.JavaMail.root@redhat.com>
In-Reply-To: <20120814213629.GL2877@dastard>
Subject: Re: [PATCH v4] xfs: check for possible overflow in xfs_ioc_trim
MIME-Version: 1.0
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
Cc: lczerner@redhat.com, Ben Myers <bpm@sgi.com>, Alex Elder <elder@kernel.org>, xfs@oss.sgi.com

Forwarding to maintainers.

----- Original Message -----
> On Tue, Aug 14, 2012 at 10:35:04AM +0200, Tomas Racek wrote:
> > If range.start or range.minlen is bigger than filesystem size,
> > return
> > invalid value error. This fixes possible overflow in BTOBB macro
> > when
> > passed value was nearly ULLONG_MAX.
> > 
> > Signed-off-by: Tomas Racek <tracek@redhat.com>
> 
> looks ok to me.
> 
> Reviewed-by: Dave Chinner <dchinner@redhat.com>
> --
> Dave Chinner
> david@fromorbit.com
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
