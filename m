Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id D17427F4E
	for <xfs@oss.sgi.com>; Tue, 24 Jun 2014 10:35:53 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 9CD18304089
	for <xfs@oss.sgi.com>; Tue, 24 Jun 2014 08:35:50 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id CJuHAO2Uy9m6axAk for <xfs@oss.sgi.com>;
	Tue, 24 Jun 2014 08:35:45 -0700 (PDT)
Message-ID: <53A99AD0.4000003@sandeen.net>
Date: Tue, 24 Jun 2014 10:35:44 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: XFS Repair hangs at inode repair in phase3
References: <trinity-64075195-5d6c-40f8-97ba-cc348261c69f-1403619853159@3capp-gmx-bs44>
In-Reply-To: <trinity-64075195-5d6c-40f8-97ba-cc348261c69f-1403619853159@3capp-gmx-bs44>
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

You can always try:

# git clone git://oss.sgi.com/xfs/cmds/xfsprogs.git
# cd xfsprogs
# git checkout v3.2.0
# make
# repair/xfs_repair -n /dev/md2

-Eric

On 6/24/14, 9:24 AM, Dragon wrote:
> Hello Eric,
> ok will never use xfs_check ;). Yes i saw option -P but i though if i
> desabled that test, i will never get fix those problems. The Version
> is from Debian Wheezy stable, so why it is such old, when it is that
> important :do not understand this from debianmaintainer...: So what
> could i do to use latest Version under Debian Wheezy? Normaly i use
> the package system.. Any risk to loos all my data? Where came the
> Problem from? If the version is such old, was the md2 created out of
> that, or are there only the tools in it?

> Thx
> 
> On 6/24/14, 8:01 AM, Dragon wrote:
> 
>     Hello, i have a fresh install Debian Wheezy with software raid as md2 for my files. MD2 is nealry full of 8TB and i wanted to migrate the data to a newier system. While copy files i got an message that i have to run xfs_repair. I first run xfs_check but it eats up all my 11GB memory and the system stalls.
> 
> Yep, xfs_check doesn't scale and is on the way to deprecation.
> 
>     Then i run xfs_repair -n /dev/md2 but it hangs each time add: problem with directory contens in inode 2147997719 - would have cleared inode 2147997719. If i break this and restart, it hangs at the same position. System seems to do nothing over hours.
> 
> You might try the -P option to repair. -P Disable prefetching of inode and directory blocks. Use this option if you find xfs_repair gets stuck and stops proceeding. If that works, it likely indicates a bug, but it might get you going.
> 
>     Some Infos: xfsprogs in Version 3.1.7+b1
> 
> And that's a 3-year old xfsprogs, so an upgrade might help, too. -Eric
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
