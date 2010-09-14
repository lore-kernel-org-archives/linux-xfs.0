Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o8E5dMa8111336 for <xfs@oss.sgi.com>; Tue, 14 Sep 2010 00:39:23 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id EC27D17EF635
	for <xfs@oss.sgi.com>; Mon, 13 Sep 2010 22:40:09 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail18.adl2.internode.on.net
	[150.101.137.103]) by cuda.sgi.com with ESMTP id
	5sWKjbbLbeZlAesJ for <xfs@oss.sgi.com>;
	Mon, 13 Sep 2010 22:40:09 -0700 (PDT)
Date: Tue, 14 Sep 2010 15:40:01 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: XFS Filesystem not mounting
Message-ID: <20100914054001.GG411@dastard>
References: <29704010.post@talk.nabble.com> <20100914012151.GF411@dastard>
	<29705181.post@talk.nabble.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <29705181.post@talk.nabble.com>
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

On Mon, Sep 13, 2010 at 09:43:51PM -0700, pbrunnen wrote:
> 
> Dave,
> 
> > There's a good chance your storage is in a bad state. Can you send the
> > output
> > of "echo w > /proc/sysrq-trigger" when the system is hung?
> 
> I issued your command this after running 'mount /dev/sdd1 /data'
> 
> dmesg outputs:
> XFS mounting filesystem sdd1
> Starting XFS recovery on filesystem: sdd1 (logdev: internal)
> SysRq : HELP : loglevel0-8 reBoot Crashdump tErm Full kIll saK showMem Nice
> powerOff showPc unRaw Sync showTasks Unmount 
> 
> 
> Not much... nothing on the command line appears.

Yeah, your kernel is so old it doesn't support that function. Use
"echo t > /proc/sysrq-trigger". Hunt through the output for the
stack trace associated with th ehung mount/xfs-check process.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
