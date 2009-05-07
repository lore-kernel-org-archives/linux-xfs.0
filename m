Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n47NtjQ9237228 for <xfs@oss.sgi.com>; Thu, 7 May 2009 18:55:45 -0500
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 7EBA226F79A
	for <xfs@oss.sgi.com>; Thu,  7 May 2009 16:55:48 -0700 (PDT)
Received: from mail.sandeen.net (sandeen.net [209.173.210.139]) by
	cuda.sgi.com with ESMTP id lZC36DLyQ9ex4nil for
	<xfs@oss.sgi.com>; Thu, 07 May 2009 16:55:48 -0700 (PDT)
Message-ID: <4A037503.1070904@sandeen.net>
Date: Thu, 07 May 2009 18:55:47 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: 2.6.30-rc4: xfs_fsr hangs
References: <a4423d670905011333s664115bdh1d72392897567c1d@mail.gmail.com>
	<4A036FBC.9020201@sandeen.net>
In-Reply-To: <4A036FBC.9020201@sandeen.net>
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
To: Alexander Beregalov <a.beregalov@gmail.com>
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com

Eric Sandeen wrote:

> there are 2 subsequent unlocks for the same inode:
> 
> 1:
> xfs_iunlock: ip ca2304c0 ino 132  flags 0x5

...

> 2:
> xfs_iunlock: ip ca230980 ino 131  flags 0x5


Ugh no, those are 2 different inodes.... I can read, really.  :)  still,
looking into it.

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
