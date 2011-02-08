Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p1859V32094247 for <xfs@oss.sgi.com>; Mon, 7 Feb 2011 23:09:32 -0600
Received: from mailout3.samsung.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A0AF412358CA
	for <xfs@oss.sgi.com>; Mon,  7 Feb 2011 21:12:03 -0800 (PST)
Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33]) by
	cuda.sgi.com with ESMTP id UwkokWB83VZaDDCI for
	<xfs@oss.sgi.com>; Mon, 07 Feb 2011 21:12:03 -0800 (PST)
Received: from epmmp2 (mailout3.samsung.com [203.254.224.33])
	by mailout3.samsung.com
	(Oracle Communications Messaging Exchange Server 7u4-19.01 64bit (built
	Sep 7
	2010)) with ESMTP id <0LGA00F5Y942NS80@mailout3.samsung.com> for
	xfs@oss.sgi.com; Tue, 08 Feb 2011 14:12:02 +0900 (KST)
Received: from unisistPC ([165.213.110.204])
	by mmp2.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
	2004))
	with ESMTPA id <0LGA003FS9428X@mmp2.samsung.com> for xfs@oss.sgi.com;
	Tue, 08 Feb 2011 14:12:02 +0900 (KST)
Date: Tue, 08 Feb 2011 14:12:01 +0900
From: Ryan Roh <unisist.roh@samsung.com>
Subject: RE: segmentation fault during mount
In-reply-to: <4D50CA45.8070807@sandeen.net>
Message-id: <030701cbc74e$b7f25680$27d70380$@samsung.com>
MIME-version: 1.0
Content-language: en-us
References: <02b401cbc6b6$5b7ac0b0$12704210$@samsung.com>
	<4D50CA45.8070807@sandeen.net>
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
To: 'Eric Sandeen' <sandeen@sandeen.net>
Cc: xfs@oss.sgi.com

Dear Eric,

I don't know how I can make correct form to answer for this thread because
I'm newbie here. Sorry.

Anyway, this issue was happened from returned HDD from customer which was
used our PVR STB. And our STB has toggle power switch so I think user turned
off the power during recording something.

Thanks,
Ryan.
  

-----Original Message-----
From: Eric Sandeen [mailto:sandeen@sandeen.net] 
Sent: Tuesday, February 08, 2011 1:45 PM
To: Ryan Roh
Cc: xfs@oss.sgi.com
Subject: Re: segmentation fault during mount

On 2/7/11 5:01 AM, Ryan Roh wrote:
> Dear Members,
> 
> I'm using XFS based on STMicro SH4 based chip (STi7105).
> 
> and I have some issue on xfs log mounting.
> 

Were the errors after any sort of harsh testing of the filesystem, such as
usb disconnects or power off?

Or was this after a clean unmount?

-Eric

> 
> 1. chip : sh4 STi7105
> 
> 2. HDD : 320GB USB HDD USB 2.0 port.
> 
> 3. OS : Linux 2.6.23.17 + patch for fixing cache aliasing issue.
> 
> 4. XFSProgs version : 3.1.1
> 
>  
> 
> mounting and repairing log in the below. This segmentation fault is 
> caused by
> 
> the assert in xfs_alloc_increment function of xfs_alloc_btree.c file. 
> The btree
> 
> level is equal to root level in the below code.
> 
>  
> 
>     /*
> 
>      * If we went off the root then we are seriously confused.
> 
>      */
> 
>     ASSERT(lev < cur->bc_nlevels);
> 
>  

...

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
