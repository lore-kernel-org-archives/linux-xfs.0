Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 98AEF7F37
	for <xfs@oss.sgi.com>; Thu,  9 Jul 2015 18:02:56 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 1759BAC007
	for <xfs@oss.sgi.com>; Thu,  9 Jul 2015 16:02:52 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	JvhJSt9ZjGTDg3Qv for <xfs@oss.sgi.com>;
	Thu, 09 Jul 2015 16:02:50 -0700 (PDT)
Date: Fri, 10 Jul 2015 09:02:22 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Issue with RHEL6 mkfs.xfs (3.1.1+), HP P420 RAID, and MySQL
	replication
Message-ID: <20150709230222.GD7943@dastard>
References: <110866563.1804043.1436463170539.JavaMail.yahoo@mail.yahoo.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <110866563.1804043.1436463170539.JavaMail.yahoo@mail.yahoo.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Hogan Whittall <whittalh@yahoo-inc.com>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On Thu, Jul 09, 2015 at 05:32:50PM +0000, Hogan Whittall wrote:
> Hello,
>
> Recently we encountered a previously-reported issue
> regarding write amplification with MySQL replication and XFS when
> used with certain RAID controllers (In our case, HP P420). =A0That
> issue exactly matches our issue and was documented by someone else
> here -=A0http://oss.sgi.com/archives/xfs/2013-03/msg00133.html=A0-
> but I don't see any resolution. =A0I will say that the problem
> *does not* exist when mkfs.xfs 2.9.6 is used to format the
> filesystem on RHEL6 as that sets sunit=3D0 and swidth=3D0 instead of
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

> =A0If we take the same box and format the MySQL partition with
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
-- =

Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
