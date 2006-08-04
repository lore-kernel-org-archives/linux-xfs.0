Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 03 Aug 2006 17:31:18 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id k740UdDW012082
	for <xfs@oss.sgi.com>; Thu, 3 Aug 2006 17:30:51 -0700
Date: Fri, 4 Aug 2006 10:29:50 +1000
From: Nathan Scott <nathans@sgi.com>
Subject: Re: "xfs_io -c chattr +i " on a symlink
Message-ID: <20060804102949.B2401829@wobbly.melbourne.sgi.com>
References: <28749.62.159.242.114.1154600816.squirrel@otto.lonx.net> <44D20473.3010304@sandeen.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <44D20473.3010304@sandeen.net>; from sandeen@sandeen.net on Thu, Aug 03, 2006 at 09:13:07AM -0500
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Dan Am <xfs@lonx.net>, xfs@oss.sgi.com

On Thu, Aug 03, 2006 at 09:13:07AM -0500, Eric Sandeen wrote:
> Try just using chattr.

Or not. :)

> [sandeen@sandeen ~]$ ln -s /tmp tmplink
> [sandeen@sandeen ~]$ ls -l tmplink
> lrwxrwxrwx  1 sandeen sandeen 4 Aug  3 09:05 tmplink -> /tmp
> [sandeen@sandeen ~]$ su
> Password:
> [root@sandeen sandeen]# chattr +i tmplink
> [root@sandeen sandeen]# stat -f tmplink
>    File: "tmplink"
>      ID: 802      Namelen: 255     Type: XFS (0x58465342)
> Blocks: Total: 23377204   Free: 8557099    Available: 8557099    Size: 4096
> Inodes: Total: 93554496   Free: 93202008
> [root@sandeen sandeen]#
> [root@sandeen sandeen]# lsattr tmplink
> ----i-------- tmplink

... I think you just set immutable on /tmp.  Try a broken symlink,
instead of one that points to an existing inode.

cheers.

-- 
Nathan
