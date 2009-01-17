Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	n0HL6usq005619
	for <linux-xfs@oss.sgi.com>; Sat, 17 Jan 2009 15:07:01 -0600
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id DB09F98D5C
	for <linux-xfs@oss.sgi.com>; Sat, 17 Jan 2009 13:06:55 -0800 (PST)
Received: from mail.sandeen.net (sandeen.net [209.173.210.139]) by
	cuda.sgi.com with ESMTP id Cg1xSC47tHyzoLxl for
	<linux-xfs@oss.sgi.com>; Sat, 17 Jan 2009 13:06:55 -0800 (PST)
Message-ID: <4972484E.5030204@sandeen.net>
Date: Sat, 17 Jan 2009 15:06:22 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: kernel 2.6.28 XFS internal error xfs_da_do_buf(2) at line 2112
	of	file fs/xfs/xfs_da_btree.c
References: <1232225359.8845.198.camel@champagne.cantina>
In-Reply-To: <1232225359.8845.198.camel@champagne.cantina>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
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
To: Alessandro Bono <alessandro.bono@gmail.com>
Cc: linux-xfs <linux-xfs@oss.sgi.com>, linux-kernel <linux-kernel@vger.kernel.org>

Alessandro Bono wrote:
> Hi all
> 
> New kernel new problem
> rsync over ssh to a usb disk get this scary message
> 
> Jan 17 17:39:50 champagne kernel: [30342.675488] 00000000: e8 1f 67 a1
> 7f 9c 65 fc c7 e9 c7 3f e1 d7 17 a7  ..g...e....?....
> Jan 17 17:39:50 champagne kernel: [30342.675504] Filesystem "sdb1": XFS
> internal error xfs_da_do_buf(2) at line 2112 of file
> fs/xfs/xfs_da_btree.c.  Caller 0xffffffffa0196e9f

This means that it read metadata with a bad magic number (the message
could be clearer).

Any storage errors in dmesg prior to this?

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
