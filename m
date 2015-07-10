Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id B01027F37
	for <xfs@oss.sgi.com>; Fri, 10 Jul 2015 18:16:22 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 5BE15AC002
	for <xfs@oss.sgi.com>; Fri, 10 Jul 2015 16:16:19 -0700 (PDT)
Received: from mrout5.yahoo.com (mrout5.yahoo.com [216.145.54.154]) by
	cuda.sgi.com with ESMTP id S3c3pqahC2yju3zd (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 10 Jul 2015 16:16:17 -0700 (PDT)
Received: from omp1034.mail.ne1.yahoo.com (omp1034.mail.ne1.yahoo.com
	[98.138.88.234])
	by mrout5.yahoo.com (8.14.9/8.14.9/y.out) with ESMTP id t6ANFlBn096383
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <xfs@oss.sgi.com>; Fri, 10 Jul 2015 16:15:48 -0700 (PDT)
Date: Fri, 10 Jul 2015 23:15:04 +0000 (UTC)
From: Hogan Whittall <whittalh@yahoo-inc.com>
Message-ID: <1598282205.117137.1436570104177.JavaMail.yahoo@mail.yahoo.com>
In-Reply-To: <20150710224231.GL3902@dastard>
References: <110866563.1804043.1436463170539.JavaMail.yahoo@mail.yahoo.com>
	<20150709230222.GD7943@dastard>
	<1741803883.2585541.1436543988567.JavaMail.yahoo@mail.yahoo.com>
	<20150710224231.GL3902@dastard>
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

The issue isn't random small I/O being sent to disk and the disks maxing out IOPS, it's this particular workload created by MySQL replication and the XFS options that trigger something bad to happen on the controller.  I can run disk I/O tests at the same time that replication is choking and see perfectly fine throughput and response time.  Yeah, it's weird.

As for the noalign option, that would be great to have but it does not exist in version 3.1.1 which RHEL6 uses.  It sounds like not having it in previous 3.x versions was enough of an issue that it was added in 3.2.x, which is great.  I can probably work with this and get our ramdisks used for cloning updated with a stable 3.2.x since that would be more desirable than reverting back to 2.x.x.

Thanks again for your help, now I have a fix that doesn't involve using an old version of mkfs.xfs.

-Hogan

----- Original Message -----
From: Dave Chinner <david@fromorbit.com>
To: Hogan Whittall <whittalh@yahoo-inc.com>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>
Sent: Friday, July 10, 2015 5:42 PM
Subject: Re: Issue with RHEL6 mkfs.xfs (3.1.1+), HP P420 RAID, and MySQL replication

On Fri, Jul 10, 2015 at 03:59:48PM +0000, Hogan Whittall wrote:
> Hi Dave,
> 
> Thanks for the reply, we can certainly try with the smaller log,
> but IIRC the performance hit wasn't because the disks were busy,
> it was the controller itself trying to determine what changed and
> then write that to disk.

That makes no sense to me - the controller is almost never the IO
limitation in a hardware RAID when random small IO is being issued
by the host.

> Smaller anything should help the
> controller be able to cope better, but that's not really a
> solution.
> 
> Doing disk write performance tests on these systems produce very
> different results, they are capable of much more I/O than what was
> being triggered with this issue.
> 
> Back to why I think this should be considered a bug, by 2.9.6
> setting 0 as the default for sunit/swidth and 3.1.1 having no way
> to set 0 for sunit/swidth the newer versions behave differently

False:

# man mkfs.xfs
....
    noalign
        This  option  disables  automatic geometry detection
        and creates the filesystem without stripe geometry
        alignment even if the underlying storage device
        provides this information.

IOWs:

# mkfs.xfs -d noalign ....

Will do exactly what you want.  Or alternatively:

# mkfs.xfs -d sunit=0,swidth=0 ....

Or perhaps just turning of log stripe unit alignment will be enough:

# mkfs.xfs -l sunit=1 ....


Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
