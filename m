Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p6QAS7qn122994 for <xfs@oss.sgi.com>; Tue, 26 Jul 2011 05:28:08 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E4A721E6B33A
	for <xfs@oss.sgi.com>; Tue, 26 Jul 2011 03:28:05 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	zc6FED3m4CO8bA3z for <xfs@oss.sgi.com>;
	Tue, 26 Jul 2011 03:28:05 -0700 (PDT)
Date: Tue, 26 Jul 2011 06:27:59 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: XFS internal error XFS_WANT_CORRUPTED_GOTO
Message-ID: <20110726102759.GA20478@infradead.org>
References: <CADDb1s3X5PANPrrz=GRZZyKmSK1=xiBQ8+zz3WNTW6xN=c80PQ@mail.gmail.com>
	<CADDb1s04zm48uQ0mZAUsNZ_rDX-KnSHNeFsYb06Hg10k59ijOQ@mail.gmail.com>
	<CADDb1s2rcEvik3Tb4zooq93A6BSP+W9K87VdJEWLN9iHY1StMQ@mail.gmail.com>
	<20110722083457.GC13963@dastard>
	<CADDb1s1MpajXEHhMVf-h2K1JKQqaDLZ0QQY41seURUpde8D7Sg@mail.gmail.com>
	<20110724013457.GB31951@dastard>
	<CADDb1s3JnFQiKqjD6ANDkUUyCtVwg=LDeKe4piK3ZwzQ6FK83w@mail.gmail.com>
	<20110726033302.GB8048@dastard>
	<CAB4K4y7SYX6AW45aYsM3243VSq=jJ6LErQP8SPrxgGOFtJVrrw@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAB4K4y7SYX6AW45aYsM3243VSq=jJ6LErQP8SPrxgGOFtJVrrw@mail.gmail.com>
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
To: Ajeet Yadav <ajeet.yadav.77@gmail.com>
Cc: Amit Sahrawat <amit.sahrawat83@gmail.com>, xfs@oss.sgi.com

On Tue, Jul 26, 2011 at 03:17:48PM +0530, Ajeet Yadav wrote:
> Hello Dave,
> I have seen this problem comes only with USB HDD (we have tired
> different USB HDD, but it seems common with HDD), while USB FLASH
> works fine.

Can you make sure the USB HDD actually does flush caches reliably and
doesn't lose data it claims it guaranteed to disk?  In addition to the
generally bad implementation quality of USB periphals there is a large
chance of beeing lost in translation when converting the SCSI WCE mode
and FUA bit concepts to the ATA equivalents.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
