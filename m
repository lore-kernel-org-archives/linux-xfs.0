Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 03 Aug 2006 07:13:56 -0700 (PDT)
Received: from sandeen.net (sandeen.net [209.173.210.139])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k73EDgDW021718
	for <xfs@oss.sgi.com>; Thu, 3 Aug 2006 07:13:42 -0700
Message-ID: <44D20473.3010304@sandeen.net>
Date: Thu, 03 Aug 2006 09:13:07 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: "xfs_io -c chattr +i " on a symlink
References: <28749.62.159.242.114.1154600816.squirrel@otto.lonx.net>
In-Reply-To: <28749.62.159.242.114.1154600816.squirrel@otto.lonx.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Dan Am <xfs@lonx.net>
Cc: xfs@oss.sgi.com

Dan Am wrote:
> (resend, since I used the wrong account to send the initial mail, sorry)
> 
> Dear list,
> 
> I am trying to make a symlink immutable with chattr, however the command
> seems to follow the link, which point to a NFS Mount.
> Setting xattr works on symlink btw, which is useful.
> More data below
> Any ideas ?
> 
> Best Regards
> Dan
> 
> Heres the situation from my machine's view:
> /data > ls -l bin
> lrwxrwxrwx  1 root root 48 Aug  2 15:53 bin -> /archive/l01abnfs07/bin
> 
> /data> xfs_io  -c "chattr +i" bin
> xfs_io: specified file ["bin"] is not on an XFS filesystem
> 
> ~ > xfs_io -V
> xfs_io version 2.8.4

Try just using chattr.

[sandeen@sandeen ~]$ ln -s /tmp tmplink
[sandeen@sandeen ~]$ ls -l tmplink
lrwxrwxrwx  1 sandeen sandeen 4 Aug  3 09:05 tmplink -> /tmp
[sandeen@sandeen ~]$ su
Password:
[root@sandeen sandeen]# chattr +i tmplink
[root@sandeen sandeen]# stat -f tmplink
   File: "tmplink"
     ID: 802      Namelen: 255     Type: XFS (0x58465342)
Blocks: Total: 23377204   Free: 8557099    Available: 8557099    Size: 4096
Inodes: Total: 93554496   Free: 93202008
[root@sandeen sandeen]#
[root@sandeen sandeen]# lsattr tmplink
----i-------- tmplink

xfs_io also has an option to try to do operations even on non-xfs filesystems, 
if that helps... if it follows the link & sets the attr on the link target, that 
may not be behaving as expected though.

-Eric
