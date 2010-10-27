Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o9R3slig133149 for <xfs@oss.sgi.com>; Tue, 26 Oct 2010 22:54:47 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2323313619C2
	for <xfs@oss.sgi.com>; Tue, 26 Oct 2010 21:11:38 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail13.adl6.internode.on.net
	[150.101.137.98]) by cuda.sgi.com with ESMTP id
	UGvd2tN0xABf4yWb for <xfs@oss.sgi.com>;
	Tue, 26 Oct 2010 21:11:38 -0700 (PDT)
Date: Wed, 27 Oct 2010 14:55:48 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Pid: 8345, comm: rsync Not tainted 2.6.32.22intel #1
Message-ID: <20101027035548.GD32255@dastard>
References: <4CC67450.9020602@profihost.ag> <4CC6B56B.7020007@profihost.ag>
	<20101026132505.6af29d5d@harpe.intellique.com>
	<201010270124.44846@zmi.at>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <201010270124.44846@zmi.at>
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
To: Michael Monnerie <michael.monnerie@is.it-management.at>
Cc: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>, xfs@oss.sgi.com

On Wed, Oct 27, 2010 at 01:23:35AM +0200, Michael Monnerie wrote:
> On Dienstag, 26. Oktober 2010 Emmanuel Florac wrote:
> > echo "noop" > /sys/block/sdc/queue/scheduler
> > echo 512 > /sys/block/sdc/queue/nr_requests
> > blockdev --setra 4096 /dev/sdc
> 
> How about this small script in /etc/init.d/boot.local?
> 
> for i in /dev/xvd? /dev/sd? ; do
>    if test "$i" == "${i%\?}" ; then
>       echo i=$i
>       blockdev --setra 1024 $i
>       j=${i#/dev/}
>       echo j=$j
>       echo noop >/sys/block/$j/queue/scheduler
>       echo 512 >/sys/block/$j/queue/nr_requests
>    fi
> done
> 
> This works for VMs within XenServer (/dev/xvda) and real servers 
> (/dev/sda), and sets some values for all drives.

I'd suggest that people learn how to tweak udev hotplug rules so
that when the device is first created (i.e. during hotplug) the
scheduler, queue depth and readahead are set automatically. That way
you don't have to rely on devices being discovered before your script
runs...

Another benefit of doing it this way is that it is easy to set
default rules for different types of devices based on regex matching
e.g. different configs for "sd*" vs "dm*" vs "vd*" are trivial to
set up.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
