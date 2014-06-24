Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 02A367F67
	for <xfs@oss.sgi.com>; Tue, 24 Jun 2014 09:15:39 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id BFED28F804C
	for <xfs@oss.sgi.com>; Tue, 24 Jun 2014 07:15:35 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id q7Fdro1xiTgUDjLR for <xfs@oss.sgi.com>;
	Tue, 24 Jun 2014 07:15:33 -0700 (PDT)
Message-ID: <53A98805.1080106@sandeen.net>
Date: Tue, 24 Jun 2014 09:15:33 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: XFS Repair hangs at inode repair in phase3
References: <trinity-74fd845e-7f9d-4482-a8dd-4dd93421a033-1403614903299@3capp-gmx-bs44>
In-Reply-To: <trinity-74fd845e-7f9d-4482-a8dd-4dd93421a033-1403614903299@3capp-gmx-bs44>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dragon <Sunghost@gmx.de>, xfs@oss.sgi.com

On 6/24/14, 8:01 AM, Dragon wrote:
> 
> Hello,
> i have a fresh install Debian Wheezy with software raid as md2 for my
> files. MD2 is nealry full of 8TB and i wanted to migrate the data to
> a newier system. While copy files i got an message that i have to run
> xfs_repair. I first run xfs_check but it eats up all my 11GB memory
> and the system stalls.

Yep, xfs_check doesn't scale and is on the way to deprecation.

> Then i run xfs_repair -n /dev/md2 but it hangs
> each time add: problem with directory contens in inode 2147997719 -
> would have cleared inode 2147997719. If i break this and restart, it
> hangs at the same position. System seems to do nothing over hours.

You might try the -P option to repair.

-P Disable prefetching of inode and directory blocks. Use this option if you find xfs_repair gets stuck and stops proceeding.

If that works, it likely indicates a bug, but it might get you going.

>  
> Some Infos:
> xfsprogs in Version 3.1.7+b1

And that's a 3-year old xfsprogs, so an upgrade might help, too.

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
