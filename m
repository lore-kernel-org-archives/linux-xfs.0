Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n9J33Xui022771 for <xfs@oss.sgi.com>; Sun, 18 Oct 2009 22:03:33 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E5EE21BF8336
	for <xfs@oss.sgi.com>; Sun, 18 Oct 2009 20:05:04 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail14.adl6.internode.on.net
	[150.101.137.99]) by cuda.sgi.com with ESMTP id
	JdZ9B7Qfu2jt7tpj for <xfs@oss.sgi.com>;
	Sun, 18 Oct 2009 20:05:04 -0700 (PDT)
Date: Mon, 19 Oct 2009 14:04:56 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: 2.6.31+2.6.31.4: XFS - All I/O locks up to D-state after 24-48
	hours (sysrq-t+w available)
Message-ID: <20091019030456.GS9464@discord.disaster>
References: <alpine.DEB.2.00.0910171825270.16781@p34.internal.lan>
	<alpine.DEB.2.00.0910181607040.27363@p34.internal.lan>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0910181607040.27363@p34.internal.lan>
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
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: linux-raid@vger.kernel.org, Alan Piszcz <ap@solarrain.com>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

On Sun, Oct 18, 2009 at 04:17:42PM -0400, Justin Piszcz wrote:
> It has happened again, all sysrq-X output was saved this time.
>
> wget http://home.comcast.net/~jpiszcz/20091018/crash.txt
> wget http://home.comcast.net/~jpiszcz/20091018/dmesg.txt
> wget http://home.comcast.net/~jpiszcz/20091018/interrupts.txt
> wget http://home.comcast.net/~jpiszcz/20091018/sysrq-l.txt
> wget http://home.comcast.net/~jpiszcz/20091018/sysrq-m.txt
> wget http://home.comcast.net/~jpiszcz/20091018/sysrq-p.txt
> wget http://home.comcast.net/~jpiszcz/20091018/sysrq-q.txt
> wget http://home.comcast.net/~jpiszcz/20091018/sysrq-t.txt
> wget http://home.comcast.net/~jpiszcz/20091018/sysrq-w.txt
.....
> Again, some more D-state processes:
>
> [76325.608073] pdflush       D 0000000000000001     0   362      2 0x00000000
> [76325.608087] Call Trace:
> [76325.608095]  [<ffffffff811ea1c0>] ? xfs_trans_brelse+0x30/0x130
> [76325.608099]  [<ffffffff811dc44c>] ? xlog_state_sync+0x26c/0x2a0
> [76325.608103]  [<ffffffff810513e0>] ? default_wake_function+0x0/0x10
> [76325.608106]  [<ffffffff811dc4d1>] ? _xfs_log_force+0x51/0x80
> [76325.608108]  [<ffffffff811dc50b>] ? xfs_log_force+0xb/0x40
>
> [76325.608202] xfssyncd      D 0000000000000000     0   831      2 0x00000000
> [76325.608214] Call Trace:
> [76325.608216]  [<ffffffff811dc229>] ? xlog_state_sync+0x49/0x2a0
> [76325.608220]  [<ffffffff811d3485>] ? __xfs_iunpin_wait+0x95/0xe0
> [76325.608222]  [<ffffffff81069c20>] ? autoremove_wake_function+0x0/0x30
> [76325.608225]  [<ffffffff811d566d>] ? xfs_iflush+0xdd/0x2f0
> [76325.608228]  [<ffffffff811fbe28>] ? xfs_reclaim_inode+0x148/0x190
> [76325.608231]  [<ffffffff811fbe70>] ? xfs_reclaim_inode_now+0x0/0xa0
> [76325.608233]  [<ffffffff811fc8dc>] ? xfs_inode_ag_walk+0x6c/0xc0
> [76325.608236]  [<ffffffff811fbe70>] ? xfs_reclaim_inode_now+0x0/0xa0
>
> All of the D-state processes:

All pointing to log IO not completing.

That is, all of the D state processes are backed up on locks or
waiting for IO completion processing. A lot of the processes are
waiting for _xfs_log_force to complete, others are waiting for
inodes to be unpinned or are backed up behind locked inodes that are
waiting on log IO to complete before they can complete the
transaction and unlock the inode, and so on.

Unfortunately, the xfslogd and xfsdatad kernel threads are not
present in any of the output given, so I can't tell if these have
deadlocked themselves and caused the problem. However, my experience
with such pile-ups is that an I/O completion has not been run for
some reason and that is the cause of the problem. I don't know if
you can provide enough information to tell us if this happened or
not. Instead, do you have a test case that you can share?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
