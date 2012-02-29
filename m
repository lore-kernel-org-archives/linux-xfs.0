Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q1T7ehWb257712 for <xfs@oss.sgi.com>; Wed, 29 Feb 2012 01:40:43 -0600
Received: from smtp.pobox.com (b-pb-sasl-quonix.pobox.com [208.72.237.35]) by
	cuda.sgi.com with ESMTP id xT4Aeyj0Zh11iHlJ for
	<xfs@oss.sgi.com>; Tue, 28 Feb 2012 23:40:40 -0800 (PST)
Date: Wed, 29 Feb 2012 07:40:40 +0000
From: Brian Candler <B.Candler@pobox.com>
Subject: Re: mount: Structure needs cleaning
Message-ID: <20120229074040.GA4192@nsrc.org>
References: <33393100.post@talk.nabble.com>
	<4F49B693.4080309@hardwarefreak.com> <33393429.post@talk.nabble.com>
	<20120227004902.GQ3592@dastard> <33397518.post@talk.nabble.com>
	<20120228014813.GU3592@dastard> <20120228091441.GA1562@nsrc.org>
	<20120229035044.GY3592@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120229035044.GY3592@dastard>
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
Cc: xfs@oss.sgi.com

On Wed, Feb 29, 2012 at 02:50:44PM +1100, Dave Chinner wrote:
> > > http://xfs.org/index.php/XFS_FAQ#Q._Which_settings_does_my_RAID_controller_need_.3F
> > 
> > As a side question to this: if I am using Linux's md software RAID with an
> > HBA, and XFS is using write barriers (as I believe it does by default), is
> > it still necessary to disable write caching on the drives?
> 
> No. The MD layers pass the correct flushes to the drives now.

Thank you: that's very clear and very helpful.

Regards,

Brian.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
