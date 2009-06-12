Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n5C9SI9W198394 for <xfs@oss.sgi.com>; Fri, 12 Jun 2009 04:28:19 -0500
Received: from enyo.dsw2k3.info (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 1B3D31AC21F7
	for <xfs@oss.sgi.com>; Fri, 12 Jun 2009 02:28:40 -0700 (PDT)
Received: from enyo.dsw2k3.info (enyo.dsw2k3.info [195.71.86.239]) by
	cuda.sgi.com with ESMTP id iJlmZBh36RcAh73b for
	<xfs@oss.sgi.com>; Fri, 12 Jun 2009 02:28:40 -0700 (PDT)
Date: Fri, 12 Jun 2009 11:28:25 +0200
From: Matthias Schniedermeyer <ms@citd.de>
Subject: Re: grub no longer being maintained? so Suse drops support for XFS
	boot?
Message-ID: <20090612092825.GA16974@citd.de>
References: <4A31E0FF.8050400@tlinx.org>
	<921ca19c0906112227m2c834808jd62b15d0203fe4e3@mail.gmail.com>
	<4A31F7FC.2020508@tlinx.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4A31F7FC.2020508@tlinx.org>
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
To: Linda Walsh <suse@tlinx.org>
Cc: Sujit Karataparambil <sjt.kar@gmail.com>, SuSE Linux <opensuse@opensuse.org>, xfs-oss <xfs@oss.sgi.com>

On 11.06.2009 23:38, Linda Walsh wrote:
>
> Re: "Grub supposedly unable to start if /boot is on xfs partition,
>    So, because grub is broken, XFS is no longer supported as    a boot 
> partition by Novell/SuSE. (!)...

The report below says that grub can't WRITE to XFS.
Supposedly the 'default'-file. Don't know what else GRUB may want to write.
Which, depending on preference, is superfluous anyway.

So if you switch that off (don't know how, never used it myself) all 
should be fine.

OTOH as long as you can live with a separate boot-partition, what's the 
problem of formating it with ext2. fsck-times for a single/double-digit 
MB boot-partition are negligible.

I've been using XFS for anything but boot-partitions for years.
IMHO GRUB is more important than free choice of boot-partition 
filesystem. At least until GRUB2 is finished, whenever that happens.

> Sujit Karataparambil wrote:
>> This is an Known Issue. Grub hangs when used With XFS. You could
>> Try Lilo instead. But does the same with my experiance.
> ---
> 	Weird.  I've been booting from xfs with lilo, and more
> recently, 'grub', from suse 7.x up to 11.1.  
>
> 	I haven't any recent probs concerning lilo, but I saw this same type of 
> issue and a solution in Ubuntu's bug database (though they
> encountered this problem 3 years ago and automatically used a
> workaround to not corrupt a user's choice of filesystem.
>
> The issue was Grub not being able to write to the root directory
> if it is formatted as an XFS partition.  
>
> The response was Ubuntu's workaround (maybe openSuSE could figure out
> how they did this...it is open source...and they could adopt their
> solution rather than just throwing up their hands and saying they
> don't support XFS).
>
> The Ubuntu installer automatically uses lilo in the case where the
> root (or boot) file system is XFS.  Thus no ever sees the problem grub 
> has with XFS, they simply use the more primitive, but more reliable 
> 'lilo' bootloader.
>
> It's a bit weird to see some people at SuSE prefer to work around
> a bootloader bug by disallowing user-desired file systems, rather than
> by simply using a bootloader that doesn't have the bug.  I would have 
> thought that most people would have simply chosen to Not use a buggy 
> boot-loader and use a more reliable alternative, over
> disallowing file-systems that are unsupported by the buggy-boot loader.
>
> Some folks at Suse must have a real 'thing' for 'grub' to rate it's
> importance more highly than users' file system choices...
>
> But I would really suggest that OpenSuse follow Ubuntu's example -- just 
> use a bootloader that works.  Don't limit file-system selection based on 
> the bugs of a bootloader (same would be true if lilo didn't
> work with some filesystem and grub did...use the combinations that
> work -- to rigidly disallow anything that grub suggests someone needs
> to re-examine their priorities.
>
> FWIW, though, I _am_ using grub, with XFS...but if grub broke, I'd  
> switch back to lilo in a heartbeat, NOT reformat my boot or root
> partition to accommodate the bootloader's bugs de jour.
>
> -linda
>
>
>
>
> 	
>
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

-- 




Bis denn

-- 
Real Programmers consider "what you see is what you get" to be just as 
bad a concept in Text Editors as it is in women. No, the Real Programmer
wants a "you asked for it, you got it" text editor -- complicated, 
cryptic, powerful, unforgiving, dangerous.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
