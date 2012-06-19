Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q5J3CpES019561 for <xfs@oss.sgi.com>; Mon, 18 Jun 2012 22:12:52 -0500
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id KN3fL5BvXZ1CM5a3 for
	<xfs@oss.sgi.com>; Mon, 18 Jun 2012 20:12:51 -0700 (PDT)
Date: Mon, 18 Jun 2012 23:12:42 -0400
From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: Ext4 and xfs problems in dm-thin on allocation and discard
Message-ID: <20120619031241.GA3884@redhat.com>
References: <4FDF9EBE.2030809@shiftmail.org> <20120619015745.GJ25389@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120619015745.GJ25389@dastard>
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
Cc: device-mapper development <dm-devel@redhat.com>, linux-ext4@vger.kernel.org, xfs@oss.sgi.com, Spelic <spelic@shiftmail.org>

On Mon, Jun 18 2012 at  9:57pm -0400,
Dave Chinner <david@fromorbit.com> wrote:

> On Mon, Jun 18, 2012 at 11:33:50PM +0200, Spelic wrote:
>
> > Please note that since I am above MD raid5 (I believe this is the
> > reason), the passdown of discards does not work, as my dmesg says:
> > [160508.497879] device-mapper: thin: Discard unsupported by data
> > device (dm-1): Disabling discard passdown.
> > but AFAIU, unless there is a thinp bug, this should not affect the
> > unmapping of thin blocks by fstrimming xfs... and in fact ext4 is
> > able to do that.
> 
> Does ext4 report that same error?

That message says the underlying device doesn't support discards
(because it is an MD device).  But the thinp device still has discards
enabled -- it just won't pass the discards down to the underlying data
device.

So yes, it'll happen with ext4 -- it is generated when the thin-pool
device is loaded (which happens independent of the filesystem that is
layered ontop).

The discards still inform the thin-pool that the corresponding extents
are no longer allocated.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
