Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n6N4J1wM029083 for <xfs@oss.sgi.com>; Wed, 22 Jul 2009 23:19:02 -0500
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C81FBAC8E0D
	for <xfs@oss.sgi.com>; Wed, 22 Jul 2009 21:28:00 -0700 (PDT)
Received: from mail.sandeen.net (sandeen.net [209.173.210.139]) by
	cuda.sgi.com with ESMTP id FE5qMthxeHCT0W1i for
	<xfs@oss.sgi.com>; Wed, 22 Jul 2009 21:28:00 -0700 (PDT)
Message-ID: <4A67E4DE.1050904@sandeen.net>
Date: Wed, 22 Jul 2009 23:19:42 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: XFS: file system too large to be mounted on this system. 2.6.30.1
References: <1248313295.4730.2.camel@oxygen.netxsys.com>
In-Reply-To: <1248313295.4730.2.camel@oxygen.netxsys.com>
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
To: Krzysztof Adamski <k@adamski.org>
Cc: xfs@oss.sgi.com

Krzysztof Adamski wrote:
> I got "XFS: file system too large to be mounted on this system." when
> mounting my not to large file system.
> 
> I'm running Debian lenny with a self compiled kernel, 32 bit userland
> distribution.
> 
> I have both 32 and 64 bit kernels of the 2.6.30.1 installed. I was
> running the 64bit kernel for a while, I needed to switch to the 32 bit
> version to run VBox. After reboot to 32bit kernel, one filesystem would
> not mount. The xfs_repair did not find any good superblocks.
> Fortunately booting the 64bit kernel allowed mounting of this
> filesystem.
> This is a df while running 64bit kernel:
> /dev/mapper/big--raid-file--store
>                xfs   2558652416 2540114040  18538376 100% /file-store
> /dev/sda1      xfs   195263012 194723636    539376 100% /disks/a1
> 
> The interesting part is that /disks/a1 did not have problem with
> mounting on the 32bit kernel, just the /file-store.


Do you have CONFIG_LBD (or maye now CONFIG_LBDAF) set on the newer
32-bit kernel?  You'll need that.

If you do ....

file-store is about 2T?  What is the filesystem block size?  (xfs_info
on the mountpoint would tell you)

The test is looking at whether the nr of filesystem blocks overflows
based on CONFIG_LBD or not...

and the function hasn't changed since 2007.... hrm.

I'll put my money on CONFIG_LBDAF.

-Eric

> When running 2.6.28.4 32bit kernel I have no problem with mounting this
> filesystem. So something broke between 2.6.28.4 and 2.6.30.1
> 
> I can provide any other info.
> 
> K
> 
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
