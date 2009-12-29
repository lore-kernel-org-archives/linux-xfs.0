Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	nBTLxt7o189809 for <xfs@oss.sgi.com>; Tue, 29 Dec 2009 15:59:56 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 63DBA1C20D5F
	for <xfs@oss.sgi.com>; Tue, 29 Dec 2009 14:00:39 -0800 (PST)
Received: from mail.internode.on.net (bld-mail13.adl6.internode.on.net
	[150.101.137.98]) by cuda.sgi.com with ESMTP id
	6JVDHCH4RX971ALd for <xfs@oss.sgi.com>;
	Tue, 29 Dec 2009 14:00:39 -0800 (PST)
Date: Wed, 30 Dec 2009 09:00:36 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Call trace with 2.6.27.39
Message-ID: <20091229220036.GA13802@discord.disaster>
References: <4B3A47F8.2020100@poczta.onet.pl>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4B3A47F8.2020100@poczta.onet.pl>
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
To: aluno3 <aluno3@poczta.onet.pl>
Cc: xfs@oss.sgi.com

On Tue, Dec 29, 2009 at 07:18:32PM +0100, aluno3 wrote:
> Hi
>  
> I have tested kernel 2.6.27.39 with fsstress, LVM, DD and snapshots and after a few hours I got call trace.I had 2 volumes and 10 snapshots for each volume.I created and deleted these snapshots from time to time and wrote to origin volumes with use DD from /dev/zero.Fsstress was run for 1 volume.
> 
> 
> Filesystem "dm-41": xfs_log_force: error 5 returned.

What were the errors in the log before this? i.e. why did
xfs_log_force() get an EIO error? It sounds like there's something
already gone wrong before this point.

> BUG: unable to handle kernel NULL pointer dereference at 0000000000000000
> IP: [<ffffffff802e99c3>] bdevname+0x3/0x20
....
> Process xfslogd/0 (pid: 404, threadinfo ffff88021d956000, task ffff88021fafd890)
> Stack:  ffffffff803e7526 ffff880028046970 ffffffff80817020 ffff88021d957e38
>  00000000ffff8b92 ffff88021fafdac0 ffff88021fafd890 000000001d957eb8
>  ffff880207fe8800 ffff88007fbf6cc0 ffff88021d937bc8 ffff88021d937bc8
> Call Trace:
>  [<ffffffff803e7526>] ? xfs_ioerror_alert+0x56/0xc0
>  [<ffffffff803d5060>] ? xlog_recover_iodone+0x40/0x90
>  [<ffffffff803eaa60>] ? xfs_buf_iodone_work+0x0/0x80

This has died during log recovery (on a different filesytem?), which
implies that a buffer has not been set up properly with a buftarg or
mount stucture. I can't see how that would happen from the code
because each place that explicitly sets xlog_recover_iodone() as the
completion also sets the bp->b_mount correctly. Still, there's been
an IO error of some kind to get to xfs_ioerror_alert(), so it comes
back to whether there were errors reported before this failure?

Also, were you mounting a snapshot when this occurred? If so, you
shouldn't be doing log recovery on a snapshot because that writes to
the snapshot - you should mount them with the "ro,norecovery"
options to avoid this.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
