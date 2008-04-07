Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 06 Apr 2008 19:18:08 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m372Hu2j018978
	for <xfs@oss.sgi.com>; Sun, 6 Apr 2008 19:17:59 -0700
Date: Mon, 7 Apr 2008 12:18:22 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: free space problem
Message-ID: <20080407021822.GZ108924158@sgi.com>
References: <20080401003518.GK103491721@sgi.com> <20080406160953.D47CF944596@cuda.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080406160953.D47CF944596@cuda.sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: =?iso-8859-1?Q?Husz=E1r_Viktor_D=E9nes?= <hvd@dwo.hu>
Cc: 'David Chinner' <dgc@sgi.com>, 'Emmanuel Florac' <eflorac@intellique.com>, xfs@oss.sgi.com

On Sun, Apr 06, 2008 at 06:09:39PM +0200, Huszár Viktor Dénes wrote:
> Hi guys, the earlier problem came out again:
> 
> Here are the logs:
> 
> [root]~# df -h
> Filesystem            Size  Used Avail Use% Mounted on
> /dev/md0               42G   15G   26G  37% /
> tmpfs                 7.9G     0  7.9G   0% /lib/init/rw
> udev                   10M   76K   10M   1% /dev
> tmpfs                 7.9G  2.2M  7.9G   1% /dev/shm
> /dev/md1              420G   31G  389G   8% /var/www/users
> /dev/mapper/a-a        17T   17T   51G 100% /var/www/users/sms

So you effectively have a full filesystem. Inode allocation
may be impossible as the filesystem approaches full as there
is not enough contiguous free space to allocate them in.

Also, you are probably using the inode32 allocator (i.e. no inode64
mount option), which means inodes can only be placed in the first
1TB of the filesystem, and that means those AGs are probably out of
space.

Given that you have 523GB AGs, that means inode will probably only be
put in AG 0, ad that's probably out of space. What does:

# xfs_db -r -c 'freesp -s -a 0' /dev/mapper/a-a

give you?

FWIW, This problem will come and go as you unlink files and change
the pattern of freespace...

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
