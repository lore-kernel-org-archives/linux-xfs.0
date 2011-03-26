Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with SMTP id
	p2QFV5l8058391 for <xfs@oss.sgi.com>; Sat, 26 Mar 2011 10:31:05 -0500
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with SMTP id B2BA537E641
	for <xfs@oss.sgi.com>; Sat, 26 Mar 2011 08:34:13 -0700 (PDT)
Received: from mail.sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com
	with SMTP id MoQ6GdrQamutUJfU for <xfs@oss.sgi.com>;
	Sat, 26 Mar 2011 08:34:13 -0700 (PDT)
Message-ID: <4D8E0774.1070200@sandeen.net>
Date: Sat, 26 Mar 2011 10:34:12 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: No space left on device on xfs filesystem with 7.7TB free
References: <AANLkTingRg24yJJ6Dk=KpDywtY9LrXL_jV0KWaCR-8KU@mail.gmail.com>
In-Reply-To: <AANLkTingRg24yJJ6Dk=KpDywtY9LrXL_jV0KWaCR-8KU@mail.gmail.com>
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
To: atyu30 atyu30 <ipostfix@gmail.com>
Cc: xfs@oss.sgi.com

On 3/26/11 8:41 AM, atyu30 atyu30 wrote:
> 
> 
> I'm running RedHat Linux Enterprise Server 5.2, on a 64-bit x86_64
> Linux  machine with kernel version 2.6.18-128.el5 smp.  I appear to
> have version 2.9.4 of xfsprogs.

Just as point of reference, if you're using the xfs-kmod, that is
extremely old, un-updated, and unsupported at this point.

> I have a 22TB xfs filesystem ,Yesterday, the hard disk is full, today
> released a 7.7T disk space.But still can not write to new file.

You have probably run out of 32-bit inode space on your 27T filesystem.

> software ambience:
> 
> [root@Production data5]# uname -a Linux Production 2.6.18-128.el5 #1
> SMP Wed Jan 21 10:41:14 EST 2009 x86_64 x86_64 x86_64 GNU/Linux
> 
> [root@Production data5]# rpm -qa | grep xfs 
> xfsprogs-2.9.4-1.el5.centos xorg-x11-xfs-1.0.2-4 kmod-xfs-0.4-2
>

that's X11, not the filesystem, for what it's worth :)

> 
> problem:
> 
> [root@Production data5]# df -h Filesystem            Size  Used Avail
> Use% Mounted on /dev/sda1              48G  6.7G   39G  15% / 
> /dev/sda2              81G  4.0G   73G   6% /opt /dev/sdb1
> 22T   15T  7.7T  65% /data2 tmpfs                 2.0G     0  2.0G
> 0% /dev/shm
> 
> [root@Production data5]# df -i Filesystem            Inodes   IUsed
> IFree IUse% Mounted on /dev/sda1            12812288  136847 12675441
> 2% / /dev/sda2            21867648    8440 21859208    1% /opt 
> /dev/sdb1            23429382016 4625792 23424756224    1% /data2 
> tmpfs                 504701       1  504700    1% /dev/shm
> 
> [root@Production data5]# touch test.log touch: cannot touch
> `test.log': No space left on device

If your applications can handle > 32-bit inode numbers, mount -o inode64
and see if you can create the new file.

hm, we should maybe printk in this case, it comes up often enough.

-Eric
> 
> 
> _______________________________________________ xfs mailing list 
> xfs@oss.sgi.com http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
