Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q2DNL9FE078257 for <xfs@oss.sgi.com>; Tue, 13 Mar 2012 18:21:09 -0500
Received: from sam.nabble.com (sam.nabble.com [216.139.236.26]) by
	cuda.sgi.com with ESMTP id hfFABqMNnj9R4vts (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 13 Mar 2012 16:21:07 -0700 (PDT)
Received: from isper.nabble.com ([192.168.236.156])
	by sam.nabble.com with esmtp (Exim 4.72)
	(envelope-from <lists@nabble.com>) id 1S7b1f-0001lm-7v
	for xfs@oss.sgi.com; Tue, 13 Mar 2012 16:21:07 -0700
Message-ID: <33498437.post@talk.nabble.com>
Date: Tue, 13 Mar 2012 16:21:07 -0700 (PDT)
From: troby <Thorn.Roby@harlandfs.com>
Subject: How to deal with XFS stripe geometry mismatch with hardware RAID5
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
To: xfs@oss.sgi.com


I have a 30TB XFS filesystem created on CentOS 5.4 X86_64, kernel 2.6.39,
using xfsprogs 2.9.4. The underlying hardware is 12 3TB SATA drives on a
Dell PERC 700 controller with 1GB cache. There is an external journal on a
separate set of 15k SAS drives (I suspect now this was unnecessary, because
there is very little metadata activity). When I created the filesystem I
(mistakenly) believed the stripe width of the filesystem should count all 12
drives rather than 11. I've seen some opinions that this is correct, but a
larger number which have convinced me that it is not. I also set up the RAID
BIOS to use a small stripe element of 8KB per drive, based on the I/O
request size I was seeing at the time in previous installations of the same
application, which was generally doing writes around 100KB. l'm trying to
determine how to proceed to optimize write performance. Recreating the
filesystem and its existing data is not out of the question, but would be a
last resort.

The filesystem contains a MongoDB installation consisting of roughly 13000
2GB files which are already allocated. The application is almost exclusively
inserting data, there are no updates, and files are written pretty much
sequentially. When I set up the fstab entry I believed that it would inherit
the stripe geometry automatically, however now I understand that is not the
case with XFS version 2. What I'm seeing now is average request sizes which
are about 100KB, half the stripe size. With a typical write volume around
5MB per second I am getting wait times around 50ms, which appears to be
degrading performance. The filesystem was created on a partition aligned to
a 1MB boundary.

Short of recreating the filesystem with the correct stripe width, would it
make sense to change the mount options to define a stripe width that
actually matches either the filesystem (11 stripe elements wide) or the
hardware (12 stripe elements wide)? Is there a danger of filesystem
corruption if I give fstab a mount geometry that doesn't match the values
used at filesystem creation time?

I'm unclear on the role of the RAID hardware cache in this. Since the writes
are sequential, and since the volume of data written is such that it would
take about 3 minutes to actually fill the RAID cache, I would think the data
would be resident in the cache long enough to assemble a full-width stripe
at the hardware level and avoid the 4 I/O RAID5 penalty. 
-- 
View this message in context: http://old.nabble.com/How-to-deal-with-XFS-stripe-geometry-mismatch-with-hardware-RAID5-tp33498437p33498437.html
Sent from the Xfs - General mailing list archive at Nabble.com.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
