Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q0Q50gYE149076
	for <linux-xfs@oss.sgi.com>; Wed, 25 Jan 2012 23:00:45 -0600
Received: from lo.gmane.org (lo.gmane.org [80.91.229.12]) by cuda.sgi.com with
	ESMTP id USMcz96FEIahyj61 for <linux-xfs@oss.sgi.com>;
	Wed, 25 Jan 2012 21:00:40 -0800 (PST)
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <sgi-linux-xfs@m.gmane.org>) id 1RqHRu-0002c1-9V
	for linux-xfs@oss.sgi.com; Thu, 26 Jan 2012 06:00:38 +0100
Received: from wombat.san-francisco.ca.us ([75.101.60.64])
	by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
	id 1AlnuQ-0007hv-00
	for <linux-xfs@oss.sgi.com>; Thu, 26 Jan 2012 06:00:38 +0100
Received: from kkeller by wombat.san-francisco.ca.us with local (Gmexim 0.1
	(Debian)) id 1AlnuQ-0007hv-00
	for <linux-xfs@oss.sgi.com>; Thu, 26 Jan 2012 06:00:38 +0100
From: Keith Keller <kkeller@wombat.san-francisco.ca.us>
Subject: Re: help with deciphering kernel dmesg
Date: Wed, 25 Jan 2012 20:57:20 -0800
Message-ID: <g237v8xm99.ln2@goaway.wombat.san-francisco.ca.us>
References: <a9g4v8xkfp.ln2@goaway.wombat.san-francisco.ca.us>
	<20120125064225.GR15102@dastard>
Mime-Version: 1.0
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
To: linux-xfs@oss.sgi.com

On 2012-01-25, Dave Chinner <david@fromorbit.com> wrote:
>
> the xfs_info output would be really handy for determining what path
> through the directory code XFS was taking whenteh crash occurred.

No problem, here it is.  The device is an LVM volume.  Unfortunately
I've mounted and umounted the drive a few times since the reboot, so I
don't know how helpful this will actually be.  I can attempt to repeat
the symptoms then try an xfs_info before attempting anything else.  (I
ended up killing the xfs_repair -n to get this sooner, so I still do
not have any information from that.  So far it's on phase 4, which is
taking a very long time; I think the reshape is stealing IO cycles, 
which it's not really supposed to.  It hasn't reported any errors so
far.)

meta-data=/dev/XXXXXXXX isize=256    agcount=57, agsize=61034784 blks
         =                       sectsz=512   attr=0
data     =                       bsize=4096   blocks=3417949184, imaxpct=25
         =                       sunit=0      swidth=0 blks, unwritten=1
naming   =version 2              bsize=4096  
log      =internal               bsize=4096   blocks=32768, version=1
         =                       sectsz=512   sunit=0 blks, lazy-count=0
realtime =none                   extsz=4096   blocks=0, rtextents=0

> I'd be worried about those IO errors - i don't think that they were
> the cause of the oops, but it implies that the underlying device is
> bad in some way. That may have something to do with the reshape in
> progress which make me worry that the reshape is actually keeping
> your data safe....

Yes, that was my worry as well.  Fortunately this is a backup that can
be recreated, but I'd hate to lose my primary store then find out the
backup is hosed.

> As it is, the kernel crashed reading a directory buffer. It's hard
> to say what went wrong - can you take the kernel image and run:
>
> $ gdb <path/to/kernel>
> (gdb) l *(xfs_da_do_buf+0x43e)
>
> And post the output so we can see what line number in the code the
> crash occurred at? That might provide a bit more of a clue to what
> the problem is.

Does my kernel need debugging symbols compiled in?  Because my kernel
doesn't seem to want to cooperate with gdb:

# gdb /boot/vmlinuz-2.6.39-4.el5.elrepo 
GNU gdb (GDB) Red Hat Enterprise Linux (7.0.1-37.el5_7.1)
[snip]
This GDB was configured as "x86_64-redhat-linux-gnu".
For bug reporting instructions, please see:
<http://www.gnu.org/software/gdb/bugs/>...
"/boot/vmlinuz-2.6.39-4.el5.elrepo": not in executable format: File format not recognized
(gdb) l *(xfs_da_do_buf+0x43e)
No symbol table is loaded.  Use the "file" command.

My compiling skills are generally confined to ./configure;make;make
install, so I'm not sure where to go next.  If debugging is needed to be
compiled into the kernel, that may be problematic--it looks like ELrepo
doesn't provide the same kernel with debug options, so I'd have to build
one myself to get that.  (Wow, I haven't built a kernel in over five
years!)

--keith

-- 
kkeller@wombat.san-francisco.ca.us


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
