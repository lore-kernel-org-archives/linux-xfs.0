Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id E9A327F37
	for <xfs@oss.sgi.com>; Fri, 10 Jul 2015 11:00:32 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id C370630404E
	for <xfs@oss.sgi.com>; Fri, 10 Jul 2015 09:00:29 -0700 (PDT)
Received: from mrout6.yahoo.com (mrout6.yahoo.com [216.145.54.155]) by
	cuda.sgi.com with ESMTP id rbeemj6q90IbVDDk (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 10 Jul 2015 09:00:26 -0700 (PDT)
Received: from omp1049.mail.ne1.yahoo.com (omp1049.mail.ne1.yahoo.com
	[98.138.89.234])
	by mrout6.yahoo.com (8.14.9/8.14.9/y.out) with ESMTP id t6AG0E69073197
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <xfs@oss.sgi.com>; Fri, 10 Jul 2015 09:00:14 -0700 (PDT)
Date: Fri, 10 Jul 2015 15:59:48 +0000 (UTC)
From: Hogan Whittall <whittalh@yahoo-inc.com>
Message-ID: <1741803883.2585541.1436543988567.JavaMail.yahoo@mail.yahoo.com>
In-Reply-To: <20150709230222.GD7943@dastard>
References: <110866563.1804043.1436463170539.JavaMail.yahoo@mail.yahoo.com>
	<20150709230222.GD7943@dastard>
Subject: Re: Issue with RHEL6 mkfs.xfs (3.1.1+), HP P420 RAID, and MySQL
	replication
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

Hi Dave,

Thanks for the reply, we can certainly try with the smaller log, but IIRC the performance hit wasn't because the disks were busy, it was the controller itself trying to determine what changed and then write that to disk.  Smaller anything should help the controller be able to cope better, but that's not really a solution.

Doing disk write performance tests on these systems produce very different results, they are capable of much more I/O than what was being triggered with this issue.

Back to why I think this should be considered a bug, by 2.9.6 setting 0 as the default for sunit/swidth and 3.1.1 having no way to set 0 for sunit/swidth the newer versions behave differently and don't provide any way to set the same options as 2.x.x.  To me, that kind of behavior is a bug, especially when the new defaults provide horrible performance under specific workloads with specific hardware.  If the newer versions are going to automatically calculate sunit/swidth then there needs to be a way to either disable that functionality or override it by allowing 0 to be set manually.

If the only way for us to truly restore performance on these HP systems is to run a 2.x.x version of mkfs.xfs then how is this not a bug?

We have a number of non-HP boxes running RHEL6 with hardware RAID, it's only the HP P420 RAID that is exposing IO size parameters to the kernel, all of the others show 0 or 512 and mkfs.xfs 3.1.1 knows to set sunit/swidth to 0 when those values are encountered.  Not being able to manually set 0 when it is a valid setting...that's a bug, IMO.

Thanks for your time!

-Hogan

----- Original Message -----
From: Dave Chinner <david@fromorbit.com>
To: Hogan Whittall <whittalh@yahoo-inc.com>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>
Sent: Thursday, July 9, 2015 6:02 PM
Subject: Re: Issue with RHEL6 mkfs.xfs (3.1.1+), HP P420 RAID, and MySQL replication

On Thu, Jul 09, 2015 at 05:32:50PM +0000, Hogan Whittall wrote:
> Hello,
>
> Recently we encountered a previously-reported issue
> regarding write amplification with MySQL replication and XFS when
> used with certain RAID controllers (In our case, HP P420).  That
> issue exactly matches our issue and was documented by someone else
> here - http://oss.sgi.com/archives/xfs/2013-03/msg00133.html -
> but I don't see any resolution.  I will say that the problem
> *does not* exist when mkfs.xfs 2.9.6 is used to format the
> filesystem on RHEL6 as that sets sunit=0 and swidth=0 instead of
> setting based on minimum_io_size and optimal_io_size.

The issue is the log stripe unit padding log buffers on log
writes.  Your workload like has lots of fsync() calls, which means
log writes go from being padded to the next sector boundary to being
padded to the next log stripe unit boundary.

> We have systems that are identical in how they are built and
> configured, we can take a RHEL6 box that has the MySQL partition
> formatted with mkfs.xfs v3.1.1 and reproduce the write
> amplification problem with MySQL replication every single time.

Because the more recent kernel is probably getting sunit/swidth
direct from the hardware via the kernel.


>  If we take the same box and format the MySQL partition with
> mkfs.xfs 2.9.6, then bring up MySQL with the exact same
> configuration there is no problem.

Because that version of mkfs doesn't know about the kernel optimum
IO size parameters in sysfs that are set based on hardware mode page
support. Hence older mkfs is not able to set stripe unit defaults
for hardware RAID automatically....

Your other option is to use a small log, so that the log writes end
up being permanently pinned in the RAID BBWC, and so the bandwith
they consume doesn't matter because it never hits the platters...

FWIW, this problem has only been reported for HP RAID hardware, so I
suspect that there is something the HP RAID firmware that doesn't
handle streaming FUA writes (the log writes) mixed with other random
IO particularly well.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
