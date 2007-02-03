Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sat, 03 Feb 2007 15:43:36 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l13NhNqw030805
	for <xfs@oss.sgi.com>; Sat, 3 Feb 2007 15:43:28 -0800
Date: Sun, 4 Feb 2007 10:42:21 +1100
From: David Chinner <dgc@sgi.com>
Subject: Re: bad magic and dubious inode
Message-ID: <20070203234221.GE44411608@melbourne.sgi.com>
References: <f0e429340702030959r7b8b815sb58c01238c19495e@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f0e429340702030959r7b8b815sb58c01238c19495e@mail.gmail.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: KE Liew <ke.liew@gmail.com>
Cc: xfs@oss.sgi.com

On Sat, Feb 03, 2007 at 06:59:29PM +0100, KE Liew wrote:
> Hello,
> 
> It's been a great day, and this is the situation. Files were being
> transfered from one hdd to another, SATA to IDE, and BANG and error
> occured, can't remember exactly what, but I had to umount it.

Can you look in your syslog for the forced shutdown messages?

> Successful, and ran xfs_check
> 
> ====================
> eXiStEnCe:~# xfs_check -s /dev/hdb
> bad magic # 0 in inobt block 15/916145
> ====================
> 
> Doesn't look good at all. I attempted the famous xfs_repair :)

You ran "xfs_repair -n" which means it didn't fix anything;
it just told you about errors it found.

> No modify flag set, skipping phase 5
> Inode allocation btrees are too corrupted, skipping phases 6 and 7
> No modify flag set, skipping filesystem flush and exiting.
> ====================
> 
> As you can see, it's almost dead?

No, it's not dead - xfs-repair should be able to fix the problem
if you let it.

> I haven't mount it yet, so I hope
> it's all safe and cool. What should be the next step for me to take?

run xfs_repair without the -n flag.

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
