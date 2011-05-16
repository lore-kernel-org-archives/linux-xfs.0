Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p4G3TFeb112949 for <xfs@oss.sgi.com>; Sun, 15 May 2011 22:29:15 -0500
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 920A61E29FD3
	for <xfs@oss.sgi.com>; Sun, 15 May 2011 20:29:14 -0700 (PDT)
Received: from mail.sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com
	with ESMTP id U6WLDL7apli3DgPY for <xfs@oss.sgi.com>;
	Sun, 15 May 2011 20:29:14 -0700 (PDT)
Message-ID: <4DD09A09.30807@sandeen.net>
Date: Sun, 15 May 2011 22:29:13 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: XFS_WANT_CORRUPTED_GOTO on repair of large myisam (mysql) table
References: <4DD097F9.6070205@zmcconsulting.com>
In-Reply-To: <4DD097F9.6070205@zmcconsulting.com>
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
To: "Matthew J. Probst" <mprobst@zmcconsulting.com>
Cc: xfs@oss.sgi.com

On 5/15/11 10:20 PM, Matthew J. Probst wrote:
> ##########################
> Software:
> ##########################
> xfs on lvm2 on dm-multipath
> 
> Kernel: 2.6.18-238.9.1.el5 (from RH/Centos 5.6)
> kmod-xfs version 0.4-2

Please try removing kmod-xfs; that is an extremely old xfs codebase.

the kernel above comes with xfs.ko already an is much more up to date.
When kmod-xfs is installed, it overrides  the one shipped with the kernel.

Hopefully you'll have better luck with the newer code.

-Eric

> xfsprogs version 2.9.4-1
> lvm2 version: 2.02.74-5
> device mapper multipath verson: 0.4.7-42
> Mysql version 5.1 56

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
