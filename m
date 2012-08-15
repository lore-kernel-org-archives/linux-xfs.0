Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q7FE24kn142827 for <xfs@oss.sgi.com>; Wed, 15 Aug 2012 09:02:04 -0500
Date: Wed, 15 Aug 2012 09:02:00 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH v4] xfs: check for possible overflow in xfs_ioc_trim
Message-ID: <20120815140200.GB22462@sgi.com>
References: <20120814213629.GL2877@dastard>
	<1805964222.1573527.1345033412870.JavaMail.root@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1805964222.1573527.1345033412870.JavaMail.root@redhat.com>
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
Cc: lczerner@redhat.com, Alex Elder <elder@kernel.org>, xfs@oss.sgi.com

On Wed, Aug 15, 2012 at 08:23:32AM -0400, Tomas Racek wrote:
> Forwarding to maintainers.

Thanks Tomas.  We'll get this sorted.

Regards,
	Ben

> 
> ----- Original Message -----
> > On Tue, Aug 14, 2012 at 10:35:04AM +0200, Tomas Racek wrote:
> > > If range.start or range.minlen is bigger than filesystem size,
> > > return
> > > invalid value error. This fixes possible overflow in BTOBB macro
> > > when
> > > passed value was nearly ULLONG_MAX.
> > > 
> > > Signed-off-by: Tomas Racek <tracek@redhat.com>
> > 
> > looks ok to me.
> > 
> > Reviewed-by: Dave Chinner <dchinner@redhat.com>
> > --
> > Dave Chinner
> > david@fromorbit.com
> > 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
