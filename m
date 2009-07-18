Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n6I0cdvD124325 for <xfs@oss.sgi.com>; Fri, 17 Jul 2009 19:38:40 -0500
Received: from Ishtar.tlinx.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8FD2E10A7BBC
	for <xfs@oss.sgi.com>; Fri, 17 Jul 2009 17:47:08 -0700 (PDT)
Received: from Ishtar.tlinx.org (ishtar.tlinx.org [64.81.245.74]) by
	cuda.sgi.com with ESMTP id bJ5thOxCLvZii5i4 for
	<xfs@oss.sgi.com>; Fri, 17 Jul 2009 17:47:08 -0700 (PDT)
Received: from [192.168.3.11] (Athena [192.168.3.11])
	by Ishtar.tlinx.org (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n6I0dHpd031776 for <xfs@oss.sgi.com>; Fri, 17 Jul 2009 17:39:19 -0700
Message-ID: <4A6119B5.6000706@tlinx.org>
Date: Fri, 17 Jul 2009 17:39:17 -0700
From: "Linda A. Walsh" <xfs@tlinx.org>
MIME-Version: 1.0
Subject: does XFS support block sizes other than 512 bytes?
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs-oss <xfs@oss.sgi.com>

This one's a bit more specific than the last.  If memory serves me,
XFS supported differing block sizes (which you could do on a hardware format
of a SCSI drive) back on IRIX.  But when first ported to Linux it didn't
work.  Was that ever fixed?  I seem to remember that going to 1-2K block sizes
gave and extra 10%, and it almost seems logical that going to a 4kK block size
would be ideal for xfs (presuming your disk doesn't start getting errors,
then it might get harder to remap sectors and you'd hit hard disk failure
(w/o remappable sectors) sooner.

But at least 1K might be a reasonable tradeoff?  Been quite a while since
I tried it and don't even know if the SAS drives allow it (if they do, I wonder
if the newer SATA drives do?)

thanks more... :-)
-linda

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
