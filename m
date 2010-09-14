Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o8E1L85T099696 for <xfs@oss.sgi.com>; Mon, 13 Sep 2010 20:21:08 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 7C02017E32F3
	for <xfs@oss.sgi.com>; Mon, 13 Sep 2010 18:21:54 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail13.adl6.internode.on.net
	[150.101.137.98]) by cuda.sgi.com with ESMTP id
	znxnon2sCtSAZmMA for <xfs@oss.sgi.com>;
	Mon, 13 Sep 2010 18:21:54 -0700 (PDT)
Date: Tue, 14 Sep 2010 11:21:51 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: XFS Filesystem not mounting
Message-ID: <20100914012151.GF411@dastard>
References: <29704010.post@talk.nabble.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <29704010.post@talk.nabble.com>
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
To: pbrunnen <PBrunnen@bccnetworks.net>
Cc: xfs@oss.sgi.com

On Mon, Sep 13, 2010 at 04:45:23PM -0700, pbrunnen wrote:
> 
> Hello all,
> 
> Pardon the cross post...
> 
> I have an XFS filesystem (not my root filesystem) on an OpenSuSE system that
> is not mounting.

What kernel version is that?

> We had a power failure over the weekend. All but one of our XFS mounts is
> comming up. Its a large mount (2TB) and I am not seeing errors per se...

What sort of hardware is it on? (raid controller, raid level, etc)

> But after attempting to mount it, it has been 4 hours and all we see in
> either dmesg output or in the messages file from the kernel is:
> 
> "Starting FXS recovery on filesystem: sdd1 (logdev: internal)"
> 
> Our mount process is dead and I don't see any disk i/o going on. Am I
> missing something here on this?

There's a good chance your storage is in a bad state. Can you send the output
of "echo w > /proc/sysrq-trigger" when the system is hung?

> I rebooted the box once earlier and was able mount read-only with
> norecovery...
> 
> I tried xfs_check and it also produced a dead "xfs_df -i -p xfs_check -c
> check /dev/sdd1"

Definitely sounding like a hardware issue - once again can you post
the output of the above sysrq command when it is hung there?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
