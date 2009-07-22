Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n6MEBsEQ246740 for <xfs@oss.sgi.com>; Wed, 22 Jul 2009 09:11:56 -0500
Received: from slurp.thebarn.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E836737B61C
	for <xfs@oss.sgi.com>; Wed, 22 Jul 2009 07:12:37 -0700 (PDT)
Received: from slurp.thebarn.com (mail.thebarn.com [208.42.117.202]) by
	cuda.sgi.com with ESMTP id qF98fldDpouH45uO for
	<xfs@oss.sgi.com>; Wed, 22 Jul 2009 07:12:37 -0700 (PDT)
Received: from funky.x.thebarn.com (slurp.x.thebarn.com [10.0.0.11])
	(authenticated bits=0)
	by slurp.thebarn.com (8.14.3/8.14.0) with ESMTP id n6MECKAV080592;
	Wed, 22 Jul 2009 09:12:36 -0500 (CDT)
	(envelope-from cattelan@xfs.org)
Message-ID: <4A671E44.4040305@xfs.org>
Date: Wed, 22 Jul 2009 09:12:20 -0500
From: Russell Cattelan <cattelan@thebarn.com>
MIME-Version: 1.0
Subject: Re: does XFS support block sizes other than 512 bytes?
References: <4A6119B5.6000706@tlinx.org>
In-Reply-To: <4A6119B5.6000706@tlinx.org>
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
To: "Linda A. Walsh" <xfs@tlinx.org>
Cc: xfs-oss <xfs@oss.sgi.com>

Linda A. Walsh wrote:
> This one's a bit more specific than the last.  If memory serves me,
> XFS supported differing block sizes (which you could do on a hardware
> format
> of a SCSI drive) back on IRIX.  But when first ported to Linux it didn't
> work.  Was that ever fixed?  I seem to remember that going to 1-2K
> block sizes
> gave and extra 10%, and it almost seems logical that going to a 4kK
> block size
> would be ideal for xfs (presuming your disk doesn't start getting errors,
> then it might get harder to remap sectors and you'd hit hard disk failure
> (w/o remappable sectors) sooner.
>
> But at least 1K might be a reasonable tradeoff?  Been quite a while since
> I tried it and don't even know if the SAS drives allow it (if they do,
> I wonder
> if the newer SATA drives do?)
Yes
XFS can support any power of 2 sector size up to the page size of your
system.
And it is recommend that on things like raid5 devices that the sector
size be
set to the same size as the filesystem block size.

>
> thanks more... :-)
> -linda
>
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
