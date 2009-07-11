Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n6B0ZeHV131070 for <xfs@oss.sgi.com>; Fri, 10 Jul 2009 19:35:40 -0500
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5354B1BD3ECA
	for <xfs@oss.sgi.com>; Fri, 10 Jul 2009 17:36:15 -0700 (PDT)
Received: from mail.sandeen.net (sandeen.net [209.173.210.139]) by
	cuda.sgi.com with ESMTP id IypZbwfgL1lFwh4Z for
	<xfs@oss.sgi.com>; Fri, 10 Jul 2009 17:36:15 -0700 (PDT)
Message-ID: <4A57DE7E.8080901@sandeen.net>
Date: Fri, 10 Jul 2009 19:36:14 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: xfs_repair stops on "traversing filesystem..."
References: <4A55FAF7.5040908@gmail.com>	<4A56D176.9010702@sandeen.net>	<4A56ED5F.10400@gmail.com>	<4A57A1C4.40004@sandeen.net>
	<4A57AC69.7070502@gmail.com>	<4A57AF5D.6080603@sandeen.net>
	<4A57D252.4020804@gmail.com>
In-Reply-To: <4A57D252.4020804@gmail.com>
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
To: Tomek Kruszona <bloodyscarion@gmail.com>
Cc: xfs@oss.sgi.com

Tomek Kruszona wrote:

...

> I made some tests and it seems, that filesystem to finish xfs_repair
> needs to be repaired with bhash=1024... With default options it still
> hangs on "traversing filesystem..." Is it possible to change this
> behavior to normal in other way than reformat? 

It has nothing to do w/ the format, it's just internal to xfs_repair
while it's running, the way it caches blocks that it has recently used.

> Moreover I spotted some
> strange thing. 16GB of data has been moved to lost+found. I tried to

Yeah ...

> clean L+F by
> # rm -rf lost+found
> 
> but suddenly I got this:
> 
> # ls -l /mnt/storage/
> ls: cannot access /mnt/storage/lost+found: No such file or directory
> total 0
> drwxr-xr-x 4 root    root 33 Mar  4 17:21 l_mirror
> ?????????? ? ?       ?     ?            ? lost+found

huh.  let me try on the repaired metadata image...

[root@bear-05 bad-repair]# mount -o loop badfs.img mnt/
[root@bear-05 bad-repair]# du -hc mnt/lost+found/
26M	mnt/lost+found/1602304
5.0M	mnt/lost+found/2558868
18G	mnt/lost+found/
18G	total
[root@bear-05 bad-repair]# rm -rf mnt/lost+found/*
[root@bear-05 bad-repair]# ls -l mnt/
total 0
drwxr-xr-x 4 root root 33 Mar  4 10:21 ??5?t??4
drwxr-xr-x 0 root root  6 Jul 10 19:48 lost+found
drwxr-xr-x 2 1000 root  6 Jun 30 08:45 tests

Did you do something else to the fs in between?

> I had to run xfs_repair (bhash=1024) once again and then l+f disappeared...
> 
> So I started to think: does it have some influence on data that are
> stored on this filesystem? I'm afraid that files on this FS may become
> inconsistent :/

Well, I don't know what has gone wrong with your filesytem (or, with the
storage beneath it, or whatever) - but it is certainly possible that
with corrupted metadata, that there is corrupted data as well - all
depends on the root cause ...

-Eric

> Best regards,
> Tomasz Kruszona

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
