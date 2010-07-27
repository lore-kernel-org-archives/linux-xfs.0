Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o6RDRaS4188179 for <xfs@oss.sgi.com>; Tue, 27 Jul 2010 08:27:37 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 925421E3436D
	for <xfs@oss.sgi.com>; Tue, 27 Jul 2010 06:30:40 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail13.adl6.internode.on.net
	[150.101.137.98]) by cuda.sgi.com with ESMTP id
	spUvGKyzDnupmOIH for <xfs@oss.sgi.com>;
	Tue, 27 Jul 2010 06:30:40 -0700 (PDT)
Date: Tue, 27 Jul 2010 23:30:38 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: XFS hang in xlog_grant_log_space (was Re: VFS scalability git
	tree)
Message-ID: <20100727133038.GP7362@dastard>
References: <20100722190100.GA22269@amd> <20100723135514.GJ32635@dastard>
	<20100727070538.GA2893@amd> <20100727080632.GA4958@amd>
	<20100727113626.GA2884@amd>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100727113626.GA2884@amd>
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
To: Nick Piggin <npiggin@kernel.dk>
Cc: xfs@oss.sgi.com

On Tue, Jul 27, 2010 at 09:36:26PM +1000, Nick Piggin wrote:
> On Tue, Jul 27, 2010 at 06:06:32PM +1000, Nick Piggin wrote:
> On this same system, same setup (vanilla kernel with sha given below),
> I have now twice reproduced a complete hang in XFS. I can give more
> information, test patches or options etc if required.
> 
> setup.sh looks like this:
> #!/bin/bash
> modprobe rd rd_size=$[2*1024*1024]
> dd if=/dev/zero of=/dev/ram0 bs=4K
> mkfs.xfs -f -l size=64m -d agcount=16 /dev/ram0
> mount -o delaylog,logbsize=262144,nobarrier /dev/ram0 mnt
> 
> The 'dd' is required to ensure rd driver does not allocate pages
> during IO (which can lead to out of memory deadlocks). Running just
> involves changing into mnt directory and
> 
> while true
> do
>   sync
>   echo 3 > /proc/sys/vm/drop_caches
>   ../dbench -c ../loadfiles/client.txt -t20 8
>   rm -rf clients
> done
> 
> And wait for it to hang (happend in < 5 minutes here)
....
> Call Trace:
>  [<ffffffff812361f8>] xlog_grant_log_space+0x158/0x3d0

It's waiting on log space to be freed up. Either there's an
accounting problem (possible), or you've got an xfslogd/xfsaild
spinning and not making progress competing log IOs or pushing the
tail of the log. I'll see if I can reproduce it.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
