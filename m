Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q1T3on98242953 for <xfs@oss.sgi.com>; Tue, 28 Feb 2012 21:50:49 -0600
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	RFH68MEl02iymmKc for <xfs@oss.sgi.com>;
	Tue, 28 Feb 2012 19:50:46 -0800 (PST)
Date: Wed, 29 Feb 2012 14:50:44 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: mount: Structure needs cleaning
Message-ID: <20120229035044.GY3592@dastard>
References: <33393100.post@talk.nabble.com>
	<4F49B693.4080309@hardwarefreak.com>
	<33393429.post@talk.nabble.com> <20120227004902.GQ3592@dastard>
	<33397518.post@talk.nabble.com> <20120228014813.GU3592@dastard>
	<20120228091441.GA1562@nsrc.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120228091441.GA1562@nsrc.org>
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
To: Brian Candler <B.Candler@pobox.com>
Cc: xfs@oss.sgi.com

On Tue, Feb 28, 2012 at 09:14:41AM +0000, Brian Candler wrote:
> On Tue, Feb 28, 2012 at 12:48:13PM +1100, Dave Chinner wrote:
> > > Write cache: enabled
> > 
> > There's your problem. You should read all the relevant sections on
> > write caches in the XFS FAQ. e.g:
> > 
> > http://xfs.org/index.php/XFS_FAQ#Q._Which_settings_does_my_RAID_controller_need_.3F
> 
> As a side question to this: if I am using Linux's md software RAID with an
> HBA, and XFS is using write barriers (as I believe it does by default), is
> it still necessary to disable write caching on the drives?

No. The MD layers pass the correct flushes to the drives now.

> My reading of the FAQ suggests that the write barrier by itself should be
> sufficient - but this requires that the md RAID driver implements write
> barriers correctly.  I seem to remember reading a long time ago that LVM
> and/or dmraid didn't, although that may be different now.

It has since about 2.6.35.

> Incidentally I'm using 'mdadm ... -b internal' to ensure that the RAID array
> marks dirty areas, so that if a write part-completes (e.g.  a block is
> written to only one half of a RAID1) then at next power-up this should be
> made consistent again.

Assuming that the dirty area tracking uses write cache flushes
correctly.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
