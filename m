Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	nAL100Kw223087 for <xfs@oss.sgi.com>; Fri, 20 Nov 2009 19:00:01 -0600
Received: from mail.gmx.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with SMTP id B36EC9C4C0
	for <xfs@oss.sgi.com>; Fri, 20 Nov 2009 17:00:24 -0800 (PST)
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20]) by cuda.sgi.com
	with SMTP id S41eJGnmD0ghtZbt for <xfs@oss.sgi.com>;
	Fri, 20 Nov 2009 17:00:24 -0800 (PST)
From: Juergen Urban <JuergenUrban@gmx.de>
Subject: Re: BUG() in end_page_writeback(),
	stack overflows and system speed decrease with XFS over USB
Date: Sat, 21 Nov 2009 02:00:12 +0100
References: <200911190957.45957.JuergenUrban@gmx.de>
	<4B06C58F.5070203@sandeen.net> <4B06CCFC.8030309@sandeen.net>
In-Reply-To: <4B06CCFC.8030309@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200911210200.13438.JuergenUrban@gmx.de>
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
To: xfs@oss.sgi.com

On Friday 20 November 2009 18:08:12 Eric Sandeen wrote:
> Eric Sandeen wrote:
> > Juergen Urban wrote:
> >> On Thursday 19 November 2009 19:00:16 Eric Sandeen wrote:
> >>> Juergen Urban wrote:
> >>>> Hello,
> >>>>
> >>>> my machine is running very unstable since I use XFS on an external USB
> >>>> harddisc (855 GByte XFS partition on 1TByte). One problem was the
> >>>> stack overflows caused by the large stack use of XFS, USB, SCSI and
> >>>> VFS in Linux 2.6.23.13. NFS on XFS caused much more stack overflows. I
> >>>> think I got around the stack overflows by disabling preemption, SMP
> >>>> and NFS in Linux, but I am not sure about it. I think that I didn't
> >>>> got a message from the stack overflow detection after this.
> >>>
> >>> Are you on 4k stacks?  To be honest I'd still expect things to be
> >>> mostly ok stack-wise even if so.
> >>
> >> No, I am using 8k stacks.
> >
> > Hmm.
>
> BTW if you are still seeing stack overflows when testing w/ the newer
> kernel, we can use some tracing to see what the stack backtrace is:
>
> sysctl -w kernel.stack_tracer_enabled=1
> mount -t debugfs none /sys/kernel/debug/
>
> and then look in:
>
> /sys/kernel/debug/tracing/stack_trace
> /sys/kernel/debug/tracing/stack_max_size
>

I don't think that I still get stack overflows in Linux 2.6.23.13.

Now I downloaded the new KNOPPIX with Linux 2.6.31.6. I've got also crashes 
with it, but this also could be a stack overflow, because the kernel 
configuration includes SMP and preemption. The problem here is that I don't see 
any kernel message. I just see the blinking keyboard or sometimes even 
nothing. To get the error I just need to play video with mplayer and don't 
need to write to the file system at all. I need to wait until I've got a good 
backtrace, but this will be with Linux 2.6.23.13.
The console tools of my installed Debian can't configure or use /dev/tty[0-9]* 
of Linux 2.6.31.6. The ioctls are not supported. I installed a newer version 
of the package, but this doesn't help. I copied the ".config" from Linux 
2.6.23.13 to 2.6.31.6. Maybe this is not compatible.


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
