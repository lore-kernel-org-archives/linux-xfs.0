Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q0P6gWIc178802
	for <linux-xfs@oss.sgi.com>; Wed, 25 Jan 2012 00:42:32 -0600
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	OLgceHtWZV0qHRR4 for <linux-xfs@oss.sgi.com>;
	Tue, 24 Jan 2012 22:42:28 -0800 (PST)
Date: Wed, 25 Jan 2012 17:42:25 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: help with deciphering kernel dmesg
Message-ID: <20120125064225.GR15102@dastard>
References: <a9g4v8xkfp.ln2@goaway.wombat.san-francisco.ca.us>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <a9g4v8xkfp.ln2@goaway.wombat.san-francisco.ca.us>
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
To: Keith Keller <kkeller@wombat.san-francisco.ca.us>
Cc: linux-xfs@oss.sgi.com

On Tue, Jan 24, 2012 at 09:24:26PM -0800, Keith Keller wrote:
> Hello all,
> 
> I had a strange issue with my largish XFS filesystem, and was hoping to
> get some help figuring out what it could mean.
> 
> Background: this is a ~14TB XFS filesystem on top of a linux LVM md
> RAID6 of 9 2TB disks.  In the past, I've had no problems working with this,
> but I recently added a disk to reshape to 10 disks.  During an
> rsnapshot, I got the below messages in dmesg, and when I went to umount
> the fs to do an xfs_repair -n, it claimed that the filesystem was busy,
> even though lsof didn't show any files open on the filesystem.
> 
> The last time I did an mdraid reshape, the kernel did a hard crash on a
> small amount of disk activity, and at that time the kernel messages
> seemed to point to an issue in the mdraid module.  But I wasn't able to
> save the messages, so I'm not sure whether the messages were a trace 
> from the mdraid module or the xfs module.

I suspect that from the IO errors, there is a problem in the md
reshape code, and the XFs code has failed to handle that properly.

> The kernel is the latest from ELrepo (2.6.39-4.el5.elrepo).  I am
> currently running xfs_repair -n, which hasn't yet found any errors.
> (Since the fs isn't mounted I can't yet give xfs_info output, and
> because the RAID6 is still reshaping the xfs_repair is taking a long
> time.  I can interrupt it if needed, but I'm hoping to let it finish.)
> In the past the RAID6 has passed a check, but I have not done one this
> month.  I hope I have munged any identifying information.

the xfs_info output would be really handy for determining what path
through the directory code XFS was taking whenteh crash occurred.

> Thanks for any suggestions; my dmesg output snippet is below.  A
> cursory web search on the keywords in the first line of the dmesg output
> didn't turn up anything terribly interesting.  One I found suggested
> ACLs or SELinux issues, but my system isn't using those AFAIK (at least
> it shouldn't be).
> 
> --keith
> 
> Jan 23 23:09:37 XXXXX kernel: XFS (dm-5): I/O error occurred: meta-data dev dm-5 block 0x57786050       ("xfs_trans_read_buf") error 5 buf count 4096
> Jan 23 23:10:01 XXXXX kernel: XFS (dm-5): I/O error occurred: meta-data dev dm-5 block 0x5778dff8       ("xfs_trans_read_buf") error 5 buf count 4096
> Jan 23 23:10:05 XXXXX kernel: BUG: unable to handle kernel NULL pointer dereference at 0000000000000008
> Jan 23 23:10:05 XXXXX kernel: IP: [<ffffffffa0435ed2>] xfs_da_do_buf+0x43e/0x592 [xfs]

I'd be worried about those IO errors - i don't think that they were
the cause of the oops, but it implies that the underlying device is
bad in some way. That may have something to do with the reshape in
progress which make me worry that the reshape is actually keeping
your data safe....

As it is, the kernel crashed reading a directory buffer. It's hard
to say what went wrong - can you take the kernel image and run:

$ gdb <path/to/kernel>
(gdb) l *(xfs_da_do_buf+0x43e)

And post the output so we can see what line number in the code the
crash occurred at? That might provide a bit more of a clue to what
the problem is.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
