Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 17F797F37
	for <xfs@oss.sgi.com>; Fri, 10 Jul 2015 17:42:40 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 94304AC00B
	for <xfs@oss.sgi.com>; Fri, 10 Jul 2015 15:42:36 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	DDzFlZNYOwjkMLuf for <xfs@oss.sgi.com>;
	Fri, 10 Jul 2015 15:42:33 -0700 (PDT)
Date: Sat, 11 Jul 2015 08:42:31 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Issue with RHEL6 mkfs.xfs (3.1.1+), HP P420 RAID, and MySQL
	replication
Message-ID: <20150710224231.GL3902@dastard>
References: <110866563.1804043.1436463170539.JavaMail.yahoo@mail.yahoo.com>
	<20150709230222.GD7943@dastard>
	<1741803883.2585541.1436543988567.JavaMail.yahoo@mail.yahoo.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1741803883.2585541.1436543988567.JavaMail.yahoo@mail.yahoo.com>
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
To: Hogan Whittall <whittalh@yahoo-inc.com>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

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
