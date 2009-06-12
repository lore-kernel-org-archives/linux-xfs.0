Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n5C6cm14192870 for <xfs@oss.sgi.com>; Fri, 12 Jun 2009 01:38:48 -0500
Received: from Ishtar.tlinx.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id EF31B1275C0F
	for <xfs@oss.sgi.com>; Thu, 11 Jun 2009 23:46:29 -0700 (PDT)
Received: from Ishtar.tlinx.org (ishtar.tlinx.org [64.81.245.74]) by
	cuda.sgi.com with ESMTP id Iw1fQ1obDAnRv1SO for
	<xfs@oss.sgi.com>; Thu, 11 Jun 2009 23:46:29 -0700 (PDT)
Message-ID: <4A31F7FC.2020508@tlinx.org>
Date: Thu, 11 Jun 2009 23:38:52 -0700
From: Linda Walsh <suse@tlinx.org>
MIME-Version: 1.0
Subject: Re: grub no longer being maintained? so Suse drops support for XFS
	boot?
References: <4A31E0FF.8050400@tlinx.org>
	<921ca19c0906112227m2c834808jd62b15d0203fe4e3@mail.gmail.com>
In-Reply-To: <921ca19c0906112227m2c834808jd62b15d0203fe4e3@mail.gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: SuSE Linux <opensuse@opensuse.org>
Cc: Sujit Karataparambil <sjt.kar@gmail.com>, xfs-oss <xfs@oss.sgi.com>


Re: "Grub supposedly unable to start if /boot is on xfs partition,
    So, because grub is broken, XFS is no longer supported as 
    a boot partition by Novell/SuSE. (!)...

Sujit Karataparambil wrote:
> This is an Known Issue. Grub hangs when used With XFS. You could
> Try Lilo instead. But does the same with my experiance.
---
	Weird.  I've been booting from xfs with lilo, and more
recently, 'grub', from suse 7.x up to 11.1.  

	I haven't any recent probs concerning lilo, but I saw this 
same type of issue and a solution in Ubuntu's bug database (though they
encountered this problem 3 years ago and automatically used a
workaround to not corrupt a user's choice of filesystem.

The issue was Grub not being able to write to the root directory
if it is formatted as an XFS partition.  

The response was Ubuntu's workaround (maybe openSuSE could figure out
how they did this...it is open source...and they could adopt their
solution rather than just throwing up their hands and saying they
don't support XFS).

The Ubuntu installer automatically uses lilo in the case where the
root (or boot) file system is XFS.  Thus no ever sees the problem 
grub has with XFS, they simply use the more primitive, but more 
reliable 'lilo' bootloader.

It's a bit weird to see some people at SuSE prefer to work around
a bootloader bug by disallowing user-desired file systems, rather than
by simply using a bootloader that doesn't have the bug.  
I would have thought that most people would have simply chosen to 
Not use a buggy boot-loader and use a more reliable alternative, over
disallowing file-systems that are unsupported by the buggy-boot loader.

Some folks at Suse must have a real 'thing' for 'grub' to rate it's
importance more highly than users' file system choices...

But I would really suggest that OpenSuse follow Ubuntu's example -- 
just use a bootloader that works.  Don't limit file-system selection 
based on the bugs of a bootloader (same would be true if lilo didn't
work with some filesystem and grub did...use the combinations that
work -- to rigidly disallow anything that grub suggests someone needs
to re-examine their priorities.

FWIW, though, I _am_ using grub, with XFS...but if grub broke, I'd 
switch back to lilo in a heartbeat, NOT reformat my boot or root
partition to accommodate the bootloader's bugs de jour.
 
-linda




	

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
