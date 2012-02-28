Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q1S9ElqU171413 for <xfs@oss.sgi.com>; Tue, 28 Feb 2012 03:14:47 -0600
Received: from smtp.pobox.com (b-pb-sasl-quonix.pobox.com [208.72.237.35]) by
	cuda.sgi.com with ESMTP id tYqFEc9Td8qIAfiT for
	<xfs@oss.sgi.com>; Tue, 28 Feb 2012 01:14:46 -0800 (PST)
Received: from smtp.pobox.com (unknown [127.0.0.1])
	by b-sasl-quonix.pobox.com (Postfix) with ESMTP id 064C24A76
	for <xfs@oss.sgi.com>; Tue, 28 Feb 2012 04:14:45 -0500 (EST)
Received: from b-pb-sasl-quonix.pobox.com (unknown [127.0.0.1])
	by b-sasl-quonix.pobox.com (Postfix) with ESMTP id EDAE54A72
	for <xfs@oss.sgi.com>; Tue, 28 Feb 2012 04:14:43 -0500 (EST)
Received: from device-12dac2 (unknown [92.40.254.207]) (using TLSv1 with
	cipher DHE-RSA-AES256-SHA (256/256 bits)) (No client certificate
	requested)
	by b-sasl-quonix.pobox.com (Postfix) with ESMTPSA id 5141C4A6D for
	<xfs@oss.sgi.com>; Tue, 28 Feb 2012 04:14:43 -0500 (EST)
Received: from brian by device-12dac2 with local (Exim 4.77) (envelope-from
	<b.candler@pobox.com>) id M03J0H-000182-8O for xfs@oss.sgi.com;
	Tue, 28 Feb 2012 09:14:41 +0000
Date: Tue, 28 Feb 2012 09:14:41 +0000
From: Brian Candler <B.Candler@pobox.com>
Subject: Re: mount: Structure needs cleaning
Message-ID: <20120228091441.GA1562@nsrc.org>
References: <33393100.post@talk.nabble.com>
	<4F49B693.4080309@hardwarefreak.com> <33393429.post@talk.nabble.com>
	<20120227004902.GQ3592@dastard> <33397518.post@talk.nabble.com>
	<20120228014813.GU3592@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120228014813.GU3592@dastard>
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
To: xfs@oss.sgi.com

On Tue, Feb 28, 2012 at 12:48:13PM +1100, Dave Chinner wrote:
> > Write cache: enabled
> 
> There's your problem. You should read all the relevant sections on
> write caches in the XFS FAQ. e.g:
> 
> http://xfs.org/index.php/XFS_FAQ#Q._Which_settings_does_my_RAID_controller_need_.3F

As a side question to this: if I am using Linux's md software RAID with an
HBA, and XFS is using write barriers (as I believe it does by default), is
it still necessary to disable write caching on the drives?

My reading of the FAQ suggests that the write barrier by itself should be
sufficient - but this requires that the md RAID driver implements write
barriers correctly.  I seem to remember reading a long time ago that LVM
and/or dmraid didn't, although that may be different now.

Incidentally I'm using 'mdadm ... -b internal' to ensure that the RAID array
marks dirty areas, so that if a write part-completes (e.g.  a block is
written to only one half of a RAID1) then at next power-up this should be
made consistent again.

Regards,

Brian.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
