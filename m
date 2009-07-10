Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n6ANhoca129709 for <xfs@oss.sgi.com>; Fri, 10 Jul 2009 18:43:50 -0500
Received: from mail-bw0-f214.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 50ED3358FE4
	for <xfs@oss.sgi.com>; Fri, 10 Jul 2009 16:44:26 -0700 (PDT)
Received: from mail-bw0-f214.google.com (mail-bw0-f214.google.com
	[209.85.218.214]) by cuda.sgi.com with ESMTP id
	VEBRbDWklSqBMRGQ for <xfs@oss.sgi.com>;
	Fri, 10 Jul 2009 16:44:26 -0700 (PDT)
Received: by bwz10 with SMTP id 10so997206bwz.20
	for <xfs@oss.sgi.com>; Fri, 10 Jul 2009 16:44:25 -0700 (PDT)
Message-ID: <4A57D252.4020804@gmail.com>
Date: Sat, 11 Jul 2009 01:44:18 +0200
From: Tomek Kruszona <bloodyscarion@gmail.com>
MIME-Version: 1.0
Subject: Re: xfs_repair stops on "traversing filesystem..."
References: <4A55FAF7.5040908@gmail.com>
	<4A56D176.9010702@sandeen.net>	<4A56ED5F.10400@gmail.com>
	<4A57A1C4.40004@sandeen.net> <4A57AC69.7070502@gmail.com>
	<4A57AF5D.6080603@sandeen.net>
In-Reply-To: <4A57AF5D.6080603@sandeen.net>
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

Eric Sandeen wrote:
> These are all good questions ;)  TBH I'm kind of digging through repair
> in earnest for the first time.  I'm not certain why it got into this
> state, whether there is some underlying bug, perhaps leaving things
> wrongly referenced, or just a plain ol' mis-sizing of the caches.
> 
> I have a patch now that ends like this; if all else fails at least it'd
> not spin forever, and give a hint of what to try.
> 
> -Eric
> 
> ...
> 
> Phase 6 - check inode connectivity...
>         - resetting contents of realtime bitmap and summary inodes
>         - traversing filesystem ...
> unknown magic number 0 for block 8388608 in directory inode 40541
> rebuilding directory inode 40541
> unknown magic number 0 for block 8388608 in directory inode 48934
> rebuilding directory inode 48934
> unknown magic number 0 for block 8388608 in directory inode 56139
> rebuilding directory inode 56139
> unknown magic number 0 for block 8388608 in directory inode 63785
> rebuilding directory inode 63785
> Unable to free any items in cache for new node; exiting.
> Try increasing the bhash and/or ihash size beyond 64
> cache: 0x190ed4d0
> Max supported entries = 512
> Max utilized entries = 512
> Active entries = 512
> Hash table size = 64
> Hits = 130779
> Misses = 271155
> Hit ratio = 32.54
[snip]

I made some tests and it seems, that filesystem to finish xfs_repair
needs to be repaired with bhash=1024... With default options it still
hangs on "traversing filesystem..." Is it possible to change this
behavior to normal in other way than reformat? Moreover I spotted some
strange thing. 16GB of data has been moved to lost+found. I tried to
clean L+F by
# rm -rf lost+found

but suddenly I got this:

# ls -l /mnt/storage/
ls: cannot access /mnt/storage/lost+found: No such file or directory
total 0
drwxr-xr-x 4 root    root 33 Mar  4 17:21 l_mirror
?????????? ? ?       ?     ?            ? lost+found

I had to run xfs_repair (bhash=1024) once again and then l+f disappeared...

So I started to think: does it have some influence on data that are
stored on this filesystem? I'm afraid that files on this FS may become
inconsistent :/

Best regards,
Tomasz Kruszona

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
